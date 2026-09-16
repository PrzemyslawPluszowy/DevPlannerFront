import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:ready_next/workspaces/domain/repositories/project_templates_repository.dart';

part 'project_templates_state.dart';

/// Cubit zarządzający listą i operacjami na szablonach projektów (list, create, refresh, delete, apply, details).
final class ProjectTemplatesCubit extends Cubit<ProjectTemplatesState> {
  ProjectTemplatesCubit({
    required this.workspaceId,
    required this.projectId,
    required this.repository,
  }) : super(const ProjectTemplatesLoading());

  final String workspaceId;
  final String projectId;
  final ProjectTemplatesRepository repository;

  /// Pobiera listę szablonów w workspace.
  Future<void> load() async {
    emit(const ProjectTemplatesLoading());
    final result = await repository.listTemplates(workspaceId);

    if (isClosed) return;

    result.fold(
      (error) => emit(ProjectTemplatesFailure(error.message)),
      (templates) => emit(ProjectTemplatesReady(templates: templates)),
    );
  }

  /// Pobiera pełne szczegóły pojedynczego szablonu (workflow, pola, etykiety, zadania).
  Future<ProjectTemplateDetailsResponse?> getTemplateDetails(
    String templateId,
  ) async {
    final result = await repository.getTemplateDetails(
      workspaceId: workspaceId,
      templateId: templateId,
    );

    return result.fold(
      (error) => null,
      (details) => details,
    );
  }

  /// Tworzy nowy szablon z bieżącego projektu.
  Future<bool> createTemplateFromCurrentProject(String name) async {
    final currentState = state;
    if (currentState is! ProjectTemplatesReady || currentState.isSaving) {
      return false;
    }

    emit(
      currentState.copyWith(
        isSaving: true,
        clearError: true,
        clearSuccess: true,
      ),
    );
    final result = await repository.createTemplateFromProject(
      workspaceId: workspaceId,
      projectId: projectId,
      name: name,
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(currentState.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (newTemplate) {
        final updatedList = [...currentState.templates, newTemplate];
        emit(
          currentState.copyWith(
            templates: updatedList,
            isSaving: false,
            actionSuccess: ProjectTemplateActionType.created,
          ),
        );
        return true;
      },
    );
  }

  /// Odświeża istniejący szablon danymi z bieżącego projektu.
  Future<bool> refreshTemplate({
    required String templateId,
    required String name,
    required int expectedVersion,
  }) async {
    final currentState = state;
    if (currentState is! ProjectTemplatesReady || currentState.isSaving) {
      return false;
    }

    emit(
      currentState.copyWith(
        isSaving: true,
        clearError: true,
        clearSuccess: true,
      ),
    );
    final result = await repository.refreshTemplate(
      workspaceId: workspaceId,
      templateId: templateId,
      projectId: projectId,
      name: name,
      expectedVersion: expectedVersion,
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(currentState.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (refreshed) {
        final updatedList = currentState.templates.map((t) {
          if (t.id == templateId) {
            return ProjectTemplateResponse(
              id: refreshed.id,
              name: refreshed.name,
              updatedAtUtc: refreshed.updatedAtUtc,
              version: refreshed.version,
            );
          }
          return t;
        }).toList();
        emit(
          currentState.copyWith(
            templates: updatedList,
            isSaving: false,
            actionSuccess: ProjectTemplateActionType.refreshed,
          ),
        );
        return true;
      },
    );
  }

  /// Usuwa szablon projektu.
  Future<bool> deleteTemplate({
    required String templateId,
    required int expectedVersion,
  }) async {
    final currentState = state;
    if (currentState is! ProjectTemplatesReady || currentState.isSaving) {
      return false;
    }

    emit(
      currentState.copyWith(
        isSaving: true,
        clearError: true,
        clearSuccess: true,
      ),
    );
    final result = await repository.deleteTemplate(
      workspaceId: workspaceId,
      templateId: templateId,
      expectedVersion: expectedVersion,
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(currentState.copyWith(isSaving: false, error: error.message));
        return false;
      },
      (_) {
        final updatedList = currentState.templates
            .where((t) => t.id != templateId)
            .toList();
        emit(
          currentState.copyWith(
            templates: updatedList,
            isSaving: false,
            actionSuccess: ProjectTemplateActionType.deleted,
          ),
        );
        return true;
      },
    );
  }

  /// Tworzy nowy projekt na podstawie szablonu.
  Future<ApplyProjectTemplateResponse?> applyTemplate({
    required String templateId,
    required String newProjectName,
  }) async {
    final currentState = state;
    if (currentState is! ProjectTemplatesReady || currentState.isSaving) {
      return null;
    }

    emit(
      currentState.copyWith(
        isSaving: true,
        clearError: true,
        clearSuccess: true,
      ),
    );
    final result = await repository.applyTemplate(
      workspaceId: workspaceId,
      templateId: templateId,
      newProjectName: newProjectName,
    );

    if (isClosed) return null;

    return result.fold(
      (error) {
        emit(currentState.copyWith(isSaving: false, error: error.message));
        return null;
      },
      (response) {
        emit(
          currentState.copyWith(
            isSaving: false,
            actionSuccess: ProjectTemplateActionType.applied,
          ),
        );
        return response;
      },
    );
  }
}
