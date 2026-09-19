import 'dart:async';

import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/workspaces/models/automation_models.dart';
import 'package:devplanner/workspaces/domain/repositories/automation_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/automation_settings_dry_run_service.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/automation_settings_loader.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/automation_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'automation_settings_state.dart';

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

  late final AutomationSettingsLoader _loader = AutomationSettingsLoader(
    repository: repository,
    workspaceId: workspaceId,
    projectId: projectId,
    memberProfilesRepository: memberProfilesRepository,
    taskMetadataRepository: taskMetadataRepository,
  );
  late final AutomationSettingsDryRunService _dryRunService =
      AutomationSettingsDryRunService(
        repository: repository,
        tasksRepository: tasksRepository,
        workspaceId: workspaceId,
        projectId: projectId,
      );

  Future<void> load() async {
    emit(const AutomationSettingsLoading());
    final result = await _loader.load();
    if (isClosed) return;
    switch (result) {
      case AutomationSettingsLoadFailure(:final message):
        emit(AutomationSettingsFailure(message));
      case AutomationSettingsLoadSuccess(
        :final rules,
        :final catalog,
        :final recipes,
      ):
        emit(
          AutomationSettingsReady(
            rules: rules,
            catalog: catalog,
            recipes: recipes,
          ),
        );
        unawaited(_loadBuilderOptions());
    }
  }

  /// Uzupełnia katalogi wykorzystywane przez kreator bez zatrzymywania
  /// podstawowego zarządzania regułami, gdy któryś poboczny odczyt zawiedzie.
  Future<void> _loadBuilderOptions() async {
    if (memberProfilesRepository == null && taskMetadataRepository == null) {
      return;
    }
    final options = await _loader.loadBuilderOptions();
    if (isClosed || state is! AutomationSettingsReady) return;
    final current = state as AutomationSettingsReady;
    emit(
      current.copyWith(
        memberProfiles: options.memberProfiles ?? current.memberProfiles,
        labels: options.labels ?? current.labels,
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
    final result = await _dryRunService.loadTasks();
    if (isClosed) return;
    switch (result) {
      case AutomationDryRunTasksFailure(:final message):
        final latest = _readyState();
        if (latest == null) return;
        emit(latest.copyWith(isLoadingTasks: false, error: message));
      case AutomationDryRunTasksSuccess(:final tasks):
        final latest = _readyState();
        if (latest == null) return;
        emit(
          latest.copyWith(
            tasks: tasks,
            isLoadingTasks: false,
            clearError: true,
          ),
        );
    }
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
    final result = await _dryRunService.run(rule: rule, task: task);
    if (isClosed) return;
    switch (result) {
      case AutomationDryRunFailure(:final message):
        final latest = _readyState();
        if (latest == null) return;
        emit(latest.copyWith(isRunningDryRun: false, error: message));
      case AutomationDryRunSuccess(:final response):
        final latest = _readyState();
        if (latest == null) return;
        emit(
          latest.copyWith(
            dryRunResult: response,
            isRunningDryRun: false,
            clearError: true,
          ),
        );
    }
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
