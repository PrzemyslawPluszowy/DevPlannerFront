import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'project_general_settings_state.dart';

/// Cubit odpowiedzialny za odczyt i aktualizację danych ogólnych projektu oraz jego cyklu życia.
class ProjectGeneralSettingsCubit extends Cubit<ProjectGeneralSettingsState> {
  ProjectGeneralSettingsCubit({
    required this.workspaceId,
    required this.projectId,
    required this._repository,
  }) : super(const ProjectGeneralSettingsLoading());

  final String workspaceId;
  final String projectId;
  final ProjectsRepository _repository;

  /// Ładuje aktualne szczegóły projektu.
  Future<void> load({ProjectListItem? initialProject}) async {
    if (initialProject != null && initialProject.name.isNotEmpty) {
      emit(ProjectGeneralSettingsLoaded(project: initialProject));
    } else {
      emit(const ProjectGeneralSettingsLoading());
    }

    final result = await _repository.getProject(
      workspaceId: workspaceId,
      projectId: projectId,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (state is! ProjectGeneralSettingsLoaded) {
          emit(ProjectGeneralSettingsError(error: error));
        }
      },
      (project) => emit(ProjectGeneralSettingsLoaded(project: project)),
    );
  }

  /// Zapisuje zmodyfikowane dane ogólne projektu.
  Future<bool> saveDetails({
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
    required ProjectVisibility visibility,
    required ProjectStatus status,
  }) async {
    final current = state;
    if (current is! ProjectGeneralSettingsLoaded) return false;

    emit(current.copyWith(isSaving: true, clearSuccess: true));
    final result = await _repository.updateProject(
      workspaceId: workspaceId,
      projectId: projectId,
      name: name,
      description: description,
      icon: icon,
      primaryColor: primaryColor,
      visibility: visibility,
      status: status,
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error));
        return false;
      },
      (updatedProject) {
        emit(
          ProjectGeneralSettingsLoaded(
            project: updatedProject,
            saveSuccess: true,
          ),
        );
        return true;
      },
    );
  }

  /// Archiwizuje projekt.
  Future<bool> archiveProject() async {
    final current = state;
    if (current is! ProjectGeneralSettingsLoaded) return false;

    emit(current.copyWith(isSaving: true));
    final result = await _repository.archiveProject(
      workspaceId: workspaceId,
      projectId: projectId,
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error));
        return false;
      },
      (updated) {
        emit(ProjectGeneralSettingsLoaded(project: updated));
        return true;
      },
    );
  }

  /// Przywraca zarchiwizowany projekt.
  Future<bool> restoreProject() async {
    final current = state;
    if (current is! ProjectGeneralSettingsLoaded) return false;

    emit(current.copyWith(isSaving: true));
    final result = await _repository.restoreProject(
      workspaceId: workspaceId,
      projectId: projectId,
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error));
        return false;
      },
      (updated) {
        emit(ProjectGeneralSettingsLoaded(project: updated));
        return true;
      },
    );
  }

  /// Usuwa trwale zarchiwizowany projekt.
  Future<bool> deleteProject() async {
    final current = state;
    if (current is! ProjectGeneralSettingsLoaded) return false;

    emit(current.copyWith(isSaving: true));
    final result = await _repository.deleteProject(
      workspaceId: workspaceId,
      projectId: projectId,
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error));
        return false;
      },
      (_) => true,
    );
  }
}
