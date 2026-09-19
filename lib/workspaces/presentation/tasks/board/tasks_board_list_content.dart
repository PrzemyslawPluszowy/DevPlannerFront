import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
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
///
/// Aktywny zapisany widok i cubity Listy dostarcza właściciel chrome nagłówka,
/// żeby wiersz poleceń i tabela opisywały ten sam stan.
class TasksBoardListContent extends StatelessWidget {
  const TasksBoardListContent({
    required this.workspaceId,
    required this.projectId,
    required this.hasCustomWorkflow,
    required this.savedViewId,
    required this.groupBy,
    this.columns = defaultTaskListColumns,
    this.customFieldIds = const [],
    this.columnOrder,
    this.settingsRevision = 0,
    this.onViewSnapshotChanged,
    this.listCubit,
    this.preferencesCubit,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final bool hasCustomWorkflow;
  final String? savedViewId;
  final TaskSavedViewGroupBy groupBy;
  final List<TaskSavedViewColumn> columns;
  final List<String> customFieldIds;
  final List<String>? columnOrder;
  final int settingsRevision;
  final ValueChanged<TaskListViewSnapshot>? onViewSnapshotChanged;
  final ProjectTasksListCubit? listCubit;
  final TaskListPreferencesCubit? preferencesCubit;

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
    return ProjectTasksList(
      key: ValueKey((workspaceId, projectId, savedViewId, settingsRevision)),
      workspaceId: workspaceId,
      projectId: projectId,
      savedViewId: savedViewId,
      groupBy: groupBy,
      hasCustomWorkflow: hasCustomWorkflow,
      columns: columns,
      customFieldIds: customFieldIds,
      columnOrder: columnOrder,
      memberProfilesByUserId: memberProfiles,
      onViewSnapshotChanged: onViewSnapshotChanged,
      listCubit: listCubit,
      preferencesCubit: preferencesCubit,
    );
  }
}
