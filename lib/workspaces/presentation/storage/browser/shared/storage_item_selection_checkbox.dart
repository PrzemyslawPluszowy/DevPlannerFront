import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Explicit desktop selection separate from opening an item.
class StorageItemSelectionCheckbox extends StatelessWidget {
  const StorageItemSelectionCheckbox({
    required this.name,
    required this.selected,
    required this.onToggle,
    super.key,
  });

  final String name;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: context.l10n.storageSelectItem(name),
    child: CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.space): onToggle,
        const SingleActivator(LogicalKeyboardKey.enter): onToggle,
      },
      child: Checkbox(
        value: selected,
        semanticLabel: context.l10n.storageSelectItem(name),
        onChanged: (_) => onToggle(),
        visualDensity: VisualDensity.compact,
      ),
    ),
  );
}
