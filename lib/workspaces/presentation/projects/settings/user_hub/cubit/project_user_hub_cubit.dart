import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'project_user_hub_state.dart';

/// Cubit zarządzający stanem i preferencjami w Panelu Użytkownika Projektu.
final class ProjectUserHubCubit extends Cubit<ProjectUserHubState> {
  ProjectUserHubCubit({
    required this.workspaceId,
    required this.projectId,
    required this.repository,
  }) : super(const ProjectUserHubLoading());

  final String workspaceId;
  final String projectId;
  final ProjectsRepository repository;

  /// Inicjalizuje dane projektu w panelu użytkownika.
  Future<void> load({ProjectListItem? initialProject}) async {
    final effectiveInitialPinned = initialProject?.isPinned ?? false;
    final effectiveInitialHidden = initialProject?.isHidden ?? false;

    if (initialProject != null) {
      emit(
        ProjectUserHubReady(
          project: initialProject,
          isPinned: effectiveInitialPinned,
          isHidden: effectiveInitialHidden,
        ),
      );
    } else {
      emit(const ProjectUserHubLoading());
    }

    final result = await repository.getProject(
      workspaceId: workspaceId,
      projectId: projectId,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (state is! ProjectUserHubReady) {
          emit(ProjectUserHubFailure(error.message));
        }
      },
      (project) {
        // Backend `getProject` zwraca model projektu bez preferencji użytkownika.
        // Zachowujemy stan preferencji z aktualnego stanu lub initialProject.
        final currentReady = state is ProjectUserHubReady
            ? state as ProjectUserHubReady
            : null;
        final preservedPinned =
            currentReady?.isPinned ?? effectiveInitialPinned;
        final preservedHidden =
            currentReady?.isHidden ?? effectiveInitialHidden;

        emit(
          ProjectUserHubReady(
            project: project.copyWith(
              isPinned: preservedPinned,
              isHidden: preservedHidden,
            ),
            isPinned: preservedPinned,
            isHidden: preservedHidden,
          ),
        );
      },
    );
  }

  /// Zmienia przypięcie projektu w ulubionych użytkownika.
  Future<void> togglePin(bool isPinned) async {
    final currentState = state;
    if (currentState is! ProjectUserHubReady || currentState.isSaving) return;

    emit(
      currentState.copyWith(
        isPinned: isPinned,
        isSaving: true,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final result = await repository.updateProjectPreference(
      workspaceId: workspaceId,
      projectId: projectId,
      isPinned: isPinned,
      isHidden: currentState.isHidden,
    );

    if (isClosed) return;

    result.fold(
      (error) => emit(
        currentState.copyWith(
          isPinned: !isPinned,
          isSaving: false,
          error: error.message,
        ),
      ),
      (preference) => emit(
        currentState.copyWith(
          isPinned: preference.isPinned,
          isHidden: preference.isHidden,
          isSaving: false,
          successMessage: preference.isPinned
              ? 'Projekt przypięty do ulubionych.'
              : 'Projekt odpięty z ulubionych.',
        ),
      ),
    );
  }

  /// Zmienia ukrycie projektu w menu użytkownika.
  Future<void> toggleHide(bool isHidden) async {
    final currentState = state;
    if (currentState is! ProjectUserHubReady || currentState.isSaving) return;

    emit(
      currentState.copyWith(
        isHidden: isHidden,
        isSaving: true,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final result = await repository.updateProjectPreference(
      workspaceId: workspaceId,
      projectId: projectId,
      isPinned: currentState.isPinned,
      isHidden: isHidden,
    );

    if (isClosed) return;

    result.fold(
      (error) => emit(
        currentState.copyWith(
          isHidden: !isHidden,
          isSaving: false,
          error: error.message,
        ),
      ),
      (preference) => emit(
        currentState.copyWith(
          isPinned: preference.isPinned,
          isHidden: preference.isHidden,
          isSaving: false,
          successMessage: preference.isHidden
              ? 'Projekt ukryty z bocznego menu.'
              : 'Projekt przywrócony do bocznego menu.',
        ),
      ),
    );
  }

  /// Pozwala użytkownikowi opuścić jawne członkostwo w projekcie.
  Future<void> leaveProject() async {
    final currentState = state;
    if (currentState is! ProjectUserHubReady || currentState.isLeaving) return;

    final projectVisibility = currentState.project.visibility;

    emit(
      currentState.copyWith(
        isLeaving: true,
        clearError: true,
        clearSuccess: true,
      ),
    );

    final result = await repository.leaveProject(
      workspaceId: workspaceId,
      projectId: projectId,
    );

    if (isClosed) return;

    result.fold(
      (error) => emit(
        currentState.copyWith(
          isLeaving: false,
          error: error.message,
        ),
      ),
      (_) => emit(
        ProjectUserHubLeftSuccess(visibility: projectVisibility),
      ),
    );
  }
}
