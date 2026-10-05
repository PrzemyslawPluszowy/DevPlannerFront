import 'dart:async';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_view_preference.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_drag_and_drop.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_folder_actions_menu.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_item_selection_checkbox.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Wiersze folderów w widoku tabelarycznym / liście eksploratora.
class StorageFolderRows extends StatelessWidget {
  /// Tworzy listę folderów.
  const StorageFolderRows({
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

    final selectionCubit = context.watch<StorageSelectionCubit>();
    final dense =
        context.select<StorageBrowserCubit, StorageDensity>(
          (cubit) => cubit.currentDensity,
        ) ==
        StorageDensity.compact;

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

        return _FolderRow(
          folder: folder,
          capabilities: capabilities,
          dense: dense,
          isSelected: isSelected,
        );
      },
    );
  }
}

/// Otwarcie folderu i jego menu są niezależnymi celami focus oraz semantyki.
final class _FolderRow extends StatelessWidget {
  const _FolderRow({
    required this.folder,
    required this.capabilities,
    required this.dense,
    required this.isSelected,
  });
  final StorageFolderResponse folder;
  final StorageShellCapabilities capabilities;
  final bool dense;
  final bool isSelected;

  void _activate(BuildContext context) {
    final selection = context.read<StorageSelectionCubit>();
    if (selection.state.hasSelection) {
      selection.toggleFolder(folder);
    } else {
      unawaited(context.read<StorageBrowserCubit>().openFolder(folder));
    }
  }

  @override
  Widget build(BuildContext context) => StorageFolderDropTarget(
    folder: folder,
    enabled: capabilities.canMove && folder.canEdit,
    child: GestureDetector(
      onSecondaryTapDown: (details) => StorageFolderActionsMenu.showContextMenu(
        context,
        folder,
        details.globalPosition,
        capabilities: capabilities,
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
              onLongPress: () =>
                  context.read<StorageSelectionCubit>().toggleFolder(folder),
              child: CallbackShortcuts(
                bindings: {
                  const SingleActivator(LogicalKeyboardKey.enter): () =>
                      _activate(context),
                  const SingleActivator(LogicalKeyboardKey.space): () =>
                      _activate(context),
                },
                child: ListTile(
                  dense: dense,
                  minVerticalPadding: dense ? 4 : 8,
                  selected: isSelected,
                  selectedTileColor: context.colors.primaryContainer.withValues(
                    alpha: 0.3,
                  ),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      AppIcons.folder,
                      color: Color(0xFFD58A00),
                      size: 20,
                    ),
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
                  trailing: const Icon(AppIcons.chevronRight, size: 16),
                  onTap: () => _activate(context),
                  onLongPress: () => context
                      .read<StorageSelectionCubit>()
                      .toggleFolder(folder),
                ),
              ),
            ),
          ),
          StorageFolderActionsMenu(folder: folder, capabilities: capabilities),
          const SizedBox(width: 16),
        ],
      ),
    ),
  );
}
