import 'package:equatable/equatable.dart';

/// Stan modalu usuwania arkusza.
sealed class DeleteArkuszState extends Equatable {
  /// Tworzy bazowy stan usuwania arkusza.
  const DeleteArkuszState();

  @override
  List<Object?> get props => [];
}

/// Stan poczatkowy modalu usuwania arkusza.
final class DeleteArkuszInitial extends DeleteArkuszState {
  /// Tworzy stan poczatkowy.
  const DeleteArkuszInitial();
}

/// Stan wykonywania usuniecia arkusza.
final class DeleteArkuszSubmitting extends DeleteArkuszState {
  /// Tworzy stan wykonywania usuwania.
  const DeleteArkuszSubmitting();
}

/// Stan poprawnego usuniecia arkusza.
final class DeleteArkuszSuccess extends DeleteArkuszState {
  /// Tworzy stan sukcesu usuwania.
  const DeleteArkuszSuccess();
}

/// Stan zablokowania usuwania arkusza przez guard biznesowy.
final class DeleteArkuszBlocked extends DeleteArkuszState {
  /// Tworzy stan blokady usuwania.
  const DeleteArkuszBlocked();
}

/// Stan bledu usuwania arkusza.
final class DeleteArkuszError extends DeleteArkuszState {
  /// Tworzy stan bledu usuwania.
  const DeleteArkuszError({required this.message});

  /// Komunikat bledu zwrocony do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}
