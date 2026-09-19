import 'dart:async';
import 'dart:convert';

import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:rxdart/rxdart.dart';

/// Rodzaj zasobu, który ma własny pokój SignalR.
enum WorkspaceScopedRealtimeKind { tasks, whiteboard, wiki }

/// Identyfikuje zasób subskrybowany przez ekran. Dla Tasks wymagane są oba ID.
final class WorkspaceScopedRealtimeTarget {
  const WorkspaceScopedRealtimeTarget.tasks({
    required this.workspaceId,
    required this.resourceId,
  }) : kind = WorkspaceScopedRealtimeKind.tasks;

  const WorkspaceScopedRealtimeTarget.resource({
    required this.kind,
    required this.resourceId,
  }) : workspaceId = null;

  final WorkspaceScopedRealtimeKind kind;
  final String? workspaceId;
  final String resourceId;
}

/// Surowe, rozszerzalne zdarzenie z zakresowego huba.
final class WorkspaceScopedRealtimeEvent {
  const WorkspaceScopedRealtimeEvent({
    required this.method,
    required this.payload,
    this.isReplay = false,
  });

  final String method;
  final Map<String, dynamic> payload;
  final bool isReplay;

  String? get eventId => _string(payload['eventId'] ?? payload['id']);
  int? get sequence => _int(
    payload['realtimeSequence'] ?? payload['sequence'] ?? payload['revision'],
  );

  static String? _string(Object? value) => value?.toString();

  static int? _int(Object? value) =>
      value is int ? value : int.tryParse(value?.toString() ?? '');
}

/// Błąd transportu lub niezgodności kontraktu huba.
final class WorkspaceScopedRealtimeError {
  const WorkspaceScopedRealtimeError(this.error, this.stackTrace);
  final Object error;
  final StackTrace stackTrace;
}

/// Wspólny właściciel cyklu życia Tasks, Whiteboard i Wiki.
///
/// Serwis nie zna Cubitów ani widgetów. Każdy ekran tworzy go lokalnie dla
/// jednego zasobu, a po zamknięciu wywołuje [dispose]. Po reconnect wykonuje
/// ponowną subskrypcję i replay od ostatniego kursora. W przypadku odpowiedzi
/// `resync-required` emituje zdarzenie oraz nie ukrywa go przed UI.
final class WorkspaceScopedRealtimeService {
  WorkspaceScopedRealtimeService({required this.client});

  final WorkspaceSignalRTransport client;
  final PublishSubject<WorkspaceScopedRealtimeEvent> _events =
      PublishSubject<WorkspaceScopedRealtimeEvent>();
  final PublishSubject<WorkspaceScopedRealtimeError> _errors =
      PublishSubject<WorkspaceScopedRealtimeError>();
  final Set<String> _seen = <String>{};
  final Map<String, int> _latest = <String, int>{};
  StreamSubscription<WorkspaceSignalRConnectionState>? _states;
  WorkspaceScopedRealtimeTarget? _target;
  String? _cursor;
  bool _started = false;
  bool _connectedOnce = false;
  bool _replayInFlight = false;

  Stream<WorkspaceScopedRealtimeEvent> get events => _events.stream;
  Stream<WorkspaceScopedRealtimeError> get errors => _errors.stream;
  Stream<WorkspaceSignalRConnectionState> get connectionStates => client.states;

  Future<void> start(WorkspaceScopedRealtimeTarget target) async {
    if (target.resourceId.trim().isEmpty ||
        (target.kind == WorkspaceScopedRealtimeKind.tasks &&
            (target.workspaceId == null ||
                target.workspaceId!.trim().isEmpty))) {
      throw ArgumentError('Zakres realtime wymaga poprawnych identyfikatorów.');
    }
    if (_started && _sameTarget(_target!, target)) return;
    if (_started) await stop();
    _target = target;
    _started = true;
    _connectedOnce = false;
    _registerHandlers();
    _states = client.states.listen(_onState);
    try {
      await client.connect();
    } catch (error, stackTrace) {
      _report(error, stackTrace);
      await stop();
      rethrow;
    }
  }

