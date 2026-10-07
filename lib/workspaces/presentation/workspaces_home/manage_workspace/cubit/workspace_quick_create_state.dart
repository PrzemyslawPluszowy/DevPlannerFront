import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';

final class WorkspaceQuickCreateState {
  const WorkspaceQuickCreateState({
    this.isSubmitting = false,
    this.nameInvalid = false,
    this.failure,
    this.createdWorkspaceId,
    this.openFailed = false,
  });

  final bool isSubmitting;
  final bool nameInvalid;
  final WorkspacesFailureReason? failure;
  final String? createdWorkspaceId;
  final bool openFailed;
}
