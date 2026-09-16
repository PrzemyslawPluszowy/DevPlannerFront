import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/app/shell/overlay/app_modal_picker_host.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:ready_next/shared/presentation/widgets/app_expandable_side_sheet.dart';
import 'package:ready_next/workspaces/data/kanban/models/kanban_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_capacity_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:ready_next/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:ready_next/workspaces/data/realtime/tasks/task_project_realtime_adapter.dart';
import 'package:ready_next/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_status_category.dart';
import 'package:ready_next/workspaces/domain/models/project_list_item.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:ready_next/workspaces/domain/repositories/kanban_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_capacity_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_template_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_view_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/tasks_repository.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_projects_state.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/project_settings_modal.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/user_hub/project_user_hub_modal.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_state.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/viewport/kanban_auto_scroll_coordinator.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/project_tasks_list.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/project_tasks_list_rows.dart';
import 'package:ready_next/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/recurrence/project_recurrences_sheet.dart';
import 'package:ready_next/workspaces/presentation/tasks/timeline/cubit/task_timeline_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/views/task_saved_views_export.dart';
import 'package:ready_next/workspaces/presentation/tasks/workload/cubit/task_workload_cubit.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tasks_board_card_content.dart';
part 'tasks_board_card_menu.dart';
part 'tasks_board_card_subtasks.dart';
part 'tasks_board_cards.dart';
part 'tasks_board_collapsed_column.dart';
part 'tasks_board_columns.dart';
part 'tasks_board_header.dart';
part 'tasks_board_quick_create.dart';
part 'tasks_board_saved_views.dart';
part 'tasks_board_states.dart';
part 'tasks_board_template_picker.dart';
part 'tasks_board_template_picker_actions.dart';
part 'tasks_board_timeline.dart';
part 'tasks_board_view_preferences.dart';
part 'tasks_board_view_switcher.dart';
part 'tasks_board_workload.dart';
part 'widgets/project_member_facepile.dart';

/// Produkcyjny widok tablicy Tasks projektu.
class TasksBoardPage extends StatelessWidget {
  const TasksBoardPage({
    required this.workspaceId,
    required this.projectId,
    this.initialView,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final String? initialView;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) {
          final cubit = TasksBoardCubit(
            context.read<KanbanRepository>(),
            TaskProjectRealtimeAdapter.fromFactory(
              context.read<WorkspaceScopedRealtimeFactory>(),
            ),
            context.read<TasksRepository>(),
            workflowRepository: context.read<TaskWorkflowRepository>(),
            collaborationRepository: context
                .read<TaskCollaborationRepository>(),
            taskTemplateRepository: context.read<TaskTemplateRepository>(),
            memberProfilesRepository: context
                .read<ProjectMemberProfilesRepository>(),
            workspaceId: workspaceId,
            projectId: projectId,
          );
          unawaited(cubit.start());
          return cubit;
        },
      ),
      BlocProvider(
        create: (context) {
          final cubit = TaskSavedViewMetadataCubit(
            repository: context.read<TaskMetadataRepository>(),
            workspaceId: workspaceId,
            projectId: projectId,
          );
          unawaited(cubit.load());
          return cubit;
        },
      ),
      BlocProvider(
        create: (context) {
          final cubit = TaskSavedViewsCubit(
            repository: context.read<TaskViewRepository>(),
            preferencesRepository: context
                .read<TaskListConfigurationRepository>(),
            workspaceId: workspaceId,
            projectId: projectId,
          );
          unawaited(cubit.load());
          return cubit;
        },
      ),
      BlocProvider(
        create: (context) {
          final cubit = TaskTemplatePickerCubit(
            repository: context.read<TaskTemplateRepository>(),
            workspaceId: workspaceId,
          );
          unawaited(cubit.load());
          return cubit;
        },
      ),
    ],
    child: _TasksBoardView(
      workspaceId: workspaceId,
      projectId: projectId,
      initialView: initialView,
    ),
  );
}

/// Dostępne widoki w module zadań projektu.
enum TasksProjectView { board, list, timeline, workload, recurrence }

typedef _TasksProjectView = TasksProjectView;

class _TasksBoardView extends StatefulWidget {
  const _TasksBoardView({
    required this.workspaceId,
    required this.projectId,
    this.initialView,
  });

  final String workspaceId;
  final String projectId;
  final String? initialView;

  @override
  State<_TasksBoardView> createState() => _TasksBoardViewState();
}

class _TasksBoardViewState extends State<_TasksBoardView> {
  late _TasksProjectView _view;
  bool _hasOpenedList = false;
  int _settingsRevision = 0;
  TaskListViewSnapshot? _currentListSnapshot;
  final _viewPreferences = _TasksProjectViewPreferences();

