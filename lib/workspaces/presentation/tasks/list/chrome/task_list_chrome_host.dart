import 'dart:async';

import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/bulk/task_list_bulk_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_list_command_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Chrome Listy przekazany do wspólnego nagłówka.
final class TaskListChrome {
  const TaskListChrome({
    required this.commandBar,
    required this.bulkBar,
    required this.showBulkBar,
    this.listCubit,
    this.preferencesCubit,
  });

  /// Wiersz poleceń Listy: filtry, sortowanie, grupowanie i kolumny.
  final Widget commandBar;

  /// Kontekstowy pasek akcji masowych Listy.
  final Widget bulkBar;

  /// Czy Lista ma zaznaczone zadania.
  final bool showBulkBar;

  /// Cubity Listy, gdy chrome jest aktywne; `null` dla innych widoków.
  final ProjectTasksListCubit? listCubit;
  final TaskListPreferencesCubit? preferencesCubit;
}

/// Właściciel stanu Listy, który oddaje wiersz poleceń i pasek akcji nagłówkowi.
///
/// Dzięki temu nagłówek renderuje kontrolki Listy w swoim drugim wierszu, a nie
/// wewnątrz przewijanej treści, i nie ma dwóch pasków akcji masowych.
class TaskListChromeHost extends StatefulWidget {
  const TaskListChromeHost({
    required this.workspaceId,
    required this.projectId,
    required this.savedViewId,
    required this.groupBy,
    required this.memberProfilesByUserId,
    required this.builder,
    this.hasCustomWorkflow = false,
    this.columns = defaultTaskListColumns,
    this.customFieldIds = const [],
    this.columnOrder,
    this.listenToBoardRealtime = true,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final String? savedViewId;
  final TaskSavedViewGroupBy groupBy;
  final Map<String, ProjectMemberProfile> memberProfilesByUserId;
  final bool hasCustomWorkflow;
  final List<TaskSavedViewColumn> columns;
  final List<String> customFieldIds;
  final List<String>? columnOrder;
  final bool listenToBoardRealtime;

  /// Buduje drzewo z gotowym chrome Listy.
  final Widget Function(BuildContext context, TaskListChrome chrome) builder;

  @override
  State<TaskListChromeHost> createState() => _TaskListChromeHostState();
}

class _TaskListChromeHostState extends State<TaskListChromeHost> {
  late final ProjectTasksListCubit _cubit;
  late final TaskListPreferencesCubit _preferencesCubit;

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
  void didUpdateWidget(covariant TaskListChromeHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Zmiana zapisanego widoku przebudowuje host przez `key`, więc cubit nie
    // potrzebuje osobnej ścieżki aktualizacji widoku.
    if (oldWidget.groupBy != widget.groupBy) {
      unawaited(_cubit.updateGroupBy(widget.groupBy));
    }
  }

  @override
  void dispose() {
    unawaited(_cubit.close());
    unawaited(_preferencesCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Lista działa także bez boardu (np. samodzielny host lub testy), więc
    // realtime boardu podłączamy tylko wtedy, gdy cubit jest dostępny.
    final boardCubit = widget.listenToBoardRealtime
        ? context.read<TasksBoardCubit?>()
        : null;
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cubit),
        BlocProvider.value(value: _preferencesCubit),
      ],
      child: boardCubit == null
          ? _buildChrome(context)
          : BlocListener<TasksBoardCubit, TasksBoardState>(
              listenWhen: (previous, current) =>
                  (previous is! TasksBoardReady &&
                      current is TasksBoardReady) ||
                  (previous is TasksBoardReady &&
                      current is TasksBoardReady &&
                      (previous.realtimeRevision != current.realtimeRevision ||
                          previous.taskDataRevision !=
                              current.taskDataRevision)),
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
              child: _buildChrome(context),
            ),
    );
  }

  Widget _buildChrome(BuildContext context) =>
      BlocBuilder<ProjectTasksListCubit, ProjectTasksListState>(
        builder: (context, listState) =>
            BlocBuilder<TaskListPreferencesCubit, TaskListPreferencesState>(
              builder: (context, preferencesState) => widget.builder(
                context,
                TaskListChrome(
                  listCubit: _cubit,
                  preferencesCubit: _preferencesCubit,
                  showBulkBar: switch (listState) {
                    ProjectTasksListReady(:final selectedTaskIds) =>
                      selectedTaskIds.isNotEmpty,
                    _ => false,
                  },
                  commandBar: TaskListCommandBar(
                    listState: listState,
                    preferencesState: preferencesState,
                    memberProfiles: widget.memberProfilesByUserId,
                    hasCustomWorkflow: widget.hasCustomWorkflow,
                  ),
                  bulkBar: TaskListBulkBar(
                    listCubit: _cubit,
                    listState: listState,
                    preferencesState: preferencesState,
                    memberProfiles: widget.memberProfilesByUserId,
                  ),
                ),
              ),
            ),
      );
}
