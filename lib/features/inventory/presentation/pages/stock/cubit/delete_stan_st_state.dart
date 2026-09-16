import 'package:equatable/equatable.dart';

/// Stan modalu usuwania pojedynczego rekordu `stan_st`.
sealed class DeleteStanStState extends Equatable {
  /// Tworzy bazowy stan usuwania rekordu `stan_st`.
  const DeleteStanStState();

  @override
  List<Object?> get props => [];
}

/// Stan poczatkowy modalu usuwania.
final class DeleteStanStInitial extends DeleteStanStState {
  /// Tworzy stan poczatkowy.
  const DeleteStanStInitial();
}

/// Stan wykonywania usuniecia rekordu.
final class DeleteStanStSubmitting extends DeleteStanStState {
  /// Tworzy stan wysylania zadania usuniecia.
  const DeleteStanStSubmitting();
}

/// Stan poprawnego usuniecia rekordu.
final class DeleteStanStSuccess extends DeleteStanStState {
  /// Tworzy stan sukcesu.
  const DeleteStanStSuccess();
}

/// Stan bledu usuwania rekordu `stan_st`.
final class DeleteStanStError extends DeleteStanStState {
  /// Tworzy stan bledu z komunikatem do UI.
  const DeleteStanStError({required this.message});

  /// Komunikat bledu zwrocony przez repository.
  final String message;

  @override
  List<Object?> get props => [message];
}
