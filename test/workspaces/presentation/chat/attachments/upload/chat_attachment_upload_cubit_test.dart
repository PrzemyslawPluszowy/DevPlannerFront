import 'dart:async';
import 'dart:typed_data';

import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  StorageUploadInput input() => StorageUploadInput(
    name: 'a.txt',
    size: 1,
    bytes: Uint8List.fromList([1]),
  );

  test('happy and pending to clean retain session until consumed', () async {
    final port = FakePort([
      ChatAttachmentRemoteStatus.pending,
      ChatAttachmentRemoteStatus.cleanReady,
    ]);
    final cubit = ChatAttachmentUploadCubit(port, pollDelay: Duration.zero);
    await cubit.start('c', input());
    final ready = cubit.state as ChatAttachmentUploadReady;
    expect(ready.storageFileId, 'file-1');
    expect(ready.sessionId, 'session-1');
    await cubit.close();
    expect(port.cancelled, [('c', 'session-1')]);
  });

  test(
    'private Storage file is copied server-side without local upload',
    () async {
      final port = FakePort(const []);
      final cubit = ChatAttachmentUploadCubit(port, pollDelay: Duration.zero);
      await cubit.start(
        'conversation-1',
        const StorageUploadInput(
          name: 'specyfikacja.docx',
          size: 4096,
          mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
          sourceStorageFileId: 'private-file-9',
        ),
      );
      expect(cubit.state, isA<ChatAttachmentUploadReady>());
      expect(
        (cubit.state as ChatAttachmentUploadReady).storageFileId,
        'copied-private-file-9',
      );
      expect(port.copied, [('conversation-1', 'session-1', 'private-file-9')]);
      expect(port.uploads, 0);
      expect(port.polls, 0);
      await cubit.close();
    },
  );

  test('infected, failed and timeout cancel the session', () async {
    for (final statuses in [
      [ChatAttachmentRemoteStatus.infected],
      [ChatAttachmentRemoteStatus.failed],
      [ChatAttachmentRemoteStatus.pending],
    ]) {
      final port = FakePort(statuses);
      final cubit = ChatAttachmentUploadCubit(
        port,
        maxPolls: 1,
        pollDelay: Duration.zero,
      );
      await cubit.start('c', input());
      expect(cubit.state, isA<ChatAttachmentUploadFailed>());
      expect(port.cancelled, isNotEmpty);
    }
  });

  test('cancel, revoke and consumed lifecycle handle ready session', () async {
    final port = FakePort([ChatAttachmentRemoteStatus.cleanReady]);
    final cubit = ChatAttachmentUploadCubit(port, pollDelay: Duration.zero);
    await cubit.start('c', input());
    final ready = cubit.state as ChatAttachmentUploadReady;
    cubit.markConsumed(ready.sessionId);
    await cubit.cancel();
    expect(port.cancelled, isEmpty);
    await cubit.start('c', input());
    await cubit.revoke();
    expect(port.cancelled, isNotEmpty);
  });

  test(
    'stale delayed start cancels its created session and cannot emit ready',
    () async {
      final port = FakePort([ChatAttachmentRemoteStatus.cleanReady])
        ..firstCreate = Completer<ChatAttachmentUploadSession>();
      final cubit = ChatAttachmentUploadCubit(port, pollDelay: Duration.zero);
      final old = cubit.start('old', input());
      await Future<void>.delayed(Duration.zero);
      final current = cubit.start('new', input());
      port.firstCreate!.complete(const ChatAttachmentUploadSession('stale'));
      await Future.wait([old, current]);
      expect((cubit.state as ChatAttachmentUploadReady).sessionId, 'session-2');
      expect(port.cancelled, contains(('old', 'stale')));
    },
  );

  for (final stage in ['ticket', 'upload']) {
    test('closing during $stage prevents further upload and polling', () async {
      final port = FakePort([ChatAttachmentRemoteStatus.cleanReady]);
      if (stage == 'ticket') port.delayedTicket = Completer();
      if (stage == 'upload') port.delayedUpload = Completer();
      final cubit = ChatAttachmentUploadCubit(port, pollDelay: Duration.zero);
      final pending = cubit.start('conversation', input());
      await Future<void>.delayed(Duration.zero);
      await cubit.close();
      port.delayedTicket?.complete(const ChatAttachmentTicket('file-1'));
      port.delayedUpload?.complete();
      await pending;
      expect(port.completions, 0);
      expect(port.polls, 0);
      expect(port.cancelled, [('conversation', 'session-1')]);
      await cubit.start('after-close', input());
      expect(port.creates, 1);
    });
  }
}

final class FakePort implements ChatAttachmentUploadPort {
  FakePort(this.statuses);
  final List<ChatAttachmentRemoteStatus> statuses;
  final cancelled = <(String, String)>[];
  final copied = <(String, String, String)>[];
  int uploads = 0;
  Completer<ChatAttachmentUploadSession>? firstCreate;
  int creates = 0;
  int polls = 0;
  int completions = 0;
  Completer<ChatAttachmentTicket>? delayedTicket;
  Completer<void>? delayedUpload;
  @override
  Future<ChatAttachmentUploadSession> createSession(
    String conversationId,
  ) async {
    creates++;
    if (creates == 1 && firstCreate != null) return firstCreate!.future;
    return ChatAttachmentUploadSession('session-$creates');
  }

  @override
  Future<String> copyPrivateFileToSession({
    required String conversationId,
    required String sessionId,
    required String sourceStorageFileId,
  }) async {
    copied.add((conversationId, sessionId, sourceStorageFileId));
    return 'copied-$sourceStorageFileId';
  }

  @override
  Future<ChatAttachmentTicket> createTicket({
    required String sessionId,
    required StorageUploadInput input,
  }) async => delayedTicket != null
      ? delayedTicket!.future
      : const ChatAttachmentTicket('file-1');
  @override
  Future<void> complete(String storageFileId) async {
    completions++;
  }

  @override
  Future<void> upload(
    ChatAttachmentTicket ticket,
    StorageUploadInput input,
  ) async {
    uploads++;
    await delayedUpload?.future;
  }

  @override
  Future<ChatAttachmentRemoteStatus> status(String storageFileId) async =>
      statuses[polls++ < statuses.length ? polls - 1 : statuses.length - 1];
  @override
  Future<void> cancelSession(String conversationId, String sessionId) async =>
      cancelled.add((conversationId, sessionId));
}
