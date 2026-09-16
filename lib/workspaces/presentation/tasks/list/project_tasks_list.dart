import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/tasks_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/filters/task_list_filters.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/task_list_table.dart';
import 'package:ready_next/workspaces/presentation/tasks/views/task_saved_views_export.dart';
import 'package:ready_next/workspaces/presentation/tasks/widgets/task_list_workflow_segmented_switch.dart';

/// Główny orkiestrator widoku listy zadań projektu.
///
/// Inicjalizuje [ProjectTasksListCubit] oraz [TaskListPreferencesCubit], łączy
/// je z globalnym stanem widoku, zdarzeniami realtime i konfiguracją kolumn
/// oraz deleguje renderowanie do [TaskListTable].
class ProjectTasksList extends StatefulWidget {
  const ProjectTasksList({
    required this.workspaceId,
    required this.projectId,
    this.savedViewId,
    this.groupBy = TaskSavedViewGroupBy.none,
    this.hasCustomWorkflow = false,
    this.columns = defaultTaskListColumns,
    this.customFieldIds = const [],
    this.columnOrder,
    this.memberProfilesByCoreUserId = const {},
    this.onViewSnapshotChanged,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final String? savedViewId;
  final TaskSavedViewGroupBy groupBy;
  final bool hasCustomWorkflow;
  final List<TaskSavedViewColumn> columns;
  final List<String> customFieldIds;
  final List<String>? columnOrder;
  final Map<String, ProjectMemberProfile> memberProfilesByCoreUserId;
  final ValueChanged<TaskListViewSnapshot>? onViewSnapshotChanged;

  @override
  State<ProjectTasksList> createState() => _ProjectTasksListState();
}

class _ProjectTasksListState extends State<ProjectTasksList> {
  late final ProjectTasksListCubit _cubit;
  late final TaskListPreferencesCubit _preferencesCubit;
  TaskListPreferencesReady? _lastAppliedPreferences;

  @override
  void initState() {
    super.initState();
    _cubit = ProjectTasksListCubit(
      repository: context.read<TasksRepository>(),
      metadataRepository: context.read<TaskMetadataRepository>(),
      collaborationRepository: context.read<TaskCollaborationRepository>(),
      recurrenceRepository: context.read<TaskRecurrenceRepository>(),
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      savedViewId: widget.savedViewId,
      groupBy: widget.groupBy,
    );
    _preferencesCubit = TaskListPreferencesCubit(
      repository: context.read<TaskListConfigurationRepository>(),
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
    );
    unawaited(_cubit.load());
    unawaited(_preferencesCubit.load());
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    unawaited(_preferencesCubit.close());
    super.dispose();
  }

  void _notifySnapshotIfNeeded() {
    final callback = widget.onViewSnapshotChanged;
    if (callback == null) return;

    final listState = _cubit.state;
    final prefState = _preferencesCubit.state;
    if (listState is! ProjectTasksListReady ||
        prefState is! TaskListPreferencesReady) {
      return;
    }

    final systemColumns = <TaskSavedViewColumn>[];
    final customFieldIds = <String>[];
    final columnOrder = <String>[];

    for (final col in prefState.effectiveVisibleColumns) {
      columnOrder.add(col.id);
      if (col.isSystem && col is SystemColumnReference) {
        systemColumns.add(col.column);
      } else if (col.isCustomField && col is CustomFieldColumnReference) {
        customFieldIds.add(col.fieldId);
      }
    }

    final snapshot = TaskListViewSnapshot(
      filter: TaskSavedViewFilter(
        statuses: listState.status != null ? [listState.status!] : null,
        priorities: listState.priority != null ? [listState.priority!] : null,
        assigneeCoreUserIds: listState.assigneeCoreUserId != null
            ? [listState.assigneeCoreUserId!]
            : null,
        myInvolvement: listState.myInvolvement,
        pinnedOnly: listState.pinnedOnly,
      ),
      sortField: prefState.sortField,
      sortDirection: prefState.sortDirection,
      groupBy: prefState.groupBy,
      columns: systemColumns,
      customFieldIds: customFieldIds,
      columnOrder: columnOrder,
    );

    callback(snapshot);
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider.value(value: _cubit),
      BlocProvider.value(value: _preferencesCubit),
    ],
    child: MultiBlocListener(
      listeners: [
        BlocListener<ProjectTasksListCubit, ProjectTasksListState>(
          listener: (context, listState) {
            if (!mounted) return;
            _notifySnapshotIfNeeded();
          },
        ),
        BlocListener<TasksBoardCubit, TasksBoardState>(
          listenWhen: (previous, current) =>
              (previous is! TasksBoardReady && current is TasksBoardReady) ||
              (previous is TasksBoardReady &&
                  current is TasksBoardReady &&
                  (previous.realtimeRevision != current.realtimeRevision ||
                      previous.mutationSerial != current.mutationSerial)),
          listener: (context, boardState) {
            if (!mounted) return;
            unawaited(
              boardState is TasksBoardReady &&
                      boardState.latestRealtimeMutation != null
                  ? _cubit.applyRealtimeMutation(
                      boardState.latestRealtimeMutation!,
                    )
                  : _cubit.load(),
            );
          },
        ),
        BlocListener<TaskListPreferencesCubit, TaskListPreferencesState>(
          listenWhen: (previous, current) =>
              current is TaskListPreferencesReady,
          listener: (context, prefState) {
            if (!mounted || prefState is! TaskListPreferencesReady) return;
            _notifySnapshotIfNeeded();
            final previous = _lastAppliedPreferences;
            _lastAppliedPreferences = prefState;
            final shouldReload =
                previous is! TaskListPreferencesReady ||
                previous.groupBy != prefState.groupBy ||
                previous.sortField != prefState.sortField ||
                previous.sortDirection != prefState.sortDirection;

            if (shouldReload) {
              if (_cubit.groupBy != prefState.groupBy) {
                unawaited(_cubit.updateGroupBy(prefState.groupBy));
              } else {
                unawaited(_cubit.load());
              }
            }
          },
        ),
      ],
      child: _ProjectTasksListView(
        groupBy: widget.groupBy,
        columns: widget.columns,
        customFieldIds: widget.customFieldIds,
        columnOrder: widget.columnOrder,
        memberProfilesByCoreUserId: widget.memberProfilesByCoreUserId,
        hasCustomWorkflow: widget.hasCustomWorkflow,
        savedViewId: widget.savedViewId,
      ),
    ),
  );
}

class _ProjectTasksListView extends StatelessWidget {
  const _ProjectTasksListView({
    required this.groupBy,
    required this.columns,
    this.customFieldIds,
    this.columnOrder,
    required this.memberProfilesByCoreUserId,
    this.hasCustomWorkflow = false,
    this.savedViewId,
  });

