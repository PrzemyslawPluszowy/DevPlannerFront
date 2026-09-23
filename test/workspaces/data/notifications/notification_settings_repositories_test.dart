import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_notification_settings_repository_impl.dart';
import 'package:devplanner/workspaces/data/notifications/api/notifications_api.dart';
import 'package:devplanner/workspaces/data/notifications/models/notification_models.dart';
import 'package:devplanner/workspaces/data/notifications/repositories/notification_digest_repository_impl.dart';
import 'package:devplanner/workspaces/data/notifications/repositories/notification_preferences_repository_impl.dart';
import 'package:devplanner/workspaces/data/notifications/repositories/notification_reply_repository_impl.dart';
import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart'
    as transport_chat;
import 'package:devplanner/workspaces/data/shared/enums/notification_enums.dart'
    as transport_notification;
import 'package:devplanner/workspaces/domain/notifications/models/chat_notification_settings.dart';
import 'package:devplanner/workspaces/domain/notifications/models/notification_preferences.dart';
import 'package:devplanner/workspaces/domain/notifications/models/notification_reply_command.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockNotificationsApi extends Mock implements NotificationsApi {}

final class _MockChatApi extends Mock implements ChatApi {}

void main() {
  test('kontrakt preferencji rozmowy używa nazw enum backendu', () {
    final response = ChatNotificationPreferenceResponse.fromJson(
      const <String, dynamic>{
        'conversationId': 'conversation-1',
        'userId': 'user-1',
        'preference': 'All',
      },
    );

    expect(response.preference, transport_chat.ChatNotificationPreference.all);
    expect(response.toJson()['preference'], 'All');
    expect(
      const UpdateChatNotificationPreferencePayload(
        preference: transport_chat.ChatNotificationPreference.highOnly,
      ).toJson()['preference'],
      'HighOnly',
    );
  });

  test('kontrakt e-mail dekoduje i koduje wartości enum backendu', () {
    final digest = NotificationEmailCategoryPreference.fromJson(
      const <String, dynamic>{'emailMode': 'DailyDigest'},
    );
    final immediate = NotificationEmailCategoryPreference.fromJson(
      const <String, dynamic>{'emailMode': 'Immediate'},
    );

    expect(digest.emailMode.name, 'dailyDigest');
    expect(digest.toJson()['emailMode'], 'DailyDigest');
    expect(immediate.emailMode.name, 'immediate');
    expect(immediate.toJson()['emailMode'], 'Immediate');
    expect(
      NotificationEmailCategoryPreference.fromJson(
        const <String, dynamic>{'emailMode': 'Digest'},
      ).emailMode.name,
      'digest',
    );
    expect(
      const NotificationEmailCategoryPreference(
        emailMode: transport_notification.NotificationEmailDeliveryMode.digest,
      ).toJson()['emailMode'],
      'Digest',
    );
    expect(
      const UpdateNotificationDeliveryPreferencePayload(
        storage: transport_notification.NotificationEmailDeliveryMode.none,
      ).toJson()['storage'],
      'None',
    );
  });

  setUpAll(() {
    registerFallbackValue(const UpdateNotificationDeliveryPreferencePayload());
    registerFallbackValue(
      const UpdateStorageNotificationPreferencePayload(
        mode: transport_notification.StorageNotificationPreferenceMode.disabled,
      ),
    );
    registerFallbackValue(
      const NotificationReplyPayload(clientMessageId: 'fallback', text: 'x'),
    );
    registerFallbackValue(const UpdateChatUserNotificationPreferencePayload());
    registerFallbackValue(
      const UpdateChatNotificationPreferencePayload(
        preference: transport_chat.ChatNotificationPreference.all,
      ),
    );
  });

  group('NotificationPreferencesRepositoryImpl', () {
    test('mapuje globalne preferencje i nie wystawia DTO transportu', () async {
      final api = _MockNotificationsApi();
      when(api.getDeliveryPreferences).thenAnswer(
        (_) async => _NotificationFixtures.deliveryPreferences(),
      );
      final repository = NotificationPreferencesRepositoryImpl(api);

      final result = await repository.getDeliveryPreferences();
      final settings = result.getOrElse(
        () => throw StateError('Oczekiwano preferencji.'),
      );

      expect(settings.userId, 'user-1');
      expect(
        settings.modes[NotificationDeliveryCategory.chat],
        NotificationEmailDeliveryMode.dailyDigest,
      );
      expect(
        settings.modes[NotificationDeliveryCategory.storage],
        NotificationEmailDeliveryMode.none,
      );
    });

    test('serializuje częściową zmianę i mapuje preferencję Storage', () async {
      final api = _MockNotificationsApi();
      when(() => api.updateDeliveryPreferences(any())).thenAnswer(
        (_) async => _NotificationFixtures.deliveryPreferences(),
      );
      when(() => api.updateStoragePreference(any())).thenAnswer(
        (_) async => _NotificationFixtures.storagePreference(),
      );
      final repository = NotificationPreferencesRepositoryImpl(api);

      final delivery = await repository.updateDeliveryPreferences(
        const UpdateNotificationDeliveryPreferencesCommand(
          chat: NotificationEmailDeliveryMode.immediate,
          storage: NotificationEmailDeliveryMode.digest,
        ),
      );
      final storage = await repository.updateStoragePreference(
        StorageNotificationMode.mentionsOnly,
      );

      expect(delivery.isRight(), isTrue);
      expect(
        storage
            .getOrElse(() => throw StateError('Brak ustawienia Storage.'))
            .mode,
        StorageNotificationMode.mentionsOnly,
      );
      final deliveryPayload =
          verify(() => api.updateDeliveryPreferences(captureAny()))
                  .captured
                  .single
              as UpdateNotificationDeliveryPreferencePayload;
      expect(
        deliveryPayload.chat,
        transport_notification.NotificationEmailDeliveryMode.immediate,
      );
      expect(
        deliveryPayload.storage,
        transport_notification.NotificationEmailDeliveryMode.digest,
      );
      expect(deliveryPayload.task, isNull);
      final storagePayload =
          verify(() => api.updateStoragePreference(captureAny()))
                  .captured
                  .single
              as UpdateStorageNotificationPreferencePayload;
      expect(
        storagePayload.mode,
        transport_notification.StorageNotificationPreferenceMode.mentionsOnly,
      );
    });

    test('zachowuje 401 jako typowany błąd sesji', () async {
      final api = _MockNotificationsApi();
      when(api.getDeliveryPreferences).thenThrow(
        _NotificationFixtures.dioError(statusCode: 401),
      );
      final result = await NotificationPreferencesRepositoryImpl(
        api,
      ).getDeliveryPreferences();

      result.fold(
        (error) {
          expect(error.type, ApiErrorType.unauthorized);
          expect(error.statusCode, 401);
        },
        (_) => fail('Oczekiwano błędu 401.'),
      );
    });
  });

  group('NotificationDigestRepositoryImpl', () {
    test('mapuje snapshot digestu do stabilnych modeli domenowych', () async {
      final api = _MockNotificationsApi();
      when(
        () => api.digest(limit: 12),
      ).thenAnswer((_) async => _NotificationFixtures.digest());
      final result = await NotificationDigestRepositoryImpl(
        api,
      ).getDigest(limit: 12);
      final digest = result.getOrElse(
        () => throw StateError('Oczekiwano digestu.'),
      );

      expect(digest.groups.single.groupKey, 'chat:conversation-1');
      expect(digest.groups.single.latest.deepLink, '/chat/conversation-1');
      verify(() => api.digest(limit: 12)).called(1);
    });
  });

  group('NotificationReplyRepositoryImpl', () {
    test('wysyła pełną intencję odpowiedzi i mapuje wiadomość Chat', () async {
      final api = _MockNotificationsApi();
      when(() => api.reply('notification-1', any())).thenAnswer(
        (_) async => _NotificationFixtures.chatMessage(),
      );
      final repository = NotificationReplyRepositoryImpl(api);

      final result = await repository.reply(
        const NotificationReplyCommand(
          notificationId: 'notification-1',
          clientMessageId: 'client-1',
          text: 'Dziękuję',
          deltaJson: '{"ops":[]}',
        ),
      );
      final message = result.getOrElse(
        () => throw StateError('Oczekiwano wiadomości Chat.'),
      );

      expect(message.conversationId, 'conversation-1');
      expect(message.attachments.single.storageFileId, 'file-1');
      final payload =
          verify(() => api.reply('notification-1', captureAny()))
                  .captured
                  .single
              as NotificationReplyPayload;
      expect(payload.clientMessageId, 'client-1');
      expect(payload.deltaJson, '{"ops":[]}');
    });

    test('zachowuje 403 przy odpowiedzi do niedostępnej rozmowy', () async {
      final api = _MockNotificationsApi();
      when(() => api.reply('notification-1', any())).thenThrow(
        _NotificationFixtures.dioError(statusCode: 403),
      );

      final result = await NotificationReplyRepositoryImpl(api).reply(
        const NotificationReplyCommand(
          notificationId: 'notification-1',
          clientMessageId: 'client-1',
          text: 'Dziękuję',
        ),
      );

      result.fold(
        (error) {
          expect(error.type, ApiErrorType.forbidden);
          expect(error.statusCode, 403);
        },
        (_) => fail('Oczekiwano błędu 403.'),
      );
    });
  });

  group('ChatNotificationSettingsRepositoryImpl', () {
    test('mapuje globalne kanały oraz politykę pojedynczej rozmowy', () async {
      final api = _MockChatApi();
      when(api.getUserNotificationPreferences).thenAnswer(
        (_) async => _NotificationFixtures.chatSettings(),
      );
      when(
        () => api.setNotificationPreference('conversation-1', any()),
      ).thenAnswer((_) async => _NotificationFixtures.conversationSetting());
      final repository = ChatNotificationSettingsRepositoryImpl(api);

      final global = await repository.getGlobalSettings();
      final conversation = await repository.updateConversationSetting(
        conversationId: 'conversation-1',
        mode: ChatConversationNotificationMode.highOnly,
      );

      expect(
        global
            .getOrElse(() => throw StateError('Brak ustawień Chat.'))
            .pushEnabled,
        isTrue,
      );
      expect(
        conversation
            .getOrElse(() => throw StateError('Brak ustawień rozmowy.'))
            .mode,
        ChatConversationNotificationMode.highOnly,
      );
      final payload =
          verify(
                () => api.setNotificationPreference(
                  'conversation-1',
                  captureAny(),
                ),
              ).captured.single
              as UpdateChatNotificationPreferencePayload;
      expect(
        payload.preference,
        transport_chat.ChatNotificationPreference.highOnly,
      );
    });
  });
}

