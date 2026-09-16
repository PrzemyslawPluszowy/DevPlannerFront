import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_arkusz_numer_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/update_arkusz_numer_state.dart';

/// Cubit obslugujacy zapis numeru pojedynczego arkusza.
class UpdateArkuszNumerCubit extends Cubit<UpdateArkuszNumerState> {
  /// Tworzy cubit modalu edycji numeru arkusza.
  UpdateArkuszNumerCubit({required this._repository})
    : super(const UpdateArkuszNumerInitial());

  final InventoriesRepository _repository;

  /// Zapisuje numer arkusza po stronie backendu.
  Future<void> submit({
    required int arkuszId,
    required String numer,
  }) async {
    if (state is UpdateArkuszNumerSubmitting) {
      return;
    }

    emit(const UpdateArkuszNumerSubmitting());

    final result = await _repository.updateArkuszNumer(
      arkuszId: arkuszId,
      query: UpdateArkuszNumerRequest(numer: numer),
    );

    result.fold(
      (error) => emit(UpdateArkuszNumerError(message: error.message)),
      (_) => emit(const UpdateArkuszNumerSuccess()),
    );
  }
}
