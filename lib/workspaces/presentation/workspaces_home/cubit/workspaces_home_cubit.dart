import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/models/workspace_list_item.dart';
import 'package:ready_next/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/cubit/workspaces_home_state.dart';

/// Cubit odpowiedzialny wyłącznie za pobranie listy workspace’ów.
class WorkspacesHomeCubit extends Cubit<WorkspacesHomeState> {
  /// Tworzy lokalny Cubit ekranu startowego Workspaces.
  WorkspacesHomeCubit({required this._repository})
    : super(const WorkspacesHomeInitial());

  final WorkspacesRepository _repository;

  /// Pobiera aktywne workspace’y użytkownika.
  Future<void> load() async {
    if (isClosed) return;
    emit(const WorkspacesHomeLoading());

    final result = await _repository.listWorkspaces(includeHidden: true);
    if (isClosed) return;

    result.fold(
      (error) => emit(_stateForError(error)),
      (items) {
        final visible = items
            .where((item) => !item.isHidden)
            .toList(growable: false);
        final hidden = items
            .where((item) => item.isHidden)
            .toList(growable: false);
        if (visible.isEmpty && hidden.isEmpty) {
          emit(const WorkspacesHomeEmpty());
        } else {
          emit(
            WorkspacesHomeLoaded(
              List.unmodifiable(visible),
              hiddenItems: List.unmodifiable(hidden),
            ),
          );
        }
      },
    );
  }

  /// Filtruje widoczną listę workspace’ów na podstawie wpisanej frazy.
  void filter(String query) {
    final current = state;
    if (current is! WorkspacesHomeLoaded || isClosed) return;
    emit(
      WorkspacesHomeLoaded(
        current.items,
        hiddenItems: current.hiddenItems,
        searchQuery: query,
      ),
    );
  }

  /// Tworzy nowy workspace i odświeża katalog po sukcesie backendu.
  Future<WorkspaceListItem?> createWorkspace({
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
  }) async {
    if (isClosed) return null;
    emit(const WorkspacesHomeLoading());
    final result = await _repository.createWorkspace(
      name: name,
      description: description,
      icon: icon,
      primaryColor: primaryColor,
    );
    if (isClosed) return null;
    WorkspaceListItem? created;
    await result.fold(
      (error) async => emit(_stateForError(error)),
      (item) async {
        created = item;
        await load();
      },
    );
    return created;
  }

