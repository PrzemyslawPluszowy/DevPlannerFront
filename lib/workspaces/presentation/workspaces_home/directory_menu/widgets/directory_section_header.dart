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

    return Padding(
      padding: const .only(
        left: Sizes.p4,
        right: Sizes.p4,
        top: Sizes.p8,
        bottom: 2,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 13,
              color: colors.onSurfaceVariant.withValues(alpha: .7),
            ),
            Gaps.w6,
          ],
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: context.text.labelSmall?.copyWith(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
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
                minWidth: 22,
                minHeight: 22,
              ),
              tooltip: label,
              style: IconButton.styleFrom(
                foregroundColor: colors.onSurfaceVariant,
                hoverColor: colors.primary.withValues(alpha: .08),
              ),
            ),
        ],
      ),
    );
  }
}
