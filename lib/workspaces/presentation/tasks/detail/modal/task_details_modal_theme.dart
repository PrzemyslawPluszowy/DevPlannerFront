import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Applies Tasks' desktop control tokens inside the detail modal and overlays.
final class TaskDetailsModalTheme extends StatelessWidget {
  const TaskDetailsModalTheme({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context);
    final tasks = context.tasksTheme;
    final colors = context.colors;
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(tasks.controlRadius),
      borderSide: BorderSide(color: tasks.canvasBorder),
    );
    final controlShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(tasks.controlRadius),
      side: BorderSide(color: tasks.canvasBorder),
    );
    final compactButton = FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      minimumSize: const Size(0, 32),
      shape: controlShape,
      backgroundColor: colors.primary,
      foregroundColor: colors.onPrimary,
      disabledBackgroundColor: tasks.commandBarSurface,
      disabledForegroundColor: colors.onSurfaceVariant.withValues(alpha: .55),
      textStyle: tasks.controlText.copyWith(fontWeight: FontWeight.w700),
    );

    return Theme(
      data: base.copyWith(
        canvasColor: tasks.canvas,
        inputDecorationTheme: base.inputDecorationTheme.copyWith(
          filled: true,
          isDense: true,
          fillColor: tasks.commandBarSurface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          enabledBorder: fieldBorder,
          border: fieldBorder,
          focusedBorder: fieldBorder.copyWith(
            borderSide: BorderSide(color: colors.primary, width: 1.5),
          ),
          errorBorder: fieldBorder.copyWith(
            borderSide: BorderSide(color: colors.error),
          ),
          focusedErrorBorder: fieldBorder.copyWith(
            borderSide: BorderSide(color: colors.error, width: 1.5),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            minimumSize: const Size(0, 32),
            foregroundColor: colors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tasks.controlRadius),
            ),
            textStyle: tasks.controlText.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: compactButton,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            minimumSize: const Size(0, 32),
            foregroundColor: colors.onSurface,
            side: BorderSide(color: tasks.canvasBorder),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(tasks.controlRadius),
            ),
            textStyle: tasks.controlText.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        dialogTheme: base.dialogTheme.copyWith(
          backgroundColor: tasks.canvas,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tasks.panelRadius),
            side: BorderSide(color: tasks.canvasBorder),
          ),
        ),
        popupMenuTheme: base.popupMenuTheme.copyWith(
          color: tasks.cardSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tasks.menuRadius),
            side: BorderSide(color: tasks.canvasBorder),
          ),
          textStyle: tasks.dataText,
        ),
        menuTheme: MenuThemeData(
          style: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(tasks.cardSurface),
            surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
            elevation: const WidgetStatePropertyAll(8),
            shape: WidgetStatePropertyAll(controlShape),
            side: WidgetStatePropertyAll(BorderSide(color: tasks.canvasBorder)),
          ),
        ),
        datePickerTheme: base.datePickerTheme.copyWith(
          backgroundColor: tasks.canvas,
          surfaceTintColor: Colors.transparent,
          headerBackgroundColor: tasks.commandBarSurface,
          headerForegroundColor: colors.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tasks.panelRadius),
            side: BorderSide(color: tasks.canvasBorder),
          ),
        ),
        timePickerTheme: base.timePickerTheme.copyWith(
          backgroundColor: tasks.canvas,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tasks.panelRadius),
            side: BorderSide(color: tasks.canvasBorder),
          ),
          hourMinuteColor: tasks.commandBarSurface,
          hourMinuteTextColor: colors.onSurface,
          dialBackgroundColor: tasks.commandBarSurface,
          dialHandColor: colors.primary,
          dialTextColor: colors.onSurface,
          dayPeriodColor: tasks.commandBarSurface,
          dayPeriodTextColor: colors.onSurface,
          entryModeIconColor: colors.onSurfaceVariant,
        ),
        tooltipTheme: base.tooltipTheme.copyWith(
          decoration: BoxDecoration(
            color: tasks.cardSurface,
            borderRadius: BorderRadius.circular(tasks.controlRadius),
            border: Border.all(color: tasks.canvasBorder),
          ),
          textStyle: tasks.dataStrongText,
        ),
        bottomSheetTheme: base.bottomSheetTheme.copyWith(
          backgroundColor: tasks.canvas,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(tasks.panelRadius),
            side: BorderSide(color: tasks.canvasBorder),
          ),
          showDragHandle: false,
        ),
        listTileTheme: base.listTileTheme.copyWith(
          dense: true,
          minVerticalPadding: 4,
          visualDensity: VisualDensity.compact,
        ),
      ),
      child: child,
    );
  }
}
