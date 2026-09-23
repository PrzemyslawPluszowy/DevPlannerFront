import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Rozstrzyga, czy wolno zamknąć edytor dokumentu.
///
/// Dokument bez niepotwierdzonych zmian zamyka się od razu. Gdy OnlyOffice
/// zgłosił zmiany czekające na zapis, zamknięcie wymaga świadomej decyzji
/// użytkownika — autosave jest asynchroniczny, więc pośpiech mógłby zakończyć
/// sesję przed callbackiem zapisu. Osobny komunikat dostaje stan „edytor bez
/// zmian, backend nie potwierdził jeszcze wersji”: brak lokalnych zmian nie
/// znaczy, że treść jest już utrwalona.
Future<bool> confirmStorageOfficeClose(
  BuildContext context, {
  required bool hasUnsavedChanges,
  bool isAwaitingSaveConfirmation = false,
  bool isSaveUnconfirmed = false,
}) async {
  if (!hasUnsavedChanges && !isAwaitingSaveConfirmation && !isSaveUnconfirmed) {
    return true;
  }
  final awaiting = !hasUnsavedChanges && isAwaitingSaveConfirmation;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        awaiting
            ? context.l10n.storageOfficeCloseAwaitingTitle
            : context.l10n.storageOfficeCloseUnsavedTitle,
      ),
      content: Text(
        awaiting
            ? context.l10n.storageOfficeCloseAwaitingBody
            : context.l10n.storageOfficeCloseUnsavedBody,
      ),
      actions: [
        TextButton(
          key: awaiting
              ? const ValueKey('storage_office_wait_for_save')
              : const ValueKey('storage_office_keep_editing'),
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(
            awaiting
                ? context.l10n.storageOfficeCloseWaitForSave
                : context.l10n.cancel,
          ),
        ),
        TextButton(
          key: const ValueKey('storage_office_close_anyway'),
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(context.l10n.close),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
