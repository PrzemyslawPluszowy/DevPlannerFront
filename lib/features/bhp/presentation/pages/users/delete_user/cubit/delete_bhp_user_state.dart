import 'package:equatable/equatable.dart';

/// Bazowy stan usuwania pracownika BHP.
sealed class DeleteBhpUserState extends Equatable {
  /// Tworzy bazowy stan usuwania pracownika.
  const DeleteBhpUserState();

  @override
  List<Object?> get props => const [];
}

/// Stan początkowy modalu usuwania pracownika.
final class DeleteBhpUserInitial extends DeleteBhpUserState {
  /// Tworzy stan początkowy modalu usuwania.
  const DeleteBhpUserInitial();
}

/// Stan wykonywania archiwizacji pracownika.
final class DeleteBhpUserSubmitting extends DeleteBhpUserState {
  /// Tworzy stan wykonywania archiwizacji.
  const DeleteBhpUserSubmitting();
}

/// Stan poprawnej archiwizacji pracownika.
final class DeleteBhpUserSuccess extends DeleteBhpUserState {
  /// Tworzy stan poprawnej archiwizacji pracownika.
  const DeleteBhpUserSuccess();
}

/// Stan błędu archiwizacji pracownika.
final class DeleteBhpUserError extends DeleteBhpUserState {
  /// Tworzy stan błędu archiwizacji pracownika.
  const DeleteBhpUserError({required this.message});

  /// Komunikat błędu zwrócony do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}
