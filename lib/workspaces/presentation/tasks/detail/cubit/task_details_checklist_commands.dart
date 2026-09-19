import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_checklist_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_mutation_coordinator.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_response_assembler.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';

/// Commands for checklist mutations; Cubit remains a public compatibility API.
final class TaskDetailsChecklistCommands {
  const TaskDetailsChecklistCommands({
    required this.service,
    required this.coordinator,
    required this.assembler,
    required this.readState,
    required this.emitReady,
  });

  final TaskDetailsChecklistService service;
  final TaskDetailsMutationCoordinator coordinator;
  final TaskDetailsResponseAssembler assembler;
  final TaskDetailsState Function() readState;
  final void Function(TaskDetailsReady state) emitReady;

  Future<bool> add(String title) async {
    final current = readState();
    final normalized = title.trim();
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        normalized.isEmpty) {
      return false;
    }
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.execute(
      current: current,
      operation: service.add(
        title: normalized,
        expectedVersion: current.details.task.version,
      ),
      onSuccess: (current, response) {
        final items = [...current.details.task.checklistItems, response.data]
          ..sort((a, b) => a.position.compareTo(b.position));
        return assembler.withChecklistMutation(current, items, response);
      },
    );
  }

  Future<bool> update(
    TaskChecklistItemResponse item, {
    String? title,
    bool? isCompleted,
  }) async {
    final current = readState();
    final normalizedTitle = (title ?? item.title).trim();
    if (current is! TaskDetailsReady ||
        current.isSaving ||
        normalizedTitle.isEmpty) {
      return false;
    }
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.execute(
      current: current,
      operation: service.update(
        item: item,
        title: normalizedTitle,
        isCompleted: isCompleted,
        expectedVersion: current.details.task.version,
      ),
      onSuccess: (current, response) {
        final items = current.details.task.checklistItems
            .map(
              (candidate) =>
                  candidate.id == item.id ? response.data : candidate,
            )
            .toList(growable: false);
        return assembler.withChecklistMutation(current, items, response);
      },
    );
  }

  Future<bool> delete(TaskChecklistItemResponse item) async {
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.execute(
      current: current,
      operation: service.delete(
        item: item,
        expectedVersion: current.details.task.version,
      ),
      onSuccess: (current, response) {
        final items = current.details.task.checklistItems
            .where((candidate) => candidate.id != item.id)
            .toList(growable: false);
        return assembler.withChecklistMutation(current, items, response);
      },
    );
  }
}
