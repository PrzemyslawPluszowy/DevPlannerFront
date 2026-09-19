import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_navigation_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';

/// Adapter istniejącego lokalnego katalogu workspace do portu drzewa.
final class DevPlannerWorkspaceNavigationGateway
    implements WorkspaceNavigationGateway {
  const DevPlannerWorkspaceNavigationGateway({required this.workspacesGateway});

  final WorkspacesGateway workspacesGateway;

  @override
  Future<List<WorkspaceSummary>> listWorkspaces() =>
      workspacesGateway.listWorkspaces();
}
