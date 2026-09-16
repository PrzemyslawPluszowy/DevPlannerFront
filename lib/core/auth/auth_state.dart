import 'package:equatable/equatable.dart';
import 'package:ready_next/core/auth/auth_models.dart';

/// Bazowy stan sesji standalone.
sealed class AuthState extends Equatable {
  /// Tworzy bazowy stan autoryzacji.
  const AuthState();
}

/// Stan inicjalnego odtwarzania sesji.
final class AuthLoading extends AuthState {
  /// Tworzy stan ladowania sesji.
  const AuthLoading();

  @override
  List<Object?> get props => [];
}

/// Stan braku aktywnej sesji.
final class AuthUnauthenticated extends AuthState {
  /// Tworzy stan niezalogowanego uzytkownika.
  const AuthUnauthenticated({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Stan poprawnie zalogowanej sesji.
final class AuthAuthenticated extends AuthState {
  /// Tworzy stan zalogowanego uzytkownika.
  const AuthAuthenticated({required this.user});

  final AuthUser? user;

  @override
  List<Object?> get props => [
    user?.userId,
    user?.login,
    user?.displayName,
    user?.coreUserId,
    user?.permissions,
  ];
}
