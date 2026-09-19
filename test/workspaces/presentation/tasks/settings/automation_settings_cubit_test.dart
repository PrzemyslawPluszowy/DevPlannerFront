import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/automation_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/data/workspaces/models/automation_models.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/automation_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/automation_settings_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

final class _AutomationRepository implements AutomationRepository {
  List<AutomationRuleResponse> rules = [_rule()];
  SetAutomationRuleEnabledPayload? enabledPayload;
  ApplyAutomationRecipePayload? recipePayload;
  AutomationDryRunPayload? dryRunPayload;
  CreateAutomationRulePayload? createPayload;
  UpdateAutomationRulePayload? updatePayload;
  Completer<Either<ApiError, List<AutomationRunResponse>>>? runsCompleter;

  @override
  Future<Either<ApiError, List<AutomationRuleResponse>>> listRules({
    required String workspaceId,
    required String projectId,
  }) async => Right(rules);

  @override
  Future<Either<ApiError, AutomationCatalogResponse>> getCatalog({
    required String workspaceId,
    required String projectId,
  }) async => const Right(
    AutomationCatalogResponse(triggers: [], conditions: [], actions: []),
  );

  @override
  Future<Either<ApiError, List<AutomationRecipe>>> listRecipes({
    required String workspaceId,
    required String projectId,
  }) async => Right([_recipe()]);

  @override
  Future<Either<ApiError, AutomationRuleResponse>> createRule({
    required String workspaceId,
    required String projectId,
    required CreateAutomationRulePayload payload,
  }) async {
    createPayload = payload;
    final rule = _rule().copyWith(
      id: 'rule-2',
      name: payload.name,
      triggerType: payload.triggerType,
      triggerConfig: payload.triggerConfig,
      actions: payload.actions,
    );
    rules = [...rules, rule];
    return Right(rule);
  }

  @override
  Future<Either<ApiError, AutomationRuleResponse>> updateRule({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    required UpdateAutomationRulePayload payload,
  }) async {
    updatePayload = payload;
    final updated = rules
        .singleWhere((item) => item.id == ruleId)
        .copyWith(
          name: payload.name,
          triggerType: payload.triggerType,
          triggerConfig: payload.triggerConfig,
          conditions: payload.conditions,
          actions: payload.actions,
          version: 5,
        );
    rules = [updated];
    return Right(updated);
  }

  @override
  Future<Either<ApiError, AutomationRuleResponse>> setRuleEnabled({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    required SetAutomationRuleEnabledPayload payload,
  }) async {
    enabledPayload = payload;
    final rule = rules
        .singleWhere((item) => item.id == ruleId)
        .copyWith(
          isEnabled: payload.enabled,
          version: 5,
        );
    rules = [rule];
    return Right(rule);
  }

  @override
  Future<Either<ApiError, AutomationRuleResponse>> installRecipe({
    required String workspaceId,
    required String projectId,
    required String recipeKey,
    required ApplyAutomationRecipePayload payload,
  }) async {
    recipePayload = payload;
    final rule = _rule().copyWith(id: 'rule-2', name: payload.name!);
    rules = [...rules, rule];
    return Right(rule);
  }

  @override
  Future<Either<ApiError, List<AutomationRunResponse>>> listRuns({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    int? pageSize,
  }) async {
    final pending = runsCompleter;
    if (pending != null) return pending.future;
    return Right([_run(ruleId)]);
  }

  AutomationRunResponse _run(String ruleId) => AutomationRunResponse(
    id: 'run-1',
    ruleId: ruleId,
    triggerEventId: 'event-1',
    triggerSourceEntity: 'Task',
    triggerSourceEntityId: 'task-1',
    status: AutomationRunStatus.succeeded,
    durationMs: 42,
    executionDetails: const {},
    executedAtUtc: DateTime.utc(2026),
    correlationId: 'correlation-1',
    chainDepth: 0,
  );

