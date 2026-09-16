import 'package:equatable/equatable.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_search_arkusze_models.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

/// Stan wyszukiwarki elementów pomiędzy arkuszami inwentaryzacji.
final class InventorySheetSearchState extends Equatable {
  /// Tworzy stan wyszukiwarki arkuszy.
  const InventorySheetSearchState({
    this.query = '',
    this.sortBy = GetInwentaryzacjaSearchArkuszeSortBy.nrewid,
    this.sortDir = GetInwentaryzacjaSearchArkuszeSortDirection.asc,
    this.result = const LoadableInitial(),
  });

  /// Bieżąca fraza wyszukiwania.
  final String query;

  /// Wybrane pole sortowania.
  final GetInwentaryzacjaSearchArkuszeSortBy sortBy;

  /// Wybrany kierunek sortowania.
  final GetInwentaryzacjaSearchArkuszeSortDirection sortDir;

  /// Wynik wyszukiwania.
  final LoadableState<GetInwentaryzacjaSearchArkuszeResponseData> result;

  /// Czy można odpalić request do backendu.
  bool get canSearch => query.trim().length >= 2;

  /// Tworzy kopię stanu z nadpisanymi polami.
  InventorySheetSearchState copyWith({
    String? query,
    GetInwentaryzacjaSearchArkuszeSortBy? sortBy,
    GetInwentaryzacjaSearchArkuszeSortDirection? sortDir,
    LoadableState<GetInwentaryzacjaSearchArkuszeResponseData>? result,
  }) {
    return InventorySheetSearchState(
      query: query ?? this.query,
      sortBy: sortBy ?? this.sortBy,
      sortDir: sortDir ?? this.sortDir,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [query, sortBy, sortDir, result];
}
