import 'package:equatable/equatable.dart';

/// Bazowy stan formularza zmiany hasła.
sealed class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy gotowy do wprowadzania danych.
final class ChangePasswordInitial extends ChangePasswordState {
  const ChangePasswordInitial();
}

/// Stan w trakcie wysyłania żądania zmiany hasła do backendu.
final class ChangePasswordSubmitting extends ChangePasswordState {
  const ChangePasswordSubmitting();
}

/// Stan po pomyślnej zmianie hasła.
final class ChangePasswordSuccess extends ChangePasswordState {
  const ChangePasswordSuccess({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/// Stan błędu zmiany hasła (walidacja po stronie klienta lub błąd z serwera).
final class ChangePasswordFailure extends ChangePasswordState {
  const ChangePasswordFailure({
    required this.message,
    this.code,
    this.traceId,
  });

  final String message;
  final String? code;
  final String? traceId;

  @override
  List<Object?> get props => [message, code, traceId];
}
