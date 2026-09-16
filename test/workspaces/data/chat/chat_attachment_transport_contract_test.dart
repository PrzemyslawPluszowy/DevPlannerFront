import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/workspaces/data/chat/models/chat_models.dart';

void main() {
  test(
    'serializuje sesję oraz uporządkowane attachmentFileIds kontraktu Chat',
    () {
      final session = ChatTemporaryAttachmentSessionResponse(
        id: 'session-1',
        conversationId: 'conversation-1',
        expiresAtUtc: DateTime.utc(2026, 9, 14, 12),
      );
      const payload = SendChatMessagePayload(
        clientMessageId: 'client-1',
        text: 'Treść',
        attachmentFileIds: ['file-a', 'file-b'],
      );

      expect(session.toJson(), {
        'id': 'session-1',
        'conversationId': 'conversation-1',
        'expiresAtUtc': '2026-09-14T12:00:00.000Z',
      });
      expect(payload.toJson()['attachmentFileIds'], ['file-a', 'file-b']);
      expect(
        ChatTemporaryAttachmentSessionResponse.fromJson(session.toJson()),
        session,
      );
    },
  );

  test('odtwarza uporządkowane attachments w odpowiedzi wiadomości', () {
    final message = ChatMessageResponse.fromJson({
      'id': 'message-1',
      'conversationId': 'conversation-1',
      'authorCoreUserId': 'user-1',
      'clientMessageId': 'client-1',
      'text': 'Treść',
      'payloadHash': 'HASH',
      'version': 1,
      'createdAtUtc': '2026-09-14T12:00:00.000Z',
      'isDeleted': false,
      'attachments': [
        {
          'id': 'attachment-1',
          'messageId': 'message-1',
          'storageFileId': 'file-a',
          'attachedByCoreUserId': 'user-1',
          'position': 0,
          'createdAtUtc': '2026-09-14T12:00:00.000Z',
        },
      ],
    });

    expect(message.attachments!.single.storageFileId, 'file-a');
    expect(message.attachments!.single.position, 0);
  });
}
