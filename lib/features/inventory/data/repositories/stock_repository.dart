import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/inventory/data/api/inventory_api.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/delete_firma_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/delete_stan_st_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_firmy_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_duplicates_models.dart';
import 'package:ready_next/features/inventory/data/models/endpoints/get_stan_st_models.dart';

/// Kontrakt repozytorium stanów środków trwałych.
abstract interface class StockRepository {
  /// Pobiera listę stanów środków trwałych.
  Future<Either<ApiError, GetStanStResponseData>> fetchStock(
    GetStanStQuery query,
  );

  /// Pobiera duplikaty numerow ewidencyjnych w `stan_st`.
  Future<Either<ApiError, GetStanStDuplicatesResponseData>>
  fetchStockDuplicates();

  /// Pobiera listę dostępnych firm.
  Future<Either<ApiError, List<GetFirmyItem>>> fetchCompanies({
    bool forceRefresh = false,
  });

  /// Czyści cache listy firm.
  void invalidateCompaniesCache();

  /// Usuwa firmę ze słownika inwentaryzacji.
  Future<Either<ApiError, DeleteFirmaResponseData>> deleteCompany(
    int companyId,
  );

  /// Usuwa pojedynczy rekord ze snapshotu `stan_st`.
  Future<Either<ApiError, DeleteStanStResponseData>> deleteStockItem({
    required int stockItemId,
    required String confirmNrewid,
    required String confirmNazwa,
  });
}

/// Implementacja repozytorium stanów środków trwałych oparta o Retrofit.
class StockRepositoryImpl extends ApiRepository implements StockRepository {
  /// Tworzy repozytorium z klientem API inwentaryzacji.
  StockRepositoryImpl({required this._api});

  final InventoryApi _api;
  List<GetFirmyItem>? _companiesCache;

  @override
  Future<Either<ApiError, GetStanStResponseData>> fetchStock(
    GetStanStQuery query,
  ) async {
    return guardApiCall(
      () async {
        return _fetchStockRaw(query);
      },
      fallbackMessage: 'Nie udało się pobrać listy stanów ŚT.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane stanów ŚT.',
    );
  }

  Future<GetStanStResponseData> _fetchStockRaw(GetStanStQuery query) async {
    final response = await _api.getStanSt(
      firma: query.firma,
      baza: query.baza,
      idmiejsce: query.idmiejsce,
      stan: query.stan,
      q: query.q,
      limit: query.limit,
      offset: query.offset,
      nazwa: query.nazwa,
      nrewid: query.nrewid,
      kodKreskowy: query.kodKreskowy,
    );
    return response.data;
  }

  @override
  Future<Either<ApiError, GetStanStDuplicatesResponseData>>
  fetchStockDuplicates() async {
    return guardApiCall(
      () async {
        final response = await _api.getStanStDuplicates();
        return response.data;
      },
      fallbackMessage: 'Nie udało się pobrać duplikatów numerów ewidencyjnych.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane duplikatów stan_st.',
    );
  }

  @override
  Future<Either<ApiError, List<GetFirmyItem>>> fetchCompanies({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _companiesCache != null) {
      return Right(_companiesCache!);
    }

    return guardApiCall(
      () async {
        final response = await _api.getFirmy();
        final items = List<GetFirmyItem>.unmodifiable(response.data.items);
        _companiesCache = items;
        return items;
      },
      fallbackMessage: 'Nie udało się pobrać listy firm.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane firm.',
    );
  }

  @override
  void invalidateCompaniesCache() {
    _companiesCache = null;
  }

  @override
  Future<Either<ApiError, DeleteFirmaResponseData>> deleteCompany(
    int companyId,
  ) async {
    final result = await guardApiCall(
      () async {
        final response = await _api.deleteFirma(companyId);
        return response.data;
      },
      fallbackMessage: 'Nie udało się usunąć firmy.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane usunięcia firmy.',
    );

    result.fold((_) => null, (_) => invalidateCompaniesCache());
    return result;
  }

  @override
  Future<Either<ApiError, DeleteStanStResponseData>> deleteStockItem({
    required int stockItemId,
    required String confirmNrewid,
    required String confirmNazwa,
  }) async {
    return guardApiCall(
      () async {
        final response = await _api.deleteStanSt(
          stockItemId,
          confirmNrewid: confirmNrewid,
          confirmNazwa: confirmNazwa,
        );
        return response.data;
      },
      fallbackMessage: 'Nie udało się usunąć środka trwałego ze snapshotu.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane usunięcia środka trwałego.',
    );
  }
}
