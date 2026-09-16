import 'dart:async';

import 'package:ready_next/workspaces/data/notifications/models/notification_models.dart';
import 'package:ready_next/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:ready_next/workspaces/domain/repositories/notifications_repository.dart';
import 'package:rxdart/rxdart.dart';

/// Zdarzenie nowego elementu prywatnej skrzynki.
final class NotificationCreatedRealtimeEvent {
  /// Tworzy zdarzenie z kontraktu `notification.created`.
  const NotificationCreatedRealtimeEvent(this.notification);

  /// Pełny element powiadomienia zwrócony przez backend.
  final WorkspaceNotificationResponse notification;
}

/// Potwierdza pełny, access-safe resync kursora po reconnect.
final class NotificationUnreadCountReconciledRealtimeEvent {
  /// Tworzy wynik końcowy replayu, po pobraniu list i bieżącego badge'a.
  const NotificationUnreadCountReconciledRealtimeEvent(this.unreadCount);

  /// Licznik zwrócony przez backend po zrekoncyliowaniu wszystkich stron.
  final int unreadCount;
}

/// Snapshot grupy z huba albo z REST-owego replayu po reconnect.
final class NotificationGroupUpdatedRealtimeEvent {
  /// Tworzy zdarzenie z kontraktu `notification.group.updated`.
  const NotificationGroupUpdatedRealtimeEvent(
    this.group, {
    this.isReplay = false,
  });

  /// Najnowszy access-safe snapshot grupy.
  final NotificationGroupResponse group;

  /// Czy snapshot pochodzi z odtworzenia REST po przerwaniu połączenia.
  final bool isReplay;
}

/// Minimalny sygnał cofnięcia dostępu do grupy; celowo nie zawiera jej danych.
final class NotificationGroupRemovedRealtimeEvent {
  /// Tworzy sygnał zgodny z `notification.group.removed` backendu.
  const NotificationGroupRemovedRealtimeEvent({
    required this.groupKey,
    required this.realtimeSequence,
  });

  /// Klucz jedynego lokalnego wpisu, który wolno usunąć.
  final String groupKey;

  /// Sekwencja chroniąca przed spóźnionym remove albo update.
  final int realtimeSequence;
}

/// Stan błędu transportu lub replayu, przekazywany właścicielowi realtime.
final class WorkspaceNotificationsRealtimeError {
  /// Tworzy błąd bez zastępowania go tekstem UI.
  const WorkspaceNotificationsRealtimeError(this.error, this.stackTrace);

  /// Oryginalny błąd warstwy transportu/API.
  final Object error;

  /// Stos wywołań, jeśli był dostępny.
  final StackTrace stackTrace;
}

/// Właściciel lifecycle huba powiadomień dla jednej sesji użytkownika.
///
/// Rejestruje handlery przed `connect`, odrzuca duplikaty po `eventId` oraz
/// starsze snapshoty po `RealtimeSequence`. Po ponownym połączeniu pobiera
/// aktualny snapshot grup przez repozytorium REST — kursor pozostaje ukryty
/// w repozytorium i nie jest rekonstruowany po stronie klienta.
final class WorkspaceNotificationsRealtimeService {
  /// Tworzy serwis z transportem SignalR i repozytorium REST.
  WorkspaceNotificationsRealtimeService({
    required this._client,
    required this._notificationsRepository,
  });

  final WorkspaceSignalRTransport _client;
  final NotificationsRepository _notificationsRepository;
  final PublishSubject<Object> _events = PublishSubject<Object>();
  final PublishSubject<WorkspaceNotificationsRealtimeError> _errors =
      PublishSubject<WorkspaceNotificationsRealtimeError>();
  final Map<String, int> _latestGroupSequences = <String, int>{};
  final Set<String> _seenEventIds = <String>{};
  StreamSubscription<WorkspaceSignalRConnectionState>? _stateSubscription;
  bool _started = false;
  bool _wasConnected = false;
  bool _replayInFlight = false;
  int _sessionGeneration = 0;
  int _requestedReplayGeneration = 0;

  /// Zdarzenia domenowe do konsumpcji przez Cubit lub innego właściciela stanu.
  Stream<Object> get events => _events.stream;

  /// Błędy pozostają jawne; UI nie powinno ich ukrywać ani zastępować fallbackiem.
  Stream<WorkspaceNotificationsRealtimeError> get errors => _errors.stream;

  /// Stan połączenia transportowego.
  Stream<WorkspaceSignalRConnectionState> get connectionStates =>
      _client.states;

