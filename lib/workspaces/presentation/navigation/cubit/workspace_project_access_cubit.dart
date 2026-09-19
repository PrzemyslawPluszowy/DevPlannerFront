import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_project_access_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lokalnie weryfikuje projekt wskazany przez deep link.
final class WorkspaceProjectAccessCubit
    extends Cubit<WorkspaceProjectAccessState> {
  WorkspaceProjectAccessCubit({
    required this._gateway,
    required this.workspaceId,
    required this.projectId,
  }) : super(const WorkspaceProjectAccessInitial());

  final ProjectsGateway _gateway;
  final String workspaceId;
  final String projectId;

  Future<void> load() async {
    if (isClosed || state is WorkspaceProjectAccessLoading) return;
    emit(const WorkspaceProjectAccessLoading());
    try {
      final projects = await _gateway.listProjects(workspaceId);
      if (isClosed) return;
      final project = projects
          .where((item) => item.id == projectId)
          .firstOrNull;
      emit(
        project == null
            ? const WorkspaceProjectAccessDenied(
                reason: ProjectsFailureReason.notFound,
                statusCode: 404,
              )
            : WorkspaceProjectAccessGranted(project),
      );
    } on ProjectsGatewayException catch (error) {
      if (isClosed) return;
      final denied =
          error.reason == ProjectsFailureReason.unauthorized ||
          error.reason == ProjectsFailureReason.forbidden ||
          error.reason == ProjectsFailureReason.notFound;
      final state = denied
          ? WorkspaceProjectAccessDenied(
              reason: error.reason,
              statusCode: error.statusCode,
              backendCode: error.backendCode,
              message: error.message,
            )
          : WorkspaceProjectAccessFailure(
              reason: error.reason,
              statusCode: error.statusCode,
              backendCode: error.backendCode,
              message: error.message,
            );
      emit(state);
    } on Exception catch (_) {
      if (isClosed) return;
      emit(
        const WorkspaceProjectAccessFailure(
          reason: ProjectsFailureReason.requestFailed,
        ),
      );
    }
  }
}
