import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/equipment_activation/cubit/bhp_equipment_activation_state.dart';

/// Cubit flow zmiany statusu karty wyposażenia.
class BhpEquipmentActivationCubit extends Cubit<BhpEquipmentActivationState> {
  /// Tworzy cubit flow zmiany statusu wyposażenia.
  BhpEquipmentActivationCubit({
    required this._repository,
    required this._equipment,
    required this._mode,
  }) : super(const BhpEquipmentActivationLoading());

  final BhpEquipmentRepository _repository;
  final GetBhpEquipmentListItem _equipment;
  final BhpEquipmentActivationMode _mode;

  /// Ładuje preview wpływu operacji na stanowiska.
  Future<void> load() async {
    emit(const BhpEquipmentActivationLoading());

    final result = await _repository.getEquipmentActivationImpact(
      _equipment.id,
    );
    if (isClosed) {
      return;
    }
    result.fold(
      (error) => emit(BhpEquipmentActivationError(message: error.message)),
      (impact) => emit(
        BhpEquipmentActivationReady(
          mode: _mode,
          impact: impact,
          selectedStandardIds: const {},
          isSubmitting: false,
        ),
      ),
    );
  }

  /// Przełącza zaznaczenie przypisania do przywrócenia.
  void toggleSelection(int standardId) {
    if (state case final BhpEquipmentActivationReady ready
        when !ready.isSubmitting &&
            ready.mode == BhpEquipmentActivationMode.setActive) {
      final selected = Set<int>.of(ready.selectedStandardIds);
      if (!selected.add(standardId)) {
        selected.remove(standardId);
      }
      emit(ready.copyWith(selectedStandardIds: selected));
    }
  }

  /// Wysyła zmianę statusu karty do backendu.
  Future<Either<ApiError, GetBhpEquipmentDetails>> submit() async {
    final currentState = state;
    if (currentState is! BhpEquipmentActivationReady ||
        currentState.isSubmitting) {
      return const Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Formularz zmiany statusu nie jest gotowy.',
        ),
      );
    }

    emit(currentState.copyWith(isSubmitting: true));

    final result = switch (currentState.mode) {
      BhpEquipmentActivationMode.setInactive => _repository.archiveEquipment(
        _equipment.id,
      ),
      BhpEquipmentActivationMode.setActive => _repository.unarchiveEquipment(
        _equipment.id,
        selectedStandardIds: currentState.selectedStandardIds.toList(
          growable: false,
        ),
      ),
    };

    final response = await result;
    if (!isClosed) {
      emit(currentState.copyWith(isSubmitting: false));
    }

    return response;
  }
}
