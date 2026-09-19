import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_board_composition.dart';
import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
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
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/project_tasks_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

/// Composition boundary for the real Tasks/Kanban page.
///
/// The widget only exposes typed domain ports to presentation. HTTP clients,
/// token handling and SignalR construction remain in the data composition.
final class TasksBoardRoutePage extends StatelessWidget {
  const TasksBoardRoutePage({
    required this.composition,
    required this.workspaceId,
    required this.projectId,
    required this.authSession,
    this.initialView,
    super.key,
  });

  final TasksBoardComposition composition;
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
    child: _content(),
  );

  Widget _content() {
    if (initialView == 'kanban') {
      return TasksBoardPage(
        workspaceId: workspaceId,
        projectId: projectId,
        initialView: initialView,
      );
    }
    return ProjectTasksList(
      workspaceId: workspaceId,
      projectId: projectId,
      listenToBoardRealtime: false,
    );
  }
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
