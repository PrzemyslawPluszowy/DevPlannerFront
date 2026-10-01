import 'package:dartz/dartz.dart' show Right;
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_priority_header_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Tasks extends Mock implements TasksRepository {}

final class _Acceptance extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _Checklist extends Mock implements TaskChecklistRepository {}

ProjectTaskDetailsResponse _details() => ProjectTaskDetailsResponse(
  task: ProjectTaskResponse(
    id: 'task-1',
    number: 1,
    key: 'TASK-1',
    workspaceId: 'workspace-1',
    projectId: 'project-1',
    title: 'Task',
    status: ProjectTaskStatus.todo,
    priority: TaskPriority.normal,
    taskType: 'Task',
    position: 1,
    createdByUserId: 'user-1',
    assignees: [],
    checklistItems: [],
    createdAtUtc: DateTime.utc(2026),
    updatedAtUtc: DateTime.utc(2026),
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

TaskDetailsCubit _source(_Tasks repository) => TaskDetailsCubit(
  repository: repository,
  acceptanceCriteriaRepository: _Acceptance(),
  checklistRepository: _Checklist(),
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  taskId: 'task-1',
);

void _stub(_Tasks repository) {
  when(
    () => repository.getTask(
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    ),
  ).thenAnswer((_) async => Right(_details()));
}

void main() {
  setUpAll(
    () => registerFallbackValue(
      const UpdateProjectTaskPayload(
        title: 'Task',
        status: ProjectTaskStatus.todo,
        priority: TaskPriority.normal,
        position: 1,
        expectedVersion: 1,
      ),
    ),
  );
  for (final replaceSource in [false, true]) {
    testWidgets(
      replaceSource
          ? 'old priority menu cannot mutate a replaced source'
          : 'priority is selected directly without the basics dialog',
      (tester) async {
        final firstRepository = _Tasks();
        final secondRepository = _Tasks();
        _stub(firstRepository);
        _stub(secondRepository);
        final first = _source(firstRepository);
        final second = _source(secondRepository);
        await Future.wait([first.load(), second.load()]);
        addTearDown(first.close);
        addTearDown(second.close);
        final updated = _details().task.copyWith(
          priority: TaskPriority.critical,
          version: 2,
        );
        when(
          () => firstRepository.updateTask(
            workspaceId: 'workspace-1',
            projectId: 'project-1',
            taskId: 'task-1',
            payload: any(named: 'payload'),
          ),
        ).thenAnswer(
          (_) async => Right(
            TaskMutationResponse(
              taskId: updated.id,
              taskVersion: 2,
              taskUpdatedAtUtc: updated.updatedAtUtc,
              data: updated,
            ),
          ),
        );
        final selectedSource = ValueNotifier<TaskDetailsCubit>(first);
        addTearDown(selectedSource.dispose);
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: MaterialTheme.crm().light(),
            home: Scaffold(
              body: ValueListenableBuilder<TaskDetailsCubit>(
                valueListenable: selectedSource,
                builder: (_, source, _) => BlocProvider.value(
                  value: source,
                  child: const TaskDetailsModalTheme(
                    child: Center(
                      child: TaskPriorityHeaderControl(
                        priority: TaskPriority.normal,
                        enabled: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.byKey(const ValueKey('task-header-priority')));
        await tester.pumpAndSettle();
        expect(find.byType(Dialog), findsNothing);
        if (replaceSource) {
          selectedSource.value = second;
          await tester.pump();
        }
        await tester.tap(find.text('Critical priority'));
        await tester.pumpAndSettle();
        if (replaceSource) {
          verifyNever(
            () => firstRepository.updateTask(
              workspaceId: 'workspace-1',
              projectId: 'project-1',
              taskId: 'task-1',
              payload: any(named: 'payload'),
            ),
          );
        } else {
          verify(
            () => firstRepository.updateTask(
              workspaceId: 'workspace-1',
              projectId: 'project-1',
              taskId: 'task-1',
              payload: any(named: 'payload'),
            ),
          ).called(1);
        }
        verifyNever(
          () => secondRepository.updateTask(
            workspaceId: 'workspace-1',
            projectId: 'project-1',
            taskId: 'task-1',
            payload: any(named: 'payload'),
          ),
        );
      },
    );
  }
}
