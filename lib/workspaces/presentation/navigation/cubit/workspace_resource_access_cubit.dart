import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/models/project_resource_list_item.dart';
import 'package:ready_next/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_resource_access_state.dart';

/// Lokalnie potwierdza, że zasób z URL należy do bieżącego projektu.
///
/// Detail route nie pokazuje technicznego placeholdera ani samego ID z URL:
/// pobiera katalog właściwego typu i renderuje dane dopiero po znalezieniu
/// zasobu. Szczegółowe dane pozostają odpowiedzialnością modułu domenowego.
final class WorkspaceResourceAccessCubit
    extends Cubit<WorkspaceResourceAccessState> {
  WorkspaceResourceAccessCubit({
    required this._repository,
    required this.workspaceId,
    required this.projectId,
    required this.resourceKind,
    required this.resourceId,
  }) : super(const WorkspaceResourceAccessInitial());

  final ProjectResourcesRepository _repository;
  final String workspaceId;
  final String projectId;
  final String resourceKind;
  final String resourceId;

  Future<void> load() async {
    if (isClosed) return;
    final kind = _kindFor(resourceKind);
    if (kind == null) {
      emit(const WorkspaceResourceAccessNotFound());
      return;
    }
    emit(const WorkspaceResourceAccessLoading());
    final result = await _loadKind(kind);
    if (isClosed) return;
    result.fold(
      (error) => emit(_failure(error)),
      (items) {
        final item = items.where((candidate) => candidate.id == resourceId);
        emit(
          item.isEmpty
              ? const WorkspaceResourceAccessNotFound()
              : WorkspaceResourceAccessGranted(item.first),
        );
      },
    );
  }

  ProjectResourceKind? _kindFor(String value) => switch (value) {
    'tasks' => ProjectResourceKind.tasks,
    'whiteboards' => ProjectResourceKind.whiteboards,
    'wiki' => ProjectResourceKind.wiki,
    'files' => ProjectResourceKind.files,
    'automations' => ProjectResourceKind.automations,
    _ => null,
  };

  Future<Either<ApiError, List<ProjectResourceListItem>>> _loadKind(
    ProjectResourceKind kind,
  ) => switch (kind) {
    ProjectResourceKind.tasks => _repository.listTasks(
      workspaceId: workspaceId,
      projectId: projectId,
    ),
    ProjectResourceKind.whiteboards => _repository.listWhiteboards(
      workspaceId: workspaceId,
      projectId: projectId,
    ),
    ProjectResourceKind.wiki => _repository.listWikiPages(
      workspaceId: workspaceId,
      projectId: projectId,
    ),
    ProjectResourceKind.files => _repository.listProjectFolders(
      workspaceId: workspaceId,
      projectId: projectId,
    ),
    ProjectResourceKind.automations => _repository.listAutomations(
      workspaceId: workspaceId,
      projectId: projectId,
    ),
  };

  WorkspaceResourceAccessFailure _failure(ApiError error) =>
      WorkspaceResourceAccessFailure(
        message: error.message,
        backendCode: error.backendCode?.toString(),
      );
}
