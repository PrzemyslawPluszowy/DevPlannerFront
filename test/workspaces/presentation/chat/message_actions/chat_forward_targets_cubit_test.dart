import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_forward_targets_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/message_actions/cubit/chat_forward_targets_state.dart';
import 'package:flutter_test/flutter_test.dart';

final class _InboxCall {
  const _InboxCall({this.cursor, this.query, required this.filter});

  final String? cursor;
  final String? query;
  final ChatInboxFilter filter;
}

final class _InboxRepository implements ChatInboxRepository {
  final calls = <_InboxCall>[];
  final pages = <String?, ChatInboxPage>{};
  final queryPages = <String?, ChatInboxPage>{};
  final failuresByCursor = <String?, ApiError>{};
  final delayedQueries = <String, Completer<Either<ApiError, ChatInboxPage>>>{};
  int unreadCountCalls = 0;

  @override
  Future<Either<ApiError, ChatInboxPage>> loadInbox({
    ChatInboxFilter filter = ChatInboxFilter.all,
    String? cursor,
    int? limit,
    String? query,
  }) async {
    calls.add(_InboxCall(cursor: cursor, query: query, filter: filter));
    final delayed = query == null ? null : delayedQueries[query];
    if (delayed != null) return delayed.future;
    final failure = failuresByCursor[cursor];
    if (failure != null) return Left(failure);
    final page = cursor == null && query != null
        ? queryPages[query]
        : pages[cursor];
    return Right(page ?? ChatInboxPage.empty);
  }

  @override
  Future<Either<ApiError, ChatInboxUnreadCount>> loadUnreadCount() async {
    unreadCountCalls++;
    return Right(
      ChatInboxUnreadCount(
        totalUnreadCount: 0,
        unreadConversationCount: 0,
        generatedAtUtc: DateTime.utc(2026),
      ),
    );
  }

  @override
  Future<Either<ApiError, void>> markRead({
    required String conversationId,
    required String messageId,
  }) async => const Right(null);
}

ChatInboxItem _item(String id, String name) => ChatInboxItem(
  conversation: ChatConversation(
    id: id,
    type: 'direct',
    scopeKind: 'global',
    scopeKey: 'direct:global:$id',
    version: 1,
    createdAtUtc: DateTime.utc(2026),
    postingPermission: 'Everyone',
    isArchived: false,
    name: name,
  ),
  lastActivityAtUtc: DateTime.utc(2026),
  unreadCount: 0,
  isMuted: false,
  isDraft: false,
  participantCount: 2,
);

