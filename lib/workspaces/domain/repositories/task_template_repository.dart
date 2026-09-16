import 'package:dartz/dartz.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_templates_models.dart';

/// Biblioteka szablonów zadań workspace i osobiste ustawienie domyślne.
abstract interface class TaskTemplateRepository {
  Future<Either<ApiError, List<TaskTemplateResponse>>> list(String workspaceId);
  Future<Either<ApiError, TaskTemplateResponse>> create({
    required String workspaceId,
    required String taskId,
    required CreateTaskTemplatePayload payload,
  });
  Future<Either<ApiError, TaskTemplateResponse>> createFromDefinition({
    required String workspaceId,
    required CreateTaskTemplateDefinitionPayload payload,
  });
  Future<Either<ApiError, TaskTemplateDetailsResponse>> details({
    required String workspaceId,
    required String templateId,
  });
  Future<Either<ApiError, TaskTemplateDetailsResponse>> update({
    required String workspaceId,
    required String templateId,
    required UpdateTaskTemplatePayload payload,
  });
  Future<Either<ApiError, Unit>> delete({
    required String workspaceId,
    required String templateId,
    required int expectedVersion,
  });
  Future<Either<ApiError, ProjectTaskResponse>> apply({
    required String workspaceId,
    required String templateId,
    required ApplyTaskTemplatePayload payload,
  });
  Future<Either<ApiError, DefaultTaskTemplateResponse>> getDefault(
    String workspaceId,
  );
  Future<Either<ApiError, DefaultTaskTemplateResponse>> setDefault({
    required String workspaceId,
    required SetDefaultTaskTemplatePayload payload,
  });
}
