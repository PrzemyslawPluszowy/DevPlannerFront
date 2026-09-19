import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Pojedyncza komórka nagłówka tabeli zadań.
///
/// Wyświetla zwięzłą etykietę kolumny, ikonę semantyczną, wskaźnik aktywnego
/// sortowania oraz uchwyt do zmiany szerokości kolumny przeciąganiem myszy.
class TaskListHeaderCell extends StatelessWidget {
  const TaskListHeaderCell({
    required this.width,
    required this.label,
    super.key,
    this.icon,
    this.iconColor,
    this.onResizeDelta,
    this.onResizeStart,
    this.onResizeUpdate,
    this.onResizeEnd,
    this.sortDirection,
    this.onTapSort,
    this.canReorder = false,
    this.reorderHandleBuilder,
  });

  /// Szerokość komórki nagłówka w pikselach.
  final double width;

  /// Zlokalizowana etykieta kolumny.
  final String label;

  /// Opcjonalna ikona kolumny.
  final IconData? icon;

  /// Kolor ikony kolumny.
  final Color? iconColor;

  /// Callback wywoływany przy zmianie szerokości przeciąganiem (wsteczna zgodność).
  final ValueChanged<double>? onResizeDelta;

  /// Callback rozpoczęcia zmiany szerokości przeciąganiem separatora.
  final VoidCallback? onResizeStart;

  /// Callback ciągłej aktualizacji zmiany szerokości (delta pikseli).
  final ValueChanged<double>? onResizeUpdate;

  /// Callback zakończenia zmiany szerokości przeciąganiem.
  final VoidCallback? onResizeEnd;

  /// Aktywny kierunek sortowania dla tej kolumny (null jeśli brak).
  final TaskSavedViewSortDirection? sortDirection;

  /// Callback kliknięcia w nagłówek przełączający sortowanie.
  final VoidCallback? onTapSort;

  /// Czy kolumna wspiera przeciąganie w celu zmiany kolejności.
  final bool canReorder;

  /// Opcjonalny dekorator chwytaka przeciągania kolumny.
  /// Ogranicza obszar chwytania wyłącznie do ikony i tekstu, eliminując konflikt z resize.
  final Widget Function(Widget child)? reorderHandleBuilder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final resizeTooltip = context.l10n.tasksListResizeColumnTooltip(label);

    final sortTooltip = switch (sortDirection) {
      null => context.l10n.tasksListSortAscending,
      TaskSavedViewSortDirection.ascending =>
        context.l10n.tasksListSortDescending,
      TaskSavedViewSortDirection.descending => context.l10n.tasksListSortClear,
    };

    final tooltipMessage = canReorder
        ? '$label • $sortTooltip\n${context.l10n.tasksListDragToReorderTooltip}'
        : (onTapSort != null ? sortTooltip : null);

    Widget labelAndIcon = Row(
      mainAxisSize: .min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 14,
            color: iconColor ?? colors.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 5),
        ],
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: text.labelMedium?.copyWith(
              color: sortDirection != null ? colors.primary : colors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (sortDirection != null) ...[
          const SizedBox(width: 4),
          Icon(
            sortDirection == TaskSavedViewSortDirection.ascending
                ? Symbols.arrow_upward_alt_rounded
                : Symbols.arrow_downward_alt_rounded,
            size: 14,
            color: colors.primary,
          ),
        ] else if (onTapSort != null) ...[
          const SizedBox(width: 4),
          Icon(
            Symbols.swap_vert_rounded,
            size: 14,
            color: colors.onSurfaceVariant.withValues(alpha: 0.38),
          ),
        ],
      ],
    );

    // Chwytak reorder obejmuje WYŁĄCZNIE ikonę + tekst, zapobiegając konfliktom z resize
    if (reorderHandleBuilder != null) {
      labelAndIcon = reorderHandleBuilder!(labelAndIcon);
    }

    final content = Padding(
      padding: const .symmetric(horizontal: 10),
      child: Align(
        alignment: .centerLeft,
        child: labelAndIcon,
      ),
    );

    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: colors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: MouseRegion(
              cursor: onTapSort != null
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              child: tooltipMessage != null
                  ? Tooltip(
                      message: tooltipMessage,
                      child: onTapSort != null
                          ? InkWell(
                              onTap: onTapSort,
                              hoverColor: colors.primary.withValues(
                                alpha: 0.04,
                              ),
                              child: content,
                            )
                          : content,
                    )
                  : (onTapSort != null
                        ? InkWell(
                            onTap: onTapSort,
                            hoverColor: colors.primary.withValues(alpha: 0.04),
                            child: content,
                          )
                        : content),
            ),
          ),
          if (onResizeUpdate != null || onResizeDelta != null)
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              width: 14,
              child: Tooltip(
                message: resizeTooltip,
                child: Semantics(
                  label: resizeTooltip,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeColumn,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragStart: (_) => onResizeStart?.call(),
                      onHorizontalDragUpdate: (details) {
                        onResizeUpdate?.call(details.delta.dx);
                        onResizeDelta?.call(details.delta.dx);
                      },
                      onHorizontalDragEnd: (_) => onResizeEnd?.call(),
                      onHorizontalDragCancel: () => onResizeEnd?.call(),
                      child: Align(
                        alignment: .centerRight,
                        child: Container(
                          width: 1.5,
                          color: colors.outlineVariant.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
