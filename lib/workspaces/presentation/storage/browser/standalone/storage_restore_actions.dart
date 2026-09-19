import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Confirmation-backed restore action for a deleted file.
final class StorageFileRestoreAction extends StatelessWidget {
  /// Creates a restore action.
  const StorageFileRestoreAction({
    required this.fileId,
    this.buttonKey,
    super.key,
  });

  /// Identifier passed to the typed Storage mutation Cubit.
  final String fileId;

  /// Optional key for deterministic widget tests.
  final Key? buttonKey;

  @override
  Widget build(BuildContext context) => IconButton(
    key: buttonKey,
    tooltip: context.l10n.storageRestoreSelected,
    icon: const Icon(Icons.restore_outlined),
    onPressed: () => _confirm(context),
  );

  Future<void> _confirm(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.storageRestoreConfirmTitle),
        content: Text(context.l10n.storageRestoreConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.storageRestoreSelected),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<StorageFileMutationCubit>().restoreFile(fileId);
  }
}