  @override
  void initState() {
    super.initState();
    _view = _viewFromQuery(widget.initialView);
    _hasOpenedList = _view == _TasksProjectView.list;
    if (widget.initialView == null) {
      unawaited(_restorePreferredView());
    }
  }

  @override
  void didUpdateWidget(covariant _TasksBoardView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialView == widget.initialView) return;
    final nextView = _viewFromQuery(widget.initialView);
    if (nextView == _view) return;
    _view = nextView;
    _hasOpenedList = _hasOpenedList || nextView == _TasksProjectView.list;
  }

  _TasksProjectView _viewFromQuery(String? value) => switch (value) {
    'list' => _TasksProjectView.list,
    'timeline' => _TasksProjectView.timeline,
    'workload' => _TasksProjectView.workload,
    'recurrence' => _TasksProjectView.recurrence,
    _ => _TasksProjectView.board,
  };

  Future<void> _restorePreferredView() async {
    final preferred = await _viewPreferences.read(
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
    );
    if (!mounted || preferred == null) return;
    setState(() {
      _view = preferred;
      _hasOpenedList = _hasOpenedList || preferred == _TasksProjectView.list;
    });
  }

  void _changeView(_TasksProjectView view) {
    setState(() {
      _view = view;
      _hasOpenedList = _hasOpenedList || view == _TasksProjectView.list;
    });
    unawaited(
      _viewPreferences.write(
        workspaceId: widget.workspaceId,
        projectId: widget.projectId,
        view: view,
      ),
    );
    context.go(
      '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/tasks?view=${_viewUrlValue(view)}',
    );
  }

  String _viewUrlValue(_TasksProjectView view) => switch (view) {
    _TasksProjectView.board => 'board',
    _TasksProjectView.list => 'list',
    _TasksProjectView.timeline => 'timeline',
    _TasksProjectView.workload => 'workload',
    _TasksProjectView.recurrence => 'recurrence',
  };

  @override
  Widget build(
    BuildContext context,
  ) => BlocConsumer<TasksBoardCubit, TasksBoardState>(
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
          TasksBoardInitial() || TasksBoardLoading() => const _BoardSkeleton(),
          TasksBoardFailure(:final message, :final kind, :final backendCode) =>
            _BoardFailure(
              message: backendCode == null
                  ? message
                  : '$message ($backendCode)',
              kind: kind,
            ),
          TasksBoardReady() => _ReadyBoard(
            workspaceId: widget.workspaceId,
            projectId: widget.projectId,
            state: state,
            view: _view,
            hasOpenedList: _hasOpenedList,
            settingsRevision: _settingsRevision,
            currentSnapshot: _currentListSnapshot,
            onSnapshotChanged: (snapshot) {
              if (_currentListSnapshot == snapshot) return;
              setState(() => _currentListSnapshot = snapshot);
            },
            onSettingsClosed: () => setState(() => _settingsRevision++),
            onViewChanged: _changeView,
          ),
        },
      ),
    ),
  );
}

class _ReadyBoard extends StatelessWidget {
  const _ReadyBoard({
    required this.workspaceId,
    required this.projectId,
    required this.state,
    required this.view,
    required this.hasOpenedList,
    required this.onViewChanged,
    this.currentSnapshot,
    this.onSnapshotChanged,
    this.settingsRevision = 0,
    this.onSettingsClosed,
  });

  final String workspaceId;
  final String projectId;
  final TasksBoardReady state;
  final _TasksProjectView view;
  final bool hasOpenedList;
  final int settingsRevision;
  final TaskListViewSnapshot? currentSnapshot;
  final ValueChanged<TaskListViewSnapshot>? onSnapshotChanged;
  final VoidCallback? onSettingsClosed;
  final ValueChanged<_TasksProjectView> onViewChanged;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      children: [
        _BoardHeader(
          state: state,
          workspaceId: workspaceId,
          projectId: projectId,
          view: view,
          currentSnapshot: currentSnapshot,
          onViewChanged: onViewChanged,
          onSettingsClosed: onSettingsClosed,
        ),
        Expanded(
          child: view == _TasksProjectView.timeline
              ? TaskTimelineView(
                  workspaceId: workspaceId,
                  projectId: projectId,
                )
              : view == _TasksProjectView.workload
              ? TaskWorkloadView(
                  workspaceId: workspaceId,
                  projectId: projectId,
                )
              : view == _TasksProjectView.recurrence
              ? BlocProvider(
                  create: (context) {
                    final realtimeFactory = context
                        .read<WorkspaceScopedRealtimeFactory?>();
                    final cubit = ProjectRecurrencesCubit(
                      repository: context.read<TaskRecurrenceRepository>(),
                      workspaceId: workspaceId,
                      projectId: projectId,
                      realtime: realtimeFactory != null
                          ? TaskProjectRealtimeAdapter.fromFactory(
                              realtimeFactory,
                            )
                          : null,
                    );
                    unawaited(cubit.load());
                    return cubit;
                  },
                  child: ProjectRecurrencesSheet(
                    workspaceId: workspaceId,
                    projectId: projectId,
                  ),
                )
              : hasOpenedList
              ? IndexedStack(
                  index: view == _TasksProjectView.board ? 0 : 1,
                  children: [
                    _BoardContent(
                      workspaceId: workspaceId,
                      projectId: projectId,
                      state: state,
                    ),
                    _TasksListContent(
                      workspaceId: workspaceId,
                      projectId: projectId,
                      settingsRevision: settingsRevision,
                      hasCustomWorkflow: state.board.columns.any(
                        (column) => column.customStatusId != null,
                      ),
                      onViewSnapshotChanged: onSnapshotChanged,
                    ),
                  ],
                )
              : _BoardContent(
                  workspaceId: workspaceId,
                  projectId: projectId,
                  state: state,
                ),
        ),
      ],
    );
    return view == _TasksProjectView.board
        ? _BoardKeyboardShortcuts(child: content)
        : content;
  }
}

