import 'package:dartz/dartz.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/custom_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_custom_status_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _TasksRepository extends Mock implements TasksRepository {}

final class _AcceptanceRepository extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _ChecklistRepository extends Mock
    implements TaskChecklistRepository {}

final class _CustomWorkflowRepository extends Mock
    implements CustomWorkflowRepository {}

ProjectTaskDetailsResponse _details() => ProjectTaskDetailsResponse(
  task: ProjectTaskResponse(
    id: 'task-1',
    number: 1,
    key: 'TASK-1',
    workspaceId: 'workspace-1',
    projectId: 'project-1',
    title: 'Pierwsze zadanie',
    status: ProjectTaskStatus.todo,
    priority: TaskPriority.normal,
    taskType: 'Task',
    position: 100,
    createdByUserId: 'user-1',
    assignees: [],
    checklistItems: [],
    createdAtUtc: DateTime.utc(2026, 8, 26),
    updatedAtUtc: DateTime.utc(2026, 8, 26),
    version: 1,
  ),
  labels: [],
  customFields: [],
  acceptanceCriteria: [],
  dependencies: [],
  watchers: [],
  isWatchedByMe: false,
  isPinnedByMe: false,
  subtasks: [],
  workflow: const ProjectTaskWorkflowResponse(
    statuses: [],
    transitions: [],
    version: 1,
  ),
  includedUsers: [],
);

void main() {
  testWidgets('status picker receives task cubit inside root modal route', (
    tester,
  ) async {
    final workflowRepository = _CustomWorkflowRepository();
    when(
      () => workflowRepository.listStatuses(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer((_) async => const Right(<ProjectCustomStatusResponse>[]));
    final cubit = TaskDetailsCubit(
      repository: _TasksRepository(),
      acceptanceCriteriaRepository: _AcceptanceRepository(),
      checklistRepository: _ChecklistRepository(),
      customWorkflowRepository: workflowRepository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider.value(
          value: cubit,
          child: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => TaskCustomStatusPicker.show(
                    context,
                    _details(),
                  ),
                  child: const Text('Otwórz status'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Otwórz status'));
    await tester.pumpAndSettle();

    verify(
      () => workflowRepository.listStatuses(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).called(1);
    expect(find.text('Status zadania w projekcie'), findsOneWidget);
    expect(
      find.text('Projekt nie ma aktywnych statusów własnych.'),
      findsOneWidget,
    );
  });
}
