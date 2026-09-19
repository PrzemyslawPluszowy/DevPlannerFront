import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Nagłówek sekcji w katalogu menu bocznego Workspaces.
class DirectorySectionHeader extends StatelessWidget {
  const DirectorySectionHeader({
    required this.label,
    this.icon,
    this.onAdd,
    super.key,
  });

  /// Etykieta sekcji.
  final String label;

  /// Opcjonalna ikona sekcji.
  final IconData? icon;

  /// Opcjonalna akcja dodania nowego elementu.
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final navigationTheme = context.devPlannerNavigationTheme;

    return SizedBox(
      height: 32,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: navigationTheme.rowHorizontalPadding,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: navigationTheme.rowIconSize,
                color: colors.onSurfaceVariant.withValues(alpha: .7),
              ),
              Gaps.w6,
            ],
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: context.text.labelSmall?.copyWith(
                  fontSize: navigationTheme.sectionFontSize,
                  fontWeight: FontWeight.w500,
                  color: colors.onSurfaceVariant.withValues(alpha: .75),
                  letterSpacing: .4,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onAdd != null)
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Symbols.add_rounded),
                iconSize: 15,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 28,
                  minHeight: 28,
                ),
                tooltip: label,
                style: IconButton.styleFrom(
                  foregroundColor: colors.onSurfaceVariant,
                  hoverColor: colors.primary.withValues(alpha: .08),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
