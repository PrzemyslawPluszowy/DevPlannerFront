import 'package:equatable/equatable.dart';

/// Bazowy stan dodawania elementu arkusza.
sealed class AddArkuszElementState extends Equatable {
  /// Tworzy bazowy stan dodawania elementu.
  const AddArkuszElementState();

  @override
  List<Object?> get props => const [];
}

/// Stan gotowosci formularza dodawania elementu arkusza.
final class AddArkuszElementReady extends AddArkuszElementState {
  /// Tworzy stan gotowosci formularza.
  const AddArkuszElementReady({this.submitError});

  /// Komunikat bledu wysylki formularza.
  final String? submitError;

  @override
  List<Object?> get props => [submitError];
}

/// Stan wysylania formularza dodawania elementu arkusza.
final class AddArkuszElementSending extends AddArkuszElementState {
  /// Tworzy stan wysylania formularza.
  const AddArkuszElementSending();
}

/// Stan poprawnego zapisania elementu arkusza.
final class AddArkuszElementSaved extends AddArkuszElementState {
  /// Tworzy stan poprawnego zapisania elementu.
  const AddArkuszElementSaved({required this.itemId});

  /// Id nowo utworzonego elementu arkusza.
  final int itemId;

  @override
  List<Object?> get props => [itemId];
}
