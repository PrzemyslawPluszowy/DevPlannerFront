import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/add_equipment/cubit/add_bhp_equipment_state.dart';

/// Cubit formularza dodawania karty wyposażenia BHP.
class AddBhpEquipmentCubit extends Cubit<AddBhpEquipmentState> {
  /// Tworzy cubit formularza dodawania wyposażenia.
  AddBhpEquipmentCubit({required this._repository})
    : super(const AddBhpEquipmentReady());

  final BhpEquipmentRepository _repository;

  /// Wysyła formularz nowej karty wyposażenia do backendu.
  Future<void> submit(PostBhpEquipmentRequest request) async {
    if (state is AddBhpEquipmentSubmitting) {
      return;
    }

    emit(const AddBhpEquipmentSubmitting());

    final result = await _repository.createEquipment(request);
    result.fold(
      (error) => emit(AddBhpEquipmentReady(submitError: error.message)),
      (item) => emit(AddBhpEquipmentSuccess(item: item)),
    );
  }
}
