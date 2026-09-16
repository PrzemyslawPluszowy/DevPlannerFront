import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/features/inventory/data/repositories/locations_repository.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/cubit/locations_state.dart';
import 'package:ready_next/features/inventory/presentation/pages/stock/services/stock_filter_service.dart';

/// Cubit obsługujący pobieranie i filtrowanie listy miejsc, zsynchronizowany z globalnymi filtrami.
class LocationsCubit extends Cubit<LocationsState> {
  /// Tworzy cubit z repozytorium miejsc i serwisem filtrów.
  LocationsCubit({
    required this._repository,
    required this._filterService,
  }) : super(const LocationsInitial()) {
    _paramsSubscription = _filterService.paramsStream.listen((params) {
      unawaited(load(firma: params.firma));
    });
  }

  final LocationsRepository _repository;
  final StockFilterService _filterService;
  StreamSubscription<StockQueryParams>? _paramsSubscription;
  int _requestSequence = 0;

  /// Id aktualnie wybranej firmy do filtrowania (pobrane z serwisu filtrów).
  int? get firmaId => _filterService.lastParams.firma;

  /// Pobiera listę miejsc na podstawie filtrów.
  Future<void> load({int? firma, bool forceRefresh = false}) async {
    final requestId = ++_requestSequence;
    emit(const LocationsLoading());

    // Pobieramy dane z repozytorium na podstawie opcjonalnie przekazanego firmaId
    // lub aktualnego stanu serwisu filtrów.
    final result = await _repository.fetchLocations(
      firma: firma ?? _filterService.lastParams.firma,
      forceRefresh: forceRefresh,
    );
    if (isClosed || requestId != _requestSequence) {
      return;
    }

    result.fold(
      (error) => emit(LocationsError(message: error.message)),
      (data) => emit(LocationsSuccess(data: data)),
    );
  }

  /// Przeładowuje dane z aktualnymi parametrami.
  Future<void> refresh() => load(forceRefresh: true);

  @override
  Future<void> close() {
    unawaited(_paramsSubscription?.cancel());
    return super.close();
  }
}
