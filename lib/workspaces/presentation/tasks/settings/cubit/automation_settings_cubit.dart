import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/workspaces/models/automation_models.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/domain/repositories/automation_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/tasks_repository.dart';

sealed class AutomationSettingsState {
  const AutomationSettingsState();
}

final class AutomationSettingsInitial extends AutomationSettingsState {
  const AutomationSettingsInitial();
}

final class AutomationSettingsLoading extends AutomationSettingsState {
  const AutomationSettingsLoading();
}

final class AutomationSettingsFailure extends AutomationSettingsState {
  const AutomationSettingsFailure(this.message);

  final String message;
}

final class AutomationSettingsReady extends AutomationSettingsState {
  const AutomationSettingsReady({
    required this.rules,
    required this.catalog,
    required this.recipes,
    this.runsByRuleId = const {},
    this.loadingRunRuleIds = const {},
    this.memberProfiles = const [],
    this.labels = const [],
    this.tasks = const [],
    this.isLoadingTasks = false,
    this.dryRunResult,
    this.isRunningDryRun = false,
    this.busyRuleId,
    this.isInstallingRecipe = false,
    this.error,
  });

  final List<AutomationRuleResponse> rules;
  final AutomationCatalogResponse catalog;
  final List<AutomationRecipe> recipes;
  final Map<String, List<AutomationRunResponse>> runsByRuleId;
  final Set<String> loadingRunRuleIds;
  final List<ProjectMemberProfile> memberProfiles;
  final List<TaskLabelResponse> labels;
  final List<ProjectTaskListItemResponse> tasks;
  final bool isLoadingTasks;
  final AutomationDryRunResponse? dryRunResult;
  final bool isRunningDryRun;
  final String? busyRuleId;
  final bool isInstallingRecipe;
  final String? error;

  AutomationSettingsReady copyWith({
    List<AutomationRuleResponse>? rules,
    AutomationCatalogResponse? catalog,
    List<AutomationRecipe>? recipes,
    Map<String, List<AutomationRunResponse>>? runsByRuleId,
    Set<String>? loadingRunRuleIds,
    List<ProjectMemberProfile>? memberProfiles,
    List<TaskLabelResponse>? labels,
    List<ProjectTaskListItemResponse>? tasks,
    bool? isLoadingTasks,
    AutomationDryRunResponse? dryRunResult,
    bool clearDryRunResult = false,
    bool? isRunningDryRun,
    String? busyRuleId,
    bool clearBusyRule = false,
    bool? isInstallingRecipe,
    String? error,
    bool clearError = false,
  }) => AutomationSettingsReady(
    rules: rules ?? this.rules,
    catalog: catalog ?? this.catalog,
    recipes: recipes ?? this.recipes,
    runsByRuleId: runsByRuleId ?? this.runsByRuleId,
    loadingRunRuleIds: loadingRunRuleIds ?? this.loadingRunRuleIds,
    memberProfiles: memberProfiles ?? this.memberProfiles,
    labels: labels ?? this.labels,
    tasks: tasks ?? this.tasks,
    isLoadingTasks: isLoadingTasks ?? this.isLoadingTasks,
    dryRunResult: clearDryRunResult ? null : dryRunResult ?? this.dryRunResult,
    isRunningDryRun: isRunningDryRun ?? this.isRunningDryRun,
    busyRuleId: clearBusyRule ? null : busyRuleId ?? this.busyRuleId,
    isInstallingRecipe: isInstallingRecipe ?? this.isInstallingRecipe,
    error: clearError ? null : error ?? this.error,
  );
}

/// Stan reguł projektu, gotowych przepisów i wersjonowanych mutacji.
final class AutomationSettingsCubit extends Cubit<AutomationSettingsState> {
  AutomationSettingsCubit({
    required this.repository,
    required this.tasksRepository,
    this.memberProfilesRepository,
    this.taskMetadataRepository,
    required this.workspaceId,
    required this.projectId,
  }) : super(const AutomationSettingsInitial());

  static const _creatingRuleBusyId = '__creating_automation_rule__';

  final AutomationRepository repository;
  final TasksRepository tasksRepository;
  final ProjectMemberProfilesRepository? memberProfilesRepository;
  final TaskMetadataRepository? taskMetadataRepository;
  final String workspaceId;
  final String projectId;

