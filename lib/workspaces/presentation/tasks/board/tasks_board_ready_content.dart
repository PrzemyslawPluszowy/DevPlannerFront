import 'dart:async';

import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/tasks/task_project_realtime_adapter.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/kanban_assignee_column.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_content_host.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_list_content.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_saved_view_selection.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/project_recurrences_sheet.dart';
import 'package:devplanner/workspaces/presentation/tasks/tasks_project_view_contract.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/models/task_list_view_snapshot.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/task_saved_views_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wyświetla aktywny widok i zachowuje wcześniej odwiedzone Listę oraz Kanban.
class TasksBoardReadyContent extends StatelessWidget {
  const TasksBoardReadyContent({
    required this.header,
    required this.workspaceId,
    required this.projectId,
    required this.state,
    required this.view,
    required this.hasOpenedList,
    required this.hasOpenedBoard,
    required this.savedView,
    required this.settingsRevision,
    required this.onSnapshotChanged,
    required this.emptyStateBuilder,
    required this.cardBuilder,
    required this.quickCreateBuilder,
    required this.timelineView,
    required this.workloadView,
    required this.listCubit,
    required this.preferencesCubit,
    required this.errorBanner,
    super.key,
  });

  final Widget header;
  final String workspaceId;
  final String projectId;
  final TasksBoardReady state;
  final TasksProjectView view;
  final bool hasOpenedList;
  final bool hasOpenedBoard;
  final TaskSavedViewSelection savedView;
  final int settingsRevision;
  final ValueChanged<TaskListViewSnapshot>? onSnapshotChanged;
  final WidgetBuilder emptyStateBuilder;
  final KanbanAssigneeCardBuilder cardBuilder;
  final KanbanAssigneeQuickCreateBuilder quickCreateBuilder;
  final Widget timelineView;
  final Widget workloadView;
  final ProjectTasksListCubit? listCubit;
  final TaskListPreferencesCubit? preferencesCubit;
  final Widget errorBanner;

  @override
  Widget build(BuildContext context) {
    final showBoard = hasOpenedBoard || view == TasksProjectView.board;
    final showList = hasOpenedList || view == TasksProjectView.list;
    final recurrenceRepository = context.read<TaskRecurrenceRepository>();
    final realtimeFactory = context.read<WorkspaceScopedRealtimeFactory?>();
    final content = Column(
      children: [
        header,
        errorBanner,
        Expanded(
          child: view == TasksProjectView.timeline
              ? timelineView
              : view == TasksProjectView.workload
              ? workloadView
              : view == TasksProjectView.recurrence
              ? _ProjectRecurrencesContent(
                  key: _ProjectRecurrencesScopeKey(
                    workspaceId: workspaceId,
                    projectId: projectId,
                    repository: recurrenceRepository,
                    realtimeFactory: realtimeFactory,
                  ),
                  workspaceId: workspaceId,
                  projectId: projectId,
                  repository: recurrenceRepository,
                  realtimeFactory: realtimeFactory,
                )
              : IndexedStack(
                  index: view == TasksProjectView.board ? 0 : 1,
                  children: [
                    if (showBoard)
                      TasksBoardContentHost(
                        workspaceId: workspaceId,
                        projectId: projectId,
                        state: state,
                        emptyStateBuilder: emptyStateBuilder,
                        cardBuilder: cardBuilder,
                        quickCreateBuilder: quickCreateBuilder,
                      )
                    else
                      const SizedBox.shrink(),
                    if (showList)
                      TasksBoardListContent(
                        workspaceId: workspaceId,
                        projectId: projectId,
                        settingsRevision: settingsRevision,
                        hasCustomWorkflow: state.board.columns.any(
                          (column) => column.customStatusId != null,
                        ),
                        savedViewId: savedView.savedViewId,
                        groupBy: savedView.groupBy,
                        columns: savedView.columns,
                        customFieldIds: savedView.customFieldIds,
                        columnOrder: savedView.columnOrder,
                        onViewSnapshotChanged: onSnapshotChanged,
                        listCubit: listCubit,
                        preferencesCubit: preferencesCubit,
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
        ),
      ],
    );
    final padded = Padding(
      padding: const EdgeInsets.only(left: 2),
      child: content,
    );
    return view == TasksProjectView.board
        ? TasksBoardKeyboardShortcuts(child: padded)
        : padded;
  }
}

/// Tworzy Cubit cyklicznych dla aktualnego projektu i jego portów.
class _ProjectRecurrencesContent extends StatelessWidget {
  const _ProjectRecurrencesContent({
    required this.workspaceId,
    required this.projectId,
    required this.repository,
    required this.realtimeFactory,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final TaskRecurrenceRepository repository;
  final WorkspaceScopedRealtimeFactory? realtimeFactory;

  @override
  Widget build(BuildContext context) {
    final factory = realtimeFactory;
    return BlocProvider(
      create: (context) {
        final cubit = ProjectRecurrencesCubit(
          repository: repository,
          workspaceId: workspaceId,
          projectId: projectId,
          realtime: factory == null
              ? null
              : TaskProjectRealtimeAdapter.fromFactory(factory),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: ProjectRecurrencesSheet(
        workspaceId: workspaceId,
        projectId: projectId,
      ),
    );
  }
}

/// Klucz usuwa Cubita cyklicznych po zmianie projektu albo portu danych.
/// Rozpoznaje zmianę projektu lub repozytorium cyklicznych.
class _ProjectRecurrencesScopeKey extends LocalKey {
  const _ProjectRecurrencesScopeKey({
    required this.workspaceId,
    required this.projectId,
    required this.repository,
    required this.realtimeFactory,
  });

  final String workspaceId;
  final String projectId;
  final TaskRecurrenceRepository repository;
  final WorkspaceScopedRealtimeFactory? realtimeFactory;

  @override
  bool operator ==(Object other) =>
      other is _ProjectRecurrencesScopeKey &&
      workspaceId == other.workspaceId &&
      projectId == other.projectId &&
      identical(repository, other.repository) &&
      identical(realtimeFactory, other.realtimeFactory);

  @override
  int get hashCode => Object.hash(
    workspaceId,
    projectId,
    identityHashCode(repository),
    identityHashCode(realtimeFactory),
  );
}
