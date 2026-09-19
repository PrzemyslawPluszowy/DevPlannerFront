import 'package:bloc/bloc.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';
import 'package:devplanner/workspaces/domain/navigation/workspace_navigation_tree.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_navigation_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_navigation_tree_state.dart';

/// Composes the clean workspace and project ports into a tree snapshot.
///
/// This controller deliberately owns no HTTP, routing, or widget concerns. A
/// failed project load fails the whole snapshot; no partial or fallback tree
/// is emitted, so a sidebar cannot display data from an unknown scope.
final class WorkspaceNavigationTreeCubit
    extends Cubit<WorkspaceNavigationTreeState> {
  WorkspaceNavigationTreeCubit({
    required this.workspaceGateway,
    required this.projectsGateway,
  }) : super(const WorkspaceNavigationTreeInitial());

  final WorkspaceNavigationGateway workspaceGateway;
  final ProjectsGateway projectsGateway;

  Future<void> load() async {
    if (isClosed) return;
    emit(const WorkspaceNavigationTreeLoading());
    String? activeWorkspaceId;

    try {
      final workspaces = await workspaceGateway.listWorkspaces();
      if (isClosed) return;

      final projectsByWorkspace = <String, List<ProjectListItem>>{};
      for (final workspace in workspaces) {
        activeWorkspaceId = workspace.id;
        final projects = await projectsGateway.listProjects(workspace.id);
        if (isClosed) return;
        if (_violatesWorkspaceScope(workspace, projects)) {
          emit(
            WorkspaceNavigationTreeFailure(
              source: WorkspaceNavigationTreeFailureSource.composition,
              workspaceId: activeWorkspaceId,
              projectsReason: ProjectsFailureReason.invalidResponse,
            ),
          );
          return;
        }
        projectsByWorkspace[workspace.id] = List<ProjectListItem>.unmodifiable(
          projects,
        );
      }

      emit(
        WorkspaceNavigationTreeReady(
          WorkspaceNavigationTree.fromWorkspacesWithProjects(
            workspaces: workspaces,
            projectsByWorkspace: projectsByWorkspace,
          ),
        ),
      );
    } on WorkspacesGatewayException catch (error) {
      if (isClosed) return;
      emit(
        WorkspaceNavigationTreeFailure(
          source: WorkspaceNavigationTreeFailureSource.workspaces,
          workspacesReason: error.reason,
          statusCode: error.statusCode,
          backendCode: error.backendCode,
        ),
      );
    } on ProjectsGatewayException catch (error) {
      if (isClosed) return;
      emit(
        WorkspaceNavigationTreeFailure(
          source: WorkspaceNavigationTreeFailureSource.projects,
          workspaceId: activeWorkspaceId,
          projectsReason: error.reason,
          statusCode: error.statusCode,
          backendCode: error.backendCode,
          message: error.message,
          traceId: error.traceId,
        ),
      );
    } on Exception catch (_) {
      if (isClosed) return;
      emit(
        const WorkspaceNavigationTreeFailure(
          source: WorkspaceNavigationTreeFailureSource.composition,
        ),
      );
    }
  }

  bool _violatesWorkspaceScope(
    WorkspaceSummary workspace,
    List<ProjectListItem> projects,
  ) {
    final projectIds = <String>{};
    for (final project in projects) {
      if (project.workspaceId != workspace.id || !projectIds.add(project.id)) {
        return true;
      }
    }
    return false;
  }
}
