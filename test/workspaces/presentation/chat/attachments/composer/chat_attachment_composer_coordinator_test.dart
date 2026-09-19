import 'dart:async';
import 'dart:typed_data';

import 'package:devplanner/workspaces/domain/chat/attachments/chat_attachments_export.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/composer/chat_attachment_composer_coordinator.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_queue_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  StorageUploadInput input(String id) => StorageUploadInput(
    name: '$id.txt',
    size: 1,
    bytes: Uint8List.fromList([1]),
  );

  test(
    'publishes ready attachment IDs to draft in original selection order',
    () async {
      final first = _FakeOwner('file-1', 'session-1');
      final second = _FakeOwner('file-2', 'session-2');
      final draft = _FakeDraft();
      final coordinator = _coordinator([first, second], draft);
      coordinator.selectInputs([input('first'), input('second')]);

      final preparing = coordinator.prepare('conversation');
      await Future<void>.delayed(Duration.zero);
      second.finish();
      await Future<void>.delayed(Duration.zero);
      first.finish();
      await preparing;

      expect(draft.attachmentIds, ['file-1', 'file-2']);
      expect(coordinator.state, isA<ChatAttachmentComposerCoordinatorReady>());
      await coordinator.close();
    },
  );

  test('confirmed send consumes matching sessions exactly once', () async {
    final first = _FakeOwner('file-1', 'session-1')..finish();
    final second = _FakeOwner('file-2', 'session-2')..finish();
    final draft = _FakeDraft();
    final coordinator = _coordinator([first, second], draft);
    coordinator.selectInputs([input('first'), input('second')]);
    await coordinator.prepare('conversation');

    coordinator.registerSubmittedMessage(
      clientMessageId: 'client-1',
      attachmentIds: const ['file-1', 'file-2'],
    );
    await coordinator.markConsumedAfterConfirmedSend(
      clientMessageId: 'client-1',
      confirmedAttachmentIds: const ['file-1', 'file-2'],
    );
    await coordinator.markConsumedAfterConfirmedSend(
      clientMessageId: 'client-1',
      confirmedAttachmentIds: const ['file-1', 'file-2'],
    );

    expect(first.consumedSessions, ['session-1']);
    expect(second.consumedSessions, ['session-2']);
    expect(draft.attachmentIds, isEmpty);
    await coordinator.close();
  });

  test(
    'send failure or retry preserves the ready draft IDs and sessions',
    () async {
      final first = _FakeOwner('file-1', 'session-1')..finish();
      final second = _FakeOwner('file-2', 'session-2')..finish();
      final draft = _FakeDraft();
      final coordinator = _coordinator([first, second], draft);
      coordinator.selectInputs([input('first'), input('second')]);
      await coordinator.prepare('conversation');

      coordinator.preserveForSendFailureOrRetry();

      expect(draft.attachmentIds, ['file-1', 'file-2']);
      expect(first.consumedSessions, isEmpty);
      expect(second.consumedSessions, isEmpty);
      expect(first.revokes, 0);
      expect(second.revokes, 0);
      await coordinator.close();
    },
  );

  test(
    'access revoke cancels sessions and clears draft attachment IDs',
    () async {
      final owner = _FakeOwner('file-1', 'session-1')..finish();
      final draft = _FakeDraft();
      final coordinator = _coordinator([owner], draft);
      coordinator.selectInputs([input('first')]);
      await coordinator.prepare('conversation');

      await coordinator.clearForAccessRevoked();

      expect(owner.revokes, 1);
      expect(draft.attachmentIds, isEmpty);
      expect(coordinator.state, isA<ChatAttachmentComposerCoordinatorIdle>());
      await coordinator.close();
    },
  );

  test('stale queue result cannot restore draft IDs after revoke', () async {
    final owner = _FakeOwner('file-1', 'session-1');
    final draft = _FakeDraft();
    final coordinator = _coordinator([owner], draft);
    coordinator.selectInputs([input('first')]);

    final preparing = coordinator.prepare('conversation');
    await Future<void>.delayed(Duration.zero);
    await coordinator.revoke();
    owner.finish();
    await preparing;

    expect(draft.attachmentIds, isEmpty);
    expect(coordinator.state, isA<ChatAttachmentComposerCoordinatorIdle>());
    await coordinator.close();
  });

  test(
    'awaiting A blocks B and requires the matching client confirmation',
    () async {
      final first = _FakeOwner('file-a', 'session-a')..finish();
      final draft = _FakeDraft();
      final coordinator = _coordinator([first], draft);
      coordinator.selectInputs([input('a')]);
      await coordinator.prepare('conversation');
      coordinator.registerSubmittedMessage(
        clientMessageId: 'client-a',
        attachmentIds: const ['file-a'],
      );

      coordinator.selectInputs([input('b')]);
      await coordinator.prepare('conversation');
      await coordinator.markConsumedAfterConfirmedSend(
        clientMessageId: 'client-b',
        confirmedAttachmentIds: const ['file-a'],
      );

      expect(first.revokes, 0);
      expect(first.consumedSessions, isEmpty);
      expect(
        coordinator.state,
        isA<ChatAttachmentComposerCoordinatorAwaitingConfirmation>(),
      );

      // Retry nie rejestruje nowej generacji i nadal oczekuje na ten sam UUID.
      coordinator.preserveForSendFailureOrRetry();
      await coordinator.markConsumedAfterConfirmedSend(
        clientMessageId: 'client-a',
        confirmedAttachmentIds: const ['file-a'],
      );

      expect(first.consumedSessions, ['session-a']);
      expect(draft.attachmentIds, isEmpty);
      await coordinator.close();
    },
  );
}

ChatAttachmentComposerCoordinatorCubit _coordinator(
  List<_FakeOwner> owners,
  _FakeDraft draft,
) => ChatAttachmentComposerCoordinatorCubit(
  selection: ChatAttachmentSelectionCubit(),
  uploadQueue: ChatAttachmentUploadQueueCubit(_FakeOwnerFactory(owners).call),
  updateDraftAttachmentIds: draft.updateAttachmentIds,
);

final class _FakeDraft {
  List<String> attachmentIds = const <String>[];

  void updateAttachmentIds(List<String> value) {
    attachmentIds = List.unmodifiable(value);
  }
}

final class _FakeOwnerFactory {
  _FakeOwnerFactory(this._owners);

  final List<_FakeOwner> _owners;
  var _index = 0;

  ChatAttachmentUploadOwner call() => _owners[_index++];
}

final class _FakeOwner implements ChatAttachmentUploadOwner {
  _FakeOwner(this.fileId, this.sessionId);

  final String fileId;
  final String sessionId;
  final Completer<void> _pending = Completer<void>();
  final List<String> consumedSessions = <String>[];
  int revokes = 0;
  ChatAttachmentPreparedFile? _prepared;

  void finish() {
    if (!_pending.isCompleted) _pending.complete();
  }

  @override
  ChatAttachmentPreparedFile? get preparedFile => _prepared;

  @override
  Future<void> start(String conversationId, StorageUploadInput input) async {
    await _pending.future;
    if (revokes == 0) {
      _prepared = ChatAttachmentPreparedFile(
        storageFileId: fileId,
        sessionId: sessionId,
      );
    }
  }

  @override
  void markConsumed(String sessionId) => consumedSessions.add(sessionId);

  @override
  Future<void> revoke() async {
    revokes++;
    finish();
  }

  @override
  Future<void> close() async {}
}
