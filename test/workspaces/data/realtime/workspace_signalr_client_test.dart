import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/notifications/models/notification_models.dart';
import 'package:ready_next/workspaces/data/realtime/notifications/workspace_notifications_realtime_service.dart';
import 'package:ready_next/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/notification_enums.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';
import 'package:signalr_netcore/signalr_client.dart';

class _NotificationsRepositoryMock extends Mock
    implements NotificationsRepository {}

final class _FakeSignalRTransport implements WorkspaceSignalRTransport {
  final _states = StreamController<WorkspaceSignalRConnectionState>.broadcast();
  final _handlers = <String, MethodInvocationFunc>{};

  @override
  Stream<WorkspaceSignalRConnectionState> get states => _states.stream;

  @override
  void on(String methodName, MethodInvocationFunc handler) {
    _handlers[methodName] = handler;
  }

  @override
  Future<void> connect() async {
    _states
      ..add(WorkspaceSignalRConnectionState.connecting)
      ..add(WorkspaceSignalRConnectionState.connected);
  }

  @override
  Future<Object?> invoke(String methodName, {List<Object>? args}) async => null;

  @override
  Future<void> disconnect() async {
    if (!_states.isClosed) {
      _states.add(WorkspaceSignalRConnectionState.disconnected);
    }
  }

  @override
  void dispose() {
    unawaited(_states.close());
  }

  void reconnect() => _states.add(WorkspaceSignalRConnectionState.connected);

  void emit(String name, Map<String, Object?> payload) =>
      _handlers[name]?.call([payload]);
}

final class _NotificationsRepositoryStub extends Mock
    implements NotificationsRepository {}

WorkspaceNotificationResponse _notification() => WorkspaceNotificationResponse(
  id: 'notification-1',
  sourceModule: 'Tasks',
  eventType: 'task.updated',
  entityType: 'task',
  entityId: 'task-1',
  title: 'Zadanie zmienione',
  body: 'Opis',
  eventId: 'event-1',
  contractVersion: 1,
  createdAtUtc: DateTime.utc(2026, 8, 30),
  isPinned: false,
  category: NotificationCategory.task,
  priority: NotificationPriority.normal,
);

