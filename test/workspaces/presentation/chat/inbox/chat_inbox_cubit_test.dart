import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:flutter_test/flutter_test.dart';

final class _InboxRepositoryFake implements ChatInboxRepository {
  _InboxRepositoryFake({
    this.page,
    this.counts,
    this.failure,
    this.loadMorePage,
    this.loadMoreFailure,
  });

  ChatInboxPage? page;
  ChatInboxUnreadCount? counts;
  ApiError? failure;
  ChatInboxPage? loadMorePage;
  ApiError? loadMoreFailure;
  final List<ChatInboxFilter> requestedFilters = <ChatInboxFilter>[];

  /// Opóźnienie odpowiedzi dla filtra Unread; pozwala wymusić wyścig.
  Duration? unreadDelay;
  final List<String?> requestedCursors = <String?>[];
  int unreadCountCalls = 0;

  @override
  Future<Either<ApiError, ChatInboxPage>> loadInbox({
    ChatInboxFilter filter = ChatInboxFilter.all,
    String? cursor,
    int? limit,
  }) async {
    requestedFilters.add(filter);
    requestedCursors.add(cursor);
    // Stronę i błąd czytamy przed opóźnieniem: odpowiedź odpowiada stanowi
    // z chwili żądania, więc test naprawdę rozstrzyga, kto wygrywa wyścig.
    final error = cursor != null ? loadMoreFailure : failure;
    final result = cursor != null
        ? (loadMorePage ?? ChatInboxPage.empty)
        : (page ?? ChatInboxPage.empty);
    if (cursor == null &&
        filter == ChatInboxFilter.unread &&
        unreadDelay != null) {
      await Future<void>.delayed(unreadDelay!);
    }
    if (error != null) return Left(error);
    return Right(result);
  }

  @override
  Future<Either<ApiError, ChatInboxUnreadCount>> loadUnreadCount() async {
    unreadCountCalls++;
    final value = counts;
    if (value == null) return Left(_parsingError());
    return Right(value);
  }

  @override
  Future<Either<ApiError, void>> markRead({
    required String conversationId,
    required String messageId,
  }) async => const Right(null);

  static ApiError _parsingError() => const ApiError(
    type: ApiErrorType.parsing,
    message: 'chat.inbox.unread_count_failed',
    apiCode: 'chat.inbox.unread_count_failed',
  );
}

ChatInboxItem item({
  required String id,
  required String name,
  int unread = 0,
  bool muted = false,
  bool draft = false,
  String? draftText,
  String? preview,
}) => ChatInboxItem(
  conversation: ChatConversation(
    id: id,
    type: 'direct',
    scopeKind: 'global',
    scopeKey: 'direct:global:$id',
    version: 1,
    createdAtUtc: DateTime.utc(2026, 9, 21),
    postingPermission: 'Everyone',
    isArchived: false,
    name: name,
  ),
  lastActivityAtUtc: DateTime.utc(2026, 9, 21, 12),
  unreadCount: unread,
  isMuted: muted,
  isDraft: draft,
  draftText: draftText,
  participantCount: 2,
  lastMessage: preview == null
      ? null
      : ChatInboxMessagePreview(
          messageId: '$id-message',
          authorUserId: 'peer',
          text: preview,
          isDeleted: false,
          hasAttachments: false,
          createdAtUtc: DateTime.utc(2026, 9, 21, 12),
        ),
);

ChatInboxUnreadCount counts(int total, int conversations) =>
    ChatInboxUnreadCount(
      totalUnreadCount: total,
      unreadConversationCount: conversations,
      generatedAtUtc: DateTime.utc(2026, 9, 21, 12),
    );

