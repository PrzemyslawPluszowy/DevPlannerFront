import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/history/task_history_changes.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/history/task_history_presentation.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

TaskHistoryEventResponse _move({
  required List<TaskHistoryChangeResponse> changes,
}) => TaskHistoryEventResponse(
  eventId: 'qa-event',
  eventType: TaskHistoryEventType.kanbanMoved,
  actionLabel: 'Przesunięto kartę na Kanbanie',
  actor: const TaskHistoryActorResponse(
    type: TaskActorType.user,
    userId: 'qa-user-uuid',
  ),
  changes: changes,
  taskVersion: 3,
  correlationId: 'qa-correlation',
  createdAtUtc: DateTime.utc(2026, 10, 1, 12),
);

void main() {
  test('normalizes Kanban status pair without mutating API data or unchanged noise', () {
    final source = _move(
      changes: [
        const TaskHistoryChangeResponse(field: 'status', before: 2),
        const TaskHistoryChangeResponse(field: 'position', before: 1, after: 1),
        const TaskHistoryChangeResponse(field: 'targetStatus', after: 0),
      ],
    );
    final prepared = TaskHistoryChanges.prepare(source);
    expect(prepared.changes, [
      const TaskHistoryChangeResponse(field: 'status', before: 2, after: 0),
    ]);
    expect(source.changes, hasLength(3));
    expect(TaskHistoryChanges.prepare(prepared), prepared);
  });

  for (final locale in ['pl', 'en']) {
    testWidgets(
      'history uses author names, field labels and localized date: $locale',
      (tester) async {
        final event = _move(
          changes: [
            const TaskHistoryChangeResponse(
              field: 'status',
              before: 2,
              after: 0,
            ),
          ],
        );
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: TaskHistoryEventTile(
                event: event,
                actorNames: const {'qa-user-uuid': 'QA Author'},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.textContaining('QA Author'), findsOneWidget);
        expect(find.textContaining('qa-user-uuid'), findsNothing);
        expect(
          find.text(
            locale == 'pl'
                ? 'Przesunięto kartę na Kanbanie'
                : 'Kanban card moved',
          ),
          findsOneWidget,
        );
        final context = tester.element(find.byType(TaskHistoryEventTile));
        final l10n = AppLocalizations.of(context)!;
        expect(
          find.text(
            '${l10n.taskDetailsStatusField}: ${l10n.taskStatusInProgress} → ${l10n.taskStatusBacklog}',
          ),
          findsOneWidget,
        );
        if (locale == 'pl') expect(find.textContaining('Oct'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'every numeric metadata status and priority maps to the matching textual value',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: SizedBox(key: ValueKey('context'))),
        ),
      );
      await tester.pumpAndSettle();
      final context = tester.element(find.byKey(const ValueKey('context')));
      const statuses = [
        'Backlog',
        'Todo',
        'InProgress',
        'Blocked',
        'Done',
        'Cancelled',
      ];
      const priorities = ['Low', 'Normal', 'High', 'Critical'];
      for (var index = 0; index < statuses.length; index++) {
        expect(
          TaskHistoryPresentation.value(context, 'status', index),
          TaskHistoryPresentation.value(context, 'status', statuses[index]),
        );
      }
      for (var index = 0; index < priorities.length; index++) {
        expect(
          TaskHistoryPresentation.value(context, 'priority', index),
          TaskHistoryPresentation.value(context, 'priority', priorities[index]),
        );
      }
      expect(
        TaskHistoryPresentation.value(context, 'status', 99),
        AppLocalizations.of(context)!.taskHistoryUnknownStatus,
      );
      expect(
        TaskHistoryPresentation.actorLabel(
          context,
          const TaskHistoryActorResponse(
            type: TaskActorType.user,
            userId: 'removed-user',
          ),
          const {},
        ),
        AppLocalizations.of(context)!.taskDetailsHistoryActorUser,
      );
    },
  );
}
