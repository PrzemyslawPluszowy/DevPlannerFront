import 'package:dartz/dartz.dart';
import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/shell/overlays/devplanner_global_panels_host.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_composer_draft.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_file_request.dart';
import 'package:devplanner/workspaces/domain/chat/resource/resource_chat_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/chat_repository.dart';
import 'package:devplanner/workspaces/presentation/chat/global_chat_composition.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

void main() {
  testWidgets('otwiera i zamyka globalny panel bez zmiany widoku pod spodem', (
    tester,
  ) async {
    final navigationRouter = GoRouter(
      routes: [GoRoute(path: '/', builder: (_, _) => const SizedBox.shrink())],
    );
    addTearDown(navigationRouter.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: DevPlannerGlobalPanelsHost(
          navigation: DevPlannerNavigation(navigationRouter),
          child: Builder(
            builder: (context) => Column(
              children: [
                TextButton(
                  onPressed: DevPlannerPanelsScope.controllerOf(
                    context,
                  )!.showChat,
                  child: const Text('Otwórz czat'),
                ),
                const Text('Edycja pod panelem'),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Otwórz czat'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('devplanner-chat-unavailable')),
      findsOneWidget,
    );
    expect(find.text('Edycja pod panelem'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('devplanner-chat-unavailable')),
      findsNothing,
    );
    expect(find.text('Edycja pod panelem'), findsOneWidget);
  });

  testWidgets('udostępnia resolver Resource Chat także aktywnej trasie', (
    tester,
  ) async {
    final navigationRouter = GoRouter(
      routes: [GoRoute(path: '/', builder: (_, _) => const SizedBox.shrink())],
    );
    addTearDown(navigationRouter.dispose);
    final repository = _ChatResourceRepository();
    await tester.pumpWidget(
      MaterialApp(
        home: DevPlannerGlobalPanelsHost(
          navigation: DevPlannerNavigation(navigationRouter),
          chat: DevPlannerGlobalChatComposition(
            repository: repository,
            userId: 'user-1',
            draftRepository: _DraftRepository(),
          ),
          child: Builder(
            builder: (context) => Text(
              context.read<ResourceChatRepository?>() == repository
                  ? 'resolver dostępny'
                  : 'brak resolvera',
            ),
          ),
        ),
      ),
    );

    expect(find.text('resolver dostępny'), findsOneWidget);
  });

  testWidgets(
    'renderuje listę rozmów w globalnym panelu bez zmiany widoku pod spodem',
    (tester) async {
      final navigationRouter = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, _) => const SizedBox.shrink()),
        ],
      );
      addTearDown(navigationRouter.dispose);
      await tester.pumpWidget(
        MaterialApp(
          supportedLocales: const [Locale('pl')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: DevPlannerGlobalPanelsHost(
            navigation: DevPlannerNavigation(navigationRouter),
            chat: DevPlannerGlobalChatComposition(
              repository: _ChatPanelRepository(),
              userId: 'user-1',
              draftRepository: _DraftRepository(),
              inboxRepository: _InboxRepository(),
            ),
            child: Builder(
              builder: (context) => Column(
                children: [
                  TextButton(
                    onPressed: DevPlannerPanelsScope.controllerOf(
                      context,
                    )!.showChat,
                    child: const Text('Otwórz działający czat'),
                  ),
                  const Text('Niezmieniony ekran zadania'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Otwórz działający czat'));
      await tester.pumpAndSettle();

      expect(find.text('Rozmowa projektu'), findsOneWidget);
      expect(find.text('Niezmieniony ekran zadania'), findsOneWidget);
      expect(
        find.byKey(const ValueKey('devplanner-chat-unavailable')),
        findsNothing,
      );

      await tester.tap(find.text('Rozmowa projektu'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Symbols.open_in_new_rounded), findsNothing);
      expect(find.text('Niezmieniony ekran zadania'), findsOneWidget);
    },
  );

  testWidgets(
    'pokazuje jawny błąd konfiguracji, gdy brakuje portu skrzynki',
    (tester) async {
      final navigationRouter = GoRouter(
        routes: [
          GoRoute(path: '/', builder: (_, _) => const SizedBox.shrink()),
        ],
      );
      addTearDown(navigationRouter.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: DevPlannerGlobalPanelsHost(
            navigation: DevPlannerNavigation(navigationRouter),
            chat: DevPlannerGlobalChatComposition(
              repository: _ChatPanelRepository(),
              userId: 'user-1',
              draftRepository: _DraftRepository(),
            ),
            child: Builder(
              builder: (context) => TextButton(
                onPressed: DevPlannerPanelsScope.controllerOf(context)!
                    .showChat,
                child: const Text('Otwórz czat bez skrzynki'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Otwórz czat bez skrzynki'));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('devplanner-chat-incomplete-composition')),
        findsOneWidget,
      );
      // Zastępcza lista bazowa nie może udawać nowego produktu.
      expect(find.text('Rozmowa projektu'), findsNothing);
    },
  );
}

final class _ChatResourceRepository
    implements ChatRepository, ResourceChatRepository {
  @override
  Future<Either<ApiError, List<ChatConversationResponse>>>
  listConversations() => throw UnimplementedError();

  @override
  Future<Either<ApiError, List<ChatMessageResponse>>> listMessages(
    String conversationId,
  ) => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatConversation>> resolveFileConversation(
    ResourceChatFileRequest request,
  ) => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatMessageResponse>> sendMessage({
    required String conversationId,
    required String clientMessageId,
    required String text,
  }) => throw UnimplementedError();
}

final class _DraftRepository implements ChatDraftRepository {
  @override
  Future<void> delete({
    required String userId,
    required String conversationId,
  }) async {}

  @override
  Future<ChatComposerDraft?> read({
    required String userId,
    required String conversationId,
  }) async => null;

  @override
  Future<void> deleteAllForUser({required String userId}) async {}

  @override
  Future<void> save({
    required String userId,
    required String conversationId,
    required ChatComposerDraft draft,
  }) async {}
}

final class _ChatPanelRepository implements ChatRepository {
  /// Historia i lista bazowa nie są już źródłem kolumny skrzynki.
  @override
  Future<Either<ApiError, List<ChatConversationResponse>>>
  listConversations() async => const Right(<ChatConversationResponse>[]);

  @override
  Future<Either<ApiError, List<ChatMessageResponse>>> listMessages(
    String conversationId,
  ) => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatMessageResponse>> sendMessage({
    required String conversationId,
    required String clientMessageId,
    required String text,
  }) => throw UnimplementedError();
}

final class _InboxRepository implements ChatInboxRepository {
  @override
  Future<Either<ApiError, ChatInboxPage>> loadInbox({
    ChatInboxFilter filter = ChatInboxFilter.all,
    String? cursor,
    int limit = 30,
    String? query,
  }) async => Right(
    ChatInboxPage(
      hasMore: false,
      items: [
        ChatInboxItem(
          conversation: ChatConversation(
            id: 'conversation-1',
            type: 'channel',
            scopeKind: 'project',
            scopeKey: 'project-1',
            workspaceId: 'workspace-1',
            projectId: 'project-1',
            name: 'Rozmowa projektu',
            version: 1,
            createdAtUtc: DateTime.utc(2026),
            postingPermission: 'Everyone',
            isArchived: false,
          ),
          lastActivityAtUtc: DateTime.utc(2026),
          unreadCount: 0,
          isMuted: false,
          isDraft: false,
          participantCount: 1,
        ),
      ],
    ),
  );

  @override
  Future<Either<ApiError, ChatInboxUnreadCount>> loadUnreadCount() async =>
      Right(
        ChatInboxUnreadCount(
          totalUnreadCount: 0,
          unreadConversationCount: 0,
          generatedAtUtc: DateTime.utc(2026),
        ),
      );

  @override
  Future<Either<ApiError, void>> markRead({
    required String conversationId,
    required String messageId,
  }) async => const Right(null);
}