  /// Uruchamia hub dla bieżącej sesji. Operacja jest idempotentna.
  Future<void> start() async {
    if (_started) return;
    _started = true;
    _sessionGeneration++;
    _wasConnected = false;
    _registerHandlers();
    _stateSubscription = _client.states.listen(_handleConnectionState);
    try {
      await _client.connect();
    } catch (error, stackTrace) {
      _started = false;
      await _stateSubscription?.cancel();
      _stateSubscription = null;
      await _client.disconnect();
      _reportError(error, stackTrace);
      rethrow;
    }
  }

  /// Zatrzymuje hub i czyści dane deduplikacji należące do sesji użytkownika.
  Future<void> stop() async {
    if (!_started) return;
    _started = false;
    _sessionGeneration++;
    _requestedReplayGeneration++;
    _wasConnected = false;
    await _stateSubscription?.cancel();
    _stateSubscription = null;
    await _client.disconnect();
    _latestGroupSequences.clear();
    _seenEventIds.clear();
  }

  /// Zwalnia strumienie i transport przy zamykaniu aplikacji.
  Future<void> dispose() async {
    await stop();
    await _events.close();
    await _errors.close();
    _client.dispose();
  }

  void _registerHandlers() {
    _client.on('notification.created', _handleCreated);
    _client.on('notification.group.updated', _handleGroupUpdated);
    _client.on('notification.group.removed', _handleGroupRemoved);
  }

  void _handleGroupRemoved(List<Object?>? arguments) {
    final payload = _mapArgument(arguments);
    if (payload == null) return;
    try {
      final groupKey = payload['groupKey'];
      final sequence = payload['realtimeSequence'];
      if (groupKey is! String || groupKey.isEmpty || sequence is! num) return;
      final value = sequence.toInt();
      final previous = _latestGroupSequences[groupKey];
      if (previous != null && value <= previous) return;
      _latestGroupSequences[groupKey] = value;
      _events.add(
        NotificationGroupRemovedRealtimeEvent(
          groupKey: groupKey,
          realtimeSequence: value,
        ),
      );
    } catch (error, stackTrace) {
      _reportError(error, stackTrace);
    }
  }

  void _handleCreated(List<Object?>? arguments) {
    final payload = _mapArgument(arguments);
    if (payload == null) return;
    try {
      final notification = WorkspaceNotificationResponse.fromJson(payload);
      if (!_seenEventIds.add(notification.eventId)) return;
      _events.add(NotificationCreatedRealtimeEvent(notification));
    } catch (error, stackTrace) {
      _reportError(error, stackTrace);
    }
  }

  void _handleGroupUpdated(List<Object?>? arguments) {
    final payload = _mapArgument(arguments);
    if (payload == null) return;
    try {
      final group = NotificationGroupResponse.fromJson(payload);
      if (!_acceptGroup(group)) return;
      _events.add(NotificationGroupUpdatedRealtimeEvent(group));
    } catch (error, stackTrace) {
      _reportError(error, stackTrace);
    }
  }

  bool _acceptGroup(NotificationGroupResponse group) {
    final sequence = group.realtimeSequence;
    if (sequence != null) {
      final previous = _latestGroupSequences[group.groupKey];
      if (previous != null && sequence <= previous) return false;
      _latestGroupSequences[group.groupKey] = sequence;
      return true;
    }
    return _seenEventIds.add(group.latest.eventId);
  }

  void _handleConnectionState(WorkspaceSignalRConnectionState state) {
    if (state != WorkspaceSignalRConnectionState.connected) return;
    final shouldReplay = _wasConnected;
    _wasConnected = true;
    if (shouldReplay) _requestInboxReplay();
  }

  /// Scalony replay: kolejny reconnect unieważnia starszy przebieg, ale nie
  /// otwiera równoległych pętli cursorowych dla tej samej sesji.
  void _requestInboxReplay() {
    if (!_started) return;
    _requestedReplayGeneration++;
    if (!_replayInFlight) unawaited(_runRequestedInboxReplay());
  }

  Future<void> _runRequestedInboxReplay() async {
    _replayInFlight = true;
    try {
      while (_started) {
        final sessionGeneration = _sessionGeneration;
        final replayGeneration = _requestedReplayGeneration;
        await _replayInbox(
          sessionGeneration: sessionGeneration,
          replayGeneration: replayGeneration,
        );
        if (!_started || sessionGeneration != _sessionGeneration) return;
        if (replayGeneration == _requestedReplayGeneration) return;
      }
    } finally {
      _replayInFlight = false;
    }
  }

