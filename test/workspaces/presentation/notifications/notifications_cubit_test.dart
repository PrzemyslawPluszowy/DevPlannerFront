import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/notifications/models/notification_models.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/notification_enums.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_cubit.dart';
import 'package:ready_next/workspaces/presentation/notifications/cubit/notifications_state.dart';

class _FakeNotificationsRepository implements NotificationsRepository {
  _FakeNotificationsRepository({
    required this.groupsResult,
    required this.countResult,
  });

  Either<ApiError, List<NotificationGroupResponse>> groupsResult;
  List<CursorPageResponse<NotificationGroupResponse>>? groupPages;
  String? groupNextCursor;
  Either<ApiError, int> countResult;
  Completer<Either<ApiError, List<NotificationGroupResponse>>>?
  listGroupsCompleter;
  int listGroupsCalls = 0;
  Either<ApiError, void> markAllReadResult = const Right(null);
  Either<ApiError, void> markGroupReadResult = const Right(null);
  Either<ApiError, void> archiveGroupResult = const Right(null);
  Either<ApiError, void> quickActionResult = const Right(null);
  Completer<Either<ApiError, void>>? markAllReadCompleter;
  Completer<Either<ApiError, void>>? markGroupReadCompleter;
  Completer<Either<ApiError, void>>? archiveGroupCompleter;
  Completer<Either<ApiError, void>>? quickActionCompleter;
  int markAllReadCalls = 0;

  @override
  Future<Either<ApiError, int>> unreadCount() async => countResult;

  @override
  Future<Either<ApiError, CursorPageResponse<WorkspaceNotificationResponse>>>
  listNotifications({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  }) async => const Right(CursorPageResponse(items: []));

  @override
  Future<Either<ApiError, CursorPageResponse<NotificationGroupResponse>>>
  listGroups({
    String? cursor,
    int limit = 30,
    NotificationCategory? category,
    bool unreadOnly = false,
  }) async {
    listGroupsCalls++;
    final completer = listGroupsCompleter;
    final pages = groupPages;
    if (pages != null) {
      return Right(
        pages[(listGroupsCalls - 1).clamp(0, pages.length - 1)],
      );
    }
    final result = await (completer?.future ?? Future.value(groupsResult));
    return result.map(
      (groups) =>
          CursorPageResponse(items: groups, nextCursor: groupNextCursor),
    );
  }

  @override
  Future<Either<ApiError, void>> markAllRead() async {
    markAllReadCalls++;
    final completer = markAllReadCompleter;
    if (completer != null) return completer.future;
    return markAllReadResult;
  }

  @override
  Future<Either<ApiError, void>> markGroupRead(String groupKey) async {
    final completer = markGroupReadCompleter;
    return completer?.future ?? markGroupReadResult;
  }

  @override
  Future<Either<ApiError, void>> archiveGroup(String groupKey) async {
    final completer = archiveGroupCompleter;
    return completer?.future ?? archiveGroupResult;
  }

  @override
  Future<Either<ApiError, void>> quickAction(
    String notificationId,
    NotificationQuickActionKind action,
  ) async => quickActionCompleter?.future ?? quickActionResult;
}

abstract final class NotificationsFixture {
  static WorkspaceNotificationResponse notification({String? deepLink}) =>
      WorkspaceNotificationResponse(
        id: '11111111-1111-4111-8111-111111111111',
        sourceModule: 'workspaces',
        eventType: 'workspace.created',
        entityType: 'workspace',
        entityId: '22222222-2222-4222-8222-222222222222',
        title: 'Nowy workspace',
        body: 'Utworzono workspace testowy.',
        deepLink: deepLink,
        eventId: '33333333-3333-4333-8333-333333333333',
        contractVersion: 1,
        createdAtUtc: DateTime.utc(2026),
        isPinned: false,
        category: NotificationCategory.workspace,
        priority: NotificationPriority.normal,
      );

  static NotificationGroupResponse group({String? deepLink}) =>
      NotificationGroupResponse(
        groupKey: 'workspace:22222222-2222-4222-8222-222222222222',
        count: 1,
        unreadCount: 1,
        latest: notification(deepLink: deepLink),
        notificationIds: const ['11111111-1111-4111-8111-111111111111'],
      );
}

