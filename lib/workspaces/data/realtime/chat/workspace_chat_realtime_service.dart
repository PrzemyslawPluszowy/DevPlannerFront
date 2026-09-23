import 'dart:async';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/realtime/chat/chat_realtime_event_mapper.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_realtime_credentials.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:rxdart/rxdart.dart';

/// Surowe zdarzenie z Chat Huba. Payload pozostaje mapą, ponieważ backend
/// może rozszerzać poszczególne zdarzenia bez wymuszania zmiany UI.
final class ChatRealtimeEvent {
  /// Tworzy zdarzenie odebrane z podaną nazwą metody SignalR.
  const ChatRealtimeEvent({
    required this.method,
    required this.payload,
    this.isReplay = false,
  });

  /// Nazwa metody klienta, np. `chat.message.created`.
  final String method;

  /// Znormalizowany payload zdarzenia.
  final Map<String, dynamic> payload;

  /// Czy zdarzenie pochodzi z `GetConversationEvents`.
  final bool isReplay;

  /// Id zdarzenia, jeśli backend je dostarczył.
  String? get eventId => _nonEmptyString(
    payload['eventId'] ?? payload['EventId'] ?? payload['id'],
  );

  /// Kursor sekwencji wykorzystywany przy kolejnym replayu.
  int? get sequence => _toInt(
    payload['realtimeSequence'] ??
        payload['sequence'] ??
        payload['Sequence'] ??
        payload['revision'] ??
        payload['Revision'],
  );

  static String? _nonEmptyString(Object? value) =>
      value is String && value.isNotEmpty ? value : null;

  static int? _toInt(Object? value) =>
      value is int ? value : int.tryParse('$value');
}

/// Błąd transportu, dekodowania albo replayu Chat.
final class WorkspaceChatRealtimeError {
  /// Zachowuje oryginalny błąd i stack trace dla warstwy stanu.
  const WorkspaceChatRealtimeError(this.error, this.stackTrace);

  /// Oryginalny błąd — UI nie powinno go zastępować fallbackiem.
  final Object error;

  /// Ślad diagnostyczny błędu.
  final StackTrace stackTrace;
}

