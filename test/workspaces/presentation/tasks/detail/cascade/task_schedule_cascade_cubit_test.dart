import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_schedule_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_schedule_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cascade/cubit/task_schedule_cascade_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

/// Repozytorium harmonogramu z jawnie sterowanymi wynikami kaskady.
final class _FakeScheduleRepository implements TaskScheduleRepository {
  Either<ApiError, ScheduleCascadeResponse>? previewResult;
  Either<ApiError, ScheduleCascadeResponse>? applyResult;
  final previews = <PreviewScheduleCascadePayload>[];
  final applies = <ApplyScheduleCascadePayload>[];

  @override
  Future<Either<ApiError, ScheduleCascadeResponse>> previewCascade({
    required String workspaceId,
    required String projectId,
    required PreviewScheduleCascadePayload payload,
  }) async {
    previews.add(payload);
    return previewResult!;
  }

  @override
  Future<Either<ApiError, ScheduleCascadeResponse>> applyCascade({
    required String workspaceId,
    required String projectId,
    required ApplyScheduleCascadePayload payload,
  }) async {
    applies.add(payload);
    return applyResult!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ScheduleCascadeResponse _previewWith({
  required String taskId,
  required int expectedVersion,
}) => ScheduleCascadeResponse(
  dateShifts: [
    TaskDateShiftResponse(
      taskId: taskId,
      title: 'Zadanie',
      proposedStartAtUtc: DateTime.utc(2026, 9, 21),
      proposedDueAtUtc: DateTime.utc(2026, 9, 25),
      shiftWorkingDays: 2,
      isOnCriticalPath: true,
      expectedVersion: expectedVersion,
    ),
  ],
  criticalPathTaskIds: [taskId],
  totalProjectWorkingDays: 40,
  taskFloats: const [],
);

void main() {
  late _FakeScheduleRepository repository;
  late TaskScheduleCascadeCubit cubit;

  setUp(() {
    repository = _FakeScheduleRepository();
    cubit = TaskScheduleCascadeCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
  });

  tearDown(() => cubit.close());

  test('podgląd kaskady pokazuje wynik i niczego nie zapisuje', () async {
    repository.previewResult = Right(
      _previewWith(taskId: 'task-1', expectedVersion: 7),
    );

    final ok = await cubit.preview(
      taskId: 'task-1',
      newStartAtUtc: DateTime.utc(2026, 9, 21),
      newDueAtUtc: DateTime.utc(2026, 9, 25),
    );

    expect(ok, isTrue);
    expect(cubit.state.preview?.dateShifts.single.taskId, 'task-1');
    expect(cubit.state.isPreviewing, isFalse);
    expect(cubit.state.error, isNull);
    expect(repository.previews.single.taskId, 'task-1');
    expect(repository.applies, isEmpty);
  });

  test('błąd podglądu zostaje w stanie i nie udaje aktualnego podglądu', () async {
    repository.previewResult = Right(
      _previewWith(taskId: 'task-1', expectedVersion: 7),
    );
    await cubit.preview(
      taskId: 'task-1',
      newStartAtUtc: DateTime.utc(2026, 9, 21),
      newDueAtUtc: DateTime.utc(2026, 9, 25),
    );
    expect(cubit.state.preview, isNotNull);

    repository.previewResult = const Left(
      ApiError(
        type: ApiErrorType.forbidden,
        message: 'Brak dostępu do harmonogramu',
        statusCode: 403,
      ),
    );
    final ok = await cubit.preview(
      taskId: 'task-1',
      newStartAtUtc: DateTime.utc(2026, 10),
      newDueAtUtc: DateTime.utc(2026, 10, 5),
    );

    expect(ok, isFalse);
    expect(cubit.state.preview, isNull);
    expect(cubit.state.error, 'Brak dostępu do harmonogramu');
  });

  test('zapis bez podglądu jest odrzucany, bo brakuje wersji zadań', () async {
    final ok = await cubit.apply(
      taskId: 'task-1',
      newStartAtUtc: DateTime.utc(2026, 9, 21),
      newDueAtUtc: DateTime.utc(2026, 9, 25),
    );

    expect(ok, isFalse);
    expect(repository.applies, isEmpty);
    expect(cubit.state.error, isNull);
  });

  test('zapis wysyła wersje zadań z zaakceptowanego podglądu', () async {
    repository.previewResult = Right(
      _previewWith(taskId: 'task-1', expectedVersion: 7),
    );
    await cubit.preview(
      taskId: 'task-1',
      newStartAtUtc: DateTime.utc(2026, 9, 21),
      newDueAtUtc: DateTime.utc(2026, 9, 25),
    );
    repository.applyResult = Right(
      _previewWith(taskId: 'task-1', expectedVersion: 7),
    );

    final ok = await cubit.apply(
      taskId: 'task-1',
      newStartAtUtc: DateTime.utc(2026, 9, 21),
      newDueAtUtc: DateTime.utc(2026, 9, 25),
    );

    expect(ok, isTrue);
    expect(repository.applies.single.expectedTaskVersions, {'task-1': 7});
    // Po zapisie podgląd nie udaje już propozycji do akceptacji.
    expect(cubit.state.preview, isNull);
    expect(cubit.state.isApplying, isFalse);
  });

  test('konflikt wersji zostawia podgląd i trwały komunikat', () async {
    repository.previewResult = Right(
      _previewWith(taskId: 'task-1', expectedVersion: 7),
    );
    await cubit.preview(
      taskId: 'task-1',
      newStartAtUtc: DateTime.utc(2026, 9, 21),
      newDueAtUtc: DateTime.utc(2026, 9, 25),
    );
    repository.applyResult = const Left(
      ApiError(
        type: ApiErrorType.conflict,
        message: 'Ktoś zmienił zadanie w międzyczasie',
        statusCode: 409,
      ),
    );

    final ok = await cubit.apply(
      taskId: 'task-1',
      newStartAtUtc: DateTime.utc(2026, 9, 21),
      newDueAtUtc: DateTime.utc(2026, 9, 25),
    );

    expect(ok, isFalse);
    expect(cubit.state.error, 'Ktoś zmienił zadanie w międzyczasie');
    expect(cubit.state.preview, isNotNull);
  });

  test('zmiana dat zdejmuje podgląd, żeby nie opisywał innych terminów', () async {
    repository.previewResult = Right(
      _previewWith(taskId: 'task-1', expectedVersion: 7),
    );
    await cubit.preview(
      taskId: 'task-1',
      newStartAtUtc: DateTime.utc(2026, 9, 21),
      newDueAtUtc: DateTime.utc(2026, 9, 25),
    );

    cubit.clearPreview();

    expect(cubit.state.preview, isNull);
    expect(cubit.state.isBusy, isFalse);
  });
}
