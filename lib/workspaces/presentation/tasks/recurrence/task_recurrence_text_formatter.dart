import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:flutter/material.dart';

/// Zawiera zlokalizowane etykiety prezentowane przy regułach cykliczności.
final class TaskRecurrenceTextFormatter {
  const TaskRecurrenceTextFormatter._();

  static String intervalLabel(
    BuildContext context,
    TaskRecurrenceFrequency frequency,
    int interval,
  ) {
    return switch (frequency) {
      TaskRecurrenceFrequency.daily =>
        interval == 1
            ? context.l10n.taskRecurrenceIntervalDaily
            : context.l10n.taskRecurrenceIntervalDays(interval),
      TaskRecurrenceFrequency.weekly =>
        interval == 1
            ? context.l10n.taskRecurrenceIntervalWeekly
            : context.l10n.taskRecurrenceIntervalWeeks(interval),
      TaskRecurrenceFrequency.monthly =>
        interval == 1
            ? context.l10n.taskRecurrenceIntervalMonthly
            : context.l10n.taskRecurrenceIntervalMonths(interval),
    };
  }
}
