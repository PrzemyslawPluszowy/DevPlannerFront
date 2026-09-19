import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Dyskretny, nowoczesny placeholder dla pustych komórek w tabeli zadań.
///
/// Zamiast surowego myślnika ('—') wyświetla subtelną, wyszarzoną ikonę
/// odpowiadającą typowi danej komórki. Przy najechaniu kursorem myszy (hover)
/// rozjaśnia się i wskazuje możliwość kliknięcia oraz dodania wartości.
class TaskCellEmptyPlaceholder extends StatefulWidget {
  const TaskCellEmptyPlaceholder({
    required this.icon,
    super.key,
    this.tooltip,
    this.isInteractive = true,
    this.onTap,
  });

  /// Ikona semantyczna komórki (np. tarcza, zegar, kalendarz, etykieta).
  final IconData icon;

  /// Opcjonalny opis akcji w dymku (np. "Ustaw termin", "Wybierz ryzyko").
  final String? tooltip;

  /// Czy komórka jest edytowalna i reaguje na najechanie myszą.
  final bool isInteractive;

  /// Opcjonalny callback kliknięcia otwieranego pickera/menu.
  final VoidCallback? onTap;

  @override
  State<TaskCellEmptyPlaceholder> createState() =>
      _TaskCellEmptyPlaceholderState();
}

class _TaskCellEmptyPlaceholderState extends State<TaskCellEmptyPlaceholder> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  void dispose() {
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ValueListenableBuilder<bool>(
      valueListenable: _isHovered,
      builder: (context, isHovered, _) {
        final iconColor = !widget.isInteractive
            ? colors.onSurfaceVariant.withValues(alpha: 0.18)
            : isHovered
            ? colors.primary.withValues(alpha: 0.9)
            : colors.onSurfaceVariant.withValues(alpha: 0.28);
        final content = MouseRegion(
          cursor: widget.isInteractive
              ? SystemMouseCursors.click
              : SystemMouseCursors.basic,
          onEnter: widget.isInteractive ? (_) => _isHovered.value = true : null,
          onExit: widget.isInteractive ? (_) => _isHovered.value = false : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            padding: const .symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: .circular(4),
              color: isHovered && widget.isInteractive
                  ? colors.primary.withValues(alpha: 0.08)
                  : Colors.transparent,
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(widget.icon, size: 15, color: iconColor),
                if (isHovered && widget.isInteractive) ...[
                  const SizedBox(width: 3),
                  Icon(Icons.add, size: 11, color: colors.primary),
                ],
              ],
            ),
          ),
        );
        final interactiveContent = widget.isInteractive && widget.onTap != null
            ? InkWell(
                onTap: widget.onTap,
                borderRadius: .circular(4),
                hoverColor: Colors.transparent,
                splashColor: colors.primary.withValues(alpha: 0.12),
                child: content,
              )
            : content;
        if (widget.tooltip case final tip? when tip.isNotEmpty) {
          return Tooltip(message: tip, child: interactiveContent);
        }
        return interactiveContent;
      },
    );
  }
}
