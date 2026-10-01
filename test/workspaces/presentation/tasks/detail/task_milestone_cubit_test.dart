import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/milestone_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/milestone/cubit/task_milestone_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Repository implements MilestoneRepository {
  final assignedTaskIds = <String, Set<String>>{
    'milestone-1': {'task-1'},
    'milestone-2': {},
  };
  String? assignedMilestoneId;
  String? unassignedMilestoneId;
  int listTaskCalls = 0;
  int listCalls = 0;
  Object? listError;
  Object? getError;
  Object? assignError;
  Object? unassignError;
  Completer<void>? pendingList;

  @override
  Future<Either<ApiError, List<MilestoneResponse>>> listMilestones({
    required String workspaceId,
    required String projectId,
  }) async {
    listCalls++;
    if (pendingList case final pending?) await pending.future;
    if (listError case final error?) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    return Right([_milestone('milestone-1'), _milestone('milestone-2')]);
  }

  @override
  Future<Either<ApiError, MilestoneResponse>> getMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  }) async {
    if (getError case final error?) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    return Right(_milestone(milestoneId));
  }

  @override
  Future<Either<ApiError, List<MilestoneTaskResponse>>> listTasks({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  }) async {
    listTaskCalls++;
    return Right([
      for (final id in assignedTaskIds[milestoneId]!) _task(id),
    ]);
  }

  @override
  Future<Either<ApiError, Unit>> assignTask({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required String taskId,
  }) async {
    if (assignError case final error?) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    assignedMilestoneId = milestoneId;
    assignedTaskIds[milestoneId]!.add(taskId);
    return const Right(unit);
  }

  @override
  Future<Either<ApiError, Unit>> unassignTask({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required String taskId,
  }) async {
    if (unassignError case final error?) {
      Error.throwWithStackTrace(error, StackTrace.current);
    }
    unassignedMilestoneId = milestoneId;
    assignedTaskIds[milestoneId]!.remove(taskId);
    return const Right(unit);
  }

  @override
  Future<Either<ApiError, MilestoneResponse>> createMilestone({
    required String workspaceId,
    required String projectId,
    required CreateMilestonePayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, MilestoneResponse>> updateMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
    required UpdateMilestonePayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, Unit>> deleteMilestone({
    required String workspaceId,
    required String projectId,
    required String milestoneId,
  }) => throw UnimplementedError();
}

MilestoneResponse _milestone(String id) => MilestoneResponse(
  id: id,
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  name: id,
  status: MilestoneStatus.active,
  progress: 0,
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  version: 1,
);

MilestoneTaskResponse _task(String id) => MilestoneTaskResponse(
  id: id,
  number: 1,
  key: 'PRO-1',
  title: 'Zadanie',
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.normal,
  version: 1,
);

void main() {
  late _Repository repository;
  late TaskMilestoneCubit cubit;

  setUp(() {
    repository = _Repository();
    cubit = TaskMilestoneCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
      assignedMilestoneId: 'milestone-1',
    );
  });
  tearDown(() => cubit.close());

  test(
    'odczytuje przypisanie z task DTO bez skanowania zadań milestone’ów',
    () async {
      await cubit.load();

      expect((cubit.state as TaskMilestoneReady).assigned?.id, 'milestone-1');
      expect(repository.listTaskCalls, 0);
    },
  );

  test(
    'odpina zadanie, a potem pozwala przypisać je do innego milestone’u',
    () async {
      await cubit.load();

      expect(await cubit.unassign(), isTrue);
      expect(repository.unassignedMilestoneId, 'milestone-1');
      final target = (cubit.state as TaskMilestoneReady).milestones.last;
      expect(await cubit.assign(target), isTrue);
      expect(repository.assignedMilestoneId, 'milestone-2');
    },
  );

  test('thrown load error zachowuje metadane i kończy Loading', () async {
    const error = ApiError(
      type: ApiErrorType.forbidden,
      message: 'Denied',
      apiCode: 'storage.denied',
      traceId: 'trace-load',
      fields: {
        'scope': ['denied'],
      },
    );
    repository.listError = error;
    await cubit.load();
    expect((cubit.state as TaskMilestoneFailure).error, same(error));
    expect(cubit.canRetry, isTrue);
  });

  test('unknown mutation kończy saving i zachowuje przypisanie', () async {
    await cubit.load();
    repository.unassignError = StateError('private details');
    expect(await cubit.unassign(), isFalse);
    final state = cubit.state as TaskMilestoneReady;
    expect(state.isSaving, isFalse);
    expect(state.assigned?.id, 'milestone-1');
    expect(state.apiError?.message, isEmpty);
    expect(state.apiError?.apiCode, 'tasks.milestone_operation_failed');
    expect(cubit.canMutate, isTrue);
  });

  test('thrown assign error pozwala na jawne ponowienie', () async {
    await cubit.load();
    await cubit.unassign();
    const error = ApiError(
      type: ApiErrorType.validation,
      message: 'Invalid',
      fields: {
        'milestoneId': ['invalid'],
      },
      traceId: 'trace-save',
    );
    repository.assignError = error;
    expect(await cubit.assign(_milestone('milestone-2')), isFalse);
    expect((cubit.state as TaskMilestoneReady).apiError, same(error));
    repository.assignError = null;
    expect(await cubit.assign(_milestone('milestone-2')), isTrue);
    expect((cubit.state as TaskMilestoneReady).apiError, isNull);
  });

  test('cooldown blokuje odczyt i mutacje do RetryAfter', () async {
    await cubit.load();
    repository.unassignError = ApiError(
      type: ApiErrorType.unknown,
      message: 'Wait',
      statusCode: 429,
      retryAfterUtc: DateTime.now().toUtc().add(
        const Duration(milliseconds: 120),
      ),
    );
    expect(await cubit.unassign(), isFalse);
    expect(cubit.canRetry, isFalse);
    expect(cubit.canMutate, isFalse);
    final calls = repository.listCalls;
    await cubit.load();
    expect(repository.listCalls, calls);
    await Future<void>.delayed(const Duration(milliseconds: 180));
    expect(cubit.canRetry, isTrue);
    repository.unassignError = null;
    expect(await cubit.unassign(), isTrue);
  });

  test('zamknięcie odrzuca spóźniony throw i kolejne REST', () async {
    repository.pendingList = Completer<void>();
    repository.listError = StateError('late private details');
    final loading = cubit.load();
    await cubit.close();
    repository.pendingList!.complete();
    await loading;
    expect(cubit.state, isA<TaskMilestoneLoading>());
    await cubit.load();
    expect(repository.listCalls, 1);
  });

  test('thrown Dio zachowuje status fields code i trace', () async {
    await cubit.load();
    final options = RequestOptions(path: '/milestone/unassign');
    repository.unassignError = DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response<Object?>(
        requestOptions: options,
        statusCode: 422,
        data: {
          'code': 'milestone.invalid',
          'message': 'Invalid selection',
          'fields': {
            'milestoneId': ['No longer active'],
          },
          'traceId': 'trace-dio',
        },
      ),
    );
    expect(await cubit.unassign(), isFalse);
    final error = (cubit.state as TaskMilestoneReady).apiError!;
    expect(error.statusCode, 422);
    expect(error.apiCode, 'milestone.invalid');
    expect(error.traceId, 'trace-dio');
    expect(error.fields['milestoneId'], ['No longer active']);
  });

  test(
    'throw assigned fetch przekazuje access lost i kończy Loading',
    () async {
      const error = ApiError(
        type: ApiErrorType.forbidden,
        message: 'Denied',
        apiCode: 'milestone.denied',
        traceId: 'trace-fetch',
      );
      repository.getError = error;
      ApiError? reported;
      final owner = TaskMilestoneCubit(
        repository: repository,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
        assignedMilestoneId: 'milestone-unlisted',
        onAccessLost: (error) => reported = error,
      );
      addTearDown(owner.close);
      await owner.load();
      expect((owner.state as TaskMilestoneFailure).error, same(error));
      expect(reported, same(error));
    },
  );

  test('unknown Dio bez response nie ujawnia prywatnego message', () async {
    await cubit.load();
    repository.unassignError = DioException(
      requestOptions: RequestOptions(path: '/milestone/unassign'),
      message: 'private upstream details',
    );
    expect(await cubit.unassign(), isFalse);
    final error = (cubit.state as TaskMilestoneReady).apiError!;
    expect(error.message, isEmpty);
    expect(error.apiCode, 'tasks.milestone_operation_failed');
  });
}
