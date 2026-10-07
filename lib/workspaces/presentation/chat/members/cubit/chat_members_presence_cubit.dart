import 'dart:async';

import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/domain/chat/members/chat_members_presence_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Null status jest nieznany, nigdy domyślnie Offline po awarii.
final class ChatMembersPresenceState {
  const ChatMembersPresenceState({
    this.users = const {},
    this.failure,
    this.isLoading = false,
  });

  final Map<String, bool> users;
  final ApiError? failure;
  final bool isLoading;
}

/// Snapshot ma ograniczony czas życia; właściciel zawiesza odczyt po ukryciu UI.
final class ChatMembersPresenceCubit extends Cubit<ChatMembersPresenceState> {
  ChatMembersPresenceCubit({
    required ChatMembersPresenceRepository repository,
    required this.conversationId,
    this.pollInterval = const Duration(seconds: 15),
    this.maxAge = const Duration(seconds: 30),
    DateTime Function()? now,
    // Public dependency name is retained; the owned field stays private.
    // ignore: prefer_initializing_formals
  }) : _repository = repository,
       _now = now ?? DateTime.now,
       super(const ChatMembersPresenceState());

  final ChatMembersPresenceRepository _repository;
  final String conversationId;
  final Duration pollInterval;
  final Duration maxAge;
  final DateTime Function() _now;
  DateTime? _retryAfter;
  Timer? _poll;
  Timer? _expiry;
  bool _active = true;
  bool _pending = false;
  int _generation = 0;

  Future<void> refresh() async {
    if (isClosed || !_active || _pending) return;
    if (_retryAfter != null && _now().toUtc().isBefore(_retryAfter!)) return;
    _poll?.cancel();
    _pending = true;
    final generation = ++_generation;
    emit(ChatMembersPresenceState(users: state.users, isLoading: true));
    final result = await _repository.loadMembersPresence(conversationId);
    if (isClosed || !_active || generation != _generation) return;
    _pending = false;
    _expiry?.cancel();
    result.fold(
      (error) {
        _retryAfter = error.retryAfterUtc;
        emit(ChatMembersPresenceState(failure: error));
      },
      (snapshot) {
        _retryAfter = null;
        final remaining = snapshot.snapshotAtUtc
            .add(maxAge)
            .difference(_now().toUtc());
        if (remaining <= Duration.zero ||
            snapshot.snapshotAtUtc.isAfter(
              _now().toUtc().add(const Duration(seconds: 5)),
            )) {
          emit(const ChatMembersPresenceState());
          return;
        }
        emit(ChatMembersPresenceState(users: snapshot.users));
        _expiry = Timer(remaining > maxAge ? maxAge : remaining, _expire);
      },
    );
    // Odebrané uprawnienie zatrzymuje polling i usuwa cached obecność.
    if (state.failure?.statusCode case 401 || 403 || 404) return;
    final retryDelay = _retryAfter?.difference(_now().toUtc()) ?? Duration.zero;
    _poll = Timer(
      retryDelay > pollInterval ? retryDelay : pollInterval,
      () => unawaited(refresh()),
    );
  }

  void _expire() {
    if (!isClosed) emit(const ChatMembersPresenceState());
  }

  void setActive(bool active) {
    if (isClosed || _active == active) return;
    _active = active;
    _generation++;
    _pending = false;
    _poll?.cancel();
    _expiry?.cancel();
    emit(const ChatMembersPresenceState());
    if (active) {
      final retryDelay =
          _retryAfter?.difference(_now().toUtc()) ?? Duration.zero;
      if (retryDelay > Duration.zero) {
        _poll = Timer(retryDelay, () => unawaited(refresh()));
      } else {
        unawaited(refresh());
      }
    }
  }

  @override
  Future<void> close() {
    _generation++;
    _poll?.cancel();
    _expiry?.cancel();
    return super.close();
  }
}
