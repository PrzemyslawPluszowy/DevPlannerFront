import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/cubit/project_resource_creation_command_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Obsługuje zapis nowego projektu bez wiązania logiki z widgetem formularza.
final class CreateProjectCommandCubit
    extends Cubit<ProjectResourceCreationCommandState> {
  CreateProjectCommandCubit(this._repository)
    : super(const ProjectResourceCreationCommandState.idle());

  final ProjectsRepository _repository;

  Future<void> submit({
    required String workspaceId,
    required String name,
    required String? description,
    required String icon,
    required String primaryColorHex,
    required ProjectVisibility visibility,
  }) async {
    if (state.isSubmitting) return;
    emit(const ProjectResourceCreationCommandState.submitting());
    final result = await _repository.createProject(
      workspaceId: workspaceId,
      name: name,
      description: description,
      icon: icon,
      primaryColor: primaryColorHex,
      visibility: visibility,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(ProjectResourceCreationCommandState.failure(error)),
      (project) =>
          emit(ProjectResourceCreationCommandState.success(project.id)),
    );
  }
}

/// Obsługuje zapis nowej tablicy Whiteboard.
final class CreateWhiteboardCommandCubit
    extends Cubit<ProjectResourceCreationCommandState> {
  CreateWhiteboardCommandCubit(this._repository)
    : super(const ProjectResourceCreationCommandState.idle());

  final ProjectResourcesRepository _repository;

  Future<void> submit({
    required String workspaceId,
    required String projectId,
    required String name,
    required String? description,
    required String type,
  }) async {
    if (state.isSubmitting) return;
    emit(const ProjectResourceCreationCommandState.submitting());
    final result = await _repository.createWhiteboard(
      workspaceId: workspaceId,
      projectId: projectId,
      name: name,
      description: description,
      type: type,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(ProjectResourceCreationCommandState.failure(error)),
      (board) => emit(ProjectResourceCreationCommandState.success(board.id)),
    );
  }
}

/// Obsługuje zapis nowego zadania projektu.
final class CreateProjectTaskCommandCubit
    extends Cubit<ProjectResourceCreationCommandState> {
  CreateProjectTaskCommandCubit(this._repository)
    : super(const ProjectResourceCreationCommandState.idle());

  final ProjectResourcesRepository _repository;

  Future<void> submit({
    required String workspaceId,
    required String projectId,
    required String title,
    required String? description,
    required String priority,
    required String status,
  }) async {
    if (state.isSubmitting) return;
    emit(const ProjectResourceCreationCommandState.submitting());
    final result = await _repository.createTask(
      workspaceId: workspaceId,
      projectId: projectId,
      title: title,
      description: description,
      priority: priority,
      status: status,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(ProjectResourceCreationCommandState.failure(error)),
      (task) => emit(ProjectResourceCreationCommandState.success(task.id)),
    );
  }
}

/// Obsługuje zapis nowej strony Wiki projektu.
final class CreateWikiPageCommandCubit
    extends Cubit<ProjectResourceCreationCommandState> {
  CreateWikiPageCommandCubit(this._repository)
    : super(const ProjectResourceCreationCommandState.idle());

  final ProjectResourcesRepository _repository;

  Future<void> submit({
    required String workspaceId,
    required String projectId,
    required String title,
  }) async {
    if (state.isSubmitting) return;
    emit(const ProjectResourceCreationCommandState.submitting());
    final result = await _repository.createWikiPage(
      workspaceId: workspaceId,
      projectId: projectId,
      title: title,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(ProjectResourceCreationCommandState.failure(error)),
      (page) => emit(ProjectResourceCreationCommandState.success(page.id)),
    );
  }
}

/// Obsługuje zapis karty na tablicy korkowej projektu.
final class CreateCorkboardCardCommandCubit
    extends Cubit<ProjectResourceCreationCommandState> {
  CreateCorkboardCardCommandCubit(this._repository)
    : super(const ProjectResourceCreationCommandState.idle());

  final ProjectResourcesRepository _repository;

  Future<void> submit({
    required String workspaceId,
    required String projectId,
    required String title,
    required String? content,
    required String colorHex,
  }) async {
    if (state.isSubmitting) return;
    emit(const ProjectResourceCreationCommandState.submitting());
    final result = await _repository.createCorkboardCard(
      workspaceId: workspaceId,
      projectId: projectId,
      title: title,
      content: content,
      colorHex: colorHex,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(ProjectResourceCreationCommandState.failure(error)),
      (cardId) => emit(ProjectResourceCreationCommandState.success(cardId)),
    );
  }
}

/// Obsługuje zapis nowego folderu w Storage projektu.
final class CreateProjectFolderCommandCubit
    extends Cubit<ProjectResourceCreationCommandState> {
  CreateProjectFolderCommandCubit(this._repository)
    : super(const ProjectResourceCreationCommandState.idle());

  final ProjectResourcesRepository _repository;

  Future<void> submit({
    required String workspaceId,
    required String projectId,
    required String name,
  }) async {
    if (state.isSubmitting) return;
    emit(const ProjectResourceCreationCommandState.submitting());
    final result = await _repository.createProjectFolder(
      workspaceId: workspaceId,
      projectId: projectId,
      name: name,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(ProjectResourceCreationCommandState.failure(error)),
      (folder) => emit(ProjectResourceCreationCommandState.success(folder.id)),
    );
  }
}
