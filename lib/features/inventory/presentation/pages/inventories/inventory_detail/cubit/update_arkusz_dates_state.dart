import 'package:equatable/equatable.dart';

/// Stan modalu edycji dat arkusza.
sealed class UpdateArkuszDatesState extends Equatable {
  /// Tworzy bazowy stan edycji dat arkusza.
  const UpdateArkuszDatesState();

  @override
  List<Object?> get props => [];
}

/// Stan poczatkowy modalu edycji dat arkusza.
final class UpdateArkuszDatesInitial extends UpdateArkuszDatesState {
  /// Tworzy stan poczatkowy.
  const UpdateArkuszDatesInitial();
}

/// Stan wykonywania zapisu dat arkusza.
final class UpdateArkuszDatesSubmitting extends UpdateArkuszDatesState {
  /// Tworzy stan wykonywania zapisu.
  const UpdateArkuszDatesSubmitting();
}

/// Stan poprawnego zapisu dat arkusza.
final class UpdateArkuszDatesSuccess extends UpdateArkuszDatesState {
  /// Tworzy stan sukcesu.
  const UpdateArkuszDatesSuccess();
}

/// Stan bledu zapisu dat arkusza.
final class UpdateArkuszDatesError extends UpdateArkuszDatesState {
  /// Tworzy stan bledu backendowego.
  const UpdateArkuszDatesError({required this.message});

  /// Komunikat bledu zwrocony do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}
