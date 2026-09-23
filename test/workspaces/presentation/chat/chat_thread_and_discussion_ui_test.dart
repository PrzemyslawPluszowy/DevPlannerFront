import 'package:dartz/dartz.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_realtime_credentials.dart';
import 'package:devplanner/workspaces/domain/chat/composer/chat_draft_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/chat_conversation_repository.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/discussion/chat_discussion_repository.dart';
import 'package:devplanner/workspaces/domain/chat/message_actions/chat_message_actions_export.dart';
import 'package:devplanner/workspaces/domain/chat/thread/chat_thread_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_upload_input.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/chat/attachments/upload/chat_attachment_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/chat_conversation_page.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/cubit/chat_conversation_state.dart';
import 'package:devplanner/workspaces/presentation/chat/thread/chat_thread_side_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets(
    'wątek zachowuje cursor, wysyła reply do parenta i izoluje draft',
    (
      tester,
    ) async {
      final thread = _ThreadRepository();
      final conversation = _ConversationRepository();
      final drafts = _DraftRepository();
      await tester.pumpWidget(
        _ChatFixture.thread(
          thread: thread,
          conversation: conversation,
          drafts: drafts,
          root: _message('root-a'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Load older replies'), findsOneWidget);
      await tester.tap(find.text('Load older replies'));
      await tester.pumpAndSettle();
      expect(thread.cursors, <String?>[null, 'older']);

      await tester.enterText(find.byType(TextField), 'reply');
      await tester.tap(find.byTooltip('Send message'));
      await tester.pumpAndSettle();
      expect(conversation.sent.single.conversationId, 'parent');
      expect(conversation.sent.single.replyToMessageId, 'root-a');

      await tester.pumpWidget(
        _ChatFixture.thread(
          thread: thread,
          conversation: conversation,
          drafts: drafts,
          root: _message('root-b'),
        ),
      );
      await tester.pump();
      expect(
        drafts.readKeys,
        containsAll(<String>['user-1/thread:root-a', 'user-1/thread:root-b']),
      );
    },
  );

  testWidgets('revoke 403 czyści draft wątku i nie zostawia composera', (
    tester,
  ) async {
    final drafts = _DraftRepository();
    await drafts.save(
      userId: 'user-1',
      conversationId: 'thread:root-a',
      draft: const ChatComposerDraft(text: 'Prywatny draft'),
    );
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pumpWidget(
      const SizedBox.shrink(),
    );
    await tester.pump();
    await tester.pumpWidget(
      _ChatFixture.thread(
        thread: _ThreadRepository(deny: true),
        conversation: _ConversationRepository(),
        drafts: drafts,
        root: _message('root-a'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Forbidden'), findsOneWidget);
    expect(drafts.deletedKeys, contains('user-1/thread:root-a'));
    expect(find.text('Prywatny draft'), findsNothing);
  });

  testWidgets('dyskusja nie zmienia URI ani nie rzuca po odłączeniu rodzica', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(() => tester.view.resetPhysicalSize());
    final conversations = _ConversationRepository();
    final router = GoRouter(
      initialLocation: '/chat/conversations/parent?source=panel',
      routes: [
        GoRoute(
          path: '/chat/conversations/:id',
          builder: (_, state) => _ChatFixture.conversation(
            conversation: conversations,
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Open discussion'));
    await tester.pump();
    await tester.enterText(find.byType(TextField).first, 'Project discussion');
    await tester.tap(
      find.widgetWithText(FilledButton, 'Open discussion').first,
    );
    await tester.pumpAndSettle();
    expect(
      router.routerDelegate.currentConfiguration.uri.toString(),
      '/chat/conversations/parent?source=panel',
    );

    conversations.deny = true;
    await tester
        .element(
          find
              .byWidgetPredicate(
                (widget) =>
                    widget
                        is BlocListener<
                          ChatConversationCubit,
                          ChatConversationState
                        >,
              )
              .first,
        )
        .read<ChatConversationCubit>()
        .load();
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Forbidden'), findsOneWidget);
    expect(find.text('Named discussion'), findsNothing);
  });

  testWidgets(
    'detach rodzica zamyka otwarty wątek, usuwa jego draft i nie rzuca wyjątku',
    (tester) async {
      tester.view.physicalSize = const Size(700, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(() => tester.view.resetPhysicalSize());
      final conversations = _ConversationRepository();
      final drafts = _DraftRepository();
      await drafts.save(
        userId: 'user-1',
        conversationId: 'thread:root',
        draft: const ChatComposerDraft(text: 'Prywatny draft wątku'),
      );
      final router = GoRouter(
        initialLocation: '/chat/conversations/parent',
        routes: [
          GoRoute(
            path: '/chat/conversations/:id',
            builder: (_, _) => _ChatFixture.conversation(
              conversation: conversations,
              drafts: drafts,
            ),
          ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(_ChatFixture.router(router));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Open thread'));
      await tester.pumpAndSettle();
      expect(find.text('Thread'), findsOneWidget);
      expect(find.text('Prywatny draft wątku'), findsOneWidget);

      conversations.deny = true;
      await _ChatFixture.parentCubit(tester).load();
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Thread'), findsNothing);
      expect(find.text('Prywatny draft wątku'), findsNothing);
      expect(drafts.deletedKeys, contains('user-1/thread:root'));
    },
  );
}

abstract final class _ChatFixture {
  static AuthSessionPort authSession() => AuthSessionController(
    initial: const AuthSessionSnapshot(
      status: AuthSessionStatus.signedIn,
      user: AuthUser(
        userId: 'user-1',
        login: 'tester',
        displayName: 'Tester',
      ),
    ),
  );

  static Widget thread({
    required _ThreadRepository thread,
    required _ConversationRepository conversation,
    required _DraftRepository drafts,
    required ChatMessage root,
  }) => MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MultiRepositoryProvider(
      providers: [
        ListenableProvider<AuthSessionPort>.value(
          value: _ChatFixture.authSession(),
        ),
        RepositoryProvider<ChatThreadRepository>.value(value: thread),
        RepositoryProvider<ChatConversationRepository>.value(
          value: conversation,
        ),
        RepositoryProvider<ChatDraftRepository>.value(value: drafts),
      ],
      child: Scaffold(
        body: ChatThreadSidePanel(
          key: ValueKey(root.id),
          conversationId: 'parent',
          rootMessage: root,
          onClose: () {},
        ),
      ),
    ),
  );
  static Widget conversation({
    required _ConversationRepository conversation,
    _DraftRepository? drafts,
  }) => MultiRepositoryProvider(
    providers: [
      ListenableProvider<AuthSessionPort>.value(
        value: _ChatFixture.authSession(),
      ),
      RepositoryProvider<ChatConversationRepository>.value(value: conversation),
      RepositoryProvider<ChatMessageActionsRepository>.value(
        value: _MessageActionsRepository(),
      ),
      RepositoryProvider<ChatAttachmentUploadPort>.value(
        value: _AttachmentUploadPort(),
      ),
      RepositoryProvider<FilePickerPort>.value(value: _FilePickerPort()),
      RepositoryProvider<ChatDraftRepository>.value(
        value: drafts ?? _DraftRepository(),
      ),
      RepositoryProvider<ChatThreadRepository>.value(
        value: _ThreadRepository(),
      ),
      RepositoryProvider<ChatDiscussionRepository>.value(
        value: _DiscussionRepository(),
      ),
      RepositoryProvider<WorkspaceChatRealtimeFactory>.value(
        value: WorkspaceChatRealtimeFactory(
          baseUrl: 'http://127.0.0.1:1',
          credentials: WorkspaceRealtimeCredentials.bearer(
            () async => null,
          ),
        ),
      ),
    ],
    child: const Scaffold(
      body: ChatConversationPageView(conversationId: 'parent'),
    ),
  );

  static Widget router(GoRouter router) => MaterialApp.router(
    routerConfig: router,
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );

  static ChatConversationCubit parentCubit(WidgetTester tester) => tester
      .element(
        find
            .byWidgetPredicate(
              (widget) =>
                  widget
                      is BlocListener<
                        ChatConversationCubit,
                        ChatConversationState
                      >,
            )
            .first,
      )
      .read<ChatConversationCubit>();
}

ChatMessage _message(String id) => ChatMessage(
  id: id,
  conversationId: 'parent',
  authorUserId: 'user-1',
  clientMessageId: id,
  text: 'Message $id',
  payloadHash: 'hash',
  version: 1,
  createdAtUtc: DateTime.utc(2026),
  isDeleted: false,
  deliveryState: ChatMessageDeliveryState.sent,
);
ChatConversation _conversation() => ChatConversation(
  id: 'parent',
  type: 'Group',
  scopeKind: 'Global',
  scopeKey: 'global',
  version: 1,
  createdAtUtc: DateTime.utc(2026),
  postingPermission: 'Member',
  isArchived: false,
);

final class _ThreadRepository implements ChatThreadRepository {
  _ThreadRepository({this.deny = false});
  bool deny;
  final cursors = <String?>[];
  @override
  Future<Either<ApiError, ChatMessagePage>> listThreadMessages({
    required String conversationId,
    required String threadRootMessageId,
    String? cursor,
    int limit = 50,
  }) async {
    cursors.add(cursor);
    return deny
        ? const Left(
            ApiError(type: ApiErrorType.forbidden, message: 'Forbidden'),
          )
        : Right(
            ChatMessagePage(
              items: [_message('reply-${cursor ?? 'new'}')],
              nextCursor: cursor == null ? 'older' : null,
            ),
          );
  }
}

final class _ConversationRepository implements ChatConversationRepository {
  bool deny = false;
  final sent = <ChatSendMessageCommand>[];
  @override
  Future<Either<ApiError, ChatConversation>> getConversation(
    String conversationId,
  ) async => deny
      ? const Left(ApiError(type: ApiErrorType.forbidden, message: 'Forbidden'))
      : Right(_conversation());
  @override
  Future<Either<ApiError, ChatMessageWindow>> loadMessageWindow({
    required String conversationId,
    required String messageId,
    int before = 20,
    int after = 20,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatMessagePage>> listConversationMessages({
    required String conversationId,
    String? cursor,
    int limit = 50,
  }) async => deny
      ? const Left(ApiError(type: ApiErrorType.forbidden, message: 'Forbidden'))
      : Right(ChatMessagePage(items: [_message('root')]));
  @override
  Future<Either<ApiError, ChatMessage>> sendConversationMessage(
    ChatSendMessageCommand command,
  ) async {
    sent.add(command);
    return Right(_message('sent'));
  }

  @override
  Future<Either<ApiError, void>> markMessageDelivered({
    required String messageId,
  }) async => const Right(null);

  @override
  Future<Either<ApiError, void>> markConversationRead({
    required String conversationId,
    required String messageId,
  }) async => const Right(null);
}

final class _DiscussionRepository implements ChatDiscussionRepository {
  @override
  Future<Either<ApiError, ChatConversation>> resolveDiscussion({
    required ChatConversation parentConversation,
    required String rootMessageId,
    required String name,
  }) async => Right(
    ChatConversation(
      id: 'discussion',
      type: 'Discussion',
      scopeKind: 'Global',
      scopeKey: 'global',
      discussionRootMessageId: rootMessageId,
      version: 1,
      createdAtUtc: DateTime.utc(2026),
      postingPermission: 'Member',
      isArchived: false,
    ),
  );
}

final class _MessageActionsRepository implements ChatMessageActionsRepository {
  @override
  Future<Either<ApiError, ChatMessage>> editMessage({
    required String messageId,
    required String text,
    required String? deltaJson,
    required int version,
  }) async => Right(_message(messageId));

  @override
  Future<Either<ApiError, void>> deleteMessage({
    required String messageId,
    required int version,
  }) async => const Right(null);

  @override
  Future<Either<ApiError, List<ChatMessageRevision>>> listRevisions(
    String messageId,
  ) async => const Right(<ChatMessageRevision>[]);

  @override
  Future<Either<ApiError, ChatMessage>> forwardMessage({
    required String messageId,
    required String targetConversationId,
    required String clientMessageId,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatPinnedMessage>> pinMessage({
    required String conversationId,
    required String messageId,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, void>> unpinMessage({
    required String conversationId,
    required String messageId,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, List<ChatPinnedMessage>>> listPins(
    String conversationId,
  ) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatBookmark>> bookmarkMessage({
    required String messageId,
    String? note,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, void>> removeBookmark(String messageId) async =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, List<ChatBookmark>>> listBookmarks() async =>
      throw UnimplementedError();

  @override
  Future<Either<ApiError, ChatMessageReaction>> addReaction({
    required String messageId,
    required String emoji,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, void>> removeReaction({
    required String messageId,
    required String emoji,
  }) async => throw UnimplementedError();

  @override
  Future<Either<ApiError, List<ChatMessageReaction>>> listReactions(
    String messageId,
  ) async => throw UnimplementedError();
}

final class _AttachmentUploadPort implements ChatAttachmentUploadPort {
  @override
  Future<void> cancelSession(String conversationId, String sessionId) async {}

  @override
  Future<void> complete(String storageFileId) async {}

  @override
  Future<ChatAttachmentUploadSession> createSession(
    String conversationId,
  ) async => const ChatAttachmentUploadSession('session');

  @override
  Future<ChatAttachmentTicket> createTicket({
    required String sessionId,
    required StorageUploadInput input,
  }) async => const ChatAttachmentTicket('file');

  @override
  Future<ChatAttachmentRemoteStatus> status(String storageFileId) async =>
      ChatAttachmentRemoteStatus.cleanReady;

  @override
  Future<void> upload(
    ChatAttachmentTicket ticket,
    StorageUploadInput input,
  ) async {}
}

final class _FilePickerPort implements FilePickerPort {
  @override
  Future<List<StorageUploadInput>> pickFiles({
    bool allowMultiple = true,
    List<String>? allowedExtensions,
  }) async => const <StorageUploadInput>[];
}

final class _DraftRepository implements ChatDraftRepository {
  final values = <String, ChatComposerDraft>{};
  final readKeys = <String>[];
  final deletedKeys = <String>[];
  String _key(String user, String conversation) => '$user/$conversation';
  @override
  Future<ChatComposerDraft?> read({
    required String userId,
    required String conversationId,
  }) async {
    final key = _key(userId, conversationId);
    readKeys.add(key);
    return values[key];
  }

  @override
  Future<void> save({
    required String userId,
    required String conversationId,
    required ChatComposerDraft draft,
  }) async => values[_key(userId, conversationId)] = draft;
  @override
  Future<void> delete({
    required String userId,
    required String conversationId,
  }) async {
    final key = _key(userId, conversationId);
    deletedKeys.add(key);
    values.remove(key);
  }

  @override
  Future<void> deleteAllForUser({required String userId}) async {}
}
