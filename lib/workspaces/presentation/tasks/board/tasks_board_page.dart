import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:devplanner/shared/presentation/widgets/app_expandable_side_sheet.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_capacity_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/realtime/tasks/task_project_realtime_adapter.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_project_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_capacity_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_state.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/project_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/user_hub/project_user_hub_modal.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/task_board_date_formatter.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_card_subtasks.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_columns_viewport.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_drop_targets.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_list_content.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_template_choice_button.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_project_view.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/viewport/kanban_auto_scroll_coordinator.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_contextual_bulk_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/chrome/tasks_command_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/chrome/tasks_error_banner_host.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_list_chrome_host.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_saved_view_selection.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/project_tasks_list_rows.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/project_recurrences_sheet.dart';
import 'package:devplanner/workspaces/presentation/tasks/tasks_project_view_contract.dart';
import 'package:devplanner/workspaces/presentation/tasks/timeline/cubit/task_timeline_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/task_saved_views_export.dart';
import 'package:devplanner/workspaces/presentation/tasks/widgets/tasks_selection_checkbox.dart';
import 'package:devplanner/workspaces/presentation/tasks/workload/cubit/task_workload_cubit.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

export '../tasks_project_view_contract.dart' show TasksProjectView;
export 'tasks_board_card_subtasks.dart';
export 'tasks_project_view.dart';

part '../header/tasks_header.dart';
part '../header/tasks_header_actions.dart';
part '../header/tasks_header_board_filters.dart';
part '../header/tasks_header_command_bar.dart';
part '../header/tasks_header_create_actions.dart';
part '../header/tasks_header_layout.dart';
part '../header/tasks_header_quick_create_dialog.dart';
part 'cards/content/kanban_card_frame.dart';
part 'cards/content/kanban_card_identity.dart';
part 'cards/content/kanban_card_metadata.dart';
part 'tasks_board_card_content.dart';
part 'tasks_board_card_menu.dart';
part 'tasks_board_cards.dart';
part 'tasks_board_collapsed_column.dart';
part 'tasks_board_columns.dart';
part 'tasks_board_quick_create.dart';
part 'tasks_board_saved_views.dart';
part 'tasks_board_states.dart';
part 'tasks_board_template_picker.dart';
part 'tasks_board_template_picker_actions.dart';
part 'tasks_board_template_picker_content.dart';
part 'tasks_board_timeline.dart';
part 'tasks_board_view_switcher.dart';
part 'tasks_board_workload.dart';
part 'template_actions/template_editor_basic.dart';
part 'template_actions/template_editor_classification.dart';
part 'template_actions/template_editor_fields.dart';
part 'template_actions/template_editor_loading.dart';
part 'template_actions/template_editor_management.dart';
part 'template_actions/template_editor_metadata.dart';
part 'template_actions/template_editor_mutations.dart';
part 'template_actions/template_editor_planning.dart';
part 'template_actions/template_editor_responsibility.dart';
part 'template_actions/template_editor_scope.dart';
part 'template_actions/template_editor_sections.dart';
part 'template_actions/template_editor_state.dart';
part 'template_actions/template_editor_values.dart';
part 'template_actions/template_editor_view.dart';
part 'template_actions/template_picker_actions.dart';
part 'widgets/project_member_facepile.dart';

