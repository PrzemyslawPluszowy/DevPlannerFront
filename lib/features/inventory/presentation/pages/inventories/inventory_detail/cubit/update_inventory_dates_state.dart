import 'package:equatable/equatable.dart';

/// Stan modalu edycji dat inwentaryzacji.
sealed class UpdateInventoryDatesState extends Equatable {
  const UpdateInventoryDatesState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy edycji dat inwentaryzacji.
final class UpdateInventoryDatesInitial extends UpdateInventoryDatesState {
  const UpdateInventoryDatesInitial();
}

/// Stan zapisywania dat inwentaryzacji.
final class UpdateInventoryDatesSubmitting extends UpdateInventoryDatesState {
  const UpdateInventoryDatesSubmitting();
}

/// Stan poprawnego zapisania dat inwentaryzacji.
final class UpdateInventoryDatesSuccess extends UpdateInventoryDatesState {
  const UpdateInventoryDatesSuccess();
}

/// Stan błędu zapisu dat inwentaryzacji.
final class UpdateInventoryDatesError extends UpdateInventoryDatesState {
  const UpdateInventoryDatesError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
