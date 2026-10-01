import 'package:dartz/dartz.dart' show Right;
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_status_category.dart';
import 'package:devplanner/workspaces/domain/repositories/custom_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_theme.dart';
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

final class _WorkflowRepository extends Mock
    implements CustomWorkflowRepository {}

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

ProjectCustomStatusResponse _status() => const ProjectCustomStatusResponse(
  id: 'custom-1',
  projectId: 'project-1',
  name: 'Doing',
  colorHex: '#2472D4',
  category: TaskStatusCategory.inProgress,
  position: 1,
  isDefault: false,
  taskCount: 1,
  version: 1,
);

TaskDetailsCubit _source(
  _TasksRepository tasks,
  _WorkflowRepository workflow,
) => TaskDetailsCubit(
  repository: tasks,
  acceptanceCriteriaRepository: _AcceptanceRepository(),
  checklistRepository: _ChecklistRepository(),
  customWorkflowRepository: workflow,
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  taskId: 'task-1',
);

void _stubSources(_TasksRepository tasks, _WorkflowRepository workflow) {
  when(
    () => tasks.getTask(
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    ),
  ).thenAnswer((_) async => Right(_details()));
  when(
    () => workflow.listStatuses(
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    ),
  ).thenAnswer((_) async => Right([_status()]));
}

void main() {
  testWidgets('ignores an open choice after the task provider is replaced', (
    tester,
  ) async {
    final oldTasks = _TasksRepository();
    final newTasks = _TasksRepository();
    final oldWorkflow = _WorkflowRepository();
    final newWorkflow = _WorkflowRepository();
    _stubSources(oldTasks, oldWorkflow);
    _stubSources(newTasks, newWorkflow);
    final oldSource = _source(oldTasks, oldWorkflow);
    final newSource = _source(newTasks, newWorkflow);
    await Future.wait([oldSource.load(), newSource.load()]);
    addTearDown(oldSource.close);
    addTearDown(newSource.close);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        theme: MaterialTheme.crm().light(),
        home: _SourceHarness(oldSource: oldSource, newSource: newSource),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Backlog'));
    await tester.pumpAndSettle();
    expect(find.text('Doing'), findsOneWidget);

    tester.state<_SourceHarnessState>(find.byType(_SourceHarness)).replace();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Doing').last);
    await tester.pumpAndSettle();

    verifyNever(
      () => oldTasks.moveCustomStatus(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
        taskId: any(named: 'taskId'),
        customStatusId: any(named: 'customStatusId'),
        expectedVersion: any(named: 'expectedVersion'),
      ),
    );
    verifyNever(
      () => newTasks.moveCustomStatus(
        workspaceId: any(named: 'workspaceId'),
        projectId: any(named: 'projectId'),
        taskId: any(named: 'taskId'),
        customStatusId: any(named: 'customStatusId'),
        expectedVersion: any(named: 'expectedVersion'),
      ),
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

final class _SourceHarness extends StatefulWidget {
  const _SourceHarness({required this.oldSource, required this.newSource});

  final TaskDetailsCubit oldSource;
  final TaskDetailsCubit newSource;

  @override
  State<_SourceHarness> createState() => _SourceHarnessState();
}

final class _SourceHarnessState extends State<_SourceHarness> {
  var _useNewSource = false;

  void replace() => setState(() => _useNewSource = true);

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _useNewSource ? widget.newSource : widget.oldSource,
    child: Scaffold(
      body: Center(
        child: TaskDetailsModalTheme(
          child: TaskCustomStatusHeaderControl(
            details: _details(),
            fallbackLabel: 'Backlog',
            enabled: true,
          ),
        ),
      ),
    ),
  );
}
