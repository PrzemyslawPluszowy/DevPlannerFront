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
}

final class FakePort implements ChatAttachmentUploadPort {
  FakePort(this.statuses);
  final List<ChatAttachmentRemoteStatus> statuses;
  final cancelled = <(String, String)>[];
  Completer<ChatAttachmentUploadSession>? firstCreate;
  int creates = 0;
  int polls = 0;
  @override
  Future<ChatAttachmentUploadSession> createSession(
    String conversationId,
  ) async {
    creates++;
    if (creates == 1 && firstCreate != null) return firstCreate!.future;
    return ChatAttachmentUploadSession('session-$creates');
  }

  @override
  Future<ChatAttachmentTicket> createTicket({
    required String sessionId,
    required StorageUploadInput input,
  }) async => const ChatAttachmentTicket('file-1');
  @override
  Future<void> complete(String storageFileId) async {}
  @override
  Future<void> upload(
    ChatAttachmentTicket ticket,
    StorageUploadInput input,
  ) async {}
  @override
  Future<ChatAttachmentRemoteStatus> status(String storageFileId) async =>
      statuses[polls++ < statuses.length ? polls - 1 : statuses.length - 1];
  @override
  Future<void> cancelSession(String conversationId, String sessionId) async =>
      cancelled.add((conversationId, sessionId));
}
