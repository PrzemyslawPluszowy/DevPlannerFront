import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class TaskWorkflowSettingsState {
  const TaskWorkflowSettingsState();
}

final class TaskWorkflowSettingsInitial extends TaskWorkflowSettingsState {
  const TaskWorkflowSettingsInitial();
}

final class TaskWorkflowSettingsLoading extends TaskWorkflowSettingsState {
  const TaskWorkflowSettingsLoading();
}

final class TaskWorkflowSettingsFailure extends TaskWorkflowSettingsState {
  const TaskWorkflowSettingsFailure(this.message);

  final String message;
}

final class TaskWorkflowSettingsReady extends TaskWorkflowSettingsState {
  const TaskWorkflowSettingsReady({
    required this.workflow,
    this.isSaving = false,
    this.error,
  });

  final ProjectTaskWorkflowResponse workflow;
  final bool isSaving;
  final String? error;

  TaskWorkflowSettingsReady copyWith({
    ProjectTaskWorkflowResponse? workflow,
    bool? isSaving,
    String? error,
    bool clearError = false,
  }) => TaskWorkflowSettingsReady(
    workflow: workflow ?? this.workflow,
    isSaving: isSaving ?? this.isSaving,
    error: clearError ? null : error ?? this.error,
  );
}

/// Stan edytora dozwolonych przejść statusów projektu.
final class TaskWorkflowSettingsCubit extends Cubit<TaskWorkflowSettingsState> {
  TaskWorkflowSettingsCubit({
    required this.repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const TaskWorkflowSettingsInitial());

  final TaskWorkflowRepository repository;
  final String workspaceId;
  final String projectId;

  Future<void> load() async {
    emit(const TaskWorkflowSettingsLoading());
    final result = await repository.getWorkflow(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(TaskWorkflowSettingsFailure(error.message)),
      (workflow) =>
          emit(TaskWorkflowSettingsReady(workflow: _sorted(workflow))),
    );
  }

  /// Włącza lub wyłącza pojedynczą, kierunkową krawędź workflow.
  Future<bool> toggleTransition({
    required ProjectTaskStatus from,
    required ProjectTaskStatus to,
    required bool allowed,
  }) async {
    final current = state;
    if (current is! TaskWorkflowSettingsReady ||
        current.isSaving ||
        from == to) {
      return false;
    }

    final transitions = current.workflow.transitions.toSet();
    final transition = ProjectTaskWorkflowTransitionResponse(
      fromStatus: from,
      toStatus: to,
    );
    if (allowed) {
      transitions.add(transition);
    } else {
      transitions.remove(transition);
    }

    emit(current.copyWith(isSaving: true, clearError: true));
    final result = await repository.updateWorkflow(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: UpdateProjectTaskWorkflowPayload(
        statuses: [
          for (final status in current.workflow.statuses)
            UpdateProjectTaskWorkflowStatusPayload(
              status: status.status,
              displayName: status.displayName,
              color: status.color,
              position: status.position,
              isInitial: status.isInitial,
              isTerminal: status.isTerminal,
              category: status.category,
            ),
        ],
        transitions: _sortedTransitions(transitions),
        expectedVersion: current.workflow.version,
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (workflow) {
        emit(TaskWorkflowSettingsReady(workflow: _sorted(workflow)));
        return true;
      },
    );
  }

  static ProjectTaskWorkflowResponse _sorted(
    ProjectTaskWorkflowResponse workflow,
  ) => workflow.copyWith(
    statuses: [...workflow.statuses]
      ..sort((left, right) => left.position.compareTo(right.position)),
    transitions: _sortedTransitions(workflow.transitions),
  );

  static List<ProjectTaskWorkflowTransitionResponse> _sortedTransitions(
    Iterable<ProjectTaskWorkflowTransitionResponse> transitions,
  ) => transitions.toSet().toList()
    ..sort((left, right) {
      final from = left.fromStatus.index.compareTo(right.fromStatus.index);
      return from == 0
          ? left.toStatus.index.compareTo(right.toStatus.index)
          : from;
    });
}
