import 'package:devplanner/workspaces/domain/ports/workspace_management_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/cubit/workspace_quick_create_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class WorkspaceQuickCreateCubit extends Cubit<WorkspaceQuickCreateState> {
  WorkspaceQuickCreateCubit({required this.gateway})
    : super(const WorkspaceQuickCreateState());

  final WorkspaceManagementGateway gateway;

  void clearNameError() {
    if (!isClosed && state.nameInvalid) {
      emit(const WorkspaceQuickCreateState());
    }
  }

  /// Zapis jest zakończony przed nawigacją. Ponowienie nawigacji używa tego ID.
  Future<String?> createOrRetry(String rawName) async {
    if (isClosed || state.isSubmitting) return null;
    final name = rawName.trim();
    if (name.isEmpty) {
      emit(const WorkspaceQuickCreateState(nameInvalid: true));
      return null;
    }
    final createdId = state.createdWorkspaceId;
    emit(
      WorkspaceQuickCreateState(
        isSubmitting: true,
        createdWorkspaceId: createdId,
      ),
    );
    if (createdId != null) return createdId;
    try {
      final workspace = await gateway.createWorkspace(name: name);
      if (isClosed) return null;
      emit(
        WorkspaceQuickCreateState(
          isSubmitting: true,
          createdWorkspaceId: workspace.id,
        ),
      );
      return workspace.id;
    } on WorkspacesGatewayException catch (error) {
      if (!isClosed) emit(WorkspaceQuickCreateState(failure: error.reason));
    } catch (_) {
      if (!isClosed) {
        emit(
          const WorkspaceQuickCreateState(
            failure: WorkspacesFailureReason.requestFailed,
          ),
        );
      }
    }
    return null;
  }

  void finishOpening({required bool succeeded}) {
    if (isClosed) return;
    emit(
      WorkspaceQuickCreateState(
        createdWorkspaceId: state.createdWorkspaceId,
        openFailed: !succeeded,
      ),
    );
  }
}
