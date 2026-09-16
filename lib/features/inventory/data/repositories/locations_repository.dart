import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/api/inventory_api.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_miejsca_models.dart';

/// Kontrakt repozytorium miejsc (lokalizacji).
abstract interface class LocationsRepository {
  /// Pobiera listę miejsc dla firmy.
  Future<Either<ApiError, GetMiejscaResponseData>> fetchLocations({
    int? firma,
    bool forceRefresh = false,
  });

  /// Czyści cache list miejsc.
  void invalidateLocationsCache({int? firma});
}

/// Implementacja repozytorium miejsc oparta o Retrofit.
class LocationsRepositoryImpl extends ApiRepository
    implements LocationsRepository {
  /// Tworzy repozytorium z klientem API inwentaryzacji.
  LocationsRepositoryImpl({required this._api});

  final InventoryApi _api;
  final Map<int?, GetMiejscaResponseData> _locationsCache = {};

  @override
  Future<Either<ApiError, GetMiejscaResponseData>> fetchLocations({
    int? firma,
    bool forceRefresh = false,
  }) async {
    final cached = _locationsCache[firma];
    if (!forceRefresh && cached != null) {
      return Right(cached);
    }

    return guardApiCall(
      () async {
        final response = await _api.getMiejsca(firma: firma);
        final data = GetMiejscaResponseData(
          items: List<GetMiejscaItem>.unmodifiable(response.data.items),
          meta: response.data.meta,
        );
        _locationsCache[firma] = data;
        return data;
      },
      fallbackMessage: 'Nie udało się pobrać listy miejsc.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane miejsc.',
    );
  }

  @override
  void invalidateLocationsCache({int? firma}) {
    if (firma == null) {
      _locationsCache.clear();
      return;
    }
    _locationsCache.remove(firma);
  }
}
