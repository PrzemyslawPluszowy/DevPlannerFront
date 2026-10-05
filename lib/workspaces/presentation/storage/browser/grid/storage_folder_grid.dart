import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_drag_and_drop.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_folder_actions_menu.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_grid_name.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_item_selection_checkbox.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Siatka folderów w widoku kafelkowym eksploratora.
class StorageFolderGrid extends StatelessWidget {
  /// Tworzy siatkę folderów.
  const StorageFolderGrid({
    required this.folders,
    this.capabilities = StorageShellCapabilities.readOnly,
    super.key,
  });

  /// Lista folderów do wyrenderowania.
  final List<StorageFolderResponse> folders;

  /// Uprawnienia kompozycji przekazywane do menu folderu.
  final StorageShellCapabilities capabilities;

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
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent:
                104 +
                (MediaQuery.textScalerOf(context).scale(12) - 12)
                        .clamp(0, double.infinity)
                        .toDouble() *
                    4,
          ),
          itemCount: folders.length,
          itemBuilder: (context, index) {
            final folder = folders[index];
            return _FolderCard(folder: folder, capabilities: capabilities);
          },
        ),
      ],
    );
  }
}

class _FolderCard extends StatelessWidget {
  const _FolderCard({required this.folder, required this.capabilities});

  final StorageFolderResponse folder;
  final StorageShellCapabilities capabilities;

  @override
  Widget build(BuildContext context) {
    final selectionCubit = context.watch<StorageSelectionCubit>();
    final isSelected = selectionCubit.state.isFolderSelected(folder.id);

    return StorageFolderDropTarget(
      folder: folder,
      enabled: capabilities.canMove && folder.canEdit,
      child: GestureDetector(
        onSecondaryTapDown: (details) =>
            StorageFolderActionsMenu.showContextMenu(
              context,
              folder,
              details.globalPosition,
              capabilities: capabilities,
            ),
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
              StorageItemSelectionCheckbox(
                key: ValueKey('select-folder-${folder.id}'),
                name: folder.name,
                selected: isSelected,
                onToggle: () =>
                    context.read<StorageSelectionCubit>().toggleFolder(folder),
              ),
              Expanded(
                child: Semantics(
                  key: ValueKey('folder-open-${folder.id}'),
                  container: true,
                  button: true,
                  label: folder.name,
                  selected: isSelected,
                  excludeSemantics: true,
                  onTap: () => _activate(context),
                  onLongPress: () => context
                      .read<StorageSelectionCubit>()
                      .toggleFolder(folder),
                  child: CallbackShortcuts(
                    bindings: {
                      const SingleActivator(LogicalKeyboardKey.enter): () =>
                          _activate(context),
                      const SingleActivator(LogicalKeyboardKey.space): () =>
                          _activate(context),
                    },
                    child: InkWell(
                      onTap: () => _activate(context),
                      onLongPress: () => context
                          .read<StorageSelectionCubit>()
                          .toggleFolder(folder),
                      borderRadius: BorderRadius.circular(8),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.amber.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              AppIcons.folder,
                              size: 23,
                              color: Color(0xFFD58A00),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StorageGridName(
                                  name: folder.name,
                                  style: context.text.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (folder.itemCount > 0)
                                  Text(
                                    context.l10n.storageItemsCount(
                                      folder.itemCount,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: context.text.labelSmall?.copyWith(
                                      color: context.colors.onSurfaceVariant,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              StorageFolderActionsMenu(
                folder: folder,
                capabilities: capabilities,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _activate(BuildContext context) {
    final selection = context.read<StorageSelectionCubit>();
    if (selection.state.hasSelection) {
      selection.toggleFolder(folder);
    } else {
      unawaited(context.read<StorageBrowserCubit>().openFolder(folder));
    }
  }
}