  Future<void> load() async {
    emit(const AutomationSettingsLoading());
    final rules = await repository.listRules(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return;
    await rules.fold(
      (error) async => emit(AutomationSettingsFailure(error.message)),
      (items) async {
        final catalog = await repository.getCatalog(
          workspaceId: workspaceId,
          projectId: projectId,
        );
        if (isClosed) return;
        await catalog.fold(
          (error) async => emit(AutomationSettingsFailure(error.message)),
          (catalog) async {
            final recipes = await repository.listRecipes(
              workspaceId: workspaceId,
              projectId: projectId,
            );
            if (isClosed) return;
            recipes.fold(
              (error) => emit(AutomationSettingsFailure(error.message)),
              (recipes) {
                emit(
                  AutomationSettingsReady(
                    rules: _sortedRules(items),
                    catalog: catalog,
                    recipes: recipes,
                  ),
                );
                unawaited(_loadBuilderOptions());
              },
            );
          },
        );
      },
    );
  }

  /// Uzupełnia katalogi wykorzystywane przez kreator bez zatrzymywania
  /// podstawowego zarządzania regułami, gdy któryś poboczny odczyt zawiedzie.
  Future<void> _loadBuilderOptions() async {
    final profilesRepository = memberProfilesRepository;
    final metadataRepository = taskMetadataRepository;
    if (profilesRepository == null && metadataRepository == null) return;
    final profilesFuture = profilesRepository?.listProfiles(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    final labelsFuture = metadataRepository?.listLabels(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    final profiles = profilesFuture == null ? null : await profilesFuture;
    final labels = labelsFuture == null ? null : await labelsFuture;
    if (isClosed || state is! AutomationSettingsReady) return;
    final current = state as AutomationSettingsReady;
    emit(
      current.copyWith(
        memberProfiles: profiles?.fold(
          (_) => current.memberProfiles,
          (items) => items,
        ),
        labels: labels?.fold((_) => current.labels, (items) => items),
      ),
    );
  }

  Future<bool> setEnabled(AutomationRuleResponse rule, bool enabled) async {
    final current = state;
    if (current is! AutomationSettingsReady ||
        current.busyRuleId != null ||
        current.isInstallingRecipe ||
        rule.isEnabled == enabled) {
      return false;
    }
    emit(
      current.copyWith(
        busyRuleId: rule.id,
        clearError: true,
      ),
    );
    final result = await repository.setRuleEnabled(
      workspaceId: workspaceId,
      projectId: projectId,
      ruleId: rule.id,
      payload: SetAutomationRuleEnabledPayload(
        enabled: enabled,
        expectedVersion: rule.version,
      ),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        final latest = _readyState();
        if (latest == null) return false;
        emit(
          latest.copyWith(clearBusyRule: true, error: error.message),
        );
        return false;
      },
      (updated) {
        final latest = _readyState();
        if (latest == null) return false;
        emit(
          latest.copyWith(
            rules: _replaceRule(latest.rules, updated),
            clearBusyRule: true,
          ),
        );
        return true;
      },
    );
  }

  /// Tworzy regułę z kreatora i od razu dodaje odpowiedź do lokalnej listy.
  Future<bool> create(CreateAutomationRulePayload payload) async {
    final current = state;
    if (current is! AutomationSettingsReady ||
        current.busyRuleId != null ||
        current.isInstallingRecipe) {
      return false;
    }
    emit(current.copyWith(busyRuleId: _creatingRuleBusyId, clearError: true));
    final result = await repository.createRule(
      workspaceId: workspaceId,
      projectId: projectId,
      payload: payload,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        final latest = _readyState();
        if (latest == null) return false;
        emit(latest.copyWith(clearBusyRule: true, error: error.message));
        return false;
      },
      (rule) {
        final latest = _readyState();
        if (latest == null) return false;
        emit(
          latest.copyWith(
            rules: _sortedRules([...latest.rules, rule]),
            clearBusyRule: true,
          ),
        );
        return true;
      },
    );
  }

  /// Aktualizuje definicję reguły i zastępuje ją odpowiedzią wersjonowaną.
  Future<bool> update({
    required AutomationRuleResponse rule,
    required UpdateAutomationRulePayload payload,
  }) async {
    final current = state;
    if (current is! AutomationSettingsReady ||
        current.busyRuleId != null ||
        current.isInstallingRecipe) {
      return false;
    }
    emit(current.copyWith(busyRuleId: rule.id, clearError: true));
    final result = await repository.updateRule(
      workspaceId: workspaceId,
      projectId: projectId,
      ruleId: rule.id,
      payload: payload,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        final latest = _readyState();
        if (latest == null) return false;
        emit(latest.copyWith(clearBusyRule: true, error: error.message));
        return false;
      },
      (updated) {
        final latest = _readyState();
        if (latest == null) return false;
        emit(
          latest.copyWith(
            rules: _replaceRule(latest.rules, updated),
            clearBusyRule: true,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> archive(AutomationRuleResponse rule) async {
    final current = state;
    if (current is! AutomationSettingsReady ||
        current.busyRuleId != null ||
        current.isInstallingRecipe) {
      return false;
    }
    emit(current.copyWith(busyRuleId: rule.id, clearError: true));
    final result = await repository.archiveRule(
      workspaceId: workspaceId,
      projectId: projectId,
      ruleId: rule.id,
      expectedVersion: rule.version,
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        final latest = _readyState();
        if (latest == null) return false;
        emit(latest.copyWith(clearBusyRule: true, error: error.message));
        return false;
      },
      (_) {
        final latest = _readyState();
        if (latest == null) return false;
        emit(
          latest.copyWith(
            rules: latest.rules.where((item) => item.id != rule.id).toList(),
            clearBusyRule: true,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> installRecipe(AutomationRecipe recipe) async {
    final current = state;
    if (current is! AutomationSettingsReady ||
        current.busyRuleId != null ||
        current.isInstallingRecipe) {
      return false;
    }
    emit(current.copyWith(isInstallingRecipe: true, clearError: true));
    final result = await repository.installRecipe(
      workspaceId: workspaceId,
      projectId: projectId,
      recipeKey: recipe.key,
      payload: ApplyAutomationRecipePayload(name: recipe.name),
    );
    if (isClosed) return false;
    return result.fold(
      (error) {
        final latest = _readyState();
        if (latest == null) return false;
        emit(
          latest.copyWith(isInstallingRecipe: false, error: error.message),
        );
        return false;
      },
      (rule) {
        final latest = _readyState();
        if (latest == null) return false;
        emit(
          latest.copyWith(
            rules: _sortedRules([...latest.rules, rule]),
            isInstallingRecipe: false,
          ),
        );
        return true;
      },
    );
  }

  /// Leniwie pobiera historię wybranej reguły bez blokowania pozostałego panelu.
  Future<void> loadRuns(AutomationRuleResponse rule) async {
    final current = state;
    if (current is! AutomationSettingsReady ||
        current.loadingRunRuleIds.contains(rule.id)) {
      return;
    }
    emit(
      current.copyWith(
        loadingRunRuleIds: {...current.loadingRunRuleIds, rule.id},
        clearError: true,
      ),
    );
    final result = await repository.listRuns(
      workspaceId: workspaceId,
      projectId: projectId,
      ruleId: rule.id,
      pageSize: 30,
    );
    if (isClosed) return;
    result.fold(
      (error) {
        final latest = _readyState();
        if (latest == null) return;
        emit(
          latest.copyWith(
            loadingRunRuleIds: {...latest.loadingRunRuleIds}..remove(rule.id),
            error: error.message,
          ),
        );
      },
      (runs) {
        final latest = _readyState();
        if (latest == null) return;
        emit(
          latest.copyWith(
            runsByRuleId: {...latest.runsByRuleId, rule.id: runs},
            loadingRunRuleIds: {...latest.loadingRunRuleIds}..remove(rule.id),
          ),
        );
      },
    );
  }

  /// Ładuje pierwszą stronę zadań wyłącznie dla selektora dry-run.
  Future<void> loadTasksForDryRun() async {
    final current = state;
    if (current is! AutomationSettingsReady || current.isLoadingTasks) return;
    emit(current.copyWith(isLoadingTasks: true, clearError: true));
    final result = await tasksRepository.listProjectTasks(
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (isClosed) return;
    result.fold(
      (error) {
        final latest = _readyState();
        if (latest == null) return;
        emit(latest.copyWith(isLoadingTasks: false, error: error.message));
      },
      (page) {
        final latest = _readyState();
        if (latest == null) return;
        emit(
          latest.copyWith(
            tasks: page.items,
            isLoadingTasks: false,
            clearError: true,
          ),
        );
      },
    );
  }

  /// Symuluje regułę dla zadania bez zapisywania zmian po stronie backendu.
  Future<void> dryRun({
    required AutomationRuleResponse rule,
    required ProjectTaskListItemResponse task,
  }) async {
    final current = state;
    if (current is! AutomationSettingsReady || current.isRunningDryRun) return;
    emit(
      current.copyWith(
        isRunningDryRun: true,
        clearDryRunResult: true,
        clearError: true,
      ),
    );
    final result = await repository.dryRun(
      workspaceId: workspaceId,
      projectId: projectId,
      ruleId: rule.id,
      payload: AutomationDryRunPayload(taskId: task.id, eventPayload: const {}),
    );
    if (isClosed) return;
    result.fold(
      (error) {
        final latest = _readyState();
        if (latest == null) return;
        emit(latest.copyWith(isRunningDryRun: false, error: error.message));
      },
      (response) {
        final latest = _readyState();
        if (latest == null) return;
        emit(
          latest.copyWith(
            dryRunResult: response,
            isRunningDryRun: false,
            clearError: true,
          ),
        );
      },
    );
  }

  AutomationSettingsReady? _readyState() {
    final current = state;
    return current is AutomationSettingsReady ? current : null;
  }

  static List<AutomationRuleResponse> _replaceRule(
    List<AutomationRuleResponse> rules,
    AutomationRuleResponse updated,
  ) => _sortedRules([
    for (final rule in rules)
      if (rule.id != updated.id) rule,
    updated,
  ]);

  static List<AutomationRuleResponse> _sortedRules(
    List<AutomationRuleResponse> rules,
  ) => [...rules]..sort((left, right) => left.name.compareTo(right.name));
}
