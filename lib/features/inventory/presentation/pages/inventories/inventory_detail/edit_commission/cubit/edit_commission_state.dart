import 'package:equatable/equatable.dart';

/// Bazowy stan edycji komisji.
sealed class EditCommissionState extends Equatable {
  /// Tworzy bazowy stan edycji komisji.
  const EditCommissionState();

  @override
  List<Object?> get props => const [];
}

/// Stan gotowosci formularza edycji komisji.
final class EditCommissionReady extends EditCommissionState {
  /// Tworzy stan gotowosci formularza edycji komisji.
  const EditCommissionReady({this.submitError});

  /// Komunikat bledu wysylki formularza.
  final String? submitError;

  @override
  List<Object?> get props => [submitError];
}

/// Stan wysylania edycji komisji.
final class EditCommissionSending extends EditCommissionState {
  /// Tworzy stan wysylania edycji komisji.
  const EditCommissionSending();
}

/// Stan poprawnego zapisania edycji komisji.
final class EditCommissionSaved extends EditCommissionState {
  /// Tworzy stan poprawnego zapisania edycji komisji.
  const EditCommissionSaved();
}
