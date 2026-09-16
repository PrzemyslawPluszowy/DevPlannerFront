import 'package:flutter/material.dart';

/// Root-scoped adapter systemowych pickerów daty i czasu.
abstract final class AppModalPickerHost {
  static Future<DateTime?> showDate(
    BuildContext context, {
    required DateTime firstDate,
    required DateTime lastDate,
    required DateTime initialDate,
    Locale? locale,
    TransitionBuilder? builder,
  }) => showDatePicker(
    context: context,
    // ignore: avoid_redundant_argument_values, rootowy navigator jest kontraktem shella.
    useRootNavigator: true,
    firstDate: firstDate,
    lastDate: lastDate,
    initialDate: initialDate,
    locale: locale,
    builder: builder,
  );

  static Future<TimeOfDay?> showTime(
    BuildContext context, {
    required TimeOfDay initialTime,
    Locale? locale,
    TransitionBuilder? builder,
  }) => showTimePicker(
    context: context,
    // ignore: avoid_redundant_argument_values, rootowy navigator jest kontraktem shella.
    useRootNavigator: true,
    initialTime: initialTime,
    builder: locale == null
        ? builder
        : (context, child) => Localizations.override(
            context: context,
            locale: locale,
            child: Builder(
              builder: (localizedContext) =>
                  builder?.call(localizedContext, child) ??
                  child ??
                  const SizedBox.shrink(),
            ),
          ),
  );
}
