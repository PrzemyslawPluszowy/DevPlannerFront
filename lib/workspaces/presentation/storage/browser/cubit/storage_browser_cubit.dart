import 'dart:async';

import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_breadcrumb_resolver.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/shared/storage_formatters.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'storage_browser_cubit_view_state.dart';

/// Cubit zarządzający widokiem eksploratora plików, nawigacją po folderach,
/// paginacją kursorową, filtrami i sortowaniem.
final class StorageBrowserCubit extends Cubit<StorageBrowserState> {
  /// Tworzy instancję cubita z początkowym zakresem.
  StorageBrowserCubit({
    required this.repository,
    StorageScope initialScope = const StorageScope.personal(),
    StorageViewMode initialViewMode = StorageViewMode.grid,
  }) : super(
         StorageBrowserInitial(
           scope: initialScope,
           viewMode: initialViewMode,
         ),
       );

  final StorageRepository repository;
  int _requestGeneration = 0;
  String? _searchQuery;
  final Map<String, String?> _folderParents = {};

  /// Ładuje dane dla bieżącego zakresu i folderu.
  Future<void> load({bool showLoading = true}) async {
    final requestGeneration = ++_requestGeneration;
    final scope = currentScope;
    final filter = currentFilter;
    final sort = currentSort;
    final viewMode = currentViewMode;

    if (showLoading) {
      emit(
        StorageBrowserLoading(
          scope: scope,
          filter: filter,
          sort: sort,
          viewMode: viewMode,
        ),
      );
    }

    StorageFolderResponse? folderDetails;
    var breadcrumbs = [
      StorageBreadcrumbItem(
        name: StorageBreadcrumbResolver(repository).rootName(scope),
      ),
    ];
    if (scope.folderId != null) {
      try {
        final resolved = await StorageBreadcrumbResolver(repository)
            .resolve(scope);
        folderDetails = resolved.currentFolder;
        breadcrumbs = resolved.breadcrumbs;
      } on Exception {
        // Brak przodka nie może ukryć zawartości dostępnego folderu.
      }
      if (isClosed || requestGeneration != _requestGeneration) return;
    }

    final foldersResult = await repository.listFolders(
      scope: scope,
      parentFolderId: scope.folderId,
    );
    if (isClosed || requestGeneration != _requestGeneration) return;

    if (foldersResult.isLeft()) {
      foldersResult.leftMap((err) {
        if (err.statusCode == 403) {
          emit(
            StorageBrowserForbidden(
              scope: scope,
              message: err.message,
            ),
          );
        } else {
          emit(
            StorageBrowserFailure(
              scope: scope,
              message: err.message,
              statusCode: err.statusCode,
              backendCode: err.backendCode,
            ),
          );
        }
      });
      return;
    }

    final filesResult = await repository.listFiles(
      scope: scope,
      folderId: scope.folderId,
      filter: filter,
      query: _searchQuery,
    );
    if (isClosed || requestGeneration != _requestGeneration) return;

    if (filesResult.isLeft()) {
      filesResult.leftMap((err) {
        if (err.statusCode == 403) {
          emit(
            StorageBrowserForbidden(
              scope: scope,
              message: err.message,
            ),
          );
        } else {
          emit(
            StorageBrowserFailure(
              scope: scope,
              message: err.message,
              statusCode: err.statusCode,
              backendCode: err.backendCode,
            ),
          );
        }
      });
      return;
    }

    final folders = foldersResult.getOrElse(() => <StorageFolderResponse>[]);
    final filesPage = filesResult.getOrElse(
      () => const CursorPageResponse<StorageFileResponse>(items: []),
    );
    final files = filesPage.items;
    if (folders.isEmpty && files.isEmpty) {
      emit(
        StorageBrowserEmpty(
          scope: scope,
          currentFolder: folderDetails,
          breadcrumbs: breadcrumbs,
          filter: filter,
          sort: sort,
          viewMode: viewMode,
          searchQuery: _searchQuery,
        ),
      );
    } else {
      emit(
        StorageBrowserReady(
          scope: scope,
          currentFolder: folderDetails,
          breadcrumbs: breadcrumbs,
          folders: StorageFormatters.sortFolders(folders, sort),
          files: StorageFormatters.sortFiles(files, sort),
          nextCursor: filesPage.nextCursor,
          filter: filter,
          sort: sort,
          viewMode: viewMode,
          searchQuery: _searchQuery,
        ),
      );
    }
  }

