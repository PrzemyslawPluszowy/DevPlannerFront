import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker_calendar.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker_manual_entry.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker_presets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Composes the compact calendar, manual entry, presets, and its actions.
final class TaskDatePickerContent extends StatelessWidget {
  const TaskDatePickerContent({
    required this.selectedDate,
    required this.displayedMonth,
    required this.firstDate,
    required this.lastDate,
    required this.onSelected,
    required this.onPresetSelected,
    required this.onShowPreviousMonth,
    required this.onShowNextMonth,
    required this.onCancelled,
    required this.onConfirmed,
    this.onCleared,
    super.key,
  });

  final DateTime selectedDate;
  final DateTime displayedMonth;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onSelected;
  final ValueChanged<DateTime> onPresetSelected;
  final VoidCallback onShowPreviousMonth;
  final VoidCallback onShowNextMonth;
  final VoidCallback? onCleared;
  final VoidCallback onCancelled;
  final VoidCallback onConfirmed;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final monthName = DateFormat.yMMMM(locale).format(displayedMonth);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 540),
      child: SingleChildScrollView(
        child: SizedBox(
          width: 324,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TaskDatePickerPresets(
                  selectedDate: selectedDate,
                  today: today,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  onSelected: onPresetSelected,
                ),
                const SizedBox(height: Sizes.p6),
                TaskDatePickerManualEntry(
                  selectedDate: selectedDate,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  onSelected: onSelected,
                ),
                const SizedBox(height: Sizes.p6),
                TaskDatePickerMonthHeader(
                  monthName: monthName,
                  canGoPrevious: _TaskDatePickerMonthBounds.canGoPrevious(
                    displayedMonth,
                    DateTime(firstDate.year, firstDate.month),
                  ),
                  canGoNext: _TaskDatePickerMonthBounds.canGoNext(
                    displayedMonth,
                    DateTime(lastDate.year, lastDate.month),
                  ),
                  onPrevious: onShowPreviousMonth,
                  onNext: onShowNextMonth,
                ),
                const SizedBox(height: Sizes.p2),
                TaskDatePickerWeekdayHeader(locale: locale),
                TaskDatePickerMonthGrid(
                  displayedMonth: displayedMonth,
                  selectedDate: selectedDate,
                  today: today,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  onDateFocused: onSelected,
                  onDateSelected: onSelected,
                ),
                const SizedBox(height: Sizes.p4),
                TaskDatePickerFooter(
                  onCleared: onCleared,
                  onCancelled: onCancelled,
                  onConfirmed: onConfirmed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

abstract final class _TaskDatePickerMonthBounds {
  static bool canGoPrevious(DateTime value, DateTime first) =>
      _monthIndex(value) > _monthIndex(first);

  static bool canGoNext(DateTime value, DateTime last) =>
      _monthIndex(value) < _monthIndex(last);

  static int _monthIndex(DateTime value) => value.year * 12 + value.month;
}

/// Neutral desktop controls for clearing, cancelling, or confirming a date.
final class TaskDatePickerFooter extends StatelessWidget {
  const TaskDatePickerFooter({
    required this.onCancelled,
    required this.onConfirmed,
    this.onCleared,
    super.key,
  });

  final VoidCallback? onCleared;
  final VoidCallback onCancelled;
  final VoidCallback onConfirmed;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      if (onCleared != null)
        TextButton(
          style: _secondaryStyle(context),
          onPressed: onCleared,
          child: Text(context.l10n.tasksListClearDateButton),
        ),
      const Spacer(),
      TextButton(
        style: _secondaryStyle(context),
        onPressed: onCancelled,
        child: Text(context.l10n.tasksListCancelButton),
      ),
      const SizedBox(width: Sizes.p4),
      FilledButton(
        style: FilledButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
          minimumSize: const Size(0, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              context.tasksTheme.controlRadius,
            ),
          ),
          backgroundColor: context.tasksTheme.selectionAccent,
          foregroundColor: context.tasksTheme.onAccent,
        ),
        onPressed: onConfirmed,
        child: Text(context.l10n.tasksListSaveButton),
      ),
    ],
  );

  ButtonStyle _secondaryStyle(BuildContext context) => TextButton.styleFrom(
    visualDensity: VisualDensity.compact,
    padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
    minimumSize: const Size(0, 30),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    foregroundColor: context.colors.onSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
    ),
  );
}
