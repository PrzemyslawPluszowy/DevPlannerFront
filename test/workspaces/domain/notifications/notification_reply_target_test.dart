import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/workspaces/domain/notifications/models/notification_reply_target.dart';

void main() {
  group('NotificationReplyTarget', () {
    test('dopuszcza ChatMessage bez klientskiej walidacji formatu ID', () {
      expect(
        NotificationReplyTarget.tryFromNotification(
          entityType: 'ChatMessage',
        ),
        isNotNull,
      );
    });

    test('dopuszcza metadane chatMessageId oraz messageId', () {
      for (final metadata in <String>[
        '{"chatMessageId":"message-from-chat"}',
        '{"messageId":"legacy-message"}',
      ]) {
        expect(
          NotificationReplyTarget.tryFromNotification(
            entityType: 'Task',
            metadataJson: metadata,
          ),
          isNotNull,
        );
      }
    });

    test('odrzuca inne powiadomienia, puste i błędne metadane', () {
      for (final metadata in <String?>[
        null,
        '',
        '{}',
        '{"messageId":"  "}',
        'not-json',
      ]) {
        expect(
          NotificationReplyTarget.tryFromNotification(
            entityType: 'Task',
            metadataJson: metadata,
          ),
          isNull,
        );
      }
    });
  });
}
