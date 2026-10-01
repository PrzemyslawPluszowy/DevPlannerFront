import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('open date and time pickers keep Tasks tokens in both themes', (
    tester,
  ) async {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final baseTheme = brightness == Brightness.light
          ? MaterialTheme.crm().light()
          : MaterialTheme.crm().dark();
      final tasks = baseTheme.extension<DevPlannerTasksTheme>()!;
      final primary = baseTheme.colorScheme.primary;

      await tester.pumpWidget(
        MaterialApp(
          key: ValueKey<Brightness>(brightness),
          theme: baseTheme,
          home: TaskDetailsModalTheme(
            child: Scaffold(
              body: Builder(
                builder: (context) => Column(
                  children: [
                    TextButton(
                      onPressed: () => unawaited(
                        showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2035),
                          initialDate: DateTime(2026, 9, 30),
                        ),
                      ),
                      child: const Text('Open date'),
                    ),
                    TextButton(
                      onPressed: () => unawaited(
                        showTimePicker(
                          context: context,
                          initialTime: const TimeOfDay(hour: 9, minute: 30),
                        ),
                      ),
                      child: const Text('Open time'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open date'));
      await tester.pumpAndSettle();
      final dateTheme = Theme.of(tester.element(find.byType(DatePickerDialog)));
      expect(dateTheme.datePickerTheme.backgroundColor, tasks.canvas);
      expect(
        dateTheme.datePickerTheme.headerBackgroundColor,
        tasks.commandBarSurface,
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open time'));
      await tester.pumpAndSettle();
      final timeTheme = Theme.of(tester.element(find.byType(TimePickerDialog)));
      expect(timeTheme.timePickerTheme.backgroundColor, tasks.canvas);
      expect(
        timeTheme.timePickerTheme.hourMinuteColor,
        tasks.commandBarSurface,
      );
      expect(timeTheme.timePickerTheme.dialHandColor, primary);
      expect(
        timeTheme.timePickerTheme.shape,
        isA<RoundedRectangleBorder>().having(
          (shape) => shape.borderRadius,
          'radius',
          BorderRadius.circular(tasks.panelRadius),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
    }
  });
}
