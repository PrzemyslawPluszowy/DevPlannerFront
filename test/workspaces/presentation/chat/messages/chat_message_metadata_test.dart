import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/presentation/chat/messages/chat_message_metadata.dart';
import 'package:flutter_test/flutter_test.dart';

ChatMessage message({
  String id = 'message-1',
  String authorUserId = 'user-1',
  ChatMessageDeliveryState deliveryState = ChatMessageDeliveryState.sent,
  bool isDeleted = false,
  int deliveredToCount = 0,
  int readByCount = 0,
}) => ChatMessage(
  id: id,
  conversationId: 'conversation-1',
  authorUserId: authorUserId,
  clientMessageId: 'client-1',
  text: 'Treść',
  payloadHash: 'hash',
  version: 1,
  createdAtUtc: DateTime.utc(2026, 9, 22, 10, 5),
  isDeleted: isDeleted,
  deliveryState: deliveryState,
  deliveredToCount: deliveredToCount,
  readByCount: readByCount,
);

void main() {
  group('ChatMessageMetadata.timeLabel', () {
    test('formatuje godzinę lokalną z zerami wiodącymi', () {
      final label = ChatMessageMetadata.timeLabel(DateTime(2026, 9, 22, 9, 7));

      expect(label, '09:07');
    });
  });

  group('ChatMessageMetadata.statusFor', () {
    test('brak statusu dla cudzej wiadomości', () {
      expect(
        ChatMessageMetadata.statusFor(
          message: message(authorUserId: 'user-2'),
          isOwn: false,
        ),
        isNull,
      );
    });

    test('brak statusu dla usuniętej własnej wiadomości', () {
      expect(
        ChatMessageMetadata.statusFor(
          message: message(isDeleted: true),
          isOwn: true,
        ),
        isNull,
      );
    });

    test('wysyłanie nie proponuje ponowienia', () {
      final status = ChatMessageMetadata.statusFor(
        message: message(deliveryState: ChatMessageDeliveryState.sending),
        isOwn: true,
      );

      expect(status, isNotNull);
      expect(status!.kind, ChatMessageStatusKind.sending);
      expect(status.canRetry, isFalse);
    });

    test('porażka proponuje ponowienie', () {
      final status = ChatMessageMetadata.statusFor(
        message: message(deliveryState: ChatMessageDeliveryState.failed),
        isOwn: true,
      );

      expect(status!.kind, ChatMessageStatusKind.failed);
      expect(status.canRetry, isTrue);
    });

    test('potwierdzona wiadomość ma status wysłanej bez ponowienia', () {
      final status = ChatMessageMetadata.statusFor(
        message: message(),
        isOwn: true,
      );

      expect(status!.kind, ChatMessageStatusKind.sent);
      expect(status.canRetry, isFalse);
    });

    test('serwerowe dostarczenie wygrywa ze statusem wysłanej', () {
      final status = ChatMessageMetadata.statusFor(
        message: message(deliveredToCount: 2),
        isOwn: true,
      );

      expect(status!.kind, ChatMessageStatusKind.delivered);
      expect(status.count, 2);
    });

    test('odczyt wygrywa z dostarczeniem', () {
      final status = ChatMessageMetadata.statusFor(
        message: message(deliveredToCount: 3, readByCount: 1),
        isOwn: true,
      );

      expect(status!.kind, ChatMessageStatusKind.read);
      expect(
        status.count,
        1,
        reason: 'status pokazuje liczbę, którą potwierdził serwer',
      );
    });

    test('brak potwierdzeń nie udaje dostarczenia', () {
      final status = ChatMessageMetadata.statusFor(
        message: message(),
        isOwn: true,
      );

      expect(status!.kind, ChatMessageStatusKind.sent);
      expect(status.count, 0);
    });
  });
}
