import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';

/// Jawne stany walidacji zasobu otwartego z deep linku.
sealed class WorkspaceResourceAccessState {
  const WorkspaceResourceAccessState();
}

final class WorkspaceResourceAccessInitial
    extends WorkspaceResourceAccessState {
  const WorkspaceResourceAccessInitial();
}

final class WorkspaceResourceAccessLoading
    extends WorkspaceResourceAccessState {
  const WorkspaceResourceAccessLoading();
}

final class WorkspaceResourceAccessGranted
    extends WorkspaceResourceAccessState {
  const WorkspaceResourceAccessGranted(this.item);

  final ProjectResourceListItem item;
}

final class WorkspaceResourceAccessNotFound
    extends WorkspaceResourceAccessState {
  const WorkspaceResourceAccessNotFound();
}

final class WorkspaceResourceAccessFailure
    extends WorkspaceResourceAccessState {
  const WorkspaceResourceAccessFailure({
    required this.message,
    this.backendCode,
  });

  final String message;
  final String? backendCode;
}
