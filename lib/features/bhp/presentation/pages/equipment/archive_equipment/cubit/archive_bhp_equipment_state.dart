import 'package:equatable/equatable.dart';

/// Bazowy stan archiwizacji karty wyposażenia BHP.
sealed class ArchiveBhpEquipmentState extends Equatable {
  /// Tworzy bazowy stan archiwizacji wyposażenia.
  const ArchiveBhpEquipmentState();

  @override
  List<Object?> get props => const [];
}

/// Stan początkowy modalu archiwizacji wyposażenia.
final class ArchiveBhpEquipmentInitial extends ArchiveBhpEquipmentState {
  /// Tworzy stan początkowy modalu archiwizacji.
  const ArchiveBhpEquipmentInitial();
}

/// Stan wykonywania archiwizacji wyposażenia.
final class ArchiveBhpEquipmentSubmitting extends ArchiveBhpEquipmentState {
  /// Tworzy stan wykonywania archiwizacji.
  const ArchiveBhpEquipmentSubmitting();
}

/// Stan poprawnej archiwizacji wyposażenia.
final class ArchiveBhpEquipmentSuccess extends ArchiveBhpEquipmentState {
  /// Tworzy stan poprawnej archiwizacji wyposażenia.
  const ArchiveBhpEquipmentSuccess();
}

/// Stan błędu archiwizacji wyposażenia.
final class ArchiveBhpEquipmentError extends ArchiveBhpEquipmentState {
  /// Tworzy stan błędu archiwizacji wyposażenia.
  const ArchiveBhpEquipmentError({required this.message});

  /// Komunikat błędu zwrócony do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}
