import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_run_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_time_zones_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_time_zones_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

final class _TaskRecurrenceRepository implements TaskRecurrenceRepository {
  Either<ApiError, TaskRecurrenceResponse>? getResult;
  Object? getThrown;
  Object? createThrown;
  Object? deleteThrown;
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? createResult;
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? updateResult;
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? pauseResult;
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? resumeResult;
  CreateTaskRecurrencePayload? createPayload;
  UpdateTaskRecurrencePayload? updatePayload;
  int? pauseVersion;
  int? resumeVersion;
  Either<ApiError, List<String>>? timeZonesResult;
  Object? timeZonesThrown;
  int timeZoneRequests = 0;
  Either<ApiError, List<ProjectTaskRecurrenceRunResponse>>? runsResult;
  Object? runsThrown;
  Completer<Either<ApiError, List<ProjectTaskRecurrenceRunResponse>>>?
  runsCompleter;
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? runNowResult;
  Object? runNowThrown;
  Completer<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>?
  runNowCompleter;
  int runHistoryRequests = 0;
  int runNowRequests = 0;
  String? runNowTaskId;

  @override
  Future<Either<ApiError, List<String>>> listSupportedTimeZones({
    required String workspaceId,
    required String projectId,
  }) async {
    timeZoneRequests++;
    if (timeZonesThrown case final error?) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    return timeZonesResult!;
  }

  @override
  Future<Either<ApiError, TaskRecurrenceResponse>> get({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async {
    if (getThrown case final error?) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    return getResult!;
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  create({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskRecurrencePayload payload,
  }) async {
    createPayload = payload;
    if (createThrown case final error?) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    return createResult!;
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  update({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required UpdateTaskRecurrencePayload payload,
  }) async {
    updatePayload = payload;
    return updateResult!;
  }

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
  }) async {
    if (deleteThrown case final error?) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    return right(
      TaskMutationResponse(
        taskId: taskId,
        taskVersion: 1,
        taskUpdatedAtUtc: DateTime.utc(2026),
        data: true,
      ),
    );
  }

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
  }) async {
    runHistoryRequests++;
    if (runsThrown case final error?) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    final completer = runsCompleter;
    if (completer != null) return completer.future;
    return runsResult ?? const Right([]);
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  triggerRunNow({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async {
    runNowRequests++;
    runNowTaskId = taskId;
    if (runNowThrown case final error?) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    final completer = runNowCompleter;
    if (completer != null) return completer.future;
    return runNowResult ??
        const Left(
          ApiError(type: ApiErrorType.unknown, message: 'run unavailable'),
        );
  }
}

TaskRecurrenceResponse _recurrence({bool isActive = true, int version = 3}) =>
    TaskRecurrenceResponse(
      id: 'recurrence-1',
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      sourceTaskId: 'task-1',
      mode: TaskRecurrenceMode.scheduled,
      frequency: TaskRecurrenceFrequency.weekly,
      interval: 1,
      timeZoneId: 'Europe/Warsaw',
      occurrenceStatus: ProjectTaskStatus.todo,
      skipIfPreviousOpen: true,
      isActive: isActive,
      createdAtUtc: DateTime.utc(2026, 8, 26),
      updatedAtUtc: DateTime.utc(2026, 8, 26),
      version: version,
    );

TaskMutationResponse<TaskRecurrenceResponse> _mutation(
  TaskRecurrenceResponse recurrence,
) => TaskMutationResponse(
  taskId: recurrence.sourceTaskId,
  taskVersion: 5,
  taskUpdatedAtUtc: recurrence.updatedAtUtc,
  data: recurrence,
);

ProjectTaskRecurrenceRunResponse _run({
  String id = 'run-1',
  String ruleId = 'recurrence-1',
  String sourceTaskId = 'task-1',
  DateTime? executedAtUtc,
  TaskRecurrenceRunOutcome outcome = TaskRecurrenceRunOutcome.created,
  String? createdTaskKey = 'TASK-8',
}) => ProjectTaskRecurrenceRunResponse(
  id: id,
  recurrenceRuleId: ruleId,
  sourceTaskId: sourceTaskId,
  taskKey: 'TASK-1',
  taskTitle: 'Source task',
  scheduledAtUtc: DateTime.utc(2026),
  executedAtUtc: executedAtUtc ?? DateTime.utc(2026),
  outcome: outcome,
  createdTaskId: createdTaskKey == null ? null : 'occurrence-1',
  createdTaskKey: createdTaskKey,
);

TaskRecurrenceCubit _cubit(_TaskRecurrenceRepository repository) =>
    TaskRecurrenceCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );

TaskRecurrenceRunCubit _runCubit(_TaskRecurrenceRepository repository) =>
    TaskRecurrenceRunCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      sourceTaskId: 'task-1',
    );

void main() {
  test(
    'ładuje katalog ze stanu początkowego Loading, sortuje i filtruje',
    () async {
      final repository = _TaskRecurrenceRepository()
        ..timeZonesResult = const Right([
          'Europe/Warsaw',
          'America/New_York',
        ]);
      final cubit = TaskRecurrenceTimeZonesCubit(
        repository: repository,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        currentId: 'UTC',
      );

      await cubit.load();

      final ready = cubit.state as TaskRecurrenceTimeZonesReady;
      expect(repository.timeZoneRequests, 1);
      expect(ready.allZones, ['America/New_York', 'Europe/Warsaw']);
      expect(ready.currentIdIsUnlisted, isTrue);

      cubit.search('warsaw');
      expect(
        (cubit.state as TaskRecurrenceTimeZonesReady).visibleZones,
        ['Europe/Warsaw'],
      );
      await cubit.close();
    },
  );

  test('zachowuje typowany błąd katalogu zamiast pustej listy', () async {
    const failure = ApiError(
      type: ApiErrorType.forbidden,
      message: 'Brak dostępu',
      apiCode: 'project_forbidden',
      contractCode: 'project_forbidden',
      traceId: 'trace-zone-1',
    );
    final repository = _TaskRecurrenceRepository()
      ..timeZonesResult = const Left(failure);
    final cubit = TaskRecurrenceTimeZonesCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      currentId: 'UTC',
    );

    await cubit.load();

    final state = cubit.state as TaskRecurrenceTimeZonesFailure;
    expect(state.error.apiCode, 'project_forbidden');
    expect(state.error.traceId, 'trace-zone-1');
    expect(repository.timeZoneRequests, 1);
    await cubit.close();
  });

