import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

final class TaskDatePickerPresets extends StatelessWidget {
  const TaskDatePickerPresets({
    required this.selectedDate,
    required this.today,
    required this.firstDate,
    required this.lastDate,
    required this.onSelected,
    super.key,
  });

  final DateTime selectedDate;
  final DateTime today;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final presets = <_DatePreset>[
      _DatePreset(context.l10n.tasksListDatePresetToday, today),
      _DatePreset(
        context.l10n.tasksListDatePresetTomorrow,
        today.add(const Duration(days: 1)),
      ),
      _DatePreset(
        context.l10n.tasksListDatePresetNextWeek,
        today.add(Duration(days: 8 - today.weekday)),
      ),
      _DatePreset(
        context.l10n.tasksListDatePresetNextMonth,
        DateTime(today.year, today.month + 1, today.day),
      ),
    ];
    return Wrap(
      spacing: Sizes.p4,
      runSpacing: Sizes.p4,
      children: presets
          .map((preset) {
            final date = DateTime(
              preset.date.year,
              preset.date.month,
              preset.date.day,
            );
            final first = DateTime(
              firstDate.year,
              firstDate.month,
              firstDate.day,
            );
            final last = DateTime(lastDate.year, lastDate.month, lastDate.day);
            final enabled = !date.isBefore(first) && !date.isAfter(last);
            final selected = _sameCalendarDay(date, selectedDate);
            return _DatePresetButton(
              label: preset.label,
              selected: selected,
              enabled: enabled,
              onPressed: () => onSelected(date),
            );
          })
          .toList(growable: false),
    );
  }
}

final class _DatePreset {
  const _DatePreset(this.label, this.date);

  final String label;
  final DateTime date;
}

final class _DatePresetButton extends StatelessWidget {
  const _DatePresetButton({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    child: TextButton(
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: Sizes.p6),
        minimumSize: const Size(0, 30),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: selected
            ? context.tasksTheme.selectionAccent
            : context.colors.onSurfaceVariant,
        backgroundColor: selected
            ? context.tasksTheme.selectionAccent.withValues(alpha: .10)
            : context.tasksTheme.commandBarSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
          side: BorderSide(
            color: selected
                ? context.tasksTheme.selectionAccent.withValues(alpha: .4)
                : context.tasksTheme.canvasBorder,
          ),
        ),
      ),
      onPressed: enabled ? onPressed : null,
      child: Text(label, maxLines: 1),
    ),
  );
}

bool _sameCalendarDay(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;
