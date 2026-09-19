import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';

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
  const WorkspaceProjectAccessDenied({
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

final class WorkspaceProjectAccessFailure extends WorkspaceProjectAccessState {
  const WorkspaceProjectAccessFailure({
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
