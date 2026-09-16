import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan sekcji stanowisk BHP.
sealed class BhpPositionsState extends Equatable {
  /// Tworzy bazowy stan sekcji stanowisk BHP.
  const BhpPositionsState();

  @override
  List<Object?> get props => const [];
}

/// Filtry listy stanowisk BHP.
enum BhpPositionsFilter {
  /// Pokazuje wszystkie stanowiska.
  wszystkie,

  /// Pokazuje tylko aktywne stanowiska.
  aktywne,

  /// Pokazuje tylko nieaktywne stanowiska.
  nieaktywne,
}

/// Stan początkowy sekcji stanowisk BHP.
final class BhpPositionsInitial extends BhpPositionsState {
  /// Tworzy stan początkowy sekcji stanowisk BHP.
  const BhpPositionsInitial();
}

/// Stan ładowania sekcji stanowisk BHP.
final class BhpPositionsLoading extends BhpPositionsState {
  /// Tworzy stan ładowania sekcji stanowisk BHP.
  const BhpPositionsLoading();
}

/// Stan sukcesu sekcji stanowisk BHP.
final class BhpPositionsSuccess extends BhpPositionsState {
  /// Tworzy stan sukcesu sekcji stanowisk BHP.
  const BhpPositionsSuccess({
    required this.items,
    required this.filter,
  });

  /// Lista stanowisk BHP.
  final List<GetBhpPositionListItem> items;

  /// Aktualnie aktywny filtr listy.
  final BhpPositionsFilter filter;

  @override
  List<Object?> get props => [items, filter];
}

/// Stan błędu sekcji stanowisk BHP.
final class BhpPositionsError extends BhpPositionsState {
  /// Tworzy stan błędu sekcji stanowisk BHP.
  const BhpPositionsError({required this.message});

  /// Komunikat błędu do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}
