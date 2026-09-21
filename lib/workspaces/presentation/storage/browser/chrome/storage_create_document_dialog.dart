import 'package:devplanner/foundation/l10n/l10n.dart';
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
      showDialog<StorageCreateDocumentRequest>(
        context: context,
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

  @override
  void dispose() {
    _controller.dispose();
    _format.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<StorageDocumentFormat>(
        valueListenable: _format,
        builder: (context, format, _) => AlertDialog(
          title: Text(context.l10n.storageCreateDocumentDialogTitle),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.storageDocumentName,
                    hintText: context.l10n.storageDocumentNameHint,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<StorageDocumentFormat>(
                  initialValue: format,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: context.l10n.storageDocumentFormat,
                  ),
                  items: StorageDocumentFormat.values
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(
                            storageDocumentFormatLabel(item, context.l10n),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) _format.value = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final name = _controller.text.trim();
                if (name.isEmpty) return;
                Navigator.pop(context, (name: name, format: format));
              },
              child: Text(context.l10n.storageCreateDocumentButton),
            ),
          ],
        ),
      );
}

/// Lokalizowana nazwa formatu dokumentu.
String storageDocumentFormatLabel(
  StorageDocumentFormat format,
  AppLocalizations l10n,
) => switch (format) {
  StorageDocumentFormat.txt => l10n.storageFormatTxt,
  StorageDocumentFormat.odt => l10n.storageFormatOdt,
  StorageDocumentFormat.ods => l10n.storageFormatOds,
  StorageDocumentFormat.odp => l10n.storageFormatOdp,
  StorageDocumentFormat.docx => l10n.storageFormatDocx,
  StorageDocumentFormat.xlsx => l10n.storageFormatXlsx,
  StorageDocumentFormat.pptx => l10n.storageFormatPptx,
};
