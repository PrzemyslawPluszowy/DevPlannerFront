import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wiersz nagłówka grupy zadań (np. status, wykonawca, kamień milowy).
///
/// Zawiera przycisk zwijania/rozwijania grupy, kolorowy akcent,
/// etykietę oraz licznik elementów w grupie.
/// Działa również jako cel przeciągania zadań (DragTarget).
class TaskListGroupRow extends StatelessWidget {
  const TaskListGroupRow({
    required this.label,
    required this.count,
    required this.isCollapsed,
    required this.onToggle,
    super.key,
    this.status,
    this.onTaskDropped,
  });

  final String label;
  final int count;
  final ProjectTaskStatus? status;
  final bool isCollapsed;
  final VoidCallback onToggle;
  final ValueChanged<ProjectTaskListItemResponse>? onTaskDropped;

  @override
  Widget build(BuildContext context) {
    final accent = status == null
        ? _groupAccent(label)
        : TaskStatusVisualHelper.color(status!);

    return DragTarget<ProjectTaskListItemResponse>(
      onWillAcceptWithDetails: (_) => onTaskDropped != null,
      onAcceptWithDetails: (details) => onTaskDropped?.call(details.data),
      builder: (context, candidates, _) => Container(
        height: 36,
        padding: const .symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          border: Border(
            left: BorderSide(color: accent, width: 3),
            top: candidates.isEmpty
                ? BorderSide(color: context.colors.outlineVariant)
                : BorderSide(color: context.colors.primary, width: 2),
            bottom: BorderSide(color: context.colors.outlineVariant),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: TaskListGrid.selection,
              child: IconButton(
                onPressed: onToggle,
                icon: Icon(
                  isCollapsed
                      ? Symbols.keyboard_arrow_right_rounded
                      : Symbols.keyboard_arrow_down_rounded,
                  color: accent,
                  size: 19,
                ),
                visualDensity: .compact,
                tooltip: isCollapsed
                    ? context.l10n.tasksListExpandGroupTooltip
                    : context.l10n.tasksListCollapseGroupTooltip,
              ),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: context.text.labelLarge?.copyWith(
                color: context.colors.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const .symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$count',
                style: context.text.labelSmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  static Color _groupAccent(String value) {
    const accents = [
      Color(0xFF2563EB),
      Color(0xFF0D9488),
      Color(0xFF7C3AED),
      Color(0xFFE11D48),
      Color(0xFFF59E0B),
    ];
    return accents[value.hashCode.abs() % accents.length];
  }
}
