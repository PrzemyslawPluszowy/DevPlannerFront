import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_message.dart';
import 'package:devplanner/workspaces/domain/chat/links/chat_message_link.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('lokalne kopie dostawy i usunięcia zachowują linki serwera', () {
    const link = ChatMessageLink(
      url: 'https://example.com/',
      host: 'example.com',
      isHttps: true,
      isInternal: false,
      previewAllowed: true,
    );
    final message = ChatMessage(
      id: 'message-1',
      conversationId: 'conversation-1',
      authorUserId: 'user-1',
      clientMessageId: 'client-1',
      text: 'https://example.com',
      payloadHash: 'hash',
      version: 1,
      createdAtUtc: DateTime.utc(2026, 9, 22),
      isDeleted: false,
      deliveryState: ChatMessageDeliveryState.sending,
      links: const [link],
    );

    expect(
      message
          .copyWithDelivery(deliveryState: ChatMessageDeliveryState.sent)
          .links,
      const [link],
    );
    expect(message.copyWithDeletion(version: 2).links, const [link]);
  });
}
