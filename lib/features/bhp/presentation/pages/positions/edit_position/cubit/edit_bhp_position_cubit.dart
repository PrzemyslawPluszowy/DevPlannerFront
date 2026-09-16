import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/edit_position/cubit/edit_bhp_position_state.dart';

/// Cubit formularza edycji stanowiska BHP.
class EditBhpPositionCubit extends Cubit<EditBhpPositionState> {
  /// Tworzy cubit formularza edycji stanowiska.
  EditBhpPositionCubit({
    required GetBhpPositionListItem item,
    required this._repository,
  }) : _item = item,
       super(EditBhpPositionReady(item: item));

  final GetBhpPositionListItem _item;
  final BhpPositionsRepository _repository;

  /// Wysyła formularz edycji stanowiska do backendu.
  Future<void> submit(PostBhpPositionRequest request) async {
    final currentState = state;
    if (currentState is! EditBhpPositionReady) {
      return;
    }

    emit(EditBhpPositionSubmitting(item: currentState.item));

    final result = await _repository.updatePosition(_item.id, request);
    result.fold(
      (error) => emit(
        EditBhpPositionReady(
          item: currentState.item,
          submitError: error.message,
        ),
      ),
      (item) {
        emit(EditBhpPositionSuccess(item: item));
        emit(EditBhpPositionReady(item: item));
      },
    );
  }
}
