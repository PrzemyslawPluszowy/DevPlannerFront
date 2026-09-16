import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_standards/cubit/bhp_position_standards_state.dart';

/// Cubit managera standardu stanowiska BHP.
class BhpPositionStandardsCubit extends Cubit<BhpPositionStandardsState> {
  /// Tworzy cubit managera standardu stanowiska.
  BhpPositionStandardsCubit({
    required this._position,
    required this._positionsRepository,
    required this._equipmentRepository,
  }) : super(const BhpPositionStandardsLoading());

  final GetBhpPositionListItem _position;
  final BhpPositionsRepository _positionsRepository;
  final BhpEquipmentRepository _equipmentRepository;

  /// Ładuje standard stanowiska oraz katalog aktywnego wyposażenia.
  Future<void> load() async {
    emit(const BhpPositionStandardsLoading());

    final standardsResult = await _positionsRepository.getPositionStandards(
      _position.id,
    );
    final equipmentResult = await _equipmentRepository.getEquipment(
      active: true,
    );

    final nextState = standardsResult.fold<BhpPositionStandardsState>(
      (error) => BhpPositionStandardsError(message: error.message),
      (standards) => equipmentResult.fold<BhpPositionStandardsState>(
        (error) => BhpPositionStandardsError(message: error.message),
        (equipment) => BhpPositionStandardsReady(
          position: _position,
          standards: _sortStandards(standards),
          equipment: equipment,
        ),
      ),
    );
    emit(nextState);
  }

  /// Zmienia filtr listy standardu bez ponownego ładowania danych.
  void setFilter(BhpPositionStandardsFilter filter) {
    final currentState = state;
    if (currentState is! BhpPositionStandardsReady ||
        currentState.filter == filter) {
      return;
    }

    emit(currentState.copyWith(filter: filter));
  }

