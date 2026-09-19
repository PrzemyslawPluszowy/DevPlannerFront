import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_collaboration_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_mutation_coordinator.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_response_assembler.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';

/// Commands for assignees, watching and personal pinning.
final class TaskDetailsCollaborationCommands {
  const TaskDetailsCollaborationCommands({
    required this.service,
    required this.coordinator,
    required this.assembler,
    required this.readState,
    required this.emitReady,
  });

  final TaskDetailsCollaborationService service;
  final TaskDetailsMutationCoordinator coordinator;
  final TaskDetailsResponseAssembler assembler;
  final TaskDetailsState Function() readState;
  final void Function(TaskDetailsReady state) emitReady;

  Future<bool> replaceAssignees(List<String> userIds) async {
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.execute(
      current: current,
      operation: service.replaceAssignees(
        userIds: userIds,
        expectedVersion: current.details.task.version,
      ),
      onSuccess: assembler.withProjectTaskMutation,
    );
  }

  Future<bool> toggleWatching() async {
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving) return false;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.executeAndRefresh(
      current: current,
      operation: service.toggleWatching(
        isWatched: current.details.isWatchedByMe,
        expectedVersion: current.details.task.version,
      ),
    );
  }

  Future<bool> togglePinned() async {
    final current = readState();
    if (current is! TaskDetailsReady || current.isSaving) return false;
    final isPinned = !current.details.isPinnedByMe;
    emitReady(current.copyWith(isSaving: true, clearMutationError: true));
    return coordinator.execute(
      current: current,
      operation: service.togglePinned(isPinned: isPinned),
      onSuccess: (current, _) => assembler.withPinned(current, isPinned),
    );
  }
}