void main() {
  test(
    'klient zaczyna w stanie rozłączonym i nie wywołuje huba przed connect',
    () {
      final client = WorkspaceSignalRClient(
        'http://localhost:5072/api/v1/realtime/notifications',
        () async => 'token',
      );

      expect(client.state, WorkspaceSignalRConnectionState.disconnected);
      expect(
        () => client.invoke('SubscribeConversation'),
        throwsA(isA<StateError>()),
      );

      client.dispose();
    },
  );

  test(
    'group.removed jest typowany, nie niesie danych i odrzuca stale sequence',
    () async {
      final transport = _FakeSignalRTransport();
      final service = WorkspaceNotificationsRealtimeService(
        client: transport,
        notificationsRepository: _NotificationsRepositoryMock(),
      );
      final events = <Object>[];
      final subscription = service.events.listen(events.add);
      await service.start();

      transport.emit('notification.group.removed', {
        'groupKey': 'task-1',
        'realtimeSequence': 2,
      });
      transport.emit('notification.group.removed', {
        'groupKey': 'task-1',
        'realtimeSequence': 1,
        'title': 'nie wolno',
      });
      await Future<void>.delayed(Duration.zero);

      expect(events, hasLength(1));
      final removed = events.single as NotificationGroupRemovedRealtimeEvent;
      expect(removed.groupKey, 'task-1');
      expect(removed.realtimeSequence, 2);
      await subscription.cancel();
      await service.dispose();
    },
  );

  test('notification.created deduplikuje powtórzony eventId', () async {
    final transport = _FakeSignalRTransport();
    final service = WorkspaceNotificationsRealtimeService(
      client: transport,
      notificationsRepository: _NotificationsRepositoryMock(),
    );
    final events = <Object>[];
    final subscription = service.events.listen(events.add);
    await service.start();

    final payload = _notification().toJson();
    transport
      ..emit('notification.created', payload)
      ..emit('notification.created', payload);
    await Future<void>.delayed(Duration.zero);

    expect(events.whereType<NotificationCreatedRealtimeEvent>(), hasLength(1));
    await subscription.cancel();
    await service.dispose();
  });

  test('po dispose klient odrzuca nowe operacje', () {
    final client = WorkspaceSignalRClient(
      'http://localhost:5072/hub',
      () async => null,
    );
    client.dispose();

    // ignore: unnecessary_lambdas, wywołanie synchronicznie sprawdza guard przed Future
    expect(() => client.connect(), throwsA(isA<StateError>()));
  });

  test('serwis powiadomień nie uruchamia huba bez tokenu sesji', () async {
    final service = WorkspaceNotificationsRealtimeService(
      client: WorkspaceSignalRClient(
        'http://localhost:5072/api/v1/realtime/notifications',
        () async => null,
      ),
      notificationsRepository: _NotificationsRepositoryMock(),
    );

    expect(
      service.start(),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          contains('aktywnej sesji'),
        ),
      ),
    );
    await service.dispose();
  });

  test(
    'po reconnect wykonuje REST replay i emituje tylko świeży snapshot',
    () async {
      final transport = _FakeSignalRTransport();
      final repository = _NotificationsRepositoryStub();
      final group = NotificationGroupResponse(
        groupKey: 'task-1',
        count: 1,
        unreadCount: 1,
        latest: _notification(),
        notificationIds: const ['notification-1'],
        realtimeSequence: 1,
      );
      when(repository.listGroups).thenAnswer(
        (_) async => Right(CursorPageResponse(items: [group])),
      );
      when(repository.listNotifications).thenAnswer(
        (_) async => const Right(CursorPageResponse(items: [])),
      );
      when(repository.unreadCount).thenAnswer((_) async => const Right(1));
      final service = WorkspaceNotificationsRealtimeService(
        client: transport,
        notificationsRepository: repository,
      );
      final events = <Object>[];
      final subscription = service.events.listen(events.add);

      await service.start();
      await Future<void>.delayed(Duration.zero);
      transport.reconnect();
      await Future<void>.delayed(Duration.zero);

      verify(repository.listGroups).called(1);
      final groupEvents = events
          .whereType<NotificationGroupUpdatedRealtimeEvent>();
      expect(groupEvents, hasLength(1));
      expect(
        groupEvents.single.isReplay,
        isTrue,
      );

      await subscription.cancel();
      await service.dispose();
    },
  );

  test(
    'reconnect odtwarza wszystkie strony obu cursorów i kończy badge snapshotem',
    () async {
      final transport = _FakeSignalRTransport();
      final repository = _NotificationsRepositoryStub();
      final first = _notification();
      final second = first.copyWith(id: 'notification-2', eventId: 'event-2');
      final group = NotificationGroupResponse(
        groupKey: 'task-1',
        count: 2,
        unreadCount: 2,
        latest: second,
        notificationIds: [first.id, second.id],
        realtimeSequence: 2,
      );
      when(repository.listNotifications).thenAnswer(
        (_) async => Right(
          CursorPageResponse(items: [first], nextCursor: 'items-next'),
        ),
      );
      when(
        () => repository.listNotifications(cursor: 'items-next'),
      ).thenAnswer((_) async => Right(CursorPageResponse(items: [second])));
      when(repository.listGroups).thenAnswer(
        (_) async => Right(
          CursorPageResponse(items: [group], nextCursor: 'groups-next'),
        ),
      );
      when(
        () => repository.listGroups(cursor: 'groups-next'),
      ).thenAnswer(
        (_) async => const Right(
          CursorPageResponse<NotificationGroupResponse>(items: []),
        ),
      );
      when(repository.unreadCount).thenAnswer((_) async => const Right(2));
      final service = WorkspaceNotificationsRealtimeService(
        client: transport,
        notificationsRepository: repository,
      );
      final events = <Object>[];
      final subscription = service.events.listen(events.add);

      await service.start();
      await Future<void>.delayed(Duration.zero);
      transport.reconnect();
      await Future<void>.delayed(const Duration(milliseconds: 10));

      verify(repository.listNotifications).called(1);
      verify(
        () => repository.listNotifications(cursor: 'items-next'),
      ).called(1);
      verify(repository.listGroups).called(1);
      verify(() => repository.listGroups(cursor: 'groups-next')).called(1);
      expect(
        events.whereType<NotificationCreatedRealtimeEvent>().map(
          (event) => event.notification.id,
        ),
        ['notification-1', 'notification-2'],
      );
      expect(
        events.whereType<NotificationGroupUpdatedRealtimeEvent>(),
        hasLength(1),
      );
      expect(
        events.whereType<NotificationUnreadCountReconciledRealtimeEvent>(),
        contains(
          isA<NotificationUnreadCountReconciledRealtimeEvent>().having(
            (event) => event.unreadCount,
            'unreadCount',
            2,
          ),
        ),
      );

      await subscription.cancel();
      await service.dispose();
    },
  );

  test(
    'nowszy reconnect unieważnia spóźnioną stronę starszego replayu',
    () async {
      final transport = _FakeSignalRTransport();
      final repository = _NotificationsRepositoryStub();
      final firstPage =
          Completer<
            Either<ApiError, CursorPageResponse<WorkspaceNotificationResponse>>
          >();
      var notificationCalls = 0;
      when(repository.listNotifications).thenAnswer((_) {
        notificationCalls++;
        if (notificationCalls == 1) return firstPage.future;
        return Future.value(
          Right(
            CursorPageResponse(
              items: [_notification().copyWith(id: 'fresh', eventId: 'fresh')],
            ),
          ),
        );
      });
      when(repository.listGroups).thenAnswer(
        (_) async => const Right(CursorPageResponse(items: [])),
      );
      when(repository.unreadCount).thenAnswer((_) async => const Right(1));
      final service = WorkspaceNotificationsRealtimeService(
        client: transport,
        notificationsRepository: repository,
      );
      final events = <Object>[];
      final subscription = service.events.listen(events.add);

      await service.start();
      await Future<void>.delayed(Duration.zero);
      transport.reconnect();
      await Future<void>.delayed(Duration.zero);
      expect(notificationCalls, 1);
      transport.reconnect();
      firstPage.complete(
        Right(
          CursorPageResponse(
            items: [_notification().copyWith(id: 'stale', eventId: 'stale')],
          ),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(notificationCalls, 2);
      expect(
        events
            .whereType<NotificationCreatedRealtimeEvent>()
            .single
            .notification
            .id,
        'fresh',
      );
      await subscription.cancel();
      await service.dispose();
    },
  );
}
