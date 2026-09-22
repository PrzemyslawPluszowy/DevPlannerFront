import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_conversation_management_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_directory_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_members_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_message_actions_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_presence_repository_impl.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_search_repository_impl.dart';
import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:devplanner/workspaces/domain/chat/management/models/chat_conversation_create_command.dart';
import 'package:devplanner/workspaces/domain/chat/members/models/chat_member.dart';
import 'package:devplanner/workspaces/domain/chat/presence/models/chat_user_status.dart';
import 'package:devplanner/workspaces/domain/chat/search/models/chat_search_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockChatApi extends Mock implements ChatApi {}

ChatConversationResponse conversationResponse() => ChatConversationResponse(
  id: 'conversation-1',
  type: ChatConversationType.group,
  scopeKind: ChatScopeKind.global,
  scopeKey: 'global:grupa',
  name: 'Grupa',
  version: 2,
  createdAtUtc: DateTime.utc(2026, 9, 21),
);

void main() {
  late _MockChatApi api;

  setUp(() {
    api = _MockChatApi();
    registerFallbackValue(
      const ResolveChatConversationPayload(
        type: ChatConversationType.group,
        scopeKind: ChatScopeKind.global,
        scopeKey: 'fallback',
      ),
    );
    registerFallbackValue(const UpdateChatConversationPayload());
    registerFallbackValue(const AddChatMembersPayload());
    registerFallbackValue(const UpdateChatMemberRolePayload(role: 'Member'));
    registerFallbackValue(
      const ForwardChatMessagePayload(
        targetConversationId: 'c',
        clientMessageId: 'k',
      ),
    );
    registerFallbackValue(const AddChatReactionPayload(emoji: '+1'));
    registerFallbackValue(const ChatBookmarkPayload());
    registerFallbackValue(const UpsertChatUserStatusPayload());
  });

  group('ChatConversationManagementRepositoryImpl', () {
    test('tworzy rozmowę tekstowymi wartościami kontraktu', () async {
      when(() => api.resolve(any())).thenAnswer(
        (_) async => conversationResponse(),
      );

      final result =
          await ChatConversationManagementRepositoryImpl(
            api,
          ).createConversation(
            const ChatConversationCreateCommand(
              kind: ChatConversationKind.group,
              scope: ChatConversationScope.global,
              scopeKey: 'grupa-1',
              name: 'Grupa',
              userIds: ['owner', 'peer'],
              postingPermission: 'AdminsOnly',
            ),
          );

      expect(result.isRight(), isTrue);
      final payload =
          verify(() => api.resolve(captureAny())).captured.single
              as ResolveChatConversationPayload;
      expect(payload.type, ChatConversationType.group);
      expect(payload.scopeKind, ChatScopeKind.global);
      expect(payload.userIds, ['owner', 'peer']);
      expect(
        payload.postingPermission,
        'AdminsOnly',
        reason: 'wybór polityki publikacji nie może ginąć po drodze do DTO',
      );
      expect(
        result.getOrElse(() => throw StateError('brak')).id,
        'conversation-1',
      );
    });

    test('opuszczenie rozmowy deleguje do kontraktu', () async {
      when(() => api.leaveConversation(any())).thenAnswer((_) async {});

      final result = await ChatConversationManagementRepositoryImpl(
        api,
      ).leaveConversation('conversation-1');

      expect(result.isRight(), isTrue);
      verify(() => api.leaveConversation('conversation-1')).called(1);
    });

    test('błąd transportu ma stabilny kod domenowy', () async {
      when(() => api.archiveConversation(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/chat/conversations/x'),
          response: Response<void>(
            requestOptions: RequestOptions(path: '/x'),
            statusCode: 403,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      final result = await ChatConversationManagementRepositoryImpl(
        api,
      ).archiveConversation('conversation-1');

      final error = result.swap().getOrElse(
        () => throw StateError('oczekiwano błędu'),
      );
      expect(error.apiCode, 'chat.conversations.manage_failed');
      expect(error.statusCode, 403);
    });
  });

  group('ChatMembersRepositoryImpl', () {
    test(
      'mapuje rolę tekstową na typ domenowy i degradację read-only',
      () async {
        when(() => api.listMembers(any())).thenAnswer(
          (_) async => <ChatMemberResponse>[
            ChatMemberResponse(
              userId: 'owner',
              role: 'Owner',
              joinedAtUtc: DateTime.utc(2026, 9, 21),
            ),
            ChatMemberResponse(
              userId: 'nieznany',
              role: 'Synthetic',
              joinedAtUtc: DateTime.utc(2026, 9, 21),
            ),
          ],
        );

        final result = await ChatMembersRepositoryImpl(api).listMembers(
          'conversation-1',
        );

        final members = result.getOrElse(() => <ChatMember>[]);
        expect(members.first.role, ChatMemberRole.owner);
        expect(members.first.role.canManageMembers, isTrue);
        expect(
          members.last.role,
          ChatMemberRole.observer,
          reason: 'nieznana rola nie może udawać uprawnień',
        );
        expect(members.last.role.canPublish, isFalse);
      },
    );

    test('mapuje profil członka i degraduje brak nazwy do loginu', () async {
      when(() => api.listMembers(any())).thenAnswer(
        (_) async => <ChatMemberResponse>[
          ChatMemberResponse(
            userId: 'peer-1',
            role: 'Member',
            joinedAtUtc: DateTime.utc(2026, 9, 21),
            login: 'ola.k',
            displayName: 'Ola Kowalska',
            avatarUrl: '/api/v1/users/peer-1/avatar',
          ),
          ChatMemberResponse(
            userId: 'peer-2',
            role: 'Member',
            joinedAtUtc: DateTime.utc(2026, 9, 21),
            login: 'jan.n',
          ),
        ],
      );

      final result = await ChatMembersRepositoryImpl(api).listMembers(
        'conversation-1',
      );

      final members = result.getOrElse(() => <ChatMember>[]);
      expect(members.first.label, 'Ola Kowalska');
      expect(members.first.avatarUrl, '/api/v1/users/peer-1/avatar');
      expect(
        members.last.label,
        'jan.n',
        reason: 'brak nazwy wyświetlanej nie może pokazywać UUID',
      );
    });

    test('dodaje członków przekazanymi identyfikatorami', () async {
      when(() => api.addMembers(any(), any())).thenAnswer(
        (_) async => <ChatMemberResponse>[],
      );

      await ChatMembersRepositoryImpl(api).addMembers(
        conversationId: 'conversation-1',
        userIds: ['peer-1'],
      );

      final payload =
          verify(
                () => api.addMembers('conversation-1', captureAny()),
              ).captured.single
              as AddChatMembersPayload;
      expect(payload.userIds, ['peer-1']);
    });
  });

  group('ChatMessageActionsRepositoryImpl', () {
    test('forward zachowuje idempotency key klienta', () async {
      when(() => api.forwardMessage(any(), any())).thenAnswer(
        (_) async => messageResponse(),
      );

      await ChatMessageActionsRepositoryImpl(api).forwardMessage(
        messageId: 'message-1',
        targetConversationId: 'conversation-2',
        clientMessageId: 'client-key-1',
      );

      final payload =
          verify(
                () => api.forwardMessage('message-1', captureAny()),
              ).captured.single
              as ForwardChatMessagePayload;
      expect(payload.clientMessageId, 'client-key-1');
      expect(payload.targetConversationId, 'conversation-2');
    });

    test('rewizje używają lokalnych UserId, nie nazw Core', () async {
      when(() => api.listRevisions(any())).thenAnswer(
        (_) async => <ChatMessageRevisionResponse>[
          ChatMessageRevisionResponse(
            id: 'revision-1',
            messageId: 'message-1',
            authorUserId: 'author-local',
            editedByUserId: 'editor-local',
            text: 'poprzednia',
            createdAtUtc: DateTime.utc(2026, 9, 21),
            version: 1,
            newVersion: 2,
          ),
        ],
      );

      final result = await ChatMessageActionsRepositoryImpl(
        api,
      ).listRevisions('message-1');

      final revision = result.getOrElse(() => []).single;
      expect(revision.authorUserId, 'author-local');
      expect(revision.editedByUserId, 'editor-local');
    });

    test('reakcja jest wysyłana jako emoji, a błąd ma kod akcji', () async {
      when(() => api.addReaction(any(), any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(
            path: '/api/v1/chat/messages/x/reactions',
          ),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await ChatMessageActionsRepositoryImpl(api).addReaction(
        messageId: 'message-1',
        emoji: '+1',
      );

      final payload =
          verify(
                () => api.addReaction('message-1', captureAny()),
              ).captured.single
              as AddChatReactionPayload;
      expect(payload.emoji, '+1');
      expect(
        result.swap().getOrElse(() => throw StateError('brak')).apiCode,
        'chat.messages.action_failed',
      );
    });
  });

  group('ChatSearchRepositoryImpl', () {
    test('przekazuje frazę i filtry oraz mapuje trafienia', () async {
      when(
        () => api.search(
          query: any(named: 'query'),
          conversationId: any(named: 'conversationId'),
          senderId: any(named: 'senderId'),
          workspaceId: any(named: 'workspaceId'),
          projectId: any(named: 'projectId'),
          fromUtc: any(named: 'fromUtc'),
          toUtc: any(named: 'toUtc'),
          mentionedUserId: any(named: 'mentionedUserId'),
          limit: any(named: 'limit'),
          cursor: any(named: 'cursor'),
        ),
      ).thenAnswer(
        (_) async => ChatSearchResponse(
          items: <ChatSearchItemResponse>[
            ChatSearchItemResponse(
              messageId: 'message-1',
              conversationId: 'conversation-1',
              authorUserId: 'author-1',
              conversationType: ChatConversationType.group,
              text: 'trafienie',
              highlight: '**trafienie**',
              score: 0.5,
              createdAtUtc: DateTime.utc(2026, 9, 21),
              hasMention: true,
            ),
          ],
          nextCursor: 'older',
          totalApproximate: 1,
          indexVersion: 'v1',
        ),
      );

      final result = await ChatSearchRepositoryImpl(api).searchMessages(
        const ChatSearchQuery(term: 'traf', conversationId: 'conversation-1'),
      );

      final page = result.getOrElse(
        () => const ChatSearchPage(hits: [], totalApproximate: 0),
      );
      expect(page.hits.single.messageId, 'message-1');
      expect(page.hits.single.hasMention, isTrue);
      expect(page.nextCursor, 'older');
      verify(
        () => api.search(
          query: 'traf',
          conversationId: 'conversation-1',
          senderId: any(named: 'senderId'),
          workspaceId: any(named: 'workspaceId'),
          projectId: any(named: 'projectId'),
          fromUtc: any(named: 'fromUtc'),
          toUtc: any(named: 'toUtc'),
          mentionedUserId: any(named: 'mentionedUserId'),
          limit: any(named: 'limit'),
          cursor: any(named: 'cursor'),
        ),
      ).called(1);
    });

    test('podpowiedzi wzmianek mapują profil lokalnego użytkownika', () async {
      when(() => api.mentionSuggestions(any(), any())).thenAnswer(
        (_) async => <ChatMentionSuggestionResponse>[
          const ChatMentionSuggestionResponse(
            userId: 'user-1',
            login: 'login-1',
            displayName: 'Osoba',
          ),
        ],
      );

      final result = await ChatSearchRepositoryImpl(api).suggestMentions(
        conversationId: 'conversation-1',
        term: 'os',
      );

      final suggestion = result.getOrElse(() => []).single;
      expect(suggestion.userId, 'user-1');
      expect(suggestion.displayName, 'Osoba');
    });
  });

  group('ChatDirectoryRepositoryImpl', () {
    test('mapuje katalog na modele domenowe bez adresu e-mail', () async {
      when(
        () => api.searchDirectory(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => <ChatDirectoryUserResponse>[
          const ChatDirectoryUserResponse(
            userId: 'user-1',
            login: 'anna.kowalska',
            displayName: 'Anna Kowalska',
          ),
        ],
      );

      final result = await ChatDirectoryRepositoryImpl(api)
          .search(term: 'anna');

      final entry = result.getOrElse(() => []).single;
      expect(entry.userId, 'user-1');
      expect(entry.label, 'Anna Kowalska');
      expect(
        ChatDirectoryUserResponse.fromJson(const <String, dynamic>{
          'userId': 'user-1',
          'login': 'anna.kowalska',
          'displayName': 'Anna Kowalska',
        }).toJson().keys,
        isNot(contains('email')),
      );
      verify(() => api.searchDirectory(query: 'anna', limit: 20)).called(1);
    });

    test('błąd katalogu ma własny kod domenowy', () async {
      when(
        () => api.searchDirectory(
          query: any(named: 'query'),
          limit: any(named: 'limit'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/chat/users'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await ChatDirectoryRepositoryImpl(api)
          .search(term: 'anna');

      expect(
        result.swap().getOrElse(() => throw StateError('brak')).apiCode,
        'chat.directory.load_failed',
      );
    });
  });

  group('ChatPresenceRepositoryImpl', () {
    test('brak statusu jest poprawną odpowiedzią, nie błędem', () async {
      when(() => api.getUserStatus(any())).thenAnswer((_) async => null);

      final result = await ChatPresenceRepositoryImpl(
        api,
      ).getUserStatus('user-1');

      expect(
        result.getOrElse(
          () => ChatUserStatus(
            userId: 'x',
            isDnd: false,
            updatedAtUtc: DateTime.utc(2026),
          ),
        ),
        isNull,
      );
    });

    test('ustawia własny status z wygaśnięciem i DND', () async {
      when(() => api.upsertStatus(any())).thenAnswer(
        (_) async => ChatUserStatusResponse(
          userId: 'user-1',
          emoji: '🌴',
          text: 'Urlop',
          expiresAtUtc: DateTime.utc(2026, 9, 22),
          isDnd: true,
          updatedAtUtc: DateTime.utc(2026, 9, 21, 12),
        ),
      );

      final result = await ChatPresenceRepositoryImpl(api).setOwnStatus(
        ChatUserStatusUpdate(
          emoji: '🌴',
          text: 'Urlop',
          isDnd: true,
          expiresAtUtc: DateTime.utc(2026, 9, 22),
        ),
      );

      final payload =
          verify(() => api.upsertStatus(captureAny())).captured.single
              as UpsertChatUserStatusPayload;
      expect(payload.isDnd, isTrue);
      final status = result.getOrElse(
        () => throw StateError('brak statusu'),
      );
      expect(status.text, 'Urlop');
      expect(status.isExpiredAt(DateTime.utc(2026, 9, 22, 1)), isTrue);
      expect(status.isExpiredAt(DateTime.utc(2026, 9, 21, 13)), isFalse);
    });

    test('błąd statusu sesji ma własny kod', () async {
      when(() => api.clearStatus()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/chat/users/me/status'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await ChatPresenceRepositoryImpl(api).clearOwnStatus();

      expect(
        result.swap().getOrElse(() => throw StateError('brak')).apiCode,
        'chat.status.update_failed',
      );
    });
  });
}

ChatMessageResponse messageResponse() => ChatMessageResponse(
  id: 'message-1',
  conversationId: 'conversation-1',
  authorUserId: 'author-1',
  clientMessageId: 'client-1',
  text: 'tresc',
  payloadHash: 'hash',
  version: 1,
  createdAtUtc: DateTime.utc(2026, 9, 21),
  isDeleted: false,
);
