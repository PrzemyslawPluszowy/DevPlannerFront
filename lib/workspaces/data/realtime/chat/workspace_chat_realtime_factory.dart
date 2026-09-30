import 'dart:async';

import 'package:devplanner/workspaces/data/realtime/chat/workspace_chat_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_realtime_credentials.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:rxdart/rxdart.dart';

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