  final TaskSavedViewGroupBy groupBy;
  final List<TaskSavedViewColumn> columns;
  final List<String>? customFieldIds;
  final List<String>? columnOrder;
  final Map<String, ProjectMemberProfile> memberProfilesByCoreUserId;
  final bool hasCustomWorkflow;
  final String? savedViewId;

  @override
  Widget build(BuildContext context) {
    final preferencesCubit = context.watch<TaskListPreferencesCubit>();
    final preferencesState = preferencesCubit.state;
    final prefReady = preferencesState is TaskListPreferencesReady
        ? preferencesState
        : null;

    final effectiveRefs =
        prefReady?.effectiveVisibleColumns ??
        (columnOrder != null && columnOrder!.isNotEmpty
            ? columnOrder!.map(TaskColumnReference.fromId).toList()
            : null);

    final effectiveGroupBy = prefReady?.groupBy ?? groupBy;
    final showWorkflowSwitch = hasCustomWorkflow && savedViewId == null;

    final table = BlocBuilder<ProjectTasksListCubit, ProjectTasksListState>(
      builder: (context, state) => switch (state) {
        ProjectTasksListLoading() => const Center(
          child: CircularProgressIndicator(),
        ),
        ProjectTasksListFailure(:final message) => TaskListFailureView(
          message: message,
        ),
        ProjectTasksListReady() => TaskListTable(
          state: state,
          groupBy: effectiveGroupBy,
          columns: columns,
          columnReferences: effectiveRefs,
          customFieldIds: customFieldIds,
          memberProfilesByCoreUserId: memberProfilesByCoreUserId,
          preferencesCubit: preferencesCubit,
        ),
      },
    );

    if (!showWorkflowSwitch) return table;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const .fromLTRB(16, 8, 16, 4),
          child: TaskListWorkflowSegmentedSwitch(
            selected: effectiveGroupBy,
            onChanged: (selected) {
              unawaited(preferencesCubit.setGroupBy(selected));
              unawaited(
                context.read<ProjectTasksListCubit>().updateGroupBy(selected),
              );
            },
          ),
        ),
        Expanded(child: table),
      ],
    );
  }
}
