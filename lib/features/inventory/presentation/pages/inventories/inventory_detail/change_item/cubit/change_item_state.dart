import 'package:equatable/equatable.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_arkusz_element_models.dart';

/// Bazowy stan edycji pojedynczego elementu arkusza.
sealed class ChangeItemState extends Equatable {
  /// Tworzy bazowy stan edycji elementu.
  const ChangeItemState();

  @override
  List<Object?> get props => const [];
}

/// Stan gotowosci formularza edycji elementu.
final class ChangeItemReady extends ChangeItemState {
  /// Tworzy stan gotowosci formularza.
  const ChangeItemReady({this.submitError});

  /// Komunikat bledu walidacji lub zapisu.
  final String? submitError;

  @override
  List<Object?> get props => [submitError];
}

/// Stan trwajacej wysylki zmian elementu.
final class ChangeItemSending extends ChangeItemState {
  /// Tworzy stan wysylki zmian.
  const ChangeItemSending();
}

/// Stan poprawnego zapisania zmian elementu.
final class ChangeItemSaved extends ChangeItemState {
  /// Tworzy stan zapisu zmian.
  const ChangeItemSaved({required this.response});

  /// Odpowiedz backendu po aktualizacji elementu.
  final PatchArkuszElementResponseData response;

  @override
  List<Object?> get props => [response];
}
