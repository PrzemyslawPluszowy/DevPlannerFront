import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/models/workspace_list_item.dart';
import 'package:ready_next/workspaces/domain/repositories/workspaces_repository.dart';

part 'workspace_general_settings_state.dart';

/// Odpowiada za odczyt i aktualizację danych podstawowych przestrzeni roboczej oraz jej cyklu życia.
class WorkspaceGeneralSettingsCubit
    extends Cubit<WorkspaceGeneralSettingsState> {
  WorkspaceGeneralSettingsCubit({
    required this.workspaceId,
    required this.repository,
  }) : super(const WorkspaceGeneralSettingsLoading());

  final String workspaceId;
  final WorkspacesRepository repository;

  /// Ładuje dane przestrzeni roboczej lub przyjmuje stan początkowy.
  Future<void> load({WorkspaceListItem? initialWorkspace}) async {
    if (initialWorkspace != null) {
      emit(WorkspaceGeneralSettingsLoaded(workspace: initialWorkspace));
      return;
    }

    emit(const WorkspaceGeneralSettingsLoading());
    final result = await repository.getWorkspace(workspaceId);

    if (isClosed) return;

    result.fold(
      (error) => emit(WorkspaceGeneralSettingsError(error: error)),
      (workspace) => emit(WorkspaceGeneralSettingsLoaded(workspace: workspace)),
    );
  }

  /// Zapisuje nazwę, opis, ikonę i kolor przestrzeni roboczej.
  Future<bool> saveDetails({
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
  }) async {
    final current = state;
    if (current is! WorkspaceGeneralSettingsLoaded || current.isSaving) {
      return false;
    }

    emit(
      current.copyWith(isSaving: true, clearSuccess: true, clearError: true),
    );

    final result = await repository.updateWorkspace(
      workspaceId: workspaceId,
      name: name,
      description: description,
      icon: icon,
      primaryColor: primaryColor,
    );

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(current.copyWith(isSaving: false, error: error));
        return false;
      },
      (updatedWorkspace) {
        emit(
          current.copyWith(
            workspace: updatedWorkspace,
            isSaving: false,
            saveSuccess: true,
          ),
        );
        return true;
      },
    );
  }

  /// Archiwizuje przestrzeń roboczą.
  Future<bool> archiveWorkspace() async {
    final current = state;
    if (current is! WorkspaceGeneralSettingsLoaded || current.isArchiving) {
      return false;
    }

    emit(current.copyWith(isArchiving: true, clearError: true));

    final result = await repository.archiveWorkspace(workspaceId);

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(current.copyWith(isArchiving: false, error: error));
        return false;
      },
      (updatedWorkspace) {
        emit(
          current.copyWith(
            workspace: updatedWorkspace,
            isArchiving: false,
          ),
        );
        return true;
      },
    );
  }

  /// Przywraca zarchiwizowaną przestrzeń roboczą.
  Future<bool> restoreWorkspace() async {
    final current = state;
    if (current is! WorkspaceGeneralSettingsLoaded || current.isArchiving) {
      return false;
    }

    emit(current.copyWith(isArchiving: true, clearError: true));

    final result = await repository.restoreWorkspace(workspaceId);

    if (isClosed) return false;

    return result.fold(
      (error) {
        emit(current.copyWith(isArchiving: false, error: error));
        return false;
      },
      (updatedWorkspace) {
        emit(
          current.copyWith(
            workspace: updatedWorkspace,
            isArchiving: false,
          ),
        );
        return true;
      },
    );
  }
}
