import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_chrome_pill.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_delete_confirmation.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_move_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_state.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Kontekstowy pasek akcji masowych dla bieżącego zaznaczenia.
///
/// Zastępuje wiersz poleceń, więc w chrome istnieje dokładnie jeden pasek
/// akcji masowych — tak samo jak w Tasks.
final class StorageBulkBar extends StatelessWidget {
  /// Tworzy pasek akcji masowych.
  const StorageBulkBar({
    this.capabilities = StorageShellCapabilities.readOnly,
    super.key,
  });

  /// Uprawnienia kompozycji decydujące o widoczności akcji masowych.
  final StorageShellCapabilities capabilities;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;

    return BlocBuilder<StorageSelectionCubit, StorageSelectionState>(
      builder: (context, state) {
        if (!state.hasSelection) return const SizedBox.shrink();

        final fileMutationCubit = context.read<StorageFileMutationCubit>();
        final canDownloadZip =
            capabilities.canDownload &&
            state.canDownloadZip &&
            state.selectedFileIds.isNotEmpty;
        final canDelete = capabilities.canDelete && state.canDelete;

        return Container(
          key: const ValueKey('storage_bulk_bar'),
          padding: EdgeInsets.symmetric(horizontal: common.controlGap),
          decoration: BoxDecoration(
            color: common.bulkBarSurface,
            borderRadius: BorderRadius.circular(common.controlRadius),
            border: Border.all(color: common.bulkBarBorder),
          ),
          child: Row(
            children: [
              StorageChromePill(
                key: const ValueKey('storage_bulk_clear'),
                icon: AppIcons.close,
                tooltip: context.l10n.storageClearSelection,
                onTap: context.read<StorageSelectionCubit>().clearSelection,
              ),
              SizedBox(width: common.controlGap),
              Text(
                context.l10n.storageSelectedCount(state.count),
                style: common.controlText.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              const Spacer(),
              if (capabilities.canMove && state.selectedFileIds.isNotEmpty) ...[
                StorageChromePill(
                  key: const ValueKey('storage_bulk_move'),
                  icon: AppIcons.folder,
                  label: context.l10n.storageMoveAction,
                  tooltip: context.l10n.storageMoveAction,
                  onTap: () => unawaited(
                    runStorageMoveToFolderAction(
                      context,
                      fileIds: state.selectedFileIds.toList(),
                    ),
                  ),
                ),
                SizedBox(width: common.controlGap),
              ],
              if (canDownloadZip) ...[
                StorageChromePill(
                  key: const ValueKey('storage_bulk_download_zip'),
                  icon: AppIcons.download,
                  label: context.l10n.storageDownloadZip,
                  tooltip: context.l10n.storageDownloadZip,
                  onTap: () => unawaited(
                    fileMutationCubit.downloadZip(
                      fileIds: state.selectedFileIds.toList(),
                    ),
                  ),
                ),
                SizedBox(width: common.controlGap),
              ],
              if (canDelete)
                StorageChromePill(
                  key: const ValueKey('storage_bulk_delete'),
                  icon: AppIcons.delete,
                  label: context.l10n.storageDeleteSelected,
                  tooltip: context.l10n.storageDeleteSelected,
                  onTap: () =>
                      unawaited(showStorageDeleteConfirm(context, state)),
                ),
            ],
          ),
        );
      },
    );
  }
}
