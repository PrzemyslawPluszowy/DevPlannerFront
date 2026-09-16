import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';
import 'package:ready_next/features/inventory/data/repositories/stock_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/stock_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/services/stock_filter_service.dart';

/// Cubit obsługujący wyłącznie pobieranie danych dla listy stanów ŚT.
class StockCubit extends Cubit<StockState> {
  StockCubit({
    required this._repository,
    required this._filterService,
  }) : super(const StockInitial()) {
    _paramsSubscription = _filterService.paramsStream.listen((params) {
      unawaited(load(params));
    });
  }

  final StockRepository _repository;
  final StockFilterService _filterService;
  StreamSubscription<StockQueryParams>? _paramsSubscription;
  int _requestSequence = 0;

  /// Pobiera dane inicjalne (np. listę firm).
  Future<void> loadInitialData() async {
    final result = await _repository.fetchCompanies();
    result.fold((_) => null, _filterService.setCompanies);
  }

  /// Pobiera listę stanów ŚT na podstawie parametrów.
  Future<void> load(StockQueryParams params) async {
    final requestId = ++_requestSequence;
    emit(const StockLoading());
    final queryText = params.q?.trim();
    final normalizedQuery = queryText == null || queryText.isEmpty
        ? null
        : queryText;
    final query = GetStanStQuery(
      firma: params.firma,
      stan: params.status?.apiValue?.toString(),
      q: normalizedQuery,
      limit: params.limit,
      offset: params.offset,
    );

    final result = await _repository.fetchStock(query);
    if (isClosed || requestId != _requestSequence) {
      return;
    }

    result.fold(
      (error) => emit(StockError(message: error.message)),
      (data) => emit(StockSuccess(data: data)),
    );
  }

  @override
  Future<void> close() {
    unawaited(_paramsSubscription?.cancel());
    return super.close();
  }
}
