import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_acceptance_criteria_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_checklist_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_state.dart';
import 'package:flutter_test/flutter_test.dart';

final class _TasksRepository implements TasksRepository {
  _TasksRepository(this.result);

  Either<ApiError, ProjectTaskDetailsResponse> result;
  Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>? updateResult;
  Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>? createResult;
  QuickCreateProjectTaskPayload? createPayload;
  UpdateProjectTaskPayload? updatePayload;
  Either<ApiError, TaskMutationResponse<TaskDependencyResponse>>?
  createDependencyResult;
  Either<ApiError, TaskMutationResponse<TaskDependencyResponse>>?
  updateDependencyResult;
  Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>?
  deleteDependencyResult;
  CreateTaskDependencyPayload? createDependencyPayload;
  UpdateTaskDependencyPayload? updateDependencyPayload;
  int? deleteDependencyExpectedVersion;
  int getCalls = 0;

  @override
  Future<Either<ApiError, ProjectTaskDetailsResponse>> getTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async {
    getCalls++;
    return result;
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskDependencyResponse>>>
  updateDependency({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String dependencyId,
    required UpdateTaskDependencyPayload payload,
  }) async {
    updateDependencyPayload = payload;
    return updateDependencyResult!;
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  updateTask({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required UpdateProjectTaskPayload payload,
  }) async {
    updatePayload = payload;
    return updateResult!;
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  quickCreateTask({
    required String workspaceId,
    required String projectId,
    required QuickCreateProjectTaskPayload payload,
  }) async {
    createPayload = payload;
    return createResult!;
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskDependencyResponse>>>
  createDependency({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskDependencyPayload payload,
  }) async {
    createDependencyPayload = payload;
    return createDependencyResult!;
  }

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  deleteDependency({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String dependencyId,
    required int expectedVersion,
  }) async {
    deleteDependencyExpectedVersion = expectedVersion;
    return deleteDependencyResult!;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _TaskChecklistRepository implements TaskChecklistRepository {
  Either<ApiError, TaskMutationResponse<TaskChecklistItemResponse>>? addResult;
  Either<ApiError, TaskMutationResponse<TaskChecklistItemResponse>>?
  updateResult;
  Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>?
  deleteResult;
  CreateTaskChecklistItemPayload? addPayload;
  UpdateTaskChecklistItemPayload? updatePayload;
  int? deleteExpectedVersion;

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskChecklistItemResponse>>>
  addItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskChecklistItemPayload payload,
  }) async {
    addPayload = payload;
    return addResult!;
  }

  @override
  Future<Either<ApiError, TaskMutationResponse<TaskChecklistItemResponse>>>
  updateItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String itemId,
    required UpdateTaskChecklistItemPayload payload,
  }) async {
    updatePayload = payload;
    return updateResult!;
  }

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  deleteItem({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String itemId,
    required int expectedVersion,
  }) async {
    deleteExpectedVersion = expectedVersion;
    return deleteResult!;
  }
}

final class _TaskAcceptanceCriteriaRepository
    implements TaskAcceptanceCriteriaRepository {
  Either<ApiError, TaskMutationResponse<TaskAcceptanceCriterionResponse>>?
  createResult;
  Either<ApiError, TaskMutationResponse<TaskAcceptanceCriterionResponse>>?
  updateResult;
  Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>?
  deleteResult;
  CreateTaskAcceptanceCriterionPayload? createPayload;
  UpdateTaskAcceptanceCriterionPayload? updatePayload;
  int? deleteExpectedVersion;

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskAcceptanceCriterionResponse>>
  >
  create({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required CreateTaskAcceptanceCriterionPayload payload,
  }) async {
    createPayload = payload;
    return createResult!;
  }

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskAcceptanceCriterionResponse>>
  >
  update({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String criterionId,
    required UpdateTaskAcceptanceCriterionPayload payload,
  }) async {
    updatePayload = payload;
    return updateResult!;
  }

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  delete({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String criterionId,
    required int expectedVersion,
  }) async {
    deleteExpectedVersion = expectedVersion;
    return deleteResult!;
  }
}

final class _TaskCollaborationRepository
    implements TaskCollaborationRepository {
  Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>?
  followResult;
  Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>?
  unfollowResult;
  int followCalls = 0;
  int unfollowCalls = 0;
  bool? pinnedValue;
  Either<ApiError, Unit>? pinnedResult;
  Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>?
  replaceAssigneesResult;
  List<String>? replacedAssigneeIds;
  int? replaceAssigneesExpectedVersion;

  @override
  Future<Either<ApiError, TaskMutationResponse<ProjectTaskResponse>>>
  replaceAssignees({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required List<String> userIds,
    required int expectedVersion,
  }) async {
    replacedAssigneeIds = userIds;
    replaceAssigneesExpectedVersion = expectedVersion;
    return replaceAssigneesResult!;
  }

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  follow({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  }) async {
    followCalls++;
    return followResult!;
  }

  @override
  Future<Either<ApiError, List<TaskWatcherResponse>>> listWatchers({
    required String workspaceId,
    required String projectId,
    required String taskId,
  }) async => const Right([]);

  @override
  Future<
    Either<ApiError, TaskMutationResponse<TaskMutationAcknowledgementResponse>>
  >
  unfollow({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required int expectedVersion,
  }) async {
    unfollowCalls++;
    return unfollowResult!;
  }

  @override
  Future<Either<ApiError, Unit>> updatePinned({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required bool isPinned,
  }) async {
    pinnedValue = isPinned;
    return pinnedResult!;
  }
}

final class _TaskMetadataRepository implements TaskMetadataRepository {
  Either<ApiError, List<TaskLabelResponse>> labelsResult = const Right([]);
  Either<ApiError, TaskMutationResponse<List<TaskLabelResponse>>>?
  replaceLabelsResult;
  ReplaceTaskLabelsPayload? replaceLabelsPayload;
  Either<ApiError, TaskMutationResponse<List<TaskCustomFieldValueResponse>>>?
  replaceCustomFieldsResult;
  ReplaceTaskCustomFieldValuesPayload? replaceCustomFieldsPayload;

  @override
  Future<Either<ApiError, List<TaskLabelResponse>>> listLabels({
    required String workspaceId,
    required String projectId,
  }) async => labelsResult;

  @override
  Future<Either<ApiError, TaskLabelResponse>> createLabel({
    required String workspaceId,
    required String projectId,
    required CreateTaskLabelPayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskLabelResponse>> updateLabel({
    required String workspaceId,
    required String projectId,
    required String labelId,
    required UpdateTaskLabelPayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, Unit>> archiveLabel({
    required String workspaceId,
    required String projectId,
    required String labelId,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, List<TaskCustomFieldResponse>>> listCustomFields({
    required String workspaceId,
    required String projectId,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskCustomFieldResponse>> createCustomField({
    required String workspaceId,
    required String projectId,
    required CreateTaskCustomFieldPayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskCustomFieldResponse>> updateCustomField({
    required String workspaceId,
    required String projectId,
    required String fieldId,
    required UpdateTaskCustomFieldPayload payload,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, Unit>> archiveCustomField({
    required String workspaceId,
    required String projectId,
    required String fieldId,
  }) => throw UnimplementedError();

  @override
  Future<Either<ApiError, TaskMutationResponse<List<TaskLabelResponse>>>>
  replaceLabels({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required ReplaceTaskLabelsPayload payload,
  }) async {
    replaceLabelsPayload = payload;
    return replaceLabelsResult!;
  }

  @override
  Future<
    Either<ApiError, TaskMutationResponse<List<TaskCustomFieldValueResponse>>>
  >
  replaceCustomFieldValues({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required ReplaceTaskCustomFieldValuesPayload payload,
  }) async {
    replaceCustomFieldsPayload = payload;
    return replaceCustomFieldsResult!;
  }
}

ProjectTaskDetailsResponse _details() => ProjectTaskDetailsResponse(
  task: ProjectTaskResponse(
    id: 'task-1',
    number: 1,
    key: 'TASK-1',
    workspaceId: 'workspace-1',
    projectId: 'project-1',
    title: 'Pierwsze zadanie',
    status: ProjectTaskStatus.todo,
    priority: TaskPriority.normal,
    taskType: 'Task',
    position: 100,
    createdByUserId: 'user-1',
    assignees: [],
    checklistItems: [],
    createdAtUtc: DateTime.utc(2026, 8, 26),
    updatedAtUtc: DateTime.utc(2026, 8, 26),
    version: 1,
  ),
  labels: [],
  customFields: [],
  acceptanceCriteria: [],
  dependencies: [],
  watchers: [],
  isWatchedByMe: false,
  isPinnedByMe: false,
  subtasks: [],
  workflow: const ProjectTaskWorkflowResponse(
    statuses: [],
    transitions: [],
    version: 1,
  ),
  includedUsers: [],
);

void main() {
  test('ładuje pełny agregat szczegółów zadania', () async {
    final cubit = TaskDetailsCubit(
      repository: _TasksRepository(Right(_details())),
      acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
      checklistRepository: _TaskChecklistRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );

    await cubit.load();

    expect(cubit.state, isA<TaskDetailsReady>());
    expect(
      (cubit.state as TaskDetailsReady).details.task.key,
      'TASK-1',
    );
    await cubit.close();
  });

  test('mapuje 403 na jawny stan forbidden', () async {
    final cubit = TaskDetailsCubit(
      repository: _TasksRepository(
        const Left(
          ApiError(
            type: ApiErrorType.forbidden,
            message: 'Brak uprawnień',
            statusCode: 403,
          ),
        ),
      ),
      acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
      checklistRepository: _TaskChecklistRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );

    await cubit.load();

    expect(cubit.state, isA<TaskDetailsFailure>());
    expect(
      (cubit.state as TaskDetailsFailure).kind,
      TaskDetailsFailureKind.forbidden,
    );
    await cubit.close();
  });

  test(
    'zapisuje podstawowe pola z expectedVersion i przyjmuje nową wersję',
    () async {
      final original = _details();
      final updatedTask = original.task.copyWith(
        title: 'Zmieniony tytuł',
        status: ProjectTaskStatus.inProgress,
        priority: TaskPriority.high,
        version: 2,
      );
      final repository = _TasksRepository(Right(original))
        ..updateResult = Right(
          TaskMutationResponse(
            taskId: updatedTask.id,
            taskVersion: 2,
            taskUpdatedAtUtc: updatedTask.updatedAtUtc,
            data: updatedTask,
          ),
        );
      final cubit = TaskDetailsCubit(
        repository: repository,
        acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
        checklistRepository: _TaskChecklistRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );
      await cubit.load();

      final saved = await cubit.updateBasics(
        title: '  Zmieniony tytuł  ',
        status: ProjectTaskStatus.inProgress,
        priority: TaskPriority.high,
      );

      expect(saved, isTrue);
      expect(repository.updatePayload?.title, 'Zmieniony tytuł');
      expect(repository.updatePayload?.expectedVersion, 1);
      final ready = cubit.state as TaskDetailsReady;
      expect(ready.details.task.version, 2);
      expect(ready.details.task.status, ProjectTaskStatus.inProgress);
      await cubit.close();
    },
  );

  test('tworzy podzadanie z jawnym TargetStatus', () async {
    final original = _details();
    final repository = _TasksRepository(Right(original))
      ..createResult = Right(
        TaskMutationResponse(
          taskId: 'child-1',
          taskVersion: 1,
          taskUpdatedAtUtc: original.task.updatedAtUtc,
          data: original.task.copyWith(id: 'child-1', parentTaskId: 'task-1'),
        ),
      );
    final cubit = TaskDetailsCubit(
      repository: repository,
      acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
      checklistRepository: _TaskChecklistRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    await cubit.load();

    expect(await cubit.createSubtask('  Nowe podzadanie  '), isTrue);
    expect(repository.createPayload?.title, 'Nowe podzadanie');
    expect(repository.createPayload?.parentTaskId, 'task-1');
    expect(repository.createPayload?.targetStatus, ProjectTaskStatus.todo);
    await cubit.close();
  });

  test(
    'po konflikcie pobiera najnowszy agregat i zachowuje komunikat',
    () async {
      final original = _details();
      final refreshed = original.copyWith(
        task: original.task.copyWith(title: 'Zmiana innej osoby', version: 4),
      );
      final repository = _TasksRepository(Right(original))
        ..updateResult = const Left(
          ApiError(
            type: ApiErrorType.conflict,
            message: 'Zadanie zostało zmienione',
            statusCode: 409,
          ),
        );
      final cubit = TaskDetailsCubit(
        repository: repository,
        acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
        checklistRepository: _TaskChecklistRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );
      await cubit.load();
      repository.result = Right(refreshed);

      final saved = await cubit.updateBasics(
        title: 'Moja zmiana',
        status: ProjectTaskStatus.todo,
        priority: TaskPriority.normal,
      );
      await Future<void>.delayed(Duration.zero);

      expect(saved, isFalse);
      expect(repository.getCalls, 2);
      final ready = cubit.state as TaskDetailsReady;
      expect(ready.details.task.title, 'Zmiana innej osoby');
      expect(ready.details.task.version, 4);
      expect(ready.mutationError, 'Zadanie zostało zmienione');
      expect(ready.mutationSerial, 1);
      await cubit.close();
    },
  );

  test('zapisuje terminy i estymację bez utraty pozostałych pól', () async {
    final original = _details();
    final start = DateTime.utc(2026, 9);
    final due = DateTime.utc(2026, 9, 5);
    final updatedTask = original.task.copyWith(
      startAtUtc: start,
      dueAtUtc: due,
      estimatedMinutes: 480,
      version: 2,
    );
    final repository = _TasksRepository(Right(original))
      ..updateResult = Right(
        TaskMutationResponse(
          taskId: updatedTask.id,
          taskVersion: 2,
          taskUpdatedAtUtc: updatedTask.updatedAtUtc,
          data: updatedTask,
        ),
      );
    final cubit = TaskDetailsCubit(
      repository: repository,
      acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
      checklistRepository: _TaskChecklistRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    await cubit.load();

    final saved = await cubit.updatePlanning(
      startAtUtc: start,
      dueAtUtc: due,
      estimatedMinutes: 480,
    );

    expect(saved, isTrue);
    expect(repository.updatePayload?.title, original.task.title);
    expect(repository.updatePayload?.status, original.task.status);
    expect(repository.updatePayload?.startAtUtc, start);
    expect(repository.updatePayload?.dueAtUtc, due);
    expect(repository.updatePayload?.estimatedMinutes, 480);
    expect(repository.updatePayload?.expectedVersion, 1);
    await cubit.close();
  });

  test('zapisuje opis Delta z aktualną wersją zadania', () async {
    final original = _details();
    final updatedTask = original.task.copyWith(
      description: 'Opis z formatowaniem',
      descriptionDeltaJson: '[{"insert":"Opis z formatowaniem\\n"}]',
      version: 2,
    );
    final repository = _TasksRepository(Right(original))
      ..updateResult = Right(
        TaskMutationResponse(
          taskId: updatedTask.id,
          taskVersion: updatedTask.version,
          taskUpdatedAtUtc: updatedTask.updatedAtUtc,
          data: updatedTask,
        ),
      );
    final cubit = TaskDetailsCubit(
      repository: repository,
      acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
      checklistRepository: _TaskChecklistRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    await cubit.load();

    final saved = await cubit.updateDescription(
      description: ' Opis z formatowaniem ',
      descriptionDeltaJson: '[{"insert":"Opis z formatowaniem\\n"}]',
    );

    expect(saved, isTrue);
    expect(repository.updatePayload?.description, 'Opis z formatowaniem');
    expect(
      repository.updatePayload?.descriptionDeltaJson,
      '[{"insert":"Opis z formatowaniem\\n"}]',
    );
    expect(repository.updatePayload?.expectedVersion, 1);
    expect((cubit.state as TaskDetailsReady).details.task.version, 2);
    await cubit.close();
  });

  test('odrzuca niepoprawny zakres dat bez wywołania backendu', () async {
    final repository = _TasksRepository(Right(_details()));
    final cubit = TaskDetailsCubit(
      repository: repository,
      acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
      checklistRepository: _TaskChecklistRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    await cubit.load();

    final saved = await cubit.updatePlanning(
      startAtUtc: DateTime.utc(2026, 9, 5),
      dueAtUtc: DateTime.utc(2026, 9),
      estimatedMinutes: 60,
    );

    expect(saved, isFalse);
    expect(repository.updatePayload, isNull);
    expect(cubit.state, isA<TaskDetailsReady>());
    await cubit.close();
  });

  test('dodaje, przełącza i usuwa checklistę z kolejnymi wersjami', () async {
    final now = DateTime.utc(2026, 8, 26);
    final openItem = TaskChecklistItemResponse(
      id: 'check-1',
      title: 'Sprawdzić umowę',
      position: 100,
      isCompleted: false,
      updatedAtUtc: now,
    );
    final completedItem = openItem.copyWith(
      isCompleted: true,
      completedAtUtc: now,
    );
    final checklistRepository = _TaskChecklistRepository()
      ..addResult = Right(
        TaskMutationResponse(
          taskId: 'task-1',
          taskVersion: 2,
          taskUpdatedAtUtc: now,
          data: openItem,
        ),
      )
      ..updateResult = Right(
        TaskMutationResponse(
          taskId: 'task-1',
          taskVersion: 3,
          taskUpdatedAtUtc: now,
          data: completedItem,
        ),
      )
      ..deleteResult = Right(
        TaskMutationResponse(
          taskId: 'task-1',
          taskVersion: 4,
          taskUpdatedAtUtc: now,
          data: const TaskMutationAcknowledgementResponse(changed: true),
        ),
      );
    final cubit = TaskDetailsCubit(
      repository: _TasksRepository(Right(_details())),
      acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
      checklistRepository: checklistRepository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    await cubit.load();

    expect(await cubit.addChecklistItem('  Sprawdzić umowę  '), isTrue);
    var ready = cubit.state as TaskDetailsReady;
    expect(checklistRepository.addPayload?.title, 'Sprawdzić umowę');
    expect(checklistRepository.addPayload?.expectedVersion, 1);
    expect(ready.details.task.checklistItems.single.id, 'check-1');
    expect(ready.details.task.version, 2);

    expect(await cubit.toggleChecklistItem(openItem), isTrue);
    ready = cubit.state as TaskDetailsReady;
    expect(checklistRepository.updatePayload?.isCompleted, isTrue);
    expect(checklistRepository.updatePayload?.expectedVersion, 2);
    expect(ready.details.task.checklistItems.single.isCompleted, isTrue);
    expect(ready.details.task.version, 3);

    expect(await cubit.deleteChecklistItem(completedItem), isTrue);
    ready = cubit.state as TaskDetailsReady;
    expect(checklistRepository.deleteExpectedVersion, 3);
    expect(ready.details.task.checklistItems, isEmpty);
    expect(ready.details.task.version, 4);
    await cubit.close();
  });

  test(
    'dodaje, akceptuje i usuwa kryterium z kolejnymi wersjami',
    () async {
      final now = DateTime.utc(2026, 8, 26);
      final pending = TaskAcceptanceCriterionResponse(
        id: 'criterion-1',
        text: 'Raport został zatwierdzony',
        position: 100,
        isAccepted: false,
        updatedAtUtc: now,
      );
      final accepted = pending.copyWith(
        isAccepted: true,
        acceptedAtUtc: now,
      );
      final criteriaRepository = _TaskAcceptanceCriteriaRepository()
        ..createResult = Right(
          TaskMutationResponse(
            taskId: 'task-1',
            taskVersion: 2,
            taskUpdatedAtUtc: now,
            data: pending,
          ),
        )
        ..updateResult = Right(
          TaskMutationResponse(
            taskId: 'task-1',
            taskVersion: 3,
            taskUpdatedAtUtc: now,
            data: accepted,
          ),
        )
        ..deleteResult = Right(
          TaskMutationResponse(
            taskId: 'task-1',
            taskVersion: 4,
            taskUpdatedAtUtc: now,
            data: const TaskMutationAcknowledgementResponse(changed: true),
          ),
        );
      final cubit = TaskDetailsCubit(
        repository: _TasksRepository(Right(_details())),
        acceptanceCriteriaRepository: criteriaRepository,
        checklistRepository: _TaskChecklistRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );
      await cubit.load();

      expect(
        await cubit.addAcceptanceCriterion(' Raport został zatwierdzony '),
        isTrue,
      );
      var ready = cubit.state as TaskDetailsReady;
      expect(criteriaRepository.createPayload?.expectedVersion, 1);
      expect(ready.details.acceptanceCriteria.single.id, 'criterion-1');
      expect(ready.details.task.version, 2);

      expect(await cubit.toggleAcceptanceCriterion(pending), isTrue);
      ready = cubit.state as TaskDetailsReady;
      expect(criteriaRepository.updatePayload?.isAccepted, isTrue);
      expect(criteriaRepository.updatePayload?.expectedVersion, 2);
      expect(ready.details.acceptanceCriteria.single.isAccepted, isTrue);
      expect(ready.details.task.version, 3);

      expect(await cubit.deleteAcceptanceCriterion(accepted), isTrue);
      ready = cubit.state as TaskDetailsReady;
      expect(criteriaRepository.deleteExpectedVersion, 3);
      expect(ready.details.acceptanceCriteria, isEmpty);
      expect(ready.details.task.version, 4);
      await cubit.close();
    },
  );

  test(
    'tworzy zależność i odświeża pełny agregat po odpowiedzi backendu',
    () async {
      final now = DateTime.utc(2026, 8, 26);
      final original = _details();
      final dependency = TaskDependencyDetailsResponse(
        id: 'dependency-1',
        sourceTaskId: 'task-1',
        targetTaskId: 'task-2',
        type: TaskDependencyType.blocks,
        createdAtUtc: now,
        relatedTask: const ProjectTaskReferenceResponse(
          id: 'task-2',
          number: 2,
          key: 'TASK-2',
          title: 'Zadanie blokujące',
          status: ProjectTaskStatus.todo,
          version: 1,
        ),
      );
      final refreshed = original.copyWith(
        task: original.task.copyWith(version: 2),
        dependencies: [dependency],
      );
      final repository = _TasksRepository(Right(original))
        ..createDependencyResult = Right(
          TaskMutationResponse(
            taskId: 'task-1',
            taskVersion: 2,
            taskUpdatedAtUtc: now,
            data: TaskDependencyResponse(
              id: 'dependency-1',
              sourceTaskId: 'task-1',
              targetTaskId: 'task-2',
              type: TaskDependencyType.blocks,
              createdAtUtc: now,
            ),
          ),
        );
      final cubit = TaskDetailsCubit(
        repository: repository,
        acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
        checklistRepository: _TaskChecklistRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );
      await cubit.load();
      repository.result = Right(refreshed);

      expect(
        await cubit.createDependency(
          targetTaskId: 'task-2',
          type: TaskDependencyType.blocks,
        ),
        isTrue,
      );
      final ready = cubit.state as TaskDetailsReady;
      expect(repository.createDependencyPayload?.targetTaskId, 'task-2');
      expect(repository.createDependencyPayload?.expectedVersion, 1);
      expect(repository.getCalls, 2);
      expect(ready.details.dependencies.single.relatedTask.key, 'TASK-2');
      await cubit.close();
    },
  );

  test(
    'edytuje rodzaj oraz lag zależności z aktualną wersją zadania',
    () async {
      final now = DateTime.utc(2026, 8, 26);
      final dependency = TaskDependencyDetailsResponse(
        id: 'dependency-1',
        sourceTaskId: 'task-1',
        targetTaskId: 'task-2',
        type: TaskDependencyType.blocks,
        createdAtUtc: now,
        relatedTask: const ProjectTaskReferenceResponse(
          id: 'task-2',
          number: 2,
          key: 'TASK-2',
          title: 'Zależne zadanie',
          status: ProjectTaskStatus.todo,
          version: 1,
        ),
      );
      final initial = _details().copyWith(dependencies: [dependency]);
      final repository = _TasksRepository(Right(initial))
        ..updateDependencyResult = Right(
          TaskMutationResponse(
            taskId: 'task-1',
            taskVersion: 2,
            taskUpdatedAtUtc: now,
            data: TaskDependencyResponse(
              id: dependency.id,
              sourceTaskId: dependency.sourceTaskId,
              targetTaskId: dependency.targetTaskId,
              type: dependency.type,
              createdAtUtc: now,
              dependencyKind: TaskDependencyKind.startToStart,
              lagDays: 3,
            ),
          ),
        );
      final cubit = TaskDetailsCubit(
        repository: repository,
        acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
        checklistRepository: _TaskChecklistRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );
      await cubit.load();

      expect(
        await cubit.updateDependency(
          dependency: dependency,
          dependencyKind: TaskDependencyKind.startToStart,
          lagDays: 3,
        ),
        isTrue,
      );

      final ready = cubit.state as TaskDetailsReady;
      expect(repository.updateDependencyPayload?.expectedVersion, 1);
      expect(
        repository.updateDependencyPayload?.dependencyKind,
        TaskDependencyKind.startToStart,
      );
      expect(repository.updateDependencyPayload?.lagDays, 3);
      expect(
        ready.details.dependencies.single.dependencyKind,
        TaskDependencyKind.startToStart,
      );
      expect(ready.details.dependencies.single.lagDays, 3);
      expect(ready.details.task.version, 2);
      await cubit.close();
    },
  );

  test('usuwa zależność lokalnie z nową wersją zadania', () async {
    final now = DateTime.utc(2026, 8, 26);
    final dependency = TaskDependencyDetailsResponse(
      id: 'dependency-1',
      sourceTaskId: 'task-1',
      targetTaskId: 'task-2',
      type: TaskDependencyType.relatedTo,
      createdAtUtc: now,
      relatedTask: const ProjectTaskReferenceResponse(
        id: 'task-2',
        number: 2,
        key: 'TASK-2',
        title: 'Powiązane zadanie',
        status: ProjectTaskStatus.todo,
        version: 1,
      ),
    );
    final initial = _details().copyWith(dependencies: [dependency]);
    final repository = _TasksRepository(Right(initial))
      ..deleteDependencyResult = Right(
        TaskMutationResponse(
          taskId: 'task-1',
          taskVersion: 2,
          taskUpdatedAtUtc: now,
          data: const TaskMutationAcknowledgementResponse(changed: true),
        ),
      );
    final cubit = TaskDetailsCubit(
      repository: repository,
      acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
      checklistRepository: _TaskChecklistRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    await cubit.load();

    expect(await cubit.deleteDependency(dependency), isTrue);
    final ready = cubit.state as TaskDetailsReady;
    expect(repository.deleteDependencyExpectedVersion, 1);
    expect(ready.details.dependencies, isEmpty);
    expect(ready.details.task.version, 2);
    await cubit.close();
  });

  test('obserwuje zadanie i odświeża pełny agregat', () async {
    final now = DateTime.utc(2026, 8, 26);
    final initial = _details();
    final refreshed = initial.copyWith(
      task: initial.task.copyWith(version: 2),
      watchers: [
        TaskWatcherResponse(userId: 'user-1', createdAtUtc: now),
      ],
      isWatchedByMe: true,
    );
    final repository = _TasksRepository(Right(initial));
    final collaboration = _TaskCollaborationRepository()
      ..followResult = Right(
        TaskMutationResponse(
          taskId: 'task-1',
          taskVersion: 2,
          taskUpdatedAtUtc: now,
          data: const TaskMutationAcknowledgementResponse(changed: true),
        ),
      );
    final cubit = TaskDetailsCubit(
      repository: repository,
      acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
      checklistRepository: _TaskChecklistRepository(),
      collaborationRepository: collaboration,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    await cubit.load();
    repository.result = Right(refreshed);

    expect(await cubit.toggleWatching(), isTrue);
    expect(collaboration.followCalls, 1);
    expect(collaboration.unfollowCalls, 0);
    expect(repository.getCalls, 2);
    final ready = cubit.state as TaskDetailsReady;
    expect(ready.details.isWatchedByMe, isTrue);
    expect(ready.details.watchers.single.userId, 'user-1');
    await cubit.close();
  });

  test('zastępuje wykonawców z expectedVersion i deduplikuje osoby', () async {
    final initial = _details();
    final assignedAt = DateTime.utc(2026, 8, 27);
    final updatedTask = initial.task.copyWith(
      assignees: [
        TaskAssigneeResponse(
          userId: 'user-2',
          isPrimary: true,
          createdAtUtc: assignedAt,
        ),
        TaskAssigneeResponse(
          userId: 'user-3',
          isPrimary: false,
          createdAtUtc: assignedAt,
        ),
      ],
      version: 2,
    );
    final collaboration = _TaskCollaborationRepository()
      ..replaceAssigneesResult = Right(
        TaskMutationResponse(
          taskId: updatedTask.id,
          taskVersion: 2,
          taskUpdatedAtUtc: updatedTask.updatedAtUtc,
          data: updatedTask,
        ),
      );
    final cubit = TaskDetailsCubit(
      repository: _TasksRepository(Right(initial)),
      acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
      checklistRepository: _TaskChecklistRepository(),
      collaborationRepository: collaboration,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    await cubit.load();

    final saved = await cubit.replaceAssignees([
      'user-2',
      'user-2',
      'user-3',
    ]);

    expect(saved, isTrue);
    expect(collaboration.replacedAssigneeIds, ['user-2', 'user-3']);
    expect(collaboration.replaceAssigneesExpectedVersion, 1);
    final ready = cubit.state as TaskDetailsReady;
    expect(ready.details.task.assignees, hasLength(2));
    expect(ready.details.task.version, 2);
    await cubit.close();
  });

  test(
    'przypina task lokalnie bez refetchu współdzielonego agregatu',
    () async {
      final repository = _TasksRepository(Right(_details()));
      final collaboration = _TaskCollaborationRepository()
        ..pinnedResult = const Right(unit);
      final cubit = TaskDetailsCubit(
        repository: repository,
        acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
        checklistRepository: _TaskChecklistRepository(),
        collaborationRepository: collaboration,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );
      await cubit.load();

      expect(await cubit.togglePinned(), isTrue);
      expect(collaboration.pinnedValue, isTrue);
      expect(repository.getCalls, 1);
      expect((cubit.state as TaskDetailsReady).details.isPinnedByMe, isTrue);
      await cubit.close();
    },
  );

  test(
    'zastępuje etykiety z expectedVersion i zapisuje wersję mutacji',
    () async {
      final now = DateTime.utc(2026, 8, 26);
      final labels = [
        TaskLabelResponse(
          id: 'label-1',
          name: 'Pilne',
          color: '#E74C3C',
          createdAtUtc: now,
        ),
        TaskLabelResponse(
          id: 'label-2',
          name: 'Backend',
          color: '#4C7CF3',
          createdAtUtc: now,
        ),
      ];
      final metadata = _TaskMetadataRepository()
        ..replaceLabelsResult = Right(
          TaskMutationResponse(
            taskId: 'task-1',
            taskVersion: 2,
            taskUpdatedAtUtc: now,
            data: labels,
          ),
        );
      final cubit = TaskDetailsCubit(
        repository: _TasksRepository(Right(_details())),
        acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
        checklistRepository: _TaskChecklistRepository(),
        metadataRepository: metadata,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        taskId: 'task-1',
      );
      await cubit.load();

      expect(
        await cubit.replaceLabels(['label-1', 'label-1', 'label-2']),
        isTrue,
      );
      expect(metadata.replaceLabelsPayload?.labelIds, ['label-1', 'label-2']);
      expect(metadata.replaceLabelsPayload?.expectedVersion, 1);
      final ready = cubit.state as TaskDetailsReady;
      expect(ready.details.labels, labels);
      expect(ready.details.task.version, 2);
      await cubit.close();
    },
  );

  test('zapisuje wartości pól własnych z expectedVersion', () async {
    final now = DateTime.utc(2026, 8, 26);
    const field = TaskCustomFieldDefinitionValueResponse(
      id: 'field-1',
      name: 'Punkty',
      type: TaskCustomFieldType.number,
      isRequired: false,
      position: 100,
      value: 3,
    );
    final initial = _details().copyWith(customFields: [field]);
    final metadata = _TaskMetadataRepository()
      ..replaceCustomFieldsResult = Right(
        TaskMutationResponse(
          taskId: 'task-1',
          taskVersion: 2,
          taskUpdatedAtUtc: now,
          data: [
            TaskCustomFieldValueResponse(
              fieldId: 'field-1',
              value: 5,
              updatedAtUtc: now,
            ),
          ],
        ),
      );
    final cubit = TaskDetailsCubit(
      repository: _TasksRepository(Right(initial)),
      acceptanceCriteriaRepository: _TaskAcceptanceCriteriaRepository(),
      checklistRepository: _TaskChecklistRepository(),
      metadataRepository: metadata,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      taskId: 'task-1',
    );
    await cubit.load();

    expect(await cubit.replaceCustomFieldValues({'field-1': 5}), isTrue);
    expect(metadata.replaceCustomFieldsPayload?.values, {'field-1': 5});
    expect(metadata.replaceCustomFieldsPayload?.expectedVersion, 1);
    final ready = cubit.state as TaskDetailsReady;
    expect(ready.details.customFields.single.value, 5);
    expect(ready.details.task.version, 2);
    await cubit.close();
  });
}