/// Produkcyjny widok tablicy Tasks projektu.
class TasksBoardPage extends StatelessWidget {
  const TasksBoardPage({
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
  final TasksProjectViewPreferenceStore? viewPreferenceStore;
  final VoidCallback? onProjectExited;

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
    child: TasksProjectViewHost(
      workspaceId: workspaceId,
      projectId: projectId,
      initialView: initialView,
      viewPreferenceStore: viewPreferenceStore,
      onProjectExited: onProjectExited,
    ),
  );
}

class TasksBoardReadyView extends StatelessWidget {
  const TasksBoardReadyView({
    required this.workspaceId,
    required this.projectId,
    required this.state,
    required this.view,
    required this.hasOpenedList,
    required this.onViewChanged,
    this.hasOpenedBoard = true,
    this.currentSnapshot,
    this.onSnapshotChanged,
    this.settingsRevision = 0,
    this.onSettingsClosed,
    this.onProjectExited,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final TasksBoardReady state;
  final TasksProjectView view;
  final bool hasOpenedList;

  /// Kanban nie jest montowany, dopóki użytkownik go nie otworzy.
  ///
  /// Kolumny dociągają kolejne strony dopiero po zamontowaniu widoku, więc
  /// domyślna Lista nie może płacić za niewidoczny board.
  final bool hasOpenedBoard;
  final int settingsRevision;
  final TaskListViewSnapshot? currentSnapshot;
  final ValueChanged<TaskListViewSnapshot>? onSnapshotChanged;
  final VoidCallback? onSettingsClosed;

  /// Nawigację po wyjściu z projektu dostarcza właściciel trasy.
  final VoidCallback? onProjectExited;
  final ValueChanged<TasksProjectView> onViewChanged;

  @override
  Widget build(BuildContext context) {
    // Aktywny zapisany widok czytamy raz i przekazujemy wierszowi poleceń oraz
    // treści Listy, żeby oba opisywały ten sam widok.
    final savedView = TaskSavedViewSelection.of(
      context,
      hasCustomWorkflow: state.board.columns.any(
        (column) => column.customStatusId != null,
      ),
    );
    return TaskListChromeHost(
      key: ValueKey(savedView.savedViewId),
      workspaceId: workspaceId,
      projectId: projectId,
      savedViewId: savedView.savedViewId,
      groupBy: savedView.groupBy,
      memberProfilesByUserId: state.memberProfilesByUserId,
      builder: (context, chrome) => _readyContent(context, chrome, savedView),
    );
  }

  Widget _readyContent(
    BuildContext context,
    TaskListChrome chrome,
    TaskSavedViewSelection savedView,
  ) {
    // Sloty Listy i Kanbanu są stabilne, żeby powrót między widokami nie
    // remontował drugiego z nich razem z jego scrollem i stanem inline.
    final showBoard = hasOpenedBoard || view == TasksProjectView.board;
    final showList = hasOpenedList || view == TasksProjectView.list;
    final content = Column(
      children: [
        // Moduł montuje publiczny nagłówek, więc Lista i Kanban używają
        // dokładnie tego samego chrome, a testy mają jeden typ do sprawdzenia.
        TasksHeader(
          state: state,
          workspaceId: workspaceId,
          projectId: projectId,
          view: view,
          currentSnapshot: currentSnapshot,
          onViewChanged: onViewChanged,
          onSettingsClosed: onSettingsClosed,
          onProjectExited: onProjectExited,
          commandBar: chrome.commandBar,
          bulkBar: chrome.bulkBar,
          showBulkBar: chrome.showBulkBar,
        ),
        // Trwały komunikat błędu widzi cały moduł Tasks: Lista, Kanban i widoki
        // pochodne, także po przebudowie drzewa albo zamknięciu menu.
        TasksErrorBannerHost(
          boardActive: view == TasksProjectView.board,
        ),
        Expanded(
          child: view == TasksProjectView.timeline
              ? TaskTimelineView(
                  workspaceId: workspaceId,
                  projectId: projectId,
                )
              : view == TasksProjectView.workload
              ? TaskWorkloadView(
                  workspaceId: workspaceId,
                  projectId: projectId,
                )
              : view == TasksProjectView.recurrence
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
              : IndexedStack(
                  index: view == TasksProjectView.board ? 0 : 1,
                  children: [
                    if (showBoard)
                      _BoardContent(
                        workspaceId: workspaceId,
                        projectId: projectId,
                        state: state,
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
                        listCubit: chrome.listCubit,
                        preferencesCubit: chrome.preferencesCubit,
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
        ),
      ],
    );
    // Cała zakładka Tasks odstaje o włos od krawędzi canvasu shella, żeby obrys
    // kontenera nie stykał się z tabelą Listy ani z kolumnami tablicy.
    final tab = Padding(
      padding: const .only(left: Sizes.p2),
      child: content,
    );
    return view == TasksProjectView.board
        ? _BoardKeyboardShortcuts(child: tab)
        : tab;
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
          child: KanbanColumnsViewport(
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
