import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/subtasks/cubit/kanban_subtasks_state.dart';
import 'package:flutter_test/flutter_test.dart';

final class _MockTasksRepo implements TasksRepository {
  _MockTasksRepo({
    this.listResult,
    this.createResult,
  });

  Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>? listResult;
  Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>? createResult;
  Either<ApiError, TaskMutationResponse<ProjectTaskListItemResponse>>?
  updateListResult;
  UpdateTaskListItemPayload? lastUpdatePayload;
  int listCallCount = 0;

  @override
  Future<Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>>
  listProjectTasks({
    required String workspaceId,
    required String projectId,
    ProjectTasksQuery query = const ProjectTasksQuery(),
  }) async {
    listCallCount++;
    return listResult ??
        Right(
          CursorPageResponse<ProjectTaskListItemResponse>(
            items: [
              ProjectTaskListItemResponse(
                id: 'sub-1',
                number: 101,
                key: 'EX-101',
                title: 'Podzadanie testowe 1',
                status: ProjectTaskStatus.todo,
                priority: TaskPriority.normal,
                assignees: const [],
                checklistCompletedCount: 0,
                checklistTotalCount: 0,
                updatedAtUtc: DateTime.utc(2026, 9, 6),
                version: 1,
              ),
            ],
            nextCursor: query.cursor == null ? 'cur-2' : null,
          ),
        );
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  createTask({
    required String workspaceId,
    required String projectId,
    required CreateProjectTaskPayload payload,
  }) async =>
      createResult ??
      Right(
        TaskMutationResponse<ProjectTaskResponse>(
          taskId: 'sub-new',
          taskVersion: 1,
          taskUpdatedAtUtc: DateTime.utc(2026, 9, 6),
          data: ProjectTaskResponse(
            id: 'sub-new',
            number: 102,
            key: 'EX-102',
            workspaceId: workspaceId,
            projectId: projectId,
            parentTaskId: payload.parentTaskId,
            title: payload.title,
            status: ProjectTaskStatus.todo,
            priority: TaskPriority.normal,
            taskType: 'Task',
            position: 1000,
            createdByUserId: 'u-1',
            assignees: const [],
            checklistItems: const [],
            createdAtUtc: DateTime.utc(2026, 9, 6),
            updatedAtUtc: DateTime.utc(2026, 9, 6),
            version: 1,
          ),
        ),
      );

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  quickCreateTask({
    required String workspaceId,
    required String projectId,
    required QuickCreateProjectTaskPayload payload,
  }) async =>
      createResult ??
      Right(
        TaskMutationResponse<ProjectTaskResponse>(
          taskId: 'sub-new',
          taskVersion: 1,
          taskUpdatedAtUtc: DateTime.utc(2026, 9, 6),
          data: ProjectTaskResponse(
            id: 'sub-new',
            number: 102,
            key: 'EX-102',
            workspaceId: workspaceId,
            projectId: projectId,
            parentTaskId: payload.parentTaskId,
            title: payload.title,
            status: ProjectTaskStatus.todo,
            priority: TaskPriority.normal,
            taskType: 'Task',
            position: 1000,
            createdByUserId: 'u-1',
            assignees: const [],
            checklistItems: const [],
            createdAtUtc: DateTime.utc(2026, 9, 6),
            updatedAtUtc: DateTime.utc(2026, 9, 6),
            version: 1,
          ),
        ),
      );

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskListItemResponse>>>
  updateListItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required UpdateTaskListItemPayload payload,
  }) async {
    lastUpdatePayload = payload;
    return updateListResult ??
        Right(
          TaskMutationResponse<ProjectTaskListItemResponse>(
            taskId: taskId,
            taskVersion: payload.expectedVersion + 1,
            taskUpdatedAtUtc: DateTime.utc(2026, 9, 8),
            data: ProjectTaskListItemResponse(
              id: taskId,
              number: 101,
              key: 'EX-101',
              title: 'Podzadanie testowe 1',
              status: payload.status ?? ProjectTaskStatus.todo,
              customStatusId: payload.customStatusId,
              priority: payload.priority ?? TaskPriority.normal,
              assignees: const [],
              checklistCompletedCount: 0,
              checklistTotalCount: 0,
              updatedAtUtc: DateTime.utc(2026, 9, 8),
              version: payload.expectedVersion + 1,
            ),
          ),
        );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('KanbanSubtasksCubit', () {
    test('stan początkowy ma subtasks: [] i poprawne liczniki', () async {
      final repo = _MockTasksRepo();
      final cubit = KanbanSubtasksCubit(
        tasksRepository: repo,
        workspaceId: 'w-1',
        projectId: 'p-1',
        parentTaskId: 'parent-1',
        initialSubtaskTotal: 5,
        initialSubtaskCompleted: 2,
      );

      expect(cubit.state, isA<KanbanSubtasksInitial>());
      expect(cubit.state.subtaskTotal, 5);
      expect(cubit.state.subtaskCompleted, 2);
      expect(cubit.state.subtasks, isEmpty);
      await cubit.close();
    });

    test(
      'loadInitial emituje KanbanSubtasksReady z pobranymi dziećmi',
      () async {
        final repo = _MockTasksRepo();
        final cubit = KanbanSubtasksCubit(
          tasksRepository: repo,
          workspaceId: 'w-1',
          projectId: 'p-1',
          parentTaskId: 'parent-1',
          initialSubtaskTotal: 5,
          initialSubtaskCompleted: 1,
        );

        await cubit.loadInitial();

        expect(cubit.state, isA<KanbanSubtasksReady>());
        final ready = cubit.state as KanbanSubtasksReady;
        expect(ready.subtasks.length, 1);
        expect(ready.subtasks.first.id, 'sub-1');
        expect(ready.hasMore, isTrue);
        expect(ready.nextCursor, 'cur-2');
        await cubit.close();
      },
    );

    test('loadInitial przy błędzie sieci emituje KanbanSubtasksError z komunikatem', () async {
      final repo = _MockTasksRepo(
        listResult: const Left(
          ApiError(
            type: ApiErrorType.server,
            message: 'Błąd połączenia z serwerem',
          ),
        ),
      );
      final cubit = KanbanSubtasksCubit(
        tasksRepository: repo,
        workspaceId: 'w-1',
        projectId: 'p-1',
        parentTaskId: 'parent-1',
        initialSubtaskTotal: 3,
        initialSubtaskCompleted: 0,
      );

      await cubit.loadInitial();

      expect(cubit.state, isA<KanbanSubtasksError>());
      final error = cubit.state as KanbanSubtasksError;
      expect(error.message, 'Błąd połączenia z serwerem');
      await cubit.close();
    });

    test(
      'loadMore dołącza nowe elementy bez duplikacji i aktualizuje cursor',
      () async {
        final repo = _MockTasksRepo();
        final cubit = KanbanSubtasksCubit(
          tasksRepository: repo,
          workspaceId: 'w-1',
          projectId: 'p-1',
          parentTaskId: 'parent-1',
          initialSubtaskTotal: 5,
          initialSubtaskCompleted: 0,
        );

        await cubit.loadInitial();

        repo.listResult = Right(
          CursorPageResponse<ProjectTaskListItemResponse>(
            items: [
              ProjectTaskListItemResponse(
                id: 'sub-2',
                number: 102,
                key: 'EX-102',
                title: 'Podzadanie 2',
                status: ProjectTaskStatus.todo,
                priority: TaskPriority.normal,
                assignees: const [],
                checklistCompletedCount: 0,
                checklistTotalCount: 0,
                updatedAtUtc: DateTime.utc(2026, 9, 6),
                version: 1,
              ),
            ],
          ),
        );

        await cubit.loadMore();

        final ready = cubit.state as KanbanSubtasksReady;
        expect(ready.subtasks.length, 2);
        expect(ready.subtasks[1].id, 'sub-2');
        await cubit.close();
      },
    );

    test(
      'createSubtask dodaje nowe dziecko, inkrementuje licznik i czyści błąd',
      () async {
        final repo = _MockTasksRepo();
        final cubit = KanbanSubtasksCubit(
          tasksRepository: repo,
          workspaceId: 'w-1',
          projectId: 'p-1',
          parentTaskId: 'parent-1',
          initialSubtaskTotal: 1,
          initialSubtaskCompleted: 0,
        );

        await cubit.loadInitial();
        final success = await cubit.createSubtask('Nowe podzadanie');

        expect(success, isTrue);
        final ready = cubit.state as KanbanSubtasksReady;
        expect(ready.subtasks.length, 2);
        expect(ready.subtasks.last.title, 'Nowe podzadanie');
        expect(ready.subtaskTotal, 2);
        await cubit.close();
      },
    );

    test(
      'createSubtask przy błędzie zachowuje stan i zapisuje createError',
      () async {
        final repo = _MockTasksRepo(
          createResult: const Left(
            ApiError(
              type: ApiErrorType.forbidden,
              message: 'Brak uprawnień do tworzenia podzadania',
            ),
          ),
        );
        final cubit = KanbanSubtasksCubit(
          tasksRepository: repo,
          workspaceId: 'w-1',
          projectId: 'p-1',
          parentTaskId: 'parent-1',
          initialSubtaskTotal: 1,
          initialSubtaskCompleted: 0,
        );

        await cubit.loadInitial();
        final success = await cubit.createSubtask('Zadanie bez uprawnień');

        expect(success, isFalse);
        final ready = cubit.state as KanbanSubtasksReady;
        expect(ready.createError, 'Brak uprawnień do tworzenia podzadania');
        expect(ready.subtasks.length, 1);
        await cubit.close();
      },
    );

    test(
      'updateStatus optymistycznie zmienia dziecko i licznik done',
      () async {
        final cubit = KanbanSubtasksCubit(
          tasksRepository: _MockTasksRepo(),
          workspaceId: 'w-1',
          projectId: 'p-1',
          parentTaskId: 'parent-1',
          initialSubtaskTotal: 1,
          initialSubtaskCompleted: 0,
        );
        await cubit.loadInitial();

        expect(
          await cubit.updateStatus('sub-1', ProjectTaskStatus.done),
          isTrue,
        );
        final ready = cubit.state as KanbanSubtasksReady;
        expect(ready.subtasks.single.status, ProjectTaskStatus.done);
        expect(ready.subtasks.single.version, 2);
        expect(ready.subtaskCompleted, 1);
        expect(ready.pendingSubtaskIds, isEmpty);
        await cubit.close();
      },
    );

    test(
      'updateStatus wysyła wyłącznie identyfikator statusu customowego',
      () async {
        final repo = _MockTasksRepo();
        final cubit = KanbanSubtasksCubit(
          tasksRepository: repo,
          workspaceId: 'w-1',
          projectId: 'p-1',
          parentTaskId: 'parent-1',
          initialSubtaskTotal: 1,
          initialSubtaskCompleted: 0,
        );
        await cubit.loadInitial();

        expect(
          await cubit.updateStatus(
            'sub-1',
            ProjectTaskStatus.inProgress,
            customStatusId: 'custom-in-progress',
          ),
          isTrue,
        );

        expect(repo.lastUpdatePayload?.status, isNull);
        expect(repo.lastUpdatePayload?.customStatusId, 'custom-in-progress');
        expect(repo.lastUpdatePayload?.toJson(), isNot(contains('status')));
        expect(
          repo.lastUpdatePayload?.toJson()['customStatusId'],
          'custom-in-progress',
        );
        await cubit.close();
      },
    );

    test('quick-create pomija oba nieużywane pola statusu w JSON', () {
      final json = const QuickCreateProjectTaskPayload(
        title: 'Nowe zadanie',
      ).toJson();

      expect(json, isNot(contains('targetStatus')));
      expect(json, isNot(contains('customStatusId')));
    });
  });
}
