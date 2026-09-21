import 'dart:async';

import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/realtime/storage/storage_realtime_client_adapter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_event.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_target.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_netcore/signalr_client.dart';

final class _Transport implements WorkspaceSignalRTransport {
  final BehaviorSubject<WorkspaceSignalRConnectionState> statesSubject =
      BehaviorSubject.seeded(WorkspaceSignalRConnectionState.disconnected);
  /// Lista handlerów na metodę, jak w produkcyjnym transporcie: rejestracja
  /// dokłada kolejną funkcję, więc test widzi wyciek przy zmianie zakresu.
  final Map<String, List<MethodInvocationFunc>> handlers = {};
  final List<(String, List<Object>?)> invocations = [];

  /// Kolejne strony historii zwracane na wywołania `Get*Events`.
  final List<Map<String, dynamic>> historyPages = [];
  bool failConnect = false;
  bool disposed = false;
  int connectAttempts = 0;

  @override
  Stream<WorkspaceSignalRConnectionState> get states => statesSubject.stream;

  @override
  void on(String methodName, MethodInvocationFunc handler) {
    (handlers[methodName] ??= <MethodInvocationFunc>[]).add(handler);
  }

  /// Największa liczba handlerów zarejestrowanych dla jednej metody.
  int get maxHandlersPerMethod =>
      handlers.values.fold(0, (max, list) => list.length > max ? list.length : max);

  @override
  Future<void> connect() async {
    connectAttempts++;
    if (failConnect) throw StateError('Brak aktywnej sesji.');
    if (!statesSubject.isClosed) {
      statesSubject.add(WorkspaceSignalRConnectionState.connected);
    }
  }

  @override
  Future<Object?> invoke(String methodName, {List<Object>? args}) async {
    invocations.add((methodName, args));
    if (!methodName.startsWith('Get')) return null;
    return historyPages.isEmpty ? null : historyPages.removeAt(0);
  }

  @override
  Future<void> disconnect() async {}

  @override
  void dispose() {
    disposed = true;
    unawaited(statesSubject.close());
  }

  /// Prawdziwe wznowienie przechodzi przez stan pośredni; powtórzone
  /// „połączono” bez przerwy nie jest nowym połączeniem.
  void reconnect() {
    if (statesSubject.isClosed) return;
    statesSubject.add(WorkspaceSignalRConnectionState.reconnecting);
    statesSubject.add(WorkspaceSignalRConnectionState.connected);
  }

  void emit(String method, Map<String, dynamic> payload) {
    for (final handler in handlers[method] ?? const <MethodInvocationFunc>[]) {
      handler(<Object?>[payload]);
    }
  }

  /// Wywołania huba w formie czytelnej dla asercji: rekordy z listą w polu nie
  /// porównują się głęboko, więc nazwę i argumenty składamy w tekst.
  List<String> get calls => invocations
      .map(
        (invocation) =>
            '${invocation.$1}(${(invocation.$2 ?? const <Object>[]).join('|')})',
      )
      .toList();
}

Map<String, dynamic> _page({
  List<Map<String, dynamic>> items = const [],
  String? nextCursor,
  bool hasMore = false,
  bool resyncRequired = false,
}) => <String, dynamic>{
  'items': items,
  'nextCursor': nextCursor,
  'hasMore': hasMore,
  'resyncRequired': resyncRequired,
};

Map<String, dynamic> _event(String id, {int sequence = 1}) => <String, dynamic>{
  'eventId': id,
  'sequence': sequence,
  'cursor': 'cursor-$sequence',
  'type': 'storage.file.created',
};

const _personalId = '11111111-1111-1111-1111-111111111111';
const _workspaceId = '22222222-2222-2222-2222-222222222222';
const _projectId = '33333333-3333-3333-3333-333333333333';

