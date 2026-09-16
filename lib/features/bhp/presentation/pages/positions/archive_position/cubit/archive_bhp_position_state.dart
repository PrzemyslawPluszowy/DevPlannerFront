import 'package:equatable/equatable.dart';

/// Bazowy stan archiwizacji stanowiska BHP.
sealed class ArchiveBhpPositionState extends Equatable {
  /// Tworzy bazowy stan archiwizacji stanowiska.
  const ArchiveBhpPositionState();

  @override
  List<Object?> get props => const [];
}

/// Stan początkowy modalu archiwizacji stanowiska.
final class ArchiveBhpPositionInitial extends ArchiveBhpPositionState {
  /// Tworzy stan początkowy modalu archiwizacji.
  const ArchiveBhpPositionInitial();
}

/// Stan wykonywania archiwizacji stanowiska.
final class ArchiveBhpPositionSubmitting extends ArchiveBhpPositionState {
  /// Tworzy stan wykonywania archiwizacji.
  const ArchiveBhpPositionSubmitting();
}

/// Stan poprawnej archiwizacji stanowiska.
final class ArchiveBhpPositionSuccess extends ArchiveBhpPositionState {
  /// Tworzy stan poprawnej archiwizacji stanowiska.
  const ArchiveBhpPositionSuccess();
}

/// Stan błędu archiwizacji stanowiska.
final class ArchiveBhpPositionError extends ArchiveBhpPositionState {
  /// Tworzy stan błędu archiwizacji stanowiska.
  const ArchiveBhpPositionError({required this.message});

  /// Komunikat błędu zwrócony do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}
