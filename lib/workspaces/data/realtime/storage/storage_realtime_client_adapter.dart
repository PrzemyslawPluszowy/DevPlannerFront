import 'dart:async';
import 'dart:collection';

import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_event.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_realtime_target.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_realtime_client.dart';

/// Kanał zmian plików nad wspólnym transportem SignalR.
///
/// Klasa nie zna Cubitów ani widgetów. Tłumaczy kontrakt huba na typowane
/// zdarzenia, deduplikuje je i odtwarza historię po ponownym połączeniu.
final class StorageRealtimeClientAdapter implements StorageRealtimeClient {
  /// Tworzy klienta na gotowym transporcie huba Storage.
  StorageRealtimeClientAdapter(
    this._transport, {
    this.retryDelay = const Duration(seconds: 5),
  }) {
    // Handlery rejestrujemy raz: produkcja trzyma listę funkcji na metodę,
    // więc rejestracja przy każdej zmianie zakresu dokładałaby kolejne kopie
    // i mnożyła dekodowanie każdego zdarzenia.
    _registerHandlers();
  }

  /// Rozmiar okna deduplikacji.
  ///
  /// Historia po reconnect jest odporna na powtórzone zdarzenia, bo odtworzenie
  /// kończy się odświeżeniem listy, a nie dopisaniem plików. Okno chroni więc
  /// tylko przed burzą powtórzeń w jednej sesji i nie musi być nieograniczone.
  static const _dedupWindow = 512;

  /// Rozmiar strony historii; serwer przyjmuje 1–200.
  static const _historyPageSize = 100;

  /// Ile pierwszych stron historii oddajemy ekranowi. Reszta nadrabiania tylko
  /// przesuwa kursor, bo pojedyncze odświeżenie pokazuje stan po wszystkich.
  static const _emittedHistoryPages = 3;

  /// Twardy budżet stron nadrabiania po dłuższej przerwie.
  static const _historyPageLimit = 20;

  /// Ile razy ponowić pierwsze połączenie, zanim kanał zostanie uznany za
  /// niedostępny do następnego wejścia w zakres.
  static const _maxConnectAttempts = 3;

  final WorkspaceSignalRTransport _transport;
  final StreamController<StorageRealtimeEvent> _events =
      StreamController<StorageRealtimeEvent>.broadcast();
  final Duration retryDelay;
  Timer? _retryTimer;
  int _connectAttempts = 0;
  final Set<String> _seen = <String>{};
  final Queue<String> _seenOrder = Queue<String>();
  StreamSubscription<WorkspaceSignalRConnectionState>? _states;
  StorageRealtimeTarget? _target;
  String? _cursor;
  WorkspaceSignalRConnectionState? _lastTransportState;
  bool _subscribed = false;
  bool _disposed = false;
  Future<void>? _subscriptionWork;

  @override
  Stream<StorageRealtimeEvent> get events => _events.stream;

  @override
  Future<void> start(StorageRealtimeTarget target) async {
    if (_disposed) return;
    if (_target == target && _subscribed) return;
    // Licznik prób zeruje się tylko przy świadomym wejściu w zakres (zmiana
    // zakresu albo ponowne otwarcie tego samego), a nie w wewnętrznej pętli
    // ponowień — inaczej limit prób nigdy by się nie wyczerpał.
    if (_target != target || _connectAttempts >= _maxConnectAttempts) {
      _connectAttempts = 0;
    }
    await _detachSubscription();
    _target = target;
    _cursor = null;
    _lastTransportState = null;
    _seen.clear();
    _seenOrder.clear();
    _states = _transport.states.listen(_onState);
    try {
      await _transport.connect();
      _connectAttempts = 0;
    } catch (_) {
      // Brak połączenia nie może wyłączyć eksploratora ani kanału na stałe:
      // nasłuchiwanie stanów zostaje (transport może połączyć się później),
      // a kolejne próby idą z ograniczonym backoffem. Lista i ręczne
      // odświeżenie działają przez cały czas.
      _scheduleRetry();
      return;
    }
    await _awaitSubscriptionWork();
  }

  /// Ponawia połączenie po nieudanej próbie, z ograniczoną liczbą prób.
  void _scheduleRetry() {
    if (_disposed || _target == null) return;
    if (_connectAttempts >= _maxConnectAttempts) return;
    _connectAttempts++;
    _retryTimer?.cancel();
    _retryTimer = Timer(
      retryDelay * _connectAttempts,
      () => unawaited(_retryConnect()),
    );
  }

  /// Ponawia samo połączenie, bez rozbierania subskrypcji i bez zerowania licznika.
  Future<void> _retryConnect() async {
    if (_disposed || _target == null || _subscribed) return;
    try {
      await _transport.connect();
      _connectAttempts = 0;
    } catch (_) {
      _scheduleRetry();
      return;
    }
    await _awaitSubscriptionWork();
  }

  @override
  Future<void> stop() => _detachSubscription();

