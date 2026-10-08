import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:devplanner/shared/presentation/widgets/app_expandable_side_sheet.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/preferences/shared_preferences_tasks_board_view_store.dart';
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
import 'package:devplanner/workspaces/domain/models/project_people_request.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_board_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_project_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_capacity_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_state.dart';
import 'package:devplanner/workspaces/presentation/projects/people/project_member_presence_label.dart';
import 'package:devplanner/workspaces/presentation/projects/people/project_people_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/people/project_people_panel.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/project_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_api_error_normalizer.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_assignee_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/kanban_assignee_visuals.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/kanban_board_grouping_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/kanban_column_surface.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/kanban_move_to_person_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/task_board_color_parser.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/task_board_date_formatter.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_card_subtasks.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_drop_targets.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_quick_create.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_ready_content.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_view_switcher.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_project_view.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/templates/cubit/task_template_picker_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/viewport/kanban_auto_scroll_coordinator.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_board_bulk_due_scope.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_bulk_due_date_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_bulk_interaction.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_contextual_bulk_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/chrome/tasks_command_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/chrome/tasks_error_banner_host.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_open_intent.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_error_banner.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_view_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/header/task_quick_create_select.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_list_chrome_host.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_saved_view_selection.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/project_tasks_list_rows.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_launcher.dart';
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
export 'kanban_assignee_board_content.dart'
    show KanbanAssigneeBoardContent, KanbanAssigneeColumnsViewport;
export 'kanban_assignee_column.dart' show KanbanAssigneeColumn;
export 'kanban_assignee_visuals.dart'
    show
        KanbanAssigneeAvatar,
        KanbanAssigneeStatusBadge,
        KanbanCardStatusBadge,
        KanbanCardStatusBadgeView;
export 'kanban_board_grouping_bar.dart' show KanbanBoardGroupingBar;
export 'kanban_column_surface.dart' show KanbanColumnSurface;
export 'kanban_move_to_person_dialog.dart' show KanbanMoveToPersonDialog;
export 'task_board_color_parser.dart' show TaskBoardColorParser;
export 'tasks_board_card_subtasks.dart';
export 'tasks_project_view.dart';

part '../header/tasks_header.dart';
part '../header/tasks_header_actions.dart';
part '../header/tasks_header_assignee_columns.dart';
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
part 'tasks_board_saved_views.dart';
part 'tasks_board_states.dart';
part 'tasks_board_template_picker.dart';
part 'tasks_board_template_picker_actions.dart';
part 'tasks_board_template_picker_content.dart';
part 'tasks_board_timeline.dart';
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
    this.boardViewPreferenceStore,
    this.viewPreferenceStore,
    this.onProjectExited,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final String? initialView;
  final TasksProjectViewPreferenceStore? viewPreferenceStore;

  /// Osobiste preferencje widoku tablicy (grupowanie, widoczność kolumn osób);
  /// brak adaptera oznacza wybór w pamięci bieżącej sesji.
  final TasksBoardViewPreferenceStore? boardViewPreferenceStore;
  final VoidCallback? onProjectExited;

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) {
          final authSession = context.read<AuthSessionPort>();
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
            viewPreferenceStore:
                boardViewPreferenceStore ??
                SharedPreferencesTasksBoardViewStore(
                  // Preferencja jest osobista, więc tożsamość czytamy w momencie
                  // operacji, a nie raz na starcie klienta.
                  currentUserId: () => authSession.snapshot.user?.userId,
                ),
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

/// Rozdziela widok listy i tablicy od ich chrome oraz właścicieli stanu.
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
  final bool hasOpenedBoard;
  final int settingsRevision;
  final TaskListViewSnapshot? currentSnapshot;
  final ValueChanged<TaskListViewSnapshot>? onSnapshotChanged;
  final VoidCallback? onSettingsClosed;
  final VoidCallback? onProjectExited;
  final ValueChanged<TasksProjectView> onViewChanged;

  @override
  Widget build(BuildContext context) {
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
      builder: (context, chrome) => TasksBoardReadyContent(
        header: TasksHeader(
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
          taskSearchAction: TasksGlobalSearchLauncher(
            repository: context.read<TaskViewRepository>(),
          ),
        ),
        errorBanner: TasksErrorBannerHost(
          boardActive: view == TasksProjectView.board,
        ),
        workspaceId: workspaceId,
        projectId: projectId,
        state: state,
        view: view,
        hasOpenedList: hasOpenedList,
        hasOpenedBoard: hasOpenedBoard,
        savedView: savedView,
        settingsRevision: settingsRevision,
        onSnapshotChanged: onSnapshotChanged,
        emptyStateBuilder: (_) => const _BoardEmpty(),
        cardBuilder: (task, statusBadge, canDrag) => KanbanAssigneeTaskCard(
          task: task,
          workspaceId: workspaceId,
          projectId: projectId,
          state: state,
          statusBadge: statusBadge,
          canDrag: canDrag,
        ),
        quickCreateBuilder: (backlogColumn) => KanbanQuickCreateTask(
          column: backlogColumn,
          onManageTemplates: TaskTemplatePickerOverlay.show,
        ),
        timelineView: TaskTimelineView(
          workspaceId: workspaceId,
          projectId: projectId,
        ),
        workloadView: TaskWorkloadView(
          workspaceId: workspaceId,
          projectId: projectId,
        ),
        listCubit: chrome.listCubit,
        preferencesCubit: chrome.preferencesCubit,
      ),
    );
  }
}
