import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/api/bhp_api.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Kontrakt repozytorium dashboardu BHP.
abstract interface class BhpDashboardRepository {
  /// Pobiera alerty dashboardu BHP.
  Future<Either<ApiError, GetBhpDashboardResponseData>> getIssueAlerts({
    int monthsAhead = 1,
  });

  /// Pobiera globalną historię operacji BHP dla wybranego roku.
  Future<Either<ApiError, GetBhpIssueOperationsResponseData>>
  getIssueOperations(
    int year,
  );

  /// Pobiera globalne braki wyposażenia względem aktywnych standardów.
  Future<Either<ApiError, GetBhpMissingEquipmentResponseData>>
  getMissingEquipment();
}

/// Implementacja repozytorium dashboardu BHP oparta o Retrofit.
class BhpDashboardRepositoryImpl extends ApiRepository
    implements BhpDashboardRepository {
  /// Tworzy repozytorium z klientem API BHP.
  BhpDashboardRepositoryImpl({required this._api});

  final BhpApi _api;

  @override
  Future<Either<ApiError, GetBhpDashboardResponseData>> getIssueAlerts({
    int monthsAhead = 1,
  }) {
    return guardApiCall(
      () => _api.getIssueAlerts(monthsAhead: monthsAhead),
      fallbackMessage: 'Nie udało się pobrać dashboardu BHP.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane dashboardu BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpIssueOperationsResponseData>>
  getIssueOperations(
    int year,
  ) {
    return guardApiCall(
      () => _api.getIssueOperations(year: year),
      fallbackMessage: 'Nie udało się pobrać historii operacji BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane historii operacji BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpMissingEquipmentResponseData>>
  getMissingEquipment() {
    return guardApiCall(
      _api.getMissingEquipment,
      fallbackMessage: 'Nie udało się pobrać braków wyposażenia BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane braków wyposażenia BHP.',
    );
  }
}
