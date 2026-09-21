import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/storage/office/cubit/storage_office_editor_actions_state.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wskaźnik połączenia i stanu zapisu dokumentu biurowego.
///
/// Stany są rozłączne i wynikają z sygnałów edytora oraz z potwierdzenia
/// backendu: brak połączenia, połączony ze zmianami, połączony bez zmian
/// czekający na zapis, zapis potwierdzony nową wersją pliku oraz brak
/// potwierdzenia w oknie kontroli. Ekran nie ogłasza zapisu na podstawie samego
/// braku lokalnych zmian w edytorze.
final class StorageOfficeStatusLabel extends StatelessWidget {
  /// Tworzy wskaźnik stanu sesji edytora.
  const StorageOfficeStatusLabel({required this.actions, super.key});

  /// Stan krótkotrwałych operacji i statusu sesji.
  final StorageOfficeEditorActionsState actions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (IconData icon, String label, Color color) = switch (actions) {
      StorageOfficeEditorActionsState(hasUnsavedChanges: true) => (
        Symbols.cloud_upload_rounded,
        l10n.storageOfficeUnsavedChanges,
        context.colors.tertiary,
      ),
      StorageOfficeEditorActionsState(
        saveConfirmation: StorageOfficeSaveConfirmation.confirmed,
      ) =>
        (
          Symbols.cloud_done_rounded,
          l10n.storageOfficeSavedChanges,
          context.colors.onSurfaceVariant,
        ),
      StorageOfficeEditorActionsState(
        saveConfirmation: StorageOfficeSaveConfirmation.awaitingServer,
      ) =>
        (
          Symbols.cloud_sync_rounded,
          l10n.storageOfficeSavingChanges,
          context.colors.onSurfaceVariant,
        ),
      StorageOfficeEditorActionsState(
        saveConfirmation: StorageOfficeSaveConfirmation.unconfirmed,
      ) =>
        (
          Symbols.cloud_off_rounded,
          l10n.storageOfficeSaveUnconfirmed,
          context.colors.error,
        ),
      // Połączony bez zmian i bez potwierdzonej wersji nie ma czego ogłaszać:
      // pokazuje połączenie, a nie zapis, którego backend nie potwierdził.
      StorageOfficeEditorActionsState(isSessionReady: true) => (
        Symbols.cloud_sync_rounded,
        l10n.storageOfficeConnected,
        context.colors.onSurfaceVariant,
      ),
      _ => (
        Symbols.cloud_sync_rounded,
        l10n.storageOfficeConnecting,
        context.colors.onSurfaceVariant,
      ),
    };

    return Row(
      key: const ValueKey('storage_office_status'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
          semanticLabel: actions.isSessionReady
              ? l10n.storageOfficeConnected
              : l10n.storageOfficeConnecting,
        ),
        const SizedBox(width: 6),
        Text(label, style: context.text.bodySmall?.copyWith(color: color)),
      ],
    );
  }
}
