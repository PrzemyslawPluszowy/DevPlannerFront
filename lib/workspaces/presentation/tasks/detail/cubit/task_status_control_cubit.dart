import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class TaskStatusCatalogState {
  const TaskStatusCatalogState({
    required this.isLoading,
    required this.statuses,
    this.error,
  });

  const TaskStatusCatalogState.loading()
    : isLoading = true,
      statuses = const [],
      error = null;

  final bool isLoading;
  final List<ProjectCustomStatusResponse> statuses;
  final ApiError? error;
}

/// Owns the project catalog request and rejects responses from replaced scopes.
final class TaskStatusControlCubit extends Cubit<TaskStatusCatalogState> {
  factory TaskStatusControlCubit({
    required TaskDetailsCubit source,
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) => TaskStatusControlCubit._(source, workspaceId, projectId, taskId);

  TaskStatusControlCubit._(
    this._source,
    this._workspaceId,
    this._projectId,
    this._taskId,
  ) : super(const TaskStatusCatalogState.loading()) {
    unawaited(reload());
  }

  TaskDetailsCubit _source;
  String _workspaceId;
  String _projectId;
  String _taskId;
  int _generation = 0;

  void replaceScope({
    required TaskDetailsCubit source,
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) {
    final changed =
        !identical(source, _source) ||
        workspaceId != _workspaceId ||
        projectId != _projectId ||
        taskId != _taskId;
    if (!changed) return;
    _source = source;
    _workspaceId = workspaceId;
    _projectId = projectId;
    _taskId = taskId;
    unawaited(reload());
  }

  void retry() => unawaited(reload());

  Future<void> reload() async {
    if (isClosed) return;
    final generation = ++_generation;
    final source = _source;
    final projectId = _projectId;
    emit(const TaskStatusCatalogState.loading());
    final result = await source.loadCustomStatuses();
    if (isClosed ||
        generation != _generation ||
        !identical(source, _source) ||
        projectId != _projectId) {
      return;
    }
    result.fold(
      (error) => emit(
        TaskStatusCatalogState(
          isLoading: false,
          statuses: const [],
          error: error,
        ),
      ),
      (statuses) {
        final sorted = List<ProjectCustomStatusResponse>.of(statuses)
          ..sort((a, b) => a.position.compareTo(b.position));
        emit(
          TaskStatusCatalogState(
            isLoading: false,
            statuses: List.unmodifiable(sorted),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _generation++;
    return super.close();
  }
}

abstract final class TaskWorkflowStatusOptions {
  static List<ProjectTaskStatus> allowedFor(
    ProjectTaskDetailsResponse details,
  ) {
    final current = details.task.status;
    final allowed = <ProjectTaskStatus>{
      if (details.workflow.transitions.isEmpty) ...ProjectTaskStatus.values,
      current,
      for (final transition in details.workflow.transitions)
        if (transition.fromStatus == current) transition.toStatus,
    };
    final configured = details.workflow.statuses
        .where((item) => allowed.contains(item.status))
        .map((item) => item.status)
        .toList(growable: false);
    if (configured.isNotEmpty) return configured;
    return ProjectTaskStatus.values
        .where(allowed.contains)
        .toList(
          growable: false,
        );
  }
}
