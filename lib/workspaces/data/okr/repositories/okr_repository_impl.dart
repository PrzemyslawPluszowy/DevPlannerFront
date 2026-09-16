import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/okr/api/okr_api.dart';
import 'package:ready_next/workspaces/data/okr/models/okr_models.dart';
import 'package:ready_next/workspaces/domain/repositories/okr_repository.dart';

/// Adapter API OKR z ujednoliconą obsługą błędów transportowych.
final class OkrRepositoryImpl extends ApiRepository implements OkrRepository {
  // Publicne `api` zachowuje czytelny kontrakt konstruktora między pakietami;
  // pole transportu pozostaje prywatne zgodnie z granicą warstwy danych.
  // ignore: prefer_initializing_formals
  OkrRepositoryImpl({required OkrApi api}) : _api = api;

  final OkrApi _api;

  @override
  Future<Either<ApiError, ObjectiveResponse>> getObjective({
    required String workspaceId,
    required String objectiveId,
  }) => guardApiCall(
    () => _api.getObjective(workspaceId, objectiveId),
    fallbackMessage: 'Nie udało się pobrać celu OKR.',
    parsingMessage: 'Backend zwrócił nieprawidłowy cel OKR.',
  );
}
