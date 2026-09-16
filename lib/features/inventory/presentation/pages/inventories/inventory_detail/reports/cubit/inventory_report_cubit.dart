import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_inwentaryzacja_report_models.dart';
import 'package:ready_next/features/inventory/data/repositories/inventories_repository.dart';
import 'package:ready_next/shared/presentation/cubit/loadable_cubit.dart';

/// Stan raportu inwentaryzacji.
final class InventoryReportState extends Equatable {
  /// Tworzy stan raportu.
  const InventoryReportState({
    required this.reportType,
    required this.sortBy,
    required this.sortDir,
    this.result = const LoadableInitial(),
  });

  /// Typ raportu.
  final InwentaryzacjaReportType reportType;

  /// Wybrane pole sortowania.
  final GetInwentaryzacjaReportSortBy sortBy;

  /// Wybrany kierunek sortowania.
  final GetInwentaryzacjaReportSortDirection sortDir;

  /// Wynik ładowania raportu.
  final LoadableState<GetInwentaryzacjaReportResponseData> result;

  /// Tworzy kopię stanu z nadpisanymi wartościami.
  InventoryReportState copyWith({
    InwentaryzacjaReportType? reportType,
    GetInwentaryzacjaReportSortBy? sortBy,
    GetInwentaryzacjaReportSortDirection? sortDir,
    LoadableState<GetInwentaryzacjaReportResponseData>? result,
  }) {
    return InventoryReportState(
      reportType: reportType ?? this.reportType,
      sortBy: sortBy ?? this.sortBy,
      sortDir: sortDir ?? this.sortDir,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [reportType, sortBy, sortDir, result];
}

/// Cubit widoku raportu inwentaryzacji.
class InventoryReportCubit extends Cubit<InventoryReportState> {
  /// Tworzy cubit raportu.
  InventoryReportCubit({
    required this._repository,
    required InwentaryzacjaReportType reportType,
  }) : super(
         InventoryReportState(
           reportType: reportType,
           sortBy: GetInwentaryzacjaReportSortBy.id,
           sortDir: GetInwentaryzacjaReportSortDirection.asc,
         ),
       );

  final InventoriesRepository _repository;

  /// Ładuje raport dla wskazanej inwentaryzacji.
  Future<void> load(int inventoryId) async {
    emit(
      state.copyWith(
        result: LoadableState<GetInwentaryzacjaReportResponseData>.loading(
          previousData: state.result.data,
        ),
      ),
    );

    final result = await _repository.fetchInventoryReport(
      inventoryId: inventoryId,
      query: GetInwentaryzacjaReportQuery(
        reportType: state.reportType,
        includeSummary: false,
        sortBy: state.sortBy,
        sortDir: state.sortDir,
      ),
    );

    result.fold<void>(
      (error) => emit(
        state.copyWith(
          result: LoadableState<GetInwentaryzacjaReportResponseData>.error(
            message: error.message,
            previousData: state.result.data,
          ),
        ),
      ),
      (data) => emit(
        state.copyWith(
          result: LoadableState<GetInwentaryzacjaReportResponseData>.success(
            data: data,
          ),
        ),
      ),
    );
  }

  /// Zmienia pole sortowania i przeładowuje raport.
  Future<void> updateSortBy(
    int inventoryId,
    GetInwentaryzacjaReportSortBy sortBy,
  ) async {
    emit(state.copyWith(sortBy: sortBy));
    await load(inventoryId);
  }

  /// Zmienia kierunek sortowania i przeładowuje raport.
  Future<void> updateSortDir(
    int inventoryId,
    GetInwentaryzacjaReportSortDirection sortDir,
  ) async {
    emit(state.copyWith(sortDir: sortDir));
    await load(inventoryId);
  }
}
