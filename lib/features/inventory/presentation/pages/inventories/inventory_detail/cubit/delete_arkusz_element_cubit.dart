import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/delete_arkusz_element_state.dart';

/// Cubit obslugujacy usuniecie pojedynczego elementu arkusza.
class DeleteArkuszElementCubit extends Cubit<DeleteArkuszElementState> {
  /// Tworzy cubit modalu usuwania elementu.
  DeleteArkuszElementCubit({required this._repository})
    : super(const DeleteArkuszElementInitial());

  final InventoriesRepository _repository;

  /// Usuwa element dla wskazanego arkusza.
  Future<void> submit({
    required int arkuszId,
    required int elementId,
  }) async {
    if (state is DeleteArkuszElementSubmitting) {
      return;
    }

    emit(const DeleteArkuszElementSubmitting());

    final result = await _repository.deleteArkuszElement(
      arkuszId: arkuszId,
      elementId: elementId,
    );

    result.fold(
      (error) => emit(DeleteArkuszElementError(message: error.message)),
      (_) => emit(const DeleteArkuszElementSuccess()),
    );
  }
}
