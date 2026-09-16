import 'package:equatable/equatable.dart';

/// Stan modalu usuwania pojedynczego elementu arkusza.
sealed class DeleteArkuszElementState extends Equatable {
  /// Tworzy bazowy stan usuwania elementu.
  const DeleteArkuszElementState();

  @override
  List<Object?> get props => [];
}

/// Stan poczatkowy modalu usuwania elementu.
final class DeleteArkuszElementInitial extends DeleteArkuszElementState {
  /// Tworzy stan poczatkowy.
  const DeleteArkuszElementInitial();
}

/// Stan wykonywania usuniecia elementu.
final class DeleteArkuszElementSubmitting extends DeleteArkuszElementState {
  /// Tworzy stan wykonywania usuniecia.
  const DeleteArkuszElementSubmitting();
}

/// Stan poprawnego usuniecia elementu.
final class DeleteArkuszElementSuccess extends DeleteArkuszElementState {
  /// Tworzy stan sukcesu.
  const DeleteArkuszElementSuccess();
}

/// Stan bledu usuwania elementu.
final class DeleteArkuszElementError extends DeleteArkuszElementState {
  /// Tworzy stan bledu backendowego.
  const DeleteArkuszElementError({required this.message});

  /// Komunikat bledu zwrocony do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}
