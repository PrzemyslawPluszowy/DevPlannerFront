import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/models/chat_notification_settings.dart';
import 'package:devplanner/workspaces/presentation/chat/settings/cubit/chat_conversation_mute_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

/// Repozytorium ustawień rejestrujące zapisy polityki rozmowy.
final class _SettingsFake implements ChatNotificationSettingsRepository {
  _SettingsFake({this.mode = ChatConversationNotificationMode.all});

  ChatConversationNotificationMode mode;
  ApiError? saveFailure;
  final List<ChatConversationNotificationMode> saved =
      <ChatConversationNotificationMode>[];

  @override
  Future<Either<ApiError, ChatConversationNotificationSetting>>
  getConversationSetting(String conversationId) async => Right(
    ChatConversationNotificationSetting(
      conversationId: conversationId,
      userId: 'me',
      mode: mode,
    ),
  );

  @override
  Future<Either<ApiError, ChatConversationNotificationSetting>>
  updateConversationSetting({
    required String conversationId,
    required ChatConversationNotificationMode mode,
  }) async {
    saved.add(mode);
    final error = saveFailure;
    if (error != null) return Left(error);
    this.mode = mode;
    return Right(
      ChatConversationNotificationSetting(
        conversationId: conversationId,
        userId: 'me',
        mode: mode,
      ),
    );
  }

  @override
  Future<Either<ApiError, ChatNotificationSettings>>
  getGlobalSettings() async => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatNotificationSettings>> updateGlobalSettings(
    UpdateChatNotificationSettingsCommand command,
  ) async => throw UnimplementedError();
}

void main() {
  group('ChatConversationMuteCubit', () {
    test('odczytuje politykę rozmowy i wycisza ją realnym zapisem', () async {
      final repository = _SettingsFake();
      final cubit = ChatConversationMuteCubit(
        repository: repository,
        conversationId: 'conversation-1',
      );

      await cubit.load();
      expect(cubit.state.isMuted, isFalse);

      await cubit.toggleMute();

      expect(repository.saved, <ChatConversationNotificationMode>[
        ChatConversationNotificationMode.muted,
      ]);
      expect(cubit.state.isMuted, isTrue);
      expect(cubit.state.isBusy, isFalse);
      await cubit.close();
    });

    test('drugie przełączenie wyłącza wyciszenie', () async {
      final repository = _SettingsFake(
        mode: ChatConversationNotificationMode.muted,
      );
      final cubit = ChatConversationMuteCubit(
        repository: repository,
        conversationId: 'conversation-1',
      );
      await cubit.load();
      expect(cubit.state.isMuted, isTrue);

      await cubit.toggleMute();

      expect(repository.saved, <ChatConversationNotificationMode>[
        ChatConversationNotificationMode.all,
      ]);
      expect(cubit.state.isMuted, isFalse);
      await cubit.close();
    });

    test('porażka zapisu cofa przełącznik do stanu serwera', () async {
      final repository = _SettingsFake()
        ..saveFailure = const ApiError(
          type: ApiErrorType.forbidden,
          message: 'chat.forbidden',
          apiCode: 'chat.forbidden',
          statusCode: 403,
        );
      final cubit = ChatConversationMuteCubit(
        repository: repository,
        conversationId: 'conversation-1',
      );
      await cubit.load();

      await cubit.toggleMute();

      expect(
        cubit.state.isMuted,
        isFalse,
        reason:
            'przełącznik nie może zostać w pozycji, której serwer nie przyjął',
      );
      expect(cubit.state.failureCode, 'chat.forbidden');
      expect(cubit.state.isBusy, isFalse);
      await cubit.close();
    });
  });
}
