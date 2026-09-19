import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_dependencies_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_mutation_coordinator.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_response_assembler.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';

/// Commands for task dependency mutations.
final class TaskDetailsDependencyCommands {
  const TaskDetailsDependencyCommands({
    required this.service,
    required this.coordinator,
    required this.assembler,
    required this.readState,
    required this.emitReady,
  });

  final TaskDetailsDependenciesService service;
  final TaskDetailsMutationCoordinator coordinator;
  final TaskDetailsResponseAssembler assembler;
  final TaskDetailsState Function() readState;
  final void Function(TaskDetailsReady state) emitReady;

  Future<List<ProjectTaskListItemResponse>> search(String phrase) =>
      service.search(phrase);

  Future<bool> create({
    required String targetTaskId,
    required TaskDependencyType type,
    required TaskDependencyKind dependencyKind,
    required int lagDays,
  }) async {
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.executeAndRefresh(
      current: current,
      operation: service.create(
        targetTaskId: targetTaskId,
        type: type,
        dependencyKind: dependencyKind,
        lagDays: lagDays,
        expectedVersion: current.details.task.version,
      ),
    );
  }

  Future<bool> update({
    required TaskDependencyDetailsResponse dependency,
    required TaskDependencyKind dependencyKind,
    required int lagDays,
  }) async {
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.execute(
      current: current,
      operation: service.update(
        dependency: dependency,
        dependencyKind: dependencyKind,
        lagDays: lagDays,
        expectedVersion: current.details.task.version,
      ),
      onSuccess: (current, response) => assembler.withDependencyUpdate(
        current,
        dependency,
        response,
      ),
    );
  }

  Future<bool> delete(TaskDependencyDetailsResponse dependency) async {
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.execute(
      current: current,
      operation: service.delete(
        dependency: dependency,
        expectedVersion: current.details.task.version,
      ),
      onSuccess: (current, response) => assembler.withDependencyDeleted(
        current,
        dependency.id,
        response,
      ),
    );
  }
}
