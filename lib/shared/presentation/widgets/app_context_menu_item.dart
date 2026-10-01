import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu_models.dart';
import 'package:flutter/material.dart';

/// Pojedynczy wiersz menu: ikona, etykieta, skrót i znacznik wyboru.
class AppContextMenuItem<T> extends StatefulWidget {
  const AppContextMenuItem({
    required this.entry,
    required this.isHighlighted,
    required this.onHoverChanged,
    required this.onPressed,
    super.key,
  });

  final AppContextMenuEntry<T> entry;
  final bool isHighlighted;
  final ValueChanged<bool> onHoverChanged;
  final VoidCallback onPressed;

  @override
  State<AppContextMenuItem<T>> createState() => _AppContextMenuItemState<T>();
}

class _AppContextMenuItemState<T> extends State<AppContextMenuItem<T>> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final menuTheme = context.menuTheme;
    final isActive = _isHovered || widget.isHighlighted;
    final Color foreground;
    if (entry.foregroundColor case final explicit?) {
      foreground = explicit;
    } else if (entry.isDestructive) {
      foreground = menuTheme.destructive;
    } else if (entry.selected || isActive) {
      foreground = menuTheme.itemSelectedForeground;
    } else {
      foreground = menuTheme.itemForeground;
    }
    final background = isActive
        ? (entry.isDestructive
              ? menuTheme.destructiveHover
              : menuTheme.itemHover)
        : (entry.selected ? menuTheme.itemSelectedSurface : Colors.transparent);

    return MouseRegion(
      cursor: entry.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) {
        if (!entry.enabled) return;
        setState(() => _isHovered = true);
        widget.onHoverChanged(true);
      },
      onExit: (_) {
        if (!entry.enabled) return;
        setState(() => _isHovered = false);
        widget.onHoverChanged(false);
      },
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(menuTheme.itemRadius)),
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          onTap: entry.enabled ? widget.onPressed : null,
          child: Container(
            height: menuTheme.rowHeight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.all(
                Radius.circular(menuTheme.itemRadius),
              ),
            ),
            child: Opacity(
              opacity: entry.enabled ? 1 : menuTheme.disabledOpacity,
              child: Row(
                children: [
                  if (entry.leading case final leading?) ...[
                    leading,
                    const SizedBox(width: 8),
                  ] else ...[
                    SizedBox(
                      width: menuTheme.iconSize + 2,
                      child: entry.icon == null
                          ? null
                          : Icon(
                              entry.icon,
                              size: menuTheme.iconSize - 1,
                              color: entry.iconColor ?? foreground,
                            ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      entry.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: menuTheme.itemText.copyWith(
                        color: foreground,
                        fontWeight: entry.selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (entry.trailing case final trailing?) ...[
                    const SizedBox(width: 8),
                    trailing,
                  ],
                  if (entry.shortcutLabel case final shortcut?) ...[
                    const SizedBox(width: 12),
                    Text(
                      shortcut,
                      style: menuTheme.shortcutText.copyWith(
                        color: menuTheme.sectionForeground,
                      ),
                    ),
                  ],
                  if (entry.selected) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.check_rounded,
                      size: menuTheme.iconSize - 1,
                      color: menuTheme.itemSelectedForeground,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
