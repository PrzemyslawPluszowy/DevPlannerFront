import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/conversation/models/chat_conversation_models_export.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_presence_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_presence_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const refreshInterval = Duration(hours: 1);

  test(
    'batches direct peers, keeps online and offline distinct, excludes groups',
    () async {
      final inbox = ChatInboxCubit(
        repository: _InboxRepository(
          _page([
            _item('conversation-a', peer: 'peer-online'),
            _item('conversation-b', peer: 'peer-offline'),
            _item('group', peer: 'group-member', type: 'group'),
          ]),
        ),
      );
      await inbox.load();
      final repository = _PresenceRepository()
        ..response = const Right<ApiError, Map<String, bool>>({
          'peer-online': true,
          'peer-offline': false,
        });
      final presence = ChatInboxPresenceCubit(
        inbox: inbox,
        repository: repository,
        currentUserId: 'me',
        refreshInterval: refreshInterval,
      );
      addTearDown(presence.close);
      addTearDown(inbox.close);

      await _waitFor(() => presence.state.statuses.length == 2);

      expect(repository.requests, [
        ['peer-offline', 'peer-online'],
      ]);
      expect(presence.state.statusFor('peer-online'), isTrue);
      expect(presence.state.statusFor('peer-offline'), isFalse);
      expect(presence.state.statusFor('group-member'), isNull);
    },
  );

  test(
    'a batch failure leaves peers unknown rather than marking offline',
    () async {
      final inbox = ChatInboxCubit(
        repository: _InboxRepository(
          _page([_item('conversation', peer: 'peer')]),
        ),
      );
      await inbox.load();
      final repository = _PresenceRepository()
        ..response = const Left(
          ApiError(
            type: ApiErrorType.connection,
            message: 'chat.inbox.presence_failed',
          ),
        );
      final presence = ChatInboxPresenceCubit(
        inbox: inbox,
        repository: repository,
        currentUserId: 'me',
        refreshInterval: refreshInterval,
      );
      addTearDown(presence.close);
      addTearDown(inbox.close);

      await _waitFor(() => presence.state.error != null);

      expect(presence.state.statusFor('peer'), isNull);
    },
  );

  test(
    'refresh keeps last successful statuses until the new batch finishes',
    () async {
      final inbox = ChatInboxCubit(
        repository: _InboxRepository(
          _page([_item('conversation', peer: 'peer')]),
        ),
      );
      await inbox.load();
      final delayed = Completer<Either<ApiError, Map<String, bool>>>();
      final repository = _PresenceRepository()
        ..response = const Right({'peer': true});
      final presence = ChatInboxPresenceCubit(
        inbox: inbox,
        repository: repository,
        currentUserId: 'me',
        refreshInterval: refreshInterval,
      );
      addTearDown(presence.close);
      addTearDown(inbox.close);
      await _waitFor(() => presence.state.statusFor('peer') == true);
      repository.responses.add(delayed.future);
      final emitted = <ChatInboxPresenceState>[];
      final subscription = presence.stream.listen(emitted.add);

      final refresh = presence.refresh();
      await _waitFor(() => presence.state.isRefreshing);
      expect(presence.state.statusFor('peer'), isTrue);
      expect(emitted.any((state) => state.statuses.isEmpty), isFalse);
      delayed.complete(const Right({'peer': false}));
      await refresh;
      await subscription.cancel();

      expect(presence.state.statusFor('peer'), isFalse);
    },
  );

  test('archived peers are excluded from the live batch', () async {
    final inbox = ChatInboxCubit(
      repository: _InboxRepository(
        _page([
          _item('conversation-archived', peer: 'archived', archived: true),
        ]),
      ),
    );
    await inbox.load();
    final repository = _PresenceRepository();
    final presence = ChatInboxPresenceCubit(
      inbox: inbox,
      repository: repository,
      currentUserId: 'me',
      refreshInterval: refreshInterval,
    );
    addTearDown(presence.close);
    addTearDown(inbox.close);
    await Future<void>.delayed(const Duration(milliseconds: 5));
    expect(repository.requests, isEmpty);
  });

  test(
    'forbidden batch stops periodic retries until inbox scope changes',
    () async {
      final inbox = ChatInboxCubit(
        repository: _InboxRepository(
          _page([_item('conversation', peer: 'peer')]),
        ),
      );
      await inbox.load();
      final repository = _PresenceRepository()
        ..response = const Left(
          ApiError(
            type: ApiErrorType.forbidden,
            message: 'denied',
            statusCode: 403,
          ),
        );
      final presence = ChatInboxPresenceCubit(
        inbox: inbox,
        repository: repository,
        currentUserId: 'me',
        refreshInterval: const Duration(milliseconds: 2),
      );
      addTearDown(presence.close);
      addTearDown(inbox.close);
      await _waitFor(() => presence.state.error != null);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(repository.requests, hasLength(1));
    },
  );

  test('429 retry-after blocks scheduled and manual early requests', () async {
    final now = DateTime.utc(2026, 10, 2);
    final inbox = ChatInboxCubit(
      repository: _InboxRepository(
        _page([_item('conversation', peer: 'peer')]),
      ),
    );
    await inbox.load();
    final repository = _PresenceRepository()
      ..response = Left(
        ApiError(
          type: ApiErrorType.badResponse,
          message: 'limited',
          statusCode: 429,
          retryAfterUtc: now.add(const Duration(minutes: 1)),
        ),
      );
    final presence = ChatInboxPresenceCubit(
      inbox: inbox,
      repository: repository,
      currentUserId: 'me',
      refreshInterval: const Duration(milliseconds: 2),
      nowUtc: () => now,
    );
    addTearDown(presence.close);
    addTearDown(inbox.close);
    await _waitFor(() => presence.state.retryCountdownSeconds > 0);
    await presence.refresh();
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(repository.requests, hasLength(1));
  });

  test('a successful snapshot expires after the bounded stale age', () async {
    final inbox = ChatInboxCubit(
      repository: _InboxRepository(
        _page([_item('conversation', peer: 'peer')]),
      ),
    );
    await inbox.load();
    final presence = ChatInboxPresenceCubit(
      inbox: inbox,
      repository: _PresenceRepository()..response = const Right({'peer': true}),
      currentUserId: 'me',
      refreshInterval: refreshInterval,
      maxStaleAge: const Duration(milliseconds: 3),
    );
    addTearDown(presence.close);
    addTearDown(inbox.close);
    await _waitFor(() => presence.state.statusFor('peer') == true);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(presence.state.statusFor('peer'), isNull);
  });

  test(
    'manual retry refreshes inbox after revoked peer batch failure',
    () async {
      final inboxRepository = _InboxRepository(
        _page([_item('conversation-old', peer: 'peer-revoked')]),
      );
      final inbox = ChatInboxCubit(repository: inboxRepository);
      await inbox.load();
      final repository = _PresenceRepository()
        ..response = const Right({'peer-valid': true})
        ..responses.add(
          Future.value(
            const Left(
              ApiError(
                type: ApiErrorType.forbidden,
                message: 'denied',
                statusCode: 403,
              ),
            ),
          ),
        )
        ..responses.add(
          Future.value(const Right({'peer-revoked': false})),
        )
        ..responses.add(Future.value(const Right({'peer-valid': true})));
      final presence = ChatInboxPresenceCubit(
        inbox: inbox,
        repository: repository,
        currentUserId: 'me',
        refreshInterval: const Duration(milliseconds: 5),
      );
      addTearDown(presence.close);
      addTearDown(inbox.close);
      await _waitFor(() => presence.state.error != null);

      inboxRepository.page = _page([
        _item('conversation-valid', peer: 'peer-valid'),
      ]);
      await presence.retry();
      expect(repository.requests.last, ['peer-valid']);
      expect(presence.state.error, isNull);
      await _waitFor(() => presence.state.statusFor('peer-valid') == true);
      await _waitFor(() => repository.requests.length >= 3);

      expect(repository.requests.last, ['peer-valid']);
    },
  );

  test(
    'stale result is discarded and the changed inbox peers are refreshed',
    () async {
      final inboxRepository = _InboxRepository(
        _page([_item('conversation-old', peer: 'peer-old')]),
      );
      final inbox = ChatInboxCubit(repository: inboxRepository);
      await inbox.load();
      final staleResponse = Completer<Either<ApiError, Map<String, bool>>>();
      final repository = _PresenceRepository()
        ..responses.add(staleResponse.future)
        ..responses.add(Future.value(const Right({'peer-new': false})));
      final presence = ChatInboxPresenceCubit(
        inbox: inbox,
        repository: repository,
        currentUserId: 'me',
        refreshInterval: refreshInterval,
      );
      addTearDown(presence.close);
      addTearDown(inbox.close);
      await _waitFor(() => repository.requests.length == 1);

      inboxRepository.page = _page([
        _item('conversation-new', peer: 'peer-new'),
      ]);
      await inbox.refresh();
      staleResponse.complete(const Right({'peer-old': true}));
      await _waitFor(() => presence.state.statusFor('peer-new') == false);

      expect(repository.requests, [
        ['peer-old'],
        ['peer-new'],
      ]);
      expect(presence.state.statusFor('peer-old'), isNull);
    },
  );

  test(
    'session changes clear cached status and sign-in refreshes it',
    () async {
      final inbox = ChatInboxCubit(
        repository: _InboxRepository(
          _page([_item('conversation', peer: 'peer')]),
        ),
      );
      await inbox.load();
      final session = AuthSessionController(
        initial: const AuthSessionSnapshot(
          status: AuthSessionStatus.signedIn,
          user: AuthUser(userId: 'me', login: 'me', displayName: 'Me'),
        ),
      );
      final repository = _PresenceRepository()
        ..response = const Right({'peer': true});
      final presence = ChatInboxPresenceCubit(
        inbox: inbox,
        repository: repository,
        currentUserId: 'me',
        authSession: session,
        refreshInterval: refreshInterval,
      );
      addTearDown(presence.close);
      addTearDown(inbox.close);
      await _waitFor(() => presence.state.statusFor('peer') == true);

      session.setSignedOut();
      expect(presence.state.statuses, isEmpty);
      session.setSignedIn(
        const AuthUser(
          userId: 'foreign',
          login: 'foreign',
          displayName: 'Other',
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(repository.requests, hasLength(1));
      expect(presence.state.statuses, isEmpty);
      session.setSignedIn(
        const AuthUser(userId: 'me', login: 'me', displayName: 'Me'),
      );
      await _waitFor(() => repository.requests.length == 2);

      expect(presence.state.statusFor('peer'), isTrue);
    },
  );

  test('foreign owner at creation never queries inbox peers', () async {
    final inbox = ChatInboxCubit(
      repository: _InboxRepository(
        _page([_item('conversation', peer: 'peer')]),
      ),
    );
    await inbox.load();
    final session = AuthSessionController(
      initial: const AuthSessionSnapshot(
        status: AuthSessionStatus.signedIn,
        user: AuthUser(
          userId: 'foreign',
          login: 'foreign',
          displayName: 'Other',
        ),
      ),
    );
    final repository = _PresenceRepository();
    final presence = ChatInboxPresenceCubit(
      inbox: inbox,
      repository: repository,
      currentUserId: 'me',
      authSession: session,
      refreshInterval: refreshInterval,
    );
    addTearDown(presence.close);
    addTearDown(inbox.close);
    await Future<void>.delayed(const Duration(milliseconds: 5));

    expect(repository.requests, isEmpty);
    expect(presence.state.statuses, isEmpty);
  });

  test('closing during a pending batch prevents a late state update', () async {
    final inbox = ChatInboxCubit(
      repository: _InboxRepository(
        _page([_item('conversation', peer: 'peer')]),
      ),
    );
    await inbox.load();
    final response = Completer<Either<ApiError, Map<String, bool>>>();
    final repository = _PresenceRepository()..responses.add(response.future);
    final presence = ChatInboxPresenceCubit(
      inbox: inbox,
      repository: repository,
      currentUserId: 'me',
      refreshInterval: refreshInterval,
    );
    await _waitFor(() => repository.requests.isNotEmpty);
    final emissions = <ChatInboxPresenceState>[];
    final subscription = presence.stream.listen(emissions.add);

    await presence.close();
    response.complete(const Right({'peer': true}));
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();
    await inbox.close();

    expect(emissions, isEmpty);
  });
}

Future<void> _waitFor(bool Function() condition) async {
  for (var i = 0; i < 100 && !condition(); i++) {
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }
  expect(condition(), isTrue);
}

ChatInboxPage _page(List<ChatInboxItem> items) =>
    ChatInboxPage(items: items, hasMore: false);

ChatInboxItem _item(
  String conversationId, {
  required String peer,
  String type = 'direct',
  bool archived = false,
}) => ChatInboxItem(
  conversation: ChatConversation(
    id: conversationId,
    type: type,
    scopeKind: 'global',
    scopeKey: conversationId,
    version: 1,
    createdAtUtc: DateTime.utc(2026),
    postingPermission: 'Everyone',
    isArchived: archived,
  ),
  lastActivityAtUtc: DateTime.utc(2026),
  unreadCount: 0,
  isMuted: false,
  isDraft: false,
  participantCount: type == 'direct' ? 2 : 3,
  // The peer id is a runtime fixture parameter, so this list cannot be const.
  participants: [
    const ChatInboxParticipant(userId: 'me', isCurrentUser: true),
    ChatInboxParticipant(userId: peer, isCurrentUser: false),
  ],
);

final class _InboxRepository implements ChatInboxRepository {
  _InboxRepository(this.page);

  ChatInboxPage page;

  @override
  Future<Either<ApiError, ChatInboxPage>> loadInbox({
    ChatInboxFilter filter = ChatInboxFilter.all,
    String? cursor,
    int? limit,
    String? query,
  }) async => Right(page);

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

final class _PresenceRepository implements ChatInboxPresenceRepository {
  final List<List<String>> requests = [];
  final List<Future<Either<ApiError, Map<String, bool>>>> responses = [];
  Either<ApiError, Map<String, bool>> response = const Right({});

  @override
  Future<Either<ApiError, Map<String, bool>>> loadPresence(
    List<String> userIds,
  ) {
    requests.add(List.unmodifiable(userIds));
    if (responses.isNotEmpty) return responses.removeAt(0);
    return Future.value(response);
  }
}