  Future<void> stop() async {
    if (!_started) return;
    final target = _target;
    _started = false;
    _target = null;
    await _states?.cancel();
    _states = null;
    if (target != null) {
      try {
        await client.invoke(
          _unsubscribeMethod(target),
          args: <Object>[target.resourceId],
        );
      } catch (_) {
        // Logout i zamykanie ekranu nie mogą czekać na odsubskrybowanie.
      }
    }
    _seen.clear();
    _latest.clear();
    _cursor = null;
  }

  Future<void> dispose() async {
    await stop();
    await _events.close();
    await _errors.close();
    client.dispose();
  }

  void _registerHandlers() {
    for (final method in _methods) {
      client.on(method, (arguments) => _onEvent(method, arguments));
    }
  }

  void _onState(WorkspaceSignalRConnectionState state) {
    if (state != WorkspaceSignalRConnectionState.connected || !_started) return;
    final replay = _connectedOnce;
    _connectedOnce = true;
    unawaited(_subscribeAndReplay(replay: replay));
  }

  Future<void> _subscribeAndReplay({required bool replay}) async {
    final target = _target;
    if (target == null || !_started) return;
    try {
      final args = target.kind == WorkspaceScopedRealtimeKind.tasks
          ? <Object>[target.workspaceId!, target.resourceId]
          : <Object>[target.resourceId];
      await client.invoke(_subscribeMethod(target), args: args);
      if (replay) await _replay(target);
    } catch (error, stackTrace) {
      _report(error, stackTrace);
    }
  }

  Future<void> _replay(WorkspaceScopedRealtimeTarget target) async {
    if (_replayInFlight || !_started) return;
    _replayInFlight = true;
    try {
      final args = target.kind == WorkspaceScopedRealtimeKind.tasks
          ? <Object>[target.workspaceId!, target.resourceId, _cursor ?? '', 100]
          : <Object>[target.resourceId, _cursor ?? '', 500];
      final result = await client.invoke(_replayMethod(target), args: args);
      final page = _decodePage(result);
      for (final event in page.events) {
        _emit(event.method, event.payload, isReplay: true);
      }
      _cursor = page.nextCursor ?? _cursor;
    } catch (error, stackTrace) {
      _report(error, stackTrace);
    } finally {
      _replayInFlight = false;
    }
  }

  void _onEvent(String method, List<Object?>? arguments) {
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
    final event = WorkspaceScopedRealtimeEvent(
      method: method,
      payload: Map<String, dynamic>.unmodifiable(payload),
      isReplay: isReplay,
    );
    final id = event.eventId;
    if (id != null && !_seen.add(id)) return;
    final sequence = event.sequence;
    if (sequence != null) {
      final key = '${_target?.resourceId ?? ''}:$method';
      if ((_latest[key] ?? -1) >= sequence) return;
      _latest[key] = sequence;
      _cursor = '$sequence';
    }
    if (!_events.isClosed) _events.add(event);
  }

  void _report(Object error, StackTrace stackTrace) {
    if (!_errors.isClosed) {
      _errors.add(WorkspaceScopedRealtimeError(error, stackTrace));
    }
  }

  static bool _sameTarget(
    WorkspaceScopedRealtimeTarget a,
    WorkspaceScopedRealtimeTarget b,
  ) =>
      a.kind == b.kind &&
      a.workspaceId == b.workspaceId &&
      a.resourceId == b.resourceId;

  static String _subscribeMethod(WorkspaceScopedRealtimeTarget target) =>
      switch (target.kind) {
        WorkspaceScopedRealtimeKind.tasks => 'SubscribeProject',
        WorkspaceScopedRealtimeKind.whiteboard => 'SubscribeBoard',
        WorkspaceScopedRealtimeKind.wiki => 'JoinWikiPage',
      };

  static String _unsubscribeMethod(WorkspaceScopedRealtimeTarget target) =>
      switch (target.kind) {
        WorkspaceScopedRealtimeKind.tasks => 'UnsubscribeProject',
        WorkspaceScopedRealtimeKind.whiteboard => 'UnsubscribeBoard',
        WorkspaceScopedRealtimeKind.wiki => 'LeaveWikiPage',
      };

