import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/add_position/cubit/add_bhp_position_state.dart';

/// Cubit formularza dodawania stanowiska BHP.
class AddBhpPositionCubit extends Cubit<AddBhpPositionState> {
  /// Tworzy cubit formularza dodawania stanowiska.
  AddBhpPositionCubit({required this._repository})
    : super(const AddBhpPositionReady());

  final BhpPositionsRepository _repository;

  /// Wysyła formularz nowego stanowiska do backendu.
  Future<void> submit(PostBhpPositionRequest request) async {
    if (state is AddBhpPositionSubmitting) {
      return;
    }

    emit(const AddBhpPositionSubmitting());

    final result = await _repository.createPosition(request);
    result.fold(
      (error) => emit(AddBhpPositionReady(submitError: error.message)),
      (item) => emit(AddBhpPositionSuccess(item: item)),
    );
  }
}
