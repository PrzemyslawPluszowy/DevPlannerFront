import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_element_nrewid_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/post_arkusz_elementy_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/add_arkusz_element_state.dart';

/// Cubit obslugujacy dodawanie elementu arkusza.
class AddArkuszElementCubit extends Cubit<AddArkuszElementState> {
  /// Tworzy cubit dodawania elementu arkusza.
  AddArkuszElementCubit({required this._repository})
    : super(const AddArkuszElementReady());

  final InventoriesRepository _repository;

  /// Dodaje nadwyzke recznie do wskazanego arkusza.
  Future<void> addManual({
    required int arkuszId,
    required PostArkuszElementyQuery query,
  }) async {
    if (state is AddArkuszElementSending) {
      return;
    }

    emit(const AddArkuszElementSending());

    final result = await _repository.addArkuszNadwyzka(
      arkuszId: arkuszId,
      query: query,
    );

    result.fold(
      (error) => emit(AddArkuszElementReady(submitError: error.message)),
      (data) => emit(AddArkuszElementSaved(itemId: data.id)),
    );
  }

  /// Dodaje element do arkusza po numerze ewidencyjnym.
  Future<void> addByNrewid({
    required int arkuszId,
    required CreateArkuszElementByNrewidRequest query,
  }) async {
    if (state is AddArkuszElementSending) {
      return;
    }

    emit(const AddArkuszElementSending());

    final result = await _repository.createArkuszElementByNrewid(
      arkuszId: arkuszId,
      query: query,
    );

    result.fold(
      (error) => emit(AddArkuszElementReady(submitError: error.message)),
      (data) => emit(AddArkuszElementSaved(itemId: data.id)),
    );
  }
}