  static String _replayMethod(WorkspaceScopedRealtimeTarget target) =>
      switch (target.kind) {
        WorkspaceScopedRealtimeKind.tasks => 'GetProjectEvents',
        WorkspaceScopedRealtimeKind.whiteboard => 'GetBoardEvents',
        WorkspaceScopedRealtimeKind.wiki => 'GetWikiPageEvents',
      };

  static const _methods = <String>[
    'task.created',
    'task.updated',
    'task.status_changed',
    'task.kanban_moved',
    'task.kanban_bulk_moved',
    'task.kanban_column_rebalanced',
    'task.archived',
    'task.restored',
    'task.recurrence_changed',
    'project.presence.changed',
    'whiteboard.presence.changed',
    'whiteboard.cursor.changed',
    'whiteboard.operation.applied',
    'whiteboard.resync.required',
    'wiki.presence.changed',
    'wiki.selection.changed',
    'wiki.page.updated',
    'wiki.page.moved',
    'wiki.page.verified',
    'wiki.events.resync-required',
  ];

  static _ReplayPage _decodePage(Object? value) {
    final map = value is Map
        ? Map<String, dynamic>.from(value)
        : const <String, dynamic>{};
    final raw = map['items'] ?? map['events'] ?? const <Object?>[];
    final list = raw is List ? raw : const <Object?>[];
    final events = <WorkspaceScopedRealtimeEvent>[];
    for (final item in list) {
      final decoded = item is Map ? Map<String, dynamic>.from(item) : null;
      if (decoded == null) continue;
      final method =
          decoded['eventType']?.toString() ??
          decoded['type']?.toString() ??
          'realtime.event';
      final payloadJson = decoded['payloadJson'];
      final payload = payloadJson is String ? _jsonMap(payloadJson) : decoded;
      events.add(
        WorkspaceScopedRealtimeEvent(
          method: method,
          payload: payload,
          isReplay: true,
        ),
      );
    }
    return _ReplayPage(events, map['nextCursor']?.toString());
  }

  static Map<String, dynamic>? _mapArgument(List<Object?>? arguments) {
    final value = arguments == null || arguments.isEmpty
        ? null
        : arguments.first;
    return value is Map ? Map<String, dynamic>.from(value) : null;
  }

  static Map<String, dynamic> _jsonMap(String value) {
    try {
      final decoded = jsonDecode(value);
      return decoded is Map
          ? Map<String, dynamic>.from(decoded)
          : <String, dynamic>{'payload': decoded};
    } catch (_) {
      return <String, dynamic>{'payloadJson': value};
    }
  }
}

/// Fabryka lokalnych serwisów zakresowych; każdy ekran dostaje własny
/// transport, więc zamknięcie jednego projektu nie zrywa innych subskrypcji.
///
/// Klasa pozostaje rozszerzalna, aby composition tests mogły podać lokalny,
/// nietransportowy hub bez uruchamiania sieci. Produkcyjna kompozycja nadal
/// korzysta z tej implementacji i nie zmienia zachowania runtime.
class WorkspaceScopedRealtimeFactory {
  const WorkspaceScopedRealtimeFactory({
    required this.baseUrl,
    required this.accessTokenProvider,
  });

  final String baseUrl;
  final Future<String?> Function() accessTokenProvider;

  WorkspaceScopedRealtimeService create(WorkspaceScopedRealtimeKind kind) {
    final hub = switch (kind) {
      WorkspaceScopedRealtimeKind.tasks => 'tasks',
      WorkspaceScopedRealtimeKind.whiteboard => 'whiteboard',
      WorkspaceScopedRealtimeKind.wiki => 'wiki',
    };
    return WorkspaceScopedRealtimeService(
      client: WorkspaceSignalRClient(
        '$baseUrl/api/v1/realtime/$hub',
        accessTokenProvider,
      ),
    );
  }
}

final class _ReplayPage {
  const _ReplayPage(this.events, this.nextCursor);
  final List<WorkspaceScopedRealtimeEvent> events;
  final String? nextCursor;
}