abstract final class _NotificationFixtures {
  static NotificationDeliveryPreferenceResponse deliveryPreferences() =>
      NotificationDeliveryPreferenceResponse(
        userId: 'user-1',
        invitation: _email(
          transport_notification.NotificationEmailDeliveryMode.immediate,
        ),
        membership: _email(
          transport_notification.NotificationEmailDeliveryMode.immediate,
        ),
        workspace: _email(
          transport_notification.NotificationEmailDeliveryMode.digest,
        ),
        project: _email(
          transport_notification.NotificationEmailDeliveryMode.digest,
        ),
        task: _email(
          transport_notification.NotificationEmailDeliveryMode.immediate,
        ),
        comment: _email(
          transport_notification.NotificationEmailDeliveryMode.immediate,
        ),
        chat: _email(
          transport_notification.NotificationEmailDeliveryMode.dailyDigest,
        ),
        storage: _email(
          transport_notification.NotificationEmailDeliveryMode.none,
        ),
        system: _email(
          transport_notification.NotificationEmailDeliveryMode.immediate,
        ),
        updatedAtUtc: DateTime.utc(2026, 9, 15),
      );

  static NotificationEmailCategoryPreference _email(
    transport_notification.NotificationEmailDeliveryMode mode,
  ) => NotificationEmailCategoryPreference(emailMode: mode);

