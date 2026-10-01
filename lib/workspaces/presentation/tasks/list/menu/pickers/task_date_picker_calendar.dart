import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

final class TaskDatePickerMonthHeader extends StatelessWidget {
  const TaskDatePickerMonthHeader({
    required this.monthName,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final String monthName;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          monthName,
          style: context.tasksTheme.controlText.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      _MonthNavigationButton(
        tooltip: MaterialLocalizations.of(context).previousMonthTooltip,
        icon: Symbols.chevron_left_rounded,
        enabled: canGoPrevious,
        onPressed: onPrevious,
      ),
      _MonthNavigationButton(
        tooltip: MaterialLocalizations.of(context).nextMonthTooltip,
        icon: Symbols.chevron_right_rounded,
        enabled: canGoNext,
        onPressed: onNext,
      ),
    ],
  );
}

final class _MonthNavigationButton extends StatelessWidget {
  const _MonthNavigationButton({
    required this.tooltip,
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 30,
    height: 30,
    child: IconButton(
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      onPressed: enabled ? onPressed : null,
      icon: Icon(icon, size: 18),
      style: IconButton.styleFrom(
        foregroundColor: context.colors.onSurfaceVariant,
        disabledForegroundColor: context.colors.onSurfaceVariant.withValues(
          alpha: .35,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
        ),
      ),
    ),
  );
}

final class TaskDatePickerWeekdayHeader extends StatelessWidget {
  const TaskDatePickerWeekdayHeader({required this.locale, super.key});

  final String locale;

  @override
  Widget build(BuildContext context) {
    final firstDay = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final weekdays = List<String>.generate(7, (index) {
      final weekday = DateTime(2024, 1, 1 + ((firstDay + index + 6) % 7));
      return DateFormat.E(locale).format(weekday);
    }, growable: false);
    return Row(
      children: weekdays
          .map(
            (name) => Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    name,
                    maxLines: 1,
                    style: context.tasksTheme.controlText.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

final class TaskDatePickerMonthGrid extends StatelessWidget {
  const TaskDatePickerMonthGrid({
    required this.displayedMonth,
    required this.selectedDate,
    required this.today,
    required this.firstDate,
    required this.lastDate,
    required this.onDateFocused,
    required this.onDateSelected,
    super.key,
  });

  final DateTime displayedMonth;
  final DateTime selectedDate;
  final DateTime today;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateFocused;
  final ValueChanged<DateTime> onDateSelected;

  @override
  Widget build(BuildContext context) {
    final firstWeekday = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final firstOfMonth = DateTime(displayedMonth.year, displayedMonth.month);
    final offset = (firstOfMonth.weekday % 7 - firstWeekday) % 7;
    final daysInMonth = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    ).day;
    final normalizedFirst = DateTime(
      firstDate.year,
      firstDate.month,
      firstDate.day,
    );
    final normalizedLast = DateTime(
      lastDate.year,
      lastDate.month,
      lastDate.day,
    );
    final cells = <Widget>[];
    for (var index = 0; index < 42; index++) {
      final dayNumber = index - offset + 1;
      if (dayNumber < 1 || dayNumber > daysInMonth) {
        cells.add(const Expanded(child: SizedBox(height: 34)));
        continue;
      }
      final date = DateTime(
        displayedMonth.year,
        displayedMonth.month,
        dayNumber,
      );
      final normalizedDate = DateTime(date.year, date.month, date.day);
      cells.add(
        Expanded(
          child: TaskDatePickerDayCell(
            date: date,
            selected: _TaskDatePickerCalendarDay.same(date, selectedDate),
            today: _TaskDatePickerCalendarDay.same(date, today),
            enabled:
                !normalizedDate.isBefore(normalizedFirst) &&
                !normalizedDate.isAfter(normalizedLast),
            onFocused: onDateFocused,
            onSelected: onDateSelected,
          ),
        ),
      );
    }
    return Column(
      children: List<Widget>.generate(
        6,
        (row) => Row(
          children: cells.sublist(row * 7, row * 7 + 7),
        ),
        growable: false,
      ),
    );
  }
}

final class TaskDatePickerDayCell extends StatelessWidget {
  const TaskDatePickerDayCell({
    required this.date,
    required this.selected,
    required this.today,
    required this.enabled,
    required this.onFocused,
    required this.onSelected,
    super.key,
  });

  final DateTime date;
  final bool selected;
  final bool today;
  final bool enabled;
  final ValueChanged<DateTime> onFocused;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    final background = selected
        ? tasks.selectionAccent
        : today
        ? tasks.selectionAccent.withValues(alpha: .10)
        : Colors.transparent;
    final foreground = selected ? tasks.onAccent : colors.onSurface;
    return SizedBox(
      height: 34,
      child: Semantics(
        button: true,
        selected: selected,
        enabled: enabled,
        label: MaterialLocalizations.of(context).formatFullDate(date),
        child: Padding(
          padding: const EdgeInsets.all(1),
          child: Material(
            color: background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tasks.controlRadius),
              side: today && !selected
                  ? BorderSide(color: tasks.selectionAccent)
                  : BorderSide.none,
            ),
            child: InkWell(
              mouseCursor: enabled
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              borderRadius: BorderRadius.circular(tasks.controlRadius),
              onFocusChange: enabled
                  ? (focused) {
                      if (focused) onFocused(date);
                    }
                  : null,
              onTap: enabled ? () => onSelected(date) : null,
              child: Center(
                child: Text(
                  '${date.day}',
                  style: context.tasksTheme.controlText.copyWith(
                    color: enabled
                        ? foreground
                        : colors.onSurfaceVariant.withValues(alpha: .35),
                    fontWeight: selected || today
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

abstract final class _TaskDatePickerCalendarDay {
  static bool same(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
