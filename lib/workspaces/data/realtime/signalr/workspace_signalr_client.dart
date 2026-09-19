import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:signalr_netcore/signalr_client.dart';

/// Stan transportu SignalR używany przez właścicieli realtime w module.
enum WorkspaceSignalRConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

/// Cienka, testowalna granica nad klientem SignalR.
///
/// Klasa nie zna modeli UI ani Cubitów. Token jest pobierany za każdym
/// handshake'em, więc refresh sesji nie wymaga przebudowy połączenia.
/// Deduplikacja, replay kursora i autoryzacja zasobów należą do repozytoriów
/// konkretnych hubów, zgodnie z kontraktem backendu.
/// Minimalny kontrakt transportu używany przez właścicieli konkretnych hubów.
/// Dzięki niemu repozytoria realtime można testować bez uruchamiania serwera.
abstract interface class WorkspaceSignalRTransport {
  /// Stany cyklu życia połączenia.
  Stream<WorkspaceSignalRConnectionState> get states;

  /// Rejestruje handler zdarzenia serwera.
  void on(String methodName, MethodInvocationFunc handler);

  /// Otwiera transport.
  Future<void> connect();

  /// Wywołuje metodę huba.
  Future<Object?> invoke(String methodName, {List<Object>? args});

  /// Zamyka transport przed zmianą sesji.
  Future<void> disconnect();

  /// Zwalnia zasoby transportu.
  void dispose();
}

final class WorkspaceSignalRClient implements WorkspaceSignalRTransport {
  WorkspaceSignalRClient(
    String url,
    Future<String?> Function() accessTokenProvider,
  ) : _url = url,
      _accessTokenProvider = accessTokenProvider;

  final String _url;
  final Future<String?> Function() _accessTokenProvider;
  final BehaviorSubject<WorkspaceSignalRConnectionState> _states =
      BehaviorSubject.seeded(WorkspaceSignalRConnectionState.disconnected);
  HubConnection? _connection;
  final Map<String, List<MethodInvocationFunc>> _handlers = {};
  bool _disposed = false;
  int _generation = 0;
  Future<void>? _connectInFlight;

  /// Strumień stanu transportu; kończy się razem z klientem.
  @override
  Stream<WorkspaceSignalRConnectionState> get states => _states.stream;

  WorkspaceSignalRConnectionState get state => _states.value;

  /// Tworzy połączenie dopiero przy pierwszym użyciu.
  @override
  Future<void> connect() async {
    _ensureNotDisposed();
    final pending = _connectInFlight;
    if (pending != null) return pending;
    final operation = _connect(_generation);
    _connectInFlight = operation;
    try {
      await operation;
    } finally {
      if (identical(_connectInFlight, operation)) _connectInFlight = null;
    }
  }

  Future<void> _connect(int generation) async {
    if (_connection?.state == HubConnectionState.Connected ||
        _connection?.state == HubConnectionState.Connecting ||
        _connection?.state == HubConnectionState.Reconnecting) {
      return;
    }

    // Nie pozwalamy SignalR rozpocząć handshake'u bez tokenu. Dzięki temu
    // wygaśnięta sesja nie tworzy anonimowego połączenia ani pętli reconnect.
    final initialToken = (await _accessTokenProvider())?.trim() ?? '';
    if (_disposed || generation != _generation) return;
    if (initialToken.isEmpty) {
      throw StateError('Nie można uruchomić SignalR bez aktywnej sesji.');
    }

    final connection = HubConnectionBuilder()
        .withUrl(
          _url,
          options: HttpConnectionOptions(
            accessTokenFactory: () async {
              final token = (await _accessTokenProvider())?.trim() ?? '';
              if (_disposed || generation != _generation) {
                throw StateError('Połączenie SignalR zostało anulowane.');
              }
              if (token.isEmpty) {
                throw StateError('Sesja wygasła podczas handshake SignalR.');
              }
              return token;
            },
          ),
        )
        .withAutomaticReconnect(retryDelays: const [0, 2000, 5000, 10000])
        .build();
    _connection = connection;
    for (final entry in _handlers.entries) {
      for (final handler in entry.value) {
        connection.on(entry.key, handler);
      }
    }
    connection.onreconnecting(
      ({error}) => _emit(
        WorkspaceSignalRConnectionState.reconnecting,
      ),
    );
    connection.onreconnected(
      ({connectionId}) => _emit(
        WorkspaceSignalRConnectionState.connected,
      ),
    );
    connection.onclose(
      ({error}) => _emit(
        WorkspaceSignalRConnectionState.disconnected,
      ),
    );

    _emit(WorkspaceSignalRConnectionState.connecting);
    try {
      await connection.start();
      if (_disposed || generation != _generation) {
        await connection.stop();
        return;
      }
      _emit(WorkspaceSignalRConnectionState.connected);
    } catch (_) {
      _emit(WorkspaceSignalRConnectionState.disconnected);
      rethrow;
    }
  }

  /// Rejestruje handler zdarzenia wysyłanego przez hub.
  @override
  void on(String methodName, MethodInvocationFunc handler) {
    _ensureNotDisposed();
    (_handlers[methodName] ??= <MethodInvocationFunc>[]).add(handler);
    _connection?.on(methodName, handler);
  }

  /// Wywołuje metodę huba; połączenie musi być wcześniej uruchomione.
  @override
  Future<Object?> invoke(String methodName, {List<Object>? args}) {
    _ensureNotDisposed();
    final connection = _connection;
    if (connection == null ||
        connection.state != HubConnectionState.Connected) {
      throw StateError('Połączenie SignalR nie jest uruchomione.');
    }
    return connection.invoke(methodName, args: args);
  }

  /// Zatrzymuje transport przed wylogowaniem lub zmianą użytkownika.
  @override
  Future<void> disconnect() async {
    _generation++;
    _connectInFlight = null;
    final connection = _connection;
    _connection = null;
    _handlers.clear();
    if (connection != null) await connection.stop();
    if (!_disposed) _emit(WorkspaceSignalRConnectionState.disconnected);
  }

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _generation++;
    final connection = _connection;
    if (connection != null) unawaited(connection.stop());
    _connection = null;
    unawaited(_states.close());
  }

  void _emit(WorkspaceSignalRConnectionState value) {
    if (!_disposed && !_states.isClosed) _states.add(value);
  }

  void _ensureNotDisposed() {
    if (_disposed) throw StateError('Klient SignalR został zwolniony.');
  }
}
