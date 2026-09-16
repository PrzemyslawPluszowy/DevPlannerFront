import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_inwentaryzacja_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_inventory_dates_state.dart';

/// Cubit obslugujacy zapis dat naglowka inwentaryzacji.
class UpdateInventoryDatesCubit extends Cubit<UpdateInventoryDatesState> {
  UpdateInventoryDatesCubit({required this._repository})
    : super(const UpdateInventoryDatesInitial());

  final InventoriesRepository _repository;

  Future<void> submit({
    required int inventoryId,
    required PatchInwentaryzacjaRequest query,
  }) async {
    if (state is UpdateInventoryDatesSubmitting) {
      return;
    }

    emit(const UpdateInventoryDatesSubmitting());

    final result = await _repository.updateInventory(
      inventoryId: inventoryId,
      query: query,
    );

    result.fold(
      (error) => emit(UpdateInventoryDatesError(message: error.message)),
      (_) => emit(const UpdateInventoryDatesSuccess()),
    );
  }
}