/// Właściciel jednego kontekstu rozmowy Chat.
///
/// Serwis realizuje kontrakt huba: subskrypcję, odsubskrypcję, typing,
/// heartbeat obecności oraz replay po reconnect. Nie zawiera zależności od
/// widgetów ani Cubitów; ekran może subskrybować `events` i `errors` lokalnie.
final class WorkspaceChatRealtimeService
    implements ChatConversationRealtimeClient {
  /// Tworzy serwis z abstrakcją transportu, łatwą do zastąpienia w testach.
  WorkspaceChatRealtimeService({
    required this._client,
    this.presenceHeartbeatInterval = const Duration(seconds: 15),
  });

  final WorkspaceSignalRTransport _client;

  /// Period działania krótkiego lease'u presence; testy mogą skrócić timer.
  final Duration presenceHeartbeatInterval;
  final PublishSubject<ChatRealtimeEvent> _events =
      PublishSubject<ChatRealtimeEvent>();
  final PublishSubject<WorkspaceChatRealtimeError> _errors =
      PublishSubject<WorkspaceChatRealtimeError>();
  final PublishSubject<ChatConversationRealtimeEvent> _conversationEvents =
      PublishSubject<ChatConversationRealtimeEvent>();
  final PublishSubject<ChatConversationRealtimeError> _conversationErrors =
      PublishSubject<ChatConversationRealtimeError>();
  final BehaviorSubject<ChatConversationPresenceSnapshot?> _presenceSnapshots =
      BehaviorSubject<ChatConversationPresenceSnapshot?>.seeded(null);
  final PublishSubject<ChatUserStatusChanged> _userStatusChanges =
      PublishSubject<ChatUserStatusChanged>();
  final ChatRealtimeEventMapper _eventMapper = ChatRealtimeEventMapper();
  final Set<String> _seenEventIds = <String>{};
  int? _latestSequence;
  StreamSubscription<WorkspaceSignalRConnectionState>? _states;
  String? _conversationId;
  String? _cursor;
  bool _started = false;
  bool _isConnected = false;
  bool _wasConnected = false;
  bool _replayInFlight = false;
  bool _heartbeatInFlight = false;
  Timer? _presenceHeartbeat;

  /// Surowe zdarzenia domenowe dla lokalnego Cubita rozmowy.
  Stream<ChatRealtimeEvent> get events => _events.stream;

  /// Jawne błędy transportu i kontraktu backendu.
  Stream<WorkspaceChatRealtimeError> get errors => _errors.stream;

  /// Typowane eventy historii gotowe dla lokalnego reduktora rozmowy.
  @override
  Stream<ChatConversationRealtimeEvent> get conversationEvents =>
      _conversationEvents.stream;

  /// Typowane błędy subskrypcji bez obiektu wyjątku w presentation.
  @override
  Stream<ChatConversationRealtimeError> get conversationErrors =>
      _conversationErrors.stream;

  /// Ostatni snapshot obecności oraz kolejne zmiany z autoryzowanego huba.
  @override
  Stream<ChatConversationPresenceSnapshot?> get presenceSnapshots =>
      _presenceSnapshots.stream;

  @override
  Stream<ChatUserStatusChanged> get userStatusChanges =>
      _userStatusChanges.stream;

  /// Strumień stanu połączenia do ewentualnego wskaźnika w UI.
  Stream<WorkspaceSignalRConnectionState> get connectionStates =>
      _client.states;

  /// Otwiera rozmowę i wywołuje `SubscribeConversation`.
  @override
  Future<void> start(String conversationId) async {
    final id = conversationId.trim();
    if (id.isEmpty) throw ArgumentError.value(conversationId, 'conversationId');
    if (_started && _conversationId == id) return;
    if (_started) await stop();
    _conversationId = id;
    _started = true;
    _isConnected = false;
    _wasConnected = false;
    _registerHandlers();
    _states = _client.states.listen(_handleState);
    try {
      await _client.connect();
    } catch (error, stackTrace) {
      _report(error, stackTrace);
      await stop();
      rethrow;
    }
  }

  /// Zatrzymuje subskrypcję rozmowy przed zamknięciem ekranu lub logoutem.
  @override
  Future<void> stop() async {
    if (!_started) return;
    final id = _conversationId;
    _started = false;
    _isConnected = false;
    _conversationId = null;
    _presenceHeartbeat?.cancel();
    _presenceHeartbeat = null;
    _heartbeatInFlight = false;
    if (!_presenceSnapshots.isClosed) _presenceSnapshots.add(null);
    await _states?.cancel();
    _states = null;
    if (id != null) {
      try {
        await _client.invoke('UnsubscribeConversation', args: <Object>[id]);
      } catch (_) {
        // Przy zamykaniu połączenia błąd odsubskrypcji nie może blokować logoutu.
      }
    }
    _seenEventIds.clear();
    _latestSequence = null;
    _cursor = null;
  }

  /// Wywołuje `SetTyping` bez dotykania warstwy widgetów.
  @override
  Future<void> setTyping(bool isTyping) async {
    final id = _requireConversation();
    await _client.invoke('SetTyping', args: <Object>[id, isTyping]);
  }

  /// Podtrzymuje obecność użytkownika w aktywnej rozmowie.
  @override
  Future<void> heartbeatPresence() async {
    final id = _requireConversation();
    await _client.invoke('HeartbeatPresence', args: <Object>[id]);
  }

  void _startPresenceHeartbeat(String conversationId) {
    _presenceHeartbeat?.cancel();
    _presenceHeartbeat = Timer.periodic(presenceHeartbeatInterval, (_) {
      if (!_started || _conversationId != conversationId || !_isConnected) {
        return;
      }
      unawaited(_sendPresenceHeartbeat(conversationId));
    });
  }

  Future<void> _sendPresenceHeartbeat(String conversationId) async {
    if (_heartbeatInFlight ||
        !_started ||
        _conversationId != conversationId ||
        !_isConnected) {
      return;
    }
    _heartbeatInFlight = true;
    try {
      await _client.invoke('HeartbeatPresence', args: <Object>[conversationId]);
    } catch (error, stackTrace) {
      _report(error, stackTrace);
    } finally {
      _heartbeatInFlight = false;
    }
  }

  /// Zamyka strumienie i transport. Wywołać przy niszczeniu właściciela sesji.
  Future<void> dispose() async {
    await stop();
    await _events.close();
    await _errors.close();
    await _conversationEvents.close();
    await _conversationErrors.close();
    await _presenceSnapshots.close();
    await _userStatusChanges.close();
    _client.dispose();
  }

  void _registerHandlers() {
    for (final method in _eventMethods) {
      _client.on(method, (arguments) => _handleEvent(method, arguments));
    }
  }

  void _handleState(WorkspaceSignalRConnectionState state) {
    _isConnected = state == WorkspaceSignalRConnectionState.connected;
    if (state != WorkspaceSignalRConnectionState.connected || !_started) {
      return;
    }
    final reconnect = _wasConnected;
    _wasConnected = true;
    unawaited(_subscribeAndReplay(replay: reconnect));
  }

  Future<void> _subscribeAndReplay({required bool replay}) async {
    final id = _conversationId;
    if (id == null || !_started) return;
    try {
      await _client.invoke('SubscribeConversation', args: <Object>[id]);
      _startPresenceHeartbeat(id);
      await _sendPresenceHeartbeat(id);
      if (replay) await _replay(id);
    } catch (error, stackTrace) {
      _report(error, stackTrace);
    }
  }

  Future<void> _replay(String id) async {
    if (_replayInFlight || !_started) return;
    _replayInFlight = true;
    try {
      var cursor = _cursor;
      while (_started && _conversationId == id) {
        final result = await _client.invoke(
          'GetConversationEvents',
          args: <Object>[id, cursor ?? '', 100],
        );
        final page = _eventMapper.decodeReplay(result);
        if (page.resyncRequired) {
          _emitResyncRequired(id);
          return;
        }
        for (final event in page.events) {
          _emit(event.method, event.payload, isReplay: true);
        }
        if (page.nextCursor == null || page.nextCursor == cursor) return;
        cursor = page.nextCursor;
        _cursor = cursor;
      }
    } catch (error, stackTrace) {
      _report(error, stackTrace);
    } finally {
      _replayInFlight = false;
    }
  }

  void _handleEvent(String method, List<Object?>? arguments) {
    final payload = _mapArgument(arguments);
    if (payload == null) {
      _report(
        FormatException('Nieprawidłowy payload zdarzenia $method.'),
        StackTrace.current,
      );
      return;
    }
    _emit(method, payload);
  }

  void _emit(
    String method,
    Map<String, dynamic> payload, {
    bool isReplay = false,
  }) {
    final normalizedPayload = _eventMapper.normalizeLiveEnvelope(payload);
    if (normalizedPayload == null) return;
    final event = ChatRealtimeEvent(
      method: method,
      payload: Map<String, dynamic>.unmodifiable(normalizedPayload),
      isReplay: isReplay,
    );
    final sequence = event.sequence;
    if (sequence != null) {
      final latest = _latestSequence;
      if (latest != null && sequence <= latest) return;
    }
    final id = event.eventId;
    if (id != null && !_seenEventIds.add(id)) return;
    if (sequence != null) {
      _latestSequence = sequence;
      _cursor = _eventMapper.cursorForSequence(sequence);
    }
    if (!_events.isClosed) _events.add(event);
    // To zdarzenie unieważnia skrzynkę i nie należy do historii wiadomości.
    // Nadal przesuwamy kursor replayu, ale nie mapujemy go na event rozmowy.
    if (method == 'chat.inbox.changed') return;
    if (method == 'chat.presence.changed') {
      final snapshot = _eventMapper.mapPresence(normalizedPayload);
      if (snapshot == null) {
        _report(
          const FormatException(
            'Nieprawidłowy snapshot obecności rozmowy Chat.',
          ),
          StackTrace.current,
        );
      } else if (!_presenceSnapshots.isClosed) {
        _presenceSnapshots.add(snapshot);
      }
    }
    if (method == 'chat.user_status.changed') {
      final change = _eventMapper.mapUserStatusChanged(normalizedPayload);
      if (change == null) {
        _report(
          const FormatException('Nieprawidłowy status użytkownika w Chat Hub.'),
          StackTrace.current,
        );
      } else if (!_userStatusChanges.isClosed) {
        _userStatusChanges.add(change);
      }
      return;
    }
    final typedEvent = _eventMapper.map(
      method: method,
      payload: normalizedPayload,
      isReplay: isReplay,
    );
    if (typedEvent != null && !_conversationEvents.isClosed) {
      _conversationEvents.add(typedEvent);
    }
  }

  void _emitResyncRequired(String conversationId) {
    if (_conversationEvents.isClosed) return;
    _conversationEvents.add(
      ChatConversationRealtimeEvent(
        eventId: 'resync:$conversationId:${_cursor ?? ''}',
        sequence: null,
        conversationId: conversationId,
        kind: ChatConversationRealtimeEventKind.resyncRequired,
        isReplay: true,
      ),
    );
  }

  String _requireConversation() =>
      _conversationId ?? (throw StateError('Brak aktywnej rozmowy Chat.'));

  void _report(Object error, StackTrace stackTrace) {
    if (!_errors.isClosed) {
      _errors.add(WorkspaceChatRealtimeError(error, stackTrace));
    }
    if (!_conversationErrors.isClosed) {
      _conversationErrors.add(
        ChatConversationRealtimeError(
          kind: _errorKind(error),
          message: error.toString(),
        ),
      );
    }
  }

  ChatConversationRealtimeErrorKind _errorKind(Object error) {
    if (error case ApiError(
      type: ApiErrorType.unauthorized || ApiErrorType.forbidden,
    )) {
      return ChatConversationRealtimeErrorKind.accessRevoked;
    }
    return ChatConversationRealtimeErrorKind.transport;
  }

  Map<String, dynamic>? _mapArgument(List<Object?>? arguments) {
    final value = arguments?.firstOrNull;
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  static const List<String> _eventMethods = <String>[
    'chat.message.created',
    'chat.message.updated',
    'chat.message.deleted',
    'chat.inbox.changed',
    'chat.typing.changed',
    'chat.presence.changed',
    'chat.user_status.changed',
    'chat.member.access_revoked',
    'chat.member.added',
    'chat.member.left',
    'chat.member.rejoined',
    'chat.member.removed',
    'chat.member.role_changed',
  ];
}

/// Sesyjny właściciel subskrypcji realtime Chatu.
///
/// Fabryka jest właścicielem połączeń całej sesji: dla tej samej rozmowy
/// zwraca tę samą subskrypcję, więc przebudowa widoku nie tworzy kolejnego
/// połączenia SignalR. Połączenie zamyka się, gdy ostatnia dzierżawa rozmowy
/// zostanie zwolniona, a `closeAll` zamyka wszystko na końcu sesji.
final class WorkspaceChatRealtimeFactory {
  /// Tworzy sesyjny właściciel na poświadczeniach jednej sesji.
  WorkspaceChatRealtimeFactory({
    required String baseUrl,
    required WorkspaceRealtimeCredentials credentials,
  }) : this._(baseUrl, credentials);

  WorkspaceChatRealtimeFactory._(this._baseUrl, this._credentials);

  final String _baseUrl;
  final WorkspaceRealtimeCredentials _credentials;
  final Map<String, _PooledChatSubscription> _subscriptions =
      <String, _PooledChatSubscription>{};
  WorkspaceChatInboxRealtimeService? _inboxService;
  bool _closed = false;

  /// Liczba otwartych połączeń; używana przez testy i diagnostykę.
  int get openConversationCount => _subscriptions.length;

  /// Jedno połączenie sesyjne odbierające sygnały unieważnienia inboxa.
  WorkspaceChatInboxRealtimeService openInboxInvalidations() {
    if (_closed) {
      throw StateError('Sesja realtime Chatu została już zamknięta.');
    }
    return _inboxService ??= WorkspaceChatInboxRealtimeService(
      client: WorkspaceSignalRClient(
        '$_baseUrl/api/v1/realtime/chat',
        _credentials,
      ),
    );
  }

  /// Czy właściciel został już zamknięty na końcu sesji.
  bool get isClosed => _closed;

  /// Otwiera dzierżawę subskrypcji rozmowy.
  ///
  /// Powtórne wywołanie dla tej samej rozmowy zwiększa licznik dzierżaw i
  /// zwraca istniejącą subskrypcję zamiast tworzyć nowe połączenie.
  WorkspaceChatRealtimeLease open(String conversationId) {
    final id = conversationId.trim();
    if (id.isEmpty) throw ArgumentError.value(conversationId, 'conversationId');
    if (_closed) {
      throw StateError('Sesja realtime Chatu została już zamknięta.');
    }
    final existing = _subscriptions[id];
    if (existing != null) {
      existing.refCount++;
      return WorkspaceChatRealtimeLease._(this, id, existing.service);
    }
    final service = WorkspaceChatRealtimeService(
      client: WorkspaceSignalRClient(
        '$_baseUrl/api/v1/realtime/chat',
        _credentials,
      ),
    );
    _subscriptions[id] = _PooledChatSubscription(service);
    return WorkspaceChatRealtimeLease._(this, id, service);
  }

  /// Zwalnia jedną dzierżawę rozmowy i zamyka połączenie po ostatniej.
  Future<void> release(String conversationId) async {
    final entry = _subscriptions[conversationId];
    if (entry == null) return;
    entry.refCount--;
    if (entry.refCount > 0) return;
    _subscriptions.remove(conversationId);
    await entry.service.dispose();
  }

  /// Zamyka wszystkie subskrypcje; wywoływane przy końcu sesji.
  Future<void> closeAll() async {
    _closed = true;
    final entries = _subscriptions.values.toList(growable: false);
    _subscriptions.clear();
    for (final entry in entries) {
      await entry.service.dispose();
    }
    await _inboxService?.dispose();
    _inboxService = null;
  }
}

/// Lekki kanał sesyjny: niesie wyłącznie sygnał, że skrzynka wymaga ponownego
/// odczytu przez REST. Nie przesyła treści, nazw ani identyfikatorów rozmów.
final class WorkspaceChatInboxRealtimeService {
  WorkspaceChatInboxRealtimeService({required this.client});

  final WorkspaceSignalRTransport client;
  final PublishSubject<void> _invalidations = PublishSubject<void>();
  StreamSubscription<WorkspaceSignalRConnectionState>? _states;
  bool _started = false;
  bool _disposed = false;

  Stream<void> get invalidations => _invalidations.stream;

  Future<void> start() async {
    if (_started || _disposed) return;
    _started = true;
    client.on('chat.inbox.changed', _handleInvalidation);
    _states = client.states.listen((state) {
      if (_started && state == WorkspaceSignalRConnectionState.connected) {
        // Initial connect and every reconnect reconcile missed outbox events.
        _invalidations.add(null);
      }
    });
    try {
      await client.connect();
    } catch (_) {
      _started = false;
      await _states?.cancel();
      _states = null;
      rethrow;
    }
  }

  void _handleInvalidation(List<Object?>? arguments) {
    if (_started && !_invalidations.isClosed) _invalidations.add(null);
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _started = false;
    await _states?.cancel();
    _states = null;
    await client.disconnect();
    client.dispose();
    await _invalidations.close();
  }
}

/// Dzierżawa jednej rozmowy na sesyjnym właścicielu realtime.
///
/// Dzierżawa realizuje port rozmowy, więc widok i Cubit nie wiedzą, że
/// połączenie jest współdzielone. `dispose` zwalnia wyłącznie tę dzierżawę.
final class WorkspaceChatRealtimeLease
    implements ChatConversationRealtimeClient {
  WorkspaceChatRealtimeLease._(
    this._owner,
    this._conversationId,
    this._service,
  );

  final WorkspaceChatRealtimeFactory _owner;
  final String _conversationId;
  final WorkspaceChatRealtimeService _service;
  bool _disposed = false;

  /// Rozmowa, której dotyczy dzierżawa.
  String get conversationId => _conversationId;

  /// Strumień stanu współdzielonego połączenia.
  Stream<WorkspaceSignalRConnectionState> get connectionStates =>
      _service.connectionStates;

  @override
  Stream<ChatConversationRealtimeEvent> get conversationEvents =>
      _service.conversationEvents;

  @override
  Stream<ChatConversationRealtimeError> get conversationErrors =>
      _service.conversationErrors;

  @override
  Stream<ChatConversationPresenceSnapshot?> get presenceSnapshots =>
      _service.presenceSnapshots;

  @override
  Stream<ChatUserStatusChanged> get userStatusChanges =>
      _service.userStatusChanges;

  @override
  Future<void> start(String conversationId) => _service.start(conversationId);

  @override
  Future<void> stop() => _service.stop();

  @override
  Future<void> setTyping(bool isTyping) => _service.setTyping(isTyping);

  @override
  Future<void> heartbeatPresence() => _service.heartbeatPresence();

  /// Zwalnia dzierżawę; połączenie zamyka się po ostatniej dzierżawie.
  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    await _owner.release(_conversationId);
  }
}

final class _PooledChatSubscription {
  _PooledChatSubscription(this.service);

  final WorkspaceChatRealtimeService service;
  int refCount = 1;
}
