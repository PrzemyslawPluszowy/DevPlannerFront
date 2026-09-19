import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';

/// Use-cases relacji między zadaniami w ekranie szczegółów.
///
/// Serwis izoluje walidację identyfikatorów, zakres lagów i wywołania typed
/// repository. Nie posiada stanu UI; snapshot szczegółów scala cubit.
final class TaskDetailsDependenciesService {
  const TaskDetailsDependenciesService({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
  });

  final TasksRepository repository;
  final String workspaceId;
  final String projectId;
  final String taskId;

  Future<List<ProjectTaskListItemResponse>> search(String phrase) async {
    final query = phrase.trim();
    if (query.length < 2) return const [];
    final result = await repository.listProjectTasks(
      workspaceId: workspaceId,
      projectId: projectId,
      query: ProjectTasksQuery(search: query, limit: 20),
    );
    return result.fold((_) => const [], (page) => page.items);
  }

  Future<Either<ApiError, TaskMutationResponse<TaskDependencyResponse>>>
  create({
    required String targetTaskId,
    required TaskDependencyType type,
    required TaskDependencyKind dependencyKind,
    required int lagDays,
    required int expectedVersion,
  }) {
    if (targetTaskId == taskId || lagDays < -365 || lagDays > 365) {
      return Future.value(
        const Left(
          ApiError(
            type: ApiErrorType.validation,
            message: 'Nieprawidłowy cel albo przesunięcie relacji zadania.',
          ),
        ),
      );
    }
    return repository.createDependency(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      payload: CreateTaskDependencyPayload(
        targetTaskId: targetTaskId,
        type: type,
        expectedVersion: expectedVersion,
        dependencyKind: dependencyKind,
        lagDays: lagDays,
      ),
    );
  }

  Future<Either<ApiError, TaskMutationResponse<TaskDependencyResponse>>>
  update({
    required TaskDependencyDetailsResponse dependency,
    required TaskDependencyKind dependencyKind,
    required int lagDays,
    required int expectedVersion,
  }) {
    if (lagDays < -365 || lagDays > 365) {
      return Future.value(
        const Left(
          ApiError(
            type: ApiErrorType.validation,
            message:
                'Przesunięcie relacji musi mieścić się w zakresie -365–365.',
          ),
        ),
      );
    }
    return repository.updateDependency(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      dependencyId: dependency.id,
      payload: UpdateTaskDependencyPayload(
        dependencyKind: dependencyKind,
        lagDays: lagDays,
        expectedVersion: expectedVersion,
      ),
    );
  }

  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  delete({
    required TaskDependencyDetailsResponse dependency,
    required int expectedVersion,
  }) => repository.deleteDependency(
    workspaceId: workspaceId,
    projectId: projectId,
    taskId: taskId,
    dependencyId: dependency.id,
    expectedVersion: expectedVersion,
  );
}
