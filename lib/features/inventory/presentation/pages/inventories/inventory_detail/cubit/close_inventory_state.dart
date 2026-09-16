import 'package:equatable/equatable.dart';

/// Stan modalu zamykania inwentaryzacji.
sealed class CloseInventoryState extends Equatable {
  /// Tworzy bazowy stan zamykania inwentaryzacji.
  const CloseInventoryState();

  @override
  List<Object?> get props => [];
}

/// Stan poczatkowy modalu zamykania.
final class CloseInventoryInitial extends CloseInventoryState {
  /// Tworzy stan poczatkowy.
  const CloseInventoryInitial();
}

/// Stan wykonywania zamykania inwentaryzacji.
final class CloseInventorySubmitting extends CloseInventoryState {
  /// Tworzy stan wykonywania zamykania.
  const CloseInventorySubmitting();
}

/// Stan poprawnego zamkniecia inwentaryzacji.
final class CloseInventorySuccess extends CloseInventoryState {
  /// Tworzy stan sukcesu zamkniecia.
  const CloseInventorySuccess();
}

/// Stan blokady zamkniecia ze wzgledu na status.
final class CloseInventoryBlocked extends CloseInventoryState {
  /// Tworzy stan blokady statusowej.
  const CloseInventoryBlocked();
}

/// Stan bledu backendowego zamykania inwentaryzacji.
final class CloseInventoryError extends CloseInventoryState {
  /// Tworzy stan bledu backendowego.
  const CloseInventoryError({required this.message});

  /// Komunikat bledu zwrocony do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}