  static StorageNotificationPreferenceResponse storagePreference() =>
      StorageNotificationPreferenceResponse(
        userId: 'user-1',
        mode: transport_notification
            .StorageNotificationPreferenceMode
            .mentionsOnly,
        isDefault: false,
        updatedAtUtc: DateTime.utc(2026, 9, 15),
      );

  static NotificationDigestResponse digest() => NotificationDigestResponse(
    generatedAtUtc: DateTime.utc(2026, 9, 15, 12),
    groups: [
      NotificationGroupResponse(
        groupKey: 'chat:conversation-1',
        count: 3,
        unreadCount: 2,
        latest: notification(),
        notificationIds: const ['notification-1'],
        preview: 'Nowa wiadomość',
      ),
    ],
  );

  static WorkspaceNotificationResponse notification() =>
      WorkspaceNotificationResponse(
        id: 'notification-1',
        sourceModule: 'Chat',
        eventType: 'MessageCreated',
        entityType: 'Conversation',
        entityId: 'conversation-1',
        title: 'Nowa wiadomość',
        body: 'Treść wiadomości',
        deepLink: '/chat/conversation-1',
        eventId: 'event-1',
        contractVersion: 1,
        createdAtUtc: DateTime.utc(2026, 9, 15, 11),
        isPinned: false,
        category: transport_notification.NotificationCategory.chat,
        priority: transport_notification.NotificationPriority.normal,
      );

  static ChatMessageResponse chatMessage() => ChatMessageResponse(
    id: 'message-1',
    conversationId: 'conversation-1',
    authorUserId: 'user-1',
    clientMessageId: 'client-1',
    text: 'Dziękuję',
    payloadHash: 'hash-1',
    version: 1,
    createdAtUtc: DateTime.utc(2026, 9, 15, 11),
    isDeleted: false,
    attachments: [
      ChatAttachmentResponse(
        id: 'attachment-1',
        messageId: 'message-1',
        storageFileId: 'file-1',
        attachedByUserId: 'user-1',
        position: 0,
        createdAtUtc: DateTime.utc(2026, 9, 15, 11),
      ),
    ],
  );

  static ChatUserNotificationPreferenceResponse chatSettings() =>
      const ChatUserNotificationPreferenceResponse(
        userId: 'user-1',
        inAppEnabled: true,
        emailEnabled: false,
        pushEnabled: true,
        digestEnabled: true,
      );

  static ChatNotificationPreferenceResponse conversationSetting() =>
      const ChatNotificationPreferenceResponse(
        conversationId: 'conversation-1',
        userId: 'user-1',
        preference: transport_chat.ChatNotificationPreference.highOnly,
      );

  static DioException dioError({required int statusCode}) => DioException(
    requestOptions: RequestOptions(path: '/api/v1/notifications/test'),
    type: DioExceptionType.badResponse,
    response: Response<void>(
      requestOptions: RequestOptions(path: '/api/v1/notifications/test'),
      statusCode: statusCode,
    ),
  );
}
