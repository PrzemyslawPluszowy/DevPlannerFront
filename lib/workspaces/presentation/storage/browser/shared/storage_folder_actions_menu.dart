import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_chrome_pill.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Menu operacji folderu wspólne dla siatki i listy.
final class StorageFolderActionsMenu extends StatelessWidget {
  const StorageFolderActionsMenu({
    required this.folder,
    this.capabilities = StorageShellCapabilities.readOnly,
    super.key,
  });

  final StorageFolderResponse folder;

  /// Uprawnienia kompozycji decydujące o widoczności akcji folderu.
  final StorageShellCapabilities capabilities;

  /// Opens the desktop secondary-click menu for a folder.
  static void showContextMenu(
    BuildContext context,
    StorageFolderResponse folder,
    Offset position, {
    StorageShellCapabilities capabilities = StorageShellCapabilities.readOnly,
  }) {
    final canRename = capabilities.canRenameFolder && folder.canEdit;
    final canDelete = capabilities.canDelete && folder.canDelete;
    if (!canRename && !canDelete) return;
    final l10n = context.l10n;
    unawaited(
      AppContextMenu.show(
        context,
        globalPosition: position,
        headerTitle: folder.name,
        actions: [
          if (canRename)
            AppContextMenuAction(
              label: l10n.storageRenameFolderDialogTitle,
              icon: AppIcons.documentText,
              onTap: (_) => showRename(context, folder),
            ),
          if (canDelete)
            AppContextMenuAction(
              label: l10n.delete,
              icon: AppIcons.delete,
              isDestructive: true,
              onTap: (_) => _confirmDelete(context, folder),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canRename = capabilities.canRenameFolder && folder.canEdit;
    final canDelete = capabilities.canDelete && folder.canDelete;
    if (!canRename && !canDelete) return const SizedBox.shrink();

    return StorageChromePill(
      key: ValueKey('folder-actions-${folder.id}'),
      icon: AppIcons.moreVertical,
      tooltip: context.l10n.storageMoreOptionsTooltip,
      onTap: () => unawaited(_openMenu(context, canRename, canDelete)),
    );
  }

  /// Otwiera menu folderu na wspólnej powierzchni `AppContextMenu`.
  Future<void> _openMenu(
    BuildContext context,
    bool canRename,
    bool canDelete,
  ) async {
    final selected = await AppContextMenu.select<_StorageFolderAction>(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      headerTitle: folder.name,
      options: [
        if (canRename)
          AppContextMenuOption<_StorageFolderAction>(
            value: _StorageFolderAction.rename,
            label: context.l10n.storageRenameFolderDialogTitle,
            icon: AppIcons.documentText,
          ),
        if (canDelete)
          AppContextMenuOption<_StorageFolderAction>(
            value: _StorageFolderAction.delete,
            label: context.l10n.delete,
            icon: AppIcons.delete,
            isDestructive: true,
          ),
      ],
    );
    if (selected == null || !context.mounted) return;
    switch (selected) {
      case _StorageFolderAction.rename:
        await showRename(context, folder);
      case _StorageFolderAction.delete:
        await _confirmDelete(context, folder);
    }
  }

  /// Wyświetla współdzielony formularz zmiany nazwy folderu.
  static Future<void> showRename(
    BuildContext context,
    StorageFolderResponse folder,
  ) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _StorageRenameFolderDialog(initialName: folder.name),
    );
    if (name == null ||
        name.isEmpty ||
        name == folder.name ||
        !context.mounted) {
      return;
    }
    await context.read<StorageFolderMutationCubit>().renameFolder(
      folderId: folder.id,
      newName: name,
    );
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    StorageFolderResponse folder,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.storageDeleteConfirmTitle),
        content: Text(context.l10n.storageDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<StorageFolderMutationCubit>().deleteFolder(folder.id);
    }
  }
}

enum _StorageFolderAction { rename, delete }

/// Formularz zmiany nazwy folderu.
///
/// Kontroler należy do stanu dialogu, więc żyje dokładnie tyle, ile widżet:
/// zwolnienie po zamknięciu trasy ubijało go w trakcie animacji zamknięcia, gdy
/// pole jeszcze się renderowało.
class _StorageRenameFolderDialog extends StatefulWidget {
  const _StorageRenameFolderDialog({required this.initialName});

  final String initialName;

  @override
  State<_StorageRenameFolderDialog> createState() =>
      _StorageRenameFolderDialogState();
}

class _StorageRenameFolderDialogState
    extends State<_StorageRenameFolderDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialName,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.storageRenameFolderDialogTitle),
    content: TextField(
      controller: _controller,
      autofocus: true,
      decoration: InputDecoration(
        hintText: context.l10n.storageCreateFolderDialogHint,
      ),
      onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(context.l10n.cancel),
      ),
      FilledButton(
        onPressed: () => Navigator.of(context).pop(_controller.text.trim()),
        child: Text(context.l10n.save),
      ),
    ],
  );
}
