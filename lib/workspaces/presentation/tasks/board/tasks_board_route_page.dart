import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_board_composition.dart';
import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_capacity_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Composition boundary for the real Tasks/Kanban page.
///
/// The widget only exposes typed domain ports to presentation. HTTP clients,
/// token handling and SignalR construction remain in the data composition.
final class TasksBoardRoutePage extends StatelessWidget {
  const TasksBoardRoutePage({
    required this.composition,
    required this.projectSettings,
    required this.workspaceId,
    required this.projectId,
    required this.authSession,
    this.initialView,
    super.key,
  });

  final TasksBoardComposition composition;

  /// Porty centrum ustawień projektu otwieranego z nagłówka Tasks.
  final ProjectSettingsComposition projectSettings;

  final String workspaceId;
  final String projectId;
  final AuthSessionPort authSession;
  final String? initialView;

  @override
  Widget build(BuildContext context) => MultiRepositoryProvider(
    providers: [
      RepositoryProvider<KanbanRepository>.value(
        value: composition.kanbanRepository,
      ),
      RepositoryProvider<TasksRepository>.value(
        value: composition.tasksRepository,
      ),
      RepositoryProvider<TaskWorkflowRepository>.value(
        value: composition.workflowRepository,
      ),
      RepositoryProvider<TaskCollaborationRepository>.value(
        value: composition.collaborationRepository,
      ),
      RepositoryProvider<TaskTemplateRepository>.value(
        value: composition.taskTemplateRepository,
      ),
      RepositoryProvider<ProjectMemberProfilesRepository>.value(
        value: composition.memberProfilesRepository,
      ),
      // Panel użytkownika projektu i ustawienia projektu są otwierane z
      // nagłówka Tasks, więc kontrakt projektów musi być widoczny w tej samej
      // kompozycji co porty zadań. Centrum ustawień dostaje dodatkowo cały
      // zestaw portów, bo jest montowane na root navigatorze.
      RepositoryProvider<ProjectsRepository>.value(
        value: composition.projectsRepository,
      ),
      RepositoryProvider<ProjectSettingsComposition>.value(
        value: projectSettings,
      ),
      RepositoryProvider<TaskMetadataRepository>.value(
        value: composition.metadataRepository,
      ),
      RepositoryProvider<TaskViewRepository>.value(
        value: composition.viewRepository,
      ),
      RepositoryProvider<TaskListConfigurationRepository>.value(
        value: composition.listConfigurationRepository,
      ),
      RepositoryProvider<TaskCapacityRepository>.value(
        value: composition.capacityRepository,
      ),
      RepositoryProvider<TaskRecurrenceRepository>.value(
        value: composition.recurrenceRepository,
      ),
      RepositoryProvider<MilestoneRepository>.value(
        value: composition.milestoneRepository,
      ),
      RepositoryProvider<WorkspaceScopedRealtimeFactory>.value(
        value: composition.realtimeFactory,
      ),
      ListenableProvider<AuthSessionPort>.value(value: authSession),
    ],
    // Lista, Kanban, Timeline, Workload i Cykliczne są widokami jednego
    // modułu Tasks. Trasa zawsze montuje ten sam host, więc wspólny nagłówek,
    // zapisane widoki, ustawienia projektu i realtime nie mogą zależeć od
    // wartości `?view=`.
    child: TasksBoardPage(
      workspaceId: workspaceId,
      projectId: projectId,
      initialView: initialView,
      // Wyjście z projektu obsługuje trasa, więc nagłówek nie zna routera.
      onProjectExited: () => context.go(
        DevPlannerRouteCatalog.workspace(workspaceId),
      ),
    ),
  );
}

/// Fail-closed state used only when a browser BFF cannot supply desktop
/// SignalR credentials. It is never returned on the normal desktop path.
final class TasksBoardTransportUnavailablePage extends StatelessWidget {
  const TasksBoardTransportUnavailablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.workspacesTransportUnavailableTitle,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.workspacesTransportUnavailableMessage,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
