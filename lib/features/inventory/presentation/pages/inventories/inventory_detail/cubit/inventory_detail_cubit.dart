import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/inventory_detail_state.dart';

/// Cubit obslugujacy widok szczegolow inwentaryzacji.
class InventoryDetailCubit extends Cubit<InventoryDetailState> {
  /// Tworzy cubit szczegolow inwentaryzacji.
  InventoryDetailCubit({required this._repository})
    : super(const InventoryDetailLoading());

  final InventoriesRepository _repository;

  /// Laduje szczegoly inwentaryzacji po identyfikatorze.
  Future<void> load(int inventoryId) async {
    emit(const InventoryDetailLoading());
    final result = await _repository.fetchInventoryDetails(inventoryId);
    result.fold(
      (error) => emit(InventoryDetailError(message: error.message)),
      (data) => emit(InventoryDetailLoaded(data: data)),
    );
  }
}