  @override
  Future<Either<ApiError, AutomationDryRunResponse>> dryRun({
    required String workspaceId,
    required String projectId,
    required String ruleId,
    required AutomationDryRunPayload payload,
  }) async {
    dryRunPayload = payload;
    return Right(
      AutomationDryRunResponse(
        ruleId: ruleId,
        taskId: payload.taskId,
        conditionsMatched: true,
        actions: const [],
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _TasksRepository implements TasksRepository {
  @override
  Future<Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>>
  listProjectTasks({
    required String workspaceId,
    required String projectId,
    ProjectTasksQuery query = const ProjectTasksQuery(),
  }) async => Right(
    CursorPageResponse(items: [_task()]),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _MemberProfilesRepository
    implements ProjectMemberProfilesRepository {
  @override
  Future<Either<ApiError, List<ProjectMemberProfile>>> listProfiles({
    required String workspaceId,
    required String projectId,
    bool forceRefresh = false,
  }) async => const Right([
    ProjectMemberProfile(
      userId: 'member-1',
      displayName: 'Anna Kowalska',
      role: ProjectRole.member,
    ),
  ]);

  @override
  Future<Either<ApiError, ProjectMemberProfilePage>> listProfilesPage({
    required String workspaceId,
    required String projectId,
    String? search,
    String? cursor,
    int limit = 30,
  }) async => const Right(
    ProjectMemberProfilePage(
      items: [
        ProjectMemberProfile(
          userId: 'member-1',
          displayName: 'Anna Kowalska',
          role: ProjectRole.member,
        ),
      ],
    ),
  );

  @override
  Future<Either<ApiError, List<ProjectMemberProfile>>> searchProfiles({
    required String workspaceId,
    required String projectId,
    required String query,
  }) => listProfiles(workspaceId: workspaceId, projectId: projectId);

  @override
  void invalidate({required String workspaceId, required String projectId}) {}
}

final class _TaskMetadataRepository implements TaskMetadataRepository {
  @override
  Future<Either<ApiError, List<TaskLabelResponse>>> listLabels({
    required String workspaceId,
    required String projectId,
  }) async => Right([
    TaskLabelResponse(
      id: 'label-1',
      name: 'Klient',
      color: '#2563EB',
      createdAtUtc: DateTime.utc(2026),
    ),
  ]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

ProjectTaskListItemResponse _task() => ProjectTaskListItemResponse(
  id: 'task-1',
  number: 1,
  key: 'TASK-1',
  title: 'Zadanie testowe',
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.normal,
  assignees: const [],
  checklistCompletedCount: 0,
  checklistTotalCount: 0,
  updatedAtUtc: DateTime.utc(2026),
  version: 1,
);

AutomationRuleResponse _rule() => AutomationRuleResponse(
  id: 'rule-1',
  projectId: 'project-1',
  name: 'Po utworzeniu zadania',
  triggerType: AutomationTriggerType.taskCreated,
  triggerConfig: const {},
  conditions: const [],
  actions: const [],
  isEnabled: true,
  executionCount: 0,
  updatedAtUtc: DateTime.utc(2026),
  version: 4,
);

AutomationRecipe _recipe() => const AutomationRecipe(
  key: 'assign-owner',
  name: 'Przypisz właściciela',
  description: 'Przepis testowy',
  triggerType: AutomationTriggerType.taskCreated,
  triggerConfig: {},
  conditions: [],
  actions: [],
);

void main() {
  late _AutomationRepository repository;
  late AutomationSettingsCubit cubit;

  setUp(() {
    repository = _AutomationRepository();
    cubit = AutomationSettingsCubit(
      repository: repository,
      tasksRepository: _TasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
  });
  tearDown(() => cubit.close());

  test('zmienia aktywność reguły z jej expectedVersion', () async {
    await cubit.load();
    final rule = (cubit.state as AutomationSettingsReady).rules.single;

    expect(await cubit.setEnabled(rule, false), isTrue);
    expect(repository.enabledPayload?.expectedVersion, 4);
    expect(
      (cubit.state as AutomationSettingsReady).rules.single.isEnabled,
      isFalse,
    );
  });

  test('instaluje przepis i dopisuje zwróconą regułę lokalnie', () async {
    await cubit.load();
    final recipe = (cubit.state as AutomationSettingsReady).recipes.single;

    expect(await cubit.installRecipe(recipe), isTrue);
    expect(repository.recipePayload?.name, 'Przypisz właściciela');
    expect((cubit.state as AutomationSettingsReady).rules, hasLength(2));
  });

  test(
    'ładuje ACL-bezpieczne katalogi wykonawców i etykiet kreatora',
    () async {
      final catalogCubit = AutomationSettingsCubit(
        repository: repository,
        tasksRepository: _TasksRepository(),
        memberProfilesRepository: _MemberProfilesRepository(),
        taskMetadataRepository: _TaskMetadataRepository(),
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      addTearDown(catalogCubit.close);

      await catalogCubit.load();
      await Future<void>.delayed(Duration.zero);

      final state = catalogCubit.state as AutomationSettingsReady;
      expect(state.memberProfiles.single.displayName, 'Anna Kowalska');
      expect(state.labels.single.name, 'Klient');
    },
  );

  test('tworzy regułę z payloadem kreatora i aktualizuje listę', () async {
    await cubit.load();

    expect(
      await cubit.create(
        const CreateAutomationRulePayload(
          name: 'Ustaw blokadę',
          triggerType: AutomationTriggerType.taskCreated,
          triggerConfig: {},
          conditions: [],
          actions: [
            AutomationAction(
              type: AutomationActionType.setTaskStatus,
              status: ProjectTaskStatus.blocked,
            ),
          ],
        ),
      ),
      isTrue,
    );

    expect(repository.createPayload?.name, 'Ustaw blokadę');
    expect(
      repository.createPayload?.actions.single.status,
      ProjectTaskStatus.blocked,
    );
    expect((cubit.state as AutomationSettingsReady).rules, hasLength(2));
  });

  test('aktualizuje regułę z wersją i zachowuje lokalną listę', () async {
    await cubit.load();
    final rule = (cubit.state as AutomationSettingsReady).rules.single;

    expect(
      await cubit.update(
        rule: rule,
        payload: UpdateAutomationRulePayload(
          name: 'Nowa nazwa',
          triggerType: rule.triggerType,
          triggerConfig: rule.triggerConfig,
          conditions: rule.conditions,
          actions: rule.actions,
          expectedVersion: rule.version,
        ),
      ),
      isTrue,
    );

    expect(repository.updatePayload?.expectedVersion, 4);
    expect(
      (cubit.state as AutomationSettingsReady).rules.single.name,
      'Nowa nazwa',
    );
  });

  test('edytuje pełną regułę z jej expectedVersion', () async {
    await cubit.load();
    final rule = (cubit.state as AutomationSettingsReady).rules.single;

    final saved = await cubit.update(
      rule: rule,
      payload: UpdateAutomationRulePayload(
        name: 'Przenieś do blokad',
        triggerType: AutomationTriggerType.taskDueSoon,
        triggerConfig: const {'days': 3},
        conditions: const [
          AutomationCondition(
            type: AutomationConditionType.taskDueWithinDays,
            days: 3,
          ),
        ],
        actions: const [
          AutomationAction(
            type: AutomationActionType.setTaskStatus,
            status: ProjectTaskStatus.blocked,
          ),
        ],
        expectedVersion: rule.version,
      ),
    );

    expect(saved, isTrue);
    expect(repository.updatePayload?.expectedVersion, 4);
    expect(repository.updatePayload?.triggerConfig, {'days': 3});
    expect(
      (cubit.state as AutomationSettingsReady).rules.single.name,
      'Przenieś do blokad',
    );
  });

  test('leniwe ładuje historię tylko dla wybranej reguły', () async {
    await cubit.load();
    final rule = (cubit.state as AutomationSettingsReady).rules.single;

    await cubit.loadRuns(rule);

    expect(
      (cubit.state as AutomationSettingsReady).runsByRuleId[rule.id],
      hasLength(1),
    );
  });

  test('symuluje regułę na zadaniu pobranym z projektu', () async {
    await cubit.load();
    await cubit.loadTasksForDryRun();
    final state = cubit.state as AutomationSettingsReady;

    await cubit.dryRun(rule: state.rules.single, task: state.tasks.single);

    expect(repository.dryRunPayload?.taskId, 'task-1');
    expect(
      (cubit.state as AutomationSettingsReady).dryRunResult?.conditionsMatched,
      isTrue,
    );
  });

  test('nie gubi zmiany reguły po późniejszym pobraniu historii', () async {
    await cubit.load();
    final rule = (cubit.state as AutomationSettingsReady).rules.single;
    repository.runsCompleter = Completer();

    final loadingRuns = cubit.loadRuns(rule);
    expect(await cubit.setEnabled(rule, false), isTrue);
    repository.runsCompleter!.complete(Right([repository._run(rule.id)]));
    await loadingRuns;

    final state = cubit.state as AutomationSettingsReady;
    expect(state.rules.single.isEnabled, isFalse);
    expect(state.runsByRuleId[rule.id], hasLength(1));
  });
}
