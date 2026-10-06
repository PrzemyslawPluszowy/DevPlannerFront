import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_share_recipient_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_move_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_open_document_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_preview_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_dismiss_shared_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_rename_file_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_versions_action.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_sharing_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
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
    final isShared = context
        .read<StorageBrowserCubit>()
        .currentScope
        .isSharedWithMe;
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
          if (capabilities.canRenameFile && file.canEdit && !isTrash)
            AppContextMenuAction(
              label: l10n.storageRenameFileDialogTitle,
              icon: Icons.drive_file_rename_outline,
              onTap: (_) => StorageRenameFileDialog.show(context, file),
            ),
          if (file.canEditOnline && !isTrash)
            AppContextMenuAction(
              label: l10n.storageOpenOfficeAction,
              icon: AppIcons.documentText,
              onTap: (_) => unawaited(
                runStorageOpenOfficeDocument(context, file: file),
              ),
            ),
          if (capabilities.canMove &&
              file.canEdit &&
              !file.isDeleted &&
              !isTrash)
            AppContextMenuAction(
              label: l10n.storageMoveAction,
              icon: AppIcons.folder,
              onTap: (_) =>
                  StorageMoveAction.chooseFolder(context, fileIds: [file.id]),
            ),
          if (capabilities.canShare && file.canShare && !isTrash)
            AppContextMenuAction(
              label: l10n.storageShareAction,
              icon: AppIcons.share,
              onTap: (_) => StorageSharingDialog.show(
                context,
                file: file,
                repository: context.read<StorageRepository>(),
                recipientDirectory: context
                    .read<StorageShareRecipientDirectoryPort?>(),
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
          if (isShared && file.canDismissFromShared)
            AppContextMenuAction(
              label: l10n.storageDismissFromSharedAction,
              icon: Icons.visibility_off_outlined,
              onTap: (_) =>
                  StorageDismissSharedAction.confirm(context, file.id),
            ),
          if (capabilities.canDownload && file.canDownload && !isTrash)
            AppContextMenuAction(
              label: l10n.storageDownloadAction,
              icon: AppIcons.download,
              onTap: (_) => mutation.downloadFile(file),
            ),
          if (capabilities.canManageVersions &&
              file.canManageVersions &&
              !isTrash)
            AppContextMenuAction(
              label: l10n.storageVersionsTitle,
              icon: AppIcons.documentText,
              onTap: (_) =>
                  StorageVersionsAction.show(context, file, capabilities),
            ),
          if (capabilities.canDelete && isTrash && file.canRestore)
            AppContextMenuAction(
              label: l10n.storageRestoreSelected,
              icon: AppIcons.refresh,
              onTap: (_) => mutation.restoreFile(file.id),
            )
          else if (capabilities.canDelete && file.canDelete && !isTrash)
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
