enum StorageFolderActionOutcome { succeeded, failed, stale }

typedef StorageFolderRenameHandler =
    Future<StorageFolderActionOutcome> Function(String name);
typedef StorageFolderDeleteHandler =
    Future<StorageFolderActionOutcome> Function();
