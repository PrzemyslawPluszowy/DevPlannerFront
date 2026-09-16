part of 'tasks_board_page.dart';

/// Wąski, osobisty wariant zwiniętej kolumny bez modyfikowania tablicy projektu.
class _CollapsedKanbanColumn extends StatelessWidget {
  const _CollapsedKanbanColumn({
    required this.column,
    required this.onExpand,
  });

  final KanbanColumnResponse column;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: context.l10n.tasksExpandColumn(column.displayName),
      child: SizedBox(
        width: 52,
        child: Material(
          color: colors.surfaceContainerLowest,
          borderRadius: .circular(10),
          child: InkWell(
            onTap: onExpand,
            borderRadius: .circular(10),
            child: Padding(
              padding: const .symmetric(vertical: 10),
              child: Column(
                children: [
                  Icon(
                    Symbols.keyboard_arrow_right_rounded,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _parseColor(column.color),
                      shape: .circle,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        column.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.labelMedium?.copyWith(
                          fontWeight: .w700,
                        ),
                      ),
                    ),
                  ),
                  _CountBadge(column: column),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
