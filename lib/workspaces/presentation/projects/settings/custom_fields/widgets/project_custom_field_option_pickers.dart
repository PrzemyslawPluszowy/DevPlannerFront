import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/custom_field_option.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wybór domyślnego koloru albo koloru istniejącej opcji pola.
class ProjectCustomFieldColorPicker extends StatelessWidget {
  const ProjectCustomFieldColorPicker({
    required this.value,
    required this.onSelected,
    this.compact = false,
    super.key,
  });

  final String? value;
  final ValueChanged<String?> onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final currentColor = CustomFieldOptionVisuals.parseHexColor(value);
    final colors = context.colors;
    final size = compact ? 18.0 : 34.0;
    return PopupMenuButton<String?>(
      tooltip: 'Wybierz kolor opcji',
      onSelected: onSelected,
      itemBuilder: (_) => [
        const PopupMenuItem<String?>(
          child: Text('Domyślny kolor', style: TextStyle(fontSize: 12)),
        ),
        const PopupMenuDivider(),
        for (final (hex, name, color) in customFieldOptionColors)
          PopupMenuItem<String?>(
            value: hex,
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                Gaps.w8,
                Text(name, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
      ],
      child: Padding(
        padding: compact
            ? const .symmetric(horizontal: Sizes.p2)
            : EdgeInsets.zero,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color:
                currentColor?.withValues(alpha: compact ? 1 : .18) ??
                colors.surfaceContainerHigh,
            shape: BoxShape.circle,
            border: Border.all(color: currentColor ?? colors.outlineVariant),
          ),
          child: compact
              ? null
              : Icon(
                  Symbols.palette_rounded,
                  size: 16,
                  color: currentColor ?? colors.onSurfaceVariant,
                ),
        ),
      ),
    );
  }
}

/// Wybór domyślnej ikony albo ikony istniejącej opcji pola.
class ProjectCustomFieldIconPicker extends StatelessWidget {
  const ProjectCustomFieldIconPicker({
    required this.value,
    required this.onSelected,
    this.compact = false,
    super.key,
  });

  final String? value;
  final ValueChanged<String?> onSelected;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon =
        CustomFieldOptionVisuals.iconFor(value) ?? Symbols.category_rounded;
    return PopupMenuButton<String?>(
      tooltip: 'Wybierz ikonę opcji',
      onSelected: onSelected,
      itemBuilder: (_) => [
        const PopupMenuItem<String?>(
          child: Text('Bez ikony', style: TextStyle(fontSize: 12)),
        ),
        const PopupMenuDivider(),
        for (final (name, label, itemIcon) in customFieldOptionIcons)
          PopupMenuItem<String?>(
            value: name,
            child: Row(
              children: [Icon(itemIcon, size: 16), Gaps.w8, Text(label)],
            ),
          ),
      ],
      child: compact
          ? Padding(
              padding: const .symmetric(horizontal: Sizes.p2),
              child: Icon(
                icon,
                size: 16,
                color: value != null ? colors.primary : colors.onSurfaceVariant,
              ),
            )
          : Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                borderRadius: .circular(Sizes.p8),
                border: Border.all(
                  color: value != null ? colors.primary : colors.outlineVariant,
                ),
              ),
              child: Icon(
                icon,
                size: 16,
                color: value != null ? colors.primary : colors.onSurfaceVariant,
              ),
            ),
    );
  }
}
