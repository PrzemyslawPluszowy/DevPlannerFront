import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:devplanner/workspaces/domain/repositories/custom_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_mutation_coordinator.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';

/// Własne statusy korzystają z chronionego PATCH, bez zgadywania kategorii.
final class TaskDetailsCustomWorkflowCommands {
  const TaskDetailsCustomWorkflowCommands({
    required this.repository,
    required this.tasks,
    required this.workspaceId,
    required this.projectId,
    required this.taskId,
    required this.coordinator,
    required this.readState,
    required this.emitReady,
  });

  final CustomWorkflowRepository repository;
  final TasksRepository tasks;
  final String workspaceId;
  final String projectId;
  final String taskId;
  final TaskDetailsMutationCoordinator coordinator;
  final TaskDetailsState Function() readState;
  final void Function(TaskDetailsReady) emitReady;

  Future<Either<ApiError, List<ProjectCustomStatusResponse>>> listStatuses() =>
      repository.listStatuses(workspaceId: workspaceId, projectId: projectId);

  Future<bool> move(String statusId) async {
    if (coordinator.isClosed() || statusId.isEmpty) return false;
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving || !current.canEdit) {
      return false;
    }
    if (current.details.task.customStatusId == statusId) return true;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.executeAndRefresh(
      current: current,
      operation: tasks.moveCustomStatus(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        customStatusId: statusId,
        expectedVersion: current.details.task.version,
      ),
    );
  }
}
