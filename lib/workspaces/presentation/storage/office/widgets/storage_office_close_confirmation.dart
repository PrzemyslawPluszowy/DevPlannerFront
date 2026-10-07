import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Decyzja użytkownika przed utratą niepotwierdzonych zmian dokumentu.
abstract final class StorageOfficeCloseConfirmation {
  static Future<bool> confirm(
    BuildContext context, {
    required bool hasUnsavedChanges,
    bool isAwaitingSaveConfirmation = false,
    bool isSaveUnconfirmed = false,
  }) async {
    if (!hasUnsavedChanges &&
        !isAwaitingSaveConfirmation &&
        !isSaveUnconfirmed) {
      return true;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => _StorageOfficeCloseDialog(
        awaiting:
            !hasUnsavedChanges &&
            (isAwaitingSaveConfirmation || isSaveUnconfirmed),
      ),
    );
    return confirmed ?? false;
  }

  static Future<bool> confirmForceClose(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        builder: (_) => const _StorageOfficeCloseDialog(forced: true),
      ) ??
      false;
}

final class _StorageOfficeCloseDialog extends StatelessWidget {
  const _StorageOfficeCloseDialog({this.awaiting = false, this.forced = false});

  final bool awaiting;
  final bool forced;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    return AlertDialog(
      backgroundColor: tasks.canvas,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tasks.panelRadius),
        side: BorderSide(color: tasks.canvasBorder),
      ),
      constraints: const BoxConstraints(maxWidth: 480),
      elevation: 0,
      titleTextStyle: tasks.dataStrongText,
      contentTextStyle: tasks.controlText,
      title: Text(
        forced
            ? context.l10n.storageCloseOffice
            : awaiting
            ? context.l10n.storageOfficeCloseAwaitingTitle
            : context.l10n.storageOfficeCloseUnsavedTitle,
      ),
      content: Text(
        forced
            ? context.l10n.storageOfficeCloseUnconfirmed
            : awaiting
            ? context.l10n.storageOfficeCloseAwaitingBody
            : context.l10n.storageOfficeCloseUnsavedBody,
      ),
      actions: [
        TextButton(
          key: awaiting
              ? const ValueKey('storage_office_wait_for_save')
              : const ValueKey('storage_office_keep_editing'),
          style: TextButton.styleFrom(
            foregroundColor: context.colors.onSurface,
          ),
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            awaiting
                ? context.l10n.storageOfficeCloseWaitForSave
                : context.l10n.cancel,
          ),
        ),
        TextButton(
          key: const ValueKey('storage_office_close_anyway'),
          style: TextButton.styleFrom(foregroundColor: tasks.selectionAccent),
          onPressed: () => Navigator.pop(context, true),
          child: Text(context.l10n.close),
        ),
      ],
    );
  }
}
