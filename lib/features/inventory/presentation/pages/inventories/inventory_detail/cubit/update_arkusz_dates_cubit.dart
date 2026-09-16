import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_arkusz_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_arkusz_dates_state.dart';

/// Cubit obslugujacy zapis dat pojedynczego arkusza.
class UpdateArkuszDatesCubit extends Cubit<UpdateArkuszDatesState> {
  /// Tworzy cubit modalu edycji dat arkusza.
  UpdateArkuszDatesCubit({required this._repository})
    : super(const UpdateArkuszDatesInitial());

  final InventoriesRepository _repository;

  /// Zapisuje daty arkusza po stronie backendu.
  Future<void> submit({
    required int arkuszId,
    required UpdateArkuszRequest query,
  }) async {
    if (state is UpdateArkuszDatesSubmitting) {
      return;
    }

    emit(const UpdateArkuszDatesSubmitting());

    final result = await _repository.updateArkusz(
      arkuszId: arkuszId,
      query: query,
    );

    result.fold(
      (error) => emit(UpdateArkuszDatesError(message: error.message)),
      (_) => emit(const UpdateArkuszDatesSuccess()),
    );
  }
}
