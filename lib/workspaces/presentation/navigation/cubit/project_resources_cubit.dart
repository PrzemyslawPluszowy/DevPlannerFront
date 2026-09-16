import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/models/project_resource_list_item.dart';
import 'package:ready_next/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/project_resources_state.dart';

/// Lokalny Cubit jednej gałęzi zasobów projektu.
///
/// Instancja jest tworzona przy pozycji menu i ładuje dane wyłącznie przy
/// pierwszym rozwinięciu. Dzięki temu katalog wielu projektów nie wykonuje
/// serii żądań zanim użytkownik wybierze konkretną gałąź.
final class ProjectResourcesCubit extends Cubit<ProjectResourcesState> {
  ProjectResourcesCubit({
    required this._repository,
    required this.workspaceId,
    required this.projectId,
    required this.kind,
  }) : super(const ProjectResourcesInitial());

  final ProjectResourcesRepository _repository;
  final String workspaceId;
  final String projectId;
  final ProjectResourceKind kind;
  bool _hasLoaded = false;

  /// Pobiera zasoby tylko raz na cykl życia gałęzi menu.
  Future<void> load() async {
    if (isClosed || _hasLoaded) return;
    _hasLoaded = true;
    emit(const ProjectResourcesLoading());

    final result = switch (kind) {
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
    final resolved = await result;
    if (isClosed) return;
    resolved.fold(
      (error) {
        _hasLoaded = false;
        emit(_failure(error));
      },
      (items) => emit(
        items.isEmpty
            ? const ProjectResourcesEmpty()
            : ProjectResourcesReady(List.unmodifiable(items)),
      ),
    );
  }

  /// Wymusza ponowne pobranie zasobów po dodaniu lub modyfikacji elementu.
  Future<void> reload() async {
    _hasLoaded = false;
    await load();
  }

  ProjectResourcesFailure _failure(ApiError error) => ProjectResourcesFailure(
    message: error.message,
    backendCode: error.backendCode?.toString(),
  );
}
