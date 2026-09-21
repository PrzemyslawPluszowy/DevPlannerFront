import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_move_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_open_document_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_preview_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_sharing_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/storage_versions_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Desktop menu for a file, backed by the same cubit operations as the toolbar.
abstract final class StorageFileContextMenu {
  static void show(
    BuildContext context,
    StorageFileResponse file,
    Offset position, {
    StorageShellCapabilities capabilities = StorageShellCapabilities.readOnly,
    ValueChanged<String>? onOpenFileDetails,
  }) {
    final l10n = context.l10n;
    final mutation = context.read<StorageFileMutationCubit>();
    final isTrash = context.read<StorageBrowserCubit>().currentScope.isTrash;
    final openDetails = onOpenFileDetails;
    unawaited(
      AppContextMenu.show(
        context,
        globalPosition: position,
        headerTitle: file.originalFileName,
        actions: [
          if (file.canPreview && !isTrash)
            AppContextMenuAction(
              label: l10n.storagePreviewTitle,
              icon: AppIcons.documentText,
              onTap: (_) => showStoragePreview(context, file: file),
            ),
          if (openDetails != null)
            AppContextMenuAction(
              label: l10n.storageDetailsTitle,
              icon: Icons.info_outline,
              onTap: (_) => openDetails(file.id),
            ),
          if (file.canEditOnline && !isTrash)
            AppContextMenuAction(
              label: l10n.storageOpenOfficeAction,
              icon: AppIcons.documentText,
              onTap: (_) => unawaited(
                runStorageOpenOfficeDocument(context, file: file),
              ),
            ),
          if (capabilities.canMove && !isTrash)
            AppContextMenuAction(
              label: l10n.storageMoveAction,
              icon: AppIcons.folder,
              onTap: (_) =>
                  runStorageMoveToFolderAction(context, fileIds: [file.id]),
            ),
          if (capabilities.canShare && file.canShare && !isTrash)
            AppContextMenuAction(
              label: l10n.storageShareAction,
              icon: AppIcons.share,
              onTap: (_) => StorageSharingDialog.show(
                context,
                file: file,
                repository: context.read<StorageRepository>(),
                userDirectory: context.read<StorageUserDirectoryPort?>(),
              ),
            ),
          if (capabilities.canFavorite && file.canRead && !isTrash)
            AppContextMenuAction(
              label: file.isFavorite
                  ? l10n.storageRemoveFavoriteAction
                  : l10n.storageAddFavoriteAction,
              icon: AppIcons.star,
              onTap: (_) => mutation.toggleFavorite(file),
            ),
          if (capabilities.canDownload && file.canDownload)
            AppContextMenuAction(
              label: l10n.storageDownloadAction,
              icon: AppIcons.download,
              onTap: (_) => mutation.downloadFile(file),
            ),
          if (capabilities.canManageVersions && file.canManageVersions)
            AppContextMenuAction(
              label: l10n.storageVersionsTitle,
              icon: AppIcons.documentText,
              onTap: (_) async {
                final restored = await StorageVersionsDialog.show(
                  context,
                  file: file,
                  repository: context.read<StorageRepository>(),
                  downloadTransport: context.read<DownloadTransport>(),
                );
                if (restored == true && context.mounted) {
                  unawaited(
                    context.read<StorageBrowserCubit>().load(
                      showLoading: false,
                    ),
                  );
                }
              },
            ),
          if (capabilities.canDelete && isTrash && file.canRestore)
            AppContextMenuAction(
              label: l10n.storageRestoreSelected,
              icon: AppIcons.refresh,
              onTap: (_) => mutation.restoreFile(file.id),
            )
          else if (capabilities.canDelete && file.canDelete)
            AppContextMenuAction(
              label: l10n.storageDeleteAction,
              icon: AppIcons.delete,
              isDestructive: true,
              onTap: (_) => mutation.deleteFile(file.id),
            ),
        ],
      ),
    );
  }
}
