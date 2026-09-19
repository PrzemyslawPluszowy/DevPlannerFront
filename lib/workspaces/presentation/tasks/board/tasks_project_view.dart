import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_project_view_preferences.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/models/task_list_view_snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Dostępne widoki zadań jednego projektu.
enum TasksProjectView { board, list, timeline, workload, recurrence }

/// Zarządza wyłącznie lokalnym wyborem widoku oraz jego zapamiętaniem.
class TasksProjectViewHost extends StatefulWidget {
  const TasksProjectViewHost({
    required this.workspaceId,
    required this.projectId,
    this.initialView,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final String? initialView;

  @override
  State<TasksProjectViewHost> createState() => _TasksProjectViewHostState();
}

class _TasksProjectViewHostState extends State<TasksProjectViewHost> {
  late final ValueNotifier<_TasksProjectViewLocalState> _viewState;
  final TasksProjectViewPreferences _viewPreferences =
      TasksProjectViewPreferences();

  @override
  void initState() {
    super.initState();
    final view = _viewFromQuery(widget.initialView);
    _viewState = ValueNotifier(
      _TasksProjectViewLocalState(
        view: view,
        hasOpenedList: view == TasksProjectView.list,
      ),
    );
    if (widget.initialView == null) {
      unawaited(_restorePreferredView());
    }
  }

  @override
  void didUpdateWidget(covariant TasksProjectViewHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialView == widget.initialView) return;
    final nextView = _viewFromQuery(widget.initialView);
    final current = _viewState.value;
    if (nextView == current.view) return;
    _viewState.value = current.copyWith(
      view: nextView,
      hasOpenedList: current.hasOpenedList || nextView == TasksProjectView.list,
    );
  }

  @override
  void dispose() {
    _viewState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<_TasksProjectViewLocalState>(
        valueListenable: _viewState,
        builder: (context, localState, _) =>
            BlocConsumer<TasksBoardCubit, TasksBoardState>(
              listenWhen: (previous, current) =>
                  previous is TasksBoardReady &&
                  current is TasksBoardReady &&
                  previous.mutationSerial != current.mutationSerial,
              listener: (context, state) {
                if (state case TasksBoardReady(:final mutationError?)) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(content: Text(mutationError)));
                }
              },
              builder: (context, state) => Scaffold(
                backgroundColor: Colors.transparent,
                body: ColoredBox(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF11131C)
                      : const Color(0xFFF6F7FB),
                  child: switch (state) {
                    TasksBoardInitial() ||
                    TasksBoardLoading() => const TasksBoardSkeleton(),
                    TasksBoardFailure(
                      :final message,
                      :final kind,
                      :final backendCode,
                    ) =>
                      TasksBoardFailureView(
                        message: backendCode == null
                            ? message
                            : '$message ($backendCode)',
                        kind: kind,
                      ),
                    TasksBoardReady() => TasksBoardReadyView(
                      workspaceId: widget.workspaceId,
                      projectId: widget.projectId,
                      state: state,
                      view: localState.view,
                      hasOpenedList: localState.hasOpenedList,
                      settingsRevision: localState.settingsRevision,
                      currentSnapshot: localState.currentListSnapshot,
                      onSnapshotChanged: _changeSnapshot,
                      onSettingsClosed: _advanceSettingsRevision,
                      onViewChanged: _changeView,
                    ),
                  },
                ),
              ),
            ),
      );

  void _changeSnapshot(TaskListViewSnapshot snapshot) {
    final current = _viewState.value;
    if (current.currentListSnapshot == snapshot) return;
    _viewState.value = current.copyWith(currentListSnapshot: snapshot);
  }

  void _advanceSettingsRevision() {
    final current = _viewState.value;
    _viewState.value = current.copyWith(
      settingsRevision: current.settingsRevision + 1,
    );
  }

  void _changeView(TasksProjectView view) {
    final current = _viewState.value;
    _viewState.value = current.copyWith(
      view: view,
      hasOpenedList: current.hasOpenedList || view == TasksProjectView.list,
    );
    unawaited(
      _viewPreferences.write(
        workspaceId: widget.workspaceId,
        projectId: widget.projectId,
        view: _viewUrlValue(view),
      ),
    );
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      unawaited(
        DevPlannerNavigation(router).go(
          '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/tasks?view=${_viewUrlValue(view)}',
        ),
      );
    }
  }

  Future<void> _restorePreferredView() async {
    final preferredValue = await _viewPreferences.read(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
    );
    if (!mounted || preferredValue == null) return;
    final preferred = _viewFromQuery(preferredValue);
    final current = _viewState.value;
    _viewState.value = current.copyWith(
      view: preferred,
      hasOpenedList:
          current.hasOpenedList || preferred == TasksProjectView.list,
    );
  }

  TasksProjectView _viewFromQuery(String? value) => switch (value) {
    'list' => TasksProjectView.list,
    'timeline' => TasksProjectView.timeline,
    'workload' => TasksProjectView.workload,
    'recurrence' => TasksProjectView.recurrence,
    _ => TasksProjectView.board,
  };

  String _viewUrlValue(TasksProjectView view) => switch (view) {
    TasksProjectView.board => 'board',
    TasksProjectView.list => 'list',
    TasksProjectView.timeline => 'timeline',
    TasksProjectView.workload => 'workload',
    TasksProjectView.recurrence => 'recurrence',
  };
}

class _TasksProjectViewLocalState {
  const _TasksProjectViewLocalState({
    required this.view,
    required this.hasOpenedList,
    this.settingsRevision = 0,
    this.currentListSnapshot,
  });

  final TasksProjectView view;
  final bool hasOpenedList;
  final int settingsRevision;
  final TaskListViewSnapshot? currentListSnapshot;

  _TasksProjectViewLocalState copyWith({
    TasksProjectView? view,
    bool? hasOpenedList,
    int? settingsRevision,
    TaskListViewSnapshot? currentListSnapshot,
  }) => _TasksProjectViewLocalState(
    view: view ?? this.view,
    hasOpenedList: hasOpenedList ?? this.hasOpenedList,
    settingsRevision: settingsRevision ?? this.settingsRevision,
    currentListSnapshot: currentListSnapshot ?? this.currentListSnapshot,
  );
}
