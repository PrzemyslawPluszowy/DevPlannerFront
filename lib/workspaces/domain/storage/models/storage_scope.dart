import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:equatable/equatable.dart';

/// Typowany zakres eksploratora plików w Workspaces.
///
/// Zastępuje luźne kombinacje parametrów `workspaceId`, `projectId`,
/// `folderType` oraz `view`.
sealed class StorageScope extends Equatable {
  /// Tworzy bazowy zakres.
  const StorageScope({this.folderId});

  /// Prywatne pliki użytkownika (Moje pliki).
  const factory StorageScope.personal({String? folderId}) =
      StoragePersonalScope;

  /// Pliki udostępnione użytkownikowi.
  const factory StorageScope.shared({String? folderId}) = StorageSharedScope;

  /// Ostatnio otwierane/modyfikowane pliki.
  const factory StorageScope.recent() = StorageRecentScope;

  /// Ulubione pliki użytkownika.
  const factory StorageScope.favorites() = StorageFavoritesScope;

  /// Kosz usuniętych plików.
  const factory StorageScope.trash() = StorageTrashScope;

  /// Pliki w kontekście całego workspace'u.
  const factory StorageScope.workspace(
    String workspaceId, {
    String? folderId,
  }) = StorageWorkspaceScope;

  /// Pliki w kontekście konkretnego projektu.
  const factory StorageScope.project({
    required String workspaceId,
    required String projectId,
    String? folderId,
  }) = StorageProjectScope;

  /// Pliki powiązane z konkretnym zasobem (np. zadaniem lub komentarzem).
  const factory StorageScope.resource({
    required StorageModule module,
    required StorageResourceType resourceType,
    required String resourceId,
    String? folderId,
  }) = StorageResourceScope;

  /// Opcjonalny identyfikator aktualnego folderu w tym zakresie.
  final String? folderId;

  /// Kopia zakresu z innym identyfikatorem folderu.
  StorageScope copyWithFolder(String? folderId);

  /// Czy zakres to kosz.
  bool get isTrash => this is StorageTrashScope;

  /// Czy zakres to prywatne pliki.
  bool get isPersonal => this is StoragePersonalScope;

  /// Czy zakres to pliki udostępnione.
  bool get isSharedWithMe => this is StorageSharedScope;

  /// Czy zakres to ostatnie pliki.
  bool get isRecent => this is StorageRecentScope;

  /// Czy zakres to ulubione pliki.
  bool get isFavorites => this is StorageFavoritesScope;

  /// Czy bieżący zakres reprezentuje katalog, w którym wolno tworzyć zawartość.
  bool get canCreateContent =>
      this is StoragePersonalScope ||
      this is StorageWorkspaceScope ||
      this is StorageProjectScope ||
      this is StorageResourceScope;

  /// Typ zasobu używany przez upload w bieżącym zakresie.
  StorageResourceType? get uploadResourceType => switch (this) {
    StoragePersonalScope() => StorageResourceType.privateFile,
    StorageWorkspaceScope() => StorageResourceType.document,
    StorageProjectScope() => StorageResourceType.project,
    StorageResourceScope(:final resourceType) => resourceType,
    _ => null,
  };

  /// Identyfikator zasobu używany przez upload w bieżącym zakresie.
  String? get uploadResourceId => switch (this) {
    StorageProjectScope(:final projectId) => projectId,
    StorageResourceScope(:final resourceId) => resourceId,
    _ => null,
  };

  /// Odpowiadający widok systemowy backendu lub null dla folderów strukturalnych.
  StorageListView? get listView;

  /// Odpowiadający typ wirtualnego folderu backendu.
  StorageFolderType? get folderType;

  /// Identyfikator workspace'u, jeśli dotyczy.
  String? get workspaceId => null;

  /// Identyfikator projektu, jeśli dotyczy.
  String? get projectId => null;

  /// Moduł powiązany, jeśli dotyczy.
  StorageModule? get module => null;

  /// Typ powiązanego zasobu, jeśli dotyczy.
  StorageResourceType? get resourceType => null;

  /// Identyfikator powiązanego zasobu, jeśli dotyczy.
  String? get resourceId => null;
}

