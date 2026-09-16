import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/patch_arkusz_element_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/change_item/cubit/change_item_state.dart';

/// Cubit obslugujacy zapis zmian pojedynczego elementu arkusza.
class ChangeItemCubit extends Cubit<ChangeItemState> {
  /// Tworzy cubit edycji elementu arkusza.
  ChangeItemCubit({
    required this._repository,
    required this._arkuszId,
    required this._elementId,
  }) : super(const ChangeItemReady());

  final InventoriesRepository _repository;
  final int _arkuszId;
  final int _elementId;

  /// Zapisuje zmiany formularza do backendu.
  Future<void> submit(PatchArkuszElementQuery query) async {
    if (state is ChangeItemSending) {
      return;
    }

    emit(const ChangeItemSending());

    final result = await _repository.updateArkuszElement(
      arkuszId: _arkuszId,
      elementId: _elementId,
      query: query,
    );

    result.fold(
      (error) => emit(ChangeItemReady(submitError: error.message)),
      (response) => emit(ChangeItemSaved(response: response)),
    );
  }
}