void main() {
  late _Transport transport;

  setUp(() {
    transport = _Transport();
  });

  test(
    'zakres osobisty subskrybuje bez identyfikatora i nadrabia historię',
    () async {
      final client = StorageRealtimeClientAdapter(transport);
      final events = <StorageRealtimeEvent>[];
      final subscription = client.events.listen(events.add);

      transport.historyPages.add(_page(items: [_event('e-1')]));
      await client.start(const StorageRealtimeTarget.personal(_personalId));

      expect(transport.calls, [
        'SubscribePersonal()',
        'GetPersonalEvents(|100|true)',
      ]);

      // Historia jest czytana już przy pierwszej subskrypcji: zmiana, która
      // wydarzyła się między odczytem listy a dołączeniem do grupy, nie przyszłaby
      // jako zdarzenie live, więc klient zostałby z nieaktualnym widokiem.
      await Future<void>.delayed(Duration.zero);
      expect(events.map((event) => event.eventId), ['e-1']);

      // Powtórzone zdarzenie live nie odświeży listy drugi raz.
      transport.emit('storage.file.created', <String, dynamic>{
        'eventId': 'e-1',
        'cursor': 'cursor-1',
        'fileId': 'file-1',
      });
      transport.emit('storage.file.moved', <String, dynamic>{
        'eventId': 'e-2',
        'cursor': 'cursor-2',
        'fileId': 'file-1',
        'folderId': 'folder-9',
      });
      await Future<void>.delayed(Duration.zero);

      expect(events, hasLength(2));
      expect(events.last.type, StorageRealtimeEventType.fileMoved);
      expect(events.last.folderId, 'folder-9');

      await subscription.cancel();
      await client.dispose();
    },
  );

  test(
    'zakres projektu pobiera kolejne strony, aż historia się skończy',
    () async {
      final client = StorageRealtimeClientAdapter(transport);
      final events = <StorageRealtimeEvent>[];
      final subscription = client.events.listen(events.add);

      transport.historyPages.add(
        _page(items: [_event('r-1')], nextCursor: 'c-1'),
      );
      await client.start(
        const StorageRealtimeTarget.project(
          workspaceId: _workspaceId,
          projectId: _projectId,
        ),
      );
      await Future<void>.delayed(Duration.zero);

      // Po wznowieniu klient wznawia od kursora i pobiera kolejne strony, aż
      // historia się skończy. Bez tego kursor przesunąłby się ponad pominiętymi
      // zdarzeniami i lista zostałaby stara.
      transport.historyPages
        ..add(
          _page(
            items: [_event('r-2', sequence: 2)],
            nextCursor: 'c-2',
            hasMore: true,
          ),
        )
        ..add(_page(items: [_event('r-3', sequence: 3)], nextCursor: 'c-3'));
      transport.reconnect();
      await Future<void>.delayed(Duration.zero);

      expect(transport.calls, [
        'SubscribeProject($_workspaceId|$_projectId)',
        'GetProjectEvents($_workspaceId|$_projectId||100|true)',
        'SubscribeProject($_workspaceId|$_projectId)',
        'GetProjectEvents($_workspaceId|$_projectId|c-1|100|false)',
        'GetProjectEvents($_workspaceId|$_projectId|c-2|100|false)',
      ]);
      expect(events.map((event) => event.eventId), ['r-1', 'r-2', 'r-3']);

      await subscription.cancel();
      await client.dispose();
    },
  );

  test('wznowienie wznawia historię od kursora', () async {
    final client = StorageRealtimeClientAdapter(transport);
    transport.historyPages.add(_page(items: [_event('r-1', sequence: 7)]));
    await client.start(const StorageRealtimeTarget.workspace(_workspaceId));
    await Future<void>.delayed(Duration.zero);

    transport.historyPages.add(_page(items: []));
    transport.reconnect();
    await Future<void>.delayed(Duration.zero);

    expect(transport.calls, [
      'SubscribeWorkspace($_workspaceId)',
      'GetWorkspaceEvents($_workspaceId||100|true)',
      'SubscribeWorkspace($_workspaceId)',
      'GetWorkspaceEvents($_workspaceId|cursor-7|100|false)',
    ]);

    await client.dispose();
  });

  test('luka historii żąda pełnego odświeżenia listy', () async {
    final client = StorageRealtimeClientAdapter(transport);
    final events = <StorageRealtimeEvent>[];
    final subscription = client.events.listen(events.add);

    transport.historyPages.add(
      _page(items: [_event('r-9')], resyncRequired: true),
    );
    await client.start(const StorageRealtimeTarget.workspace(_workspaceId));
    await Future<void>.delayed(Duration.zero);

    expect(
      events.map((event) => event.type),
      contains(StorageRealtimeEventType.resyncRequired),
    );
    expect(events.last.requiresFullRefresh, isTrue);

    await subscription.cancel();
    await client.dispose();
  });

  test(
    'historia dłuższa niż budżet stron kończy się pełnym odświeżeniem',
    () async {
      final client = StorageRealtimeClientAdapter(transport);
      final events = <StorageRealtimeEvent>[];
      final subscription = client.events.listen(events.add);

      // Dwieście stron po jednym zdarzeniu: kursor nie może zatrzymać się w środku
      // bez powiedzenia ekranowi, że coś pominął.
      for (var index = 0; index < 200; index++) {
        transport.historyPages.add(
          _page(
            items: [_event('p-$index', sequence: index + 1)],
            nextCursor: 'c-$index',
            hasMore: true,
          ),
        );
      }
      await client.start(const StorageRealtimeTarget.workspace(_workspaceId));
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(
        events.map((event) => event.type),
        contains(StorageRealtimeEventType.resyncRequired),
      );
      // Budżet stron jest ograniczony, więc klient nie zapętli się w nieskończoność.
      expect(
        transport.invocations.where((item) => item.$1 == 'GetWorkspaceEvents'),
        hasLength(lessThanOrEqualTo(20)),
      );

      await subscription.cancel();
      await client.dispose();
    },
  );

  test('zmiana zakresu odłącza poprzednią grupę i subskrybuje nową', () async {
    final client = StorageRealtimeClientAdapter(transport);
    await client.start(const StorageRealtimeTarget.personal(_personalId));
    await client.start(const StorageRealtimeTarget.workspace(_workspaceId));

    // Nazwa grupy jest adresem serwera: bez myślników, bo tak składa ją backend.
    expect(transport.calls, [
      'SubscribePersonal()',
      'GetPersonalEvents(|100|true)',
      'Unsubscribe(storage:user:11111111111111111111111111111111)',
      'SubscribeWorkspace($_workspaceId)',
      'GetWorkspaceEvents($_workspaceId||100|true)',
    ]);

    await client.dispose();
  });

  test('brak połączenia degraduje kanał, nie ekran', () async {
    transport.failConnect = true;
    final client = StorageRealtimeClientAdapter(transport);
    final events = <StorageRealtimeEvent>[];
    final subscription = client.events.listen(events.add);

    await client.start(const StorageRealtimeTarget.personal(_personalId));

    expect(events, isEmpty);
    expect(transport.invocations, isEmpty);

    await subscription.cancel();
    await client.dispose();
  });

  test('zwolnienie klienta zamyka strumień i transport', () async {
    final client = StorageRealtimeClientAdapter(transport);
    await client.start(const StorageRealtimeTarget.personal(_personalId));
    var closed = false;
    client.events.listen(null, onDone: () => closed = true);

    await client.dispose();

    expect(closed, isTrue);
    expect(transport.disposed, isTrue);
  });
  test('zmiana zakresu nie dokłada handlerów zdarzeń', () async {
    final client = StorageRealtimeClientAdapter(transport);
    await client.start(const StorageRealtimeTarget.personal(_personalId));
    await client.start(const StorageRealtimeTarget.workspace(_workspaceId));
    await client.start(
      const StorageRealtimeTarget.project(
        workspaceId: _workspaceId,
        projectId: _projectId,
      ),
    );

    // Produkcyjny transport trzyma listę funkcji na metodę: rejestracja przy
    // każdym starcie mnożyłaby dekodowanie i zostawiała handlery na zawsze.
    expect(transport.maxHandlersPerMethod, 1);

    await client.dispose();
  });

  test('po wyczerpaniu limitu prób kanał przestaje ponawiać', () async {
    transport.failConnect = true;
    final client = StorageRealtimeClientAdapter(
      transport,
      retryDelay: const Duration(milliseconds: 10),
    );

    await client.start(const StorageRealtimeTarget.workspace(_workspaceId));
    // Trzy ponowienia z backoffem 10/20/30 ms plus pierwsza próba.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    expect(
      transport.connectAttempts,
      4,
      reason: 'limit prób musi się wyczerpać, a nie resetować w pętli',
    );

    // Świadome ponowienie (wejście w zakres) ma prawo spróbować znowu.
    await client.start(const StorageRealtimeTarget.workspace(_workspaceId));
    expect(transport.connectAttempts, 5);

    await client.dispose();
  });

  test('nieudane pierwsze połączenie samo wraca do pracy', () async {
    transport.failConnect = true;
    final client = StorageRealtimeClientAdapter(
      transport,
      retryDelay: const Duration(milliseconds: 20),
    );
    final events = <StorageRealtimeEvent>[];
    final subscription = client.events.listen(events.add);

    // Pierwsza próba kończy się błędem, więc kanał nie ma subskrypcji.
    await client.start(const StorageRealtimeTarget.workspace(_workspaceId));
    expect(transport.invocations, isEmpty);

    // Transport wraca, a kanał ponawia połączenie sam z siebie.
    transport.failConnect = false;
    await Future<void>.delayed(const Duration(milliseconds: 120));

    expect(
      transport.calls,
      contains('SubscribeWorkspace($_workspaceId)'),
      reason: 'nieudane pierwsze połączenie nie może wyłączać kanału na stałe',
    );
    transport.emit('storage.file.created', <String, dynamic>{
      'eventId': 'retry-1',
      'cursor': 'cursor-retry',
      'fileId': 'file-1',
    });
    await Future<void>.delayed(Duration.zero);
    expect(events.map((event) => event.eventId), contains('retry-1'));

    await subscription.cancel();
    await client.dispose();
  });
}
