import 'package:devplanner/workspaces/domain/navigation/workspace_navigation_tree.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';

sealed class WorkspaceNavigationState {
  const WorkspaceNavigationState();
}

final class WorkspaceNavigationInitial extends WorkspaceNavigationState {
  const WorkspaceNavigationInitial();
}

final class WorkspaceNavigationLoading extends WorkspaceNavigationState {
  const WorkspaceNavigationLoading();
}

final class WorkspaceNavigationReady extends WorkspaceNavigationState {
  const WorkspaceNavigationReady(this.tree);

  final WorkspaceNavigationTree tree;
}

final class WorkspaceNavigationFailure extends WorkspaceNavigationState {
  const WorkspaceNavigationFailure({
    required this.reason,
    this.statusCode,
    this.backendCode,
  });

  final WorkspacesFailureReason reason;
  final int? statusCode;
  final String? backendCode;
}
