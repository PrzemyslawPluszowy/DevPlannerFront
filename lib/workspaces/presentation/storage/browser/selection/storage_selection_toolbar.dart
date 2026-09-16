import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/selection/cubit/storage_selection_state.dart';

/// Pasek akcji masowych (Bulk Toolbar) pojawiający się po zaznaczeniu plików lub folderów.
class StorageSelectionToolbar extends StatelessWidget {
  /// Tworzy pasek operacji masowych.
  const StorageSelectionToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<StorageSelectionCubit, StorageSelectionState>(
      builder: (context, state) {
        if (!state.hasSelection) {
          return const SizedBox.shrink();
        }

        final selectionCubit = context.read<StorageSelectionCubit>();
        final fileMutationCubit = context.read<StorageFileMutationCubit>();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: context.colors.primaryContainer.withValues(alpha: 0.3),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(AppIcons.close, size: 18),
                tooltip: l10n.storageClearSelection,
                onPressed: selectionCubit.clearSelection,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.storageSelectedCount(state.count),
                style: context.text.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface,
                ),
              ),
              const Spacer(),
              if (state.canDownloadZip && state.selectedFileIds.isNotEmpty) ...[
                TextButton.icon(
                  icon: const Icon(AppIcons.download, size: 16),
                  label: Text(l10n.storageDownloadZip),
                  onPressed: () {
                    unawaited(
                      fileMutationCubit.downloadZip(
                        fileIds: state.selectedFileIds.toList(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
              ],
              if (state.canDelete) ...[
                TextButton.icon(
                  icon: Icon(
                    AppIcons.delete,
                    size: 16,
                    color: context.colors.error,
                  ),
                  label: Text(
                    l10n.storageDeleteSelected,
                    style: TextStyle(color: context.colors.error),
                  ),
                  onPressed: () {
                    unawaited(showDeleteConfirm(context, state));
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  /// Potwierdza i wykonuje usunięcie aktualnego zaznaczenia.
  static Future<void> showDeleteConfirm(
    BuildContext context,
    StorageSelectionState state,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.storageDeleteConfirmTitle),
        content: Text(l10n.storageDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogCtx).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final fileMutationCubit = context.read<StorageFileMutationCubit>();
      final selectionCubit = context.read<StorageSelectionCubit>();

      if (state.selectedFileIds.isNotEmpty ||
          state.selectedFolderIds.isNotEmpty) {
        await fileMutationCubit.bulkDelete(
          fileIds: state.selectedFileIds.toList(),
          folderIds: state.selectedFolderIds.toList(),
        );
      }
      selectionCubit.clearSelection();
    }
  }
}
