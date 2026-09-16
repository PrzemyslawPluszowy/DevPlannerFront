import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan formularza edycji stanowiska BHP.
sealed class EditBhpPositionState extends Equatable {
  /// Tworzy bazowy stan formularza edycji stanowiska.
  const EditBhpPositionState();

  @override
  List<Object?> get props => const [];
}

/// Stan gotowości formularza edycji stanowiska.
final class EditBhpPositionReady extends EditBhpPositionState {
  /// Tworzy stan gotowości formularza.
  const EditBhpPositionReady({
    required this.item,
    this.submitError,
  });

  /// Edytowane stanowisko.
  final GetBhpPositionListItem item;

  /// Komunikat błędu zapisu formularza.
  final String? submitError;

  @override
  List<Object?> get props => [item, submitError];
}

/// Stan zapisu formularza edycji stanowiska.
final class EditBhpPositionSubmitting extends EditBhpPositionState {
  /// Tworzy stan zapisu formularza.
  const EditBhpPositionSubmitting({required this.item});

  /// Edytowane stanowisko utrzymywane podczas wysyłki.
  final GetBhpPositionListItem item;

  @override
  List<Object?> get props => [item];
}

/// Stan poprawnego zapisu stanowiska.
final class EditBhpPositionSuccess extends EditBhpPositionState {
  /// Tworzy stan poprawnego zapisu stanowiska.
  const EditBhpPositionSuccess({required this.item});

  /// Zapisane stanowisko.
  final GetBhpPositionListItem item;

  @override
  List<Object?> get props => [item];
}
