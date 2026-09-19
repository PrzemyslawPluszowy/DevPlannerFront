import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// Kontrolka krótkotrwałego wyboru koloru i ikony projektu.
class ProjectIconAndColorPicker extends StatelessWidget {
  const ProjectIconAndColorPicker({
    required this.selectedColor,
    required this.selectedIcon,
    required this.availableColors,
    required this.availableIcons,
    required this.enabled,
    required this.onColorChanged,
    required this.onIconChanged,
    super.key,
  });

  final String? selectedColor;
  final String? selectedIcon;
  final List<String> availableColors;
  final List<String> availableIcons;
  final bool enabled;
  final ValueChanged<String> onColorChanged;
  final ValueChanged<String> onIconChanged;

  Color _parseHex(String? hex) {
    if (hex == null || hex.isEmpty) {
      return const Color(0xff3b82f6);
    }
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  IconData _mapIcon(String? name) => switch (name) {
    'rocket_launch' => Icons.rocket_launch_rounded,
    'task_alt' => Icons.task_alt_rounded,
    'code' => Icons.code_rounded,
    'shopping_bag' => Icons.shopping_bag_rounded,
    'campaign' => Icons.campaign_rounded,
    'group' => Icons.group_rounded,
    'analytics' => Icons.analytics_rounded,
    'build' => Icons.build_rounded,
    _ => Icons.folder_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Wrap(
      spacing: Sizes.p12,
      runSpacing: Sizes.p12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Wrap(
          spacing: Sizes.p8,
          children: [
            for (final hex in availableColors)
              InkWell(
                onTap: enabled ? () => onColorChanged(hex) : null,
                borderRadius: .circular(Sizes.p999),
                child: Container(
                  width: Sizes.p28,
                  height: Sizes.p28,
                  decoration: BoxDecoration(
                    color: _parseHex(hex),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedColor == hex
                          ? colors.onSurface
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: selectedColor == hex
                      ? const Icon(
                          Icons.check,
                          size: Sizes.p16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
          ],
        ),
        Gaps.w8,
        Wrap(
          spacing: Sizes.p8,
          children: [
            for (final iconName in availableIcons)
              InkWell(
                onTap: enabled ? () => onIconChanged(iconName) : null,
                borderRadius: .circular(Sizes.p8),
                child: Container(
                  width: Sizes.p32,
                  height: Sizes.p32,
                  decoration: BoxDecoration(
                    color: selectedIcon == iconName
                        ? colors.primaryContainer
                        : colors.surfaceContainerLow,
                    borderRadius: .circular(Sizes.p8),
                    border: Border.all(
                      color: selectedIcon == iconName
                          ? colors.primary
                          : colors.outlineVariant,
                    ),
                  ),
                  child: Icon(
                    _mapIcon(iconName),
                    size: Sizes.p18,
                    color: selectedIcon == iconName
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
