import 'package:equatable/equatable.dart';

/// Stan modalu edycji numeru arkusza.
sealed class UpdateArkuszNumerState extends Equatable {
  /// Tworzy bazowy stan edycji numeru arkusza.
  const UpdateArkuszNumerState();

  @override
  List<Object?> get props => [];
}

/// Stan poczatkowy modalu edycji numeru arkusza.
final class UpdateArkuszNumerInitial extends UpdateArkuszNumerState {
  /// Tworzy stan poczatkowy.
  const UpdateArkuszNumerInitial();
}

/// Stan wykonywania zapisu numeru arkusza.
final class UpdateArkuszNumerSubmitting extends UpdateArkuszNumerState {
  /// Tworzy stan wykonywania zapisu.
  const UpdateArkuszNumerSubmitting();
}

/// Stan poprawnego zapisu numeru arkusza.
final class UpdateArkuszNumerSuccess extends UpdateArkuszNumerState {
  /// Tworzy stan sukcesu.
  const UpdateArkuszNumerSuccess();
}

/// Stan bledu zapisu numeru arkusza.
final class UpdateArkuszNumerError extends UpdateArkuszNumerState {
  /// Tworzy stan bledu backendowego.
  const UpdateArkuszNumerError({required this.message});

  /// Komunikat bledu zwrocony do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}