void main() {
  group('ChatForwardTargetsCubit', () {
    test('loads next server page and excludes source conversation', () async {
      final repository = _InboxRepository()
        ..pages[null] = ChatInboxPage(
          items: <ChatInboxItem>[
            _item('source', 'Źródło'),
            _item('one', 'Pierwsza'),
          ],
          hasMore: true,
          nextCursor: 'cursor-2',
        )
        ..pages['cursor-2'] = ChatInboxPage(
          items: <ChatInboxItem>[
            _item('source', 'Źródło'),
            _item('two', 'Druga'),
          ],
          hasMore: false,
        );
      final cubit = ChatForwardTargetsCubit(
        repository: repository,
        excludedConversationId: 'source',
        queryDebounce: Duration.zero,
      );

      await cubit.load();
      expect(cubit.state, isA<ChatForwardTargetsReady>());
      expect(
        (cubit.state as ChatForwardTargetsReady).items.map(
          (item) => item.conversation.id,
        ),
        <String>['one'],
      );
      await cubit.loadMore();

      final state = cubit.state as ChatForwardTargetsReady;
      expect(
        state.items.map((item) => item.conversation.id),
        <String>['one', 'two'],
      );
      expect(repository.calls.map((call) => call.cursor), <String?>[
        null,
        'cursor-2',
      ]);
      await cubit.close();
    });

    test(
      'sends search to server without changing global inbox query',
      () async {
        final repository = _InboxRepository()
          ..pages[null] = ChatInboxPage(
            items: <ChatInboxItem>[_item('global', 'Global result')],
            hasMore: false,
          )
          ..queryPages['remote query'] = ChatInboxPage(
            items: <ChatInboxItem>[_item('remote', 'Remote result')],
            hasMore: false,
          )
          ..queryPages['global query'] = ChatInboxPage(
            items: <ChatInboxItem>[_item('global', 'Global result')],
            hasMore: false,
          );
        final globalInbox = ChatInboxCubit(repository: repository);
        await globalInbox.load();
        await globalInbox.setQuery('global query');
        final globalBefore = globalInbox.state as ChatInboxReady;
        final picker = ChatForwardTargetsCubit(
          repository: repository,
          excludedConversationId: 'source',
          queryDebounce: Duration.zero,
        );
        await picker.load();
        await picker.setQuery('remote query');

        expect(repository.calls.last.query, 'remote query');
        expect(repository.calls.last.filter, ChatInboxFilter.all);
        expect(
          (picker.state as ChatForwardTargetsReady)
              .items
              .single
              .conversation
              .id,
          'remote',
        );
        expect(globalInbox.query, 'global query');
        expect(globalInbox.state, same(globalBefore));
        expect(repository.unreadCountCalls, 2);
        await picker.close();
        await globalInbox.close();
      },
    );

    test(
      'keeps results after a later-page error and retries that cursor',
      () async {
        const pageError = ApiError(
          type: ApiErrorType.server,
          message: 'chat.inbox.load_failed',
          apiCode: 'chat.inbox.load_failed',
          contractCode: 'chat.inbox.load_failed',
          statusCode: 503,
          traceId: 'trace-forward-cursor',
          fields: <String, List<String>>{
            'cursor': <String>['expired'],
          },
        );
        final repository = _InboxRepository()
          ..pages[null] = ChatInboxPage(
            items: <ChatInboxItem>[_item('one', 'Pierwsza')],
            hasMore: true,
            nextCursor: 'next',
          )
          ..pages['next'] = ChatInboxPage(
            items: <ChatInboxItem>[_item('two', 'Druga')],
            hasMore: false,
          )
          ..failuresByCursor['next'] = pageError;
        final cubit = ChatForwardTargetsCubit(
          repository: repository,
          excludedConversationId: 'source',
        );
        await cubit.load();
        await cubit.loadMore();
        final failed = cubit.state as ChatForwardTargetsReady;
        expect(failed.items.single.conversation.id, 'one');
        expect(failed.loadMoreError, pageError);
        expect(failed.loadMoreError?.statusCode, 503);
        expect(failed.loadMoreError?.traceId, 'trace-forward-cursor');
        expect(failed.loadMoreError?.fields['cursor'], <String>['expired']);

        repository.failuresByCursor.remove('next');
        await cubit.loadMore();
        final recovered = cubit.state as ChatForwardTargetsReady;
        expect(
          recovered.items.map((item) => item.conversation.id),
          <String>['one', 'two'],
        );
        expect(recovered.loadMoreError, isNull);
        await cubit.close();
      },
    );

    test('keeps full first-page ApiError and retries the same query', () async {
      const firstError = ApiError(
        type: ApiErrorType.validation,
        message: 'Nieprawidłowe zapytanie',
        apiCode: 'chat.inbox.query_invalid',
        contractCode: 'validation.failed',
        statusCode: 422,
        traceId: 'trace-forward-first-page',
        fields: <String, List<String>>{
          'query': <String>['too_long'],
        },
      );
      final repository = _InboxRepository()
        ..failuresByCursor[null] = firstError
        ..queryPages['query text'] = ChatInboxPage(
          items: <ChatInboxItem>[_item('target', 'Cel')],
          hasMore: false,
        );
      final cubit = ChatForwardTargetsCubit(
        repository: repository,
        excludedConversationId: 'source',
      );
      await cubit.setQuery('query text');
      final failed = cubit.state as ChatForwardTargetsFailure;
      expect(failed.error, firstError);
      expect(failed.error.contractCode, 'validation.failed');
      expect(failed.error.statusCode, 422);
      expect(failed.error.traceId, 'trace-forward-first-page');
      expect(failed.error.fields['query'], <String>['too_long']);

      repository.failuresByCursor.remove(null);
      await cubit.retry();
      expect(cubit.state, isA<ChatForwardTargetsReady>());
      expect(repository.calls.last.query, 'query text');
      await cubit.close();
    });

    test('a newer query wins when an older request completes later', () async {
      final oldResult = Completer<Either<ApiError, ChatInboxPage>>();
      final repository = _InboxRepository()
        ..delayedQueries['older query'] = oldResult
        ..queryPages['newer query'] = ChatInboxPage(
          items: <ChatInboxItem>[_item('newer', 'Nowszy wynik')],
          hasMore: false,
        );
      final cubit = ChatForwardTargetsCubit(
        repository: repository,
        excludedConversationId: 'source',
        queryDebounce: Duration.zero,
      );
      final olderRequest = cubit.setQuery('older query');
      await Future<void>.delayed(const Duration(milliseconds: 1));
      expect(repository.calls.last.query, 'older query');

      await cubit.setQuery('newer query');
      expect(
        (cubit.state as ChatForwardTargetsReady).items.single.conversation.id,
        'newer',
      );
      oldResult.complete(
        Right(
          ChatInboxPage(
            items: <ChatInboxItem>[_item('older', 'Starszy wynik')],
            hasMore: false,
          ),
        ),
      );
      await olderRequest;
      expect(
        (cubit.state as ChatForwardTargetsReady).items.single.conversation.id,
        'newer',
      );
      await cubit.close();
    });

    test('closing the picker discards an in-flight query response', () async {
      final pending = Completer<Either<ApiError, ChatInboxPage>>();
      final repository = _InboxRepository()
        ..delayedQueries['closing query'] = pending;
      final cubit = ChatForwardTargetsCubit(
        repository: repository,
        excludedConversationId: 'source',
        queryDebounce: Duration.zero,
      );
      final closingRequest = cubit.setQuery('closing query');
      await Future<void>.delayed(const Duration(milliseconds: 1));
      expect(repository.calls.last.query, 'closing query');
      final stateAtClose = cubit.state;
      await cubit.close();

      pending.complete(
        Right(
          ChatInboxPage(
            items: <ChatInboxItem>[_item('late', 'Spóźniony wynik')],
            hasMore: false,
          ),
        ),
      );
      await closingRequest;
      expect(cubit.state, same(stateAtClose));
    });
  });
}
