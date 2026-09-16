import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/api/bhp_api.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Kontrakt repozytorium stanowisk BHP.
abstract interface class BhpPositionsRepository {
  /// Pobiera listę stanowisk BHP.
  Future<Either<ApiError, List<GetBhpPositionListItem>>> getPositions({
    bool? active,
    String? query,
  });

  /// Tworzy nowe stanowisko BHP.
  Future<Either<ApiError, GetBhpPositionListItem>> createPosition(
    PostBhpPositionRequest request,
  );

  /// Aktualizuje istniejące stanowisko BHP.
  Future<Either<ApiError, GetBhpPositionListItem>> updatePosition(
    int positionId,
    PostBhpPositionRequest request,
  );

  /// Archiwizuje stanowisko BHP.
  Future<Either<ApiError, GetBhpPositionListItem>> archivePosition(
    int positionId,
  );

  /// Przywraca zarchiwizowane stanowisko BHP.
  Future<Either<ApiError, GetBhpPositionListItem>> unarchivePosition(
    int positionId,
  );

  /// Duplikuje stanowisko BHP z nową nazwą.
  Future<Either<ApiError, GetBhpPositionListItem>> duplicatePosition(
    int positionId,
    String newNazwa,
  );

  /// Usuwa stanowisko BHP z bazy danych.
  Future<Either<ApiError, Unit>> deletePosition(int positionId);

  /// Pobiera pracowników przypisanych do stanowiska.
  Future<Either<ApiError, List<GetBhpUserListItem>>> getPositionUsers(
    int positionId, {
    bool? active,
    String? query,
  });

  /// Pobiera standard wyposażenia przypisany do stanowiska.
  Future<Either<ApiError, List<GetBhpUserStandardItem>>> getPositionStandards(
    int positionId,
  );

  /// Dodaje pozycję do standardu stanowiska.
  Future<Either<ApiError, GetBhpUserStandardItem>> createPositionStandard(
    int positionId,
    PostBhpPositionStandardRequest request,
  );

  /// Aktualizuje pozycję standardu stanowiska.
  Future<Either<ApiError, GetBhpUserStandardItem>> updatePositionStandard(
    int positionId,
    int standardId,
    PatchBhpPositionStandardRequest request,
  );

  /// Archiwizuje pozycję standardu stanowiska.
  Future<Either<ApiError, GetBhpUserStandardItem>> archivePositionStandard(
    int positionId,
    int standardId,
  );

  /// Przywraca zarchiwizowaną pozycję standardu stanowiska.
  Future<Either<ApiError, GetBhpUserStandardItem>> unarchivePositionStandard(
    int positionId,
    int standardId,
  );

  /// Usuwa nieaktywną pozycję standardu stanowiska.
  Future<Either<ApiError, Unit>> deletePositionStandard(
    int positionId,
    int standardId,
  );
}

