import 'package:ready_next/features/inventory/data/models/endpoints/get_arkusz_details_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

/// Cubit podgladu szczegolow pojedynczego arkusza.
class ArkuszPreviewCubit extends LoadableCubit<GetArkuszDetailsResponseData> {
  /// Tworzy cubit podgladu arkusza.
  ArkuszPreviewCubit({required this._repository});

  final InventoriesRepository _repository;

  /// Laduje szczegoly arkusza po jego identyfikatorze.
  Future<void> load(int arkuszId) async {
    emitLoading();
    final result = await _repository.fetchArkuszDetails(arkuszId);
    result.fold((error) => emitError(error.message), emitSuccess);
  }
}