  test('nie zostawia katalogu w Loading po nieoczekiwanym throw', () async {
    final repository = _TaskRecurrenceRepository()
      ..timeZonesThrown = StateError('private transport detail')
      ..timeZonesResult = const Right(['UTC']);
    final cubit = TaskRecurrenceTimeZonesCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      currentId: 'Windows/UTC',
    );

    await cubit.load();

    final failed = cubit.state as TaskRecurrenceTimeZonesFailure;
    expect(failed.error.apiCode, 'task_recurrence_time_zones_load_failed');
    expect(failed.error.message, isEmpty);
    expect(repository.timeZoneRequests, 1);

    repository.timeZonesThrown = null;
    await cubit.load();
    expect(cubit.state, isA<TaskRecurrenceTimeZonesReady>());
    expect(repository.timeZoneRequests, 2);
    await cubit.close();
  });

  test('Dio unknown bez odpowiedzi nie ujawnia surowej wiadomości', () async {
    final repository = _TaskRecurrenceRepository()
      ..timeZonesThrown = DioException(
        requestOptions: RequestOptions(path: '/task-time-zones'),
        message: 'private socket path and host detail',
      )
      ..timeZonesResult = const Right(['UTC']);
    final cubit = TaskRecurrenceTimeZonesCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      currentId: 'UTC',
    );

    await cubit.load();

    final failed = cubit.state as TaskRecurrenceTimeZonesFailure;
    expect(failed.error.apiCode, 'task_recurrence_time_zones_load_failed');
    expect(failed.error.message, isEmpty);
    expect(failed.error.message, isNot(contains('private socket')));
    await cubit.close();
  });

  test('tworzy serię na wersji detailu taska', () async {
    final repository = _TaskRecurrenceRepository()
      ..createResult = Right(_mutation(_recurrence()));
    final cubit = _cubit(repository);
    await cubit.load(hasRecurrence: false);

    final saved = await cubit.create(
      const CreateTaskRecurrencePayload(
        mode: TaskRecurrenceMode.scheduled,
        frequency: TaskRecurrenceFrequency.weekly,
        interval: 2,
        timeZoneId: 'Europe/Warsaw',
        expectedVersion: 4,
      ),
    );

    expect(saved, isTrue);
    expect(repository.createPayload?.expectedVersion, 4);
    expect((cubit.state as TaskRecurrenceReady).recurrence?.interval, 1);
    await cubit.close();
  });

  test('pobiera istniejącą serię i pauzuje na jej wersji', () async {
    final existing = _recurrence(version: 7);
    final paused = _recurrence(isActive: false, version: 8);
    final repository = _TaskRecurrenceRepository()
      ..getResult = Right(existing)
      ..pauseResult = Right(_mutation(paused));
    final cubit = _cubit(repository);

    await cubit.load(hasRecurrence: true);
    final saved = await cubit.toggleActive();

    expect(saved, isTrue);
    expect(repository.pauseVersion, 7);
    expect((cubit.state as TaskRecurrenceReady).recurrence?.isActive, isFalse);
    await cubit.close();
  });

  test('ładuje najnowszy wynik tylko dla bieżącej serii i źródła', () async {
    final expected = _run(
      id: 'run-new',
      executedAtUtc: DateTime.utc(2026, 10, 2),
      outcome: TaskRecurrenceRunOutcome.skippedPreviousOpen,
      createdTaskKey: null,
    );
    final repository = _TaskRecurrenceRepository()
      ..runsResult = Right([
        _run(id: 'wrong-source', sourceTaskId: 'task-2'),
        _run(id: 'wrong-rule', ruleId: 'recurrence-2'),
        _run(id: 'run-old'),
        expected,
      ]);
    final cubit = _runCubit(repository);

    await cubit.ensureLatestLoaded('recurrence-1');

    expect(cubit.state.latestRun, expected);
    expect(
      cubit.state.latestRun?.outcome,
      TaskRecurrenceRunOutcome.skippedPreviousOpen,
    );
    expect(repository.runHistoryRequests, 1);
    await cubit.close();
  });

  test(
    'błąd historii zachowuje diagnostykę i można ponowić sam odczyt',
    () async {
      final repository = _TaskRecurrenceRepository()
        ..runsResult = const Left(
          ApiError(
            type: ApiErrorType.server,
            statusCode: 503,
            message: 'Historia niedostępna',
            apiCode: 'recurrence_runs_unavailable',
            traceId: 'trace-runs-1',
          ),
        );
      final cubit = _runCubit(repository);

      await cubit.ensureLatestLoaded('recurrence-1');
      expect(cubit.state.historyError?.apiCode, 'recurrence_runs_unavailable');
      expect(cubit.state.historyError?.traceId, 'trace-runs-1');
      expect(cubit.state.latestRun, isNull);

      repository.runsResult = Right([_run()]);
      await cubit.retryHistory();

      expect(cubit.state.historyError, isNull);
      expect(cubit.state.latestRun?.id, 'run-1');
      expect(repository.runNowRequests, 0);
      expect(repository.runHistoryRequests, 2);
      await cubit.close();
    },
  );

  test('run-now używa taska źródłowego i odświeża rzeczywisty wynik', () async {
    final repository = _TaskRecurrenceRepository()
      ..runNowResult = Right(_mutation(_recurrence(version: 4)))
      ..runsResult = Right([_run(createdTaskKey: 'TASK-9')]);
    final cubit = _runCubit(repository);

    final succeeded = await cubit.triggerRunNow('recurrence-1');

    expect(succeeded, isTrue);
    expect(repository.runNowTaskId, 'task-1');
    expect(repository.runNowRequests, 1);
    expect(repository.runHistoryRequests, 1);
    expect(cubit.state.latestRun?.createdTaskKey, 'TASK-9');
    expect(cubit.state.isTriggering, isFalse);
    await cubit.close();
  });

  test(
    'blokuje równoległe run-now i zachowuje typowany błąd operacji',
    () async {
      final pending =
          Completer<
            Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>
          >();
      final repository = _TaskRecurrenceRepository()
        ..runNowCompleter = pending
        ..runsResult = const Right([]);
      final cubit = _runCubit(repository);

      final first = cubit.triggerRunNow('recurrence-1');
      expect(cubit.state.isTriggering, isTrue);
      expect(await cubit.triggerRunNow('recurrence-1'), isFalse);
      expect(repository.runNowRequests, 1);

      pending.complete(
        const Left(
          ApiError(
            type: ApiErrorType.server,
            statusCode: 429,
            message: 'Poczekaj',
            apiCode: 'rate_limited',
            traceId: 'trace-run-now',
          ),
        ),
      );
      await first;
      expect(cubit.state.actionError?.apiCode, 'rate_limited');
      await cubit.close();
    },
  );

  test(
    '429 run-now blokuje tylko ponowienie akcji, historia może się odświeżyć',
    () async {
      final repository = _TaskRecurrenceRepository()
        ..runNowResult = Left(
          ApiError(
            type: ApiErrorType.server,
            statusCode: 429,
            message: 'Poczekaj',
            apiCode: 'rate_limited',
            traceId: 'trace-run-now',
            retryAfterUtc: DateTime.now().toUtc().add(
              const Duration(minutes: 5),
            ),
          ),
        )
        ..runsResult = Right([_run()]);
      final cubit = _runCubit(repository);

      expect(await cubit.triggerRunNow('recurrence-1'), isFalse);
      expect(cubit.state.isActionRetryBlocked, isTrue);
      expect(cubit.state.actionError?.traceId, 'trace-run-now');
      await cubit.retryHistory();

      expect(cubit.state.latestRun?.id, 'run-1');
      expect(cubit.state.isActionRetryBlocked, isTrue);
      expect(repository.runNowRequests, 1);
      expect(repository.runHistoryRequests, 1);
      await cubit.close();
    },
  );

  test('ignoruje wynik requestu run-now po zamknięciu Cubita', () async {
    final pending =
        Completer<
          Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>
        >();
    final repository = _TaskRecurrenceRepository()..runNowCompleter = pending;
    final cubit = _runCubit(repository);

    final request = cubit.triggerRunNow('recurrence-1');
    await cubit.close();
    pending.complete(Right(_mutation(_recurrence())));
    expect(await request, isFalse);
    expect(repository.runHistoryRequests, 0);
  });

  test('zachowuje formularz i pokazuje błąd mutacji', () async {
    final repository = _TaskRecurrenceRepository()
      ..createResult = const Left(
        ApiError(
          type: ApiErrorType.conflict,
          message: 'Wersja jest nieaktualna',
        ),
      );
    final cubit = _cubit(repository);
    await cubit.load(hasRecurrence: false);

    final saved = await cubit.create(
      const CreateTaskRecurrencePayload(
        mode: TaskRecurrenceMode.scheduled,
        frequency: TaskRecurrenceFrequency.daily,
        interval: 1,
        timeZoneId: 'Etc/UTC',
        expectedVersion: 1,
      ),
    );

    expect(saved, isFalse);
    final state = cubit.state as TaskRecurrenceReady;
    expect(state.recurrence, isNull);
    expect(state.error, 'Wersja jest nieaktualna');
    await cubit.close();
  });
}
