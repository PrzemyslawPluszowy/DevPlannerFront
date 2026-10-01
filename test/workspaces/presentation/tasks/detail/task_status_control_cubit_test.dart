import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
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
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_status_control_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _TasksRepository extends Mock implements TasksRepository {}

final class _AcceptanceRepository extends Mock
    implements TaskAcceptanceCriteriaRepository {}

final class _ChecklistRepository extends Mock
    implements TaskChecklistRepository {}

final class _CustomWorkflowRepository extends Mock
    implements CustomWorkflowRepository {}

TaskDetailsCubit _source(CustomWorkflowRepository workflowRepository) =>
    TaskDetailsCubit(
      repository: _TasksRepository(),
      acceptanceCriteriaRepository: _AcceptanceRepository(),
      checklistRepository: _ChecklistRepository(),
      customWorkflowRepository: workflowRepository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );

ProjectTaskDetailsResponse _details({
  ProjectTaskWorkflowResponse? workflow,
}) => ProjectTaskDetailsResponse(
  task: ProjectTaskResponse(
    id: 'task-1',
    number: 1,
    key: 'TASK-1',
    workspaceId: 'workspace-1',
    projectId: 'project-1',
    title: 'Zadanie',
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
  workflow:
      workflow ??
      const ProjectTaskWorkflowResponse(
        statuses: [],
        transitions: [],
        version: 1,
      ),
  includedUsers: [],
);

ProjectCustomStatusResponse _status(String id, int position) =>
    ProjectCustomStatusResponse(
      id: id,
      projectId: 'project-1',
      name: id,
      colorHex: '#2563EB',
      category: TaskStatusCategory.todo,
      position: position,
      isDefault: position == 0,
      taskCount: 0,
      version: 1,
    );

void main() {
  test('empty transitions expose every system status, matching backend', () {
    expect(
      TaskWorkflowStatusOptions.allowedFor(_details()),
      ProjectTaskStatus.values,
    );
  });
  test(
    'ignores an old catalog response after same-project provider changes',
    () async {
      final pending =
          Completer<Either<ApiError, List<ProjectCustomStatusResponse>>>();
      final oldRepository = _CustomWorkflowRepository();
      final newRepository = _CustomWorkflowRepository();
      when(
        () => oldRepository.listStatuses(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        ),
      ).thenAnswer((_) => pending.future);
      when(
        () => newRepository.listStatuses(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        ),
      ).thenAnswer(
        (_) async => Right(<ProjectCustomStatusResponse>[_status('new', 1)]),
      );
      final oldSource = _source(oldRepository);
      final newSource = _source(newRepository);
      final cubit = TaskStatusControlCubit(
        source: oldSource,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );

      cubit.replaceScope(
        source: newSource,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );
      await Future<void>.delayed(Duration.zero);
      pending.complete(Right(<ProjectCustomStatusResponse>[_status('old', 0)]));
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.statuses.map((status) => status.id), ['new']);
      await cubit.close();
      await oldSource.close();
      await newSource.close();
    },
  );

  test(
    'empty custom catalog exposes only configured outgoing system transitions',
    () async {
      final repository = _CustomWorkflowRepository();
      when(
        () => repository.listStatuses(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        ),
      ).thenAnswer(
        (_) async => const Right(<ProjectCustomStatusResponse>[]),
      );
      final source = _source(repository);
      final cubit = TaskStatusControlCubit(
        source: source,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );
      await Future<void>.delayed(Duration.zero);
      final details = _details(
        workflow: const ProjectTaskWorkflowResponse(
          statuses: [],
          transitions: [
            ProjectTaskWorkflowTransitionResponse(
              fromStatus: ProjectTaskStatus.todo,
              toStatus: ProjectTaskStatus.inProgress,
            ),
          ],
          version: 3,
        ),
      );

      expect(cubit.state.statuses, isEmpty);
      expect(
        TaskWorkflowStatusOptions.allowedFor(details),
        [ProjectTaskStatus.todo, ProjectTaskStatus.inProgress],
      );
      await cubit.close();
      await source.close();
    },
  );

  test(
    'catalog failure stays an error and cannot masquerade as empty',
    () async {
      final repository = _CustomWorkflowRepository();
      const error = ApiError(
        type: ApiErrorType.connection,
        message: 'Brak połączenia',
      );
      when(
        () => repository.listStatuses(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        ),
      ).thenAnswer((_) async => const Left(error));
      final source = _source(repository);
      final cubit = TaskStatusControlCubit(
        source: source,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.error, error);
      expect(cubit.state.statuses, isEmpty);
      await cubit.close();
      await source.close();
    },
  );

  test('does not publish a pending catalog result after close', () async {
    final pending =
        Completer<Either<ApiError, List<ProjectCustomStatusResponse>>>();
    final repository = _CustomWorkflowRepository();
    when(
      () => repository.listStatuses(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer((_) => pending.future);
    final source = _source(repository);
    final cubit = TaskStatusControlCubit(
      source: source,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );

    await cubit.close();
    pending.complete(Right(<ProjectCustomStatusResponse>[_status('late', 0)]));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.isLoading, isTrue);
    expect(cubit.state.statuses, isEmpty);
    verify(
      () => repository.listStatuses(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).called(1);
    await source.close();
  });
}
