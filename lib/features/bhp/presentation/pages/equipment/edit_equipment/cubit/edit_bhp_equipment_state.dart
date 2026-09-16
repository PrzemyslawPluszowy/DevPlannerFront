import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan formularza edycji karty wyposażenia BHP.
sealed class EditBhpEquipmentState extends Equatable {
  /// Tworzy bazowy stan formularza edycji wyposażenia.
  const EditBhpEquipmentState();

  @override
  List<Object?> get props => const [];
}

/// Stan ładowania danych formularza edycji wyposażenia.
final class EditBhpEquipmentLoading extends EditBhpEquipmentState {
  /// Tworzy stan ładowania formularza.
  const EditBhpEquipmentLoading();
}

/// Stan błędu inicjalizacji formularza edycji wyposażenia.
final class EditBhpEquipmentLoadError extends EditBhpEquipmentState {
  /// Tworzy stan błędu inicjalizacji.
  const EditBhpEquipmentLoadError({required this.message});

  /// Komunikat błędu inicjalizacji.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Stan gotowości formularza edycji wyposażenia.
final class EditBhpEquipmentReady extends EditBhpEquipmentState {
  /// Tworzy stan gotowości formularza.
  const EditBhpEquipmentReady({
    required this.detail,
    this.submitError,
  });

  /// Załadowane szczegóły karty wyposażenia.
  final GetBhpEquipmentDetails detail;

  /// Komunikat błędu zapisu formularza.
  final String? submitError;

  @override
  List<Object?> get props => [detail, submitError];
}

/// Stan zapisu formularza edycji wyposażenia.
final class EditBhpEquipmentSubmitting extends EditBhpEquipmentState {
  /// Tworzy stan zapisu formularza.
  const EditBhpEquipmentSubmitting({required this.detail});

  /// Szczegóły karty utrzymywane podczas wysyłki.
  final GetBhpEquipmentDetails detail;

  @override
  List<Object?> get props => [detail];
}

/// Stan poprawnego zapisu karty wyposażenia.
final class EditBhpEquipmentSuccess extends EditBhpEquipmentState {
  /// Tworzy stan poprawnego zapisu karty.
  const EditBhpEquipmentSuccess({required this.item});

  /// Zapisana karta wyposażenia.
  final GetBhpEquipmentDetails item;

  @override
  List<Object?> get props => [item];
}
