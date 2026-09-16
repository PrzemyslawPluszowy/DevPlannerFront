import 'package:ready_next/workspaces/domain/models/project_list_item.dart';

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
  const WorkspaceProjectsFailure({required this.message, this.backendCode});

  final String message;
  final String? backendCode;
}
