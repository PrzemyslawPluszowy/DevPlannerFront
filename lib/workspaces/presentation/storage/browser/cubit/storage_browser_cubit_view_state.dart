part of 'storage_browser_cubit.dart';

/// Odczyt aktualnego widoku eksploratora wydzielony od komend ładowania.
extension StorageBrowserCubitViewState on StorageBrowserCubit {
  /// Pobiera aktualny zakres.
  StorageScope get currentScope => switch (state) {
    StorageBrowserInitial(:final scope) => scope,
    StorageBrowserLoading(:final scope) => scope,
    StorageBrowserReady(:final scope) => scope,
    StorageBrowserEmpty(:final scope) => scope,
    StorageBrowserFailure(:final scope) => scope,
    StorageBrowserForbidden(:final scope) => scope,
  };

  /// Pobiera aktualny tryb widoku.
  StorageViewMode get currentViewMode => switch (state) {
    StorageBrowserInitial(:final viewMode) => viewMode,
    StorageBrowserLoading(:final viewMode) => viewMode,
    StorageBrowserReady(:final viewMode) => viewMode,
    StorageBrowserEmpty(:final viewMode) => viewMode,
    StorageBrowserFailure() => StorageViewMode.grid,
    StorageBrowserForbidden() => StorageViewMode.grid,
  };

  /// Pobiera aktualne filtry.
  StorageBrowserFilter get currentFilter => switch (state) {
    StorageBrowserInitial(:final filter) => filter,
    StorageBrowserLoading(:final filter) => filter,
    StorageBrowserReady(:final filter) => filter,
    StorageBrowserEmpty(:final filter) => filter,
    StorageBrowserFailure() => const StorageBrowserFilter(),
    StorageBrowserForbidden() => const StorageBrowserFilter(),
  };

  /// Pobiera aktualną gęstość wierszy.
  StorageDensity get currentDensity => switch (state) {
    StorageBrowserInitial(:final density) => density,
    StorageBrowserLoading(:final density) => density,
    StorageBrowserReady(:final density) => density,
    StorageBrowserEmpty(:final density) => density,
    StorageBrowserFailure() => StorageDensity.comfortable,
    StorageBrowserForbidden() => StorageDensity.comfortable,
  };

  /// Pobiera aktualne sortowanie.
  StorageSortCriteria get currentSort => switch (state) {
    StorageBrowserInitial(:final sort) => sort,
    StorageBrowserLoading(:final sort) => sort,
    StorageBrowserReady(:final sort) => sort,
    StorageBrowserEmpty(:final sort) => sort,
    StorageBrowserFailure() => const StorageSortCriteria(),
    StorageBrowserForbidden() => const StorageSortCriteria(),
  };
}