  /// Dodaje nową pozycję standardu stanowiska.
  Future<Either<ApiError, GetBhpUserStandardItem>> createStandard(
    PostBhpPositionStandardRequest request,
  ) async {
    final currentState = state;
    if (currentState is! BhpPositionStandardsReady ||
        currentState.isSubmitting) {
      return const Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Widok standardu stanowiska nie jest jeszcze gotowy.',
        ),
      );
    }

    emit(
      currentState.copyWith(
        activeAction: BhpPositionStandardAction.creating,
        clearActionError: true,
      ),
    );

    final result = await _positionsRepository.createPositionStandard(
      _position.id,
      request,
    );
    result.fold(
      (error) => emit(
        currentState.copyWith(
          clearAction: true,
          actionError: error.message,
        ),
      ),
      (item) => emit(
        currentState.copyWith(
          standards: _sortStandards([...currentState.standards, item]),
          clearAction: true,
          clearActionError: true,
        ),
      ),
    );

    return result;
  }

  /// Zapisuje istniejącą pozycję standardu stanowiska.
  Future<Either<ApiError, GetBhpUserStandardItem>> updateStandard(
    int standardId,
    PatchBhpPositionStandardRequest request,
  ) async {
    final currentState = state;
    if (currentState is! BhpPositionStandardsReady ||
        currentState.isSubmitting) {
      return const Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Widok standardu stanowiska nie jest jeszcze gotowy.',
        ),
      );
    }

    emit(
      currentState.copyWith(
        activeAction: BhpPositionStandardAction.updating,
        activeStandardId: standardId,
        clearActionError: true,
      ),
    );

    final result = await _positionsRepository.updatePositionStandard(
      _position.id,
      standardId,
      request,
    );
    result.fold(
      (error) => emit(
        currentState.copyWith(
          clearAction: true,
          actionError: error.message,
        ),
      ),
      (item) => emit(
        currentState.copyWith(
          standards: _sortStandards(
            currentState.standards
                .map((standard) => standard.id == item.id ? item : standard)
                .toList(growable: false),
          ),
          clearAction: true,
          clearActionError: true,
        ),
      ),
    );

    return result;
  }

  /// Archiwizuje wskazaną pozycję standardu stanowiska.
  Future<Either<ApiError, GetBhpUserStandardItem>> archiveStandard(
    int standardId,
  ) async {
    final currentState = state;
    if (currentState is! BhpPositionStandardsReady ||
        currentState.isSubmitting) {
      return const Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Widok standardu stanowiska nie jest jeszcze gotowy.',
        ),
      );
    }

    emit(
      currentState.copyWith(
        activeAction: BhpPositionStandardAction.archiving,
        activeStandardId: standardId,
        clearActionError: true,
      ),
    );

    final result = await _positionsRepository.archivePositionStandard(
      _position.id,
      standardId,
    );
    result.fold(
      (error) => emit(
        currentState.copyWith(
          clearAction: true,
          actionError: error.message,
        ),
      ),
      (item) => emit(
        currentState.copyWith(
          standards: _sortStandards(
            currentState.standards
                .map((standard) => standard.id == item.id ? item : standard)
                .toList(growable: false),
          ),
          clearAction: true,
          clearActionError: true,
        ),
      ),
    );

    return result;
  }

  /// Przywraca wskazaną pozycję standardu stanowiska.
  Future<Either<ApiError, GetBhpUserStandardItem>> unarchiveStandard(
    int standardId,
  ) async {
    final currentState = state;
    if (currentState is! BhpPositionStandardsReady ||
        currentState.isSubmitting) {
      return const Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Widok standardu stanowiska nie jest jeszcze gotowy.',
        ),
      );
    }

    emit(
      currentState.copyWith(
        activeAction: BhpPositionStandardAction.unarchiving,
        activeStandardId: standardId,
        clearActionError: true,
      ),
    );

    final result = await _positionsRepository.unarchivePositionStandard(
      _position.id,
      standardId,
    );
    result.fold(
      (error) => emit(
        currentState.copyWith(
          clearAction: true,
          actionError: error.message,
        ),
      ),
      (item) => emit(
        currentState.copyWith(
          standards: _sortStandards(
            currentState.standards
                .map((standard) => standard.id == item.id ? item : standard)
                .toList(growable: false),
          ),
          clearAction: true,
          clearActionError: true,
        ),
      ),
    );

    return result;
  }

  /// Usuwa nieaktywną pozycję standardu stanowiska.
  Future<Either<ApiError, Unit>> deleteStandard(int standardId) async {
    final currentState = state;
    if (currentState is! BhpPositionStandardsReady ||
        currentState.isSubmitting) {
      return const Left(
        ApiError(
          type: ApiErrorType.unknown,
          message: 'Widok standardu stanowiska nie jest jeszcze gotowy.',
        ),
      );
    }

    final standard = currentState.standards
        .where((item) => item.id == standardId)
        .firstOrNull;

    if (standard?.aktywny ?? false) {
      return const Left(
        ApiError(
          type: ApiErrorType.validation,
          message:
              'Nie można usunąć aktywnej pozycji standardu. Najpierw ją zarchiwizuj.',
        ),
      );
    }

    emit(
      currentState.copyWith(
        activeAction: BhpPositionStandardAction.deleting,
        activeStandardId: standardId,
        clearActionError: true,
      ),
    );

    final result = await _positionsRepository.deletePositionStandard(
      _position.id,
      standardId,
    );
    result.fold(
      (error) => emit(
        currentState.copyWith(
          clearAction: true,
          actionError: error.message,
        ),
      ),
      (_) => emit(
        currentState.copyWith(
          standards: _sortStandards(
            currentState.standards
                .where((standard) => standard.id != standardId)
                .toList(growable: false),
          ),
          clearAction: true,
          clearActionError: true,
        ),
      ),
    );

    return result;
  }

  List<GetBhpUserStandardItem> _sortStandards(
    List<GetBhpUserStandardItem> input,
  ) {
    final items = List<GetBhpUserStandardItem>.from(input);
    items.sort((left, right) {
      final activeCompare = switch ((left.aktywny, right.aktywny)) {
        (true, false) => -1,
        (false, true) => 1,
        _ => 0,
      };
      if (activeCompare != 0) {
        return activeCompare;
      }

      final symbolCompare = (left.kartaWyposazeniaSymbol ?? '').compareTo(
        right.kartaWyposazeniaSymbol ?? '',
      );
      if (symbolCompare != 0) {
        return symbolCompare;
      }

      return left.id.compareTo(right.id);
    });
    return List<GetBhpUserStandardItem>.unmodifiable(items);
  }
}
