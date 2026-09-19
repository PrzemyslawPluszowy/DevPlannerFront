import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_state.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeTaskRecurrenceRepository implements TaskRecurrenceRepository {
  Either<ApiError, List<ProjectTaskRecurrenceItemResponse>> rulesResult =
      const Right([]);
  Either<ApiError, List<ProjectTaskRecurrenceRunResponse>> runsResult =
      const Right([]);
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? pauseResult;
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? resumeResult;
  Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>? runNowResult;

  int pauseCalls = 0;
  int resumeCalls = 0;
  int runNowCalls = 0;

  @override
  Future<Either<ApiError, List<ProjectTaskRecurrenceItemResponse>>>
  getProjectRecurrences({
    required String workspaceId,
    required String projectId,
  }) async => rulesResult;

  @override
  Future<Either<ApiError, List<ProjectTaskRecurrenceRunResponse>>>
  getProjectRecurrenceRuns({
    required String workspaceId,
    required String projectId,
  }) async => runsResult;

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
  Future<Either<ApiError, TaskMutationResponse<TaskRecurrenceResponse>>>
  triggerRunNow({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async {
    runNowCalls++;
    return runNowResult!;
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
}

final class _FakeTaskProjectRealtime implements TaskProjectRealtime {
  final _controller = StreamController<TaskProjectRealtimeUpdate>.broadcast();

  @override
  Stream<TaskProjectRealtimeUpdate> get updates => _controller.stream;

  @override
  Stream<WorkspaceSignalRConnectionState> get connectionStates =>
      const Stream.empty();

  @override
  Stream<WorkspaceScopedRealtimeError> get errors => const Stream.empty();

  void emitUpdate(TaskProjectRealtimeUpdate update) => _controller.add(update);

  @override
  Future<void> start({
    required String workspaceId,
    required String projectId,
  }) async {}

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}

ProjectTaskRecurrenceItemResponse _mockRule({
  String id = 'rule-1',
  String taskId = 'task-1',
  bool isActive = true,
  int version = 1,
}) => ProjectTaskRecurrenceItemResponse(
  id: id,
  workspaceId: 'w-1',
  projectId: 'p-1',
  sourceTaskId: taskId,
  taskKey: 'TSK-1',
  taskTitle: 'Zadanie cykliczne',
  taskStatus: ProjectTaskStatus.todo,
  priority: TaskPriority.normal,
  mode: TaskRecurrenceMode.scheduled,
  frequency: TaskRecurrenceFrequency.weekly,
  interval: 1,
  timeZoneId: 'Europe/Warsaw',
  occurrenceStatus: ProjectTaskStatus.todo,
  skipIfPreviousOpen: true,
  isActive: isActive,
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  version: version,
);

ProjectTaskRecurrenceRunResponse _mockRun({
  String id = 'run-1',
  String ruleId = 'rule-1',
  String taskId = 'task-1',
}) => ProjectTaskRecurrenceRunResponse(
  id: id,
  recurrenceRuleId: ruleId,
  sourceTaskId: taskId,
  taskKey: 'TSK-1',
  taskTitle: 'Zadanie cykliczne',
  scheduledAtUtc: DateTime.utc(2026, 1, 8, 9),
  executedAtUtc: DateTime.utc(2026, 1, 8, 9, 1),
  outcome: TaskRecurrenceRunOutcome.created,
  createdTaskId: 'task-2',
  createdTaskKey: 'TSK-2',
);

TaskMutationResponse<TaskRecurrenceResponse> _mockMutation({
  bool isActive = true,
  int version = 2,
}) => TaskMutationResponse(
  taskId: 'task-1',
  taskVersion: version,
  taskUpdatedAtUtc: DateTime.utc(2026, 1, 2),
  data: TaskRecurrenceResponse(
    id: 'rule-1',
    workspaceId: 'w-1',
    projectId: 'p-1',
    sourceTaskId: 'task-1',
    mode: TaskRecurrenceMode.scheduled,
    frequency: TaskRecurrenceFrequency.weekly,
    interval: 1,
    timeZoneId: 'Europe/Warsaw',
    occurrenceStatus: ProjectTaskStatus.todo,
    skipIfPreviousOpen: true,
    isActive: isActive,
    createdAtUtc: DateTime.utc(2026),
    updatedAtUtc: DateTime.utc(2026, 1, 2),
    version: version,
  ),
);

void main() {
  late _FakeTaskRecurrenceRepository repository;
  late _FakeTaskProjectRealtime realtime;
  late ProjectRecurrencesCubit cubit;

  setUp(() {
    repository = _FakeTaskRecurrenceRepository();
    realtime = _FakeTaskProjectRealtime();
    cubit = ProjectRecurrencesCubit(
      repository: repository,
      workspaceId: 'w-1',
      projectId: 'p-1',
      realtime: realtime,
    );
  });

  tearDown(() async {
    await cubit.close();
    await realtime.dispose();
  });

  test('Stan początkowy to ProjectRecurrencesInitial', () {
    expect(cubit.state, const ProjectRecurrencesInitial());
  });

  test(
    'load() emituje Loading a następnie Loaded z regułami i historią',
    () async {
      final rules = [_mockRule()];
      final runs = [_mockRun()];
      repository.rulesResult = Right(rules);
      repository.runsResult = Right(runs);

      final future = cubit.load();
      await future;

      expect(
        cubit.state,
        ProjectRecurrencesLoaded(rules: rules, runs: runs),
      );
    },
  );

  test('togglePause wstrzymuje aktywną regułę', () async {
    final rule = _mockRule();
    repository.rulesResult = Right([rule]);
    repository.runsResult = const Right([]);
    repository.pauseResult = Right(_mockMutation(isActive: false));

    await cubit.load();
    final success = await cubit.togglePause(rule);

    expect(success, isTrue);
    expect(repository.pauseCalls, 1);
  });

  test('togglePause wznawia wstrzymaną regułę', () async {
    final rule = _mockRule(isActive: false);
    repository.rulesResult = Right([rule]);
    repository.runsResult = const Right([]);
    repository.resumeResult = Right(_mockMutation());

    await cubit.load();
    final success = await cubit.togglePause(rule);

    expect(success, isTrue);
    expect(repository.resumeCalls, 1);
  });

  test('triggerRunNow wywołuje natychmiastowe wystąpienie serii', () async {
    final rule = _mockRule();
    repository.rulesResult = Right([rule]);
    repository.runsResult = const Right([]);
    repository.runNowResult = Right(_mockMutation());

    await cubit.load();
    final success = await cubit.triggerRunNow(rule);

    expect(success, isTrue);
    expect(repository.runNowCalls, 1);
  });

  test('Zdarzenie realtime automatycznie przeładowuje dane', () async {
    repository.rulesResult = Right([_mockRule()]);
    repository.runsResult = const Right([]);
    await cubit.load();

    expect((cubit.state as ProjectRecurrencesLoaded).rules.length, 1);

    // Zmiana danych po stronie repozytorium
    repository.rulesResult = Right([_mockRule(), _mockRule(id: 'rule-2')]);

    // Emisja zdarzenia realtime
    realtime.emitUpdate(
      TaskRealtimeMutation(
        eventId: 'evt-1',
        type: TaskRealtimeMutationType.recurrenceChanged,
        workspaceId: 'w-1',
        projectId: 'p-1',
        taskId: 'task-1',
        number: 1,
        key: 'TSK-1',
        version: 2,
        occurredAtUtc: DateTime.utc(2026, 9, 1, 12),
        isReplay: false,
      ),
    );

    await pumpEventQueue();

    expect((cubit.state as ProjectRecurrencesLoaded).rules.length, 2);
  });
}
