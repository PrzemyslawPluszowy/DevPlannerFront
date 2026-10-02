import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_row_actions.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/task_recurrence_editor_schedule_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final language in ['pl', 'en']) {
    for (final mode in TaskRecurrenceMode.values) {
      testWidgets('recurrence tooltip uses $language for $mode', (
        tester,
      ) async {
        final locale = Locale(language);
        final recurrence = TaskRecurrenceSummaryResponse(
          id: 'rule',
          sourceTaskId: 'task',
          mode: mode,
          frequency: TaskRecurrenceFrequency.monthly,
          interval: 3,
          timeZoneId: 'Europe/Warsaw',
          occurrenceStatus: ProjectTaskStatus.todo,
          skipIfPreviousOpen: true,
          isActive: false,
          isSourceTask: true,
          version: 1,
          nextOccurrenceAtUtc: mode == TaskRecurrenceMode.scheduled
              ? DateTime.utc(2026, 10, 17, 12)
              : null,
        );
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: Text(
                  TaskRecurrenceSummaryLabeler.format(context, recurrence),
                ),
              ),
            ),
          ),
        );
        expect(
          find.textContaining(
            language == 'en' ? 'Every 3 months' : 'Co 3 mies.',
          ),
          findsOneWidget,
        );
        expect(
          find.textContaining(language == 'en' ? 'Paused' : 'Wstrzymana'),
          findsOneWidget,
        );
        if (mode == TaskRecurrenceMode.scheduled) {
          expect(
            find.textContaining(language == 'en' ? 'Oct' : 'paź'),
            findsOneWidget,
          );
          expect(find.textContaining('UTC'), findsOneWidget);
        } else {
          expect(
            find.textContaining(
              language == 'en'
                  ? 'Waiting for the open task'
                  : 'Oczekuje na ukończenie',
            ),
            findsOneWidget,
          );
        }
        if (language == 'en') {
          expect(find.textContaining('Cykliczność'), findsNothing);
        }
      });
    }
    testWidgets('schedule date follows $language locale', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: Locale(language),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: TaskRecurrenceEditorScheduleSection(
              scheduledDate: DateTime(2026, 10, 17),
              scheduledTime: const TimeOfDay(hour: 12, minute: 0),
              enabled: true,
              onPickDate: (_) {},
              onPickTime: (_) {},
            ),
          ),
        ),
      );
      expect(
        find.textContaining(language == 'en' ? 'October' : 'października'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
