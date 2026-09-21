import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_browser_filter.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_view_preference.dart';
import 'package:equatable/equatable.dart';

// Tryb widoku i gęstość są zapisywane w preferencjach użytkownika, więc ich
// kontrakt żyje w domenie. Eksport utrzymuje stabilny punkt importu dla
// dotychczasowych konsumentów stanu.
export 'package:devplanner/workspaces/domain/storage/models/storage_view_preference.dart'
    show StorageDensity, StorageViewMode;

/// Element ścieżki okruszków w eksploratorze plików.
class StorageBreadcrumbItem extends Equatable {
  /// Tworzy element ścieżki.
  const StorageBreadcrumbItem({
    required this.name,
    this.folderId,
  });

  /// Nazwa wyświetlana (np. "Moje pliki" lub nazwa podfolderu).
  final String name;

  /// Identyfikator folderu (null dla korzenia zakresu).
  final String? folderId;

  @override
  List<Object?> get props => [name, folderId];
}

/// Bazowy stan eksploratora plików.
sealed class StorageBrowserState extends Equatable {
  /// Tworzy bazowy stan eksploratora.
  const StorageBrowserState();

  @override
  List<Object?> get props => [];
}

/// Stan początkowy przed załadowaniem danych.
class StorageBrowserInitial extends StorageBrowserState {
  /// Tworzy stan początkowy.
  const StorageBrowserInitial({
    required this.scope,
    this.filter = const StorageBrowserFilter(),
    this.sort = const StorageSortCriteria(),
    this.viewMode = StorageViewMode.list,
    this.density = StorageDensity.comfortable,
  });

  /// Aktualny zakres.
  final StorageScope scope;

  /// Aktywne filtry.
  final StorageBrowserFilter filter;

  /// Aktywne sortowanie.
  final StorageSortCriteria sort;

  /// Tryb widoku (siatka/lista).
  final StorageViewMode viewMode;

  /// Gęstość wierszy listy.
  final StorageDensity density;

  @override
  List<Object?> get props => [scope, filter, sort, viewMode, density];
}

/// Stan ładowania danych w eksploratorze.
class StorageBrowserLoading extends StorageBrowserState {
  /// Tworzy stan ładowania.
  const StorageBrowserLoading({
    required this.scope,
    this.currentFolder,
    this.breadcrumbs = const [],
    this.folders = const [],
    this.files = const [],
    this.filter = const StorageBrowserFilter(),
    this.sort = const StorageSortCriteria(),
    this.viewMode = StorageViewMode.list,
    this.density = StorageDensity.comfortable,
  });

  /// Aktualny zakres.
  final StorageScope scope;

  /// Aktualny folder.
  final StorageFolderResponse? currentFolder;

  /// Okruszki ścieżki.
  final List<StorageBreadcrumbItem> breadcrumbs;

  /// Dotychczas załadowane foldery.
  final List<StorageFolderResponse> folders;

  /// Dotychczas załadowane pliki.
  final List<StorageFileResponse> files;

  /// Aktywne filtry.
  final StorageBrowserFilter filter;

  /// Aktywne sortowanie.
  final StorageSortCriteria sort;

  /// Tryb widoku.
  final StorageViewMode viewMode;

  /// Gęstość wierszy listy.
  final StorageDensity density;

  @override
  List<Object?> get props => [
    scope,
    currentFolder,
    breadcrumbs,
    folders,
    files,
    filter,
    sort,
    viewMode,
    density,
  ];
}

/// Stan gotowości z załadowanymi danymi folderów i plików.
class StorageBrowserReady extends StorageBrowserState {
  /// Tworzy stan gotowości.
  const StorageBrowserReady({
    required this.scope,
    this.currentFolder,
    required this.breadcrumbs,
    required this.folders,
    required this.files,
    this.nextCursor,
    this.isLoadingMore = false,
    this.filter = const StorageBrowserFilter(),
    this.sort = const StorageSortCriteria(),
    this.viewMode = StorageViewMode.list,
    this.density = StorageDensity.comfortable,
    this.searchQuery,
  });

  /// Aktualny zakres eksploratora.
  final StorageScope scope;

  /// Szczegóły aktualnego folderu nadrzędnego (null dla korzenia).
  final StorageFolderResponse? currentFolder;

  /// Ścieżka nawigacyjna okruszków.
  final List<StorageBreadcrumbItem> breadcrumbs;

  /// Podfoldery w bieżącym widoku.
  final List<StorageFolderResponse> folders;

  /// Pliki w bieżącym widoku.
  final List<StorageFileResponse> files;

  /// Kursor kolejnej strony z backendu.
  final String? nextCursor;

  /// Czy trwa dociąganie kolejnej strony (infinite scroll).
  final bool isLoadingMore;

