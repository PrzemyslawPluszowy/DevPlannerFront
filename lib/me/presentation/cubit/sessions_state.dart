import 'package:devplanner/me/domain/models/user_session_item.dart';
import 'package:equatable/equatable.dart';

/// Bazowy stan listy aktywnych sesji urządzeń.
sealed class SessionsState extends Equatable {
  const SessionsState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy przed załadowaniem listy sesji.
final class SessionsInitial extends SessionsState {
  const SessionsInitial();
}

/// Stan oczekiwania na pobranie listy sesji z backendu.
final class SessionsLoading extends SessionsState {
  const SessionsLoading();
}

/// Stan z pomyślnie załadowaną listą sesji urządzeń.
final class SessionsLoaded extends SessionsState {
  const SessionsLoaded({
    required this.sessions,
    this.revokingSessionId,
    this.actionMessage,
  });

  /// Lista aktywnych sesji urządzeń.
  final List<UserSessionItem> sessions;

  /// Identyfikator sesji aktualnie unieważnianej (do wyświetlenia spinnera w wierszu).
  final String? revokingSessionId;

  /// Opcjonalny komunikat sukcesu (np. po pomyślnym unieważnieniu sesji).
  final String? actionMessage;

  @override
  List<Object?> get props => [sessions, revokingSessionId, actionMessage];
}

/// Stan błędu pobierania lub unieważniania sesji.
final class SessionsError extends SessionsState {
  const SessionsError({
    required this.message,
    this.code,
    this.traceId,
    this.lastSessions,
  });

  final String message;
  final String? code;
  final String? traceId;
  final List<UserSessionItem>? lastSessions;

  @override
  List<Object?> get props => [message, code, traceId, lastSessions];
}
