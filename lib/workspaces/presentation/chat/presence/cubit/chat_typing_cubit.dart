import 'dart:async';

import 'package:devplanner/workspaces/domain/chat/realtime/chat_realtime_export.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Stan pisania innych uczestników otwartej rozmowy.
class ChatTypingState extends Equatable {
  /// Tworzy stan pisania.
  const ChatTypingState({this.typingUserIds = const <String>{}});

  /// UUID uczestników, którzy aktualnie piszą, bez bieżącego użytkownika.
  final Set<String> typingUserIds;

  /// Czy ktokolwiek poza bieżącym użytkownikiem pisze.
  bool get isTyping => typingUserIds.isNotEmpty;

  /// Tworzy kopię stanu z nowym zbiorem piszących.
  ChatTypingState copyWith({Set<String>? typingUserIds}) =>
      ChatTypingState(typingUserIds: typingUserIds ?? this.typingUserIds);

  @override
  List<Object?> get props => [typingUserIds];
}

/// Prowadzi stan pisania z TTL podanym przez serwer.
///
/// Pisanie jest ulotne, więc cubit trzyma wygaśnięcie per uczestnik i sam
/// usuwa wpis po TTL — brak zdarzenia „stop” nie może zostawić pisania na
/// zawsze. Własne zdarzenia są pomijane, bo nadawca nie jest dla siebie
/// wskaźnikiem.
final class ChatTypingCubit extends Cubit<ChatTypingState> {
  /// Tworzy cubit na strumieniu zdarzeń rozmowy.
  ChatTypingCubit({
    required ChatConversationRealtimeClient? realtime,
    required this.currentUserId,
    this.fallbackTtl = const Duration(seconds: 8),
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now,
       super(const ChatTypingState()) {
    _subscription = realtime?.conversationEvents.listen(_onEvent);
  }

  /// Local UserId bieżącej sesji; jego pisanie nie jest pokazywane.
  final String currentUserId;

  /// TTL używany, gdy serwer nie poda wygaśnięcia.
  final Duration fallbackTtl;

  final DateTime Function() _clock;
  StreamSubscription<ChatConversationRealtimeEvent>? _subscription;
  final Map<String, DateTime> _expiries = <String, DateTime>{};
  Timer? _purgeTimer;

  void _onEvent(ChatConversationRealtimeEvent event) {
    if (event.kind != ChatConversationRealtimeEventKind.typingChanged) return;
    final userId = event.typingUserId;
    if (userId == null || userId.isEmpty || userId == currentUserId) return;
    if (event.isTyping != true) {
      _remove(userId);
      return;
    }
    _expiries[userId] = event.typingExpiresAtUtc ?? _clock().add(fallbackTtl);
    emit(state.copyWith(typingUserIds: _expiries.keys.toSet()));
    _schedulePurge();
  }

  /// Usuwa wygasłe wpisy; wywoływane po każdym sygnale pisania.
  void _schedulePurge() {
    _purgeTimer?.cancel();
    final now = _clock();
    final next = _expiries.entries
        .where((entry) => entry.value.isAfter(now))
        .map((entry) => entry.value)
        .fold<DateTime?>(null, (current, value) {
          if (current == null) return value;
          return value.isBefore(current) ? value : current;
        });
    if (next == null) {
      _purge();
      return;
    }
    _purgeTimer = Timer(next.difference(now), _purge);
  }

  void _purge() {
    if (isClosed) return;
    final now = _clock();
    final expired = _expiries.entries
        .where((entry) => !entry.value.isAfter(now))
        .map((entry) => entry.key)
        .toList(growable: false);
    if (expired.isEmpty) return;
    expired.forEach(_expiries.remove);
    emit(state.copyWith(typingUserIds: _expiries.keys.toSet()));
    if (_expiries.isNotEmpty) _schedulePurge();
  }

  void _remove(String userId) {
    if (_expiries.remove(userId) == null) return;
    emit(state.copyWith(typingUserIds: _expiries.keys.toSet()));
  }

  @override
  Future<void> close() async {
    _purgeTimer?.cancel();
    await _subscription?.cancel();
    _expiries.clear();
    return super.close();
  }
}