/// Izoluje tabelę listy od snapshotów Kanbana. Realtime musi odświeżyć Kanban
/// po zmianie strukturalnej, ale w widoku List nie może to przebudowywać
/// tysięcy wierszy — lista reaguje wyłącznie na własny Cubit oraz zmianę
/// profili członków, których faktycznie używa w komórkach Owner.
class _TasksListContent extends StatelessWidget {
  const _TasksListContent({
    required this.workspaceId,
    required this.projectId,
    required this.hasCustomWorkflow,
    this.settingsRevision = 0,
    this.onViewSnapshotChanged,
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
            TasksBoardReady(:final memberProfilesByCoreUserId) =>
              memberProfilesByCoreUserId,
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
        final initialGroupBy = savedView?.view.groupBy ?? defaultGroupBy;

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
          groupBy: initialGroupBy,
          hasCustomWorkflow: hasCustomWorkflow,
          columns: savedView?.view.columns ?? defaultTaskListColumns,
          customFieldIds: savedView?.view.customFieldIds ?? const [],
          columnOrder: savedView?.view.columnOrder,
          memberProfilesByCoreUserId: memberProfiles,
          onViewSnapshotChanged: onViewSnapshotChanged,
        );
      },
    );
  }
}

class _BoardContent extends StatefulWidget {
  const _BoardContent({
    required this.workspaceId,
    required this.projectId,
    required this.state,
  });

  final String workspaceId;
  final String projectId;
  final TasksBoardReady state;

  @override
  State<_BoardContent> createState() => _BoardContentState();
}

class _BoardContentState extends State<_BoardContent> {
  final KanbanAutoScrollCoordinator _coordinator =
      KanbanAutoScrollCoordinator();

  @override
  void dispose() {
    _coordinator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.state.board.columns.isEmpty
      ? const _BoardEmpty()
      : KanbanAutoScrollScope(
          coordinator: _coordinator,
          child: _KanbanColumns(
            workspaceId: widget.workspaceId,
            projectId: widget.projectId,
            state: widget.state,
          ),
        );
}

class _BoardKeyboardShortcuts extends StatelessWidget {
  const _BoardKeyboardShortcuts({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: const {
      SingleActivator(LogicalKeyboardKey.keyA, control: true):
          _SelectAllLoadedTasksIntent(),
      SingleActivator(LogicalKeyboardKey.keyA, meta: true):
          _SelectAllLoadedTasksIntent(),
      SingleActivator(LogicalKeyboardKey.escape): _ClearTaskSelectionIntent(),
    },
    child: Actions(
      actions: {
        _SelectAllLoadedTasksIntent:
            CallbackAction<_SelectAllLoadedTasksIntent>(
              onInvoke: (_) {
                context.read<TasksBoardCubit>().selectAllLoadedTasks();
                return null;
              },
            ),
        _ClearTaskSelectionIntent: CallbackAction<_ClearTaskSelectionIntent>(
          onInvoke: (_) {
            context.read<TasksBoardCubit>().clearTaskSelection();
            return null;
          },
        ),
      },
      child: Focus(autofocus: true, child: child),
    ),
  );
}

class _SelectAllLoadedTasksIntent extends Intent {
  const _SelectAllLoadedTasksIntent();
}

class _ClearTaskSelectionIntent extends Intent {
  const _ClearTaskSelectionIntent();
}

String _formatDate(DateTime dt) =>
    '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