void main() {
  group('ChatInboxCubit', () {
    test(
      'pierwsza strona używa serwerowego licznika, nie sumy pozycji',
      () async {
        final repository = _InboxRepositoryFake(
          page: ChatInboxPage(
            items: <ChatInboxItem>[item(id: 'c1', name: 'Ala', unread: 2)],
            hasMore: true,
            nextCursor: 'next',
          ),
          counts: counts(7, 3),
        );
        final cubit = ChatInboxCubit(repository: repository);

        await cubit.load();

        final state = cubit.state;
        expect(state, isA<ChatInboxReady>());
        final ready = state as ChatInboxReady;
        expect(ready.items, hasLength(1));
        expect(
          ready.unreadTotal,
          7,
          reason:
              'licznik pochodzi z agregatu serwera i obejmuje wszystkie strony',
        );
        expect(ready.hasMore, isTrue);
        expect(ready.nextCursor, 'next');
      },
    );

    test('pusta strona daje stan pusty, a błąd nie udaje pustki', () async {
      final emptyCubit = ChatInboxCubit(
        repository: _InboxRepositoryFake(
          page: ChatInboxPage.empty,
          counts: counts(0, 0),
        ),
      );
      await emptyCubit.load();
      expect(emptyCubit.state, isA<ChatInboxEmpty>());

      final failingCubit = ChatInboxCubit(
        repository: _InboxRepositoryFake(
          failure: const ApiError(
            type: ApiErrorType.server,
            message: 'chat.inbox.load_failed',
            apiCode: 'chat.inbox.load_failed',
          ),
        ),
      );
      await failingCubit.load();
      expect(failingCubit.state, isA<ChatInboxFailure>());
    });

    test('zmiana filtra pobiera stronę od nowa bez kursora', () async {
      final repository = _InboxRepositoryFake(
        page: ChatInboxPage(
          items: <ChatInboxItem>[item(id: 'c1', name: 'Ala')],
          nextCursor: 'next',
          hasMore: true,
        ),
        counts: counts(0, 0),
      );
      final cubit = ChatInboxCubit(repository: repository);
      await cubit.load();
      repository.requestedCursors.clear();

      await cubit.setFilter(ChatInboxFilter.unread);

      expect(repository.requestedFilters.last, ChatInboxFilter.unread);
      expect(repository.requestedCursors, <String?>[null]);
      expect(cubit.filter, ChatInboxFilter.unread);
    });

    test('kolejna strona dokłada pozycje i respektuje koniec listy', () async {
      final repository = _InboxRepositoryFake(
        page: ChatInboxPage(
          items: <ChatInboxItem>[item(id: 'c1', name: 'Ala')],
          hasMore: true,
          nextCursor: 'next',
        ),
        counts: counts(1, 1),
        loadMorePage: ChatInboxPage(
          items: <ChatInboxItem>[item(id: 'c2', name: 'Ola')],
          hasMore: false,
        ),
      );
      final cubit = ChatInboxCubit(repository: repository);
      await cubit.load();

      await cubit.loadMore();

      final ready = cubit.state as ChatInboxReady;
      expect(ready.items.map((entry) => entry.conversation.id), <String>[
        'c1',
        'c2',
      ]);
      expect(ready.hasMore, isFalse);
      expect(ready.nextCursor, isNull);

      await cubit.loadMore();
      expect(repository.requestedCursors, <String?>[
        null,
        'next',
      ], reason: 'bez kursora nie ma kolejnego pobrania');
    });

    test('błąd kolejnej strony zachowuje listę i pozwala ponowić', () async {
      final repository = _InboxRepositoryFake(
        page: ChatInboxPage(
          items: <ChatInboxItem>[item(id: 'c1', name: 'Ala')],
          hasMore: true,
          nextCursor: 'next',
        ),
        counts: counts(1, 1),
        loadMoreFailure: const ApiError(
          type: ApiErrorType.server,
          message: 'chat.inbox.load_failed',
          apiCode: 'chat.inbox.load_failed',
        ),
      );
      final cubit = ChatInboxCubit(repository: repository);
      await cubit.load();

      await cubit.loadMore();

      final ready = cubit.state as ChatInboxReady;
      expect(ready.items, hasLength(1));
      expect(ready.loadMoreFailed, isTrue);
      expect(ready.isLoadingMore, isFalse);
      expect(ready.nextCursor, 'next');
    });

    test(
      'pusta strona z hasMore zachowuje kursor do dalszych rozmów',
      () async {
        final repository = _InboxRepositoryFake(counts: counts(0, 0))
          ..page = const ChatInboxPage(
            items: <ChatInboxItem>[],
            hasMore: true,
            nextCursor: 'next',
          );
        final cubit = ChatInboxCubit(repository: repository);

        await cubit.load();

        expect(
          cubit.state,
          isA<ChatInboxReady>(),
          reason: 'pusta strona z hasMore nie może udawać braku rozmów',
        );
        final ready = cubit.state as ChatInboxReady;
        expect(ready.items, isEmpty);
        expect(ready.hasMore, isTrue);
        expect(ready.nextCursor, 'next');
        await cubit.close();
      },
    );

    test('pusta strona bez hasMore to prawdziwy brak rozmów', () async {
      final cubit = ChatInboxCubit(
        repository: _InboxRepositoryFake(
          page: ChatInboxPage.empty,
          counts: counts(0, 0),
        ),
      );

      await cubit.load();

      expect(cubit.state, isA<ChatInboxEmpty>());
      await cubit.close();
    });

    test(
      'wolniejsza odpowiedź starszego filtra nie zastępuje nowszej listy',
      () async {
        final repository = _InboxRepositoryFake(
          page: ChatInboxPage(
            items: <ChatInboxItem>[item(id: 'c1', name: 'Ala')],
            hasMore: false,
          ),
          counts: counts(1, 1),
        );
        final cubit = ChatInboxCubit(repository: repository);

        // Start filtra Unread (odpowiedź opóźniona), potem Direct: wolny wynik
        // pierwszego żądania dociera jako ostatni i nie może nadpisać stanu.
        repository.unreadDelay = const Duration(milliseconds: 80);
        final slow = cubit.setFilter(ChatInboxFilter.unread);
        repository.page = ChatInboxPage(
          items: <ChatInboxItem>[item(id: 'c2', name: 'Ola')],
          hasMore: false,
        );
        await cubit.setFilter(ChatInboxFilter.direct);
        await slow;
        await Future<void>.delayed(const Duration(milliseconds: 120));

        final ready = cubit.state as ChatInboxReady;
        expect(ready.filter, ChatInboxFilter.direct);
        expect(
          ready.items.single.conversation.id,
          'c2',
          reason: 'stan musi pochodzić z ostatniego żądania',
        );
        await cubit.close();
      },
    );

    test(
      'odświeżenie licznika aktualizuje badge bez pobierania stron',
      () async {
        final repository = _InboxRepositoryFake(
          page: ChatInboxPage(
            items: <ChatInboxItem>[item(id: 'c1', name: 'Ala', unread: 3)],
            hasMore: false,
          ),
          counts: counts(3, 1),
        );
        final cubit = ChatInboxCubit(repository: repository);
        await cubit.load();
        expect((cubit.state as ChatInboxReady).unreadTotal, 3);
        repository.requestedFilters.clear();

        repository.counts = counts(0, 0);
        await cubit.refreshUnreadTotal();

        expect((cubit.state as ChatInboxReady).unreadTotal, 0);
        expect(
          repository.requestedFilters,
          isEmpty,
          reason: 'licznik nie pobiera stron skrzynki',
        );
      },
    );
  });
}
