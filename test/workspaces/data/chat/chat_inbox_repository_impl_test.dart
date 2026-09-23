import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/chat/api/chat_api.dart';
import 'package:devplanner/workspaces/data/chat/models/chat_models.dart';
import 'package:devplanner/workspaces/data/chat/repositories/chat_inbox_repository_impl.dart';
import 'package:devplanner/workspaces/data/shared/enums/chat_enums.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockChatApi extends Mock implements ChatApi {}

void main() {
  late _MockChatApi api;
  late ChatInboxRepository repository;

  setUp(() {
    api = _MockChatApi();
    repository = ChatInboxRepositoryImpl(api);
  });

  group('ChatInboxRepositoryImpl', () {
    test('mapuje stronę skrzynki na modele domenowe', () async {
      when(
        () => api.loadInbox(limit: 30, filter: 'All'),
      ).thenAnswer(
        (_) async => ChatInboxPageResponse(
          items: <ChatInboxItemResponse>[_inboxItem(ownerId: 'current-user')],
          nextCursor: 'older-cursor',
          hasMore: true,
        ),
      );

      final result = await repository.loadInbox();

      final page = result.getOrElse(() => ChatInboxPage.empty);
      expect(page.nextCursor, 'older-cursor');
      expect(page.hasMore, isTrue);
      expect(page.items, hasLength(1));
      final item = page.items.single;
      expect(item.conversation.id, 'conversation-1');
      expect(item.conversation.type, 'direct');
      expect(item.unreadCount, 3);
      expect(item.hasUnread, isTrue);
      expect(item.isMuted, isTrue);
      expect(item.isDraft, isTrue);
      expect(item.draftText, 'szkic');
      expect(item.role, 'Member');
      expect(item.participantCount, 2);
      expect(item.lastMessage?.text, 'ostatnia wiadomość');
      expect(item.lastMessage?.isThreadReply, isFalse);
      expect(item.lastReadMessageId, 'message-read');
      expect(item.lastActivityAtUtc, DateTime.utc(2026, 9, 21, 12));
    });

    test('zachowuje łączną liczbę poza skróconą listą uczestników', () async {
      final response = _inboxItem(
        ownerId: 'current-user',
        participantCount: 9,
      );
      when(
        () => api.loadInbox(limit: 30, filter: 'All'),
      ).thenAnswer(
        (_) async => ChatInboxPageResponse(
          items: <ChatInboxItemResponse>[response],
        ),
      );

      final page = await repository.loadInbox();
      final item = page.getOrElse(() => ChatInboxPage.empty).items.single;

      expect(response.participants, hasLength(2));
      expect(item.participants, hasLength(2));
      expect(item.participantCount, 9);
    });

    test(
      'nie ujawnia identyfikatora rozmowy jako nazwy, gdy brak profilu',
      () async {
        final item = await _loadSingleItem(
          _inboxItem(ownerId: 'current-user', includeProfiles: false),
        );

        expect(item.displayName, 'peer-user');
        expect(item.otherParticipants.single.label, 'peer-user');
      },
    );

    test('wybiera etykietę rozmówcy dla rozmowy 1:1 bez nazwy', () async {
      final item = await _loadSingleItem(_inboxItem(ownerId: 'current-user'));

      expect(item.displayName, 'Rozmówca Testowy');
      expect(item.otherParticipants.single.userId, 'peer-user');
    });

    test('przekazuje filtr tekstowy i limit strony', () async {
      when(
        () => api.loadInbox(
          cursor: 'cursor-1',
          limit: 50,
          filter: 'Unread',
          query: 'projekt',
        ),
      ).thenAnswer(
        (_) async => const ChatInboxPageResponse(),
      );

      await repository.loadInbox(
        filter: ChatInboxFilter.unread,
        cursor: 'cursor-1',
        limit: 50,
        query: 'projekt',
      );

      verify(
        () => api.loadInbox(
          cursor: 'cursor-1',
          limit: 50,
          filter: 'Unread',
          query: 'projekt',
        ),
      ).called(1);
    });

    test('mapuje agregat nieprzeczytanych bez pobierania stron', () async {
      when(api.loadInboxUnreadCount).thenAnswer(
        (_) async => ChatInboxUnreadCountResponse(
          totalUnreadCount: 7,
          unreadConversationCount: 2,
          generatedAtUtc: DateTime.utc(2026, 9, 21, 12, 30),
        ),
      );

      final result = await repository.loadUnreadCount();

      expect(result.isRight(), isTrue);
      final count = result.getOrElse(
        () => throw StateError('oczekiwano agregatu'),
      );
      expect(count.totalUnreadCount, 7);
      expect(count.unreadConversationCount, 2);
      expect(count.hasUnread, isTrue);
    });

    test('oznacza odczyt wyłącznie dla wskazanej wiadomości', () async {
      when(() => api.markRead(any(), any())).thenAnswer((_) async {});

      final result = await repository.markRead(
        conversationId: 'conversation-1',
        messageId: 'message-9',
      );

      expect(result.isRight(), isTrue);
      verify(() => api.markRead('conversation-1', 'message-9')).called(1);
    });

    test('zwraca kod domenowy błędu transportu bez tekstu dla UI', () async {
      when(
        () => api.loadInbox(limit: 30, filter: 'All'),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/v1/chat/inbox'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.loadInbox();

      final error = result.swap().getOrElse(
        () => throw StateError('oczekiwano błędu'),
      );
      expect(error.apiCode, 'chat.inbox.load_failed');
      expect(error.message, 'chat.inbox.load_failed');
    });

    test('błąd parsowania zachowuje kod maszynowy skrzynki', () async {
      when(
        () => api.loadInbox(limit: 30, filter: 'All'),
      ).thenThrow(const FormatException('nieprawidłowy JSON'));

      final result = await repository.loadInbox();

      final error = result.swap().getOrElse(
        () => throw StateError('oczekiwano błędu'),
      );
      expect(error.type, ApiErrorType.parsing);
      expect(error.apiCode, 'chat.inbox.load_failed');
    });

    test('błąd agregatu nieprzeczytanych ma własny kod', () async {
      when(api.loadInboxUnreadCount).thenThrow(
        DioException(
          requestOptions: RequestOptions(
            path: '/api/v1/chat/inbox/unread-count',
          ),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.loadUnreadCount();

      expect(
        result
            .swap()
            .getOrElse(() => throw StateError('oczekiwano błędu'))
            .apiCode,
        'chat.inbox.unread_count_failed',
      );
    });
  });
}

/// Buduje pozycję skrzynki przez realny adapter, aby testować mapowanie.
Future<ChatInboxItem> _loadSingleItem(ChatInboxItemResponse response) async {
  final api = _MockChatApi();
  when(
    () => api.loadInbox(limit: 30, filter: 'All'),
  ).thenAnswer(
    (_) async =>
        ChatInboxPageResponse(items: <ChatInboxItemResponse>[response]),
  );
  final page = await ChatInboxRepositoryImpl(api).loadInbox();
  return page.getOrElse(() => ChatInboxPage.empty).items.single;
}

ChatInboxItemResponse _inboxItem({
  required String ownerId,
  bool includeProfiles = true,
  int participantCount = 2,
}) => ChatInboxItemResponse(
  conversation: ChatConversationResponse(
    id: 'conversation-1',
    type: ChatConversationType.direct,
    scopeKind: ChatScopeKind.global,
    scopeKey: 'direct:global:pair',
    version: 3,
    createdAtUtc: DateTime.utc(2026, 9, 20),
  ),
  lastMessage: ChatInboxMessagePreviewResponse(
    messageId: 'message-9',
    authorUserId: 'peer-user',
    text: 'ostatnia wiadomość',
    createdAtUtc: DateTime.utc(2026, 9, 21, 11, 59),
  ),
  lastActivityAtUtc: DateTime.utc(2026, 9, 21, 12),
  unreadCount: 3,
  lastReadMessageId: 'message-read',
  isMuted: true,
  isDraft: true,
  draftText: 'szkic',
  role: 'Member',
  participants: <ChatInboxParticipantResponse>[
    ChatInboxParticipantResponse(userId: ownerId, isCurrentUser: true),
    ChatInboxParticipantResponse(
      userId: 'peer-user',
      login: includeProfiles ? 'peer-login' : null,
      displayName: includeProfiles ? 'Rozmówca Testowy' : null,
    ),
  ],
  participantCount: participantCount,
);
