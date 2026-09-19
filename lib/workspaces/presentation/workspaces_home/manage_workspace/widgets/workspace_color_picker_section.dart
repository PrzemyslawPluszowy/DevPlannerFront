import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Sekcja wyboru koloru akcentu workspace’u.
class WorkspaceColorPickerSection extends StatelessWidget {
  const WorkspaceColorPickerSection({
    required this.selectedColor,
    required this.onColorSelected,
    super.key,
  });

  /// Dostępna paleta kolorów do wyboru dla przestrzeni roboczych.
  static const availableColors = <Color>[
    Color(0xff0b57d0),
    Color(0xff1e88e5),
    Color(0xff00897b),
    Color(0xff43a047),
    Color(0xfffb8c00),
    Color(0xffe53935),
    Color(0xff8e24aa),
    Color(0xff546e7a),
  ];

  /// Aktualnie wybrany kolor.
  final Color selectedColor;

  /// Callback po zmianie koloru.
  final ValueChanged<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          context.l10n.workspacesAccentColorLabel,
          style: context.text.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colors.onSurfaceVariant,
          ),
        ),
        Gaps.h8,
        Wrap(
          spacing: Sizes.p8,
          children: availableColors.map((color) {
            final isSelected = color.toARGB32() == selectedColor.toARGB32();
            return Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () => onColorSelected(color),
                customBorder: const CircleBorder(),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? colors.onSurface : Colors.transparent,
                      width: 2.5,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: color.withValues(alpha: .4),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                    ],
                  ),
                  child: isSelected
                      ? const Icon(
                          Symbols.check_rounded,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
