import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';

/// Jawne stany leniwie ładowanych projektów w węźle workspace’u.
sealed class WorkspaceProjectsState {
  const WorkspaceProjectsState();
}

final class WorkspaceProjectsInitial extends WorkspaceProjectsState {
  const WorkspaceProjectsInitial();
}

final class WorkspaceProjectsLoading extends WorkspaceProjectsState {
  const WorkspaceProjectsLoading();
}

final class WorkspaceProjectsReady extends WorkspaceProjectsState {
  const WorkspaceProjectsReady(this.items);

  final List<ProjectListItem> items;
}

final class WorkspaceProjectsEmpty extends WorkspaceProjectsState {
  const WorkspaceProjectsEmpty();
}

final class WorkspaceProjectsFailure extends WorkspaceProjectsState {
  const WorkspaceProjectsFailure({
    required this.reason,
    this.statusCode,
    this.backendCode,
    this.message,
  });

  final ProjectsFailureReason reason;
  final int? statusCode;
  final String? backendCode;
  final String? message;
}
