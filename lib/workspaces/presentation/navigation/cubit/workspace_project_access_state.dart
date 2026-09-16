import 'package:ready_next/workspaces/domain/models/project_list_item.dart';

/// Stany weryfikacji projektu otwartego z bezpośredniego URL-a.
sealed class WorkspaceProjectAccessState {
  const WorkspaceProjectAccessState();
}

final class WorkspaceProjectAccessInitial extends WorkspaceProjectAccessState {
  const WorkspaceProjectAccessInitial();
}

final class WorkspaceProjectAccessLoading extends WorkspaceProjectAccessState {
  const WorkspaceProjectAccessLoading();
}

final class WorkspaceProjectAccessGranted extends WorkspaceProjectAccessState {
  const WorkspaceProjectAccessGranted(this.project);

  final ProjectListItem project;
}

final class WorkspaceProjectAccessDenied extends WorkspaceProjectAccessState {
  const WorkspaceProjectAccessDenied({required this.message, this.backendCode});

  final String message;
  final String? backendCode;
}

final class WorkspaceProjectAccessFailure extends WorkspaceProjectAccessState {
  const WorkspaceProjectAccessFailure({
    required this.message,
    this.backendCode,
  });

  final String message;
  final String? backendCode;
}
