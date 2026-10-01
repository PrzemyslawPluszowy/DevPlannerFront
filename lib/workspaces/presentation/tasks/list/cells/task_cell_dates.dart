import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Edytowalna komórka daty zadania (np. termin realizacji, data rozpoczęcia).
class TaskCellDate extends StatefulWidget {
  const TaskCellDate({
    required this.dateTime,
    required this.icon,
    required this.tooltip,
    super.key,
    this.onChanged,
  });

  /// Wartość daty (UTC).
  final DateTime? dateTime;

  /// Ikona prezentowana przed datą.
  final IconData icon;

  /// Etykieta podpowiedzi.
  final String tooltip;

  /// Callback wywoływany po wybraniu nowej daty lub wyczyszczeniu.
  final Future<bool> Function(DateTime? value)? onChanged;

  @override
  State<TaskCellDate> createState() => _TaskCellDateState();
}

class _TaskCellDateState extends State<TaskCellDate> {
  bool _isPicking = false;

  Future<void> _pick(BuildContext cellContext) async {
    final onChanged = widget.onChanged;
    if (_isPicking || onChanged == null) return;
    final sourceValue = widget.dateTime;
    _isPicking = true;
    try {
      final box = cellContext.findRenderObject() as RenderBox?;
      final position = box != null
          ? box.localToGlobal(Offset(0, box.size.height + 2))
          : Offset.zero;
      final selection = await TaskDatePicker.pick(
        cellContext,
        initialValue: sourceValue?.toLocal(),
        globalPosition: position,
      );
      if (!mounted ||
          !cellContext.mounted ||
          selection == null ||
          widget.dateTime != sourceValue ||
          !identical(widget.onChanged, onChanged)) {
        return;
      }
      await onChanged(
        TaskDatePicker.asUtcTaskInstant(selection.value, sourceValue),
      );
    } finally {
      _isPicking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final formatted = widget.dateTime == null
        ? null
        : DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag())
              .format(widget.dateTime!.toLocal());

    return Builder(
      builder: (cellContext) => InkWell(
        mouseCursor: widget.onChanged != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onTap: widget.onChanged == null ? null : () => _pick(cellContext),
        child: SizedBox(
          width: TaskListGrid.dueDate,
          child: Padding(
            padding: const .symmetric(horizontal: 10),
            child: Align(
              alignment: .centerLeft,
              child: formatted == null
                  ? TaskCellEmptyPlaceholder(
                      icon: widget.icon,
                      tooltip: widget.onChanged != null ? widget.tooltip : null,
                      isInteractive: widget.onChanged != null,
                    )
                  : Row(
                      mainAxisSize: .min,
                      children: [
                        Icon(
                          widget.icon,
                          size: 14,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            formatted,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: text.labelMedium?.copyWith(
                              color: colors.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Komórka daty tylko do odczytu (data utworzenia, ostatnia aktualizacja).
class TaskCellReadOnlyDate extends StatelessWidget {
  const TaskCellReadOnlyDate({
    required this.dateTime,
    super.key,
  });

  /// Wartość daty.
  final DateTime? dateTime;

  @override
  Widget build(BuildContext context) {
    final formatted = dateTime == null
        ? '—'
        : DateFormat.yMMMd(
            Localizations.localeOf(context).toLanguageTag(),
          ).format(dateTime!.toLocal());

    return SizedBox(
      width: TaskListGrid.dueDate,
      child: Padding(
        padding: const .symmetric(horizontal: 12),
        child: Align(
          alignment: .centerLeft,
          child: Text(
            formatted,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.text.labelMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
