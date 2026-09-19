import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/workspaces/models/automation_models.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';

/// Niemutowalny stan ustawień automatyzacji projektu.
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
