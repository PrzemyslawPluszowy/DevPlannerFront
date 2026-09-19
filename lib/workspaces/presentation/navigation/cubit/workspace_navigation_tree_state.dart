import 'package:devplanner/workspaces/domain/navigation/workspace_navigation_tree.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';

sealed class WorkspaceNavigationTreeState {
  const WorkspaceNavigationTreeState();
}

final class WorkspaceNavigationTreeInitial
    extends WorkspaceNavigationTreeState {
  const WorkspaceNavigationTreeInitial();
}

final class WorkspaceNavigationTreeLoading
    extends WorkspaceNavigationTreeState {
  const WorkspaceNavigationTreeLoading();
}

final class WorkspaceNavigationTreeReady extends WorkspaceNavigationTreeState {
  const WorkspaceNavigationTreeReady(this.tree);

  final WorkspaceNavigationTree tree;
}

enum WorkspaceNavigationTreeFailureSource { workspaces, projects, composition }

final class WorkspaceNavigationTreeFailure
    extends WorkspaceNavigationTreeState {
  const WorkspaceNavigationTreeFailure({
    required this.source,
    this.workspaceId,
    this.workspacesReason,
    this.projectsReason,
    this.statusCode,
    this.backendCode,
    this.message,
    this.traceId,
  });

  final WorkspaceNavigationTreeFailureSource source;
  final String? workspaceId;
  final WorkspacesFailureReason? workspacesReason;
  final ProjectsFailureReason? projectsReason;
  final int? statusCode;
  final String? backendCode;
  final String? message;
  final String? traceId;
}
