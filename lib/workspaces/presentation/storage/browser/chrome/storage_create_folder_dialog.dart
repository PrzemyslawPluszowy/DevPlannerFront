import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Dialog tworzenia folderu w bieżącym zakresie.
///
/// Zwraca wyłącznie zatwierdzoną nazwę; utworzenie folderu należy do Cubita,
/// który wywołuje wywołujący, więc dialog nie zna repozytorium.
final class StorageCreateFolderDialog extends StatefulWidget {
  /// Tworzy dialog tworzenia folderu.
  const StorageCreateFolderDialog({super.key});

  /// Pokazuje dialog i zwraca zatwierdzoną nazwę albo `null`.
  static Future<String?> show(BuildContext context) =>
      DevPlannerModalHost.showDialog<String>(
        context,
        builder: (_) => const StorageCreateFolderDialog(),
      );

  @override
  State<StorageCreateFolderDialog> createState() =>
      _StorageCreateFolderDialogState();
}

class _StorageCreateFolderDialogState extends State<StorageCreateFolderDialog> {
  /// Kontroler należy do stanu dialogu, więc żyje dokładnie tyle, ile widżet.
  ///
  /// Zwolnienie po zamknięciu trasy (`whenComplete`) ubijało kontroler w trakcie
  /// animacji zamknięcia: pole jeszcze się renderowało, a każda przebudowa
  /// drzewa w tym oknie sięgała po zwolniony obiekt.
  final TextEditingController _controller = TextEditingController();

  final ValueNotifier<bool> _required = ValueNotifier(false);

  @override
  void dispose() {
    _controller.dispose();
    _required.dispose();
    super.dispose();
  }

  void _cancel() => Navigator.of(context).pop();

  void _create() => _submit(_controller.text);

  void _nameChanged(String name) {
    if (_required.value && name.trim().isNotEmpty) _required.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    final shape = RoundedRectangleBorder(
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
      titleTextStyle: tasks.projectTitleText.copyWith(color: colors.onSurface),
      title: Text(context.l10n.storageCreateFolderDialogTitle),
      content: SizedBox(
        width: 360,
        child: ValueListenableBuilder<bool>(
          valueListenable: _required,
          builder: (context, required, _) => TextField(
            key: const ValueKey('storage_folder_create_name'),
            controller: _controller,
            autofocus: true,
            style: tasks.dataText.copyWith(color: colors.onSurface),
            decoration: InputDecoration(
              labelText: context.l10n.workspacesFolderNameLabel,
              hintText: context.l10n.storageCreateFolderDialogHint,
              labelStyle: tasks.controlText.copyWith(
                color: colors.onSurfaceVariant,
              ),
              hintStyle: tasks.dataText.copyWith(
                color: colors.onSurfaceVariant,
              ),
              filled: true,
              fillColor: tasks.canvas,
              errorText: required ? context.l10n.authFieldRequired : null,
              errorMaxLines: 2,
              errorStyle: tasks.metaText.copyWith(color: colors.error),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(tasks.controlRadius),
                borderSide: BorderSide(color: tasks.canvasBorder),
              ),
            ),
            onChanged: _nameChanged,
            onSubmitted: _submit,
          ),
        ),
      ),
      actions: [
        TextButton(
          key: const ValueKey('storage_folder_create_cancel'),
          style: TextButton.styleFrom(
            foregroundColor: colors.onSurface,
            textStyle: tasks.controlText,
            shape: shape,
          ),
          onPressed: _cancel,
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          key: const ValueKey('storage_folder_create_confirm'),
          style: FilledButton.styleFrom(
            backgroundColor: colors.onSurface,
            foregroundColor: colors.surface,
            textStyle: tasks.controlText,
            shape: shape,
          ),
          onPressed: _create,
          child: Text(context.l10n.storageCreateFolderButton),
        ),
      ],
    );
  }

  void _submit(String rawName) {
    final name = rawName.trim();
    if (name.isEmpty) {
      _required.value = true;
      return;
    }
    Navigator.of(context).pop(name);
  }
}
