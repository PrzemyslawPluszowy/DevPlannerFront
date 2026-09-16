import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:ready_next/workspaces/presentation/storage/sharing/widgets/storage_sharing_dialog.dart';
import 'package:ready_next/workspaces/presentation/storage/versions/storage_versions_dialog.dart';

/// Desktop menu for a file, backed by the same cubit operations as the toolbar.
abstract final class StorageFileContextMenu {
  static void show(
    BuildContext context,
    StorageFileResponse file,
    Offset position,
  ) {
    final l10n = context.l10n;
    final mutation = context.read<StorageFileMutationCubit>();
    final isTrash = context.read<StorageBrowserCubit>().currentScope.isTrash;
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
              onTap: (_) {
                unawaited(
                  context.read<StoragePreviewCubit>().preparePreview(file),
                );
                return showDialog<void>(
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: context.read<StoragePreviewCubit>(),
                    child: StoragePreviewDialog(file: file),
                  ),
                );
              },
            ),
          if (file.canShare && !isTrash)
            AppContextMenuAction(
              label: l10n.storageShareAction,
              icon: AppIcons.share,
              onTap: (_) => StorageSharingDialog.show(context, file: file),
            ),
          if (file.canRead && !isTrash)
            AppContextMenuAction(
              label: file.isFavorite
                  ? l10n.storageRemoveFavoriteAction
                  : l10n.storageAddFavoriteAction,
              icon: AppIcons.star,
              onTap: (_) => mutation.toggleFavorite(file),
            ),
          if (file.canDownload)
            AppContextMenuAction(
              label: l10n.storageDownloadAction,
              icon: AppIcons.download,
              onTap: (_) => mutation.downloadFile(file),
            ),
          if (file.canManageVersions)
            AppContextMenuAction(
              label: l10n.storageVersionsTitle,
              icon: AppIcons.documentText,
              onTap: (_) async {
                final restored = await StorageVersionsDialog.show(
                  context,
                  file: file,
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
          if (isTrash && file.canRestore)
            AppContextMenuAction(
              label: l10n.storageRestoreSelected,
              icon: AppIcons.refresh,
              onTap: (_) => mutation.restoreFile(file.id),
            )
          else if (file.canDelete)
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
