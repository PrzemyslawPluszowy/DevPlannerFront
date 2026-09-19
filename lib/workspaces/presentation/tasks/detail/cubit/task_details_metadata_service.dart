import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';

/// Typed transport for labels and custom task fields.
final class TaskDetailsMetadataService {
  const TaskDetailsMetadataService({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  });

  final TaskMetadataRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;

  Future<Either<ApiError, List<TaskLabelResponse>>> listLabels() =>
      repository.listLabels(workspaceId: workspaceId, projectId: projectId);

  Future<Either<ApiError, TaskMutationResponse<List<TaskLabelResponse>>>>
  replaceLabels({
    required Iterable<String> labelIds,
    required int expectedVersion,
  }) => repository.replaceLabels(
    workspaceId: workspaceId,
    projectId: projectId,
    taskId: taskId,
    payload: ReplaceTaskLabelsPayload(
      labelIds: labelIds.toSet().toList(growable: false),
      expectedVersion: expectedVersion,
    ),
  );

  Future<
    Either<ApiError, TaskMutationResponse<List<TaskCustomFieldValueResponse>>>
  >
  replaceCustomFieldValues({
    required Map<String, dynamic> values,
    required int expectedVersion,
  }) => repository.replaceCustomFieldValues(
    workspaceId: workspaceId,
    projectId: projectId,
    taskId: taskId,
    payload: ReplaceTaskCustomFieldValuesPayload(
      values: Map<String, dynamic>.unmodifiable(values),
      expectedVersion: expectedVersion,
    ),
  );
}
