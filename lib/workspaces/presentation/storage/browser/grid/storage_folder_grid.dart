import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
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
            maxCrossAxisExtent: 280,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent:
                140 +
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

    final common = context.filesTheme.common;
    return StorageFolderDropTarget(
      folder: folder,
      enabled: capabilities.canMove && folder.canEdit && !folder.isDeleted,
      child: GestureDetector(
        onSecondaryTapDown: (details) =>
            StorageFolderActionsMenu.showContextMenu(
              context,
              folder,
              details.globalPosition,
              capabilities: capabilities,
            ),
        child: Container(
          padding: EdgeInsets.all(common.controlGap),
          decoration: BoxDecoration(
            color: isSelected
                ? context.colors.primaryContainer.withValues(alpha: .4)
                : context.colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(common.controlRadius),
            border: Border.all(
              color: isSelected
                  ? context.colors.primary
                  : context.colors.outlineVariant.withValues(alpha: .4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StorageItemSelectionCheckbox(
                    key: ValueKey('select-folder-${folder.id}'),
                    name: folder.name,
                    selected: isSelected,
                    onToggle: () => selectionCubit.toggleFolder(folder),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: context.filesTheme.folderIconSurface,
                      borderRadius: BorderRadius.circular(common.controlRadius),
                    ),
                    child: Icon(
                      AppIcons.folder,
                      size: 24,
                      color: context.filesTheme.folderIconColor,
                    ),
                  ),
                  const Spacer(),
                  StorageFolderActionsMenu(
                    folder: folder,
                    capabilities: capabilities,
                  ),
                ],
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
                  child: CallbackShortcuts(
                    bindings: {
                      const SingleActivator(LogicalKeyboardKey.enter): () =>
                          _activate(context),
                      const SingleActivator(LogicalKeyboardKey.space): () =>
                          _activate(context),
                    },
                    child: InkWell(
                      onTap: () => _activate(context),
                      onLongPress: () => selectionCubit.toggleFolder(folder),
                      borderRadius: BorderRadius.circular(common.controlRadius),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                style: common.metaText.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _activate(BuildContext context) {
    final selection = context.read<StorageSelectionCubit>();
    if (folder.isDeleted || selection.state.hasSelection) {
      selection.toggleFolder(folder);
    } else {
      unawaited(context.read<StorageBrowserCubit>().openFolder(folder));
    }
  }
}