/// Implementacja repozytorium stanowisk BHP oparta o Retrofit.
class BhpPositionsRepositoryImpl extends ApiRepository
    implements BhpPositionsRepository {
  /// Tworzy repozytorium z klientem API BHP.
  BhpPositionsRepositoryImpl({required this._api});

  final BhpApi _api;

  @override
  Future<Either<ApiError, List<GetBhpPositionListItem>>> getPositions({
    bool? active,
    String? query,
  }) {
    return guardApiCall(
      () async => List<GetBhpPositionListItem>.unmodifiable(
        await _api.getPositions(active: active, query: query),
      ),
      fallbackMessage: 'Nie udało się pobrać listy stanowisk BHP.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane listy stanowisk BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpPositionListItem>> createPosition(
    PostBhpPositionRequest request,
  ) {
    return guardApiCall(
      () => _api.createPosition(request),
      fallbackMessage: 'Nie udało się utworzyć stanowiska BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane nowego stanowiska BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpPositionListItem>> updatePosition(
    int positionId,
    PostBhpPositionRequest request,
  ) {
    return guardApiCall(
      () => _api.updatePosition(positionId, request),
      fallbackMessage: 'Nie udało się zapisać stanowiska BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane zapisanego stanowiska BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpPositionListItem>> archivePosition(
    int positionId,
  ) {
    return guardApiCall(
      () => _api.archivePosition(positionId),
      fallbackMessage: 'Nie udało się zarchiwizować stanowiska BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane zarchiwizowanego stanowiska BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpPositionListItem>> unarchivePosition(
    int positionId,
  ) {
    return guardApiCall(
      () => _api.unarchivePosition(positionId),
      fallbackMessage: 'Nie udało się przywrócić stanowiska BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane przywróconego stanowiska BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpPositionListItem>> duplicatePosition(
    int positionId,
    String newNazwa,
  ) {
    return guardApiCall(
      () => _api.duplicatePosition(positionId, {'nazwa': newNazwa}),
      fallbackMessage: 'Nie udało się zduplikować stanowiska BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane zduplikowanego stanowiska BHP.',
    );
  }

  @override
  Future<Either<ApiError, Unit>> deletePosition(int positionId) {
    return guardApiCall(
      () async {
        await _api.destroyPosition(positionId);
        return unit;
      },
      fallbackMessage: 'Nie udało się usunąć stanowiska BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłową odpowiedź podczas usuwania stanowiska BHP.',
    );
  }

  @override
  Future<Either<ApiError, List<GetBhpUserListItem>>> getPositionUsers(
    int positionId, {
    bool? active,
    String? query,
  }) {
    return guardApiCall(
      () async => List<GetBhpUserListItem>.unmodifiable(
        await _api.getPositionUsers(
          positionId,
          active: active,
          query: query,
        ),
      ),
      fallbackMessage:
          'Nie udało się pobrać listy pracowników przypisanych do stanowiska.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane listy pracowników stanowiska.',
    );
  }

  @override
  Future<Either<ApiError, List<GetBhpUserStandardItem>>> getPositionStandards(
    int positionId,
  ) {
    return guardApiCall(
      () async => List<GetBhpUserStandardItem>.unmodifiable(
        await _api.getPositionStandards(positionId),
      ),
      fallbackMessage: 'Nie udało się pobrać standardu stanowiska.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane standardu stanowiska.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserStandardItem>> createPositionStandard(
    int positionId,
    PostBhpPositionStandardRequest request,
  ) {
    return guardApiCall(
      () => _api.createPositionStandard(positionId, request),
      fallbackMessage:
          'Nie udało się dodać pozycji do standardu stanowiska BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane nowej pozycji standardu stanowiska.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserStandardItem>> updatePositionStandard(
    int positionId,
    int standardId,
    PatchBhpPositionStandardRequest request,
  ) {
    return guardApiCall(
      () => _api.updatePositionStandard(positionId, standardId, request),
      fallbackMessage:
          'Nie udało się zapisać pozycji standardu stanowiska BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane zapisanej pozycji standardu stanowiska.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserStandardItem>> archivePositionStandard(
    int positionId,
    int standardId,
  ) {
    return guardApiCall(
      () => _api.archivePositionStandard(positionId, standardId),
      fallbackMessage:
          'Nie udało się zarchiwizować pozycji standardu stanowiska BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane archiwizowanej pozycji standardu stanowiska.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserStandardItem>> unarchivePositionStandard(
    int positionId,
    int standardId,
  ) {
    return guardApiCall(
      () => _api.unarchivePositionStandard(positionId, standardId),
      fallbackMessage:
          'Nie udało się przywrócić pozycji standardu stanowiska BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane przywracanej pozycji standardu stanowiska.',
    );
  }

  @override
  Future<Either<ApiError, Unit>> deletePositionStandard(
    int positionId,
    int standardId,
  ) {
    return guardApiCall(
      () async {
        await _api.deletePositionStandard(positionId, standardId);
        return unit;
      },
      fallbackMessage: 'Nie udało się usunąć pozycji standardu stanowiska BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłową odpowiedź podczas usuwania pozycji standardu stanowiska.',
    );
  }
}
