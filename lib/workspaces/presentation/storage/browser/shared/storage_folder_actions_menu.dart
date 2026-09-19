import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Menu operacji folderu wspólne dla siatki i listy.
final class StorageFolderActionsMenu extends StatelessWidget {
  const StorageFolderActionsMenu({required this.folder, super.key});

  final StorageFolderResponse folder;

  /// Opens the desktop secondary-click menu for a folder.
  static void showContextMenu(
    BuildContext context,
    StorageFolderResponse folder,
    Offset position,
  ) {
    if (!folder.canEdit && !folder.canDelete) return;
    final l10n = context.l10n;
    unawaited(
      AppContextMenu.show(
        context,
        globalPosition: position,
        headerTitle: folder.name,
        actions: [
          if (folder.canEdit)
            AppContextMenuAction(
              label: l10n.storageRenameFolderDialogTitle,
              icon: AppIcons.documentText,
              onTap: (_) => showRename(context, folder),
            ),
          if (folder.canDelete)
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
    if (!folder.canEdit && !folder.canDelete) return const SizedBox.shrink();

    return PopupMenuButton<_StorageFolderAction>(
      tooltip: context.l10n.storageMoreOptionsTooltip,
      icon: const Icon(AppIcons.moreVertical, size: 17),
      onSelected: (action) => switch (action) {
        _StorageFolderAction.rename => unawaited(showRename(context, folder)),
        _StorageFolderAction.delete => unawaited(_delete(context)),
      },
      itemBuilder: (context) => [
        if (folder.canEdit)
          PopupMenuItem(
            value: _StorageFolderAction.rename,
            child: Text(context.l10n.storageRenameFolderDialogTitle),
          ),
        if (folder.canDelete)
          PopupMenuItem(
            value: _StorageFolderAction.delete,
            child: Text(
              context.l10n.delete,
              style: TextStyle(color: context.colors.error),
            ),
          ),
      ],
    );
  }

  /// Wyświetla współdzielony formularz zmiany nazwy folderu.
  static Future<void> showRename(
    BuildContext context,
    StorageFolderResponse folder,
  ) async {
    final controller = TextEditingController(text: folder.name);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.storageRenameFolderDialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: context.l10n.storageCreateFolderDialogHint,
          ),
          onSubmitted: (value) => Navigator.of(dialogContext).pop(value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: Text(context.l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();
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

  Future<void> _delete(BuildContext context) async {
    await _confirmDelete(context, folder);
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
