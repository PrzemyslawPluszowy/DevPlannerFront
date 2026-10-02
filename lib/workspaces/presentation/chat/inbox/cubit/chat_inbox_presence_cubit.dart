import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/chat_inbox_presence_repository.dart';
import 'package:devplanner/workspaces/domain/chat/inbox/models/chat_inbox_export.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_cubit.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_presence_state.dart';
import 'package:devplanner/workspaces/presentation/chat/inbox/cubit/chat_inbox_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Owns one batched, session-scoped refresh for direct peers in the inbox.
final class ChatInboxPresenceCubit extends Cubit<ChatInboxPresenceState> {
  ChatInboxPresenceCubit({
    required ChatInboxCubit inbox,
    required ChatInboxPresenceRepository repository,
    required String currentUserId,
    AuthSessionPort? authSession,
    ValueListenable<bool>? presenceAvailability,
    this.refreshInterval = const Duration(seconds: 15),
    this.maxStaleAge = const Duration(seconds: 30),
    DateTime Function()? nowUtc,
  }) : // Public parameter names stay clear while their owned fields stay private.
       // ignore: prefer_initializing_formals, the public API stays named while owned storage remains private
       _repository = repository,
       _authSession = authSession,
       // Keep this optional public dependency separate from its private owner.
       // ignore: prefer_initializing_formals, the public API stays named while owned storage remains private
       _presenceAvailability = presenceAvailability,
       _inbox = inbox,
       _ownerUserId = currentUserId,
       _sessionUserId =
           authSession?.snapshot.user?.userId ??
           (authSession == null ? currentUserId : ''),
       _nowUtc = nowUtc ?? _defaultNowUtc,
       super(const ChatInboxPresenceState()) {
    _inboxSubscription = inbox.stream.listen(_onInboxState);
    _authSession?.addListener(_onSessionChanged);
    _connectionWasAvailable = _presenceAvailability?.value ?? false;
    _presenceAvailability?.addListener(_onPresenceAvailabilityChanged);
    _onInboxState(inbox.state);
  }

  final ChatInboxPresenceRepository _repository;
  final AuthSessionPort? _authSession;
  final ValueListenable<bool>? _presenceAvailability;
  final ChatInboxCubit _inbox;
  final Duration refreshInterval;
  final Duration maxStaleAge;
  final DateTime Function() _nowUtc;
  StreamSubscription<ChatInboxState>? _inboxSubscription;
  Timer? _refreshTimer;
  Timer? _staleTimer;
  Timer? _cooldownTimer;
  Completer<void>? _refreshFinished;
  List<String> _peerUserIds = const <String>[];
  final String _ownerUserId;
  String _sessionUserId;
  int _generation = 0;
  bool _inFlight = false;
  bool _retryInFlight = false;
  bool _suppressAutoRefresh = false;
  bool _connectionWasAvailable = false;

  void _onInboxState(ChatInboxState inboxState) {
    if (isClosed) return;
    if (_sessionUserId != _ownerUserId) {
      _clearPresence();
      return;
    }
    final nextPeerIds =
        inboxState is ChatInboxReady &&
            inboxState.filter != ChatInboxFilter.archived
        ? _peerIds(inboxState.items)
        : const <String>[];
    if (_sameIds(_peerUserIds, nextPeerIds)) return;
    _peerUserIds = nextPeerIds;
    _generation++;
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _staleTimer?.cancel();
    _staleTimer = null;
    _cooldownTimer?.cancel();
    _cooldownTimer = null;
    emit(const ChatInboxPresenceState());
    if (_peerUserIds.isEmpty || _suppressAutoRefresh) return;
    _ensureRefreshTimer();
    unawaited(refresh());
  }

  Future<void> refresh() async {
    if (isClosed || _inFlight || _peerUserIds.isEmpty) return;
    final retryAfterUtc = state.retryAfterUtc;
    if (retryAfterUtc != null && _nowUtc().toUtc().isBefore(retryAfterUtc)) {
      return;
    }
    _inFlight = true;
    final refreshFinished = Completer<void>();
    _refreshFinished = refreshFinished;
    final generation = _generation;
    final requestedIds = _peerUserIds;
    var stale = false;
    emit(
      ChatInboxPresenceState(
        statuses: state.statuses,
        snapshotAtUtc: state.snapshotAtUtc,
        isRefreshing: true,
      ),
    );
    try {
      final statuses = <String, bool>{};
      for (var offset = 0; offset < requestedIds.length; offset += 100) {
        final end = (offset + 100).clamp(0, requestedIds.length);
        final result = await _repository.loadPresence(
          requestedIds.sublist(offset, end),
        );
        if (isClosed) return;
        if (generation != _generation) {
          stale = true;
          return;
        }
        final failure = result.fold<ApiError?>(
          (error) => error,
          (batch) {
            statuses.addAll(batch);
            return null;
          },
        );
        if (failure case final error?) {
          _staleTimer?.cancel();
          _staleTimer = null;
          _startCooldown(error.retryAfterUtc);
          if (error.type == ApiErrorType.unauthorized ||
              error.type == ApiErrorType.forbidden ||
              error.type == ApiErrorType.notFound) {
            _refreshTimer?.cancel();
            _refreshTimer = null;
          }
          emit(
            ChatInboxPresenceState(
              error: error,
              retryAfterUtc: error.retryAfterUtc,
              retryCountdownSeconds: _retryCountdown(error.retryAfterUtc),
            ),
          );
          return;
        }
      }
      _cooldownTimer?.cancel();
      _cooldownTimer = null;
      final snapshotAtUtc = _nowUtc().toUtc();
      emit(
        ChatInboxPresenceState(
          statuses: Map<String, bool>.unmodifiable(statuses),
          snapshotAtUtc: snapshotAtUtc,
        ),
      );
      _scheduleStaleExpiry(snapshotAtUtc);
    } finally {
      _inFlight = false;
      if (identical(_refreshFinished, refreshFinished)) {
        _refreshFinished = null;
        refreshFinished.complete();
      }
      if (stale && !isClosed && _peerUserIds.isNotEmpty) {
        unawaited(refresh());
      }
    }
  }

