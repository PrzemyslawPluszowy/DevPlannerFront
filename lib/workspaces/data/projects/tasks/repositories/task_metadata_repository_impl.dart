import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/api/task_operations_api.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/domain/repositories/task_metadata_repository.dart';

/// Adapter etykiet i innych metadanych Tasks do kontraktów domeny.
final class TaskMetadataRepositoryImpl extends ApiRepository
    implements TaskMetadataRepository {
  /// Tworzy adapter oparty na uwierzytelnionym kliencie operacji taska.
  TaskMetadataRepositoryImpl(this._api);

  final TaskOperationsApi _api;

  @override
  Future<Either<ApiError, List<TaskLabelResponse>>> listLabels({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.listLabels(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać etykiet projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę etykiet.',
  );

  @override
  Future<Either<ApiError, TaskLabelResponse>> createLabel({
    required String workspaceId,
    required String projectId,
    required CreateTaskLabelPayload payload,
  }) => guardApiCall(
    () => _api.createLabel(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się utworzyć etykiety projektu.',
  );

  @override
  Future<Either<ApiError, TaskLabelResponse>> updateLabel({
    required String workspaceId,
    required String projectId,
    required String labelId,
    required UpdateTaskLabelPayload payload,
  }) => guardApiCall(
    () => _api.updateLabel(workspaceId, projectId, labelId, payload),
    fallbackMessage: 'Nie udało się zapisać etykiety projektu.',
  );

  @override
  Future<Either<ApiError, Unit>> archiveLabel({
    required String workspaceId,
    required String projectId,
    required String labelId,
  }) => guardApiCall(
    () async {
      await _api.archiveLabel(workspaceId, projectId, labelId);
      return unit;
    },
    fallbackMessage: 'Nie udało się zarchiwizować etykiety projektu.',
  );

  @override
  Future<Either<ApiError, List<TaskCustomFieldResponse>>> listCustomFields({
    required String workspaceId,
    required String projectId,
  }) => guardApiCall(
    () => _api.listCustomFields(workspaceId, projectId),
    fallbackMessage: 'Nie udało się pobrać pól własnych projektu.',
    parsingMessage: 'Backend zwrócił nieprawidłową listę pól własnych.',
  );

  @override
  Future<Either<ApiError, TaskCustomFieldResponse>> createCustomField({
    required String workspaceId,
    required String projectId,
    required CreateTaskCustomFieldPayload payload,
  }) => guardApiCall(
    () => _api.createCustomField(workspaceId, projectId, payload),
    fallbackMessage: 'Nie udało się utworzyć pola własnego.',
  );

  @override
  Future<Either<ApiError, TaskCustomFieldResponse>> updateCustomField({
    required String workspaceId,
    required String projectId,
    required String fieldId,
    required UpdateTaskCustomFieldPayload payload,
  }) => guardApiCall(
    () => _api.updateCustomField(workspaceId, projectId, fieldId, payload),
    fallbackMessage: 'Nie udało się zapisać pola własnego.',
  );

  @override
  Future<Either<ApiError, Unit>> archiveCustomField({
    required String workspaceId,
    required String projectId,
    required String fieldId,
  }) => guardApiCall(
    () async {
      await _api.archiveCustomField(workspaceId, projectId, fieldId);
      return unit;
    },
    fallbackMessage: 'Nie udało się zarchiwizować pola własnego.',
  );

  @override
  Future<Either<ApiError, TaskMutationResponse<List<TaskLabelResponse>>>>
  replaceLabels({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required ReplaceTaskLabelsPayload payload,
  }) => guardApiCall(
    () => _api.replaceLabels(workspaceId, projectId, taskId, payload),
    fallbackMessage: 'Nie udało się zapisać etykiet zadania.',
  );

  @override
  Future<
    Either<ApiError, TaskMutationResponse<List<TaskCustomFieldValueResponse>>>
  >
  replaceCustomFieldValues({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required ReplaceTaskCustomFieldValuesPayload payload,
  }) => guardApiCall(
    () => _api.replaceCustomFieldValues(
      workspaceId,
      projectId,
      taskId,
      payload,
    ),
    fallbackMessage: 'Nie udało się zapisać pól własnych zadania.',
  );
}
