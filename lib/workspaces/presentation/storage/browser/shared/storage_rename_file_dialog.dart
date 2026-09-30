import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Formularz zmiany nazwy, która zachowuje rozszerzenie pliku.
abstract final class StorageRenameFileDialog {
  static Future<bool> show(
    BuildContext context,
    StorageFileResponse file,
  ) async {
    final extension = file.extension;
    final suffix = extension.isEmpty
        ? ''
        : extension.startsWith('.')
        ? extension
        : '.$extension';
    final originalName = file.originalFileName;
    final stem =
        suffix.isNotEmpty &&
            originalName.toLowerCase().endsWith(suffix.toLowerCase())
        ? originalName.substring(0, originalName.length - suffix.length)
        : originalName;
    final controller = TextEditingController(text: stem);
    final renamed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.storageRenameFileDialogTitle),
        content: SizedBox(
          width: 420,
          child: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 255 - suffix.length,
            decoration: InputDecoration(
              labelText: dialogContext.l10n.storageRenameFileHint,
              helperText: dialogContext.l10n.storageRenameFileExtensionHint,
              suffixText: suffix.isEmpty ? null : suffix,
            ),
            onSubmitted: (_) => _save(
              dialogContext,
              file,
              controller,
              suffix,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.close),
          ),
          FilledButton(
            onPressed: () => _save(
              dialogContext,
              file,
              controller,
              suffix,
            ),
            child: Text(dialogContext.l10n.storageRenameFolderButton),
          ),
        ],
      ),
    );
    controller.dispose();
    return renamed ?? false;
  }

  static Future<void> _save(
    BuildContext context,
    StorageFileResponse file,
    TextEditingController controller,
    String suffix,
  ) async {
    final stem = controller.text.trim();
    final name = '$stem$suffix';
    if (name == file.originalFileName || name.isEmpty) return;
    final success = await context.read<StorageFileMutationCubit>().renameFile(
      file: file,
      fileName: name,
    );
    if (success && context.mounted) Navigator.of(context).pop(true);
  }
}