/// Zakres prywatnych plików użytkownika (`Moje pliki`).
class StoragePersonalScope extends StorageScope {
  /// Tworzy zakres prywatnych plików.
  const StoragePersonalScope({super.folderId});

  @override
  StorageScope copyWithFolder(String? folderId) =>
      StoragePersonalScope(folderId: folderId);

  @override
  StorageListView get listView => .my;

  @override
  StorageFolderType get folderType => .personal;

  @override
  List<Object?> get props => [folderId];
}

/// Zakres plików udostępnionych aktualnemu użytkownikowi.
class StorageSharedScope extends StorageScope {
  /// Tworzy zakres plików udostępnionych.
  const StorageSharedScope({super.folderId});

  @override
  StorageScope copyWithFolder(String? folderId) =>
      StorageSharedScope(folderId: folderId);

  @override
  StorageListView get listView => .shared;

  @override
  StorageFolderType get folderType => .shared;

  @override
  List<Object?> get props => [folderId];
}

/// Zakres ostatnich plików.
class StorageRecentScope extends StorageScope {
  /// Tworzy zakres ostatnich plików.
  const StorageRecentScope() : super(folderId: null);

  @override
  StorageScope copyWithFolder(String? folderId) => this;

  @override
  StorageListView get listView => .recent;

  @override
  StorageFolderType? get folderType => null;

  @override
  List<Object?> get props => [];
}

/// Zakres ulubionych plików.
class StorageFavoritesScope extends StorageScope {
  /// Tworzy zakres ulubionych plików.
  const StorageFavoritesScope() : super(folderId: null);

  @override
  StorageScope copyWithFolder(String? folderId) => this;

  @override
  StorageListView get listView => .favorites;

  @override
  StorageFolderType? get folderType => null;

  @override
  List<Object?> get props => [];
}

/// Zakres kosza plików.
class StorageTrashScope extends StorageScope {
  /// Tworzy zakres kosza.
  const StorageTrashScope() : super(folderId: null);

  @override
  StorageScope copyWithFolder(String? folderId) => this;

  @override
  StorageListView get listView => .trash;

  @override
  StorageFolderType? get folderType => null;

  @override
  List<Object?> get props => [];
}

/// Zakres plików przypisanych do workspace'u.
class StorageWorkspaceScope extends StorageScope {
  /// Tworzy zakres workspace'u.
  const StorageWorkspaceScope(this.workspaceId, {super.folderId});

  @override
  final String workspaceId;

  @override
  StorageScope copyWithFolder(String? folderId) =>
      StorageWorkspaceScope(workspaceId, folderId: folderId);

  @override
  StorageListView? get listView => null;

  @override
  StorageFolderType get folderType => .workspace;

  @override
  List<Object?> get props => [workspaceId, folderId];
}

/// Zakres plików przypisanych do projektu.
class StorageProjectScope extends StorageScope {
  /// Tworzy zakres projektu.
  const StorageProjectScope({
    required this.workspaceId,
    required this.projectId,
    super.folderId,
  });

  @override
  final String workspaceId;

  @override
  final String projectId;

  @override
  StorageScope copyWithFolder(String? folderId) => StorageProjectScope(
    workspaceId: workspaceId,
    projectId: projectId,
    folderId: folderId,
  );

  @override
  StorageListView? get listView => null;

  @override
  StorageFolderType get folderType => .project;

  @override
  List<Object?> get props => [workspaceId, projectId, folderId];
}

/// Zakres plików konkretnego zasobu zewnętrznego.
class StorageResourceScope extends StorageScope {
  /// Tworzy zakres zasobu powiązanego.
  const StorageResourceScope({
    required this.module,
    required this.resourceType,
    required this.resourceId,
    super.folderId,
  });

  @override
  final StorageModule module;

  @override
  final StorageResourceType resourceType;

  @override
  final String resourceId;

  @override
  StorageScope copyWithFolder(String? folderId) => StorageResourceScope(
    module: module,
    resourceType: resourceType,
    resourceId: resourceId,
    folderId: folderId,
  );

  @override
  StorageListView? get listView => null;

  @override
  StorageFolderType? get folderType => null;

  @override
  List<Object?> get props => [module, resourceType, resourceId, folderId];
}
