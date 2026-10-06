import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _TasksRepository implements TasksRepository {
  ProjectTasksQuery? lastQuery;
  ProjectTasksGroupedQuery? lastGroupedQuery;
  QuickCreateProjectTaskPayload? createPayload;
  UpdateTaskListItemPayload? updateListItemPayload;
  final List<UpdateTaskListItemPayload> updateListItemPayloads = [];
  MoveProjectTaskPayload? movePayload;
  CreateTaskSelectionTokenPayload? selectionTokenPayload;
  BulkUpdateTaskSelectionPayload? bulkSelectionPayload;
  ApiError? bulkError;
  ApiError? selectionTokenError;
  Completer<Either<ApiError, TaskSelectionTokenResponse>>?
  deferredSelectionToken;
  int archiveCalls = 0;
  ApiError? flatPageError;
  bool throwFlatPage = false;
  Completer<Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>>?
  deferredFlatPage;
  int bulkCalls = 0;
  Completer<Either<ApiError, BulkUpdateTaskSelectionResponse>>? deferredBulk;
  int rootSubtaskCount = 0;
  int page = 0;
  int subtaskPage = 0;
  int groupedCalls = 0;
  bool includeBlockedGroup = false;
  bool includeBlockedTask = false;
  bool rootIsPinned = false;
  int rootWatcherCount = 0;
  bool rootIsWatchedByMe = false;
  ApiError? updateListItemError;
  ApiError? groupedListError;
  Completer<Either<ApiError, ProjectTaskGroupedListResponse>>?
  deferredNextGroupPage;
  bool useCustomStatusGroups = false;
  bool includeUnassignedCustomStatusGroup = false;
  bool failCreate = false;
  List<TaskCustomFieldValueResponse> taskCustomFields = const [];
  TaskRecurrenceSummaryResponse? rootRecurrence;
  ProjectTaskResponse? realtimeTask;
  int taskDetailsCalls = 0;

  @override
  Future<Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>>
  listProjectTasks({
    required String workspaceId,
    required String projectId,
    ProjectTasksQuery query = const ProjectTasksQuery(),
  }) async {
    lastQuery = query;
    if (throwFlatPage) throw StateError('Unexpected page error');
    if (flatPageError case final error?) return Left(error);
    if (deferredFlatPage case final deferred?) return deferred.future;
    page++;
    if (query.parentTaskId case final parentTaskId?) {
      subtaskPage++;
      return Right(
        CursorPageResponse(
          items: subtaskPage == 1
              ? [
                  _task('subtask-1').copyWith(parentTaskId: parentTaskId),
                ]
              : [
                  _task('subtask-1').copyWith(parentTaskId: parentTaskId),
                  _task('subtask-2').copyWith(parentTaskId: parentTaskId),
                ],
          nextCursor: subtaskPage == 1 ? 'cursor-2' : null,
        ),
      );
    }
    return Right(
      CursorPageResponse(
        items: page == 1
            ? [
                _task('task-1').copyWith(
                  subtaskCount: rootSubtaskCount,
                  customFields: taskCustomFields,
                  recurrence: rootRecurrence,
                ),
              ]
            : [
                _task('task-1').copyWith(
                  subtaskCount: rootSubtaskCount,
                  customFields: taskCustomFields,
                ),
                _task('task-2'),
              ],
        nextCursor: page == 1 ? 'cursor-2' : null,
      ),
    );
  }

  @override
  Future<Either<ApiError, ProjectTaskGroupedListResponse>>
  listProjectTaskGroups({
    required String workspaceId,
    required String projectId,
    ProjectTasksGroupedQuery query = const ProjectTasksGroupedQuery(),
  }) async {
    groupedCalls++;
    lastGroupedQuery = query;
    if (groupedListError case final error?) return Left(error);
    final isNextPage = query.groupKey != null;
    final deferredPage = deferredNextGroupPage;
    if (isNextPage && deferredPage != null) {
      return deferredPage.future;
    }
    if (useCustomStatusGroups) {
      return Right(
        ProjectTaskGroupedListResponse(
          totalCount: 1,
          groupBy: TaskSavedViewGroupBy.customStatus,
          groups: [
            ProjectTaskListGroupResponse(
              key: 'custom-status:status-a',
              displayName: 'Analiza',
              color: '#64748B',
              position: 0,
              totalCount: 1,
              items: [_task('task-1').copyWith(customStatusId: 'status-a')],
            ),
            const ProjectTaskListGroupResponse(
              key: 'custom-status:status-b',
              displayName: 'Realizacja',
              color: '#2563EB',
              position: 1,
              totalCount: 0,
              items: [],
            ),
            if (includeUnassignedCustomStatusGroup)
              const ProjectTaskListGroupResponse(
                key: 'custom-status:none',
                displayName: 'Bez własnego statusu',
                color: '#94A3B8',
                position: 2,
                totalCount: 0,
                items: [],
              ),
          ],
        ),
      );
    }
    return Right(
      ProjectTaskGroupedListResponse(
        totalCount: 2,
        groupBy: TaskSavedViewGroupBy.status,
        groups: [
          ProjectTaskListGroupResponse(
            key: 'status:Todo',
            displayName: 'Do zrobienia',
            color: '#2563EB',
            position: 0,
            totalCount: 2,
            items: isNextPage
                ? [_task('task-2')]
                : [
                    _task('task-1').copyWith(
                      subtaskCount: rootSubtaskCount,
                      customFields: taskCustomFields,
                      recurrence: rootRecurrence,
                      isPinned: rootIsPinned,
                      watcherCount: rootWatcherCount,
                      isWatchedByMe: rootIsWatchedByMe,
                    ),
                  ],
            nextCursor: isNextPage ? null : 'cursor-2',
          ),
          if (includeBlockedGroup)
            ProjectTaskListGroupResponse(
              key: 'status:Blocked',
              displayName: 'Zablokowane',
              color: '#DC2626',
              position: 1,
              totalCount: includeBlockedTask ? 1 : 0,
              items: includeBlockedTask
                  ? [
                      _task('blocked-1')
                          .copyWith(status: ProjectTaskStatus.blocked),
                    ]
                  : const [],
            ),
        ],
      ),
    );
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  quickCreateTask({
    required String workspaceId,
    required String projectId,
    required QuickCreateProjectTaskPayload payload,
  }) async {
    createPayload = payload;
    if (failCreate) {
      return const Left(
        ApiError(
          type: ApiErrorType.validation,
          message: 'Nie można utworzyć podzadania.',
        ),
      );
    }
    final response =
        _taskResponse(
          id: 'created-subtask',
          title: payload.title,
          parentTaskId: payload.parentTaskId,
        ).copyWith(
          status: payload.customStatusId == null
              ? payload.targetStatus ?? ProjectTaskStatus.todo
              : ProjectTaskStatus.inProgress,
          customStatusId: payload.customStatusId,
        );
    return Right(
      TaskMutationResponse(
        taskId: response.id,
        taskVersion: response.version,
        taskUpdatedAtUtc: response.updatedAtUtc,
        data: response,
      ),
    );
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskListItemResponse>>>
  updateListItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required UpdateTaskListItemPayload payload,
  }) async {
    updateListItemPayload = payload;
    updateListItemPayloads.add(payload);
    if (updateListItemError case final error?) return Left(error);
    final task = _task(taskId).copyWith(
      title: payload.title ?? 'Zadanie $taskId',
      status: payload.status ?? ProjectTaskStatus.todo,
      priority: payload.priority ?? TaskPriority.normal,
      version: payload.expectedVersion + 1,
    );
    return Right(
      TaskMutationResponse(
        taskId: task.id,
        taskVersion: task.version,
        taskUpdatedAtUtc: task.updatedAtUtc,
        data: task,
      ),
    );
  }

  @override
  Future<Either<ApiError, MovedProjectTaskResponse>> moveTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required MoveProjectTaskPayload payload,
  }) async {
    movePayload = payload;
    return Right(
      MovedProjectTaskResponse(
        taskId: taskId,
        parentTaskId: payload.parentTaskId,
        status: payload.status ?? ProjectTaskStatus.todo,
        position: 1000,
        version: payload.expectedVersion + 1,
        updatedAtUtc: DateTime.utc(2026, 1, 2),
        customStatusId: payload.customStatusId,
      ),
    );
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  archiveTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  }) async {
    archiveCalls++;
    final task = _taskResponse(id: taskId, title: 'Zadanie $taskId');
    return Right(
      TaskMutationResponse(
        taskId: taskId,
        taskVersion: expectedVersion + 1,
        taskUpdatedAtUtc: DateTime.utc(2026, 1, 2),
        data: task,
      ),
    );
  }

  @override
  Future<Either<ApiError, TaskSelectionTokenResponse>>
  createTaskSelectionToken({
    required String workspaceId,
    required String projectId,
    required CreateTaskSelectionTokenPayload payload,
  }) async {
    selectionTokenPayload = payload;
    if (selectionTokenError case final error?) return Left(error);
    if (deferredSelectionToken case final pending?) return pending.future;
    return Right(
      TaskSelectionTokenResponse(
        token: 'selection-token',
        totalCount: 5000,
        expiresAtUtc: DateTime.utc(2026, 1, 1, 0, 10),
      ),
    );
  }

  @override
  Future<Either<ApiError, BulkUpdateTaskSelectionResponse>>
  bulkUpdateTaskSelection({
    required String workspaceId,
    required String projectId,
    required BulkUpdateTaskSelectionPayload payload,
  }) async {
    bulkSelectionPayload = payload;
    bulkCalls++;
    if (bulkError case final error?) return Left(error);
    if (deferredBulk case final pending?) return pending.future;
    return Right(
      BulkUpdateTaskSelectionResponse(
        updatedCount: payload.tasks?.length ?? 5000,
        updatedTasks: [
          for (final taskId in payload.returnTaskIds)
            BulkUpdatedTaskVersionResponse(
              taskId: taskId,
              version: _task(taskId).version + 1,
              updatedAtUtc: DateTime.utc(2026, 1, 4),
            ),
        ],
      ),
    );
  }

  @override
  Future<Either<ApiError, ProjectTaskDetailsResponse>> getTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async {
    taskDetailsCalls++;
    final task =
        realtimeTask ?? _taskResponse(id: taskId, title: 'Zadanie $taskId');
    return Right(
      ProjectTaskDetailsResponse(
        task: task,
        labels: const [],
        customFields: const [],
        acceptanceCriteria: const [],
        dependencies: const [],
        watchers: const [],
        isWatchedByMe: false,
        isPinnedByMe: false,
        subtasks: const [],
        workflow: const ProjectTaskWorkflowResponse(
          statuses: [],
          transitions: [],
          version: 1,
        ),
        includedUsers: const [],
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _TaskMetadataRepository extends Mock
    implements TaskMetadataRepository {}

final class _TaskCollaborationRepository extends Mock
    implements TaskCollaborationRepository {}

final class _TaskRecurrenceRepository implements TaskRecurrenceRepository {
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? pauseResult;
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? resumeResult;
  int? pauseVersion;
  int? resumeVersion;

  @override
  Future<Either<ApiError, List<String>>> listSupportedTimeZones({
    required String workspaceId,
    required String projectId,
  }) async => const Right([]);

  @override
  Future<Either<ApiError, TaskRecurrenceResponse>> get({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  create({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskRecurrencePayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  update({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required UpdateTaskRecurrencePayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>> pause({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  }) async {
    pauseVersion = expectedVersion;
    return pauseResult!;
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  resume({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  }) async {
    resumeVersion = expectedVersion;
    return resumeResult!;
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<bool>>> delete({
    required String workspaceId,
    required String projectId,
    required String taskId,
    int? expectedVersion,
  }) async => right(
    TaskMutationResponse(
      taskId: taskId,
      taskVersion: 1,
      taskUpdatedAtUtc: DateTime.utc(2026),
      data: true,
    ),
  );

  @override
  Future<Either<ApiError, List<ProjectTaskRecurrenceItemResponse>>>
  getProjectRecurrences({
    required String workspaceId,
    required String projectId,
  }) async => const Right([]);

  @override
  Future<Either<ApiError, List<ProjectTaskRecurrenceRunResponse>>>
  getProjectRecurrenceRuns({
    required String workspaceId,
    required String projectId,
  }) async => const Right([]);

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  triggerRunNow({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) => throw UnimplementedError();
}

final class _ReplaceTaskCustomFieldValuesPayloadFake extends Fake
    implements ReplaceTaskCustomFieldValuesPayload {}

final class _ReplaceTaskLabelsPayloadFake extends Fake
    implements ReplaceTaskLabelsPayload {}

ProjectTaskListItemResponse _task(String id) => ProjectTaskListItemResponse(
  id: id,
  number: 1,
  key: 'TASK-$id',
  title: 'Zadanie $id',
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.normal,
  assignees: const [],
  checklistCompletedCount: 0,
  checklistTotalCount: 0,
  updatedAtUtc: DateTime.utc(2026),
  version: 1,
);

ProjectTaskResponse _taskResponse({
  required String id,
  required String title,
  String? parentTaskId,
}) => ProjectTaskResponse(
  id: id,
  number: 1,
  key: 'TASK-$id',
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  parentTaskId: parentTaskId,
  title: title,
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.normal,
  taskType: 'Task',
  position: 1000,
  createdByUserId: 'user-1',
  assignees: const [],
  checklistItems: const [],
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  version: 1,
);

TaskRecurrenceResponse _recurrence({bool isActive = true, int version = 3}) =>
    TaskRecurrenceResponse(
      id: 'recurrence-1',
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      sourceTaskId: 'task-1',
      mode: TaskRecurrenceMode.scheduled,
      frequency: TaskRecurrenceFrequency.weekly,
      interval: 2,
      timeZoneId: 'Europe/Warsaw',
      occurrenceStatus: ProjectTaskStatus.todo,
      skipIfPreviousOpen: true,
      isActive: isActive,
      createdAtUtc: DateTime.utc(2026, 8, 31),
      updatedAtUtc: DateTime.utc(2026, 8, 31),
      version: version,
    );

TaskRecurrenceSummaryResponse _recurrenceSummary({
  bool isActive = true,
  int version = 3,
}) => TaskRecurrenceSummaryResponse(
  id: 'recurrence-1',
  sourceTaskId: 'task-1',
  mode: TaskRecurrenceMode.scheduled,
  frequency: TaskRecurrenceFrequency.weekly,
  interval: 2,
  timeZoneId: 'Europe/Warsaw',
  occurrenceStatus: ProjectTaskStatus.todo,
  skipIfPreviousOpen: true,
  isActive: isActive,
  isSourceTask: true,
  version: version,
);

void main() {
  late _TasksRepository repository;
  late _TaskRecurrenceRepository recurrenceRepository;
  late ProjectTasksListCubit cubit;

  setUpAll(() {
    registerFallbackValue(_ReplaceTaskCustomFieldValuesPayloadFake());
    registerFallbackValue(_ReplaceTaskLabelsPayloadFake());
  });

  setUp(() {
    repository = _TasksRepository();
    recurrenceRepository = _TaskRecurrenceRepository();
    cubit = ProjectTasksListCubit(
      repository: repository,
      recurrenceRepository: recurrenceRepository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      calendarTimeZoneId: 'Europe/Warsaw',
    );
  });
  tearDown(() => cubit.close());

  test('bulk failure keeps selection, shows pending and supports explicit same-command retry', () async {
    await cubit.load();
    final task = (cubit.state as ProjectTasksListReady).tasks.single;
    cubit.toggleSelection(task.id);
    final pending =
        Completer<Either<ApiError, BulkUpdateTaskSelectionResponse>>();
    repository.deferredBulk = pending;
    final due = DateTime.utc(2026, 10, 9, 8, 15, 4, 123, 456);
    final operation = cubit.bulkUpdateSelected(dueAtUtc: due);
    expect((cubit.state as ProjectTasksListReady).isBulkSaving, isTrue);
    cubit.clearSelection();
    expect((cubit.state as ProjectTasksListReady).selectedTaskIds, {task.id});
    expect(await cubit.bulkUpdateSelected(archive: true), 0);
    pending.complete(
      const Left(
        ApiError(
          type: ApiErrorType.validation,
          statusCode: 400,
          message: 'Termin nie może poprzedzać rozpoczęcia.',
        ),
      ),
    );
    expect(await operation, 0);
    final failed = cubit.state as ProjectTasksListReady;
    expect(failed.isBulkSaving, isFalse);
    expect(failed.bulkError?.statusCode, 400);
    expect(failed.selectedTaskIds, {task.id});
    expect(
      failed.taskErrorsByTaskId[task.id],
      'Termin nie może poprzedzać rozpoczęcia.',
    );
    repository.deferredBulk = null;
    expect(await cubit.retryBulkOperation(), 1);
    expect(repository.bulkCalls, 2);
    expect(repository.bulkSelectionPayload?.dueAtUtc, due);
    expect((cubit.state as ProjectTasksListReady).selectedTaskIds, isEmpty);
    expect((cubit.state as ProjectTasksListReady).bulkError, isNull);
  });

  for (final type in [
    ApiErrorType.unauthorized,
    ApiErrorType.forbidden,
    ApiErrorType.notFound,
  ]) {
    test('bulk $type never offers or executes retry', () async {
      await cubit.load();
      cubit.toggleSelection(
        (cubit.state as ProjectTasksListReady).tasks.single.id,
      );
      repository.bulkError = ApiError(
        type: type,
        message: 'Access unavailable',
      );
      expect(await cubit.bulkUpdateSelected(archive: true), 0);
      expect((cubit.state as ProjectTasksListReady).canRetryBulk, isFalse);
      expect(await cubit.retryBulkOperation(), 0);
      expect(repository.bulkCalls, 1);
    });
  }

  test(
    'failed scope preparation discards the previous retry command',
    () async {
      await cubit.load();
      cubit.toggleSelection(
        (cubit.state as ProjectTasksListReady).tasks.single.id,
      );
      repository.bulkError = const ApiError(
        type: ApiErrorType.server,
        message: 'Temporary',
      );
      await cubit.bulkUpdateSelected(archive: true);
      expect((cubit.state as ProjectTasksListReady).canRetryBulk, isTrue);
      repository.selectionTokenError = const ApiError(
        type: ApiErrorType.forbidden,
        message: 'Access unavailable',
      );
      expect(await cubit.prepareBulkSelection(), isNull);
      expect((cubit.state as ProjectTasksListReady).canRetryBulk, isFalse);
      expect(await cubit.retryBulkOperation(), 0);
      expect(repository.bulkCalls, 1);
    },
  );

  test(
    'preparing a scope without confirming preserves validation and retry',
    () async {
      await cubit.load();
      final task = (cubit.state as ProjectTasksListReady).tasks.single;
      cubit.toggleSelection(task.id);
      repository.bulkError = const ApiError(
        type: ApiErrorType.validation,
        statusCode: 400,
        message: 'Due date precedes start',
      );
      await cubit.bulkUpdateSelected(clearDueAtUtc: true);
      final failed = cubit.state as ProjectTasksListReady;
      expect(failed.canRetryBulk, isTrue);

      // The caller can cancel its confirmation after receiving this token.
      expect(await cubit.prepareBulkSelection(), isNotNull);
      final prepared = cubit.state as ProjectTasksListReady;
      expect(prepared.bulkError, failed.bulkError);
      expect(prepared.selectedTaskIds, failed.selectedTaskIds);
      expect(prepared.canRetryBulk, isTrue);
      expect(prepared.isBulkSaving, isFalse);
      expect(repository.bulkCalls, 1);
      await cubit.retryBulkOperation();
      expect(repository.bulkCalls, 2);
      expect(repository.bulkSelectionPayload?.clearDueAtUtc, isTrue);
    },
  );

  test(
    'stale scope preparation releases its busy marker after failed filter read',
    () async {
      await cubit.load();
      final pending = Completer<Either<ApiError, TaskSelectionTokenResponse>>();
      repository.deferredSelectionToken = pending;
      final preparation = cubit.prepareBulkSelection();
      expect((cubit.state as ProjectTasksListReady).isBulkSaving, isTrue);
      repository.groupedListError = const ApiError(
        type: ApiErrorType.server,
        message: 'Filter read failed',
      );
      await cubit.load(status: ProjectTaskStatus.done);
      pending.complete(
        const Left(
          ApiError(type: ApiErrorType.server, message: 'Old token failed'),
        ),
      );
      expect(await preparation, isNull);
      final current = cubit.state as ProjectTasksListReady;
      expect(current.isBulkSaving, isFalse);
      expect(current.bulkPreparationOwner, isNull);
      expect(current.filterError, 'Filter read failed');
      expect(current.bulkError, isNull);
    },
  );

  test('stale scope cleanup does not unlock a newer actual mutation', () async {
    await cubit.load();
    final pending = Completer<Either<ApiError, TaskSelectionTokenResponse>>();
    repository.deferredSelectionToken = pending;
    final preparation = cubit.prepareBulkSelection();
    await cubit.load(status: ProjectTaskStatus.todo);
    final current = cubit.state as ProjectTasksListReady;
    cubit.toggleSelection(current.tasks.single.id);
    final mutation =
        Completer<Either<ApiError, BulkUpdateTaskSelectionResponse>>();
    repository.deferredBulk = mutation;
    final save = cubit.bulkUpdateSelected(clearDueAtUtc: true);
    expect((cubit.state as ProjectTasksListReady).isBulkSaving, isTrue);
    pending.complete(
      const Left(
        ApiError(type: ApiErrorType.server, message: 'Old token failed'),
      ),
    );
    expect(await preparation, isNull);
    expect((cubit.state as ProjectTasksListReady).isBulkSaving, isTrue);
    expect((cubit.state as ProjectTasksListReady).bulkPreparationOwner, isNull);
    mutation.complete(
      const Left(
        ApiError(type: ApiErrorType.validation, message: 'New save rejected'),
      ),
    );
    await save;
    expect((cubit.state as ProjectTasksListReady).isBulkSaving, isFalse);
    expect(
      (cubit.state as ProjectTasksListReady).bulkError?.message,
      'New save rejected',
    );
  });

  test('all inline item operations are blocked during atomic bulk', () async {
    final collaboration = _TaskCollaborationRepository();
    final metadata = _TaskMetadataRepository();
    final guarded = ProjectTasksListCubit(
      repository: repository,
      collaborationRepository: collaboration,
      metadataRepository: metadata,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    addTearDown(guarded.close);
    await guarded.load();
    final task = (guarded.state as ProjectTasksListReady).tasks.single;
    guarded.toggleSelection(task.id);
    final pending =
        Completer<Either<ApiError, BulkUpdateTaskSelectionResponse>>();
    repository.deferredBulk = pending;
    final bulk = guarded.bulkUpdateSelected(archive: true);
    expect(await guarded.archiveLoadedTask(task), isFalse);
    expect(
      await guarded.replaceAssigneesForLoadedTask(task, ['user']),
      isFalse,
    );
    expect(await guarded.setPinnedForLoadedTask(task, true), isFalse);
    expect(await guarded.toggleWatchingForLoadedTask(task), isFalse);
    expect(await guarded.replaceLabelsForLoadedTask(task, ['label']), isFalse);
    expect(repository.archiveCalls, 0);
    verifyZeroInteractions(collaboration);
    verifyZeroInteractions(metadata);
    pending.complete(
      const Left(ApiError(type: ApiErrorType.validation, message: 'Rejected')),
    );
    expect(await bulk, 0);
  });

  test('entire result prepares count without a mutation; confirmed token matches scope revision', () async {
    await cubit.load();
    final token = await cubit.prepareBulkSelection();
    expect(token?.totalCount, 5000);
    expect(repository.bulkCalls, 0);
    // Fixture token wygasł; nie wolno wysłać mutacji starym potwierdzeniem.
    expect(
      await cubit.bulkUpdateEntireResult(
        preparedSelection: token,
        archive: true,
      ),
      0,
    );
    expect(repository.bulkCalls, 0);
  });

  test(
    'flat UI grouping accepts backend None-to-Status normalization',
    () async {
      final flat = ProjectTasksListCubit(
        repository: repository,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        groupBy: TaskSavedViewGroupBy.none,
      );
      addTearDown(flat.close);
      await flat.load();
      await flat.loadMoreGroup('status:Todo');
      expect(
        (flat.state as ProjectTasksListReady).tasks.map((task) => task.id),
        ['task-1', 'task-2'],
      );
      expect((flat.state as ProjectTasksListReady).groupLoadErrors, isEmpty);
    },
  );

  test(
    'closed pagination and forbidden group retry send no additional GET',
    () async {
      await cubit.load();
      repository.groupedListError = const ApiError(
        type: ApiErrorType.forbidden,
        message: 'No access',
      );
      await cubit.loadMoreGroup('status:Todo');
      expect(repository.groupedCalls, 2);
      await cubit.loadMoreGroup('status:Todo');
      expect(repository.groupedCalls, 2);
      await cubit.close();
      await cubit.loadMoreGroup('status:Todo');
      await cubit.loadMore(retry: true);
      expect(repository.groupedCalls, 2);
    },
  );

  test('group page failure preserves cursor and data with local loading and explicit retry', () async {
    await cubit.load();
    final initial = cubit.state as ProjectTasksListReady;
    repository.groupedListError = const ApiError(
      type: ApiErrorType.server,
      message: 'Temporary read failure',
    );
    final request = cubit.loadMoreGroup('status:Todo');
    expect((cubit.state as ProjectTasksListReady).loadingGroupKeys, {
      'status:Todo',
    });
    await request;
    final failed = cubit.state as ProjectTasksListReady;
    expect(failed.tasks, initial.tasks);
    expect(failed.groups.single.nextCursor, 'cursor-2');
    expect(failed.loadingGroupKeys, isEmpty);
    expect(
      failed.groupLoadErrors['status:Todo']?.message,
      'Temporary read failure',
    );
    repository.groupedListError = null;
    await cubit.loadMoreGroup('status:Todo');
    final retried = cubit.state as ProjectTasksListReady;
    expect(retried.tasks.map((task) => task.id), ['task-1', 'task-2']);
    expect(retried.groupLoadErrors, isEmpty);
  });

  test('old group epoch cannot append or clear loading in a new same-key filtered request', () async {
    await cubit.load();
    final oldPage =
        Completer<Either<ApiError, ProjectTaskGroupedListResponse>>();
    repository.deferredNextGroupPage = oldPage;
    final oldRequest = cubit.loadMoreGroup('status:Todo');
    await cubit.load(status: ProjectTaskStatus.blocked);
    final newPage =
        Completer<Either<ApiError, ProjectTaskGroupedListResponse>>();
    repository.deferredNextGroupPage = newPage;
    final newRequest = cubit.loadMoreGroup('status:Todo');
    ProjectTaskGroupedListResponse response(String id) =>
        ProjectTaskGroupedListResponse(
          totalCount: 2,
          groupBy: TaskSavedViewGroupBy.status,
          groups: [
            ProjectTaskListGroupResponse(
              key: 'status:Todo',
              displayName: 'Todo',
              color: '#123456',
              position: 0,
              totalCount: 2,
              items: [_task(id)],
            ),
          ],
        );
    oldPage.complete(Right(response('old-filter-task')));
    await oldRequest;
    expect((cubit.state as ProjectTasksListReady).loadingGroupKeys, {
      'status:Todo',
    });
    expect(
      (cubit.state as ProjectTasksListReady).tasks.any(
        (task) => task.id == 'old-filter-task',
      ),
      isFalse,
    );
    newPage.complete(Right(response('new-filter-task')));
    await newRequest;
    final finalState = cubit.state as ProjectTasksListReady;
    expect(finalState.status, ProjectTaskStatus.blocked);
    expect(finalState.tasks.map((task) => task.id), [
      'task-1',
      'new-filter-task',
    ]);
    expect(finalState.loadingGroupKeys, isEmpty);
  });

  test('group page rejects changed task versions and mismatched group without losing data', () async {
    await cubit.load();
    final pending =
        Completer<Either<ApiError, ProjectTaskGroupedListResponse>>();
    repository.deferredNextGroupPage = pending;
    final request = cubit.loadMoreGroup('status:Todo');
    final latest = cubit.state as ProjectTasksListReady;
    final changed = latest.tasks.single.copyWith(version: 7);
    cubit.emit(
      latest.copyWith(
        tasks: [changed],
        groups: [
          latest.groups.single.copyWith(items: [changed]),
        ],
      ),
    );
    pending.complete(
      Right(
        ProjectTaskGroupedListResponse(
          totalCount: 2,
          groupBy: TaskSavedViewGroupBy.status,
          groups: [
            latest.groups.single.copyWith(
              items: [_task('task-2')],
              nextCursor: null,
            ),
          ],
        ),
      ),
    );
    await request;
    final rejected = cubit.state as ProjectTasksListReady;
    expect(rejected.tasks.single.version, 7);
    expect(
      rejected.groupLoadErrors['status:Todo']?.message,
      'tasks.list.page_changed',
    );
    expect(rejected.groups.single.nextCursor, 'cursor-2');
    final wrong = Completer<Either<ApiError, ProjectTaskGroupedListResponse>>();
    repository.deferredNextGroupPage = wrong;
    final retry = cubit.loadMoreGroup('status:Todo');
    wrong.complete(
      Right(
        ProjectTaskGroupedListResponse(
          totalCount: 2,
          groupBy: TaskSavedViewGroupBy.status,
          groups: [
            latest.groups.single.copyWith(
              key: 'wrong-group',
              items: [_task('task-2')],
              nextCursor: null,
            ),
          ],
        ),
      ),
    );
    await retry;
    expect((cubit.state as ProjectTasksListReady).tasks.single.version, 7);
    expect(
      (cubit.state as ProjectTasksListReady)
          .groupLoadErrors['status:Todo']
          ?.message,
      'tasks.list.page_failed',
    );
  });

  test('flat page ignores duplicate scroll, preserves versions and retries only explicitly', () async {
    await cubit.load();
    final initial = cubit.state as ProjectTasksListReady;
    cubit.emit(initial.copyWith(groups: [], nextCursor: 'flat-cursor'));
    final pending =
        Completer<
          Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>
        >();
    repository.deferredFlatPage = pending;
    final request = cubit.loadMore();
    await cubit.loadMore();
    final latest = cubit.state as ProjectTasksListReady;
    cubit.emit(
      latest.copyWith(tasks: [latest.tasks.single.copyWith(version: 8)]),
    );
    pending.complete(
      Right(CursorPageResponse(items: [_task('task-2')])),
    );
    await request;
    expect((cubit.state as ProjectTasksListReady).tasks.single.version, 8);
    expect(
      (cubit.state as ProjectTasksListReady).moreError,
      'tasks.list.page_changed',
    );
    expect((cubit.state as ProjectTasksListReady).isLoadingMore, isFalse);
    repository.deferredFlatPage = null;
    repository.flatPageError = const ApiError(
      type: ApiErrorType.server,
      message: 'Read failure',
    );
    await cubit.loadMore(); // scroll cannot automatically retry a failed page
    expect(
      (cubit.state as ProjectTasksListReady).moreError,
      'tasks.list.page_changed',
    );
    await cubit.loadMore(retry: true);
    expect((cubit.state as ProjectTasksListReady).moreError, 'Read failure');
    repository.flatPageError = null;
    await cubit.loadMore(retry: true);
    expect((cubit.state as ProjectTasksListReady).tasks.single.version, 8);
    expect((cubit.state as ProjectTasksListReady).moreError, isNull);
  });

  test(
    'flat page wrong cursor and exception settle loading and preserve snapshot',
    () async {
      await cubit.load();
      final initial = cubit.state as ProjectTasksListReady;
      cubit.emit(initial.copyWith(groups: [], nextCursor: 'cursor-a'));
      final pending =
          Completer<
            Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>
          >();
      repository.deferredFlatPage = pending;
      final request = cubit.loadMore();
      cubit.emit(
        (cubit.state as ProjectTasksListReady).copyWith(nextCursor: 'cursor-b'),
      );
      pending.complete(
        Right(
          CursorPageResponse(items: [_task('wrong-page')]),
        ),
      );
      await request;
      expect((cubit.state as ProjectTasksListReady).tasks, initial.tasks);
      expect((cubit.state as ProjectTasksListReady).nextCursor, 'cursor-b');
      repository.deferredFlatPage = null;
      repository.throwFlatPage = true;
      await cubit.loadMore();
      expect(
        (cubit.state as ProjectTasksListReady).moreError,
        'tasks.list.page_failed',
      );
      expect((cubit.state as ProjectTasksListReady).isLoadingMore, isFalse);
    },
  );

  test('pauzuje cykliczność bez przeładowania grupy', () async {
    recurrenceRepository.pauseResult = Right(
      TaskMutationResponse(
        taskId: 'task-1',
        taskVersion: 5,
        taskUpdatedAtUtc: DateTime.utc(2026, 8, 31),
        data: _recurrence(isActive: false, version: 4),
      ),
    );
    repository.rootRecurrence = _recurrenceSummary();
    await cubit.load();
    final initial = cubit.state as ProjectTasksListReady;
    final task = initial.tasks.single;

    final saved = await cubit.toggleRecurrence(task);

    final updated = (cubit.state as ProjectTasksListReady).tasks.single;
    expect(saved, isTrue);
    expect(recurrenceRepository.pauseVersion, 3);
    expect(updated.recurrence?.isActive, isFalse);
    expect(updated.recurrence?.version, 4);
    expect(repository.groupedCalls, 1);
  });

  test('przywraca cykliczność po błędzie pauzy', () async {
    recurrenceRepository.pauseResult = const Left(
      ApiError(type: ApiErrorType.conflict, message: 'Wersja jest nieaktualna'),
    );
    repository.rootRecurrence = _recurrenceSummary();
    await cubit.load();
    final task = (cubit.state as ProjectTasksListReady).tasks.single;

    final saved = await cubit.toggleRecurrence(task);

    final state = cubit.state as ProjectTasksListReady;
    expect(saved, isFalse);
    expect(state.tasks.single.recurrence?.isActive, isTrue);
    expect(state.taskErrorsByTaskId['task-1'], 'Wersja jest nieaktualna');
    expect(repository.groupedCalls, 1);
  });

  test('edytor cykliczności podmienia tylko lokalny wiersz', () async {
    await cubit.load();
    final task = (cubit.state as ProjectTasksListReady).tasks.single;
    final recurrence = _recurrence(version: 6).copyWith(
      frequency: TaskRecurrenceFrequency.monthly,
      interval: 3,
    );

    cubit.applyRecurrenceMutation(
      task,
      TaskMutationResponse(
        taskId: task.id,
        taskVersion: task.version + 1,
        taskUpdatedAtUtc: DateTime.utc(2026, 9, 1, 9),
        data: recurrence,
      ),
    );

    final updated = (cubit.state as ProjectTasksListReady).tasks.single;
    expect(updated.version, task.version + 1);
    expect(updated.recurrence?.frequency, TaskRecurrenceFrequency.monthly);
    expect(updated.recurrence?.interval, 3);
    expect(repository.groupedCalls, 1);
  });

  test('doładowuje wyłącznie wskazaną grupę i deduplikuje zadania', () async {
    await cubit.load();
    await cubit.loadMoreGroup('status:Todo');

    final state = cubit.state as ProjectTasksListReady;
    expect(state.tasks.map((task) => task.id), ['task-1', 'task-2']);
    expect(state.groups.single.nextCursor, isNull);
  });

  test('nie wysyła równoległego kursora tej samej grupy', () async {
    await cubit.load();
    final page = Completer<Either<ApiError, ProjectTaskGroupedListResponse>>();
    repository.deferredNextGroupPage = page;

    final first = cubit.loadMoreGroup('status:Todo');
    await Future<void>.delayed(Duration.zero);
    final duplicate = cubit.loadMoreGroup('status:Todo');

    expect(repository.groupedCalls, 2); // pierwszy odczyt + jeden cursor
    page.complete(
      Right(
        ProjectTaskGroupedListResponse(
          totalCount: 2,
          groupBy: TaskSavedViewGroupBy.status,
          groups: [
            ProjectTaskListGroupResponse(
              key: 'status:Todo',
              displayName: 'Do zrobienia',
              color: '#2563EB',
              position: 0,
              totalCount: 2,
              items: [_task('task-2')],
            ),
          ],
        ),
      ),
    );
    await Future.wait([first, duplicate]);

    expect(
      (cubit.state as ProjectTasksListReady).tasks.map((task) => task.id),
      ['task-1', 'task-2'],
    );
  });

  test('przekazuje filtr statusu do nowego odczytu cursorowego', () async {
    await cubit.load(status: ProjectTaskStatus.blocked);

    // Kontraktem transportowym jest wartość enumu z backendu (`Blocked`), a nie
    // dartowa nazwa pola: `.name` wracał tu 400 z bindera Minimal API.
    expect(
      repository.lastGroupedQuery?.status,
      ProjectTaskStatus.blocked.wireValue,
    );
    expect(
      (cubit.state as ProjectTasksListReady).status,
      ProjectTaskStatus.blocked,
    );
  });

  test(
    '403 filtra zachowuje ostatni snapshot i pokazuje błąd przy filtrach',
    () async {
      await cubit.load();
      final before = cubit.state as ProjectTasksListReady;
      repository.groupedListError = const ApiError(
        type: ApiErrorType.forbidden,
        message: 'Brak dostępu do wybranego filtra.',
        statusCode: 403,
      );

      await cubit.load(status: ProjectTaskStatus.blocked);

      final after = cubit.state as ProjectTasksListReady;
      expect(after.tasks, before.tasks);
      expect(after.groups, before.groups);
      expect(after.isRefreshing, isFalse);
      expect(after.filterError, 'Brak dostępu do wybranego filtra.');
      expect(after.status, before.status);
    },
  );

  test('przekazuje i zachowuje filtr osobistych przypięć', () async {
    await cubit.load(pinnedOnly: true);

    expect(repository.lastGroupedQuery?.pinnedOnly, isTrue);
    expect((cubit.state as ProjectTasksListReady).pinnedOnly, isTrue);

    await cubit.loadMoreGroup('status:Todo');

    expect(repository.lastGroupedQuery?.pinnedOnly, isTrue);
  });

  test(
    'przekazuje i zachowuje filtry osoby, udziału oraz nieprzypisanych',
    () async {
      await cubit.load(
        assigneeUserId: 'person-1',
        myInvolvement: TaskInvolvementFilter.collaborator,
      );

      expect(repository.lastGroupedQuery?.assigneeUserId, 'person-1');
      expect(repository.lastGroupedQuery?.myInvolvement, 'Collaborator');
      expect(repository.lastGroupedQuery?.unassignedOnly, isFalse);
      final state = cubit.state as ProjectTasksListReady;
      expect(state.assigneeUserId, 'person-1');
      expect(state.myInvolvement, TaskInvolvementFilter.collaborator);
      expect(state.unassignedOnly, isFalse);

      await cubit.loadMoreGroup('status:Todo');

      expect(repository.lastGroupedQuery?.assigneeUserId, 'person-1');
      expect(repository.lastGroupedQuery?.myInvolvement, 'Collaborator');
      expect(repository.lastGroupedQuery?.unassignedOnly, isFalse);

      await cubit.load(clearAssigneeUserId: true, unassignedOnly: true);

      expect(repository.lastGroupedQuery?.assigneeUserId, isNull);
      expect(repository.lastGroupedQuery?.unassignedOnly, isTrue);
    },
  );

  test('odświeżenie realtime zachowuje aktywne filtry listy', () async {
    await cubit.load(
      status: ProjectTaskStatus.blocked,
      priority: TaskPriority.critical,
    );

    await cubit.refreshFromRealtime();

    // Zapytanie odtwarzane po realtime używa wartości kontraktowych
    // (`Blocked`/`Critical`), a nie dartowych nazw pól.
    expect(
      repository.lastGroupedQuery?.status,
      ProjectTaskStatus.blocked.wireValue,
    );
    expect(
      repository.lastGroupedQuery?.priority,
      TaskPriority.critical.wireValue,
    );
    final state = cubit.state as ProjectTasksListReady;
    expect(state.status, ProjectTaskStatus.blocked);
    expect(state.priority, TaskPriority.critical);
  });

  test(
    'przenosi tylko załadowany wiersz po zmianie statusu realtime',
    () async {
      repository.includeBlockedGroup = true;
      await cubit.load();
      final groupedCallsBeforeRealtime = repository.groupedCalls;

      await cubit.applyRealtimeMutation(
        TaskRealtimeMutation(
          eventId: 'event-1',
          type: TaskRealtimeMutationType.statusChanged,
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          taskId: 'task-1',
          number: 1,
          key: 'TASK-task-1',
          version: 2,
          occurredAtUtc: DateTime.utc(2026, 1, 2),
          status: ProjectTaskStatus.blocked,
          isReplay: false,
        ),
      );

      final state = cubit.state as ProjectTasksListReady;
      expect(repository.groupedCalls, groupedCallsBeforeRealtime);
      expect(state.groups[0].items, isEmpty);
      expect(state.groups[0].totalCount, 1);
      expect(state.groups[1].items.single.status, ProjectTaskStatus.blocked);
      expect(state.groups[1].totalCount, 1);
    },
  );

  test(
    'nie nadpisuje świeżej własnej edycji przez natychmiastowy realtime',
    () async {
      await cubit.load();
      final initial = cubit.state as ProjectTasksListReady;
      final task = initial.tasks.single;
      await cubit.updateListItem(
        task: task,
        payload: UpdateTaskListItemPayload(
          title: 'Moja zmiana',
          expectedVersion: task.version,
        ),
      );
      final groupedCallsBeforeRealtime = repository.groupedCalls;

      await cubit.refreshFromRealtime();

      expect(repository.groupedCalls, groupedCallsBeforeRealtime);
      expect(
        (cubit.state as ProjectTasksListReady).tasks.single.title,
        'Moja zmiana',
      );
    },
  );

  test(
    'dociąga i dopisuje zdalnie utworzone zadanie bez reloadu grup',
    () async {
      await cubit.load();
      repository.realtimeTask = _taskResponse(
        id: 'task-created',
        title: 'Zadanie z drugiej sesji',
      ).copyWith(version: 2);
      final groupedCallsBeforeRealtime = repository.groupedCalls;

      await cubit.applyRealtimeMutation(
        TaskRealtimeMutation(
          eventId: 'created-event',
          type: TaskRealtimeMutationType.created,
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          taskId: 'task-created',
          number: 2,
          key: 'TASK-task-created',
          version: 2,
          occurredAtUtc: DateTime.utc(2026, 9),
          isReplay: false,
        ),
      );

      final state = cubit.state as ProjectTasksListReady;
      expect(repository.groupedCalls, groupedCallsBeforeRealtime);
      expect(repository.taskDetailsCalls, 1);
      expect(state.tasks.map((task) => task.id), contains('task-created'));
      expect(
        state.tasks.singleWhere((task) => task.id == 'task-created').title,
        'Zadanie z drugiej sesji',
      );
    },
  );

  test('dopisuje zdalnie utworzone podzadanie do rozwiniętej gałęzi', () async {
    repository.rootSubtaskCount = 1;
    await cubit.load();
    final parent = (cubit.state as ProjectTasksListReady).tasks.single;
    await cubit.toggleSubtasks(parent);
    repository.realtimeTask = _taskResponse(
      id: 'subtask-created',
      title: 'Podzadanie z drugiej sesji',
      parentTaskId: parent.id,
    ).copyWith(version: 2);
    final groupedCallsBeforeRealtime = repository.groupedCalls;

    await cubit.applyRealtimeMutation(
      TaskRealtimeMutation(
        eventId: 'subtask-created-event',
        type: TaskRealtimeMutationType.created,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'subtask-created',
        number: 3,
        key: 'TASK-subtask-created',
        version: 2,
        occurredAtUtc: DateTime.utc(2026, 9),
        isReplay: false,
      ),
    );

    final state = cubit.state as ProjectTasksListReady;
    expect(repository.groupedCalls, groupedCallsBeforeRealtime);
    expect(
      state.subtasksByParentId[parent.id]!.map((task) => task.id),
      contains('subtask-created'),
    );
    expect(state.tasks.single.subtaskCount, 2);
  });

  test('nie dopisuje zdalnego podzadania poza aktywnym filtrem', () async {
    repository.rootSubtaskCount = 1;
    await cubit.load(priority: TaskPriority.normal);
    final parent = (cubit.state as ProjectTasksListReady).tasks.single;
    await cubit.toggleSubtasks(parent);
    repository.realtimeTask = _taskResponse(
      id: 'subtask-critical',
      title: 'Podzadanie poza filtrem',
      parentTaskId: parent.id,
    ).copyWith(priority: TaskPriority.critical, version: 2);

    await cubit.applyRealtimeMutation(
      TaskRealtimeMutation(
        eventId: 'subtask-filtered-event',
        type: TaskRealtimeMutationType.created,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'subtask-critical',
        number: 4,
        key: 'TASK-subtask-critical',
        version: 2,
        occurredAtUtc: DateTime.utc(2026, 9),
        isReplay: false,
      ),
    );

    final state = cubit.state as ProjectTasksListReady;
    expect(
      state.subtasksByParentId[parent.id]!.map((task) => task.id),
      isNot(contains('subtask-critical')),
    );
    expect(state.tasks.single.subtaskCount, 1);
  });

  test(
    'usuwa zarchiwizowany przez inną osobę załadowany wiersz bez reloadu',
    () async {
      await cubit.load();
      final initial = cubit.state as ProjectTasksListReady;
      final task = initial.tasks.single;
      final initialGroupCount = initial.groups.single.totalCount;
      final groupedCallsBeforeRealtime = repository.groupedCalls;

      await cubit.applyRealtimeMutation(
        TaskRealtimeMutation(
          eventId: 'archive-event',
          type: TaskRealtimeMutationType.archived,
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          taskId: task.id,
          number: task.number,
          key: task.key,
          version: task.version + 1,
          occurredAtUtc: DateTime.utc(2026, 9),
          archivedAtUtc: DateTime.utc(2026, 9),
          isReplay: false,
        ),
      );

      final state = cubit.state as ProjectTasksListReady;
      expect(repository.groupedCalls, groupedCallsBeforeRealtime);
      expect(state.tasks, isEmpty);
      expect(state.groups.single.items, isEmpty);
      expect(state.groups.single.totalCount, initialGroupCount - 1);
    },
  );

  test(
    'nie przeładowuje listy po zakończeniu ochrony własnej edycji',
    () async {
      await cubit.load();
      final task = (cubit.state as ProjectTasksListReady).tasks.single;
      await cubit.updateListItem(
        task: task,
        payload: UpdateTaskListItemPayload(
          title: 'Moja zmiana',
          expectedVersion: task.version,
        ),
      );
      final groupedCallsBeforeRealtime = repository.groupedCalls;

      await cubit.refreshFromRealtime();
      expect(repository.groupedCalls, groupedCallsBeforeRealtime);

      await Future<void>.delayed(const Duration(milliseconds: 120));

      expect(repository.groupedCalls, groupedCallsBeforeRealtime);
    },
  );

  test('odświeżenie realtime zachowuje rozwiniętą gałąź drzewa', () async {
    repository.rootSubtaskCount = 1;
    await cubit.load();
    final parent = _task('task-1').copyWith(subtaskCount: 1);
    await cubit.toggleSubtasks(parent);

    await cubit.refreshFromRealtime();

    final state = cubit.state as ProjectTasksListReady;
    expect(state.expandedTaskIds, contains(parent.id));
    expect(state.subtasksByParentId[parent.id], isNotEmpty);
  });

  test('leniwo pobiera i cache’uje podzadania rozwiniętego zadania', () async {
    await cubit.load();
    final parent = _task('task-1').copyWith(subtaskCount: 2);

    await cubit.toggleSubtasks(parent);

    var state = cubit.state as ProjectTasksListReady;
    expect(repository.lastQuery?.parentTaskId, parent.id);
    expect(state.expandedTaskIds, contains(parent.id));
    expect(state.subtasksByParentId[parent.id], isNotEmpty);

    final callsAfterLoad = repository.page;
    await cubit.toggleSubtasks(parent);
    await cubit.toggleSubtasks(parent);

    state = cubit.state as ProjectTasksListReady;
    expect(state.expandedTaskIds, contains(parent.id));
    expect(repository.page, callsAfterLoad);
  });

  test(
    'rozwija pustego rodzica, aby dodać pierwsze podzadanie inline',
    () async {
      await cubit.load();
      final parent = (cubit.state as ProjectTasksListReady).tasks.single;

      await cubit.toggleSubtasks(parent);

      final state = cubit.state as ProjectTasksListReady;
      expect(state.expandedTaskIds, contains(parent.id));
      expect(state.subtasksByParentId[parent.id], isNotNull);
      expect(repository.lastQuery?.parentTaskId, parent.id);
    },
  );

  test(
    'doładowuje kolejną stronę podzadań wyłącznie dla rozwiniętego rodzica',
    () async {
      repository.rootSubtaskCount = 2;
      await cubit.load();
      final parent = (cubit.state as ProjectTasksListReady).tasks.single;

      await cubit.toggleSubtasks(parent);
      await cubit.loadMoreSubtasks(parent);

      final state = cubit.state as ProjectTasksListReady;
      expect(repository.lastQuery?.parentTaskId, parent.id);
      expect(repository.lastQuery?.cursor, 'cursor-2');
      expect(state.subtasksByParentId[parent.id]?.map((task) => task.id), [
        'subtask-1',
        'subtask-2',
      ]);
      expect(state.nextSubtaskCursorByParentId[parent.id], isNull);
    },
  );

  test('tworzy podzadanie i odświeża wyłącznie rozwiniętą gałąź', () async {
    await cubit.load();
    final parent = _task('task-1').copyWith(subtaskCount: 1);
    await cubit.toggleSubtasks(parent);
    final callsBeforeCreate = repository.page;

    final created = await cubit.createSubtask(
      parent: parent,
      title: '  Nowe podzadanie  ',
    );

    expect(created, isTrue);
    expect(repository.createPayload?.parentTaskId, parent.id);
    expect(repository.createPayload?.title, 'Nowe podzadanie');
    expect(repository.createPayload?.targetStatus, ProjectTaskStatus.todo);
    expect(repository.page, callsBeforeCreate + 1);
    final state = cubit.state as ProjectTasksListReady;
    expect(state.expandedTaskIds, contains(parent.id));
  });

  test('zachowuje błąd tworzenia przy konkretnej gałęzi podzadań', () async {
    repository.failCreate = true;
    await cubit.load();
    final parent = (cubit.state as ProjectTasksListReady).tasks.single;
    await cubit.toggleSubtasks(parent);

    final created = await cubit.createSubtask(
      parent: parent,
      title: 'Nieudane podzadanie',
    );

    expect(created, isFalse);
    expect(
      (cubit.state as ProjectTasksListReady).subtaskErrorsByParentId[parent.id],
      'Nie można utworzyć podzadania.',
    );
  });

  test('tworzy zadanie główne lokalnie bez przeładowania listy', () async {
    repository.includeBlockedGroup = true;
    await cubit.load();
    final callsBeforeCreate = repository.groupedCalls;

    final created = await cubit.createRootTask(
      title: '  Zadanie do zablokowanej grupy  ',
      status: ProjectTaskStatus.blocked,
    );

    expect(created, isTrue);
    expect(repository.createPayload?.title, 'Zadanie do zablokowanej grupy');
    expect(repository.createPayload?.parentTaskId, isNull);
    expect(repository.createPayload?.targetStatus, ProjectTaskStatus.blocked);
    expect(repository.groupedCalls, callsBeforeCreate);
    final state = cubit.state as ProjectTasksListReady;
    final blocked = state.groups.singleWhere(
      (group) => group.key == 'status:Blocked',
    );
    expect(blocked.totalCount, 1);
    expect(blocked.items.single.id, 'created-subtask');
    expect(state.tasks.map((task) => task.id), ['task-1', 'created-subtask']);
  });

  test(
    'nie dopisuje lokalnie nowego taska poza aktywnym filtrem priorytetu',
    () async {
      await cubit.load(priority: TaskPriority.high);
      final callsBeforeCreate = repository.groupedCalls;

      final created = await cubit.createRootTask(
        title: 'Normalny task poza filtrem',
        status: ProjectTaskStatus.todo,
      );

      expect(created, isTrue);
      expect(repository.groupedCalls, callsBeforeCreate);
      final state = cubit.state as ProjectTasksListReady;
      expect(state.tasks.map((task) => task.id), ['task-1']);
      expect(state.groups.single.totalCount, 2);
    },
  );

  test('tworzy task w wskazanej własnej kolumnie workflow lokalnie', () async {
    repository.useCustomStatusGroups = true;
    final customCubit = ProjectTasksListCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      groupBy: TaskSavedViewGroupBy.customStatus,
    );
    addTearDown(customCubit.close);
    await customCubit.load();

    final created = await customCubit.createRootTask(
      title: 'Task w realizacji',
      status: ProjectTaskStatus.todo,
      customStatusId: 'status-a',
    );

    expect(created, isTrue);
    expect(repository.createPayload?.customStatusId, 'status-a');
    expect(repository.createPayload?.targetStatus, isNull);
    final state = customCubit.state as ProjectTasksListReady;
    final group = state.groups.singleWhere(
      (item) => item.key == 'custom-status:status-a',
    );
    expect(group.items.map((item) => item.id), ['task-1', 'created-subtask']);
    expect(group.totalCount, 2);
  });

  test(
    'zapisuje lekką edycję komórki z wersją optimistic concurrency',
    () async {
      await cubit.load();
      final task = (cubit.state as ProjectTasksListReady).tasks.single;

      final saved = await cubit.updateListItem(
        task: task,
        payload: UpdateTaskListItemPayload(
          title: 'Nowa nazwa',
          priority: TaskPriority.high,
          expectedVersion: task.version,
        ),
      );

      expect(saved, isTrue);
      expect(repository.updateListItemPayload?.expectedVersion, task.version);
      final updated = (cubit.state as ProjectTasksListReady).tasks.single;
      expect(updated.title, 'Nowa nazwa');
      expect(updated.priority, TaskPriority.high);
      expect(updated.version, task.version + 1);
    },
  );

  test(
    'zmiana statusu nie gubi przypięcia ani obserwowania z bieżącego wiersza',
    () async {
      repository.rootIsPinned = true;
      repository.rootWatcherCount = 2;
      repository.rootIsWatchedByMe = true;
      await cubit.load();
      final task = (cubit.state as ProjectTasksListReady).tasks.single;

      final saved = await cubit.updateListItem(
        task: task,
        payload: UpdateTaskListItemPayload(
          status: ProjectTaskStatus.inProgress,
          expectedVersion: task.version,
        ),
      );

      expect(saved, isTrue);
      final updated = (cubit.state as ProjectTasksListReady).tasks.single;
      expect(updated.status, ProjectTaskStatus.inProgress);
      expect(updated.isPinned, isTrue);
      expect(updated.watcherCount, 2);
      expect(updated.isWatchedByMe, isTrue);
    },
  );

  test(
    '409 własnej edycji zachowuje wartość lokalną i przypina błąd do wiersza',
    () async {
      repository.updateListItemError = const ApiError(
        type: ApiErrorType.conflict,
        message: 'Konflikt danych na serwerze.',
        statusCode: 409,
      );
      await cubit.load();
      final task = (cubit.state as ProjectTasksListReady).tasks.single;
      final groupedCalls = repository.groupedCalls;

      final saved = await cubit.updateListItem(
        task: task,
        payload: UpdateTaskListItemPayload(
          title: 'Moja lokalna wartość',
          expectedVersion: task.version,
        ),
      );

      expect(saved, isFalse);
      final state = cubit.state as ProjectTasksListReady;
      expect(state.tasks.single.title, 'Moja lokalna wartość');
      expect(state.taskErrorsByTaskId[task.id], contains('inny użytkownik'));
      expect(repository.groupedCalls, groupedCalls);
    },
  );

  test('błąd edycji inline przywraca poprzednią wartość wiersza', () async {
    repository.updateListItemError = const ApiError(
      type: ApiErrorType.server,
      message: 'Serwer odrzucił zmianę tytułu.',
      statusCode: 500,
      traceId: 'trace-inline-1',
    );
    await cubit.load();
    final task = (cubit.state as ProjectTasksListReady).tasks.single;
    final originalTitle = task.title;

    final saved = await cubit.updateListItem(
      task: task,
      payload: UpdateTaskListItemPayload(
        title: 'Wartość, która się nie zapisze',
        expectedVersion: task.version,
      ),
    );

    expect(saved, isFalse);
    final state = cubit.state as ProjectTasksListReady;
    // Rollback: wiersz wraca do wartości sprzed edycji, a przyczynę widać
    // przy tym samym wierszu (komunikat pochodzi z ApiError).
    expect(state.tasks.single.title, originalTitle);
    expect(
      state.taskErrorsByTaskId[task.id],
      'Serwer odrzucił zmianę tytułu.',
    );
  });

  test('kolejkuje dwie szybkie zmiany statusu z kolejną wersją', () async {
    await cubit.load();
    final task = (cubit.state as ProjectTasksListReady).tasks.single;

    final first = cubit.updateListItem(
      task: task,
      payload: UpdateTaskListItemPayload(
        status: ProjectTaskStatus.inProgress,
        expectedVersion: task.version,
      ),
    );
    final second = cubit.updateListItem(
      task: task,
      payload: UpdateTaskListItemPayload(
        status: ProjectTaskStatus.blocked,
        expectedVersion: task.version,
      ),
    );

    expect(await first, isTrue);
    expect(await second, isTrue);
    expect(
      repository.updateListItemPayloads.map((item) => item.expectedVersion),
      [task.version, task.version + 1],
    );
    expect(
      repository.updateListItemPayloads.map((item) => item.status),
      [ProjectTaskStatus.inProgress, ProjectTaskStatus.blocked],
    );
    expect(
      (cubit.state as ProjectTasksListReady).tasks.single.status,
      ProjectTaskStatus.blocked,
    );
  });

  test(
    'ignoruje realtime będący potwierdzonym echem własnej mutacji',
    () async {
      await cubit.load();
      final task = (cubit.state as ProjectTasksListReady).tasks.single;
      await cubit.updateListItem(
        task: task,
        payload: UpdateTaskListItemPayload(
          status: ProjectTaskStatus.inProgress,
          expectedVersion: task.version,
        ),
      );
      final callsBeforeEcho = repository.groupedCalls;

      await cubit.applyRealtimeMutation(
        TaskRealtimeMutation(
          eventId: 'own-status-echo',
          type: TaskRealtimeMutationType.statusChanged,
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          taskId: task.id,
          number: task.number,
          key: task.key,
          version: task.version + 1,
          occurredAtUtc: DateTime.utc(2026, 8, 30),
          status: ProjectTaskStatus.inProgress,
          isReplay: false,
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 2200));

      expect(repository.groupedCalls, callsBeforeEcho);
    },
  );

  test(
    'zapisuje custom field lokalnie bez ponownego pobrania grup',
    () async {
      final metadata = _TaskMetadataRepository();
      repository.taskCustomFields = [
        TaskCustomFieldValueResponse(
          fieldId: 'field-hours',
          value: 3,
          updatedAtUtc: DateTime.utc(2026),
        ),
      ];
      final customCubit = ProjectTasksListCubit(
        repository: repository,
        metadataRepository: metadata,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      addTearDown(customCubit.close);
      await customCubit.load();
      final task = (customCubit.state as ProjectTasksListReady).tasks.single;
      when(
        () => metadata.replaceCustomFieldValues(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          taskId: task.id,
          payload: any(named: 'payload'),
        ),
      ).thenAnswer(
        (_) async => Right(
          TaskMutationResponse<List<TaskCustomFieldValueResponse>>(
            taskId: task.id,
            taskVersion: 2,
            taskUpdatedAtUtc: DateTime.utc(2026, 1, 2),
            data: [
              TaskCustomFieldValueResponse(
                fieldId: 'field-hours',
                value: 5,
                updatedAtUtc: DateTime.utc(2026, 1, 2),
              ),
            ],
          ),
        ),
      );
      final groupedCallsBeforeSave = repository.groupedCalls;

      final saved = await customCubit.updateCustomField(
        task: task,
        fieldId: 'field-hours',
        value: 5,
      );

      expect(saved, isTrue);
      expect(repository.groupedCalls, groupedCallsBeforeSave);
      final updated = (customCubit.state as ProjectTasksListReady)
          .groups
          .single
          .items
          .single;
      expect(updated.customFields.single.value, 5);
      expect(updated.version, 2);
    },
  );

  test(
    'przenosi tylko edytowany wiersz do nowej grupy po inline zmianie statusu',
    () async {
      repository.includeBlockedGroup = true;
      await cubit.load();
      final task = (cubit.state as ProjectTasksListReady).tasks.single;
      final groupedCallsBeforeEdit = repository.groupedCalls;

      final saved = await cubit.updateListItem(
        task: task,
        payload: UpdateTaskListItemPayload(
          status: ProjectTaskStatus.blocked,
          expectedVersion: task.version,
        ),
      );

      expect(saved, isTrue);
      expect(repository.groupedCalls, groupedCallsBeforeEdit);
      final state = cubit.state as ProjectTasksListReady;
      expect(state.groups[0].items, isEmpty);
      expect(state.groups[0].totalCount, 1);
      expect(state.groups[1].items.single.id, task.id);
      expect(state.groups[1].items.single.status, ProjectTaskStatus.blocked);
      expect(state.groups[1].totalCount, 1);
    },
  );

  test(
    'przenosi task optymistycznie do grupy statusu i zapisuje wersję',
    () async {
      await cubit.load();
      final task = (cubit.state as ProjectTasksListReady).tasks.single;

      final moved = await cubit.moveTask(
        task: task,
        targetGroupKey: 'status:Todo',
      );

      expect(moved, isTrue);
      expect(repository.movePayload?.expectedVersion, task.version);
      expect(repository.movePayload?.status, ProjectTaskStatus.todo);
      expect((cubit.state as ProjectTasksListReady).tasks.single.version, 2);
    },
  );

  test(
    'przenosi task do własnej grupy workflow przez customStatusId',
    () async {
      repository.useCustomStatusGroups = true;
      final customCubit = ProjectTasksListCubit(
        repository: repository,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        groupBy: TaskSavedViewGroupBy.customStatus,
      );
      addTearDown(customCubit.close);
      await customCubit.load();
      final task = (customCubit.state as ProjectTasksListReady).tasks.single;

      final moved = await customCubit.moveTask(
        task: task,
        targetGroupKey: 'custom-status:status-b',
      );

      expect(moved, isTrue);
      expect(repository.movePayload?.customStatusId, 'status-b');
      expect(repository.movePayload?.status, isNull);
      final state = customCubit.state as ProjectTasksListReady;
      expect(state.groups[1].items.single.customStatusId, 'status-b');
      expect(state.groups[1].items.single.customStatusName, 'Realizacja');
    },
  );

  test(
    'przeniesienie do grupy bez własnego statusu czyści custom status przez status systemowy',
    () async {
      repository.useCustomStatusGroups = true;
      repository.includeUnassignedCustomStatusGroup = true;
      final customCubit = ProjectTasksListCubit(
        repository: repository,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        groupBy: TaskSavedViewGroupBy.customStatus,
      );
      addTearDown(customCubit.close);
      await customCubit.load();
      final task = (customCubit.state as ProjectTasksListReady).tasks.single;

      final moved = await customCubit.moveTask(
        task: task,
        targetGroupKey: 'custom-status:none',
      );

      expect(moved, isTrue);
      expect(repository.movePayload?.customStatusId, isNull);
      expect(repository.movePayload?.status, ProjectTaskStatus.todo);
      final state = customCubit.state as ProjectTasksListReady;
      expect(state.groups[2].items.single.customStatusId, isNull);
    },
  );

  test('przenosi zadanie do cache podzadań wybranego rodzica', () async {
    await cubit.load();
    await cubit.loadMoreGroup('status:Todo');
    final tasks = (cubit.state as ProjectTasksListReady).tasks;

    final moved = await cubit.moveTask(
      task: tasks[1],
      targetGroupKey: 'status:Todo',
      parentTaskId: tasks.first.id,
    );

    expect(moved, isTrue);
    final state = cubit.state as ProjectTasksListReady;
    expect(state.tasks.map((task) => task.id), ['task-1']);
    expect(state.subtasksByParentId[tasks.first.id]?.single.id, 'task-2');
    expect(
      state.subtasksByParentId[tasks.first.id]?.single.parentTaskId,
      tasks.first.id,
    );
  });

  test('sortuje podzadanie wyłącznie wśród rodzeństwa', () async {
    await cubit.load();
    final parent = (cubit.state as ProjectTasksListReady).tasks.single;
    await cubit.toggleSubtasks(parent);
    await cubit.loadMoreSubtasks(parent);
    final loaded =
        (cubit.state as ProjectTasksListReady).subtasksByParentId[parent.id]!;
    final first = loaded.first.copyWith(parentTaskId: parent.id);
    final second = loaded.last.copyWith(parentTaskId: parent.id);

    final moved = await cubit.moveTask(
      task: second,
      targetGroupKey: 'status:Todo',
      parentTaskId: parent.id,
      nextTaskId: first.id,
    );

    expect(moved, isTrue);
    expect(repository.movePayload?.parentTaskId, parent.id);
    expect(repository.movePayload?.nextTaskId, first.id);
    expect(
      (cubit.state as ProjectTasksListReady).subtasksByParentId[parent.id]?.map(
        (task) => task.id,
      ),
      [second.id, first.id],
    );
  });

  test(
    'zapisuje bulk status przez wersjonowane mutacje zaznaczonych rekordów',
    () async {
      await cubit.load();
      final task = (cubit.state as ProjectTasksListReady).tasks.single;
      cubit.toggleSelection(task.id);

      final updated = await cubit.bulkUpdateSelected(
        status: ProjectTaskStatus.inProgress,
      );

      expect(updated, 1);
      expect(
        repository.bulkSelectionPayload?.status,
        ProjectTaskStatus.inProgress,
      );
      expect(
        repository.bulkSelectionPayload?.tasks?.single.expectedVersion,
        task.version,
      );
      expect(repository.bulkSelectionPayload?.tasks?.single.taskId, task.id);
      expect(repository.updateListItemPayloads, isEmpty);
      expect((cubit.state as ProjectTasksListReady).selectedTaskIds, isEmpty);
    },
  );

  test(
    'archiwum bulk usuwa tylko wybrany załadowany wiersz bez reloadu',
    () async {
      await cubit.load();
      final task = (cubit.state as ProjectTasksListReady).tasks.single;
      cubit.toggleSelection(task.id);
      final groupedCallsBeforeArchive = repository.groupedCalls;

      final updated = await cubit.bulkUpdateSelected(archive: true);

      expect(updated, 1);
      expect(repository.groupedCalls, groupedCallsBeforeArchive);
      final state = cubit.state as ProjectTasksListReady;
      expect(state.tasks, isEmpty);
      expect(state.groups.single.items, isEmpty);
      expect(state.groups.single.totalCount, 1);
      expect(state.selectedTaskIds, isEmpty);
    },
  );

  test(
    'bulk wykonawca podmienia tylko zaznaczony wiersz bez reloadu',
    () async {
      final collaboration = _TaskCollaborationRepository();
      final customCubit = ProjectTasksListCubit(
        repository: repository,
        collaborationRepository: collaboration,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      addTearDown(customCubit.close);
      await customCubit.load();
      final task = (customCubit.state as ProjectTasksListReady).tasks.single;
      customCubit.toggleSelection(task.id);
      const userId = 'user-2';
      when(
        () => collaboration.replaceAssignees(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          taskId: task.id,
          userIds: [userId],
          expectedVersion: task.version,
        ),
      ).thenAnswer(
        (_) async => Right(
          TaskMutationResponse<ProjectTaskResponse>(
            taskId: task.id,
            taskVersion: task.version + 1,
            taskUpdatedAtUtc: DateTime.utc(2026, 1, 2),
            data: _taskResponse(id: task.id, title: task.title).copyWith(
              assignees: [
                TaskAssigneeResponse(
                  userId: userId,
                  isPrimary: true,
                  createdAtUtc: DateTime.utc(2026, 1, 2),
                ),
              ],
            ),
          ),
        ),
      );
      final groupedCallsBeforeSave = repository.groupedCalls;

      final updated = await customCubit.bulkUpdateSelected(
        assigneeIds: [userId],
      );

      expect(updated, 1);
      expect(repository.groupedCalls, groupedCallsBeforeSave);
      final saved = (customCubit.state as ProjectTasksListReady)
          .groups
          .single
          .items
          .single;
      expect(saved.assignees.single.userId, userId);
      expect(saved.version, 2);
    },
  );

  test('przypina tylko lokalny wiersz bez ponownego pobrania grup', () async {
    final collaboration = _TaskCollaborationRepository();
    final customCubit = ProjectTasksListCubit(
      repository: repository,
      collaborationRepository: collaboration,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    addTearDown(customCubit.close);
    await customCubit.load();
    final task = (customCubit.state as ProjectTasksListReady).tasks.single;
    when(
      () => collaboration.updatePinned(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: task.id,
        isPinned: true,
      ),
    ).thenAnswer((_) async => const Right(unit));
    final groupedCallsBeforeSave = repository.groupedCalls;

    final saved = await customCubit.setPinnedForLoadedTask(task, true);

    expect(saved, isTrue);
    expect(repository.groupedCalls, groupedCallsBeforeSave);
    final updated = (customCubit.state as ProjectTasksListReady).tasks.single;
    expect(updated.isPinned, isTrue);
    expect(updated.version, task.version);
  });

  test(
    'obserwowanie podmienia licznik i wersję tylko lokalnego wiersza',
    () async {
      final collaboration = _TaskCollaborationRepository();
      final customCubit = ProjectTasksListCubit(
        repository: repository,
        collaborationRepository: collaboration,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      addTearDown(customCubit.close);
      await customCubit.load();
      final task = (customCubit.state as ProjectTasksListReady).tasks.single;
      when(
        () => collaboration.follow(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          taskId: task.id,
          expectedVersion: task.version,
        ),
      ).thenAnswer(
        (_) async => Right(
          TaskMutationResponse<TaskMutationAcknowledgementResponse>(
            taskId: task.id,
            taskVersion: task.version + 1,
            taskUpdatedAtUtc: DateTime.utc(2026, 1, 3),
            data: const TaskMutationAcknowledgementResponse(changed: true),
          ),
        ),
      );
      final groupedCallsBeforeSave = repository.groupedCalls;

      final saved = await customCubit.toggleWatchingForLoadedTask(task);

      expect(saved, isTrue);
      expect(repository.groupedCalls, groupedCallsBeforeSave);
      final updated = (customCubit.state as ProjectTasksListReady).tasks.single;
      expect(updated.isWatchedByMe, isTrue);
      expect(updated.watcherCount, 1);
      expect(updated.version, task.version + 1);
    },
  );

  test('etykiety podmieniają tylko lokalny wiersz z nową wersją', () async {
    final metadata = _TaskMetadataRepository();
    final customCubit = ProjectTasksListCubit(
      repository: repository,
      metadataRepository: metadata,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    addTearDown(customCubit.close);
    await customCubit.load();
    final task = (customCubit.state as ProjectTasksListReady).tasks.single;
    final label = TaskLabelResponse(
      id: 'label-1',
      name: 'Pilne',
      color: '#EF4444',
      createdAtUtc: DateTime.utc(2026, 1, 3),
    );
    when(
      () => metadata.replaceLabels(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: task.id,
        payload: any(named: 'payload'),
      ),
    ).thenAnswer(
      (_) async => Right(
        TaskMutationResponse<List<TaskLabelResponse>>(
          taskId: task.id,
          taskVersion: task.version + 1,
          taskUpdatedAtUtc: DateTime.utc(2026, 1, 3),
          data: [label],
        ),
      ),
    );
    final groupedCallsBeforeSave = repository.groupedCalls;

    final saved = await customCubit.replaceLabelsForLoadedTask(task, [
      label.id,
    ]);

    expect(saved, isTrue);
    expect(repository.groupedCalls, groupedCallsBeforeSave);
    final captured =
        verify(
              () => metadata.replaceLabels(
                workspaceId: 'workspace-1',
                projectId: 'project-1',
                taskId: task.id,
                payload: captureAny(named: 'payload'),
              ),
            ).captured.single
            as ReplaceTaskLabelsPayload;
    expect(captured.labelIds, [label.id]);
    expect(captured.expectedVersion, task.version);
    final updated = (customCubit.state as ProjectTasksListReady).tasks.single;
    expect(updated.labels, [label]);
    expect(updated.version, task.version + 1);
  });

  test(
    'zaznacza zakres, wszystkie załadowane rekordy i czyści zaznaczenie',
    () async {
      await cubit.load();
      await cubit.loadMoreGroup('status:Todo');

      cubit.toggleSelection('task-1');
      cubit.toggleSelection('task-2', range: true);
      var state = cubit.state as ProjectTasksListReady;
      expect(state.selectedTaskIds, {'task-1', 'task-2'});
      expect(state.selectionAnchorTaskId, 'task-2');

      cubit.clearSelection();
      state = cubit.state as ProjectTasksListReady;
      expect(state.selectedTaskIds, isEmpty);
      expect(state.selectionAnchorTaskId, isNull);

      cubit.selectLoadedTasks();
      state = cubit.state as ProjectTasksListReady;
      expect(state.selectedTaskIds, {'task-1', 'task-2'});
    },
  );

  test('checkbox grupy zaznacza wyłącznie rekordy tej grupy', () async {
    repository
      ..includeBlockedGroup = true
      ..includeBlockedTask = true;
    await cubit.load();

    cubit.setLoadedGroupSelected('status:Todo', selected: true);

    var state = cubit.state as ProjectTasksListReady;
    expect(state.selectedTaskIds, {'task-1'});
    expect(cubit.isLoadedGroupSelected('status:Todo'), isTrue);
    expect(cubit.isLoadedGroupSelected('status:Blocked'), isFalse);

    cubit.setLoadedGroupSelected('status:Blocked', selected: true);
    state = cubit.state as ProjectTasksListReady;
    expect(state.selectedTaskIds, {'task-1', 'blocked-1'});

    cubit.setLoadedGroupSelected('status:Todo', selected: false);
    state = cubit.state as ProjectTasksListReady;
    expect(state.selectedTaskIds, {'blocked-1'});
  });

  test('select-all podzadań działa tylko w obrębie gałęzi', () async {
    repository.rootSubtaskCount = 2;
    await cubit.load();
    final parent = (cubit.state as ProjectTasksListReady).tasks.single;
    await cubit.toggleSubtasks(parent);
    await cubit.loadMoreSubtasks(parent);
    cubit.toggleSelection(parent.id);

    cubit.setLoadedSubtasksSelected(parent.id, selected: true);

    var state = cubit.state as ProjectTasksListReady;
    expect(state.selectedTaskIds, {parent.id, 'subtask-1', 'subtask-2'});
    expect(cubit.areLoadedSubtasksSelected(parent.id), isTrue);

    cubit.setLoadedSubtasksSelected(parent.id, selected: false);
    state = cubit.state as ProjectTasksListReady;
    expect(state.selectedTaskIds, {parent.id});
  });

  test(
    'inline list date captures zone; non-date updates keep legacy omission',
    () async {
      await cubit.load();
      final task = (cubit.state as ProjectTasksListReady).tasks.single;
      final start = DateTime.utc(2026, 10, 27, 8, 23, 4, 123);
      expect(
        await cubit.updateListItem(
          task: task,
          payload: UpdateTaskListItemPayload(
            startAtUtc: start,
            expectedVersion: task.version,
          ),
        ),
        isTrue,
      );
      expect(
        repository.updateListItemPayload!.calendarTimeZoneId,
        'Europe/Warsaw',
      );
      expect(repository.updateListItemPayload!.startAtUtc, start);
      final latest = (cubit.state as ProjectTasksListReady).tasks.single;
      expect(
        await cubit.updateListItem(
          task: latest,
          payload: UpdateTaskListItemPayload(
            priority: TaskPriority.high,
            expectedVersion: latest.version,
          ),
        ),
        isTrue,
      );
      expect(repository.updateListItemPayload!.calendarTimeZoneId, isNull);
    },
  );

  test('entire-result dates capture same zone with token mode', () async {
    await cubit.load();
    final due = DateTime.utc(2026, 10, 27, 8, 23, 4, 123);
    expect(await cubit.bulkUpdateEntireResult(dueAtUtc: due), 5000);
    expect(
      repository.bulkSelectionPayload!.calendarTimeZoneId,
      'Europe/Warsaw',
    );
    expect(repository.bulkSelectionPayload!.dueAtUtc, due);
    expect(repository.bulkSelectionPayload!.tasks, isNull);
    expect(repository.bulkSelectionPayload!.selectionToken, 'selection-token');
  });

  test(
    'entire result blocks selection changes while request is pending',
    () async {
      await cubit.load();
      final task = (cubit.state as ProjectTasksListReady).tasks.single;
      final pending =
          Completer<Either<ApiError, BulkUpdateTaskSelectionResponse>>();
      repository.deferredBulk = pending;
      final bulk = cubit.bulkUpdateEntireResult(priority: TaskPriority.high);
      await Future<void>.delayed(Duration.zero);
      cubit.toggleSelection(task.id);
      pending.complete(
        Right(
          BulkUpdateTaskSelectionResponse(
            updatedCount: 5000,
            updatedTasks: [
              BulkUpdatedTaskVersionResponse(
                taskId: task.id,
                version: task.version + 1,
                updatedAtUtc: DateTime.utc(2026, 10, 27),
              ),
            ],
          ),
        ),
      );
      expect(await bulk, 5000);
      expect((cubit.state as ProjectTasksListReady).selectedTaskIds, isEmpty);
    },
  );

  test(
    'queued successor snapshot and replay survive base bulk response',
    () async {
      await cubit.load();
      final parent = (cubit.state as ProjectTasksListReady).tasks.single;
      await cubit.toggleSubtasks(parent);
      final child = (cubit.state as ProjectTasksListReady)
          .subtasksByParentId[parent.id]!
          .single;
      cubit.toggleSelection(parent.id);
      final pending =
          Completer<Either<ApiError, BulkUpdateTaskSelectionResponse>>();
      repository.deferredBulk = pending;
      final start = DateTime.utc(2026, 10, 27, 8, 23, 4, 123);
      final due = DateTime.utc(2026, 10, 28, 16, 15, 4, 123);
      final bulk = cubit.bulkUpdateSelected(dueAtUtc: start);
      final successor = TaskRealtimeMutation(
        eventId: 'successor',
        type: TaskRealtimeMutationType.updated,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: child.id,
        number: child.number,
        key: child.key,
        version: child.version + 1,
        occurredAtUtc: due,
        isReplay: true,
        startAtUtc: start,
        hasStartAtUtc: true,
        dueAtUtc: due,
        hasDueAtUtc: true,
      );
      await cubit.applyRealtimeMutation(successor);
      pending.complete(
        Right(
          BulkUpdateTaskSelectionResponse(
            updatedCount: 1,
            updatedTasks: [
              BulkUpdatedTaskVersionResponse(
                taskId: parent.id,
                version: parent.version + 1,
                updatedAtUtc: due,
              ),
            ],
          ),
        ),
      );
      expect(await bulk, 1);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await cubit.applyRealtimeMutation(successor);
      final updated = (cubit.state as ProjectTasksListReady)
          .subtasksByParentId[parent.id]!
          .single;
      expect(updated.startAtUtc, start);
      expect(updated.dueAtUtc, due);
      expect(updated.version, child.version + 1);
    },
  );

  test(
    'inline cannot start during atomic bulk and overwrite confirmed dates',
    () async {
      await cubit.load();
      final task = (cubit.state as ProjectTasksListReady).tasks.single;
      cubit.toggleSelection(task.id);
      final pending =
          Completer<Either<ApiError, BulkUpdateTaskSelectionResponse>>();
      repository.deferredBulk = pending;
      final due = DateTime.utc(2026, 10, 27, 8, 23);
      final bulk = cubit.bulkUpdateSelected(dueAtUtc: due);
      expect(
        await cubit.updateListItem(
          task: task,
          payload: UpdateTaskListItemPayload(
            dueAtUtc: DateTime.utc(2026, 10, 26),
            expectedVersion: task.version,
          ),
        ),
        isFalse,
      );
      expect(repository.updateListItemPayloads, isEmpty);
      pending.complete(
        Right(
          BulkUpdateTaskSelectionResponse(
            updatedCount: 1,
            updatedTasks: [
              BulkUpdatedTaskVersionResponse(
                taskId: task.id,
                version: task.version + 1,
                updatedAtUtc: due,
              ),
            ],
          ),
        ),
      );
      expect(await bulk, 1);
      final ready = cubit.state as ProjectTasksListReady;
      expect(ready.tasks.single.dueAtUtc, due);
      expect(ready.tasks.single.version, task.version + 1);
    },
  );

  test(
    '501 selected tasks stay selected and no non-atomic request is sent',
    () async {
      await cubit.load();
      final initial = cubit.state as ProjectTasksListReady;
      final tasks = [for (var i = 0; i < 501; i++) _task('limit-$i')];
      cubit.emit(
        initial.copyWith(
          tasks: tasks,
          groups: [],
          selectedTaskIds: tasks.map((task) => task.id).toSet(),
        ),
      );
      expect(
        await cubit.bulkUpdateSelected(dueAtUtc: DateTime.utc(2026, 10, 27)),
        0,
      );
      expect(repository.bulkCalls, 0);
      expect(repository.updateListItemPayloads, isEmpty);
      expect(
        (cubit.state as ProjectTasksListReady).selectedTaskIds,
        hasLength(501),
      );
      expect(
        (cubit.state as ProjectTasksListReady).bulkError?.message,
        'tasks.bulk.selection_limit',
      );
      expect((cubit.state as ProjectTasksListReady).canRetryBulk, isFalse);
    },
  );

  test(
    'atomic selected dates carry all versions and captured IANA once',
    () async {
      await cubit.load();
      await cubit.loadMoreGroup('status:Todo');
      final tasks = (cubit.state as ProjectTasksListReady).tasks;
      for (final task in tasks) {
        cubit.toggleSelection(task.id);
      }
      final due = DateTime.utc(2026, 10, 27, 8, 23, 4, 123);
      expect(await cubit.bulkUpdateSelected(dueAtUtc: due), tasks.length);
      expect(repository.bulkCalls, 1);
      expect(repository.updateListItemPayloads, isEmpty);
      final payload = repository.bulkSelectionPayload!;
      expect(payload.selectionToken, isEmpty);
      expect(
        payload.tasks!.map((task) => task.taskId),
        tasks.map((task) => task.id),
      );
      expect(
        payload.tasks!.map((task) => task.expectedVersion),
        tasks.map((task) => task.version),
      );
      expect(payload.calendarTimeZoneId, 'Europe/Warsaw');
      expect(payload.dueAtUtc, due);
      expect(
        (cubit.state as ProjectTasksListReady).tasks.every(
          (task) => task.dueAtUtc == due,
        ),
        isTrue,
      );
    },
  );

  test('rejected atomic bulk preserves selection and dates with visible row errors', () async {
    await cubit.load();
    final task = (cubit.state as ProjectTasksListReady).tasks.single;
    cubit.toggleSelection(task.id);
    repository.bulkError = const ApiError(
      type: ApiErrorType.conflict,
      message: 'Zadanie zmieniono.',
    );
    expect(await cubit.bulkUpdateSelected(clearDueAtUtc: true), 0);
    final ready = cubit.state as ProjectTasksListReady;
    expect(ready.selectedTaskIds, {task.id});
    expect(ready.tasks.single.dueAtUtc, task.dueAtUtc);
    expect(ready.taskErrorsByTaskId[task.id], 'Zadanie zmieniono.');
    expect(
      repository.bulkSelectionPayload!.calendarTimeZoneId,
      'Europe/Warsaw',
    );
  });

  test('realtime start updates expanded child; missing preserves and explicit null clears', () async {
    await cubit.load();
    final parent = (cubit.state as ProjectTasksListReady).tasks.single;
    await cubit.toggleSubtasks(parent);
    final initial = (cubit.state as ProjectTasksListReady)
        .subtasksByParentId[parent.id]!
        .single;
    final start = DateTime.utc(2026, 10, 27, 8, 23, 4, 123);
    for (final version in [
      initial.version + 1,
      initial.version + 2,
      initial.version + 3,
    ]) {
      await cubit.applyRealtimeMutation(
        TaskRealtimeMutation(
          eventId: 'event-$version',
          type: TaskRealtimeMutationType.updated,
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          taskId: initial.id,
          number: initial.number,
          key: initial.key,
          version: version,
          occurredAtUtc: DateTime.utc(2026, 10, 28),
          isReplay: false,
          startAtUtc: version == initial.version + 1 ? start : null,
          hasStartAtUtc: version != initial.version + 2,
        ),
      );
      final child = (cubit.state as ProjectTasksListReady)
          .subtasksByParentId[parent.id]!
          .single;
      expect(child.startAtUtc, version == initial.version + 3 ? null : start);
      expect(child.version, version);
    }
  });

  test('zaznacza i mutuje rozwinięte podzadanie przez bulk toolbar', () async {
    await cubit.load();
    final parent = (cubit.state as ProjectTasksListReady).tasks.single;
    await cubit.toggleSubtasks(parent);
    final child = (cubit.state as ProjectTasksListReady)
        .subtasksByParentId[parent.id]!
        .single;

    cubit.toggleSelection(child.id);
    var state = cubit.state as ProjectTasksListReady;
    expect(state.selectedTaskIds, {child.id});

    final updated = await cubit.bulkUpdateSelected(
      status: ProjectTaskStatus.blocked,
    );

    expect(updated, 1);
    state = cubit.state as ProjectTasksListReady;
    expect(
      state.subtasksByParentId[parent.id]!.single.status,
      ProjectTaskStatus.blocked,
    );
    expect(state.selectedTaskIds, isEmpty);
  });

  test(
    'mutuje cały filtrowany wynik przez token bez lokalnej listy ID',
    () async {
      await cubit.load(
        status: ProjectTaskStatus.blocked,
        assigneeUserId: 'member-1',
        myInvolvement: TaskInvolvementFilter.watcher,
        pinnedOnly: true,
      );

      final updated = await cubit.bulkUpdateEntireResult(
        priority: TaskPriority.critical,
      );

      expect(updated, 5000);
      expect(
        repository.selectionTokenPayload?.query.status,
        ProjectTaskStatus.blocked.wireValue,
      );
      expect(
        repository.selectionTokenPayload?.query.assigneeUserId,
        'member-1',
      );
      expect(
        repository.selectionTokenPayload?.query.myInvolvement,
        'Watcher',
      );
      expect(repository.selectionTokenPayload?.query.pinnedOnly, isTrue);
      expect(
        repository.bulkSelectionPayload?.selectionToken,
        'selection-token',
      );
      expect(repository.bulkSelectionPayload?.priority, TaskPriority.critical);
      expect(repository.bulkSelectionPayload?.returnTaskIds, ['task-1']);
      expect(repository.groupedCalls, 1);
      final state = cubit.state as ProjectTasksListReady;
      expect(state.tasks.single.priority, TaskPriority.critical);
      expect(state.tasks.single.version, 2);
      expect(state.selectedTaskIds, isEmpty);
    },
  );

  test('token bulk zachowuje filtr zadań nieprzypisanych', () async {
    await cubit.load(unassignedOnly: true);

    await cubit.bulkUpdateEntireResult(priority: TaskPriority.critical);

    expect(repository.selectionTokenPayload?.query.unassignedOnly, isTrue);
  });

  test('przenosi cały wynik tokenowy do własnej grupy workflow', () async {
    await cubit.load();

    final updated = await cubit.bulkUpdateEntireResult(
      customStatusId: 'custom-status-2',
    );

    expect(updated, 5000);
    expect(
      repository.bulkSelectionPayload?.customStatusId,
      'custom-status-2',
    );
    expect(repository.bulkSelectionPayload?.status, isNull);
  });

  test(
    'bulk może wyczyścić własny status bez zmiany statusu systemowego',
    () async {
      repository.useCustomStatusGroups = true;
      repository.includeUnassignedCustomStatusGroup = true;
      final customCubit = ProjectTasksListCubit(
        repository: repository,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        groupBy: TaskSavedViewGroupBy.customStatus,
      );
      addTearDown(customCubit.close);
      await customCubit.load();

      final updated = await customCubit.bulkUpdateEntireResult(
        clearCustomStatus: true,
      );

      expect(updated, 5000);
      expect(repository.bulkSelectionPayload?.clearCustomStatus, isTrue);
      expect(repository.bulkSelectionPayload?.customStatusId, isNull);
      final state = customCubit.state as ProjectTasksListReady;
      expect(state.groups[0].items, isEmpty);
      expect(state.groups[2].items.single.customStatusId, isNull);
    },
  );

  test(
    'updateGroupBy przełącza grupowanie i ponownie ładuje dane',
    () async {
      await cubit.load();
      expect(cubit.groupBy, TaskSavedViewGroupBy.status);

      await cubit.updateGroupBy(TaskSavedViewGroupBy.priority);
      expect(cubit.groupBy, TaskSavedViewGroupBy.priority);
      expect(repository.lastGroupedQuery?.groupBy, 'Priority');

      // Grupowanie None zachowuje none (płaska lista bez nagłówków grup)
      await cubit.updateGroupBy(TaskSavedViewGroupBy.none);
      expect(cubit.groupBy, TaskSavedViewGroupBy.none);

      // Powrót do grupowania po statusie
      await cubit.updateGroupBy(TaskSavedViewGroupBy.status);
      expect(cubit.groupBy, TaskSavedViewGroupBy.status);
      expect(repository.lastGroupedQuery?.groupBy, 'Status');
    },
  );
}
