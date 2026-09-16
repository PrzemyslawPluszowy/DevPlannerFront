import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan sekcji wyposażenia BHP.
sealed class BhpEquipmentState extends Equatable {
  /// Tworzy bazowy stan sekcji wyposażenia BHP.
  const BhpEquipmentState();

  @override
  List<Object?> get props => const [];
}

/// Filtry listy wyposażenia BHP.
enum BhpEquipmentFilter {
  /// Pokazuje wszystkie karty wyposażenia.
  wszystkie,

  /// Pokazuje tylko aktywne karty wyposażenia.
  aktywne,

  /// Pokazuje tylko nieaktywne karty wyposażenia.
  nieaktywne,
}

/// Stan początkowy sekcji wyposażenia BHP.
final class BhpEquipmentInitial extends BhpEquipmentState {
  /// Tworzy stan początkowy sekcji wyposażenia BHP.
  const BhpEquipmentInitial();
}

/// Stan ładowania sekcji wyposażenia BHP.
final class BhpEquipmentLoading extends BhpEquipmentState {
  /// Tworzy stan ładowania sekcji wyposażenia BHP.
  const BhpEquipmentLoading();
}

/// Stan sukcesu sekcji wyposażenia BHP.
final class BhpEquipmentSuccess extends BhpEquipmentState {
  /// Tworzy stan sukcesu sekcji wyposażenia BHP.
  const BhpEquipmentSuccess({
    required this.items,
    required this.filter,
  });

  /// Lista wyposażenia BHP.
  final List<GetBhpEquipmentListItem> items;

  /// Aktualnie aktywny filtr listy.
  final BhpEquipmentFilter filter;

  @override
  List<Object?> get props => [items, filter];
}

/// Stan błędu sekcji wyposażenia BHP.
final class BhpEquipmentError extends BhpEquipmentState {
  /// Tworzy stan błędu sekcji wyposażenia BHP.
  const BhpEquipmentError({required this.message});

  /// Komunikat błędu do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}
