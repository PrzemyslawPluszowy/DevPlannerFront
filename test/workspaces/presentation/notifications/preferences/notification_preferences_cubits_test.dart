import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/notifications/models/notification_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/notification_enums.dart'
    show NotificationCategory, NotificationQuickActionKind;
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/models/chat_notification_settings.dart';
import 'package:devplanner/workspaces/domain/notifications/models/notification_digest.dart';
import 'package:devplanner/workspaces/domain/notifications/models/notification_preferences.dart';
import 'package:devplanner/workspaces/domain/notifications/notification_digest_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/notification_preferences_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/notifications_repository.dart';
import 'package:devplanner/workspaces/presentation/notifications/cubit/notifications_cubit.dart';
import 'package:devplanner/workspaces/presentation/notifications/global_notifications_page.dart';
import 'package:devplanner/workspaces/presentation/notifications/preferences/cubit/notification_delivery_preferences_cubit.dart';
import 'package:devplanner/workspaces/presentation/notifications/preferences/cubit/notification_digest_cubit.dart';
import 'package:devplanner/workspaces/presentation/notifications/preferences/cubit/storage_notification_preference_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeNotificationPreferencesRepository
    implements NotificationPreferencesRepository {
  _FakeNotificationPreferencesRepository({
    required this.deliveryResult,
    required this.storageResult,
  });

  Either<ApiError, NotificationDeliveryPreferences> deliveryResult;
  Either<ApiError, StorageNotificationPreference> storageResult;
  UpdateNotificationDeliveryPreferencesCommand? lastDeliveryCommand;
  StorageNotificationMode? lastStorageMode;

  @override
  Future<Either<ApiError, NotificationDeliveryPreferences>>
  getDeliveryPreferences() async => deliveryResult;

  @override
  Future<Either<ApiError, StorageNotificationPreference>>
  getStoragePreference() async => storageResult;

  @override
  Future<Either<ApiError, NotificationDeliveryPreferences>>
  updateDeliveryPreferences(
    UpdateNotificationDeliveryPreferencesCommand command,
  ) async {
    lastDeliveryCommand = command;
    return deliveryResult;
  }

  @override
  Future<Either<ApiError, StorageNotificationPreference>>
  updateStoragePreference(StorageNotificationMode mode) async {
    lastStorageMode = mode;
    return storageResult;
  }
}

class _FakeNotificationDigestRepository
    implements NotificationDigestRepository {
  _FakeNotificationDigestRepository(this.result);

  Either<ApiError, NotificationDigest> result;

  @override
  Future<Either<ApiError, NotificationDigest>> getDigest({int? limit}) async =>
      result;
}

class _FakeChatNotificationSettingsRepository
    implements ChatNotificationSettingsRepository {
  @override
  Future<Either<ApiError, ChatConversationNotificationSetting>>
  getConversationSetting(String conversationId) async => const Right(
    ChatConversationNotificationSetting(
      conversationId: 'conversation-1',
      userId: 'user-1',
      mode: ChatConversationNotificationMode.all,
    ),
  );

  @override
  Future<Either<ApiError, ChatNotificationSettings>>
  getGlobalSettings() async => const Right(
    ChatNotificationSettings(
      userId: 'user-1',
      inAppEnabled: true,
      emailEnabled: true,
      pushEnabled: false,
      digestEnabled: false,
    ),
  );

  @override
  Future<Either<ApiError, ChatConversationNotificationSetting>>
  updateConversationSetting({
    required String conversationId,
    required ChatConversationNotificationMode mode,
  }) async => Right(
    ChatConversationNotificationSetting(
      conversationId: conversationId,
      userId: 'user-1',
      mode: mode,
    ),
  );

  @override
  Future<Either<ApiError, ChatNotificationSettings>> updateGlobalSettings(
    UpdateChatNotificationSettingsCommand command,
  ) async => getGlobalSettings();
}

class _FakeNotificationsRepository implements NotificationsRepository {
  @override
  Future<Either<ApiError, void>> archiveGroup(String groupKey) async =>
      const Right(null);

  @override
  Future<Either<ApiError, CursorPageResponse<NotificationGroupResponse>>>
  listGroups({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  }) async => const Right(CursorPageResponse(items: []));

  @override
  Future<Either<ApiError, CursorPageResponse<WorkspaceNotificationResponse>>>
  listNotifications({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  }) async => const Right(CursorPageResponse(items: []));

  @override
  Future<Either<ApiError, void>> markAllRead() async => const Right(null);

  @override
  Future<Either<ApiError, void>> markGroupRead(String groupKey) async =>
      const Right(null);

  @override
  Future<Either<ApiError, void>> quickAction(
    String notificationId,
    NotificationQuickActionKind action,
  ) async => const Right(null);

  @override
  Future<Either<ApiError, int>> unreadCount() async => const Right(0);
}

abstract final class _NotificationPreferencesFixture {
  static final delivery = NotificationDeliveryPreferences(
    userId: 'user-1',
    modes: {
      for (final category in NotificationDeliveryCategory.values)
        category: NotificationEmailDeliveryMode.immediate,
    },
    updatedAtUtc: DateTime.utc(2026, 9, 15),
  );

  static const storage = StorageNotificationPreference(
    userId: 'user-1',
    mode: StorageNotificationMode.immediate,
    isDefault: false,
  );

