import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_delete_actions.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_restore_actions.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_share_action.dart';
import 'package:devplanner/workspaces/presentation/storage/shared/storage_formatters.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/storage_versions_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Row for a file in the standalone Files browser.
final class StorageReadOnlyFileTile extends StatelessWidget {
  /// Creates a file row with optional desktop actions.
  const StorageReadOnlyFileTile({
    required this.file,
    required this.onOpen,
    required this.canDelete,
    required this.canDownload,
    this.canShare = false,
    this.repository,
    this.onShareMutationConfirmed,
    this.canManageVersions = false,
    this.onVersionsRestored,
    this.versionsRepository,
    this.versionsDownloadTransport,
    this.canRestore = false,
    this.onOpenDetails,
    super.key,
  });

  /// File rendered by the row.
  final StorageFileResponse file;

  /// Opens the existing read-only preview.
  final VoidCallback onOpen;

  /// Composition-level capability gate for the delete action.
  final bool canDelete;

  /// Composition-level capability gate for downloading the original file.
  final bool canDownload;

  /// Składany wyłącznie dla desktopowego standalone API.
  final bool canShare;

  /// Repozytorium potrzebne do dialogu zarządzania grantami.
  final StorageRepository? repository;

  /// Odświeżenie browsera po potwierdzonej zmianie ACL.
  final Future<void> Function()? onShareMutationConfirmed;

  /// Composition-level capability gate for restoring deleted files.
  final bool canRestore;

  /// Otwiera szczegóły z ponowną weryfikacją dostępu przez backend.
  final VoidCallback? onOpenDetails;

  /// Composition-level capability gate for version history and restore.
  final bool canManageVersions;

  /// Notifies the browser after a confirmed historical restore.
  final VoidCallback? onVersionsRestored;

  /// Authenticated repository used by the version-history action.
  final StorageRepository? versionsRepository;

  /// Desktop download adapter used by version-history downloads.
  final DownloadTransport? versionsDownloadTransport;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(
      StorageFormatters.iconForFile(
        mimeType: file.mimeType,
        extension: file.extension,
      ),
    ),
    title: Text(file.originalFileName),
    subtitle: Text(StorageFormatters.formatBytes(file.fileSizeBytes)),
    enabled: file.canRead,
    onTap: file.canRead ? onOpen : null,
    trailing: Wrap(
      spacing: 4,
      children: [
        if (onOpenDetails != null)
          IconButton(
            key: ValueKey('file-details-${file.id}'),
            tooltip: 'Szczegóły pliku',
            icon: const Icon(Icons.info_outline),
            onPressed: onOpenDetails,
          ),
        if (canRestore && file.isDeleted && file.canRestore)
          StorageFileRestoreAction(
            buttonKey: ValueKey('restore-file-${file.id}'),
            fileId: file.id,
          ),
        if (canDelete && file.canDelete)
          StorageFileDeleteAction(
            buttonKey: ValueKey('delete-file-${file.id}'),
            fileId: file.id,
          ),
        if (canDownload && file.canDownload)
          IconButton(
            key: ValueKey('download-file-${file.id}'),
            tooltip: context.l10n.storageDownloadAction,
            icon: const Icon(Icons.download_outlined),
            onPressed: () =>
                context.read<StorageFileMutationCubit>().downloadFile(file),
          ),
        if (canShare && file.canShare && repository != null)
          StorageFileShareAction(
            key: ValueKey('share-file-${file.id}'),
            file: file,
            repository: repository!,
            onMutationConfirmed: onShareMutationConfirmed,
          ),
        if (canManageVersions && file.canManageVersions)
          IconButton(
            key: ValueKey('versions-file-${file.id}'),
            tooltip: context.l10n.storageVersionsTitle,
            icon: const Icon(Icons.history_outlined),
            onPressed: () async {
              final restored = await StorageVersionsDialog.show(
                context,
                file: file,
                repository: versionsRepository!,
                downloadTransport: versionsDownloadTransport!,
              );
              if (restored == true && context.mounted) {
                onVersionsRestored?.call();
              }
            },
          ),
      ],
    ),
  );
}
