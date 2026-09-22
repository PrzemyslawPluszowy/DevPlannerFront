import 'package:dartz/dartz.dart';
import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/shell/overlays/devplanner_global_panels_host.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_composer_draft.dart';
import 'package:devplanner/workspaces/domain/notifications/chat_notification_settings_repository.dart';
import 'package:devplanner/workspaces/domain/notifications/models/chat_notification_settings.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('host udostępnia panelom port ustawień powiadomień Chat', (
    tester,
  ) async {
    final settings = _FakeChatNotificationSettingsRepository();
    final router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: DevPlannerGlobalPanelsHost(
          navigation: DevPlannerNavigation(router),
          chat: DevPlannerGlobalChatComposition(
            repository: _FakeChatRepository(),
            userId: 'user-1',
            draftRepository: _FakeChatDraftRepository(),
            notificationSettingsRepository: settings,
          ),
          child: const SizedBox.shrink(),
        ),
      ),
    );

    final panelContext = tester.element(find.byType(DevPlannerPanelsScope));
    expect(
      Provider.of<ChatNotificationSettingsRepository>(
        panelContext,
        listen: false,
      ),
      same(settings),
      reason:
          'modal ustawień jest rootowy i musi znaleźć port w hoście, '
          'a nie w poddrzewie panelu',
    );
  });

  testWidgets('host bez kompozycji nie udostępnia portu ustawień', (
    tester,
  ) async {
    final router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (_, _) => const SizedBox.shrink(),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: DevPlannerGlobalPanelsHost(
          navigation: DevPlannerNavigation(router),
          child: const SizedBox.shrink(),
        ),
      ),
    );

    final panelContext = tester.element(find.byType(DevPlannerPanelsScope));
    expect(
      () => Provider.of<ChatNotificationSettingsRepository>(
        panelContext,
        listen: false,
      ),
      throwsA(isA<ProviderNotFoundException>()),
    );
  });
}

final class _FakeChatNotificationSettingsRepository
    implements ChatNotificationSettingsRepository {
  @override
  Future<Either<ApiError, ChatNotificationSettings>>
  getGlobalSettings() async => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatNotificationSettings>> updateGlobalSettings(
    UpdateChatNotificationSettingsCommand command,
  ) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatConversationNotificationSetting>>
  getConversationSetting(String conversationId) async =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatConversationNotificationSetting>>
  updateConversationSetting({
    required String conversationId,
    required ChatConversationNotificationMode mode,
  }) async => throw UnimplementedError();
}

final class _FakeChatRepository implements ChatRepository {
  @override
  Future<Either<ApiError, List<ChatConversationResponse>>>
  listConversations() async => throw UnimplementedError();

  @override
  Future<Either<ApiError, List<ChatMessageResponse>>> listMessages(
    String conversationId,
  ) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatMessageResponse>> sendMessage({
    required String conversationId,
    required String clientMessageId,
    required String text,
  }) async => throw UnimplementedError();
}

final class _FakeChatDraftRepository implements ChatDraftRepository {
  @override
  Future<ChatComposerDraft?> read({
    required String userId,
    required String conversationId,
  }) async => null;

  @override
  Future<void> save({
    required String userId,
    required String conversationId,
    required ChatComposerDraft draft,
  }) async {}

  @override
  Future<void> delete({
    required String userId,
    required String conversationId,
  }) async {}

  @override
  Future<void> deleteAllForUser({required String userId}) async {}
}
