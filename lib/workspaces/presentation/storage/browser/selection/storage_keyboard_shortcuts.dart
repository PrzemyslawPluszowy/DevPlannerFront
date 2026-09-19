import 'dart:async';

import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/storage_selection_toolbar.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_folder_actions_menu.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Skróty klawiaturowe eksploratora, aktywne poza polami edycyjnymi.
final class StorageKeyboardShortcuts extends StatelessWidget {
  /// Tworzy zakres skrótów dla całego eksploratora.
  const StorageKeyboardShortcuts({required this.child, super.key});

  /// Zawartość przejmująca focus eksploratora.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyA, control: true): () =>
            _selectAll(context),
        const SingleActivator(LogicalKeyboardKey.keyA, meta: true): () =>
            _selectAll(context),
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            _outsideEditor(context, () {
              context.read<StorageSelectionCubit>().clearSelection();
            }),
        const SingleActivator(LogicalKeyboardKey.delete): () =>
            _deleteSelection(context),
        const SingleActivator(LogicalKeyboardKey.enter): () =>
            _openSelection(context, allowFolder: true),
        const SingleActivator(LogicalKeyboardKey.space): () =>
            _openSelection(context, allowFolder: false),
        const SingleActivator(LogicalKeyboardKey.f2): () =>
            _renameSelection(context),
      },
      child: Focus(
        autofocus: true,
        child: child,
      ),
    );
  }

  void _selectAll(BuildContext context) {
    _outsideEditor(context, () {
      final browserState = context.read<StorageBrowserCubit>().state;
      final selection = context.read<StorageSelectionCubit>();
      switch (browserState) {
        case StorageBrowserReady(:final files, :final folders):
          selection.selectAll(files: files, folders: folders);
        case StorageBrowserLoading(:final files, :final folders):
          selection.selectAll(files: files, folders: folders);
        case StorageBrowserEmpty():
        case StorageBrowserInitial():
        case StorageBrowserFailure():
        case StorageBrowserForbidden():
          selection.clearSelection();
      }
    });
  }

  void _deleteSelection(BuildContext context) {
    _outsideEditor(context, () {
      final state = context.read<StorageSelectionCubit>().state;
      if (state.hasSelection && state.canDelete) {
        unawaited(StorageSelectionToolbar.showDeleteConfirm(context, state));
      }
    });
  }

  void _openSelection(BuildContext context, {required bool allowFolder}) {
    _outsideEditor(context, () {
      final selection = context.read<StorageSelectionCubit>();
      final folder = selection.singleSelectedFolder;
      if (allowFolder && folder != null) {
        unawaited(context.read<StorageBrowserCubit>().openFolder(folder));
        return;
      }

      final file = selection.singleSelectedFile;
      if (file == null || !file.canPreview) return;
      unawaited(context.read<StoragePreviewCubit>().preparePreview(file));
      unawaited(
        showDialog<void>(
          context: context,
          builder: (_) => BlocProvider.value(
            value: context.read<StoragePreviewCubit>(),
            child: StoragePreviewDialog(file: file),
          ),
        ),
      );
    });
  }

  void _renameSelection(BuildContext context) {
    _outsideEditor(context, () {
      final folder = context.read<StorageSelectionCubit>().singleSelectedFolder;
      if (folder != null && folder.canEdit) {
        unawaited(StorageFolderActionsMenu.showRename(context, folder));
      }
    });
  }

  void _outsideEditor(BuildContext context, VoidCallback action) {
    final focusedContext = FocusManager.instance.primaryFocus?.context;
    if (focusedContext == null) {
      action();
      return;
    }

    // EditableText owns an internal Focus widget, so primaryFocus.context
    // commonly points at that wrapper rather than EditableText itself.
    if (focusedContext.widget is EditableText ||
        focusedContext.findAncestorWidgetOfExactType<EditableText>() != null) {
      return;
    }
    action();
  }
}
