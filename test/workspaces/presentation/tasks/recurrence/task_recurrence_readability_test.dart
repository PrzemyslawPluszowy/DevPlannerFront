import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/project_recurrences_rule_card.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/project_recurrences_run_card.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/task_recurrence_editor_schedule_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _Repository extends Mock implements TaskRecurrenceRepository {}

void main() {
  for (final language in ['pl', 'en']) {
    for (final outcome in TaskRecurrenceRunOutcome.values) {
      testWidgets('complete outcome label and meaning: $language $outcome', (
        tester,
      ) async {
        final semantics = tester.ensureSemantics();
        final l10n = await AppLocalizations.delegate.load(Locale(language));
        await tester.pumpWidget(
          _host(
            language,
            ProjectRecurrencesRunCard(
              run: ProjectTaskRecurrenceRunResponse(
                id: 'run',
                recurrenceRuleId: 'rule',
                sourceTaskId: 'task',
                taskKey: 'TASK-1',
                taskTitle: 'Source task',
                scheduledAtUtc: DateTime.utc(2026, 10, 3),
                executedAtUtc: DateTime.utc(2026, 10, 3),
                outcome: outcome,
                createdTaskKey: outcome == TaskRecurrenceRunOutcome.created
                    ? 'TASK-2'
                    : null,
              ),
            ),
          ),
        );
        final created = outcome == TaskRecurrenceRunOutcome.created;
        final label = created
            ? l10n.taskRecurrenceRunCreatedLabel
            : l10n.taskRecurrenceRunSkippedLabel;
        final fullLabel = created
            ? l10n.tasksRecurrenceOutcomeCreated
            : l10n.tasksRecurrenceOutcomeSkipped;
        expect(find.text(label), findsOneWidget);
        expect(find.bySemanticsLabel(fullLabel), findsOneWidget);
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text(label),
        );
        expect(paragraph.size.width, lessThanOrEqualTo(72));
        expect(paragraph.didExceedMaxLines, isFalse);
        expect(tester.takeException(), isNull);
        semantics.dispose();
      });
    }
    testWidgets('editor explains local time and series zone: $language', (
      tester,
    ) async {
      await tester.pumpWidget(
        _host(
          language,
          TaskRecurrenceEditorScheduleSection(
            scheduledDate: DateTime(2026, 10, 3),
            scheduledTime: const TimeOfDay(hour: 9, minute: 23),
            seriesTimeZoneId: 'Europe/Warsaw',
            enabled: true,
            onPickDate: (_) {},
            onPickTime: (_) {},
          ),
        ),
      );
      expect(
        find.textContaining(
          language == 'pl' ? 'czasie urządzenia' : 'device time',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Europe/Warsaw'), findsOneWidget);
      expect(find.textContaining('UTC'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('editor stays beside right-hand action, not row origin', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final repository = _Repository();
    final pending = Completer<Either<ApiError, TaskRecurrenceResponse>>();
    when(
      () => repository.get(
        workspaceId: 'workspace',
        projectId: 'project',
        taskId: 'task',
      ),
    ).thenAnswer((_) => pending.future);
    final cubit = ProjectRecurrencesCubit(
      repository: repository,
      workspaceId: 'workspace',
      projectId: 'project',
    );
    await tester.pumpWidget(
      _host(
        'en',
        RepositoryProvider<TaskRecurrenceRepository>.value(
          value: repository,
          child: BlocProvider.value(
            value: cubit,
            child: ProjectRecurrencesRuleCard(
              rule: _rule(),
              isActionInProgress: false,
              workspaceId: 'workspace',
              projectId: 'project',
            ),
          ),
        ),
      ),
    );
    final edit = find.byTooltip('Edit recurrence settings');
    final anchor = tester.getRect(edit);
    await tester.tap(edit);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    final heading = find.text('Task recurrence');
    expect(heading, findsOneWidget);
    final headingPosition = tester.getTopLeft(heading);
    expect(headingPosition.dx, greaterThan(anchor.left - 340));
    expect(headingPosition.dy, greaterThanOrEqualTo(anchor.bottom));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await cubit.close();
  });
}

Widget _host(String language, Widget child) => MaterialApp(
  locale: Locale(language),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: MaterialTheme.crm().dark(),
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

ProjectTaskRecurrenceItemResponse _rule() => ProjectTaskRecurrenceItemResponse(
  id: 'rule',
  workspaceId: 'workspace',
  projectId: 'project',
  sourceTaskId: 'task',
  taskKey: 'TASK-1',
  taskTitle: 'Source task',
  taskStatus: ProjectTaskStatus.todo,
  priority: TaskPriority.normal,
  mode: TaskRecurrenceMode.scheduled,
  frequency: TaskRecurrenceFrequency.daily,
  interval: 1,
  timeZoneId: 'Europe/Warsaw',
  nextOccurrenceAtUtc: DateTime.utc(2026, 10, 3),
  occurrenceStatus: ProjectTaskStatus.todo,
  skipIfPreviousOpen: false,
  isActive: true,
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  version: 1,
);
