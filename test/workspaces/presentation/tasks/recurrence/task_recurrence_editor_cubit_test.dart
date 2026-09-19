import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_state.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeTaskRecurrenceRepository implements TaskRecurrenceRepository {
  Either<ApiError, TaskRecurrenceResponse>? getResult;
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? createResult;
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? updateResult;
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? pauseResult;
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? resumeResult;

  int createCalls = 0;
  int updateCalls = 0;
  int pauseCalls = 0;
  int resumeCalls = 0;
  CreateTaskRecurrencePayload? latestCreatePayload;

  @override
  Future<Either<ApiError, TaskRecurrenceResponse>> get({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async => getResult!;

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  create({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskRecurrencePayload payload,
  }) async {
    createCalls++;
    latestCreatePayload = payload;
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
    updateCalls++;
    return updateResult!;
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>> pause({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  }) async {
    pauseCalls++;
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
    resumeCalls++;
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
  }) async => throw UnimplementedError();
}

TaskRecurrenceResponse _createDummyRecurrence() => TaskRecurrenceResponse(
  id: 'rule-1',
  workspaceId: 'ws-1',
  projectId: 'proj-1',
  sourceTaskId: 'task-1',
  mode: TaskRecurrenceMode.scheduled,
  frequency: TaskRecurrenceFrequency.weekly,
  interval: 1,
  timeZoneId: 'Europe/Warsaw',
  nextOccurrenceAtUtc: DateTime.utc(2026, 9, 8, 9),
  occurrenceStatus: ProjectTaskStatus.todo,
  skipIfPreviousOpen: true,
  isActive: true,
  version: 1,
  createdAtUtc: DateTime.utc(2026, 9),
  updatedAtUtc: DateTime.utc(2026, 9),
);

TaskMutationResponse<TaskRecurrenceResponse> _createDummyMutation({
  bool isActive = true,
  int version = 2,
}) => TaskMutationResponse(
  taskId: 'task-1',
  taskVersion: version,
  taskUpdatedAtUtc: DateTime.utc(2026, 9),
  data: TaskRecurrenceResponse(
    id: 'rule-1',
    workspaceId: 'ws-1',
    projectId: 'proj-1',
    sourceTaskId: 'task-1',
    mode: TaskRecurrenceMode.scheduled,
    frequency: TaskRecurrenceFrequency.weekly,
    interval: 1,
    timeZoneId: 'Europe/Warsaw',
    occurrenceStatus: ProjectTaskStatus.todo,
    skipIfPreviousOpen: true,
    isActive: isActive,
    createdAtUtc: DateTime.utc(2026, 9),
    updatedAtUtc: DateTime.utc(2026, 9),
    version: version,
  ),
);

void main() {
  late _FakeTaskRecurrenceRepository repository;

  setUp(() {
    repository = _FakeTaskRecurrenceRepository();
  });

  test(
    'Inicjalizacja dla zadania bez istniejącej serii ustawia stan domyślny',
    () {
      final cubit = TaskRecurrenceEditorCubit(
        repository: repository,
        workspaceId: 'ws-1',
        projectId: 'proj-1',
        taskId: 'task-1',
        taskVersion: 1,
        hasRecurrence: false,
      );

      expect(cubit.state, isA<TaskRecurrenceEditorLoaded>());
      final loaded = cubit.state as TaskRecurrenceEditorLoaded;
      expect(loaded.hasRecurrence, isFalse);
      expect(loaded.preset, TaskRecurrencePreset.weekly);
      expect(loaded.frequency, TaskRecurrenceFrequency.weekly);
      expect(loaded.interval, 1);
    },
  );

  test('Zmiana presetu modyfikuje frequency i interval', () {
    final cubit = TaskRecurrenceEditorCubit(
      repository: repository,
      workspaceId: 'ws-1',
      projectId: 'proj-1',
      taskId: 'task-1',
      taskVersion: 1,
      hasRecurrence: false,
    );

    cubit.setPreset(TaskRecurrencePreset.daily);
    var loaded = cubit.state as TaskRecurrenceEditorLoaded;
    expect(loaded.preset, TaskRecurrencePreset.daily);
    expect(loaded.frequency, TaskRecurrenceFrequency.daily);
    expect(loaded.interval, 1);

    cubit.setPreset(TaskRecurrencePreset.monthly);
    loaded = cubit.state as TaskRecurrenceEditorLoaded;
    expect(loaded.preset, TaskRecurrencePreset.monthly);
    expect(loaded.frequency, TaskRecurrenceFrequency.monthly);
    expect(loaded.interval, 1);
  });

  test('save() dla nowego zadania wywołuje create i emituje Success', () async {
    repository.createResult = Right(_createDummyMutation());

    final cubit = TaskRecurrenceEditorCubit(
      repository: repository,
      workspaceId: 'ws-1',
      projectId: 'proj-1',
      taskId: 'task-1',
      taskVersion: 1,
      hasRecurrence: false,
    );

    await cubit.save();

    expect(repository.createCalls, 1);
    expect(cubit.state, isA<TaskRecurrenceEditorSuccess>());
    final success = cubit.state as TaskRecurrenceEditorSuccess;
    expect(success.mutationResult.data.id, 'rule-1');
  });

  test(
    'zapis UTC używa niezależnego od Fluttera value object godziny',
    () async {
      repository.createResult = Right(_createDummyMutation());
      final cubit = TaskRecurrenceEditorCubit(
        repository: repository,
        workspaceId: 'ws-1',
        projectId: 'proj-1',
        taskId: 'task-1',
        taskVersion: 1,
        hasRecurrence: false,
      );

      cubit.setScheduledDate(DateTime(2026, 9, 18));
      cubit.setScheduledTime(
        const TaskRecurrenceScheduledTime(hour: 14, minute: 35),
      );
      await cubit.save();

      final payload = repository.latestCreatePayload;
      expect(payload, isNotNull);
      expect(payload!.firstOccurrenceAtUtc, DateTime.utc(2026, 9, 18, 14, 35));
      await cubit.close();
    },
  );

  test('toggleActive wstrzymuje regułę i emituje Success', () async {
    final rec = _createDummyRecurrence();
    repository.getResult = Right(rec);
    repository.pauseResult = Right(_createDummyMutation(isActive: false));

    final cubit = TaskRecurrenceEditorCubit(
      repository: repository,
      workspaceId: 'ws-1',
      projectId: 'proj-1',
      taskId: 'task-1',
      taskVersion: 1,
      hasRecurrence: true,
    );

    // poczekaj na _fetchFullRecurrence
    await Future<void>.delayed(const Duration(milliseconds: 10));

    await cubit.toggleActive();

    expect(repository.pauseCalls, 1);
    expect(cubit.state, isA<TaskRecurrenceEditorSuccess>());
  });
}