  /// Retries a failed batch, reconciling the inbox first after an ACL failure.
  Future<void> retry() async {
    if (isClosed || _retryInFlight) return;
    _retryInFlight = true;
    try {
      if (_inFlight) await _refreshFinished?.future;
      if (isClosed) return;
      final error = state.error;
      if (error?.type == ApiErrorType.forbidden ||
          error?.type == ApiErrorType.notFound) {
        _suppressAutoRefresh = true;
        try {
          await _inbox.refresh();
        } finally {
          _suppressAutoRefresh = false;
        }
      }
      if (isClosed) return;
      await refresh();
      if (!isClosed && state.error == null) _ensureRefreshTimer();
    } finally {
      _retryInFlight = false;
    }
  }

  void _ensureRefreshTimer() {
    if (isClosed || _peerUserIds.isEmpty || _refreshTimer != null) return;
    _refreshTimer = Timer.periodic(
      refreshInterval,
      (_) => unawaited(refresh()),
    );
  }

  void _onSessionChanged() {
    if (isClosed) return;
    final userId = _authSession?.snapshot.user?.userId ?? '';
    if (userId == _sessionUserId) return;
    _sessionUserId = userId;
    _generation++;
    _peerUserIds = const <String>[];
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _staleTimer?.cancel();
    _staleTimer = null;
    _cooldownTimer?.cancel();
    _cooldownTimer = null;
    emit(const ChatInboxPresenceState());
    if (userId == _ownerUserId) _onInboxState(_inbox.state);
  }

  void _onPresenceAvailabilityChanged() {
    if (isClosed) return;
    final available = _presenceAvailability?.value ?? false;
    if (available == _connectionWasAvailable) return;
    _connectionWasAvailable = available;
    _generation++;
    _staleTimer?.cancel();
    _staleTimer = null;
    _cooldownTimer?.cancel();
    _cooldownTimer = null;
    emit(const ChatInboxPresenceState());
    if (_peerUserIds.isNotEmpty) unawaited(refresh());
  }

  List<String> _peerIds(List<ChatInboxItem> items) {
    final ids = <String>{};
    for (final item in items) {
      final peerUserId = item.directPeerUserId;
      if (peerUserId != null && peerUserId.isNotEmpty) ids.add(peerUserId);
    }
    final sorted = ids.toList()..sort();
    return List<String>.unmodifiable(sorted);
  }

  void _scheduleStaleExpiry(DateTime snapshotAtUtc) {
    _staleTimer?.cancel();
    _staleTimer = Timer(maxStaleAge, () {
      if (isClosed || state.snapshotAtUtc != snapshotAtUtc) return;
      if (_nowUtc().toUtc().difference(snapshotAtUtc) < maxStaleAge) {
        _scheduleStaleExpiry(snapshotAtUtc);
        return;
      }
      emit(const ChatInboxPresenceState());
    });
  }

  void _startCooldown(DateTime? retryAfterUtc) {
    _cooldownTimer?.cancel();
    _cooldownTimer = null;
    if (retryAfterUtc == null || _retryCountdown(retryAfterUtc) == 0) return;
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed || state.error == null) {
        timer.cancel();
        _cooldownTimer = null;
        return;
      }
      final remaining = _retryCountdown(retryAfterUtc);
      emit(
        ChatInboxPresenceState(
          error: state.error,
          retryAfterUtc: retryAfterUtc,
          retryCountdownSeconds: remaining,
        ),
      );
      if (remaining == 0) {
        timer.cancel();
        _cooldownTimer = null;
      }
    });
  }

  int _retryCountdown(DateTime? retryAfterUtc) {
    if (retryAfterUtc == null) return 0;
    final difference = retryAfterUtc
        .difference(_nowUtc().toUtc())
        .inMilliseconds;
    if (difference <= 0) return 0;
    return (difference / Duration.millisecondsPerSecond).ceil();
  }

  void _clearPresence() {
    _generation++;
    _peerUserIds = const <String>[];
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _staleTimer?.cancel();
    _staleTimer = null;
    _cooldownTimer?.cancel();
    _cooldownTimer = null;
    emit(const ChatInboxPresenceState());
  }

  static DateTime _defaultNowUtc() => DateTime.now().toUtc();

  bool _sameIds(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var index = 0; index < a.length; index++) {
      if (a[index] != b[index]) return false;
    }
    return true;
  }

  @override
  Future<void> close() async {
    _generation++;
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _staleTimer?.cancel();
    _staleTimer = null;
    _cooldownTimer?.cancel();
    _cooldownTimer = null;
    _authSession?.removeListener(_onSessionChanged);
    _presenceAvailability?.removeListener(_onPresenceAvailabilityChanged);
    await _inboxSubscription?.cancel();
    return super.close();
  }
}
