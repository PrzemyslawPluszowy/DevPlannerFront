import 'package:flutter/material.dart';

enum DevPlannerModalNavigatorScope { root, nested }

/// Standalone presentation host for dialogs and sheets.
abstract final class DevPlannerModalHost {
  static Future<T?> showDialog<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    DevPlannerModalNavigatorScope navigatorScope =
        DevPlannerModalNavigatorScope.root,
    bool barrierDismissible = true,
    String? barrierLabel,
    bool requestFocus = true,
  }) => showGeneralDialog<T>(
    context: context,
    useRootNavigator: navigatorScope == DevPlannerModalNavigatorScope.root,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel ?? MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Theme.of(context).colorScheme.scrim.withValues(alpha: .24),
    requestFocus: requestFocus,
    pageBuilder: (context, _, _) => builder(context),
  );

  static Future<T?> showSideSheet<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    DevPlannerModalNavigatorScope navigatorScope =
        DevPlannerModalNavigatorScope.root,
    bool barrierDismissible = true,
    bool canClose = true,
    String? barrierLabel,
    bool requestFocus = true,
  }) => showGeneralDialog<T>(
    context: context,
    useRootNavigator: navigatorScope == DevPlannerModalNavigatorScope.root,
    barrierDismissible: barrierDismissible,
    barrierLabel: barrierLabel ?? MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Theme.of(context).colorScheme.scrim.withValues(alpha: .24),
    requestFocus: requestFocus,
    pageBuilder: (context, _, _) => PopScope(
      canPop: canClose,
      child: Align(alignment: Alignment.centerRight, child: builder(context)),
    ),
  );

  static Future<T?> showBottomSheet<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    DevPlannerModalNavigatorScope navigatorScope =
        DevPlannerModalNavigatorScope.root,
    bool barrierDismissible = true,
    String? barrierLabel,
    bool isScrollControlled = true,
    BoxConstraints? constraints,
    Color backgroundColor = Colors.transparent,
  }) => showModalBottomSheet<T>(
    context: context,
    useRootNavigator: navigatorScope == DevPlannerModalNavigatorScope.root,
    isDismissible: barrierDismissible,
    barrierLabel: barrierLabel,
    isScrollControlled: isScrollControlled,
    constraints: constraints,
    backgroundColor: backgroundColor,
    builder: builder,
  );

  static DevPlannerModalNavigatorScope navigatorScopeFor(
    bool useRootNavigator,
  ) => useRootNavigator
      ? DevPlannerModalNavigatorScope.root
      : DevPlannerModalNavigatorScope.nested;
}

abstract final class DevPlannerModalPickerHost {
  static Future<DateTime?> showDate(
    BuildContext context, {
    required DateTime firstDate,
    required DateTime lastDate,
    required DateTime initialDate,
    Locale? locale,
    TransitionBuilder? builder,
  }) => showDatePicker(
    context: context,
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
    initialTime: initialTime,
    builder: locale == null
        ? builder
        : (context, child) => Localizations.override(
            context: context,
            locale: locale,
            child: builder?.call(context, child) ?? child,
          ),
  );
}
