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
  List<WorkspaceSummary> _workspaces = const <WorkspaceSummary>[];
  final Map<String, List<ProjectListItem>> _projectsByWorkspace = {};
  final Map<String, Future<void>> _pendingProjectLoads = {};
  final Map<String, ProjectsGatewayException> _projectFailures = {};

  Future<void> load() async {
    if (isClosed) return;
    emit(const WorkspaceNavigationTreeLoading());
    try {
      final workspaces = await workspaceGateway.listWorkspaces();
      if (isClosed) return;
      _workspaces = List<WorkspaceSummary>.unmodifiable(workspaces);
      _projectsByWorkspace.clear();
      _projectFailures.clear();
      _emitReady();
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
    } on Exception catch (_) {
      if (isClosed) return;
      emit(
        const WorkspaceNavigationTreeFailure(
          source: WorkspaceNavigationTreeFailureSource.composition,
        ),
      );
    }
  }

  /// Ładuje projekty tylko dla rozwiniętego workspace'u. Równoległe kliknięcia
  /// współdzielą jedno żądanie, a błąd pozostaje lokalny dla tej gałęzi.
  Future<void> loadProjects(String workspaceId, {bool refresh = false}) {
    if (isClosed || !_workspaces.any((item) => item.id == workspaceId)) {
      return Future<void>.value();
    }
    if (!refresh && _projectsByWorkspace.containsKey(workspaceId)) {
      return Future<void>.value();
    }
    final pending = _pendingProjectLoads[workspaceId];
    if (pending != null) return pending;

    final task = _loadProjects(workspaceId);
    _pendingProjectLoads[workspaceId] = task;
    return task.whenComplete(() => _pendingProjectLoads.remove(workspaceId));
  }

  Future<void> _loadProjects(String workspaceId) async {
    _projectFailures.remove(workspaceId);
    _emitReady(loadingWorkspaceIds: {workspaceId});
    try {
      final projects = await projectsGateway.listProjects(workspaceId);
      if (isClosed) return;
      final workspace = _workspaces.firstWhere(
        (item) => item.id == workspaceId,
      );
      if (_violatesWorkspaceScope(workspace, projects)) {
        _projectFailures[workspaceId] = const ProjectsGatewayException(
          reason: ProjectsFailureReason.invalidResponse,
        );
      } else {
        _projectsByWorkspace[workspaceId] = List<ProjectListItem>.unmodifiable(
          projects,
        );
      }
    } on ProjectsGatewayException catch (error) {
      if (isClosed) return;
      _projectFailures[workspaceId] = error;
    } on Exception catch (_) {
      if (isClosed) return;
      _projectFailures[workspaceId] = const ProjectsGatewayException(
        reason: ProjectsFailureReason.requestFailed,
      );
    }
    if (!isClosed) _emitReady();
  }

  void _emitReady({Set<String> loadingWorkspaceIds = const <String>{}}) {
    if (isClosed) return;
    emit(
      WorkspaceNavigationTreeReady(
        WorkspaceNavigationTree.fromWorkspacesWithProjects(
          workspaces: _workspaces,
          projectsByWorkspace: _projectsByWorkspace,
        ),
        loadingProjectWorkspaceIds: Set<String>.unmodifiable(
          loadingWorkspaceIds,
        ),
        projectFailuresByWorkspace:
            Map<String, ProjectsGatewayException>.unmodifiable(
              _projectFailures,
            ),
      ),
    );
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
