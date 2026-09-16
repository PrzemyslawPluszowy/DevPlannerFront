import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/features/bhp/data/api/bhp_api.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Kontrakt repozytorium pracowników BHP.
abstract interface class BhpUsersRepository {
  /// Pobiera listę pracowników BHP.
  Future<Either<ApiError, List<GetBhpUserListItem>>> getUsers({
    bool? active,
    String? query,
  });

  /// Pobiera szczegóły pojedynczego pracownika BHP.
  Future<Either<ApiError, GetBhpUserDetail>> getUserDetails(int userId);

  /// Tworzy nową kartę pracownika BHP.
  Future<Either<ApiError, GetBhpUserListItem>> createUser(
    PostBhpUserRequest request,
  );

  /// Masowo aktualizuje stanowisko dla pracowników BHP.
  Future<Either<ApiError, Unit>> bulkUpdatePosition({
    required List<int> employeeIds,
    required int stanowiskoId,
  });

  /// Aktualizuje dane pracownika BHP.
  Future<Either<ApiError, GetBhpUserListItem>> updateUser(
    int userId,
    PostBhpUserRequest request,
  );

  /// Archiwizuje wskazanego pracownika BHP.
  Future<Either<ApiError, GetBhpUserListItem>> archiveUser(int userId);

  /// Przywraca zarchiwizowanego pracownika BHP.
  Future<Either<ApiError, GetBhpUserListItem>> unarchiveUser(int userId);

  /// Usuwa zarchiwizowanego pracownika BHP z bazy danych.
  Future<Either<ApiError, Unit>> destroyUser(int userId);

  /// Pobiera historię wydań wyposażenia pracownika BHP.
  Future<Either<ApiError, List<GetBhpUserIssue>>> getUserIssues(int userId);

  /// Tworzy ręczne wydanie wyposażenia dla pracownika BHP.
  Future<Either<ApiError, GetBhpUserIssue>> createUserIssue(
    int userId,
    PostBhpUserIssueRequest request,
  );

  /// Aktualizuje ręczne wydanie wyposażenia pracownika BHP.
  Future<Either<ApiError, GetBhpUserIssue>> updateUserIssue(
    int userId,
    int issueId,
    PatchBhpUserIssueRequest request,
  );

  /// Usuwa błędnie zapisane wydanie wyposażenia pracownika BHP.
  Future<Either<ApiError, Unit>> deleteUserIssue(
    int userId,
    int issueId,
  );

  /// Generuje wydania ze standardu stanowiska pracownika BHP.
  Future<Either<ApiError, List<GetBhpUserIssue>>> assignIssuesFromStandard(
    int userId, [
    List<int>? selectedStandardIds,
  ]);

  /// Powtarza zakończone wydanie wyposażenia pracownika BHP.
  Future<Either<ApiError, GetBhpUserIssue>> repeatUserIssue(
    int userId,
    int issueId,
  );

  /// Zbiorczo powtarza zakończone wydania wyposażenia pracownika BHP.
  Future<Either<ApiError, List<GetBhpUserIssue>>> repeatUserIssues(
    int userId,
    PostBhpUserIssuesRepeatRequest request,
  );

  /// Zamyka aktywne wydanie wyposażenia pracownika BHP.
  Future<Either<ApiError, GetBhpUserIssue>> closeIssue(
    int userId,
    int issueId,
    PostCloseBhpUserIssueRequest request,
  );

  /// Rejestruje ekwiwalent dla wydania wyposażenia pracownika BHP.
  Future<Either<ApiError, GetBhpUserIssue>> registerIssueEquivalent(
    int userId,
    int issueId,
    PostBhpUserIssueEquivalentRequest request,
  );

  /// Usuwa zarejestrowany ekwiwalent z wydania wyposażenia pracownika BHP.
  Future<Either<ApiError, GetBhpUserIssue>> deleteIssueEquivalent(
    int userId,
    int issueId,
  );
}

