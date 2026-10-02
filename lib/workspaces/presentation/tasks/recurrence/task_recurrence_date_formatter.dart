import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Formats an instant in device time, with its date-specific UTC offset.
final class TaskRecurrenceDateFormatter {
  const TaskRecurrenceDateFormatter._();

  static String zone(DateTime instant) {
    final offset = instant.toLocal().timeZoneOffset;
    final minutes = offset.inMinutes.abs();
    final hoursText = (minutes ~/ 60).toString().padLeft(2, '0');
    final minutesText = (minutes % 60).toString().padLeft(2, '0');
    return 'UTC${offset.isNegative ? '-' : '+'}$hoursText:$minutesText';
  }

  static String local(BuildContext context, DateTime instant) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateFormat.yMMMd(locale).add_Hm().format(instant.toLocal());
    return '$date (${zone(instant)})';
  }
}