  static final emptyDigest = NotificationDigest(
    generatedAtUtc: DateTime.utc(2026, 9, 15),
    groups: const [],
  );

  static const error = ApiError(
    type: ApiErrorType.connection,
    message: 'Offline.',
  );
}

void main() {
  test(
    'delivery preference load/save rolls back the exact snapshot on error',
    () async {
      final repository = _FakeNotificationPreferencesRepository(
        deliveryResult: Right(_NotificationPreferencesFixture.delivery),
        storageResult: const Right(_NotificationPreferencesFixture.storage),
      );
      final cubit = NotificationDeliveryPreferencesCubit(repository);
      addTearDown(cubit.close);

      await cubit.load();
      repository.deliveryResult = const Left(
        _NotificationPreferencesFixture.error,
      );

      final saved = await cubit.updateMode(
        NotificationDeliveryCategory.task,
        NotificationEmailDeliveryMode.none,
      );

      expect(saved, isFalse);
      expect(
        repository.lastDeliveryCommand?.task,
        NotificationEmailDeliveryMode.none,
      );
      final state = cubit.state as NotificationDeliveryPreferencesReady;
      expect(
        state.preferences,
        same(_NotificationPreferencesFixture.delivery),
      );
      expect(state.error, _NotificationPreferencesFixture.error);
    },
  );

  test(
    'storage preference load/save rolls back the exact snapshot on error',
    () async {
      final repository = _FakeNotificationPreferencesRepository(
        deliveryResult: Right(_NotificationPreferencesFixture.delivery),
        storageResult: const Right(_NotificationPreferencesFixture.storage),
      );
      final cubit = StorageNotificationPreferenceCubit(repository);
      addTearDown(cubit.close);

      await cubit.load();
      repository.storageResult = const Left(
        _NotificationPreferencesFixture.error,
      );

      final saved = await cubit.updateMode(StorageNotificationMode.disabled);

      expect(saved, isFalse);
      expect(repository.lastStorageMode, StorageNotificationMode.disabled);
      final state = cubit.state as StorageNotificationPreferenceReady;
      expect(state.preference, _NotificationPreferencesFixture.storage);
      expect(state.error, _NotificationPreferencesFixture.error);
    },
  );

  test(
    'digest distinguishes an empty successful snapshot from a failure',
    () async {
      final repository = _FakeNotificationDigestRepository(
        Right(_NotificationPreferencesFixture.emptyDigest),
      );
      final cubit = NotificationDigestCubit(repository);
      addTearDown(cubit.close);

      await cubit.load();
      expect(cubit.state, isA<NotificationDigestEmpty>());

      repository.result = const Left(_NotificationPreferencesFixture.error);
      await cubit.load();
      expect(cubit.state, isA<NotificationDigestFailure>());
      expect(
        (cubit.state as NotificationDigestFailure).error,
        _NotificationPreferencesFixture.error,
      );
    },
  );

  testWidgets('global inbox opens preferences through the root modal host', (
    tester,
  ) async {
    final notificationsRepository = _FakeNotificationsRepository();
    final notificationsCubit = NotificationsCubit(notificationsRepository);
    addTearDown(notificationsCubit.close);
    final preferencesRepository = _FakeNotificationPreferencesRepository(
      deliveryResult: Right(_NotificationPreferencesFixture.delivery),
      storageResult: const Right(_NotificationPreferencesFixture.storage),
    );
    final digestRepository = _FakeNotificationDigestRepository(
      Right(_NotificationPreferencesFixture.emptyDigest),
    );

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<NotificationPreferencesRepository>.value(
            value: preferencesRepository,
          ),
          RepositoryProvider<NotificationDigestRepository>.value(
            value: digestRepository,
          ),
          RepositoryProvider<ChatNotificationSettingsRepository>.value(
            value: _FakeChatNotificationSettingsRepository(),
          ),
        ],
        child: BlocProvider.value(
          value: notificationsCubit,
          child: const MaterialApp(
            locale: Locale('pl'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: GlobalNotificationsPage(),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Preferencje powiadomień'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Preferencje powiadomień'), findsOneWidget);
    expect(find.text('Podgląd digestu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('global inbox panel exposes the same preferences action', (
    tester,
  ) async {
    final notificationsRepository = _FakeNotificationsRepository();
    final notificationsCubit = NotificationsCubit(notificationsRepository);
    addTearDown(notificationsCubit.close);
    final preferencesRepository = _FakeNotificationPreferencesRepository(
      deliveryResult: Right(_NotificationPreferencesFixture.delivery),
      storageResult: const Right(_NotificationPreferencesFixture.storage),
    );
    final digestRepository = _FakeNotificationDigestRepository(
      Right(_NotificationPreferencesFixture.emptyDigest),
    );

    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<NotificationPreferencesRepository>.value(
            value: preferencesRepository,
          ),
          RepositoryProvider<NotificationDigestRepository>.value(
            value: digestRepository,
          ),
          RepositoryProvider<ChatNotificationSettingsRepository>.value(
            value: _FakeChatNotificationSettingsRepository(),
          ),
        ],
        child: BlocProvider.value(
          value: notificationsCubit,
          child: MaterialApp(
            locale: const Locale('pl'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: AppGlobalNotificationsPanel(
              repository: notificationsRepository,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Preferencje powiadomień'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Preferencje powiadomień'), findsOneWidget);
    expect(find.text('Podgląd digestu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
