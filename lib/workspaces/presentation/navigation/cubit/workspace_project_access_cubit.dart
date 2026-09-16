import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/repositories/projects_repository.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_project_access_state.dart';

/// Lokalnie weryfikuje projekt wskazany przez deep link.
final class WorkspaceProjectAccessCubit
    extends Cubit<WorkspaceProjectAccessState> {
  WorkspaceProjectAccessCubit({
    required this._repository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const WorkspaceProjectAccessInitial());

  final ProjectsRepository _repository;
  final String workspaceId;
  final String projectId;

  Future<void> load() async {
    if (isClosed || state is WorkspaceProjectAccessLoading) return;
    emit(const WorkspaceProjectAccessLoading());
    final result = await _repository.listProjects(workspaceId);
    if (isClosed) return;
    result.fold(
      (error) {
        final denied = switch (error.type) {
          ApiErrorType.unauthorized || ApiErrorType.forbidden => true,
          _ => false,
        };
        emit(
          denied
              ? WorkspaceProjectAccessDenied(
                  message: error.message,
                  backendCode: error.backendCode?.toString(),
                )
              : WorkspaceProjectAccessFailure(
                  message: error.message,
                  backendCode: error.backendCode?.toString(),
                ),
        );
      },
      (projects) {
        final project = projects
            .where((item) => item.id == projectId)
            .firstOrNull;
        emit(
          project == null
              ? const WorkspaceProjectAccessDenied(
                  message: 'Projekt nie należy do tego workspace’u.',
                )
              : WorkspaceProjectAccessGranted(project),
        );
      },
    );
  }
}
