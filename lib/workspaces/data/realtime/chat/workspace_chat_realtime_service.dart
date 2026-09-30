import 'dart:async';

import 'package:devplanner/workspaces/data/realtime/chat/chat_realtime_event_mapper.dart';
import 'package:devplanner/workspaces/data/realtime/chat/chat_realtime_transport_event.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:rxdart/rxdart.dart';

export 'chat_realtime_transport_event.dart';
export 'workspace_chat_realtime_factory.dart';

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
  int? _replayGeneration;
  bool _recovering = false;
  int _generation = 0;
  final List<({String method, Map<String, dynamic> payload})> _pendingLive = [];
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
    _generation++;
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
    _generation++;
    _recovering = false;
    _pendingLive.clear();
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
    for (final method in ChatRealtimeEventMapper.eventMethods) {
      _client.on(method, (arguments) => _handleEvent(method, arguments));
    }
  }

  void _handleState(WorkspaceSignalRConnectionState state) {
    _isConnected = state == WorkspaceSignalRConnectionState.connected;
    if (state != WorkspaceSignalRConnectionState.connected || !_started) {
      return;
    }
    _generation++;
    final reconnect = _wasConnected;
    _wasConnected = true;
    unawaited(_subscribeAndReplay(replay: reconnect));
  }

  Future<void> _subscribeAndReplay({required bool replay}) async {
    final id = _conversationId;
    if (id == null || !_started) return;
    final generation = _generation;
    _recovering = replay;
    try {
      await _client.invoke('SubscribeConversation', args: <Object>[id]);
      if (!_started || generation != _generation) return;
      _startPresenceHeartbeat(id);
      await _sendPresenceHeartbeat(id);
      if (replay) await _replay(id, generation);
    } catch (error, stackTrace) {
      if (generation == _generation) _report(error, stackTrace);
    } finally {
      if (generation == _generation) {
        _recovering = false;
        final pending = List.of(_pendingLive);
        _pendingLive.clear();
        pending.sort(
          (a, b) =>
              (ChatRealtimeEvent(
                        method: a.method,
                        payload: a.payload,
                      ).sequence ??
                      0)
                  .compareTo(
                    ChatRealtimeEvent(
                          method: b.method,
                          payload: b.payload,
                        ).sequence ??
                        0,
                  ),
        );
        for (final event in pending) {
          _emit(event.method, event.payload);
        }
      }
    }
  }

  Future<void> _replay(String id, int generation) async {
    if (_replayGeneration == generation || !_started) return;
    _replayGeneration = generation;
    try {
      var cursor = _cursor;
      while (_started && _conversationId == id && generation == _generation) {
        final result = await _client.invoke(
          'GetConversationEvents',
          args: <Object>[id, cursor ?? '', 100],
        );
        if (!_started || _conversationId != id || generation != _generation) {
          return;
        }
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
      if (_started && generation == _generation) {
        _report(error, stackTrace);
        _emitResyncRequired(id);
      }
    } finally {
      if (_replayGeneration == generation) _replayGeneration = null;
    }
  }

  void _handleEvent(String method, List<Object?>? arguments) {
    final payload = _eventMapper.mapArgument(arguments);
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
    if (!_started || method == 'chat.inbox.changed') return;
    final normalizedPayload = _eventMapper.normalizeLiveEnvelope(payload);
    if (normalizedPayload == null) return;
    final eventConversationId = normalizedPayload['conversationId'];
    if (eventConversationId != null && eventConversationId != _conversationId) {
      return;
    }
    if (_recovering && !isReplay) {
      _pendingLive.add((method: method, payload: normalizedPayload));
      return;
    }
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
          kind: _eventMapper.mapErrorKind(error),
          message: error.toString(),
        ),
      );
    }
  }
}
