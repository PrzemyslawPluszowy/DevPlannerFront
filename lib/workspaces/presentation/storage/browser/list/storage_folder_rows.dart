import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_folder_actions_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wiersze folderów w widoku tabelarycznym / liście eksploratora.
class StorageFolderRows extends StatelessWidget {
  /// Tworzy listę folderów.
  const StorageFolderRows({
    required this.folders,
    super.key,
  });

  /// Lista folderów do wyrenderowania.
  final List<StorageFolderResponse> folders;

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) return const SizedBox.shrink();

    final selectionCubit = context.watch<StorageSelectionCubit>();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: folders.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: context.colors.outlineVariant.withValues(alpha: 0.3),
      ),
      itemBuilder: (context, index) {
        final folder = folders[index];
        final isSelected = selectionCubit.state.isFolderSelected(folder.id);

        return GestureDetector(
          onSecondaryTapDown: (details) =>
              StorageFolderActionsMenu.showContextMenu(
                context,
                folder,
                details.globalPosition,
              ),
          child: ListTile(
            dense: true,
            selected: isSelected,
            selectedTileColor: context.colors.primaryContainer.withValues(
              alpha: 0.3,
            ),
            leading: Icon(
              AppIcons.folder,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              folder.name,
              style: context.text.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: folder.itemCount > 0
                ? Text(context.l10n.storageItemsCount(folder.itemCount))
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StorageFolderActionsMenu(folder: folder),
                const Icon(AppIcons.chevronRight, size: 16),
              ],
            ),
            onTap: () {
              if (selectionCubit.state.hasSelection) {
                selectionCubit.toggleFolder(folder);
              } else {
                unawaited(
                  context.read<StorageBrowserCubit>().openFolder(folder),
                );
              }
            },
            onLongPress: () => selectionCubit.toggleFolder(folder),
          ),
        );
      },
    );
  }
}
