import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/archive_position/cubit/archive_bhp_position_state.dart';

/// Cubit obsługujący archiwizację stanowiska BHP.
class ArchiveBhpPositionCubit extends Cubit<ArchiveBhpPositionState> {
  /// Tworzy cubit modalu archiwizacji stanowiska.
  ArchiveBhpPositionCubit({required this._repository})
    : super(const ArchiveBhpPositionInitial());

  final BhpPositionsRepository _repository;

  /// Archiwizuje wskazane stanowisko.
  Future<void> submit({required int positionId}) async {
    emit(const ArchiveBhpPositionSubmitting());

    final result = await _repository.archivePosition(positionId);
    result.fold(
      (error) => emit(ArchiveBhpPositionError(message: error.message)),
      (_) => emit(const ArchiveBhpPositionSuccess()),
    );
  }
}
