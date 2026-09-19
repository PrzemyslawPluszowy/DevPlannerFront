import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Confirmation-backed delete action for a folder.
final class StorageFolderDeleteAction extends StatelessWidget {
  /// Creates a folder delete action.
  const StorageFolderDeleteAction({
    required this.folderId,
    this.buttonKey,
    super.key,
  });

  /// Folder identifier passed to the typed mutation Cubit.
  final String folderId;

  /// Optional key for deterministic composition/widget tests.
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) => IconButton(
    key: buttonKey,
    tooltip: context.l10n.delete,
    icon: const Icon(Icons.delete_outline),
    onPressed: () => _confirm(context),
  );

  Future<void> _confirm(BuildContext context) async {
    final confirmed = await _showConfirmation(context);
    if (confirmed != true || !context.mounted) return;
    await context.read<StorageFolderMutationCubit>().deleteFolder(folderId);
  }

  static Future<bool?> _showConfirmation(BuildContext context) =>
      showDialog<bool>(
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
}

/// Confirmation-backed delete action for a file.
final class StorageFileDeleteAction extends StatelessWidget {
  /// Creates a file delete action.
  const StorageFileDeleteAction({
    required this.fileId,
    this.buttonKey,
    super.key,
  });

  /// File identifier passed to the typed mutation Cubit.
  final String fileId;

  /// Optional key for deterministic composition/widget tests.
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) => IconButton(
    key: buttonKey,
    tooltip: context.l10n.delete,
    icon: const Icon(Icons.delete_outline),
    onPressed: () => _confirm(context),
  );

  Future<void> _confirm(BuildContext context) async {
    final confirmed = await StorageFolderDeleteAction._showConfirmation(
      context,
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<StorageFileMutationCubit>().deleteFile(fileId);
  }
}

/// Feedback boundary for confirmed file deletion and typed failures.
final class StorageFileMutationFeedback extends StatelessWidget {
  /// Creates the file mutation feedback boundary.
  const StorageFileMutationFeedback({
    required this.onDeleted,
    this.onRestored,
    required this.child,
    super.key,
  });

  /// Refreshes Files after a confirmed delete.
  final VoidCallback onDeleted;

  /// Refreshes Files after a confirmed restore, when restore is enabled.
  final VoidCallback? onRestored;

  /// Files content with file mutation controls.
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      BlocListener<StorageFileMutationCubit, StorageFileMutationState>(
        listener: (context, state) {
          switch (state) {
            case StorageFileMutationSuccess(
                  :final type,
                )
                when type == StorageFileMutationType.deleted:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.storageDeleteSuccess)),
              );
              onDeleted();
              context.read<StorageFileMutationCubit>().reset();
            case StorageFileMutationSuccess(
                  :final type,
                )
                when type == StorageFileMutationType.restored:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.l10n.storageRestoreSuccess)),
              );
              onRestored?.call();
              context.read<StorageFileMutationCubit>().reset();
            case StorageFileMutationSuccess(
                  :final type,
                  :final file,
                )
                when type == StorageFileMutationType.fileDownloaded:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.l10n.storageDownloadSuccess(
                      file?.originalFileName ?? '',
                    ),
                  ),
                ),
              );
              context.read<StorageFileMutationCubit>().reset();
            case final StorageFileMutationFailure failure:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_failureMessage(context, failure))),
              );
              context.read<StorageFileMutationCubit>().reset();
            case StorageFileMutationInitial() || StorageFileMutationLoading():
              break;
            case StorageFileMutationSuccess():
              break;
            case StorageFileMutationPartialSuccess():
              break;
          }
        },
        child: child,
      );

  static String _failureMessage(
    BuildContext context,
    StorageFileMutationFailure failure,
  ) => switch (failure.statusCode) {
    403 => context.l10n.storageForbiddenTitle,
    404 => context.l10n.storageMutationNotFound,
    409 => context.l10n.storageMutationConflict,
    400 || 422 => context.l10n.storageMutationValidation,
    _ => context.l10n.storagePreviewError(failure.message),
  };
}
