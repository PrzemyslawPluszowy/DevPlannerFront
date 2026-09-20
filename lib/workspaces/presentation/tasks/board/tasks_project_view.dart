import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_project_view_preference_store.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/models/task_list_view_snapshot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Zarządza wyłącznie lokalnym wyborem widoku odzwierciedlonym w adresie.
class TasksProjectViewHost extends StatefulWidget {
  const TasksProjectViewHost({
    required this.workspaceId,
    required this.projectId,
    this.initialView,
    this.viewPreferenceStore,
    this.onProjectExited,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final String? initialView;

  /// Lokalna preferencja „ostatnio używany widok” dla tego projektu.
  ///
  /// Adres bez `?view=` znaczy „widok, w którym użytkownik pracował”, więc
  /// dopiero ten port rozstrzyga, czy moduł otworzy Listę, czy Kanban. Brak
  /// portu zachowuje zachowanie trasy (widok domyślny).
  final TasksProjectViewPreferenceStore? viewPreferenceStore;

  final VoidCallback? onProjectExited;

  @override
  State<TasksProjectViewHost> createState() => _TasksProjectViewHostState();
}

class _TasksProjectViewHostState extends State<TasksProjectViewHost> {
  late final ValueNotifier<_TasksProjectViewLocalState> _viewState;

  @override
  void initState() {
    super.initState();
    final view = _resolveView();
    _viewState = ValueNotifier(
      _TasksProjectViewLocalState(
        view: view,
        hasOpenedList: view == TasksProjectView.list,
        hasOpenedBoard: view == TasksProjectView.board,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant TasksProjectViewHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialView == widget.initialView) return;
    // Adres bez `?view=` znaczy „ostatnio używany widok tego projektu”, więc
    // rozstrzygnięcie jest deterministyczne: preferencja użytkownika, a gdy jej
    // brak — widok domyślny trasy. Dzięki temu `/tasks` nigdy nie dziedziczy
    // widoku z poprzedniego adresu.
    _selectView(_resolveView(), persist: widget.initialView != null);
  }

  TasksProjectView _resolveView() {
    final explicit = widget.initialView;
    if (explicit != null) return TasksProjectView.fromQuery(explicit);
    return _preferredView() ?? TasksProjectView.routeDefault;
  }

  TasksProjectView? _preferredView() {
    final token = widget.viewPreferenceStore?.viewFor(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
    );
    return token == null ? null : TasksProjectView.fromQuery(token);
  }

  /// Zapis idzie przez port, który sam raportuje awarię persistence i kończy
  /// bez wyjątku — preferencja widoku nie jest danymi ekranu.
  Future<void> _persistPreferredView(TasksProjectView view) async {
    final store = widget.viewPreferenceStore;
    if (store == null) return;
    await store.write(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      view: view.queryValue,
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
        // Błędy operacji widoku pokazuje trwały banner pod nagłówkiem
        // (`TasksErrorBannerHost`), więc widok nie dubluje ich w SnackBarze,
        // który ginął przy każdej przebudowie drzewa.
        builder: (context, localState, _) =>
            BlocBuilder<TasksBoardCubit, TasksBoardState>(
              builder: (context, state) => Scaffold(
                backgroundColor: Colors.transparent,
                body: ColoredBox(
                  color: context.tasksTheme.canvas,
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
                      hasOpenedBoard: localState.hasOpenedBoard,
                      settingsRevision: localState.settingsRevision,
                      currentSnapshot: localState.currentListSnapshot,
                      onSnapshotChanged: _changeSnapshot,
                      onSettingsClosed: _advanceSettingsRevision,
                      onProjectExited: widget.onProjectExited,
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

  /// Ustawia widok modułu, zachowując raz otwarty sąsiad (scroll i stan Listy
  /// albo Kanbanu nie giną po przełączeniu tam i z powrotem).
  void _selectView(TasksProjectView view, {bool persist = false}) {
    final current = _viewState.value;
    if (view != current.view) {
      _viewState.value = current.copyWith(
        view: view,
        hasOpenedList: current.hasOpenedList || view == TasksProjectView.list,
        hasOpenedBoard:
            current.hasOpenedBoard || view == TasksProjectView.board,
      );
    }
    if (persist) unawaited(_persistPreferredView(view));
  }

  void _changeView(TasksProjectView view) {
    _selectView(view, persist: true);
    final router = GoRouter.maybeOf(context);
    if (router == null) return;
    unawaited(
      DevPlannerNavigation(router).go(
        DevPlannerRouteCatalog.projectTasksView(
          widget.workspaceId,
          widget.projectId,
          view.queryValue,
        ),
      ),
    );
  }
}

class _TasksProjectViewLocalState {
  const _TasksProjectViewLocalState({
    required this.view,
    required this.hasOpenedList,
    required this.hasOpenedBoard,
    this.settingsRevision = 0,
    this.currentListSnapshot,
  });

  final TasksProjectView view;

  /// Lista i Kanban dzielą jedno drzewo widgetów, więc widok otwarty
  /// wcześniej pozostaje zamontowany razem ze swoim scrollen i stanem.
  final bool hasOpenedList;
  final bool hasOpenedBoard;

  final int settingsRevision;
  final TaskListViewSnapshot? currentListSnapshot;

  _TasksProjectViewLocalState copyWith({
    TasksProjectView? view,
    bool? hasOpenedList,
    bool? hasOpenedBoard,
    int? settingsRevision,
    TaskListViewSnapshot? currentListSnapshot,
  }) => _TasksProjectViewLocalState(
    view: view ?? this.view,
    hasOpenedList: hasOpenedList ?? this.hasOpenedList,
    hasOpenedBoard: hasOpenedBoard ?? this.hasOpenedBoard,
    settingsRevision: settingsRevision ?? this.settingsRevision,
    currentListSnapshot: currentListSnapshot ?? this.currentListSnapshot,
  );
}
