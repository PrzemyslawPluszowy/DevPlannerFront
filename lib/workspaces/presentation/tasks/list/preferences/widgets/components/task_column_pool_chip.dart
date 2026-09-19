import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/header/task_list_column_helper.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Kafelek kolumny w puli dostępnych/nieużywanych kolumn tabeli.
///
/// Po kliknięciu dodaje kolumnę do aktywnego nagłówka tabeli.
class TaskColumnPoolChip extends StatefulWidget {
  const TaskColumnPoolChip({
    required this.column,
    required this.onAdd,
    super.key,
    this.customFields = const [],
  });

  final TaskColumnReference column;
  final VoidCallback onAdd;
  final List<TaskCustomFieldResponse> customFields;

  @override
  State<TaskColumnPoolChip> createState() => _TaskColumnPoolChipState();
}

class _TaskColumnPoolChipState extends State<TaskColumnPoolChip> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);

  @override
  void dispose() {
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final label = TaskListColumnHelper.referenceLabel(
      context,
      widget.column,
      customFields: widget.customFields,
    );
    final icon = TaskListColumnHelper.referenceIcon(
      widget.column,
      customFields: widget.customFields,
    );

    return ValueListenableBuilder<bool>(
      valueListenable: _isHovered,
      builder: (context, isHovered, _) => MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _isHovered.value = true,
        onExit: (_) => _isHovered.value = false,
        child: InkWell(
          borderRadius: .circular(6),
          onTap: widget.onAdd,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            padding: const .symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: .circular(6),
              color: isHovered
                  ? colors.primary.withValues(alpha: 0.08)
                  : colors.surfaceContainerHigh.withValues(alpha: 0.6),
              border: Border.all(
                color: isHovered
                    ? colors.primary.withValues(alpha: 0.4)
                    : colors.outlineVariant.withValues(alpha: 0.4),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(
                  icon,
                  size: 13,
                  color: isHovered ? colors.primary : colors.onSurfaceVariant,
                ),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.labelSmall?.copyWith(
                      color: isHovered ? colors.primary : colors.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Symbols.add_rounded,
                  size: 13,
                  color: isHovered ? colors.primary : colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