/// Implementacja repozytorium pracowników BHP oparta o Retrofit.
class BhpUsersRepositoryImpl extends ApiRepository
    implements BhpUsersRepository {
  /// Tworzy repozytorium z klientem API BHP.
  BhpUsersRepositoryImpl({required this._api});

  final BhpApi _api;

  @override
  Future<Either<ApiError, List<GetBhpUserListItem>>> getUsers({
    bool? active,
    String? query,
  }) {
    return guardApiCall(
      () async => List<GetBhpUserListItem>.unmodifiable(
        await _api.getUsers(active: active, query: query),
      ),
      fallbackMessage: 'Nie udało się pobrać listy pracowników BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane listy pracowników BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserDetail>> getUserDetails(int userId) {
    return guardApiCall(
      () async => _api.getUserDetails(userId),
      fallbackMessage: 'Nie udało się pobrać szczegółów pracownika BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane szczegółów pracownika BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserListItem>> createUser(
    PostBhpUserRequest request,
  ) {
    return guardApiCall(
      () async => _api.createUser(request),
      fallbackMessage: 'Nie udało się dodać pracownika BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane nowego pracownika BHP.',
    );
  }

  @override
  Future<Either<ApiError, Unit>> bulkUpdatePosition({
    required List<int> employeeIds,
    required int stanowiskoId,
  }) {
    return guardApiCall(
      () async {
        await _api.bulkUpdatePosition(
          PostBhpUsersBulkPositionRequest(
            employeeIds: employeeIds,
            stanowiskoId: stanowiskoId,
          ),
        );
        return unit;
      },
      fallbackMessage: 'Nie udało się masowo zmienić stanowiska pracowników.',
      parsingMessage:
          'Backend zwrócił nieprawidłową odpowiedź dla masowej zmiany stanowiska.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserListItem>> updateUser(
    int userId,
    PostBhpUserRequest request,
  ) {
    return guardApiCall(
      () async => _api.updateUser(userId, request),
      fallbackMessage: 'Nie udało się zapisać zmian pracownika BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane zaktualizowanego pracownika BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserListItem>> archiveUser(int userId) {
    return guardApiCall(
      () async => _api.archiveUser(userId),
      fallbackMessage: 'Nie udało się usunąć pracownika BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane archiwizacji pracownika BHP.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserListItem>> unarchiveUser(int userId) {
    return guardApiCall(
      () async => _api.unarchiveUser(userId),
      fallbackMessage: 'Nie udało się przywrócić pracownika BHP.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane przywrócenia pracownika BHP.',
    );
  }

  @override
  Future<Either<ApiError, Unit>> destroyUser(int userId) {
    return guardApiCall(
      () async {
        await _api.destroyUser(userId);
        return unit;
      },
      fallbackMessage: 'Nie udało się usunąć pracownika z bazy danych.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po usunięciu pracownika.',
    );
  }

  @override
  Future<Either<ApiError, List<GetBhpUserIssue>>> getUserIssues(int userId) {
    return guardApiCall(
      () async => List<GetBhpUserIssue>.unmodifiable(
        await _api.getUserIssues(userId),
      ),
      fallbackMessage: 'Nie udało się pobrać wydań pracownika.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane wydań pracownika.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserIssue>> createUserIssue(
    int userId,
    PostBhpUserIssueRequest request,
  ) {
    return guardApiCall(
      () async => _api.createUserIssue(userId, request),
      fallbackMessage: 'Nie udało się dodać wydania pracownika.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane zapisanego wydania.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserIssue>> updateUserIssue(
    int userId,
    int issueId,
    PatchBhpUserIssueRequest request,
  ) {
    return guardApiCall(
      () async => _api.updateUserIssue(userId, issueId, request),
      fallbackMessage: 'Nie udało się zapisać korekty wydania pracownika.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane skorygowanego wydania.',
    );
  }

  @override
  Future<Either<ApiError, Unit>> deleteUserIssue(
    int userId,
    int issueId,
  ) {
    return guardApiCall(
      () async {
        await _api.deleteUserIssue(userId, issueId);
        return unit;
      },
      fallbackMessage: 'Nie udało się usunąć wydania pracownika.',
      parsingMessage:
          'Backend zwrócił nieprawidłową odpowiedź usuwania wydania.',
    );
  }

  @override
  Future<Either<ApiError, List<GetBhpUserIssue>>> assignIssuesFromStandard(
    int userId, [
    List<int>? selectedStandardIds,
  ]) {
    return guardApiCall(
      () async => List<GetBhpUserIssue>.unmodifiable(
        await _api.assignIssuesFromStandard(
          userId,
          PostBhpUserIssuesFromStandardRequest(
            selectedStandardIds: selectedStandardIds,
          ),
        ),
      ),
      fallbackMessage: 'Nie udało się przypisać wydań ze standardu.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane wygenerowanych wydań.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserIssue>> repeatUserIssue(
    int userId,
    int issueId,
  ) {
    return guardApiCall(
      () async => _api.repeatUserIssue(userId, issueId),
      fallbackMessage: 'Nie udało się powtórzyć wydania pracownika.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane powtórzonego wydania.',
    );
  }

  @override
  Future<Either<ApiError, List<GetBhpUserIssue>>> repeatUserIssues(
    int userId,
    PostBhpUserIssuesRepeatRequest request,
  ) {
    return guardApiCall(
      () async => List<GetBhpUserIssue>.unmodifiable(
        await _api.repeatUserIssues(userId, request),
      ),
      fallbackMessage: 'Nie udało się ponownie wydać wybranych pozycji.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane zbiorczego ponownego wydania.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserIssue>> closeIssue(
    int userId,
    int issueId,
    PostCloseBhpUserIssueRequest request,
  ) {
    return guardApiCall(
      () async => _api.closeIssue(userId, issueId, request),
      fallbackMessage: 'Nie udało się zamknąć wydania pracownika.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane zamknięcia wydania.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserIssue>> registerIssueEquivalent(
    int userId,
    int issueId,
    PostBhpUserIssueEquivalentRequest request,
  ) {
    return guardApiCall(
      () async => _api.registerIssueEquivalent(userId, issueId, request),
      fallbackMessage: 'Nie udało się zarejestrować ekwiwalentu.',
      parsingMessage: 'Backend zwrócił nieprawidłowe dane ekwiwalentu.',
    );
  }

  @override
  Future<Either<ApiError, GetBhpUserIssue>> deleteIssueEquivalent(
    int userId,
    int issueId,
  ) {
    return guardApiCall(
      () async => _api.deleteIssueEquivalent(userId, issueId),
      fallbackMessage: 'Nie udało się usunąć ekwiwalentu.',
      parsingMessage:
          'Backend zwrócił nieprawidłowe dane po usunięciu ekwiwalentu.',
    );
  }
}
