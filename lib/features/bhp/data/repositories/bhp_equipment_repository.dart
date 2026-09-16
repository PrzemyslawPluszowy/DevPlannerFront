import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/api/bhp_api.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Kontrakt repozytorium wyposażenia BHP.
abstract interface class BhpEquipmentRepository {
  /// Pobiera katalog wyposażenia BHP.
  Future<Either<ApiError, List<GetBhpEquipmentListItem>>> getEquipment({
    bool? active,
    String? query,
  });

  /// Pobiera szczegóły pojedynczej karty wyposażenia BHP.
  Future<Either<ApiError, GetBhpEquipmentDetails>> getEquipmentDetails(int id);

  /// Tworzy nową kartę wyposażenia BHP.
  Future<Either<ApiError, GetBhpEquipmentDetails>> createEquipment(
    PostBhpEquipmentRequest request,
  );

  /// Aktualizuje istniejącą kartę wyposażenia BHP.
  Future<Either<ApiError, GetBhpEquipmentDetails>> updateEquipment(
    int id,
    PostBhpEquipmentRequest request,
  );

  /// Archiwizuje kartę wyposażenia BHP.
  Future<Either<ApiError, GetBhpEquipmentDetails>> archiveEquipment(int id);

  /// Pobiera wpływ zmiany statusu karty wyposażenia na przypisania stanowisk.
  Future<Either<ApiError, GetBhpEquipmentActivationImpact>>
  getEquipmentActivationImpact(int id);

  /// Przywraca nieaktywną kartę wyposażenia BHP.
  Future<Either<ApiError, GetBhpEquipmentDetails>> unarchiveEquipment(
    int id, {
    List<int> selectedStandardIds,
  });
}

/// Implementacja repozytorium wyposażenia BHP oparta o Retrofit.
class BhpEquipmentRepositoryImpl extends ApiRepository
    implements BhpEquipmentRepository {
  /// Tworzy repozytorium z klientem API BHP.
  BhpEquipmentRepositoryImpl({required this._api});

  final BhpApi _api;

  @override
  Future<Either<ApiError, List<GetBhpEquipmentListItem>>> getEquipment({
    bool? active,
    String? query,
  }) {
    return guardApiCall(
      () async => List<GetBhpEquipmentListItem>.unmodifiable(
        await _api.getEquipment(active: active, query: query),
      ),
      fallbackMessage: 'Nie udało się pobrać katalogu wyposażenia BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane katalogu wyposażenia BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpEquipmentDetails>> getEquipmentDetails(int id) {
    return guardApiCall(
      () => _api.getEquipmentDetails(id),
      fallbackMessage: 'Nie udało się pobrać szczegółów wyposażenia BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane szczegółów wyposażenia BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpEquipmentDetails>> createEquipment(
    PostBhpEquipmentRequest request,
  ) {
    return guardApiCall(
      () => _api.createEquipment(request),
      fallbackMessage: 'Nie udało się dodać karty wyposażenia BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane nowej karty wyposażenia BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpEquipmentDetails>> updateEquipment(
    int id,
    PostBhpEquipmentRequest request,
  ) {
    return guardApiCall(
      () => _api.updateEquipment(id, request),
      fallbackMessage: 'Nie udało się zapisać zmian karty wyposażenia BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane zapisanej karty wyposażenia BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpEquipmentDetails>> archiveEquipment(int id) {
    return guardApiCall(
      () => _api.archiveEquipment(id),
      fallbackMessage: 'Nie udało się zarchiwizować karty wyposażenia BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane archiwizowanej karty wyposażenia BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpEquipmentActivationImpact>>
  getEquipmentActivationImpact(int id) {
    return guardApiCall(
      () => _api.getEquipmentActivationImpact(id),
      fallbackMessage:
          'Nie udało się pobrać wpływu zmiany statusu karty wyposażenia BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane wpływu zmiany statusu karty wyposażenia BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpEquipmentDetails>> unarchiveEquipment(
    int id, {
    List<int> selectedStandardIds = const [],
  }) {
    return guardApiCall(
      () => _api.unarchiveEquipment(
        id,
        PostBhpEquipmentActivationRequest(
          selectedStandardIds: List<int>.unmodifiable(selectedStandardIds),
        ),
      ),
      fallbackMessage: 'Nie udało się aktywować karty wyposażenia BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane aktywowanej karty wyposażenia BHP.',
    );
  }
}