void main() {
  test('emituje gotową skrzynkę z grupami i licznikiem', () async {
    final repository = _FakeNotificationsRepository(
      groupsResult: Right([
        NotificationsFixture.group(deepLink: '/notifications'),
      ]),
      countResult: const Right(3),
    );
    final cubit = NotificationsCubit(repository);
    addTearDown(cubit.close);

    await cubit.load();

    final state = cubit.state;
    expect(state, isA<NotificationsReady>());
    expect((state as NotificationsReady).groups, hasLength(1));
    expect(state.unreadCount, 3);
  });

  test(
    'pusta lista jest osobnym stanem, nawet gdy licznik wynosi zero',
    () async {
      final cubit = NotificationsCubit(
        _FakeNotificationsRepository(
          groupsResult: const Right([]),
          countResult: const Right(0),
        ),
      );
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state, isA<NotificationsEmpty>());
    },
  );

  test('nie ukrywa błędu autoryzacji backendu', () async {
    final cubit = NotificationsCubit(
      _FakeNotificationsRepository(
        groupsResult: const Left(
          ApiError(
            type: ApiErrorType.unauthorized,
            message: 'Wymagane jest poprawne uwierzytelnienie.',
          ),
        ),
        countResult: const Right(0),
      ),
    );
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state, isA<NotificationsUnauthorized>());
    expect(
      (cubit.state as NotificationsUnauthorized).message,
      'Wymagane jest poprawne uwierzytelnienie.',
    );
  });

  test('oznaczenie wszystkich jako przeczytanych odświeża skrzynkę', () async {
    final repository = _FakeNotificationsRepository(
      groupsResult: Right([NotificationsFixture.group()]),
      countResult: const Right(1),
    );
    final cubit = NotificationsCubit(repository);
    addTearDown(cubit.close);

    await cubit.markAllRead();
    // Cubit odświeża dane po zakończeniu akcji; repozytorium jest asynchroniczne,
    // więc czekamy na kolejkę mikro-zadań zamiast sprawdzać stan po samym POST.
    await Future<void>.delayed(Duration.zero);

    expect(repository.markAllReadCalls, 1);
    expect(cubit.state, isA<NotificationsReady>());
  });

  test(
    'transient refresh zachowuje inbox, badge i przekazuje refreshError',
    () async {
      final repository = _FakeNotificationsRepository(
        groupsResult: Right([NotificationsFixture.group()]),
        countResult: const Right(2),
      );
      final cubit = NotificationsCubit(repository);
      addTearDown(cubit.close);
      await cubit.load();
      repository.groupsResult = const Left(
        ApiError(type: ApiErrorType.connection, message: 'Offline.'),
      );

      await cubit.load();

      final state = cubit.state as NotificationsReady;
      expect(state.groups, hasLength(1));
      expect(state.unreadCount, 2);
      expect(state.refreshError, 'Offline.');
    },
  );

  test('mutation unauthorized nie przywraca prywatnego snapshotu', () async {
    final repository = _FakeNotificationsRepository(
      groupsResult: Right([NotificationsFixture.group()]),
      countResult: const Right(1),
    );
    final cubit = NotificationsCubit(repository);
    addTearDown(cubit.close);
    await cubit.load();
    repository.markAllReadResult = const Left(
      ApiError(type: ApiErrorType.unauthorized, message: 'Sesja wygasła.'),
    );

    await cubit.markAllRead();

    expect(cubit.state, isA<NotificationsUnauthorized>());
  });

  test(
    'markAllRead jest optymistyczny przed ACK i rollbackuje dokładny snapshot',
    () async {
      final completer = Completer<Either<ApiError, void>>();
      final repository = _FakeNotificationsRepository(
        groupsResult: Right([NotificationsFixture.group()]),
        countResult: const Right(1),
      )..markAllReadCompleter = completer;
      final cubit = NotificationsCubit(repository);
      addTearDown(cubit.close);
      await cubit.load();

      final operation = cubit.markAllRead();
      final optimistic = cubit.state as NotificationsReady;
      expect(optimistic.unreadCount, 0);
      expect(optimistic.groups.single.unreadCount, 0);

      completer.complete(
        const Left(
          ApiError(type: ApiErrorType.connection, message: 'Offline.'),
        ),
      );
      await operation;
      final rolledBack = cubit.state as NotificationsReady;
      expect(rolledBack.unreadCount, 1);
      expect(rolledBack.groups.single.unreadCount, 1);
      expect(rolledBack.refreshError, 'Offline.');
    },
  );

  test(
    'markGroupRead jest optymistyczny i rollbackuje snapshot po błędzie',
    () async {
      final completer = Completer<Either<ApiError, void>>();
      final repository = _FakeNotificationsRepository(
        groupsResult: Right([NotificationsFixture.group()]),
        countResult: const Right(1),
      )..markGroupReadCompleter = completer;
      final cubit = NotificationsCubit(repository);
      addTearDown(cubit.close);
      await cubit.load();

      final operation = cubit.markGroupRead(
        'workspace:22222222-2222-4222-8222-222222222222',
      );
      expect((cubit.state as NotificationsReady).unreadCount, 0);

      completer.complete(
        const Left(
          ApiError(type: ApiErrorType.connection, message: 'Offline.'),
        ),
      );
      await operation;
      final state = cubit.state as NotificationsReady;
      expect(state.unreadCount, 1);
      expect(state.groups.single.unreadCount, 1);
      expect(state.refreshError, 'Offline.');
    },
  );

  test(
    'archive jest optymistyczne i forbidden usuwa prywatny snapshot',
    () async {
      final completer = Completer<Either<ApiError, void>>();
      final repository = _FakeNotificationsRepository(
        groupsResult: Right([NotificationsFixture.group()]),
        countResult: const Right(1),
      )..archiveGroupCompleter = completer;
      final cubit = NotificationsCubit(repository);
      addTearDown(cubit.close);
      await cubit.load();

      final operation = cubit.archiveGroup(
        'workspace:22222222-2222-4222-8222-222222222222',
      );
      final optimistic = cubit.state as NotificationsEmpty;
      expect(optimistic.inbox.groups, isEmpty);
      expect(optimistic.unreadCount, 0);

      completer.complete(
        const Left(
          ApiError(type: ApiErrorType.forbidden, message: 'Odebrano dostęp.'),
        ),
      );
      await operation;
      expect(cubit.state, isA<NotificationsForbidden>());
    },
  );

  test('quickAction po błędzie połączenia zachowuje snapshot inboxa', () async {
    final repository =
        _FakeNotificationsRepository(
            groupsResult: Right([NotificationsFixture.group()]),
            countResult: const Right(1),
          )
          ..quickActionResult = const Left(
            ApiError(type: ApiErrorType.connection, message: 'Offline.'),
          );
    final cubit = NotificationsCubit(repository);
    addTearDown(cubit.close);
    await cubit.load();

    await cubit.quickAction(
      '11111111-1111-4111-8111-111111111111',
      NotificationQuickActionKind.markRead,
    );

    final state = cubit.state as NotificationsReady;
    expect(state.groups, hasLength(1));
    expect(state.unreadCount, 1);
    expect(state.refreshError, 'Offline.');
  });

  test(
    'pin najnowszego elementu grupy aktualizuje grupowy snapshot przed ACK',
    () async {
      final completer = Completer<Either<ApiError, void>>();
      final repository = _FakeNotificationsRepository(
        groupsResult: Right([NotificationsFixture.group()]),
        countResult: const Right(1),
      )..quickActionCompleter = completer;
      final cubit = NotificationsCubit(repository);
      addTearDown(cubit.close);
      await cubit.load();

      final action = cubit.quickAction(
        '11111111-1111-4111-8111-111111111111',
        NotificationQuickActionKind.pin,
      );
      final optimistic = cubit.state as NotificationsReady;
      expect(optimistic.groups.single.latest.isPinned, isTrue);
      expect(optimistic.unreadCount, 1);

      completer.complete(const Right(null));
      await action;
    },
  );

  test('kolejka mutacji rollbackuje względem aktualnego snapshotu', () async {
    final markRead = Completer<Either<ApiError, void>>();
    final archive = Completer<Either<ApiError, void>>();
    final repository =
        _FakeNotificationsRepository(
            groupsResult: Right([NotificationsFixture.group()]),
            countResult: const Right(1),
          )
          ..markAllReadCompleter = markRead
          ..archiveGroupCompleter = archive;
    final cubit = NotificationsCubit(repository);
    addTearDown(cubit.close);
    await cubit.load();

    final first = cubit.markAllRead();
    final second = cubit.archiveGroup(
      'workspace:22222222-2222-4222-8222-222222222222',
    );
    expect((cubit.state as NotificationsReady).groups, hasLength(1));
    markRead.complete(
      const Left(ApiError(type: ApiErrorType.connection, message: 'Offline.')),
    );
    await first;
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isA<NotificationsEmpty>());

    archive.complete(
      const Left(ApiError(type: ApiErrorType.connection, message: 'Offline.')),
    );
    await second;
    final rolledBack = cubit.state as NotificationsReady;
    expect(rolledBack.groups, hasLength(1));
    expect(rolledBack.unreadCount, 1);
  });

  test(
    'burst odświeżeń współdzieli jedno żądanie i planuje jeden follow-up',
    () async {
      final completer =
          Completer<Either<ApiError, List<NotificationGroupResponse>>>();
      final repository = _FakeNotificationsRepository(
        groupsResult: Right([NotificationsFixture.group()]),
        countResult: const Right(1),
      )..listGroupsCompleter = completer;
      final cubit = NotificationsCubit(repository);
      addTearDown(cubit.close);

      final first = cubit.load();
      final second = cubit.load();
      final third = cubit.load();
      expect(repository.listGroupsCalls, 1);

      completer.complete(Right([NotificationsFixture.group()]));
      await Future.wait([first, second, third]);
      await Future<void>.delayed(Duration.zero);

      expect(repository.listGroupsCalls, 2);
    },
  );

  test('cursor grup scala strony bez duplikowania groupKey', () async {
    final group = NotificationsFixture.group();
    final repository =
        _FakeNotificationsRepository(
            groupsResult: Right([group]),
            countResult: const Right(1),
          )
          ..groupPages = [
            CursorPageResponse(items: [group], nextCursor: 'next'),
            CursorPageResponse(items: [group]),
          ];
    final cubit = NotificationsCubit(repository);
    addTearDown(cubit.close);

    await cubit.load();
    await cubit.loadMore();

    final state = cubit.state as NotificationsReady;
    expect(state.groups, hasLength(1));
    expect(state.inbox.groupNextCursor, isNull);
  });

  test(
    'zmiana filtra i widoku podczas loadMore odrzuca spóźnioną stronę starego query',
    () async {
      final delayedPage =
          Completer<Either<ApiError, List<NotificationGroupResponse>>>();
      final repository = _FakeNotificationsRepository(
        groupsResult: Right([NotificationsFixture.group()]),
        countResult: const Right(1),
      )..groupNextCursor = 'older';
      final cubit = NotificationsCubit(repository);
      addTearDown(cubit.close);
      await cubit.load();

      repository.listGroupsCompleter = delayedPage;
      final loadingMore = cubit.loadMore();
      cubit.setFilters(category: NotificationCategory.task);
      cubit.selectView(NotificationsInboxView.items);
      repository.listGroupsCompleter = null;
      repository.groupNextCursor = null;
      repository.groupsResult = const Right([]);

      final states = <NotificationsState>[];
      final subscription = cubit.stream.listen(states.add);
      delayedPage.complete(Right([NotificationsFixture.group()]));
      await loadingMore;
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      await subscription.cancel();

      final state = cubit.state as NotificationsEmpty;
      expect(state.inbox.category, NotificationCategory.task);
      expect(state.inbox.view, NotificationsInboxView.items);
      expect(state.inbox.groups, isEmpty);
      expect(
        states.whereType<NotificationsReady>(),
        isEmpty,
      );
    },
  );
}
