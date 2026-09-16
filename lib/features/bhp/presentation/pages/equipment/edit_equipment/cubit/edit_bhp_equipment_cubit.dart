import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/edit_equipment/cubit/edit_bhp_equipment_state.dart';

/// Cubit formularza edycji karty wyposażenia BHP.
class EditBhpEquipmentCubit extends Cubit<EditBhpEquipmentState> {
  /// Tworzy cubit formularza edycji wyposażenia.
  EditBhpEquipmentCubit({
    required this._item,
    required this._repository,
  }) : super(const EditBhpEquipmentLoading());

  final GetBhpEquipmentListItem _item;
  final BhpEquipmentRepository _repository;

  GetBhpEquipmentDetails? _detail;

  /// Ładuje dane potrzebne do formularza.
  Future<void> load() async {
    emit(const EditBhpEquipmentLoading());

    final result = await _repository.getEquipmentDetails(_item.id);
    result.fold(
      (error) => emit(EditBhpEquipmentLoadError(message: error.message)),
      (detail) {
        _detail = detail;
        emit(EditBhpEquipmentReady(detail: detail));
      },
    );
  }

  /// Wysyła formularz edycji wyposażenia do backendu.
  Future<void> submit(PostBhpEquipmentRequest request) async {
    final detail = _detail;
    if (state is EditBhpEquipmentSubmitting || detail == null) {
      return;
    }

    emit(EditBhpEquipmentSubmitting(detail: detail));

    final result = await _repository.updateEquipment(_item.id, request);
    result.fold(
      (error) => emit(
        EditBhpEquipmentReady(
          detail: detail,
          submitError: error.message,
        ),
      ),
      (item) => emit(EditBhpEquipmentSuccess(item: item)),
    );
  }
}
