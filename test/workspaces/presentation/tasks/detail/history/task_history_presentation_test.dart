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
  // TaskHistoryEventType and TaskActorType are transport response enums. The
  // status/priority scalars and arbitrary change fields are persisted metadata.
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

  for (final locale in ['pl', 'en']) {
    testWidgets(
      'history previews meaningful changes and expands all raw metadata: $locale',
      (tester) async {
        tester.view.physicalSize = const Size(360, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        const longTitle = 'A long task title that remains available in full';
        const itemId = '0a8dfdf1-9844-4c43-9242-2aca74898021';
        const occurrenceId = 'de7cc0ce-bec8-4bd2-a849-2c7e1bccae11';
        final event = _move(
          changes: [
            const TaskHistoryChangeResponse(field: 'action', after: 'create'),
            const TaskHistoryChangeResponse(
              field: 'scheduledAtUtc',
              after: '2026-10-01T12:00:00Z',
            ),
            const TaskHistoryChangeResponse(field: 'title', after: longTitle),
            const TaskHistoryChangeResponse(field: 'itemId', after: itemId),
            const TaskHistoryChangeResponse(
              field: 'occurrenceTaskId',
              after: occurrenceId,
            ),
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
              body: SingleChildScrollView(
                child: TaskHistoryEventTile(event: event),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final context = tester.element(find.byType(TaskHistoryEventTile));
        final l10n = AppLocalizations.of(context)!;
        expect(
          find.textContaining(l10n.taskHistoryOperationCreated),
          findsOneWidget,
        );
        expect(
          find.textContaining(l10n.taskHistoryScheduledDate),
          findsOneWidget,
        );
        expect(find.textContaining(itemId), findsNothing);
        expect(find.textContaining(occurrenceId), findsNothing);
        expect(tester.takeException(), isNull);

        await tester.tap(find.byType(ExpansionTile));
        await tester.pumpAndSettle();
        expect(find.textContaining(itemId), findsOneWidget);
        expect(find.textContaining(occurrenceId), findsOneWidget);
        expect(
          find.textContaining(l10n.taskHistoryItemIdentifier),
          findsOneWidget,
        );
        expect(
          find.textContaining(l10n.taskHistoryOccurrenceTaskIdentifier),
          findsOneWidget,
        );
        expect(find.textContaining(longTitle), findsNWidgets(2));
        expect(
          find.textContaining(l10n.taskDetailsStatusField),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final locale in ['pl', 'en']) {
    testWidgets(
      'acceptance audit keeps persisted PascalCase fields readable: $locale',
      (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: TaskHistoryEventTile(
                event: _move(
                  changes: const [
                    TaskHistoryChangeResponse(
                      field: 'IsAccepted',
                      before: false,
                      after: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.text(
            locale == 'pl'
                ? 'Akceptacja: Niezaakceptowane → Zaakceptowane'
                : 'Acceptance: Not accepted → Accepted',
          ),
          findsOneWidget,
        );
        expect(find.textContaining('IsAccepted'), findsNothing);
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
      const family = '👨‍👩‍👧‍👦';
      expect(
        TaskHistoryPresentation.value(
          context,
          'title',
          '${'a' * 76}$family${'b' * 10}',
        ),
        '${'a' * 76}$family…',
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
