import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/delete_arkusz_state.dart';

/// Cubit obslugujacy usuniecie pojedynczego arkusza.
class DeleteArkuszCubit extends Cubit<DeleteArkuszState> {
  /// Tworzy cubit modalu usuwania arkusza.
  DeleteArkuszCubit({required this._repository})
    : super(const DeleteArkuszInitial());

  final InventoriesRepository _repository;

  /// Usuwa arkusz dla wskazanego identyfikatora.
  Future<void> submit({
    required int arkuszId,
    required bool isInventoryFinished,
  }) async {
    if (isInventoryFinished) {
      emit(const DeleteArkuszBlocked());
      return;
    }

    emit(const DeleteArkuszSubmitting());

    final result = await _repository.deleteArkusz(arkuszId);
    result.fold(
      (error) => emit(DeleteArkuszError(message: error.message)),
      (_) => emit(const DeleteArkuszSuccess()),
    );
  }
}
