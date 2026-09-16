import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/cubit/bhp_positions_state.dart';

/// Cubit sekcji stanowisk BHP.
class BhpPositionsCubit extends Cubit<BhpPositionsState> {
  /// Tworzy cubit sekcji stanowisk BHP.
  BhpPositionsCubit({required this._repository})
    : super(const BhpPositionsInitial());

  final BhpPositionsRepository _repository;
  BhpPositionsFilter _filter = BhpPositionsFilter.aktywne;

  /// Aktualnie wybrany filtr listy.
  BhpPositionsFilter get filter => _filter;

  /// Ładuje listę stanowisk BHP.
  Future<void> load([BhpPositionsFilter? nextFilter]) async {
    _filter = nextFilter ?? _filter;
    emit(const BhpPositionsLoading());

    final result = await _repository.getPositions(
      active: switch (_filter) {
        BhpPositionsFilter.wszystkie => null,
        BhpPositionsFilter.aktywne => true,
        BhpPositionsFilter.nieaktywne => false,
      },
    );
    result.fold(
      (error) => emit(BhpPositionsError(message: error.message)),
      (items) => emit(BhpPositionsSuccess(items: items, filter: _filter)),
    );
  }

  /// Przywraca zarchiwizowane stanowisko BHP.
  Future<Either<ApiError, GetBhpPositionListItem>> unarchivePosition(
    int positionId,
  ) async {
    final currentFilter = switch (state) {
      BhpPositionsSuccess(:final filter) => filter,
      _ => _filter,
    };
    final result = await _repository.unarchivePosition(positionId);
    await result.fold(
      (_) async {},
      (_) => load(currentFilter),
    );

    return result;
  }

  /// Duplikuje stanowisko BHP z nową nazwą.
  Future<Either<ApiError, GetBhpPositionListItem>> duplicatePosition(
    int positionId,
    String newNazwa,
  ) async {
    final currentFilter = switch (state) {
      BhpPositionsSuccess(:final filter) => filter,
      _ => _filter,
    };
    final result = await _repository.duplicatePosition(positionId, newNazwa);
    await result.fold(
      (_) async {},
      (_) => load(currentFilter),
    );

    return result;
  }

  /// Usuwa stanowisko BHP z bazy danych.
  Future<Either<ApiError, Unit>> deletePosition(int positionId) async {
    final currentFilter = switch (state) {
      BhpPositionsSuccess(:final filter) => filter,
      _ => _filter,
    };
    final result = await _repository.deletePosition(positionId);
    await result.fold(
      (_) async {},
      (_) => load(currentFilter),
    );

    return result;
  }
}
