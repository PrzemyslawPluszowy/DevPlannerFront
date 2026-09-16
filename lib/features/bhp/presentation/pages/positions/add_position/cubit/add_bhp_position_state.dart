import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan formularza dodawania stanowiska BHP.
sealed class AddBhpPositionState extends Equatable {
  /// Tworzy bazowy stan formularza dodawania stanowiska.
  const AddBhpPositionState();

  @override
  List<Object?> get props => const [];
}

/// Stan gotowości formularza dodawania stanowiska.
final class AddBhpPositionReady extends AddBhpPositionState {
  /// Tworzy stan gotowości formularza.
  const AddBhpPositionReady({this.submitError});

  /// Komunikat błędu zapisu formularza.
  final String? submitError;

  @override
  List<Object?> get props => [submitError];
}

/// Stan zapisu formularza dodawania stanowiska.
final class AddBhpPositionSubmitting extends AddBhpPositionState {
  /// Tworzy stan zapisu formularza.
  const AddBhpPositionSubmitting();
}

/// Stan poprawnego utworzenia stanowiska.
final class AddBhpPositionSuccess extends AddBhpPositionState {
  /// Tworzy stan poprawnego utworzenia stanowiska.
  const AddBhpPositionSuccess({required this.item});

  /// Utworzone stanowisko.
  final GetBhpPositionListItem item;

  @override
  List<Object?> get props => [item];
}
