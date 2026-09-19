import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_metadata_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_mutation_coordinator.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_response_assembler.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';

/// Commands for labels and custom field values.
final class TaskDetailsMetadataCommands {
  const TaskDetailsMetadataCommands({
    required this.service,
    required this.coordinator,
    required this.assembler,
    required this.readState,
    required this.emitReady,
  });

  final TaskDetailsMetadataService service;
  final TaskDetailsMutationCoordinator coordinator;
  final TaskDetailsResponseAssembler assembler;
  final TaskDetailsState Function() readState;
  final void Function(TaskDetailsReady state) emitReady;

  Future<List<TaskLabelResponse>> listLabels() async {
    final result = await service.listLabels();
    return result.fold((_) => const [], (labels) => labels);
  }

  Future<bool> replaceLabels(Iterable<String> labelIds) async {
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.execute(
      current: current,
      operation: service.replaceLabels(
        labelIds: labelIds,
        expectedVersion: current.details.task.version,
      ),
      onSuccess: assembler.withLabels,
    );
  }

  Future<bool> replaceCustomFieldValues(Map<String, dynamic> values) async {
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.execute(
      current: current,
      operation: service.replaceCustomFieldValues(
        values: values,
        expectedVersion: current.details.task.version,
      ),
      onSuccess: assembler.withCustomFieldValues,
    );
  }
}
