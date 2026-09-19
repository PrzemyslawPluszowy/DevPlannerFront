import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_acceptance_criteria_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_mutation_coordinator.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_response_assembler.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';

/// Commands for acceptance criteria mutations.
final class TaskDetailsAcceptanceCommands {
  const TaskDetailsAcceptanceCommands({
    required this.service,
    required this.coordinator,
    required this.assembler,
    required this.readState,
    required this.emitReady,
  });

  final TaskAcceptanceCriteriaService service;
  final TaskDetailsMutationCoordinator coordinator;
  final TaskDetailsResponseAssembler assembler;
  final TaskDetailsState Function() readState;
  final void Function(TaskDetailsReady state) emitReady;

  Future<bool> add(String text) async {
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.execute(
      current: current,
      operation: service.add(
        text: text,
        expectedVersion: current.details.task.version,
      ),
      onSuccess: (current, response) {
        final criteria = [...current.details.acceptanceCriteria, response.data]
          ..sort((a, b) => a.position.compareTo(b.position));
        return assembler.withCriteriaMutation(current, criteria, response);
      },
    );
  }

  Future<bool> update(
    TaskAcceptanceCriterionResponse criterion, {
    String? text,
    bool? isAccepted,
  }) async {
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.execute(
      current: current,
      operation: service.update(
        criterion: criterion,
        text: text,
        isAccepted: isAccepted,
        expectedVersion: current.details.task.version,
      ),
      onSuccess: (current, response) {
        final criteria = current.details.acceptanceCriteria
            .map(
              (candidate) =>
                  candidate.id == criterion.id ? response.data : candidate,
            )
            .toList(growable: false);
        return assembler.withCriteriaMutation(current, criteria, response);
      },
    );
  }

  Future<bool> delete(TaskAcceptanceCriterionResponse criterion) async {
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.execute(
      current: current,
      operation: service.delete(
        criterion: criterion,
        expectedVersion: current.details.task.version,
      ),
      onSuccess: (current, response) {
        final criteria = current.details.acceptanceCriteria
            .where((candidate) => candidate.id != criterion.id)
            .toList(growable: false);
        return assembler.withCriteriaMutation(current, criteria, response);
      },
    );
  }
}
