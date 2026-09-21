import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Dialog tworzenia folderu w bieżącym zakresie.
///
/// Zwraca wyłącznie zatwierdzoną nazwę; utworzenie folderu należy do Cubita,
/// który wywołuje wywołujący, więc dialog nie zna repozytorium.
final class StorageCreateFolderDialog extends StatefulWidget {
  /// Tworzy dialog tworzenia folderu.
  const StorageCreateFolderDialog({super.key});

  /// Pokazuje dialog i zwraca zatwierdzoną nazwę albo `null`.
  static Future<String?> show(BuildContext context) => showDialog<String>(
    context: context,
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.storageCreateFolderDialogTitle),
    content: TextField(
      controller: _controller,
      autofocus: true,
      decoration: InputDecoration(
        hintText: context.l10n.storageCreateFolderDialogHint,
      ),
      onSubmitted: _submit,
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(context.l10n.cancel),
      ),
      FilledButton(
        onPressed: () => _submit(_controller.text),
        child: Text(context.l10n.storageCreateFolderButton),
      ),
    ],
  );

  void _submit(String rawName) {
    final name = rawName.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }
}
