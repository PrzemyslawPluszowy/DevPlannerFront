import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_cubit.dart';
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
  }) async => const Right([]);

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  triggerRunNow({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async => throw UnimplementedError();
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

TaskRecurrenceCubit _cubit(_TaskRecurrenceRepository repository) =>
    TaskRecurrenceCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
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
