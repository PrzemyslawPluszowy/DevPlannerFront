import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_details_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

/// Cubit podgladu szczegolow pojedynczej inwentaryzacji.
class InventoryPreviewCubit
    extends LoadableCubit<GetInwentaryzacjaDetailsResponseData> {
  /// Tworzy cubit podgladu inwentaryzacji.
  InventoryPreviewCubit({required this._repository});

  final InventoriesRepository _repository;

  /// Laduje szczegoly inwentaryzacji po jej identyfikatorze.
  Future<void> load(int inventoryId) async {
    emitLoading();
    final result = await _repository.fetchInventoryDetails(inventoryId);
    result.fold((error) => emitError(error.message), emitSuccess);
  }
}
