import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/milestones/api/milestones_api.dart';
import 'package:ready_next/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:ready_next/workspaces/domain/repositories/milestone_repository.dart';

/// Produkcyjna implementacja kontraktu kamieni milowych Workspaces.
final class MilestoneRepositoryImpl extends ApiRepository
    implements MilestoneRepository {
  MilestoneRepositoryImpl(this._api);

  final MilestonesApi _api;

  @override
  Future<Either<ApiError, List<MilestoneResponse>>> listMilestones({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.listMilestones(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać kamieni milowych projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę kamieni milowych.',
  );

  @override
  Future<Either<ApiError, MilestoneResponse>> getMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  }) => guardApiCall(
    () => _api.getMilestone(workspaceId, projectId, milestoneId),
    fallbackMessage: 'Nie udało się pobrać szczegółów kamienia milowego.',
    parsingMessage: 'Backend zwrócił nieprawidłowy kamień milowy.',
  );

  @override
  Future<Either<ApiError, MilestoneResponse>> createMilestone({
    required String workspaceId,
    required String projectId,
    required CreateMilestonePayload payload,
  }) => guardApiCall(
    () => _api.createMilestone(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się utworzyć kamienia milowego.',
  );

  @override
  Future<Either<ApiError, MilestoneResponse>> updateMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required UpdateMilestonePayload payload,
  }) => guardApiCall(
    () => _api.updateMilestone(workspaceId, projectId, milestoneId, payload),
    fallbackMessage: 'Nie udało się zapisać kamienia milowego.',
  );

  @override
  Future<Either<ApiError, Unit>> deleteMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  }) => guardApiCall(
    () async {
      await _api.deleteMilestone(workspaceId, projectId, milestoneId);
      return unit;
    },
    fallbackMessage: 'Nie udało się usunąć kamienia milowego.',
  );

  @override
  Future<Either<ApiError, List<MilestoneTaskResponse>>> listTasks({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  }) => guardApiCall(
    () => _api.listMilestoneTasks(workspaceId, projectId, milestoneId),
    fallbackMessage: 'Nie udało się pobrać zadań kamienia milowego.',
    parsingMessage:
        'Backend zwrócił nieprawidłową listę zadań kamienia milowego.',
  );

  @override
  Future<Either<ApiError, Unit>> assignTask({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required String taskId,
  }) => guardApiCall(
    () async {
      await _api.assignTask(workspaceId, projectId, milestoneId, taskId);
      return unit;
    },
    fallbackMessage: 'Nie udało się przypisać zadania do kamienia milowego.',
  );

  @override
  Future<Either<ApiError, Unit>> unassignTask({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required String taskId,
  }) => guardApiCall(
    () async {
      await _api.unassignTask(workspaceId, projectId, milestoneId, taskId);
      return unit;
    },
    fallbackMessage:
        'Nie udało się usunąć przypisania zadania do kamienia milowego.',
  );
}
