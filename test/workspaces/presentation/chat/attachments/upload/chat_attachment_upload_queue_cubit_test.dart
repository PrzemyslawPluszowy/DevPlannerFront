import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/workspaces/domain/chat/attachments/chat_attachments_export.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:ready_next/workspaces/presentation/chat/attachments/selection/cubit/chat_attachment_selection_state.dart';
import 'package:ready_next/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_queue_cubit.dart';

void main() {
  ChatAttachment attachment(String id) => ChatAttachment(
    localId: id,
    input: StorageUploadInput(
      name: '$id.txt',
      size: 1,
      bytes: Uint8List.fromList([1]),
    ),
  );

  ChatAttachmentSelectionReady selection(List<ChatAttachment> attachments) =>
      ChatAttachmentSelectionReady(attachments: attachments);

  test(
    'publishes clean files in selection order when owners finish out of order',
    () async {
      final first = FakeOwner('file-1', 'session-1');
      final second = FakeOwner('file-2', 'session-2');
      final cubit = ChatAttachmentUploadQueueCubit(
        FakeOwnerFactory([
          first,
          second,
        ]).call,
      );

      final started = cubit.start(
        'conversation',
        selection([attachment('first'), attachment('second')]),
      );
      await Future<void>.delayed(Duration.zero);
      second.finish();
      await Future<void>.delayed(Duration.zero);
      first.finish();
      await started;

      final ready = cubit.state as ChatAttachmentUploadQueueReady;
      expect(ready.files.map((file) => file.storageFileId), [
        'file-1',
        'file-2',
      ]);
      await cubit.close();
    },
  );

  test('one failed owner revokes every active owner', () async {
    final failed = FakeOwner('file-1', 'session-1', fail: true);
    final pending = FakeOwner('file-2', 'session-2');
    final cubit = ChatAttachmentUploadQueueCubit(
      FakeOwnerFactory([
        failed,
        pending,
      ]).call,
    );

    await cubit.start(
      'conversation',
      selection([attachment('first'), attachment('second')]),
    );

    expect(cubit.state, isA<ChatAttachmentUploadQueueFailed>());
    expect(failed.revokes, 1);
    expect(pending.revokes, 1);
  });

  test(
    'revoke during polling suppresses ready output and cancels every owner',
    () async {
      final polling = FakeOwner('file-1', 'session-1');
      final cubit = ChatAttachmentUploadQueueCubit(
        FakeOwnerFactory([polling]).call,
      );

      final started = cubit.start(
        'conversation',
        selection([attachment('first')]),
      );
      await Future<void>.delayed(Duration.zero);
      await cubit.revoke();
      await started;

      expect(cubit.state, isA<ChatAttachmentUploadQueueIdle>());
      expect(polling.revokes, 1);
    },
  );

  test(
    'marks each ready session consumed exactly once after confirmed send',
    () async {
      final first = FakeOwner('file-1', 'session-1')..finish();
      final second = FakeOwner('file-2', 'session-2')..finish();
      final cubit = ChatAttachmentUploadQueueCubit(
        FakeOwnerFactory([
          first,
          second,
        ]).call,
      );
      await cubit.start(
        'conversation',
        selection([attachment('first'), attachment('second')]),
      );

      await cubit.markConsumedAfterConfirmedSend(['file-1', 'file-2']);
      await cubit.markConsumedAfterConfirmedSend(['file-1', 'file-2']);

      expect(first.consumedSessions, ['session-1']);
      expect(second.consumedSessions, ['session-2']);
      expect(first.revokes, 0);
      expect(second.revokes, 0);
    },
  );
}

final class FakeOwnerFactory {
  FakeOwnerFactory(this._owners);

  final List<FakeOwner> _owners;
  var _index = 0;

  ChatAttachmentUploadOwner call() => _owners[_index++];
}

final class FakeOwner implements ChatAttachmentUploadOwner {
  FakeOwner(this.fileId, this.sessionId, {this.fail = false});

  final String fileId;
  final String sessionId;
  final bool fail;
  final Completer<void> _polling = Completer<void>();
  final consumedSessions = <String>[];
  int revokes = 0;
  ChatAttachmentPreparedFile? _prepared;

  void finish() {
    if (!_polling.isCompleted) _polling.complete();
  }

  @override
  ChatAttachmentPreparedFile? get preparedFile => _prepared;

  @override
  Future<void> start(String conversationId, StorageUploadInput input) async {
    if (fail) return;
    await _polling.future;
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
