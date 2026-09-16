import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_visibility.dart';
import 'package:ready_next/workspaces/domain/models/project_list_item.dart';
import 'package:ready_next/workspaces/domain/repositories/projects_repository.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_projects_state.dart';

/// Lokalny Cubit jednego rozwiniętego workspace’u.
///
/// Nie pobiera projektów globalnie. Dzięki temu duże katalogi nie wykonują
/// lawiny żądań przy starcie aplikacji, a błąd jest przypięty do właściwego
/// węzła menu.
final class WorkspaceProjectsCubit extends Cubit<WorkspaceProjectsState> {
  WorkspaceProjectsCubit({
    required this._repository,
    required this.workspaceId,
  }) : super(const WorkspaceProjectsInitial());

  final ProjectsRepository _repository;
  final String workspaceId;

  Future<void> load({bool force = false}) async {
    if (isClosed) return;
    if (!force &&
        (state is WorkspaceProjectsLoading ||
            state is WorkspaceProjectsReady)) {
      return;
    }
    emit(const WorkspaceProjectsLoading());
    final result = await _repository.listProjects(workspaceId);
    if (isClosed) return;
    result.fold(
      (error) => emit(
        WorkspaceProjectsFailure(
          message: error.message,
          backendCode: error.backendCode?.toString(),
        ),
      ),
      (items) => emit(
        items.isEmpty
            ? const WorkspaceProjectsEmpty()
            : WorkspaceProjectsReady(List.unmodifiable(items)),
      ),
    );
  }

  /// Tworzy projekt na backendzie i natychmiast odświeża listę projektów.
  Future<Either<ApiError, ProjectListItem>> createProject({
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
    ProjectVisibility visibility = ProjectVisibility.shared,
    ProjectStatus status = ProjectStatus.active,
  }) async {
    final result = await _repository.createProject(
      workspaceId: workspaceId,
      name: name,
      description: description,
      icon: icon,
      primaryColor: primaryColor,
      visibility: visibility,
      status: status,
    );
    if (!isClosed) {
      await load(force: true);
    }
    return result;
  }

  /// Zapisuje nową kolejność projektów użytkownika na backendzie z optymistyczną aktualizacją UI.
  Future<void> reorderProjects(List<String> projectIds) async {
    if (isClosed) return;
    final current = state;
    if (current is! WorkspaceProjectsReady) return;

    final byId = {for (final p in current.items) p.id: p};
    final reordered = [
      for (final id in projectIds)
        if (byId.containsKey(id)) byId[id]!,
      for (final p in current.items)
        if (!projectIds.contains(p.id)) p,
    ];
    emit(WorkspaceProjectsReady(List.unmodifiable(reordered)));

    final result = await _repository.updateProjectOrder(
      workspaceId: workspaceId,
      projectIds: projectIds,
    );
    if (isClosed) return;
    result.fold(
      (error) => emit(
        WorkspaceProjectsFailure(
          message: error.message,
          backendCode: error.backendCode?.toString(),
        ),
      ),
      (items) => emit(
        items.isEmpty
            ? const WorkspaceProjectsEmpty()
            : WorkspaceProjectsReady(List.unmodifiable(items)),
      ),
    );
  }
}
