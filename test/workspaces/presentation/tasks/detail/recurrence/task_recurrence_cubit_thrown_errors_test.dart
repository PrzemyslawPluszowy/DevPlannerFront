import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Repository implements TaskRecurrenceRepository {
  Object? getThrown;
  Object? createThrown;
  Object? deleteThrown;
  Either<ApiError, TaskRecurrenceResponse>? getResult;
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? createResult;
  int createCalls = 0;

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
    createCalls++;
    if (createThrown case final error?) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    return createResult!;
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
    throw UnimplementedError();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

TaskRecurrenceResponse _recurrence() => TaskRecurrenceResponse(
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
  isActive: true,
  createdAtUtc: DateTime.utc(2026, 8, 26),
  updatedAtUtc: DateTime.utc(2026, 8, 26),
  version: 3,
);

TaskMutationResponse<TaskRecurrenceResponse> _mutation(
  TaskRecurrenceResponse recurrence,
) => TaskMutationResponse(
  taskId: recurrence.sourceTaskId,
  taskVersion: recurrence.version,
  taskUpdatedAtUtc: recurrence.updatedAtUtc,
  data: recurrence,
);

TaskRecurrenceCubit _cubit(_Repository repository) => TaskRecurrenceCubit(
  repository: repository,
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  taskId: 'task-1',
);

void main() {
  test('thrown 429 on load keeps typed metadata and can retry', () async {
    final retryAt = DateTime.now().toUtc().add(
      const Duration(milliseconds: 80),
    );
    final apiError = ApiError(
      type: ApiErrorType.server,
      message: 'Too many requests',
      statusCode: 429,
      apiCode: 'rate_limited',
      contractCode: 'rate_limited',
      fields: const {
        'recurrence': ['cooldown'],
      },
      traceId: 'trace-recurrence-429',
      retryAfterUtc: retryAt,
    );
    final repository = _Repository()
      ..getThrown = apiError
      ..getResult = Right(_recurrence());
    final cubit = _cubit(repository);

    await cubit.load(hasRecurrence: true);

    final failed = cubit.state as TaskRecurrenceFailure;
    expect(failed.apiError, apiError);
    expect(failed.apiError?.retryAfterUtc, retryAt);
    expect(failed.apiError?.fields, apiError.fields);
    repository.getThrown = null;
    await Future<void>.delayed(const Duration(milliseconds: 120));
    await cubit.load(hasRecurrence: true);
    expect(cubit.state, isA<TaskRecurrenceReady>());
    await cubit.close();
  });

  test('mutation Retry-After blocks retry until its deadline', () async {
    final retryAt = DateTime.now().toUtc().add(
      const Duration(milliseconds: 80),
    );
    final rateLimit = ApiError(
      type: ApiErrorType.server,
      message: 'Too many requests',
      statusCode: 429,
      apiCode: 'rate_limited',
      retryAfterUtc: retryAt,
    );
    final repository = _Repository()
      ..getResult = Right(_recurrence())
      ..createThrown = rateLimit;
    final cubit = _cubit(repository);
    const payload = CreateTaskRecurrencePayload(
      mode: TaskRecurrenceMode.scheduled,
      frequency: TaskRecurrenceFrequency.weekly,
      interval: 1,
      timeZoneId: 'Etc/UTC',
      expectedVersion: 3,
    );
    await cubit.load(hasRecurrence: true);

    expect(await cubit.create(payload), isFalse);
    expect((cubit.state as TaskRecurrenceReady).isRetryBlocked, isTrue);
    expect(await cubit.create(payload), isFalse);
    expect(repository.createCalls, 1);

    await Future<void>.delayed(const Duration(milliseconds: 120));
    expect((cubit.state as TaskRecurrenceReady).isRetryBlocked, isFalse);
    repository.createThrown = null;
    repository.createResult = Right(
      _mutation(_recurrence().copyWith(version: 4)),
    );
    expect(await cubit.create(payload), isTrue);
    expect(repository.createCalls, 2);
    await cubit.close();
  });

  test(
    'thrown save error clears busy and retains the loaded recurrence',
    () async {
      final apiError = ApiError(
        type: ApiErrorType.conflict,
        message: 'Version conflict',
        statusCode: 409,
        apiCode: 'task_version_conflict',
        fields: const {
          'interval': ['conflict'],
        },
        traceId: 'trace-recurrence-save',
        retryAfterUtc: DateTime.utc(2026, 10, 1, 11),
      );
      final repository = _Repository()
        ..createThrown = apiError
        ..getResult = Right(_recurrence());
      final cubit = _cubit(repository);
      await cubit.load(hasRecurrence: true);

      expect(
        await cubit.create(
          const CreateTaskRecurrencePayload(
            mode: TaskRecurrenceMode.scheduled,
            frequency: TaskRecurrenceFrequency.weekly,
            interval: 1,
            timeZoneId: 'Etc/UTC',
            expectedVersion: 3,
          ),
        ),
        isFalse,
      );

      final state = cubit.state as TaskRecurrenceReady;
      expect(state.isSaving, isFalse);
      expect(state.recurrence, _recurrence());
      expect(state.apiError, apiError);
      await cubit.close();
    },
  );

  test('thrown delete error clears busy and retains recurrence', () async {
    const apiError = ApiError(
      type: ApiErrorType.forbidden,
      message: 'Forbidden',
      apiCode: 'task_forbidden',
      traceId: 'trace-recurrence-delete',
    );
    final repository = _Repository()
      ..getResult = Right(_recurrence())
      ..deleteThrown = apiError;
    final cubit = _cubit(repository);
    await cubit.load(hasRecurrence: true);

    expect(await cubit.delete(), isFalse);

    final state = cubit.state as TaskRecurrenceReady;
    expect(state.isSaving, isFalse);
    expect(state.apiError, apiError);
    expect(state.recurrence, _recurrence());
    await cubit.close();
  });
}
