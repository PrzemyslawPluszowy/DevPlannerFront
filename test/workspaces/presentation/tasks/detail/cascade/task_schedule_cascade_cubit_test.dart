import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_schedule_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_schedule_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cascade/cubit/task_schedule_cascade_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

/// Repozytorium harmonogramu z jawnie sterowanymi wynikami kaskady.
final class _FakeScheduleRepository implements TaskScheduleRepository {
  Either<ApiError, ScheduleCascadeResponse>? previewResult;
  Future<Either<ApiError, ScheduleCascadeResponse>>? pendingPreview;
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
    return pendingPreview ?? previewResult!;
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

  test(
    'preview and apply preserve instants and the session calendar zone',
    () async {
      await cubit.close();
      cubit = TaskScheduleCascadeCubit(
        repository: repository,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        calendarTimeZoneId: 'Europe/Warsaw',
      );
      repository.previewResult = Right(
        _previewWith(taskId: 'task-1', expectedVersion: 7),
      );
      repository.applyResult = repository.previewResult;
      final start = DateTime.utc(2026, 10, 5, 22);
      final due = DateTime.utc(2026, 10, 6, 22);
      expect(
        await cubit.preview(
          taskId: 'task-1',
          newStartAtUtc: start,
          newDueAtUtc: due,
        ),
        isTrue,
      );
      expect(
        await cubit.apply(
          taskId: 'task-1',
          newStartAtUtc: start,
          newDueAtUtc: due,
        ),
        isTrue,
      );
      final preview = repository.previews.single;
      final apply = repository.applies.single;
      expect(preview.calendarTimeZoneId, 'Europe/Warsaw');
      expect(apply.calendarTimeZoneId, preview.calendarTimeZoneId);
      expect(preview.newStartAtUtc, start);
      expect(apply.newDueAtUtc, due);
      expect(PreviewScheduleCascadePayload.fromJson(preview.toJson()), preview);
      expect(ApplyScheduleCascadePayload.fromJson(apply.toJson()), apply);
      expect(preview.toJson()['newStartAtUtc'], '2026-10-05T22:00:00.000Z');
      expect(apply.toJson()['calendarTimeZoneId'], 'Europe/Warsaw');
    },
  );

  test('pierwszy harmonogram zachowuje nullable poprzednie daty w JSON', () {
    final shift = TaskDateShiftResponse.fromJson({
      'taskId': 'task-1',
      'title': 'Nowy harmonogram',
      'currentStartAtUtc': null,
      'currentDueAtUtc': null,
      'proposedStartAtUtc': '2026-10-06T00:00:00.000Z',
      'proposedDueAtUtc': '2026-10-07T00:00:00.000Z',
      'shiftWorkingDays': 0,
      'isOnCriticalPath': false,
      'expectedVersion': 7,
    });
    expect(shift.currentStartAtUtc, isNull);
    expect(shift.currentDueAtUtc, isNull);
    expect(shift.toJson()['currentStartAtUtc'], isNull);
    expect(shift.toJson()['currentDueAtUtc'], isNull);
    expect(TaskDateShiftResponse.fromJson(shift.toJson()), shift);
  });

  test('zmiana dat podczas odczytu odrzuca spóźniony podgląd', () async {
    final pending = Completer<Either<ApiError, ScheduleCascadeResponse>>();
    repository.pendingPreview = pending.future;
    final request = cubit.preview(
      taskId: 'task-1',
      newStartAtUtc: DateTime.utc(2026, 9, 21),
      newDueAtUtc: DateTime.utc(2026, 9, 25),
    );
    cubit.clearPreview();
    pending.complete(Right(_previewWith(taskId: 'task-1', expectedVersion: 7)));
    expect(await request, isFalse);
    expect(cubit.state.preview, isNull);
    expect(cubit.state.isBusy, isFalse);
  });

  test(
    'nie zapisuje kaskady dla dat innych niż zaakceptowany podgląd',
    () async {
      repository.previewResult = Right(
        _previewWith(taskId: 'task-1', expectedVersion: 7),
      );
      await cubit.preview(
        taskId: 'task-1',
        newStartAtUtc: DateTime.utc(2026, 9, 21),
        newDueAtUtc: DateTime.utc(2026, 9, 25),
      );
      expect(
        await cubit.apply(
          taskId: 'task-1',
          newStartAtUtc: DateTime.utc(2026, 10),
          newDueAtUtc: DateTime.utc(2026, 10, 5),
        ),
        isFalse,
      );
      expect(repository.applies, isEmpty);
      expect(cubit.state.apiError?.apiCode, 'task_cascade_preview_stale');
    },
  );

  test(
    'zmiana wersji szkicu uniemożliwia zastosowanie starego podglądu',
    () async {
      repository.previewResult = Right(
        _previewWith(taskId: 'task-1', expectedVersion: 7),
      );
      await cubit.preview(
        taskId: 'task-1',
        newStartAtUtc: DateTime.utc(2026, 9, 21),
        newDueAtUtc: DateTime.utc(2026, 9, 25),
        draftGeneration: 3,
      );
      expect(
        await cubit.apply(
          taskId: 'task-1',
          newStartAtUtc: DateTime.utc(2026, 9, 21),
          newDueAtUtc: DateTime.utc(2026, 9, 25),
          draftGeneration: 4,
        ),
        isFalse,
      );
      expect(repository.applies, isEmpty);
      expect(cubit.state.preview, isNull);
    },
  );

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

  test(
    'błąd podglądu zostaje w stanie i nie udaje aktualnego podglądu',
    () async {
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
    },
  );

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

  test(
    'zmiana dat zdejmuje podgląd, żeby nie opisywał innych terminów',
    () async {
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
    },
  );
}
