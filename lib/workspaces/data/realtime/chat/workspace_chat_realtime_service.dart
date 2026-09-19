import 'dart:async';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/realtime/chat/chat_realtime_event_mapper.dart';
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
  WorkspaceChatRealtimeService({required this._client});

  final WorkspaceSignalRTransport _client;
  final PublishSubject<ChatRealtimeEvent> _events =
      PublishSubject<ChatRealtimeEvent>();
  final PublishSubject<WorkspaceChatRealtimeError> _errors =
      PublishSubject<WorkspaceChatRealtimeError>();
  final PublishSubject<ChatConversationRealtimeEvent> _conversationEvents =
      PublishSubject<ChatConversationRealtimeEvent>();
  final PublishSubject<ChatConversationRealtimeError> _conversationErrors =
      PublishSubject<ChatConversationRealtimeError>();
  final ChatRealtimeEventMapper _eventMapper = ChatRealtimeEventMapper();
  final Set<String> _seenEventIds = <String>{};
  int? _latestSequence;
  StreamSubscription<WorkspaceSignalRConnectionState>? _states;
  String? _conversationId;
  String? _cursor;
  bool _started = false;
  bool _wasConnected = false;
  bool _replayInFlight = false;

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
    _conversationId = null;
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
  Future<void> setTyping(bool isTyping) async {
    final id = _requireConversation();
    await _client.invoke('SetTyping', args: <Object>[id, isTyping]);
  }

  /// Podtrzymuje obecność użytkownika w aktywnej rozmowie.
  Future<void> heartbeatPresence() async {
    final id = _requireConversation();
    await _client.invoke('HeartbeatPresence', args: <Object>[id]);
  }

  /// Zamyka strumienie i transport. Wywołać przy niszczeniu właściciela sesji.
  Future<void> dispose() async {
    await stop();
    await _events.close();
    await _errors.close();
    await _conversationEvents.close();
    await _conversationErrors.close();
    _client.dispose();
  }

  void _registerHandlers() {
    for (final method in _eventMethods) {
      _client.on(method, (arguments) => _handleEvent(method, arguments));
    }
  }

  void _handleState(WorkspaceSignalRConnectionState state) {
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
    'chat.member.access_revoked',
    'chat.member.added',
    'chat.member.left',
    'chat.member.rejoined',
    'chat.member.removed',
    'chat.member.role_changed',
  ];
}

/// Tworzy lokalny serwis dla pojedynczego ekranu rozmowy.
///
/// Każdy ekran dostaje własny transport i własny cursor; nie współdzielimy
/// globalnego połączenia pomiędzy rozmowami.
final class WorkspaceChatRealtimeFactory {
  WorkspaceChatRealtimeFactory({
    required this._baseUrl,
    required this._accessTokenProvider,
  });

  final String _baseUrl;
  final Future<String?> Function() _accessTokenProvider;

  WorkspaceChatRealtimeService create() => WorkspaceChatRealtimeService(
    client: WorkspaceSignalRClient(
      '$_baseUrl/api/v1/realtime/chat',
      _accessTokenProvider,
    ),
  );
}