  /// Aktualizuje dane workspace’u (nazwa, opis, ikona, kolor) optymistycznie.
  Future<bool> updateWorkspace({
    required String workspaceId,
    required String name,
    String? description,
    String? icon,
    String? primaryColor,
  }) async {
    final previous = state;
    if (previous is! WorkspacesHomeLoaded || isClosed) return false;
    final optimisticVisible = previous.items
        .map(
          (item) => item.id == workspaceId
              ? item.copyWith(
                  name: name,
                  description: description,
                  icon: icon,
                  primaryColor: primaryColor,
                )
              : item,
        )
        .toList(growable: false);
    final optimisticHidden = previous.hiddenItems
        .map(
          (item) => item.id == workspaceId
              ? item.copyWith(
                  name: name,
                  description: description,
                  icon: icon,
                  primaryColor: primaryColor,
                )
              : item,
        )
        .toList(growable: false);
    emit(
      WorkspacesHomeLoaded(
        optimisticVisible,
        hiddenItems: optimisticHidden,
        searchQuery: previous.searchQuery,
      ),
    );

    final result = await _repository.updateWorkspace(
      workspaceId: workspaceId,
      name: name,
      description: description,
      icon: icon,
      primaryColor: primaryColor,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        emit(previous);
        return false;
      },
      (updated) => true,
    );
  }

  /// Zapisuje przypięcie workspace’u optymistycznie z rollbackiem w przypadku błędu.
  Future<void> setPinned(String workspaceId, bool isPinned) async {
    final previous = state;
    if (previous is! WorkspacesHomeLoaded || isClosed) return;
    final optimisticVisible = previous.items
        .map(
          (item) =>
              item.id == workspaceId ? item.copyWith(isPinned: isPinned) : item,
        )
        .toList(growable: false);
    final optimisticHidden = previous.hiddenItems
        .map(
          (item) =>
              item.id == workspaceId ? item.copyWith(isPinned: isPinned) : item,
        )
        .toList(growable: false);
    emit(
      WorkspacesHomeLoaded(
        List.unmodifiable(optimisticVisible),
        hiddenItems: List.unmodifiable(optimisticHidden),
      ),
    );
    final result = await _repository.updateWorkspacePreference(
      workspaceId: workspaceId,
      isPinned: isPinned,
    );
    if (isClosed) return;
    result.fold(
      (error) {
        emit(previous);
        emit(_stateForError(error));
      },
      (_) {},
    );
  }

  /// Ukrywa workspace optymistycznie na osobistej liście bieżącego użytkownika.
  Future<void> hideWorkspace(String workspaceId) async {
    final previous = state;
    if (previous is! WorkspacesHomeLoaded || isClosed) return;
    final target = previous.items
        .where((item) => item.id == workspaceId)
        .firstOrNull;
    if (target == null) return;
    final newVisible = previous.items
        .where((item) => item.id != workspaceId)
        .toList(growable: false);
    final updatedTarget = target.copyWith(isHidden: true);
    final newHidden = [...previous.hiddenItems, updatedTarget];
    if (newVisible.isEmpty && newHidden.isEmpty) {
      emit(const WorkspacesHomeEmpty());
    } else {
      emit(
        WorkspacesHomeLoaded(
          List.unmodifiable(newVisible),
          hiddenItems: List.unmodifiable(newHidden),
        ),
      );
    }
    final result = await _repository.updateWorkspacePreference(
      workspaceId: workspaceId,
      isHidden: true,
    );
    if (isClosed) return;
    result.fold(
      (error) {
        emit(previous);
        emit(_stateForError(error));
      },
      (_) {},
    );
  }

  /// Przywraca workspace optymistycznie do osobistej listy widocznych elementów.
  Future<void> restoreWorkspace(String workspaceId) async {
    final previous = state;
    if (previous is! WorkspacesHomeLoaded || isClosed) return;
    final target = previous.hiddenItems
        .where((item) => item.id == workspaceId)
        .firstOrNull;
    if (target == null) return;
    final newHidden = previous.hiddenItems
        .where((item) => item.id != workspaceId)
        .toList(growable: false);
    final updatedTarget = target.copyWith(isHidden: false);
    final newVisible = [...previous.items, updatedTarget];
    emit(
      WorkspacesHomeLoaded(
        List.unmodifiable(newVisible),
        hiddenItems: List.unmodifiable(newHidden),
      ),
    );
    final result = await _repository.updateWorkspacePreference(
      workspaceId: workspaceId,
      isHidden: false,
    );
    if (isClosed) return;
    result.fold(
      (error) {
        emit(previous);
        emit(_stateForError(error));
      },
      (_) {},
    );
  }

  /// Ustawia osobistą widoczność workspace’u bez zmiany jego członkostwa.
  Future<void> setHidden(String workspaceId, bool isHidden) async {
    if (isHidden) {
      await hideWorkspace(workspaceId);
    } else {
      await restoreWorkspace(workspaceId);
    }
  }

  /// Zapisuje pełną kolejność widocznych workspace’ów z rollbackiem błędu.
  Future<void> reorderWorkspaces(List<String> workspaceIds) async {
    final previous = state;
    if (previous is! WorkspacesHomeLoaded || isClosed) return;
    // Backend waliduje, że payload zawiera dokładnie wszystkie aktualnie
    // widoczne workspace’y. Odświeżamy ten zbiór tuż przed zapisem, ponieważ
    // preferencje (ukrycie/przywrócenie) mogły zmienić się na innym urządzeniu
    // albo w innej karcie przeglądarki.
    final authoritative = await _repository.listWorkspaces();
    if (isClosed) return;
    List<WorkspaceListItem>? visibleItems;
    var refreshFailed = false;
    authoritative.fold(
      (error) {
        refreshFailed = true;
        emit(_stateForError(error));
      },
      (items) => visibleItems = items,
    );
    if (refreshFailed || visibleItems == null) {
      return;
    }
    final byId = {for (final item in visibleItems!) item.id: item};
    final visibleIds = byId.keys.toSet();
    final normalizedIds = <String>[];
    for (final id in workspaceIds) {
      if (visibleIds.contains(id) && !normalizedIds.contains(id)) {
        normalizedIds.add(id);
      }
    }
    for (final id in visibleIds) {
      if (!normalizedIds.contains(id)) normalizedIds.add(id);
    }
    final optimistic = [
      for (final id in normalizedIds) byId[id]!,
    ];
    emit(
      WorkspacesHomeLoaded(
        List.unmodifiable(optimistic),
        hiddenItems: previous.hiddenItems,
      ),
    );
    final result = await _repository.updateWorkspaceOrder(normalizedIds);
    if (isClosed) return;
    result.fold(
      (error) {
        emit(previous);
        emit(_stateForError(error));
      },
      (items) => emit(
        WorkspacesHomeLoaded(
          List.unmodifiable(items),
          hiddenItems: previous.hiddenItems,
        ),
      ),
    );
  }

  WorkspacesHomeState _stateForError(ApiError error) {
    final backendCode = error.backendCode?.toString();
    if (error.type == ApiErrorType.unauthorized) {
      return WorkspacesHomeUnauthorized(
        message: error.message,
        backendCode: backendCode,
      );
    }
    if (error.type == ApiErrorType.forbidden) {
      return WorkspacesHomeForbidden(
        message: error.message,
        backendCode: backendCode,
      );
    }
    return WorkspacesHomeFailure(
      message: error.message,
      backendCode: backendCode,
    );
  }
}
