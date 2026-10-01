import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/task_recurrence_editor_loaded_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeTaskRecurrenceRepository implements TaskRecurrenceRepository {
  Either<ApiError, TaskRecurrenceResponse>? getResult;
  Future<Either<ApiError, TaskRecurrenceResponse>>? pendingGet;
  UpdateTaskRecurrencePayload? latestUpdatePayload;
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
  Future<Either<ApiError, List<String>>> listSupportedTimeZones({
    required String workspaceId,
    required String projectId,
  }) async => const Right([]);

  @override
  Future<Either<ApiError, TaskRecurrenceResponse>> get({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) => pendingGet ?? Future.value(getResult!);

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
    latestUpdatePayload = payload;
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

  test('existing recurrence never creates a new rule while GET is pending or failed', () async {
    final pending = Completer<Either<ApiError, TaskRecurrenceResponse>>();
    repository.pendingGet = pending.future;
    repository.createResult = const Left(
      ApiError(type: ApiErrorType.conflict, message: 'unexpected create'),
    );
    final cubit = TaskRecurrenceEditorCubit(
      repository: repository,
      workspaceId: 'ws-1',
      projectId: 'proj-1',
      taskId: 'task-1',
      taskVersion: 1,
      hasRecurrence: true,
    );
    await cubit.save();
    expect(repository.createCalls, 0);
    pending.complete(
      const Left(ApiError(type: ApiErrorType.server, message: 'load failed')),
    );
    await Future<void>.delayed(Duration.zero);
    await cubit.save();
    expect(repository.createCalls, 0);
    await cubit.close();
  });

  test('saving retains existing rule timezone and converts selected local time to UTC', () async {
    repository.getResult = Right(
      _createDummyRecurrence().copyWith(timeZoneId: 'UTC'),
    );
    repository.updateResult = Right(_createDummyMutation());
    final cubit = TaskRecurrenceEditorCubit(
      repository: repository,
      workspaceId: 'ws-1',
      projectId: 'proj-1',
      taskId: 'task-1',
      taskVersion: 1,
      hasRecurrence: true,
    );
    await Future<void>.delayed(Duration.zero);
    cubit.setScheduledDate(DateTime(2026, 9, 8));
    cubit.setScheduledTime(
      const TaskRecurrenceScheduledTime(hour: 11, minute: 30),
    );
    await cubit.save();
    expect(repository.latestUpdatePayload?.timeZoneId, 'UTC');
    expect(
      repository.latestUpdatePayload?.nextOccurrenceAtUtc,
      DateTime(2026, 9, 8, 11, 30).toUtc(),
    );
    await cubit.close();
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
    '409 zachowuje szkic i szczegóły błędu, ponowienie zapisuje raz',
    () async {
      final conflict = ApiError(
        type: ApiErrorType.conflict,
        message: 'Reguła została zmieniona.',
        statusCode: 409,
        contractCode: 'task_recurrence_version_conflict',
        fields: const {
          'interval': ['Wartość jest nieaktualna.'],
        },
        traceId: 'trace-recurrence-409',
        retryAfterUtc: DateTime.utc(2026, 10, 1, 12),
      );
      repository.createResult = Left(conflict);
      final cubit = TaskRecurrenceEditorCubit(
        repository: repository,
        workspaceId: 'ws-1',
        projectId: 'proj-1',
        taskId: 'task-1',
        taskVersion: 1,
        hasRecurrence: false,
      );
      final chosenDate = DateTime(2026, 10, 4);
      cubit.setScheduledDate(chosenDate);
      cubit.setInterval(3);

      final first = cubit.save();
      final duplicate = cubit.save();
      await Future.wait([first, duplicate]);

      final loaded = cubit.state as TaskRecurrenceEditorLoaded;
      expect(repository.createCalls, 1);
      expect(loaded.apiError, conflict);
      expect(loaded.errorOperation, TaskRecurrenceEditorErrorOperation.create);
      expect(loaded.interval, 3);
      expect(loaded.scheduledDate, chosenDate);

      repository.createResult = Right(_createDummyMutation());
      await cubit.save();
      expect(repository.createCalls, 2);
      expect(cubit.state, isA<TaskRecurrenceEditorSuccess>());
      await cubit.close();
    },
  );

  test(
    'wybrana lokalna godzina jest wysyłana jako ten sam moment UTC',
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
      expect(
        payload!.firstOccurrenceAtUtc,
        DateTime(2026, 9, 18, 14, 35).toUtc(),
      );
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

  testWidgets('409 jest widoczny w recurrence editorze wraz ze szkicem', (
    tester,
  ) async {
    final conflict = ApiError(
      type: ApiErrorType.conflict,
      message: 'Rule changed on the server.',
      statusCode: 409,
      contractCode: 'task_recurrence_conflict',
      fields: const {
        'interval': ['The rule was updated.'],
      },
      traceId: 'recurrence-trace-409',
      retryAfterUtc: DateTime.utc(2026, 10, 1, 12),
    );
    repository.createResult = Left(conflict);
    final cubit = TaskRecurrenceEditorCubit(
      repository: repository,
      workspaceId: 'ws-1',
      projectId: 'proj-1',
      taskId: 'task-1',
      taskVersion: 1,
      hasRecurrence: false,
    );
    addTearDown(cubit.close);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: MaterialTheme.crm().light(),
        home: TaskDetailsModalTheme(
          child: BlocProvider.value(
            value: cubit,
            child: Scaffold(
              body:
                  BlocBuilder<
                    TaskRecurrenceEditorCubit,
                    TaskRecurrenceEditorState
                  >(
                    builder: (context, state) =>
                        state is TaskRecurrenceEditorLoaded
                        ? TaskRecurrenceEditorLoadedContent(
                            state: state,
                            cubit: cubit,
                          )
                        : const SizedBox.shrink(),
                  ),
            ),
          ),
        ),
      ),
    );
    final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)))!;
    await tester.tap(find.text(l10n.taskRecurrencePresetCustom));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '3');
    await tester.tap(find.text(l10n.taskRecurrenceSave));
    await tester.pumpAndSettle();

    expect(find.byType(TaskDetailsModalError), findsOneWidget);
    final loaded = cubit.state as TaskRecurrenceEditorLoaded;
    expect(loaded.apiError, conflict);
    expect(loaded.interval, 3);
    expect(find.textContaining('task_recurrence_conflict'), findsOneWidget);
    expect(find.textContaining('recurrence-trace-409'), findsOneWidget);
    expect(find.textContaining('The rule was updated.'), findsOneWidget);
  });
}
