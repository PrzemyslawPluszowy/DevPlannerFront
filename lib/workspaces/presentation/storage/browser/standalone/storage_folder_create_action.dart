import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Handles confirmed folder mutation feedback and refreshes the current list.
final class StorageFolderMutationFeedback extends StatelessWidget {
  /// Creates a feedback boundary for folder create/rename/delete operations.
  const StorageFolderMutationFeedback({
    required this.onMutated,
    required this.child,
    super.key,
  });

  /// Refreshes the browser after a confirmed folder mutation.
  final VoidCallback onMutated;

  /// Files content with folder mutation controls.
  final Widget child;

  @override
  Widget build(
    BuildContext context,
  ) => BlocListener<StorageFolderMutationCubit, StorageFolderMutationState>(
    listener: (context, state) {
      switch (state) {
        case StorageFolderMutationSuccess(:final type)
            when type == StorageFolderMutationType.created ||
                type == StorageFolderMutationType.updated ||
                type == StorageFolderMutationType.deleted:
          final message = switch (type) {
            StorageFolderMutationType.created =>
              context.l10n.storageCreateFolderSuccess,
            StorageFolderMutationType.updated =>
              context.l10n.storageRenameFolderSuccess,
            StorageFolderMutationType.deleted =>
              context.l10n.storageDeleteSuccess,
            StorageFolderMutationType.moved => context.l10n.storagePreviewTitle,
          };
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          onMutated();
          context.read<StorageFolderMutationCubit>().reset();
        case final StorageFolderMutationFailure failure:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(_failureMessage(context, failure))),
          );
          context.read<StorageFolderMutationCubit>().reset();
        case StorageFolderMutationInitial() || StorageFolderMutationLoading():
          break;
        case StorageFolderMutationSuccess():
          break;
      }
    },
    child: child,
  );

  static String _failureMessage(
    BuildContext context,
    StorageFolderMutationFailure failure,
  ) => switch (failure.statusCode) {
    403 => context.l10n.storageForbiddenTitle,
    404 => context.l10n.storageMutationNotFound,
    409 => context.l10n.storageMutationConflict,
    400 || 422 => context.l10n.storageMutationValidation,
    _ => context.l10n.storagePreviewError(failure.message),
  };
}

/// Opens the typed create-folder operation for the current scope.
final class StorageFolderCreateAction extends StatelessWidget {
  /// Creates a folder action bound to the current scope.
  const StorageFolderCreateAction({
    required this.scope,
    super.key,
  });

  /// Current Storage scope, including the current folder as parent.
  final StorageScope scope;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageFolderMutationCubit, StorageFolderMutationState>(
        builder: (context, state) => FilledButton.icon(
          icon: const Icon(Icons.create_new_folder_outlined, size: 18),
          label: Text(context.l10n.storageCreateFolderButton),
          onPressed: state is StorageFolderMutationLoading
              ? null
              : () => _openDialog(context),
        ),
      );

  Future<void> _openDialog(BuildContext context) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _StorageFolderNameDialog(),
    );
    if (!context.mounted || name == null || name.trim().isEmpty) return;
    await context.read<StorageFolderMutationCubit>().createFolder(
      scope: scope,
      name: name,
      parentFolderId: scope.folderId,
    );
  }
}

/// Opens the typed rename-folder operation for an existing folder.
final class StorageFolderRenameAction extends StatelessWidget {
  /// Creates a rename action for one folder.
  const StorageFolderRenameAction({
    required this.folderId,
    required this.currentName,
    super.key,
  });

  /// Identifier used by `StorageRepository.updateFolder`.
  final String folderId;

  /// Current name shown in the rename field.
  final String currentName;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageFolderMutationCubit, StorageFolderMutationState>(
        builder: (context, state) => IconButton(
          tooltip: context.l10n.storageRenameFolderDialogTitle,
          icon: const Icon(Icons.drive_file_rename_outline),
          onPressed: state is StorageFolderMutationLoading
              ? null
              : () => _openDialog(context),
        ),
      );

  Future<void> _openDialog(BuildContext context) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _StorageFolderNameDialog(initialName: currentName),
    );
    if (!context.mounted || name == null || name.trim().isEmpty) return;
    await context.read<StorageFolderMutationCubit>().renameFolder(
      folderId: folderId,
      newName: name,
    );
  }
}

final class _StorageFolderNameDialog extends StatefulWidget {
  const _StorageFolderNameDialog({this.initialName = ''});

  final String initialName;

  @override
  State<_StorageFolderNameDialog> createState() =>
      _StorageFolderNameDialogState();
}

final class _StorageFolderNameDialogState
    extends State<_StorageFolderNameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(
      widget.initialName.isEmpty
          ? context.l10n.storageCreateFolderDialogTitle
          : context.l10n.storageRenameFolderDialogTitle,
    ),
    content: TextField(
      controller: _controller,
      autofocus: true,
      decoration: InputDecoration(
        hintText: context.l10n.storageCreateFolderDialogHint,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(context.l10n.cancel),
      ),
      FilledButton(
        onPressed: () {
          final value = _controller.text.trim();
          if (value.isNotEmpty) Navigator.of(context).pop(value);
        },
        child: Text(
          widget.initialName.isEmpty
              ? context.l10n.storageCreateFolderButton
              : context.l10n.storageRenameFolderButton,
        ),
      ),
    ],
  );
}
