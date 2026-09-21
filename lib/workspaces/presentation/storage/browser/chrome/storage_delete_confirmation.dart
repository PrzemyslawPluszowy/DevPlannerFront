import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Potwierdzenie i wykonanie usunięcia bieżącego zaznaczenia.
///
/// Jedna ścieżka dla paska akcji masowych i skrótu Delete, żeby oba wejścia
/// pokazywały ten sam dialog i kasowały stan zaznaczenia dokładnie raz.
Future<void> showStorageDeleteConfirm(
  BuildContext context,
  StorageSelectionState state,
) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogCtx) => AlertDialog(
      title: Text(l10n.storageDeleteConfirmTitle),
      content: Text(l10n.storageDeleteConfirmMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogCtx).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => Navigator.of(dialogCtx).pop(true),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );

  if (confirmed != true || !context.mounted) return;
  final fileMutationCubit = context.read<StorageFileMutationCubit>();
  final selectionCubit = context.read<StorageSelectionCubit>();

  if (state.selectedFileIds.isNotEmpty || state.selectedFolderIds.isNotEmpty) {
    await fileMutationCubit.bulkDelete(
      fileIds: state.selectedFileIds.toList(),
      folderIds: state.selectedFolderIds.toList(),
    );
  }
  selectionCubit.clearSelection();
}
