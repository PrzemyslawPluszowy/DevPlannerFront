import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_board_composition.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_details_composition.dart';
import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_project_view_preference_store.dart';
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
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_modal_navigation_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Granica kompozycji strony Tasks i tablicy Kanban.
///
/// Warstwa prezentacji otrzymuje tu typowane porty domenowe. Klienty HTTP,
/// obsługa tokenów i tworzenie SignalR pozostają w kompozycji danych.
final class TasksBoardRoutePage extends StatelessWidget {
  const TasksBoardRoutePage({
    required this.composition,
    required this.projectSettings,
    required this.workspaceId,
    required this.projectId,
    required this.authSession,
    this.taskId,
    this.detailsComposition,
    this.initialView,
    this.viewPreferenceStore,
    super.key,
  });

  final TasksBoardComposition composition;

  /// Porty centrum ustawień projektu otwieranego z nagłówka Tasks.
  final ProjectSettingsComposition projectSettings;

  final String workspaceId;
  final String projectId;
  final AuthSessionPort authSession;
  final String? taskId;
  final TasksDetailsComposition? detailsComposition;
  final String? initialView;

  /// Preferencja „ostatnio używany widok” dla adresu `/tasks` bez `?view=`.
  final TasksProjectViewPreferenceStore? viewPreferenceStore;

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
    child: TaskDetailModalNavigationHost(
      workspaceId: workspaceId,
      projectId: projectId,
      taskId: taskId,
      detailsComposition: detailsComposition,
      settingsComposition: projectSettings,
      memberProfilesRepository: composition.memberProfilesRepository,
      child: Consumer<AuthSessionPort>(
        builder: (context, session, _) => TasksBoardPage(
          key: _TasksBoardRouteScopeKey(
            workspaceId: workspaceId,
            projectId: projectId,
            authUserId: session.snapshot.user?.userId,
            ports: [
              composition.kanbanRepository,
              composition.tasksRepository,
              composition.workflowRepository,
              composition.collaborationRepository,
              composition.taskTemplateRepository,
              composition.memberProfilesRepository,
              composition.projectsRepository,
              composition.metadataRepository,
              composition.viewRepository,
              composition.listConfigurationRepository,
              composition.capacityRepository,
              composition.recurrenceRepository,
              composition.milestoneRepository,
              composition.realtimeFactory,
              session,
              viewPreferenceStore,
            ],
          ),
          workspaceId: workspaceId,
          projectId: projectId,
          initialView: initialView,
          viewPreferenceStore: viewPreferenceStore,
          // Wyjście z projektu obsługuje trasa, więc nagłówek nie zna routera.
          onProjectExited: () => context.go(
            DevPlannerRouteCatalog.workspace(workspaceId),
          ),
        ),
      ),
    ),
  );
}

/// Stan błędu używany, gdy BFF przeglądarki nie może dostarczyć
/// uwierzytelnienia SignalR dla desktopu.
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

/// Odtwarza Cubity trasy po zmianie zakresu albo typowanej zależności.
final class _TasksBoardRouteScopeKey extends LocalKey {
  _TasksBoardRouteScopeKey({
    required this.workspaceId,
    required this.projectId,
    required this.authUserId,
    required List<Object?> ports,
  }) : ports = List<Object?>.unmodifiable(ports);

  final String workspaceId;
  final String projectId;
  final String? authUserId;
  final List<Object?> ports;

  @override
  bool operator ==(Object other) {
    if (other is! _TasksBoardRouteScopeKey ||
        workspaceId != other.workspaceId ||
        projectId != other.projectId ||
        authUserId != other.authUserId ||
        ports.length != other.ports.length) {
      return false;
    }
    for (var index = 0; index < ports.length; index++) {
      if (!identical(ports[index], other.ports[index])) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    workspaceId,
    projectId,
    authUserId,
    Object.hashAll(ports.map(identityHashCode)),
  );
}
