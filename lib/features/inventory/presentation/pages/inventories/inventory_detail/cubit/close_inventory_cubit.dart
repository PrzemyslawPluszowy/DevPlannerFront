import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacje_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/close_inventory_state.dart';

/// Cubit obslugujacy zamkniecie pojedynczej inwentaryzacji.
class CloseInventoryCubit extends Cubit<CloseInventoryState> {
  /// Tworzy cubit modalu zamykania inwentaryzacji.
  CloseInventoryCubit({required this._repository})
    : super(const CloseInventoryInitial());

  final InventoriesRepository _repository;

  /// Zamyka inwentaryzacje po przejsciu guardow statusu i daty.
  Future<void> submit({
    required int inventoryId,
    required InwentaryzacjaStatus? status,
  }) async {
    if (status != InwentaryzacjaStatus.wToku) {
      emit(const CloseInventoryBlocked());
      return;
    }

    emit(const CloseInventorySubmitting());

    final result = await _repository.closeInventory(
      inventoryId: inventoryId,
    );

    result.fold(
      (error) => emit(CloseInventoryError(message: error.message)),
      (_) => emit(const CloseInventorySuccess()),
    );
  }
}
