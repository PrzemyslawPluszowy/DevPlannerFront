import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_search_arkusze_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/inventories/inventory_detail/cubit/inventory_sheet_search_state.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

/// Cubit wyszukiwarki elementów pomiędzy arkuszami jednej inwentaryzacji.
class InventorySheetSearchCubit extends Cubit<InventorySheetSearchState> {
  /// Tworzy cubit wyszukiwarki arkuszy.
  InventorySheetSearchCubit({required this._repository})
    : super(const InventorySheetSearchState());

  final InventoriesRepository _repository;
  int _searchRequestId = 0;

  /// Aktualizuje frazę i uruchamia wyszukiwanie po spełnieniu minimum znaków.
  Future<void> updateQuery(int inventoryId, String value) async {
    final normalized = value.trim();
    ++_searchRequestId;
    emit(state.copyWith(query: normalized));

    if (normalized.length < 2) {
      emit(
        state.copyWith(
          result:
              const LoadableState<
                GetInwentaryzacjaSearchArkuszeResponseData
              >.initial(),
        ),
      );
      return;
    }

    await search(
      inventoryId,
      query: normalized,
      sortBy: state.sortBy,
      sortDir: state.sortDir,
    );
  }

  /// Zmienia pole sortowania i odświeża wyniki.
  Future<void> updateSortBy(
    int inventoryId,
    GetInwentaryzacjaSearchArkuszeSortBy value,
  ) async {
    emit(state.copyWith(sortBy: value));
    if (!state.canSearch) {
      return;
    }
    await search(
      inventoryId,
      query: state.query,
      sortBy: value,
      sortDir: state.sortDir,
    );
  }

  /// Zmienia kierunek sortowania i odświeża wyniki.
  Future<void> updateSortDir(
    int inventoryId,
    GetInwentaryzacjaSearchArkuszeSortDirection value,
  ) async {
    emit(state.copyWith(sortDir: value));
    if (!state.canSearch) {
      return;
    }
    await search(
      inventoryId,
      query: state.query,
      sortBy: state.sortBy,
      sortDir: value,
    );
  }

  /// Wysyła request wyszukiwania na podstawie bieżącego stanu.
  Future<void> search(
    int inventoryId, {
    required String query,
    required GetInwentaryzacjaSearchArkuszeSortBy sortBy,
    required GetInwentaryzacjaSearchArkuszeSortDirection sortDir,
  }) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.length < 2) {
      return;
    }

    final requestId = ++_searchRequestId;
    final previousData = state.result.data;

    emit(
      state.copyWith(
        result:
            LoadableState<GetInwentaryzacjaSearchArkuszeResponseData>.loading(
              previousData: previousData,
            ),
      ),
    );

    final result = await _repository.searchInventorySheets(
      inventoryId: inventoryId,
      query: GetInwentaryzacjaSearchArkuszeQuery(
        q: normalizedQuery,
        sortBy: sortBy,
        sortDir: sortDir,
      ),
    );

    if (requestId != _searchRequestId || isClosed) {
      return;
    }

    result.fold<void>(
      (error) => emit(
        state.copyWith(
          result:
              LoadableState<GetInwentaryzacjaSearchArkuszeResponseData>.error(
                message: error.message,
                previousData: previousData,
              ),
        ),
      ),
      (data) => emit(
        state.copyWith(
          result:
              LoadableState<GetInwentaryzacjaSearchArkuszeResponseData>.success(
                data: data,
              ),
        ),
      ),
    );
  }
}