  /// Aktywne filtry wyszukiwania.
  final StorageBrowserFilter filter;

  /// Aktywne kryteria sortowania.
  final StorageSortCriteria sort;

  /// Wybrany tryb widoku (siatka lub lista).
  final StorageViewMode viewMode;

  /// Gęstość wierszy listy.
  final StorageDensity density;

  /// Opcjonalna fraza tekstowa wyszukiwania.
  final String? searchQuery;

  /// Czy istnieje kolejna strona do pobrania.
  bool get hasMore => nextCursor != null && nextCursor!.isNotEmpty;

  /// Kopia stanu z możliwością aktualizacji pól.
  StorageBrowserReady copyWith({
    StorageScope? scope,
    StorageFolderResponse? currentFolder,
    bool clearCurrentFolder = false,
    List<StorageBreadcrumbItem>? breadcrumbs,
    List<StorageFolderResponse>? folders,
    List<StorageFileResponse>? files,
    String? nextCursor,
    bool clearNextCursor = false,
    bool? isLoadingMore,
    StorageBrowserFilter? filter,
    StorageSortCriteria? sort,
    StorageViewMode? viewMode,
    StorageDensity? density,
    String? searchQuery,
    bool clearSearchQuery = false,
  }) => StorageBrowserReady(
    scope: scope ?? this.scope,
    currentFolder: clearCurrentFolder
        ? null
        : (currentFolder ?? this.currentFolder),
    breadcrumbs: breadcrumbs ?? this.breadcrumbs,
    folders: folders ?? this.folders,
    files: files ?? this.files,
    nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    filter: filter ?? this.filter,
    sort: sort ?? this.sort,
    viewMode: viewMode ?? this.viewMode,
    density: density ?? this.density,
    searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
  );

  @override
  List<Object?> get props => [
    scope,
    currentFolder,
    breadcrumbs,
    folders,
    files,
    nextCursor,
    isLoadingMore,
    filter,
    sort,
    viewMode,
    density,
    searchQuery,
  ];
}

/// Stan pustego katalogu (brak folderów i brak plików).
class StorageBrowserEmpty extends StorageBrowserState {
  /// Tworzy stan pustego katalogu.
  const StorageBrowserEmpty({
    required this.scope,
    this.currentFolder,
    required this.breadcrumbs,
    this.filter = const StorageBrowserFilter(),
    this.sort = const StorageSortCriteria(),
    this.viewMode = StorageViewMode.list,
    this.density = StorageDensity.comfortable,
    this.searchQuery,
  });

  /// Aktualny zakres.
  final StorageScope scope;

  /// Aktualny folder.
  final StorageFolderResponse? currentFolder;

  /// Okruszki nawigacji.
  final List<StorageBreadcrumbItem> breadcrumbs;

  /// Aktywne filtry.
  final StorageBrowserFilter filter;

  /// Aktywne sortowanie.
  final StorageSortCriteria sort;

  /// Tryb widoku.
  final StorageViewMode viewMode;

  /// Gęstość wierszy listy.
  final StorageDensity density;

  /// Fraza wyszukiwania.
  final String? searchQuery;

  @override
  List<Object?> get props => [
    scope,
    currentFolder,
    breadcrumbs,
    filter,
    sort,
    viewMode,
    density,
    searchQuery,
  ];
}

/// Stan błędu pobierania danych.
class StorageBrowserFailure extends StorageBrowserState {
  /// Tworzy stan błędu.
  const StorageBrowserFailure({
    required this.scope,
    required this.message,
    this.statusCode,
    this.backendCode,
    this.apiCode,
    this.traceId,
  });

  /// Zakres, przy którym wystąpił błąd.
  final StorageScope scope;

  /// Czytelny komunikat błędu dla użytkownika.
  final String message;

  /// Opcjonalny kod HTTP.
  final int? statusCode;

  /// Opcjonalny numeryczny kod błędu backendu.
  final int? backendCode;

  /// Opcjonalny stabilny kod kontraktu, np. `storage.version_conflict`.
  final String? apiCode;

  /// Opcjonalny identyfikator śledzenia żądania, pokazywany w bannerze błędu.
  final String? traceId;

  @override
  List<Object?> get props => [
    scope,
    message,
    statusCode,
    backendCode,
    apiCode,
    traceId,
  ];
}

/// Stan odmowy uprawnień do danego zakresu/folderu (403 Forbidden).
class StorageBrowserForbidden extends StorageBrowserState {
  /// Tworzy stan braku uprawnień.
  const StorageBrowserForbidden({
    required this.scope,
    required this.message,
  });

  /// Zakres, do którego odmówiono dostępu.
  final StorageScope scope;

  /// Komunikat backendu o odmowie dostępu.
  final String message;

  @override
  List<Object?> get props => [scope, message];
}
