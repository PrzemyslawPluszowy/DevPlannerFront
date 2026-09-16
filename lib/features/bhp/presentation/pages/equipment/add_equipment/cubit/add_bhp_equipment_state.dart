import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan formularza dodawania karty wyposażenia BHP.
sealed class AddBhpEquipmentState extends Equatable {
  /// Tworzy bazowy stan formularza dodawania wyposażenia.
  const AddBhpEquipmentState();

  @override
  List<Object?> get props => const [];
}

/// Stan gotowości formularza dodawania wyposażenia.
final class AddBhpEquipmentReady extends AddBhpEquipmentState {
  /// Tworzy stan gotowości formularza.
  const AddBhpEquipmentReady({this.submitError});

  /// Komunikat błędu zapisu formularza.
  final String? submitError;

  @override
  List<Object?> get props => [submitError];
}

/// Stan zapisu formularza dodawania wyposażenia.
final class AddBhpEquipmentSubmitting extends AddBhpEquipmentState {
  /// Tworzy stan zapisu formularza.
  const AddBhpEquipmentSubmitting();
}

/// Stan poprawnego utworzenia karty wyposażenia.
final class AddBhpEquipmentSuccess extends AddBhpEquipmentState {
  /// Tworzy stan poprawnego utworzenia karty.
  const AddBhpEquipmentSuccess({required this.item});

  /// Utworzona karta wyposażenia.
  final GetBhpEquipmentDetails item;

  @override
  List<Object?> get props => [item];
}
