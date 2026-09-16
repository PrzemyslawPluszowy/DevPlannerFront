import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/task_list_grid.dart';

/// Edytowalna komórka daty zadania (np. termin realizacji, data rozpoczęcia).
class TaskCellDate extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final formatted = dateTime == null
        ? null
        : DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag())
              .format(dateTime!.toLocal());

    return Builder(
      builder: (cellContext) => InkWell(
        mouseCursor: onChanged != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onTap: onChanged == null
            ? null
            : () async {
                final box = cellContext.findRenderObject() as RenderBox?;
                final pos = box != null
                    ? box.localToGlobal(Offset(0, box.size.height + 2))
                    : Offset.zero;
                final selection = await pickAnchoredDate(
                  cellContext,
                  initialValue: dateTime,
                  globalPosition: pos,
                );
                if (selection == null) return;
                await onChanged!(asUtcCalendarDate(selection.value));
              },
        child: SizedBox(
          width: TaskListGrid.dueDate,
          child: Padding(
            padding: const .symmetric(horizontal: 10),
            child: Align(
              alignment: .centerLeft,
              child: formatted == null
                  ? TaskCellEmptyPlaceholder(
                      icon: icon,
                      tooltip: onChanged != null ? tooltip : null,
                      isInteractive: onChanged != null,
                    )
                  : Row(
                      mainAxisSize: .min,
                      children: [
                        Icon(icon, size: 14, color: colors.onSurfaceVariant),
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
