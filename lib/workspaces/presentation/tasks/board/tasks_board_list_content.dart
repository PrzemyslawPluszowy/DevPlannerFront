import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/project_tasks_list.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/task_saved_views_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Izoluje tabelę listy od snapshotów Kanbana.
///
/// Realtime musi odświeżyć Kanban po zmianie strukturalnej, ale w widoku List
/// nie może to przebudowywać tysięcy wierszy. Lista reaguje wyłącznie na własny
/// Cubit oraz profile członków wykorzystywane w komórkach Owner.
class TasksBoardListContent extends StatelessWidget {
  const TasksBoardListContent({
    required this.workspaceId,
    required this.projectId,
    required this.hasCustomWorkflow,
    this.settingsRevision = 0,
    this.onViewSnapshotChanged,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final bool hasCustomWorkflow;
  final int settingsRevision;
  final ValueChanged<TaskListViewSnapshot>? onViewSnapshotChanged;

  @override
  Widget build(BuildContext context) {
    final memberProfiles = context
        .select<TasksBoardCubit, Map<String, ProjectMemberProfile>>(
          (cubit) => switch (cubit.state) {
            TasksBoardReady(:final memberProfilesByUserId) =>
              memberProfilesByUserId,
            _ => const <String, ProjectMemberProfile>{},
          },
        );
    return BlocBuilder<TaskSavedViewsCubit, TaskSavedViewsState>(
      builder: (context, savedViewsState) {
        final savedViewId = savedViewsState is TaskSavedViewsReady
            ? savedViewsState.activeViewId
            : null;
        final savedView = savedViewsState is TaskSavedViewsReady
            ? savedViewsState.views
                  .where((item) => item.id == savedViewId)
                  .firstOrNull
            : null;
        final defaultGroupBy = hasCustomWorkflow
            ? TaskSavedViewGroupBy.customStatus
            : TaskSavedViewGroupBy.status;
        return ProjectTasksList(
          key: ValueKey((
            workspaceId,
            projectId,
            savedViewId,
            settingsRevision,
          )),
          workspaceId: workspaceId,
          projectId: projectId,
          savedViewId: savedViewId,
          groupBy: savedView?.view.groupBy ?? defaultGroupBy,
          hasCustomWorkflow: hasCustomWorkflow,
          columns: savedView?.view.columns ?? defaultTaskListColumns,
          customFieldIds: savedView?.view.customFieldIds ?? const [],
          columnOrder: savedView?.view.columnOrder,
          memberProfilesByUserId: memberProfiles,
          onViewSnapshotChanged: onViewSnapshotChanged,
        );
      },
    );
  }
}
