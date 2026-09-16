import 'package:flutter/material.dart';
import 'package:ready_next/core/theme/theme.dart';

/// Wspólna, nowoczesna i kompaktowa powierzchnia wyboru w modułach workspace.
abstract final class WorkspaceContextMenu {
  static Future<T?> select<T>(
    BuildContext context, {
    required RelativeRect position,
    required List<PopupMenuEntry<T>> items,
    BoxConstraints? constraints,
  }) {
    final colors = context.colors;

    return showMenu<T>(
      context: context,
      position: position,
      items: items,
      constraints: constraints ?? const BoxConstraints(minWidth: 160, maxWidth: 280),
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: colors.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      color: colors.surfaceContainerLowest,
      menuPadding: const EdgeInsets.symmetric(vertical: 4),
      // Pozycje menu Tasks są liczone względem overlay głównego. Zagnieżdżony
      // AutoRouter ma własny overlay, więc użycie go przesuwało popup po scrollu.
      useRootNavigator: true,
    );
  }
}
