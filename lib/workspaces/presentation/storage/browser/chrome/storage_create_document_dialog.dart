import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:flutter/material.dart';

/// Nazwa i format nowego dokumentu wybrane w dialogu.
typedef StorageCreateDocumentRequest = ({
  String name,
  StorageDocumentFormat format,
});

/// Dialog tworzenia pustego dokumentu biurowego.
///
/// Wybór formatu jest lokalnym stanem kontrolki z jawnym właścicielem, a nie
/// polem modułu: dialog nie zna repozytorium i nie tworzy niczego sam.
final class StorageCreateDocumentDialog extends StatefulWidget {
  /// Tworzy dialog tworzenia dokumentu.
  const StorageCreateDocumentDialog({super.key});

  /// Pokazuje dialog i zwraca wybór użytkownika albo `null`.
  static Future<StorageCreateDocumentRequest?> show(BuildContext context) =>
      DevPlannerModalHost.showDialog<StorageCreateDocumentRequest>(
        context,
        builder: (_) => const StorageCreateDocumentDialog(),
      );

  @override
  State<StorageCreateDocumentDialog> createState() =>
      _StorageCreateDocumentDialogState();
}

class _StorageCreateDocumentDialogState
    extends State<StorageCreateDocumentDialog> {
  /// Kontroler nazwy dokumentu należy do stanu dialogu, więc żyje dokładnie
  /// tyle, ile widżet — zwolnienie po zamknięciu trasy ubijało go w trakcie
  /// animacji zamknięcia, gdy pole jeszcze się renderowało.
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<StorageDocumentFormat> _format = ValueNotifier(
    StorageDocumentFormat.docx,
  );

  final ValueNotifier<bool> _nameRequired = ValueNotifier(false);

  @override
  void dispose() {
    _controller.dispose();
    _format.dispose();
    _nameRequired.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      _nameRequired.value = true;
      return;
    }
    Navigator.of(context).pop((name: name, format: _format.value));
  }

  void _nameChanged(String name) {
    if (_nameRequired.value && name.trim().isNotEmpty) {
      _nameRequired.value = false;
    }
  }

  void _formatChanged(StorageDocumentFormat? format) {
    if (format != null) _format.value = format;
  }

  void _cancel() => Navigator.of(context).pop();

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
      title: Text(context.l10n.storageCreateDocumentDialogTitle),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _nameRequired,
              builder: (context, required, _) => TextField(
                key: const ValueKey('storage_document_name'),
                controller: _controller,
                autofocus: true,
                style: tasks.dataText.copyWith(color: colors.onSurface),
                onChanged: _nameChanged,
                decoration: InputDecoration(
                  labelText: context.l10n.storageDocumentName,
                  hintText: context.l10n.storageDocumentNameHint,
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
              ),
            ),
            SizedBox(height: tasks.controlGap),
            ValueListenableBuilder<StorageDocumentFormat>(
              valueListenable: _format,
              builder: (context, format, _) =>
                  DropdownButtonFormField<StorageDocumentFormat>(
                    key: const ValueKey('storage_document_format'),
                    initialValue: format,
                    isExpanded: true,
                    menuMaxHeight: 280,
                    dropdownColor: tasks.canvas,
                    borderRadius: BorderRadius.circular(tasks.controlRadius),
                    style: tasks.dataText.copyWith(color: colors.onSurface),
                    decoration: InputDecoration(
                      labelText: context.l10n.storageDocumentFormat,
                      labelStyle: tasks.controlText.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                      filled: true,
                      fillColor: tasks.canvas,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          tasks.controlRadius,
                        ),
                        borderSide: BorderSide(color: tasks.canvasBorder),
                      ),
                    ),
                    items: [
                      for (final item in StorageDocumentFormat.values)
                        DropdownMenuItem(
                          value: item,
                          child: Text(
                            StorageDocumentFormatLabels.text(
                              item,
                              context.l10n,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: _formatChanged,
                  ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          key: const ValueKey('storage_document_cancel'),
          style: TextButton.styleFrom(
            foregroundColor: colors.onSurface,
            textStyle: tasks.controlText,
            shape: shape,
          ),
          onPressed: _cancel,
          child: Text(context.l10n.cancel),
        ),
        FilledButton(
          key: const ValueKey('storage_document_create'),
          style: FilledButton.styleFrom(
            backgroundColor: colors.onSurface,
            foregroundColor: colors.surface,
            textStyle: tasks.controlText,
            shape: shape,
          ),
          onPressed: _submit,
          child: Text(context.l10n.storageCreateDocumentButton),
        ),
      ],
    );
  }
}

/// Lokalizowane nazwy lokalnego wyboru formatu dokumentu.
final class StorageDocumentFormatLabels {
  const StorageDocumentFormatLabels._();

  static String text(StorageDocumentFormat format, AppLocalizations l10n) =>
      switch (format) {
        StorageDocumentFormat.txt => l10n.storageFormatTxt,
        StorageDocumentFormat.odt => l10n.storageFormatOdt,
        StorageDocumentFormat.ods => l10n.storageFormatOds,
        StorageDocumentFormat.odp => l10n.storageFormatOdp,
        StorageDocumentFormat.docx => l10n.storageFormatDocx,
        StorageDocumentFormat.xlsx => l10n.storageFormatXlsx,
        StorageDocumentFormat.pptx => l10n.storageFormatPptx,
      };
}
