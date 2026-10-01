import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Potwierdzenie i wykonanie usunięcia bieżącego zaznaczenia.
///
/// Jedna ścieżka dla paska akcji masowych i skrótu Delete, żeby oba wejścia
/// pokazywały ten sam dialog. Listener usuwa z zaznaczenia tylko zakończone ID.
final class StorageDeleteConfirmation {
  const StorageDeleteConfirmation._();

  static Future<void> show(
    BuildContext context,
    StorageSelectionState state,
  ) async {
    if (!state.canDelete || !state.hasSelection) return;
    final fileMutationCubit = context.read<StorageFileMutationCubit>();
    final selectionCubit = context.read<StorageSelectionCubit>();
    final browserCubit = context.read<StorageBrowserCubit>();
    final initialScope = browserCubit.currentScope;
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: context.tasksTheme.scrim,
      builder: (_) => _StorageDeleteDialog(
        title: l10n.storageDeleteConfirmTitle,
        message: l10n.storageDeleteConfirmMessage,
        cancelLabel: l10n.cancel,
        deleteLabel: l10n.delete,
      ),
    );

    if (confirmed != true ||
        !context.mounted ||
        fileMutationCubit.isClosed ||
        selectionCubit.isClosed ||
        browserCubit.isClosed ||
        !identical(
          context.read<StorageFileMutationCubit>(),
          fileMutationCubit,
        ) ||
        !identical(context.read<StorageSelectionCubit>(), selectionCubit) ||
        !identical(context.read<StorageBrowserCubit>(), browserCubit) ||
        browserCubit.currentScope != initialScope) {
      return;
    }
    final currentSelection = selectionCubit.state;
    if (!currentSelection.canDelete ||
        !setEquals(currentSelection.selectedFileIds, state.selectedFileIds) ||
        !setEquals(
          currentSelection.selectedFolderIds,
          state.selectedFolderIds,
        )) {
      return;
    }
    final selectedFileIds = List<String>.unmodifiable(state.selectedFileIds);
    final selectedFolderIds = List<String>.unmodifiable(
      state.selectedFolderIds,
    );

    await fileMutationCubit.bulkDelete(
      fileIds: selectedFileIds,
      folderIds: selectedFolderIds,
    );
    if (!context.mounted ||
        fileMutationCubit.isClosed ||
        selectionCubit.isClosed ||
        browserCubit.isClosed ||
        !identical(
          context.read<StorageFileMutationCubit>(),
          fileMutationCubit,
        ) ||
        !identical(context.read<StorageSelectionCubit>(), selectionCubit) ||
        !identical(context.read<StorageBrowserCubit>(), browserCubit) ||
        browserCubit.currentScope != initialScope) {
      return;
    }
  }
}

/// Zwarta powierzchnia potwierdzenia wspólna z Listą, Kanbanem i Files.
final class _StorageDeleteDialog extends StatelessWidget {
  const _StorageDeleteDialog({
    required this.title,
    required this.message,
    required this.cancelLabel,
    required this.deleteLabel,
  });

  final String title;
  final String message;
  final String cancelLabel;
  final String deleteLabel;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(tasks.controlRadius),
    );
    return AlertDialog(
      backgroundColor: tasks.canvas,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrollable: true,
      insetPadding: EdgeInsets.all(tasks.sectionGap),
      constraints: const BoxConstraints(maxWidth: 480),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tasks.panelRadius),
        side: BorderSide(color: tasks.canvasBorder),
      ),
      titlePadding: EdgeInsets.all(tasks.sectionGap),
      contentPadding: EdgeInsets.fromLTRB(
        tasks.sectionGap,
        0,
        tasks.sectionGap,
        tasks.sectionGap,
      ),
      actionsPadding: EdgeInsets.fromLTRB(
        tasks.sectionGap,
        0,
        tasks.sectionGap,
        tasks.sectionGap,
      ),
      titleTextStyle: tasks.projectTitleText.copyWith(color: colors.onSurface),
      contentTextStyle: tasks.dataText.copyWith(color: colors.onSurfaceVariant),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          autofocus: true,
          style: TextButton.styleFrom(
            foregroundColor: colors.onSurface,
            textStyle: tasks.controlText,
            shape: buttonShape,
            minimumSize: Size(0, tasks.commandRowHeight),
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.onError,
            textStyle: tasks.controlText,
            shape: buttonShape,
            minimumSize: Size(0, tasks.commandRowHeight),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(deleteLabel),
        ),
      ],
    );
  }
}
