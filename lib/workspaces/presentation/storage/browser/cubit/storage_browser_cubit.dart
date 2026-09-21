import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
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
    StorageViewMode initialViewMode = StorageViewMode.list,
    StorageSortCriteria initialSort = const StorageSortCriteria(),
    StorageDensity initialDensity = StorageDensity.comfortable,
  }) : super(
         StorageBrowserInitial(
           scope: initialScope,
           sort: initialSort,
           viewMode: initialViewMode,
           density: initialDensity,
         ),
       );

  final StorageRepository repository;
  int _requestGeneration = 0;
  String? _searchQuery;
  final Map<String, String?> _folderParents = {};

  /// Liczba trwających odczytów listy; zdarzenie realtime nie wchodzi w drogę
  /// ładowaniu, które już leci.
  int _loadDepth = 0;

  /// Czy w trakcie ładowania przyszło zdarzenie, które wymaga odświeżenia.
  bool _refreshPending = false;

  /// Największy limit, jaki przyjmuje lista plików. Odświeżenie w miejscu chce
  /// pokryć to, co już widać, ale nie może przekroczyć limitu kontraktu.
  static const _maxRefreshLimit = 100;

  /// Ładuje dane dla bieżącego zakresu i folderu.
  Future<void> load({bool showLoading = true}) async {
    await _loadListing(showLoading: showLoading, failureAsState: true);
  }

  /// Odświeża bieżący widok po zdarzeniu realtime.
  ///
  /// Zdarzenie zmienia dane, nie nawigację: zakres, folder, sortowanie, widok,
  /// filtr i zapytanie zostają. Liczba wczytanych pozycji jest zachowana przez
  /// `limit`, bo zwinięcie listy do pierwszej strony przewinęłoby widok i
  /// zgubiło zaznaczenie. Błąd nie podmienia listy na ekran awarii — wraca do
  /// wołającego, który pokazuje trwały banner, a użytkownik nie traci tego, co
  /// ma na ekranie.
  ///
  /// Zwraca `null`, gdy odświeżenie się udało albo nie było czego odświeżać.
  Future<ApiError?> refreshFromRealtime() async {
    if (_loadDepth > 0) {
      // Trwające ładowanie mogło wystartować przed zmianą, więc nie zamiata
      // sprawy: odświeżenie wróci zaraz po jego zakończeniu.
      _refreshPending = true;
      return null;
    }
    final currentState = state;
    if (currentState is! StorageBrowserReady &&
        currentState is! StorageBrowserEmpty) {
      return null;
    }
    final loaded = currentState is StorageBrowserReady
        ? currentState.files.length
        : 0;
    final query = _searchQuery;
    return query == null
        ? _loadListing(
            showLoading: false,
            failureAsState: false,
            minimumItems: loaded,
          )
        : _loadSearch(
            query,
            showLoading: false,
            failureAsState: false,
            minimumItems: loaded,
          );
  }

  Future<ApiError?> _loadListing({
    required bool showLoading,
    required bool failureAsState,
    int? minimumItems,
  }) async {
    _loadDepth++;
    try {
      final requestGeneration = ++_requestGeneration;
      final scope = currentScope;
      final filter = currentFilter;
      final sort = currentSort;
      final viewMode = currentViewMode;
      final density = currentDensity;

      if (showLoading) {
        emit(
          StorageBrowserLoading(
            scope: scope,
            filter: filter,
            sort: sort,
            viewMode: viewMode,
            density: density,
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
          final resolved = await StorageBreadcrumbResolver(
            repository,
          ).resolve(scope);
          folderDetails = resolved.currentFolder;
          breadcrumbs = resolved.breadcrumbs;
        } on Object {
          // Brak przodka nie może ukryć zawartości dostępnego folderu. Łapiemy
          // każdą awarię tego kroku, bo niezłapany błąd zostawiłby eksplorator
          // w nieskończonym stanie ładowania.
        }
        if (isClosed || requestGeneration != _requestGeneration) return null;
      }

      final foldersResult = await repository.listFolders(
        scope: scope,
        parentFolderId: scope.folderId,
      );
      if (isClosed || requestGeneration != _requestGeneration) return null;

      if (foldersResult.isLeft()) {
        final error = foldersResult.fold<ApiError?>(
          (err) => err,
          (_) => null,
        );
        if (!failureAsState) return error;
        foldersResult.leftMap((err) {
          if (err.statusCode == 403) {
            emit(StorageBrowserForbidden(scope: scope, message: err.message));
          } else {
            emit(
              StorageBrowserFailure(
                scope: scope,
                message: err.message,
                statusCode: err.statusCode,
                backendCode: err.backendCode,
                apiCode: err.apiCode,
                traceId: err.traceId,
              ),
            );
          }
        });
        return error;
      }

      final filesResult = await repository.listFiles(
        scope: scope,
        folderId: scope.folderId,
        limit: _minimumLimit(minimumItems),
        filter: filter,
        query: _searchQuery,
      );
      if (isClosed || requestGeneration != _requestGeneration) return null;

      if (filesResult.isLeft()) {
        final error = filesResult.fold<ApiError?>((err) => err, (_) => null);
        if (!failureAsState) return error;
        filesResult.leftMap((err) {
          if (err.statusCode == 403) {
            emit(StorageBrowserForbidden(scope: scope, message: err.message));
          } else {
            emit(
              StorageBrowserFailure(
                scope: scope,
                message: err.message,
                statusCode: err.statusCode,
                backendCode: err.backendCode,
                apiCode: err.apiCode,
                traceId: err.traceId,
              ),
            );
          }
        });
        return error;
      }

      final folders = foldersResult.getOrElse(() => <StorageFolderResponse>[]);
      final filesPage = filesResult.getOrElse(
        () => const CursorPageResponse<StorageFileResponse>(items: []),
      );
      final files = filesPage.items;
      // Stan końcowy czyta bieżące pola widoku: żądanie poszło z wartościami
      // sprzed zmiany, ale użytkownik mógł w trakcie przełączyć widok albo
      // sortowanie i ekran ma pokazać jego wybór, a nie stan sprzed kliknięcia.
      final displaySort = currentSort;
      final displayViewMode = currentViewMode;
      final displayDensity = currentDensity;
      if (folders.isEmpty && files.isEmpty) {
        emit(
          StorageBrowserEmpty(
            scope: scope,
            currentFolder: folderDetails,
            breadcrumbs: breadcrumbs,
            filter: filter,
            sort: displaySort,
            viewMode: displayViewMode,
            density: displayDensity,
            searchQuery: _searchQuery,
          ),
        );
      } else {
        emit(
          StorageBrowserReady(
            scope: scope,
            currentFolder: folderDetails,
            breadcrumbs: breadcrumbs,
            folders: StorageFormatters.sortFolders(folders, displaySort),
            files: StorageFormatters.sortFiles(files, displaySort),
            nextCursor: filesPage.nextCursor,
            filter: filter,
            sort: displaySort,
            viewMode: displayViewMode,
            density: displayDensity,
            searchQuery: _searchQuery,
          ),
        );
      }
      return null;
    } finally {
      _loadDepth--;
      _runPendingRefresh();
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
        sort: currentSort,
        viewMode: currentViewMode,
        density: currentDensity,
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
    _applyViewFields(filter: filter);
    await load();
  }

  /// Zmienia kryteria sortowania.
  ///
  /// W stanie pustym i początkowym nie ma czego przeliczać, ale wybór musi
  /// zostać zapamiętany — inaczej pasek poleceń pokazywałby jedno kryterium,
  /// a pierwsze załadowanie wyników sortowałoby po innym.
  void setSort(StorageSortCriteria sort) {
    _applyViewFields(sort: sort);
  }

  /// Ustawia tryb widoku wskazany przez przełącznik Lista/Siatka.
  void setViewMode(StorageViewMode mode) {
    if (currentViewMode == mode) return;
    _applyViewFields(viewMode: mode);
  }

  /// Przełącza tryb widoku (siatka / lista).
  void toggleViewMode() {
    _applyViewFields(
      viewMode: currentViewMode == StorageViewMode.grid
          ? StorageViewMode.list
          : StorageViewMode.grid,
    );
  }

  /// Ustawia gęstość wierszy listy.
  void setDensity(StorageDensity density) {
    if (currentDensity == density) return;
    _applyViewFields(density: density);
  }

  /// Zapisuje pola widoku w bieżącym stanie.
  ///
  /// Jedno miejsce obsługuje filtry, sortowanie, tryb widoku i gęstość, więc
  /// każda z tych zmian zachowuje pozostałe pola zamiast je resetować. Stan bez
  /// listy nie ma czego przeliczać, więc zmiana jest tam pomijana.
  void _applyViewFields({
    StorageBrowserFilter? filter,
    StorageSortCriteria? sort,
    StorageViewMode? viewMode,
    StorageDensity? density,
  }) {
    final s = state;
    switch (s) {
      case StorageBrowserReady():
        final nextSort = sort ?? s.sort;
        emit(
          s.copyWith(
            filter: filter ?? s.filter,
            sort: nextSort,
            viewMode: viewMode ?? s.viewMode,
            density: density ?? s.density,
            folders: sort == null
                ? null
                : StorageFormatters.sortFolders(s.folders, nextSort),
            files: sort == null
                ? null
                : StorageFormatters.sortFiles(s.files, nextSort),
          ),
        );
      case StorageBrowserEmpty():
        emit(
          StorageBrowserEmpty(
            scope: s.scope,
            currentFolder: s.currentFolder,
            breadcrumbs: s.breadcrumbs,
            filter: filter ?? s.filter,
            sort: sort ?? s.sort,
            viewMode: viewMode ?? s.viewMode,
            density: density ?? s.density,
            searchQuery: s.searchQuery,
          ),
        );
      case StorageBrowserInitial():
        emit(
          StorageBrowserInitial(
            scope: s.scope,
            filter: filter ?? s.filter,
            sort: sort ?? s.sort,
            viewMode: viewMode ?? s.viewMode,
            density: density ?? s.density,
          ),
        );
      case StorageBrowserLoading():
        emit(
          StorageBrowserLoading(
            scope: s.scope,
            currentFolder: s.currentFolder,
            breadcrumbs: s.breadcrumbs,
            folders: s.folders,
            files: s.files,
            filter: filter ?? s.filter,
            sort: sort ?? s.sort,
            viewMode: viewMode ?? s.viewMode,
            density: density ?? s.density,
          ),
        );
      case StorageBrowserFailure() || StorageBrowserForbidden():
        break;
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

    await _loadSearch(
      effectiveQuery,
      showLoading: true,
      failureAsState: true,
    );
  }

  /// Odczytuje wynik zapytania bez listy folderów; wspólny dla wyszukiwania
  /// i odświeżenia po zdarzeniu realtime, gdy zapytanie jest aktywne.
  Future<ApiError?> _loadSearch(
    String? query, {
    required bool showLoading,
    required bool failureAsState,
    int? minimumItems,
  }) async {
    _loadDepth++;
    try {
      final requestGeneration = ++_requestGeneration;

      if (showLoading) {
        emit(
          StorageBrowserLoading(
            scope: currentScope,
            filter: currentFilter,
            sort: currentSort,
            viewMode: currentViewMode,
            density: currentDensity,
          ),
        );
      }

      final filesResult = await repository.listFiles(
        scope: currentScope,
        folderId: currentScope.folderId,
        limit: _minimumLimit(minimumItems),
        filter: currentFilter,
        query: query,
      );
      if (isClosed || requestGeneration != _requestGeneration) return null;

      if (filesResult.isLeft()) {
        final error = filesResult.fold<ApiError?>((err) => err, (_) => null);
        if (!failureAsState) return error;
        filesResult.leftMap(
          (err) => emit(
            StorageBrowserFailure(
              scope: currentScope,
              message: err.message,
              statusCode: err.statusCode,
              backendCode: err.backendCode,
              apiCode: err.apiCode,
              traceId: err.traceId,
            ),
          ),
        );
        return error;
      }

      final page = filesResult.getOrElse(
        () => const CursorPageResponse<StorageFileResponse>(items: []),
      );
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
            density: currentDensity,
            searchQuery: query,
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
            density: currentDensity,
            searchQuery: query,
          ),
        );
      }
      return null;
    } finally {
      _loadDepth--;
      _runPendingRefresh();
    }
  }

  /// Limit odczytu pokrywający to, co już widać; `null` zostawia limit kontraktu.
  int? _minimumLimit(int? minimumItems) {
    if (minimumItems == null || minimumItems <= 0) return null;
    return minimumItems > _maxRefreshLimit ? _maxRefreshLimit : minimumItems;
  }

  /// Domyka odświeżenie, które przyszło w trakcie ładowania.
  void _runPendingRefresh() {
    if (!_refreshPending) return;
    _refreshPending = false;
    if (isClosed) return;
    final currentState = state;
    if (currentState is! StorageBrowserReady &&
        currentState is! StorageBrowserEmpty) {
      return;
    }
    unawaited(refreshFromRealtime());
  }
}
