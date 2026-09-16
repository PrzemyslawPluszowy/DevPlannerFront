import 'package:dartz/dartz.dart';
import 'package:ready_next/core/data/api_repository.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/api/task_templates_api.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:ready_next/workspaces/domain/repositories/task_template_repository.dart';

final class TaskTemplateRepositoryImpl extends ApiRepository
    implements TaskTemplateRepository {
  TaskTemplateRepositoryImpl(this._api);
  final TaskTemplatesApi _api;
  @override
  Future<Either<ApiError, List<TaskTemplateResponse>>> list(
    String workspaceId,
  ) => guardApiCall(
    () => _api.list(workspaceId),
    fallbackMessage: 'Nie udało się pobrać szablonów zadań.',
  );
  @override
  Future<Either<ApiError, TaskTemplateResponse>> create({
    required String workspaceId,
    required String taskId,
    required CreateTaskTemplatePayload payload,
  }) => guardApiCall(
    () => _api.create(workspaceId, taskId, payload),
    fallbackMessage: 'Nie udało się utworzyć szablonu zadania.',
  );
  @override
  Future<Either<ApiError, TaskTemplateResponse>> createFromDefinition({
    required String workspaceId,
    required CreateTaskTemplateDefinitionPayload payload,
  }) => guardApiCall(
    () => _api.createFromDefinition(workspaceId, payload),
    fallbackMessage: 'Nie udało się utworzyć szablonu zadania.',
  );
  @override
  Future<Either<ApiError, TaskTemplateDetailsResponse>> details({
    required String workspaceId,
    required String templateId,
  }) => guardApiCall(
    () => _api.getDetails(workspaceId, templateId),
    fallbackMessage: 'Nie udało się pobrać szablonu zadania.',
  );
  @override
  Future<Either<ApiError, TaskTemplateDetailsResponse>> update({
    required String workspaceId,
    required String templateId,
    required UpdateTaskTemplatePayload payload,
  }) => guardApiCall(
    () => _api.update(workspaceId, templateId, payload),
    fallbackMessage: 'Nie udało się zapisać szablonu zadania.',
  );
  @override
  Future<Either<ApiError, Unit>> delete({
    required String workspaceId,
    required String templateId,
    required int expectedVersion,
  }) async {
    final result = await guardApiCall(
      () => _api.delete(
        workspaceId,
        templateId,
        expectedVersion: expectedVersion,
      ),
      fallbackMessage: 'Nie udało się usunąć szablonu zadania.',
    );
    return result.map((_) => unit);
  }

  @override
  Future<Either<ApiError, ProjectTaskResponse>> apply({
    required String workspaceId,
    required String templateId,
    required ApplyTaskTemplatePayload payload,
  }) => guardApiCall(
    () => _api.apply(workspaceId, templateId, payload),
    fallbackMessage: 'Nie udało się zastosować szablonu zadania.',
  );
  @override
  Future<Either<ApiError, DefaultTaskTemplateResponse>> getDefault(
    String workspaceId,
  ) => guardApiCall(
    () => _api.getDefault(workspaceId),
    fallbackMessage: 'Nie udało się pobrać domyślnego szablonu.',
  );
  @override
  Future<Either<ApiError, DefaultTaskTemplateResponse>> setDefault({
    required String workspaceId,
    required SetDefaultTaskTemplatePayload payload,
  }) => guardApiCall(
    () => _api.setDefault(workspaceId, payload),
    fallbackMessage: 'Nie udało się zapisać domyślnego szablonu.',
  );
}
