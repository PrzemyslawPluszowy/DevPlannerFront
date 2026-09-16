part of 'task_list_row.dart';

/// Komórka wyboru wiersza (checkbox zaznaczenia) oraz kontrolka rozwijania podzadań (ze wskaźnikiem badge).
class _TaskListRowSelectionCell extends StatelessWidget {
  const _TaskListRowSelectionCell({
    required this.task,
    required this.isSelected,
    required this.onSelectionChanged,
    required this.isExpanded,
    required this.isSubtasksLoading,
    required this.onToggleSubtasks,
    required this.onTaskDroppedAsSubtask,
  });

  final ProjectTaskListItemResponse task;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;
  final bool isExpanded;
  final bool isSubtasksLoading;
  final VoidCallback? onToggleSubtasks;
  final ValueChanged<ProjectTaskListItemResponse>? onTaskDroppedAsSubtask;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: TaskListGrid.selection,
      child: Row(
        mainAxisAlignment: .center,
        children: [
          SizedBox(
            width: 28,
            child: Semantics(
              label: 'Zaznacz zadanie ${task.key}',
              checked: isSelected,
              child: Checkbox(
                value: isSelected,
                visualDensity: .compact,
                onChanged: onSelectionChanged == null
                    ? null
                    : (value) => onSelectionChanged!(
                        HardwareKeyboard.instance.isShiftPressed,
                      ),
              ),
            ),
          ),
          if (task.parentTaskId == null)
            DragTarget<ProjectTaskListItemResponse>(
              onWillAcceptWithDetails: (details) =>
                  details.data.id != task.id && onTaskDroppedAsSubtask != null,
              onAcceptWithDetails: (details) =>
                  onTaskDroppedAsSubtask?.call(details.data),
              builder: (context, candidates, _) => IconButton(
                tooltip: context.l10n.taskDetailsSubtasks,
                constraints: const BoxConstraints.tightFor(
                  width: 20,
                  height: 32,
                ),
                padding: EdgeInsets.zero,
                splashRadius: 16,
                visualDensity: .compact,
                onPressed: isSubtasksLoading ? null : onToggleSubtasks,
                icon: isSubtasksLoading
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Badge(
                        isLabelVisible: task.subtaskCount > 0,
                        backgroundColor: context.colors.surfaceContainerHighest,
                        textColor: context.colors.onSurfaceVariant,
                        padding: const .symmetric(horizontal: 2.5),
                        offset: const Offset(8, -8),
                        label: Text(
                          task.subtaskCount > 99
                              ? '99+'
                              : '${task.subtaskCount}',
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: .w700,
                            height: 1.0,
                          ),
                        ),
                        child: Icon(
                          isExpanded
                              ? Symbols.keyboard_arrow_down_rounded
                              : Symbols.keyboard_arrow_right_rounded,
                          color: candidates.isEmpty
                              ? context.colors.outline
                              : context.colors.primary,
                          size: 18,
                        ),
                      ),
              ),
            )
          else
            SizedBox(
              width: 20,
              child: Icon(
                Symbols.subdirectory_arrow_right_rounded,
                size: 15,
                color: context.colors.outline,
              ),
            ),
        ],
      ),
    );
  }
}
