import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/archive_equipment/cubit/archive_bhp_equipment_state.dart';

/// Cubit obsługujący archiwizację karty wyposażenia BHP.
class ArchiveBhpEquipmentCubit extends Cubit<ArchiveBhpEquipmentState> {
  /// Tworzy cubit modalu archiwizacji wyposażenia.
  ArchiveBhpEquipmentCubit({required this._repository})
    : super(const ArchiveBhpEquipmentInitial());

  final BhpEquipmentRepository _repository;

  /// Archiwizuje wskazaną kartę wyposażenia.
  Future<void> submit({required int equipmentId}) async {
    emit(const ArchiveBhpEquipmentSubmitting());

    final result = await _repository.archiveEquipment(equipmentId);
    result.fold(
      (error) => emit(ArchiveBhpEquipmentError(message: error.message)),
      (_) => emit(const ArchiveBhpEquipmentSuccess()),
    );
  }
}
