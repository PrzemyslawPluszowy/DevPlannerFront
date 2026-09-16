import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:ready_next/workspaces/domain/notifications/models/chat_notification_settings.dart';
import 'package:ready_next/workspaces/presentation/chat/settings/chat_conversation_notification_settings_modal.dart';
import 'package:ready_next/workspaces/presentation/chat/settings/chat_global_notification_settings_section.dart';
import 'package:ready_next/workspaces/presentation/chat/settings/cubit/chat_conversation_notification_settings_cubit.dart';
import 'package:ready_next/workspaces/presentation/chat/settings/cubit/chat_global_notification_settings_cubit.dart';

class _FakeChatNotificationSettingsRepository
    implements ChatNotificationSettingsRepository {
  _FakeChatNotificationSettingsRepository({
    required this.globalResult,
    required this.conversationResult,
  });

  Either<ApiError, ChatNotificationSettings> globalResult;
  Either<ApiError, ChatConversationNotificationSetting> conversationResult;
  UpdateChatNotificationSettingsCommand? globalCommand;
  String? conversationId;
  ChatConversationNotificationMode? conversationMode;

  @override
  Future<Either<ApiError, ChatConversationNotificationSetting>>
  getConversationSetting(String conversationId) async => conversationResult;

  @override
  Future<Either<ApiError, ChatNotificationSettings>>
  getGlobalSettings() async => globalResult;

  @override
  Future<Either<ApiError, ChatConversationNotificationSetting>>
  updateConversationSetting({
    required String conversationId,
    required ChatConversationNotificationMode mode,
  }) async {
    this.conversationId = conversationId;
    conversationMode = mode;
    return conversationResult;
  }

  @override
  Future<Either<ApiError, ChatNotificationSettings>> updateGlobalSettings(
    UpdateChatNotificationSettingsCommand command,
  ) async {
    globalCommand = command;
    return globalResult;
  }
}

abstract final class _ChatNotificationSettingsFixture {
  static const global = ChatNotificationSettings(
    coreUserId: 'user-1',
    inAppEnabled: true,
    emailEnabled: true,
    pushEnabled: false,
    digestEnabled: false,
  );

  static const conversation = ChatConversationNotificationSetting(
    conversationId: 'conversation-1',
    coreUserId: 'user-1',
    mode: ChatConversationNotificationMode.all,
  );

  static const unauthorized = ApiError(
    type: ApiErrorType.unauthorized,
    message: 'Sesja wygasła.',
    statusCode: 401,
  );

  static const forbidden = ApiError(
    type: ApiErrorType.forbidden,
    message: 'Brak dostępu.',
    statusCode: 403,
  );
}

void main() {
  test(
    'global settings loads and maps an email toggle to a partial command',
    () async {
      final repository = _FakeChatNotificationSettingsRepository(
        globalResult: const Right(_ChatNotificationSettingsFixture.global),
        conversationResult: const Right(
          _ChatNotificationSettingsFixture.conversation,
        ),
      );
      final cubit = ChatGlobalNotificationSettingsCubit(repository);
      addTearDown(cubit.close);

      await cubit.load();
      final saved = await cubit.updateChannel(
        ChatNotificationChannel.email,
        false,
      );

      expect(saved, isTrue);
      expect(repository.globalCommand?.emailEnabled, isFalse);
      expect(repository.globalCommand?.inAppEnabled, isNull);
      expect(
        (cubit.state as ChatGlobalNotificationSettingsReady).settings,
        _ChatNotificationSettingsFixture.global,
      );
    },
  );

  test('global settings turns a 401 load into a revoked state', () async {
    final repository = _FakeChatNotificationSettingsRepository(
      globalResult: const Left(_ChatNotificationSettingsFixture.unauthorized),
      conversationResult: const Right(
        _ChatNotificationSettingsFixture.conversation,
      ),
    );
    final cubit = ChatGlobalNotificationSettingsCubit(repository);
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state, isA<ChatGlobalNotificationSettingsRevoked>());
  });

  test(
    'global settings does not restore a stale snapshot after a 403 save',
    () async {
      final repository = _FakeChatNotificationSettingsRepository(
        globalResult: const Right(_ChatNotificationSettingsFixture.global),
        conversationResult: const Right(
          _ChatNotificationSettingsFixture.conversation,
        ),
      );
      final cubit = ChatGlobalNotificationSettingsCubit(repository);
      addTearDown(cubit.close);
      await cubit.load();
      repository.globalResult = const Left(
        _ChatNotificationSettingsFixture.forbidden,
      );

      final saved = await cubit.updateChannel(
        ChatNotificationChannel.push,
        true,
      );

      expect(saved, isFalse);
      expect(cubit.state, isA<ChatGlobalNotificationSettingsRevoked>());
    },
  );

  test(
    'conversation settings saves its own mode and maps the conversation id',
    () async {
      final repository = _FakeChatNotificationSettingsRepository(
        globalResult: const Right(_ChatNotificationSettingsFixture.global),
        conversationResult: const Right(
          _ChatNotificationSettingsFixture.conversation,
        ),
      );
      final cubit = ChatConversationNotificationSettingsCubit(
        repository,
        'conversation-1',
      );
      addTearDown(cubit.close);
      await cubit.load();

      final saved = await cubit.updateMode(
        ChatConversationNotificationMode.mentionsOnly,
      );

      expect(saved, isTrue);
      expect(repository.conversationId, 'conversation-1');
      expect(
        repository.conversationMode,
        ChatConversationNotificationMode.mentionsOnly,
      );
    },
  );

  test('conversation settings turns a 403 save into a revoked state', () async {
    final repository = _FakeChatNotificationSettingsRepository(
      globalResult: const Right(_ChatNotificationSettingsFixture.global),
      conversationResult: const Right(
        _ChatNotificationSettingsFixture.conversation,
      ),
    );
    final cubit = ChatConversationNotificationSettingsCubit(
      repository,
      'conversation-1',
    );
    addTearDown(cubit.close);
    await cubit.load();
    repository.conversationResult = const Left(
      _ChatNotificationSettingsFixture.forbidden,
    );

    final saved = await cubit.updateMode(
      ChatConversationNotificationMode.muted,
    );

    expect(saved, isFalse);
    expect(cubit.state, isA<ChatConversationNotificationSettingsRevoked>());
  });

  testWidgets(
    'global section and conversation modal are reachable with root dialogs',
    (
      tester,
    ) async {
      final repository = _FakeChatNotificationSettingsRepository(
        globalResult: const Right(_ChatNotificationSettingsFixture.global),
        conversationResult: const Right(
          _ChatNotificationSettingsFixture.conversation,
        ),
      );
      final globalCubit = ChatGlobalNotificationSettingsCubit(repository);
      addTearDown(globalCubit.close);
      await globalCubit.load();

      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider<ChatNotificationSettingsRepository>.value(
              value: repository,
            ),
          ],
          child: BlocProvider.value(
            value: globalCubit,
            child: MaterialApp(
              locale: const Locale('pl'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Builder(
                builder: (context) => Scaffold(
                  body: Column(
                    children: [
                      const ChatGlobalNotificationSettingsSection(),
                      TextButton(
                        onPressed: () =>
                            ChatConversationNotificationSettingsModal.show(
                              context,
                              conversationId: 'conversation-1',
                            ),
                        child: const Text('open-conversation-settings'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Powiadomienia Chat'), findsOneWidget);
      await tester.tap(find.text('open-conversation-settings'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(find.text('Powiadomienia rozmowy'), findsOneWidget);
      expect(find.text('Wszystkie wiadomości'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