  Future<void> _replayInbox({
    required int sessionGeneration,
    required int replayGeneration,
  }) async {
    try {
      final itemsReplayed = await _replayNotificationPages(
        sessionGeneration: sessionGeneration,
        replayGeneration: replayGeneration,
      );
      if (!_isReplayCurrent(sessionGeneration, replayGeneration)) return;
      final groupsReplayed = await _replayGroupPages(
        sessionGeneration: sessionGeneration,
        replayGeneration: replayGeneration,
      );
      if (!itemsReplayed ||
          !groupsReplayed ||
          !_isReplayCurrent(sessionGeneration, replayGeneration)) {
        return;
      }
      final unread = await _notificationsRepository.unreadCount();
      if (!_isReplayCurrent(sessionGeneration, replayGeneration)) return;
      unread.fold(
        (error) => _reportError(error, StackTrace.current),
        (count) => _events.add(
          NotificationUnreadCountReconciledRealtimeEvent(count),
        ),
      );
    } catch (error, stackTrace) {
      _reportError(error, stackTrace);
    }
  }

  Future<bool> _replayNotificationPages({
    required int sessionGeneration,
    required int replayGeneration,
  }) async {
    try {
      String? cursor;
      for (var pageIndex = 0; pageIndex < 100; pageIndex++) {
        if (!_isReplayCurrent(sessionGeneration, replayGeneration)) {
          return false;
        }
        final result = await _notificationsRepository.listNotifications(
          cursor: cursor,
        );
        if (!_isReplayCurrent(sessionGeneration, replayGeneration)) {
          return false;
        }
        var continuePaging = false;
        var succeeded = true;
        result.fold(
          (error) {
            _reportError(error, StackTrace.current);
            succeeded = false;
          },
          (page) {
            for (final notification in page.items) {
              if (!_isReplayCurrent(sessionGeneration, replayGeneration)) {
                return;
              }
              if (_seenEventIds.add(notification.eventId)) {
                _events.add(
                  NotificationCreatedRealtimeEvent(notification),
                );
              }
            }
            cursor = page.nextCursor;
            continuePaging = cursor != null;
          },
        );
        if (!succeeded) return false;
        if (!continuePaging) return true;
        if (pageIndex == 99) {
          _reportError(
            StateError('Przekroczono limit 100 stron replayu powiadomień.'),
            StackTrace.current,
          );
          return false;
        }
      }
      return true;
    } catch (error, stackTrace) {
      _reportError(error, stackTrace);
      return false;
    }
  }

  Future<bool> _replayGroupPages({
    required int sessionGeneration,
    required int replayGeneration,
  }) async {
    try {
      String? cursor;
      for (var pageIndex = 0; pageIndex < 100; pageIndex++) {
        if (!_isReplayCurrent(sessionGeneration, replayGeneration)) {
          return false;
        }
        final result = await _notificationsRepository.listGroups(
          cursor: cursor,
        );
        if (!_isReplayCurrent(sessionGeneration, replayGeneration)) {
          return false;
        }
        var continuePaging = false;
        var succeeded = true;
        result.fold(
          (error) {
            _reportError(error, StackTrace.current);
            succeeded = false;
          },
          (page) {
            for (final group in page.items) {
              if (!_isReplayCurrent(sessionGeneration, replayGeneration)) {
                return;
              }
              if (_acceptGroup(group)) {
                _events.add(
                  NotificationGroupUpdatedRealtimeEvent(group, isReplay: true),
                );
              }
            }
            cursor = page.nextCursor;
            continuePaging = cursor != null;
          },
        );
        if (!succeeded) return false;
        if (!continuePaging) return true;
        if (pageIndex == 99) {
          _reportError(
            StateError(
              'Przekroczono limit 100 stron replayu grup powiadomień.',
            ),
            StackTrace.current,
          );
          return false;
        }
      }
      return true;
    } catch (error, stackTrace) {
      _reportError(error, stackTrace);
      return false;
    }
  }

  bool _isReplayCurrent(int sessionGeneration, int replayGeneration) =>
      _started &&
      sessionGeneration == _sessionGeneration &&
      replayGeneration == _requestedReplayGeneration;

  Map<String, dynamic>? _mapArgument(List<Object?>? arguments) {
    final value = arguments?.firstOrNull;
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  void _reportError(Object error, StackTrace stackTrace) {
    if (!_errors.isClosed) {
      _errors.add(WorkspaceNotificationsRealtimeError(error, stackTrace));
    }
  }
}
