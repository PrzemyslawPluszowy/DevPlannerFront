import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';

/// Use-cases podstawowej edycji agregatu zadania.
///
/// Budowanie payloadów i wybór endpointu są poza Cubitem. Cubit pozostaje
/// właścicielem stanu, konfliktów oraz scalania odpowiedzi z widokiem.
final class TaskDetailsBasicMutationService {
  const TaskDetailsBasicMutationService({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  });

  final TasksRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;

  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>> update({
    required UpdateProjectTaskPayload payload,
  }) => repository.updateTask(
    workspaceId: workspaceId,
    projectId: projectId,
    taskId: taskId,
    payload: payload,
  );

  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  updateBasics({
    required ProjectTaskResponse task,
    required String title,
    required ProjectTaskStatus status,
    required TaskPriority priority,
  }) => update(
    payload: _payloadFrom(
      task,
      title: title,
      status: status,
      priority: priority,
      startAtUtc: task.startAtUtc,
      dueAtUtc: task.dueAtUtc,
      estimatedMinutes: task.estimatedMinutes,
    ),
  );

  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  updatePlanning({
    required ProjectTaskResponse task,
    required DateTime? startAtUtc,
    required DateTime? dueAtUtc,
    required int? estimatedMinutes,
  }) => update(
    payload: _payloadFrom(
      task,
      replacePlanning: true,
      startAtUtc: startAtUtc,
      dueAtUtc: dueAtUtc,
      estimatedMinutes: estimatedMinutes,
    ),
  );

  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  updateDescription({
    required ProjectTaskResponse task,
    required String description,
    required String descriptionDeltaJson,
  }) => update(
    payload: _payloadFrom(
      task,
      replaceDescription: true,
      description: description.trim().isEmpty ? null : description.trim(),
      descriptionDeltaJson: descriptionDeltaJson,
    ),
  );

  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  toggleArchive(ProjectTaskResponse task) => task.archivedAtUtc == null
      ? repository.archiveTask(
          workspaceId: workspaceId,
          projectId: projectId,
          taskId: taskId,
          expectedVersion: task.version,
        )
      : repository.restoreTask(
          workspaceId: workspaceId,
          projectId: projectId,
          taskId: taskId,
          expectedVersion: task.version,
        );

  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  createSubtask({required ProjectTaskResponse task, required String title}) =>
      repository.quickCreateTask(
        workspaceId: workspaceId,
        projectId: projectId,
        payload: QuickCreateProjectTaskPayload(
          title: title.trim(),
          parentTaskId: task.id,
          targetStatus: ProjectTaskStatus.todo,
        ),
      );

  UpdateProjectTaskPayload _payloadFrom(
    ProjectTaskResponse task, {
    String? title,
    ProjectTaskStatus? status,
    TaskPriority? priority,
    DateTime? startAtUtc,
    DateTime? dueAtUtc,
    int? estimatedMinutes,
    String? description,
    String? descriptionDeltaJson,
    bool replacePlanning = false,
    bool replaceDescription = false,
  }) => UpdateProjectTaskPayload(
    title: title ?? task.title,
    description: replaceDescription ? description : task.description,
    status: status ?? task.status,
    priority: priority ?? task.priority,
    startAtUtc: replacePlanning ? startAtUtc : task.startAtUtc,
    dueAtUtc: replacePlanning ? dueAtUtc : task.dueAtUtc,
    position: task.position,
    expectedVersion: task.version,
    taskType: task.taskType,
    size: task.size,
    complexity: task.complexity,
    risk: task.risk,
    businessValue: task.businessValue,
    estimatedMinutes: replacePlanning
        ? estimatedMinutes
        : task.estimatedMinutes,
    actualMinutes: task.actualMinutes,
    descriptionDeltaJson: descriptionDeltaJson ?? task.descriptionDeltaJson,
  );
}
