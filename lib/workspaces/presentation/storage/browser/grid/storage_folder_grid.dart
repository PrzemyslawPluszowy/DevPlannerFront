import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_models.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/shared/storage_folder_actions_menu.dart';

/// Siatka folderów w widoku kafelkowym eksploratora.
class StorageFolderGrid extends StatelessWidget {
  /// Tworzy siatkę folderów.
  const StorageFolderGrid({
    required this.folders,
    super.key,
  });

  /// Lista folderów do wyrenderowania.
  final List<StorageFolderResponse> folders;

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            context.l10n.storageFoldersTitle,
            style: context.text.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 76,
          ),
          itemCount: folders.length,
          itemBuilder: (context, index) {
            final folder = folders[index];
            return _FolderCard(folder: folder);
          },
        ),
      ],
    );
  }
}

class _FolderCard extends StatelessWidget {
  const _FolderCard({required this.folder});

  final StorageFolderResponse folder;

  @override
  Widget build(BuildContext context) {
    final selectionCubit = context.watch<StorageSelectionCubit>();
    final isSelected = selectionCubit.state.isFolderSelected(folder.id);

    return GestureDetector(
      onSecondaryTapDown: (details) => StorageFolderActionsMenu.showContextMenu(
        context,
        folder,
        details.globalPosition,
      ),
      child: InkWell(
        onTap: () {
          if (selectionCubit.state.hasSelection) {
            selectionCubit.toggleFolder(folder);
          } else {
            unawaited(context.read<StorageBrowserCubit>().openFolder(folder));
          }
        },
        onLongPress: () => selectionCubit.toggleFolder(folder),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? context.colors.primaryContainer.withValues(alpha: 0.4)
                : context.colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : context.colors.outlineVariant.withValues(alpha: 0.4),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Icon(
                AppIcons.folder,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      folder.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (folder.itemCount > 0)
                      Text(
                        context.l10n.storageItemsCount(folder.itemCount),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.labelSmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              StorageFolderActionsMenu(folder: folder),
            ],
          ),
        ),
      ),
    );
  }
}