  /// Dociąga kolejną stronę plików kursorowo.
  Future<void> loadNextPage() async {
    final currentState = state;
    if (currentState is! StorageBrowserReady ||
        !currentState.hasMore ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final result = await repository.listFiles(
      scope: currentState.scope,
      folderId: currentState.scope.folderId,
      cursor: currentState.nextCursor,
      filter: currentState.filter,
      query: currentState.searchQuery,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (page) {
        final mergedFiles = [...currentState.files, ...page.items];
        emit(
          currentState.copyWith(
            files: StorageFormatters.sortFiles(mergedFiles, currentState.sort),
            nextCursor: page.nextCursor,
            clearNextCursor: page.nextCursor == null,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  /// Zmienia bieżący zakres eksploratora.
  Future<void> setScope(StorageScope scope) async {
    _searchQuery = null;
    emit(
      StorageBrowserInitial(
        scope: scope,
        viewMode: currentViewMode,
      ),
    );
    await load();
  }

  /// Otwiera wskazany folder podrzędny.
  Future<void> openFolder(StorageFolderResponse folder) async {
    _folderParents[folder.id] = currentScope.folderId;
    final newScope = currentScope.copyWithFolder(folder.id);
    await setScope(newScope);
  }

  /// Wraca do folderu nadrzędnego albo do korzenia bieżącego zakresu.
  Future<void> navigateUp() async {
    final folderId = currentScope.folderId;
    if (folderId == null) return;
    await setScope(currentScope.copyWithFolder(_folderParents[folderId]));
  }

  /// Nawiguje do wskazanego elementu okruszków.
  Future<void> navigateToBreadcrumb(StorageBreadcrumbItem item) async {
    final newScope = currentScope.copyWithFolder(item.folderId);
    await setScope(newScope);
  }

  /// Zmienia filtry wyszukiwania.
  Future<void> setFilter(StorageBrowserFilter filter) async {
    final s = state;
    if (s is StorageBrowserReady) {
      emit(s.copyWith(filter: filter));
    } else if (s is StorageBrowserEmpty) {
      emit(
        StorageBrowserEmpty(
          scope: s.scope,
          currentFolder: s.currentFolder,
          breadcrumbs: s.breadcrumbs,
          filter: filter,
          sort: s.sort,
          viewMode: s.viewMode,
        ),
      );
    }
    await load();
  }

  /// Zmienia kryteria sortowania.
  void setSort(StorageSortCriteria sort) {
    final s = state;
    if (s is StorageBrowserReady) {
      emit(
        s.copyWith(
          sort: sort,
          folders: StorageFormatters.sortFolders(s.folders, sort),
          files: StorageFormatters.sortFiles(s.files, sort),
        ),
      );
    }
  }

  /// Przełącza tryb widoku (siatka / lista).
  void toggleViewMode() {
    final newMode = currentViewMode == StorageViewMode.grid
        ? StorageViewMode.list
        : StorageViewMode.grid;
    final s = state;
    if (s is StorageBrowserReady) {
      emit(s.copyWith(viewMode: newMode));
    } else if (s is StorageBrowserEmpty) {
      emit(
        StorageBrowserEmpty(
          scope: s.scope,
          currentFolder: s.currentFolder,
          breadcrumbs: s.breadcrumbs,
          filter: s.filter,
          sort: s.sort,
          viewMode: newMode,
        ),
      );
    } else if (s is StorageBrowserInitial) {
      emit(
        StorageBrowserInitial(
          scope: s.scope,
          filter: s.filter,
          sort: s.sort,
          viewMode: newMode,
        ),
      );
    }
  }

  /// Wyszukuje pliki po tekście.
  Future<void> search(String query) async {
    final trimmed = query.trim();
    final effectiveQuery = trimmed.isEmpty ? null : trimmed;
    _searchQuery = effectiveQuery;
    final requestGeneration = ++_requestGeneration;

    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (isClosed || requestGeneration != _requestGeneration) return;

    final s = state;
    if (s is StorageBrowserReady) {
      emit(
        s.copyWith(
          searchQuery: effectiveQuery,
          clearSearchQuery: effectiveQuery == null,
        ),
      );
    }

    emit(
      StorageBrowserLoading(
        scope: currentScope,
        filter: currentFilter,
        sort: currentSort,
        viewMode: currentViewMode,
      ),
    );

    final filesResult = await repository.listFiles(
      scope: currentScope,
      folderId: currentScope.folderId,
      filter: currentFilter,
      query: effectiveQuery,
    );
    if (isClosed || requestGeneration != _requestGeneration) return;

    filesResult.fold(
      (err) => emit(
        StorageBrowserFailure(
          scope: currentScope,
          message: err.message,
          statusCode: err.statusCode,
        ),
      ),
      (page) {
        final files = page.items;
        final breadcrumbs = [
          StorageBreadcrumbItem(
            name: StorageBreadcrumbResolver(repository).rootName(currentScope),
          ),
        ];
        if (files.isEmpty) {
          emit(
            StorageBrowserEmpty(
              scope: currentScope,
              breadcrumbs: breadcrumbs,
              filter: currentFilter,
              sort: currentSort,
              viewMode: currentViewMode,
              searchQuery: effectiveQuery,
            ),
          );
        } else {
          emit(
            StorageBrowserReady(
              scope: currentScope,
              breadcrumbs: breadcrumbs,
              folders: const [],
              files: StorageFormatters.sortFiles(files, currentSort),
              nextCursor: page.nextCursor,
              filter: currentFilter,
              sort: currentSort,
              viewMode: currentViewMode,
              searchQuery: effectiveQuery,
            ),
          );
        }
      },
    );
  }
}
