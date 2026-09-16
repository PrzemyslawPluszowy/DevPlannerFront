import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/put_komisja_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/edit_commission/cubit/edit_commission_state.dart';

/// Typ zasobu, dla ktorego edytowana jest komisja.
enum EditCommissionTargetType {
  /// Komisja calej inwentaryzacji.
  inventory,

  /// Komisja arkusza spisu.
  arkusz,
}

/// Cubit obslugujacy zapis podmiany komisji.
class EditCommissionCubit extends Cubit<EditCommissionState> {
  /// Tworzy cubit edycji komisji.
  EditCommissionCubit({
    required this._repository,
    required this._targetType,
    required this._targetId,
  }) : super(const EditCommissionReady());

  final InventoriesRepository _repository;
  final EditCommissionTargetType _targetType;
  final int _targetId;

  /// Zapisuje nowy sklad komisji.
  Future<void> submit(List<int> userIds) async {
    if (state is EditCommissionSending) {
      return;
    }

    emit(const EditCommissionSending());

    final error = switch (_targetType) {
      EditCommissionTargetType.inventory =>
        (await _repository.updateInventoryCommittee(
          inventoryId: _targetId,
          query: UpdateKomisjaRequest(
            komisja: userIds,
          ),
        )).fold((error) => error, (_) => null),
      EditCommissionTargetType.arkusz =>
        (await _repository.updateArkuszCommittee(
          arkuszId: _targetId,
          query: UpdateKomisjaRequest(
            komisja: userIds,
          ),
        )).fold((error) => error, (_) => null),
    };

    if (error case final ApiError apiError) {
      emit(EditCommissionReady(submitError: apiError.message));
      return;
    }

    emit(const EditCommissionSaved());
  }
}