  @override
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _retryTimer?.cancel();
    _retryTimer = null;
    await _detachSubscription();
    await _events.close();
    _transport.dispose();
  }

  void _registerHandlers() {
    for (final type in StorageRealtimeEventType.values) {
      if (type == StorageRealtimeEventType.resyncRequired) continue;
      _transport.on(type.method, (arguments) => _onEvent(type, arguments));
    }
  }

  void _onState(WorkspaceSignalRConnectionState state) {
    if (_disposed) return;
    final previous = _lastTransportState;
    _lastTransportState = state;
    if (state != WorkspaceSignalRConnectionState.connected) return;
    // Powtórzone „połączono” bez przerwy w połączeniu to ten sam stan, nie nowe
    // połączenie: subskrypcja grup po stronie serwera nadal żyje, a druga
    // subskrypcja podwoiłaby odbiór zdarzeń.
    if (previous == WorkspaceSignalRConnectionState.connected) return;
    final work = _subscribeAndReplay();
    _subscriptionWork = work;
    unawaited(work);
  }

  /// Czeka na subskrypcję, która wyszła z obsługi stanu transportu.
  ///
  /// Bez tego zmiana zakresu mogłaby odłączyć grupę, do której subskrypcja
  /// jeszcze nie zdążyła dołączyć, i zostawić ją aktywną po zmianie widoku.
  Future<void> _awaitSubscriptionWork() async {
    final work = _subscriptionWork;
    if (work == null) return;
    try {
      await work;
    } catch (_) {
      // Nieudana subskrypcja jest już obsłużona niżej.
    }
  }

  Future<void> _subscribeAndReplay() async {
    final target = _target;
    if (target == null || _disposed) return;
    try {
      await _transport.invoke(
        _subscribeMethod(target),
        args: _subscriptionArgs(target),
      );
      _subscribed = true;
      // Historia jest nadrabiana także po pierwszej subskrypcji. Lista i kanał
      // startują równolegle, więc zmiana, która wydarzyła się między odczytem
      // listy a dołączeniem do grupy, nie przyszłaby jako zdarzenie live i
      // klient zostałby z nieaktualnym widokiem do następnej mutacji.
      await _replay(target);
    } catch (_) {
      // Nieudana subskrypcja nie jest błędem ekranu: kolejne połączenie
      // transportu spróbuje ponownie, a lista pozostaje używalna.
    }
  }

  Future<void> _replay(StorageRealtimeTarget target) async {
    var pageNumber = 0;
    // Bez kursora nie ma czego wznawiać: odczyt ogona historii daje w jednym
    // żądaniu i sygnał zmiany, i pozycję startową, zamiast przewijania całej
    // historii zakresu przy każdym wejściu w moduł.
    var tail = _cursor == null;
    try {
      while (!_disposed && _target == target) {
        final result = await _transport.invoke(
          _historyMethod(target),
          args: <Object>[
            ..._subscriptionArgs(target),
            _cursor ?? '',
            _historyPageSize,
            tail,
          ],
        );
        tail = false;
        final page = _decodePage(result, isReplay: true);
        // Pierwsze strony oddajemy ekranowi: to one niosą zmiany, których nie
        // widział. Dalsze strony tylko przesuwają kursor, bo odświeżenie i tak
        // pokaże stan po nich wszystkich.
        if (pageNumber < _emittedHistoryPages) page.events.forEach(_emit);
        if (page.nextCursor != null) _cursor = page.nextCursor;
        if (page.resyncRequired) _emit(_resyncEvent);
        if (!page.hasMore) return;
        pageNumber++;
        if (pageNumber >= _historyPageLimit) {
          // Historia dłuższa niż budżet stron: jedno pełne odświeżenie pokaże
          // stan po pominiętych zmianach, a kursor zostaje na ostatniej
          // przeczytanej stronie, więc nic nie przepada.
          _emit(_resyncEvent);
          return;
        }
      }
    } catch (_) {
      // Odtworzenie historii jest optymalizacją: bez niego ekran odświeży listę
      // przy najbliższej zmianie, a nieudany odczyt nie blokuje połączenia.
    }
  }

  static const StorageRealtimeEvent _resyncEvent = StorageRealtimeEvent(
    type: StorageRealtimeEventType.resyncRequired,
    isReplay: true,
  );

  void _onEvent(StorageRealtimeEventType type, List<Object?>? arguments) {
    final payload = _payload(arguments);
    if (payload == null) return;
    _emit(_decodeEvent(type, payload));
  }

  void _emit(StorageRealtimeEvent event, {bool force = false}) {
    final id = event.eventId;
    if (id != null && !force) {
      if (!_seen.add(id)) return;
      _seenOrder.addLast(id);
      if (_seenOrder.length > _dedupWindow) _seen.remove(_seenOrder.removeFirst());
    }
    if (event.cursor != null) _cursor = event.cursor;
    if (!_disposed && !_events.isClosed) _events.add(event);
  }

  Future<void> _detachSubscription() async {
    _retryTimer?.cancel();
    _retryTimer = null;
    await _awaitSubscriptionWork();
    final target = _target;
    final subscribed = _subscribed;
    _target = null;
    _cursor = null;
    _subscribed = false;
    _lastTransportState = null;
    await _states?.cancel();
    _states = null;
    if (target != null && subscribed) {
      try {
        await _transport.invoke(
          'Unsubscribe',
          args: <Object>[_unsubscribeGroup(target)],
        );
      } catch (_) {
        // Zamknięcie ekranu i zmiana zakresu nie mogą czekać na odsubskrybowanie.
      }
    }
  }

  static List<Object> _subscriptionArgs(StorageRealtimeTarget target) =>
      switch (target.kind) {
        StorageRealtimeScopeKind.personal => const <Object>[],
        StorageRealtimeScopeKind.workspace => <Object>[target.workspaceId!],
        StorageRealtimeScopeKind.project => <Object>[
          target.workspaceId!,
          target.projectId!,
        ],
      };

  static String _subscribeMethod(StorageRealtimeTarget target) =>
      switch (target.kind) {
        StorageRealtimeScopeKind.personal => 'SubscribePersonal',
        StorageRealtimeScopeKind.workspace => 'SubscribeWorkspace',
        StorageRealtimeScopeKind.project => 'SubscribeProject',
      };

  static String _historyMethod(StorageRealtimeTarget target) =>
      switch (target.kind) {
        StorageRealtimeScopeKind.personal => 'GetPersonalEvents',
        StorageRealtimeScopeKind.workspace => 'GetWorkspaceEvents',
        StorageRealtimeScopeKind.project => 'GetProjectEvents',
      };

  /// Nazwa grupy jest adresem nadanym przez serwer i musi być identyczna co do
  /// znaku, bo odłączenie od nieistniejącej grupy cicho nic nie robi: zostałyby
  /// aktywne subskrypcje poprzedniego zakresu. Serwer składa grupy z formatu
  /// `{guid:N}`, czyli małymi literami i bez myślników.
  static String _unsubscribeGroup(StorageRealtimeTarget target) =>
      switch (target.kind) {
        StorageRealtimeScopeKind.personal => 'storage:user:${_groupId(target.ownerUserId!)}',
        StorageRealtimeScopeKind.workspace =>
          'storage:workspace:${_groupId(target.workspaceId!)}',
        StorageRealtimeScopeKind.project =>
          'storage:project:${_groupId(target.projectId!)}',
      };

  static String _groupId(String id) => id.replaceAll('-', '').toLowerCase();

  static Map<String, dynamic>? _payload(List<Object?>? arguments) {
    final value = arguments == null || arguments.isEmpty
        ? null
        : arguments.first;
    return value is Map ? Map<String, dynamic>.from(value) : null;
  }

  static StorageRealtimeEvent _decodeEvent(
    StorageRealtimeEventType type,
    Map<String, dynamic> payload, {
    bool isReplay = false,
  }) => StorageRealtimeEvent(
    type: type,
    isReplay: isReplay,
    eventId: _string(payload, 'eventId'),
    cursor: _string(payload, 'cursor'),
    fileId: _string(payload, 'fileId'),
    folderId: _string(payload, 'folderId'),
    fileVersion: _integer(payload, 'fileVersion'),
    actorUserId: _string(payload, 'actorUserId'),
    occurredAtUtc: _date(payload, 'occurredAtUtc'),
  );

  static _RealtimePage _decodePage(Object? value, {required bool isReplay}) {
    final map = value is Map
        ? Map<String, dynamic>.from(value)
        : const <String, dynamic>{};
    final raw = map['items'];
    final items = raw is List ? raw : const <Object?>[];
    final events = <StorageRealtimeEvent>[];
    for (final item in items) {
      if (item is! Map) continue;
      final payload = Map<String, dynamic>.from(item);
      final type = StorageRealtimeEventType.fromMethod(
        _string(payload, 'type') ?? '',
      );
      if (type == null) continue;
      events.add(_decodeEvent(type, payload, isReplay: isReplay));
    }
    return _RealtimePage(
      events,
      _string(map, 'nextCursor'),
      map['resyncRequired'] == true,
      map['hasMore'] == true,
    );
  }

  /// Pole kontraktu czytamy w obu konwencjach nazw, bo hub i historia
  /// serializują tę samą kopertę, a wielkość liter nie jest częścią umowy.
  static Object? _value(Map<String, dynamic> map, String key) =>
      map[key] ?? map['${key[0].toUpperCase()}${key.substring(1)}'];

  static String? _string(Map<String, dynamic> map, String key) =>
      _value(map, key)?.toString();

  static int? _integer(Map<String, dynamic> map, String key) {
    final value = _value(map, key);
    return value is int ? value : int.tryParse(value?.toString() ?? '');
  }

  static DateTime? _date(Map<String, dynamic> map, String key) {
    final value = _string(map, key);
    return value == null ? null : DateTime.tryParse(value)?.toUtc();
  }
}

final class _RealtimePage {
  const _RealtimePage(
    this.events,
    this.nextCursor,
    this.resyncRequired,
    this.hasMore,
  );

  final List<StorageRealtimeEvent> events;
  final String? nextCursor;
  final bool resyncRequired;

  /// Prawda, gdy po tej stronie są jeszcze nowsze zdarzenia zakresu; wtedy
  /// klient pobiera kolejną stronę, zamiast przesuwać kursor ponad pominięte.
  final bool hasMore;
}
