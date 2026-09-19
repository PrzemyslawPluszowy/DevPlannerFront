import 'package:bloc/bloc.dart';
import 'package:devplanner/workspaces/domain/navigation/workspace_navigation_tree.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_navigation_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_navigation_state.dart';

/// Ładuje dane drzewa bez mieszania transportu z UI.
final class WorkspaceNavigationCubit extends Cubit<WorkspaceNavigationState> {
  WorkspaceNavigationCubit({required this.gateway})
    : super(const WorkspaceNavigationInitial());

  final WorkspaceNavigationGateway gateway;

  Future<void> load() async {
    if (isClosed) return;
    emit(const WorkspaceNavigationLoading());
    try {
      final workspaces = await gateway.listWorkspaces();
      if (isClosed) return;
      emit(
        WorkspaceNavigationReady(
          WorkspaceNavigationTree.fromWorkspaces(workspaces),
        ),
      );
    } on WorkspacesGatewayException catch (error) {
      if (isClosed) return;
      emit(
        WorkspaceNavigationFailure(
          reason: error.reason,
          statusCode: error.statusCode,
          backendCode: error.backendCode,
        ),
      );
    } on Exception catch (_) {
      if (isClosed) return;
      emit(
        const WorkspaceNavigationFailure(
          reason: WorkspacesFailureReason.requestFailed,
        ),
      );
    }
  }
}
