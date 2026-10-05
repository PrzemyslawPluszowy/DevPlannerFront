import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_chrome_pill.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_folder_action_dialogs.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_folder_action_result.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_folder_delete_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Menu operacji folderu wspólne dla siatki i listy.
final class StorageFolderActionsMenu extends StatelessWidget {
  const StorageFolderActionsMenu({
    required this.folder,
    this.capabilities = StorageShellCapabilities.readOnly,
    super.key,
  });

  final StorageFolderResponse folder;
  final StorageShellCapabilities capabilities;

  /// Otwiera menu drugiego przycisku myszy na wspólnej powierzchni webowej.
  static void showContextMenu(
    BuildContext context,
    StorageFolderResponse folder,
    Offset position, {
    StorageShellCapabilities capabilities = StorageShellCapabilities.readOnly,
  }) {
    final canRename = capabilities.canRenameFolder && folder.canEdit;
    final canDelete = capabilities.canDelete && folder.canDelete;
    if (!canRename && !canDelete) return;
    final source = context.read<StorageFolderMutationCubit>();
    final browser = context.read<StorageBrowserCubit>();
    final scope = browser.currentScope;
    final snapshot = folder;
    final l10n = context.l10n;
    unawaited(
      AppContextMenu.show(
        context,
        globalPosition: position,
        headerTitle: snapshot.name,
        actions: [
          if (canRename)
            AppContextMenuAction(
              label: l10n.storageRenameFolderDialogTitle,
              icon: AppIcons.documentText,
              onTap: (_) => _rename(context, source, browser, scope, snapshot),
            ),
          if (canDelete)
            AppContextMenuAction(
              label: l10n.delete,
              icon: AppIcons.delete,
              isDestructive: true,
              onTap: (_) => _delete(context, source, browser, scope, snapshot),
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
    return Semantics(
      container: true,
      button: true,
      label: '${context.l10n.storageMoreOptionsTooltip}: ${folder.name}',
      excludeSemantics: true,
      onTap: () => unawaited(_openMenu(context, canRename, canDelete)),
      child: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.enter): () =>
              unawaited(_openMenu(context, canRename, canDelete)),
          const SingleActivator(LogicalKeyboardKey.space): () =>
              unawaited(_openMenu(context, canRename, canDelete)),
        },
        child: StorageChromePill(
          key: ValueKey('folder-actions-${folder.id}'),
          icon: AppIcons.moreVertical,
          tooltip: context.l10n.storageMoreOptionsTooltip,
          onTap: () => unawaited(_openMenu(context, canRename, canDelete)),
        ),
      ),
    );
  }

  Future<void> _openMenu(
    BuildContext context,
    bool canRename,
    bool canDelete,
  ) async {
    final source = context.read<StorageFolderMutationCubit>();
    final browser = context.read<StorageBrowserCubit>();
    final scope = browser.currentScope;
    final snapshot = folder;
    final selected = await AppContextMenu.select<_StorageFolderAction>(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      headerTitle: snapshot.name,
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
    if (!context.mounted || selected == null) return;
    final owner = _StorageFolderActionOwner(
      context: context,
      source: source,
      browser: browser,
      scope: scope,
      folder: snapshot,
    );
    if (!owner.isCurrent) return;
    final action = switch (selected) {
      _StorageFolderAction.rename => _rename(
        context,
        source,
        browser,
        scope,
        snapshot,
      ),
      _StorageFolderAction.delete => _delete(
        context,
        source,
        browser,
        scope,
        snapshot,
      ),
    };
    await action;
  }

  static Future<void> showRename(
    BuildContext context,
    StorageFolderResponse folder,
  ) async {
    final source = context.read<StorageFolderMutationCubit>();
    final browser = context.read<StorageBrowserCubit>();
    await _rename(context, source, browser, browser.currentScope, folder);
  }

  static Future<void> _rename(
    BuildContext context,
    StorageFolderMutationCubit source,
    StorageBrowserCubit browser,
    StorageScope scope,
    StorageFolderResponse folder,
  ) async {
    final owner = _StorageFolderActionOwner(
      context: context,
      source: source,
      browser: browser,
      scope: scope,
      folder: folder,
    );
    if (!owner.isCurrent) return;
    await StorageFolderRenameDialog.show(
      context,
      source: source,
      folderName: folder.name,
      onSave: owner.rename,
    );
  }

  static Future<void> _delete(
    BuildContext context,
    StorageFolderMutationCubit source,
    StorageBrowserCubit browser,
    StorageScope scope,
    StorageFolderResponse folder,
  ) async {
    final owner = _StorageFolderActionOwner(
      context: context,
      source: source,
      browser: browser,
      scope: scope,
      folder: folder,
    );
    if (!owner.isCurrent) return;
    await StorageFolderDeleteDialog.show(
      context,
      source: source,
      folderName: folder.name,
      onDelete: owner.delete,
    );
  }
}

enum _StorageFolderAction { rename, delete }

/// Zachowuje dokładne właściciele i zakres sprzed otwarcia dialogu.
final class _StorageFolderActionOwner {
  const _StorageFolderActionOwner({
    required this.context,
    required this.source,
    required this.browser,
    required this.scope,
    required this.folder,
  });

  final BuildContext context;
  final StorageFolderMutationCubit source;
  final StorageBrowserCubit browser;
  final StorageScope scope;
  final StorageFolderResponse folder;

  bool get isCurrent =>
      context.mounted &&
      !source.isClosed &&
      !browser.isClosed &&
      identical(context.read<StorageFolderMutationCubit>(), source) &&
      identical(context.read<StorageBrowserCubit>(), browser) &&
      browser.currentScope == scope;

  Future<StorageFolderActionOutcome> rename(String name) async {
    if (!isCurrent) return StorageFolderActionOutcome.stale;
    if (!source.canMutate) return StorageFolderActionOutcome.failed;
    await source.renameFolder(folderId: folder.id, newName: name);
    if (!isCurrent) return StorageFolderActionOutcome.stale;
    return source.state is StorageFolderMutationSuccess
        ? StorageFolderActionOutcome.succeeded
        : StorageFolderActionOutcome.failed;
  }

  Future<StorageFolderActionOutcome> delete() async {
    if (!isCurrent) return StorageFolderActionOutcome.stale;
    if (!source.canMutate) return StorageFolderActionOutcome.failed;
    await source.deleteFolder(folder.id);
    if (!isCurrent) return StorageFolderActionOutcome.stale;
    return source.state is StorageFolderMutationSuccess
        ? StorageFolderActionOutcome.succeeded
        : StorageFolderActionOutcome.failed;
  }
}
