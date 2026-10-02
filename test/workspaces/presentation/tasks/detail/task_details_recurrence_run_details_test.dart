import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_run_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_recurrence_run_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _RecurrenceRepository extends Mock
    implements TaskRecurrenceRepository {}

void main() {
  for (final locale in const [Locale('pl'), Locale('en')]) {
    testWidgets('pokazuje strefę, UTC i wynik oddzielony od źródła: $locale', (
      tester,
    ) async {
      final repository = _RecurrenceRepository();
      when(
        () => repository.getProjectRecurrenceRuns(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        ),
      ).thenAnswer(
        (_) async => Right([
          ProjectTaskRecurrenceRunResponse(
            id: 'run-1',
            recurrenceRuleId: 'rule-1',
            sourceTaskId: 'task-1',
            taskKey: 'TASK-1',
            taskTitle: 'Source task',
            scheduledAtUtc: DateTime.utc(2026, 10, 3, 8),
            executedAtUtc: DateTime.utc(2026, 10, 3, 8),
            outcome: TaskRecurrenceRunOutcome.created,
            createdTaskId: 'task-2',
            createdTaskKey: 'TASK-2',
          ),
        ]),
      );
      final cubit = TaskRecurrenceRunCubit(
        repository: repository,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        sourceTaskId: 'task-1',
      );
      await cubit.ensureLatestLoaded('rule-1');
      final task = _task();
      final l10n = await AppLocalizations.delegate.load(locale);

      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: MaterialTheme.crm().light(),
          home: Scaffold(
            body: BlocProvider.value(
              value: cubit,
              child: TaskRecurrenceRunDetails(
                task: task,
                isEditable: false,
              ),
            ),
          ),
        ),
      );

      expect(
        find.textContaining(l10n.taskRecurrenceNextOccurrenceUtc),
        findsOneWidget,
      );
      expect(find.textContaining('Europe/Warsaw'), findsOneWidget);
      expect(find.text(l10n.tasksRecurrenceOutcomeCreated), findsOneWidget);
      expect(
        find.text('${l10n.taskRecurrenceCreatedTask}: TASK-2'),
        findsOneWidget,
      );
      expect(find.text(l10n.tasksRecurrenceRunNow), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await cubit.close();
    });
  }
}

ProjectTaskResponse _task() => ProjectTaskResponse(
  id: 'task-1',
  number: 1,
  key: 'TASK-1',
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  title: 'Source task',
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.normal,
  taskType: 'Task',
  position: 1,
  createdByUserId: 'user-1',
  assignees: const [],
  checklistItems: const [],
  recurrence: const TaskRecurrenceSummaryResponse(
    id: 'rule-1',
    sourceTaskId: 'task-1',
    mode: TaskRecurrenceMode.scheduled,
    frequency: TaskRecurrenceFrequency.weekly,
    interval: 1,
    timeZoneId: 'Europe/Warsaw',
    occurrenceStatus: ProjectTaskStatus.todo,
    skipIfPreviousOpen: true,
    isActive: true,
    isSourceTask: true,
    version: 1,
  ),
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  version: 1,
);
