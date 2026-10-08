import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_draft_registry.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dependencies.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dependency_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _Tasks extends Mock implements TasksRepository {}

final class _Acceptance extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _Checklist extends Mock implements TaskChecklistRepository {}

final dependency = TaskDependencyDetailsResponse(
  id: 'dependency-1',
  sourceTaskId: 'task-1',
  targetTaskId: 'task-2',
  type: TaskDependencyType.blocks,
  createdAtUtc: DateTime.utc(2026),
  relatedTask: const ProjectTaskReferenceResponse(
    id: 'task-2',
    number: 2,
    key: 'TASK-2',
    title: 'Related task',
    status: ProjectTaskStatus.todo,
    version: 1,
  ),
);

ProjectTaskDetailsResponse details() => ProjectTaskDetailsResponse(
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
    position: 100,
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
  dependencies: [dependency],
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
  setUpAll(
    () => registerFallbackValue(
      const UpdateTaskDependencyPayload(
        dependencyKind: TaskDependencyKind.finishToStart,
        lagDays: 0,
        expectedVersion: 1,
      ),
    ),
  );

  testWidgets('late save failure after editor disposal belongs to parent', (
    tester,
  ) async {
    final repository = _Tasks();
    final registry = TaskDetailDraftRegistry();
    final pending =
        Completer<
          Either<ApiError, TaskMutationResponse<TaskDependencyResponse>>
        >();
    const failure = ApiError(
      type: ApiErrorType.validation,
      message: 'Rejected',
    );
    when(
      () => repository.updateDependency(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
        dependencyId: 'dependency-1',
        payload: any(named: 'payload'),
      ),
    ).thenAnswer((_) => pending.future);
    final cubit = await pumpEditor(tester, repository, registry);
    await tester.tap(find.text('Save'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    pending.complete(const Left(failure));
    await tester.pumpAndSettle();
    final state = cubit.state as TaskDetailsReady;
    expect(state.mutationFailure, failure);
    expect(state.mutationOwner, isNull);
    await cubit.close();
    registry.dispose();
  });

  testWidgets(
    'incoming dependency offers source navigation, not child mutation',
    (tester) async {
      final repository = _Tasks();
      final registry = TaskDetailDraftRegistry();
      final incoming = dependency.copyWith(
        sourceTaskId: 'task-2',
        targetTaskId: 'task-1',
      );
      final cubit = await pumpEditor(
        tester,
        repository,
        registry,
        child: DependenciesSection(dependencies: [incoming], isSaving: false),
      );
      expect(find.byTooltip('Open source task'), findsOneWidget);
      expect(find.textContaining('Blocked by'), findsOneWidget);
      expect(find.byTooltip('Edit dependency'), findsNothing);
      expect(find.byTooltip('Delete dependency'), findsNothing);
      await tester.pumpWidget(const SizedBox.shrink());
      final state = cubit.state;
      if (state is TaskDetailsReady) {
        expect(state.mutationOwner, isNull);
        expect(state.mutationFailure, isNull);
      }
      await cubit.close();
      registry.dispose();
    },
  );

  testWidgets(
    'failed dependency save remains visible in the dialog with draft',
    (tester) async {
      final repository = _Tasks();
      final registry = TaskDetailDraftRegistry();
      const failure = ApiError(
        type: ApiErrorType.validation,
        message: 'Zadania blokowałyby się nawzajem.',
        apiCode: 'task_dependency.cycle',
        traceId: 'trace-dependency',
        fields: {
          'lagDays': ['Invalid schedule'],
        },
      );
      when(
        () => repository.updateDependency(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          taskId: 'task-1',
          dependencyId: 'dependency-1',
          payload: any(named: 'payload'),
        ),
      ).thenAnswer((_) async => const Left(failure));
      final cubit = await pumpEditor(tester, repository, registry);
      await tester.enterText(find.byType(TextField), '12');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.byType(EditDependencyDialog), findsOneWidget);
      expect(
        find.textContaining('Choose another task or relationship type.'),
        findsOneWidget,
      );
      final owned = cubit.state as TaskDetailsReady;
      expect(owned.mutationOwner, isNotNull);
      cubit.clearEditorMutationError(Object());
      expect((cubit.state as TaskDetailsReady).mutationFailure, failure);

      expect(
        find.descendant(
          of: find.byType(EditDependencyDialog),
          matching: find.byType(TaskDetailsModalError),
        ),
        findsOneWidget,
      );
      await tester.tap(find.byType(ExpansionTile));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('task_dependency.cycle', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('trace-dependency', findRichText: true),
        findsOneWidget,
      );
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '12',
      );
      expect(registry.hasUnsavedDrafts, isTrue);
      verify(
        () => repository.updateDependency(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          taskId: 'task-1',
          dependencyId: 'dependency-1',
          payload: any(named: 'payload'),
        ),
      ).called(1);
      await tester.pumpWidget(const SizedBox.shrink());
      await cubit.close();
      registry.dispose();
    },
  );

  testWidgets('invalid dependency lag is inline and never calls REST', (
    tester,
  ) async {
    final repository = _Tasks();
    final registry = TaskDetailDraftRegistry();
    final cubit = await pumpEditor(tester, repository, registry);
    await tester.enterText(find.byType(TextField), '366');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byType(TextField)).decoration!.errorText,
      isNotNull,
    );
    expect(find.byType(SnackBar), findsNothing);
    verifyNever(
      () => repository.updateDependency(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
        dependencyId: 'dependency-1',
        payload: any(named: 'payload'),
      ),
    );
    expect(registry.hasUnsavedDrafts, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    final state = cubit.state;
    if (state is TaskDetailsReady) {
      expect(state.mutationOwner, isNull);
      expect(state.mutationFailure, isNull);
    }
    await cubit.close();
    registry.dispose();
  });
}

Future<TaskDetailsCubit> pumpEditor(
  WidgetTester tester,
  _Tasks repository,
  TaskDetailDraftRegistry registry, {
  Widget? child,
}) async {
  when(
    () => repository.getTask(
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    ),
  ).thenAnswer((_) async => Right(details()));
  final cubit = TaskDetailsCubit(
    repository: repository,
    acceptanceCriteriaRepository: _Acceptance(),
    checklistRepository: _Checklist(),
    workspaceId: 'workspace-1',
    projectId: 'project-1',
    taskId: 'task-1',
  );
  await cubit.load();
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('en'),
      theme: MaterialTheme.crm().light(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider.value(
          value: cubit,
          child: TaskDetailDraftScope(
            registry: registry,
            child: child ?? EditDependencyDialog(dependency: dependency),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return cubit;
}
