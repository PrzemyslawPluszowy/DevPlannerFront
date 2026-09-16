import 'package:equatable/equatable.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';

/// Bazowy stan widoku szczegolow inwentaryzacji.
sealed class InventoryDetailState extends Equatable {
  /// Tworzy bazowy stan szczegolow inwentaryzacji.
  const InventoryDetailState();

  @override
  List<Object?> get props => const [];
}

/// Stan ladowania szczegolow inwentaryzacji.
final class InventoryDetailLoading extends InventoryDetailState {
  /// Tworzy stan ladowania szczegolow inwentaryzacji.
  const InventoryDetailLoading();
}

/// Stan bledu podczas pobierania szczegolow inwentaryzacji.
final class InventoryDetailError extends InventoryDetailState {
  /// Tworzy stan bledu szczegolow inwentaryzacji.
  const InventoryDetailError({required this.message});

  /// Komunikat bledu zwracany do UI.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Stan zaladowanych szczegolow inwentaryzacji.
final class InventoryDetailLoaded extends InventoryDetailState {
  /// Tworzy stan zaladowanych szczegolow inwentaryzacji.
  const InventoryDetailLoaded({required this.data});

  /// Dane szczegolow inwentaryzacji.
  final GetInwentaryzacjaDetailsResponseData data;

  @override
  List<Object?> get props => [data];
}
