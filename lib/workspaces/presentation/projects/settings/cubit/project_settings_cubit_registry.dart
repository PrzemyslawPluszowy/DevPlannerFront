import 'dart:async';

import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_settings_tab.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/admin/tabs/templates/cubit/project_templates_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/general/cubit/project_general_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/members/cubit/project_members_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/automation_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/custom_workflow_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/milestone_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/task_custom_fields_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/settings/cubit/task_labels_settings_cubit.dart';
import 'package:flutter/foundation.dart';

/// Tworzy Cubity ustawień tylko po wejściu na daną zakładkę i sprząta je razem.
///
/// Porty przychodzą jawnie z kompozycji modala, a nie z kontekstu, bo centrum
/// ustawień jest montowane na root navigatorze i nie widzi providerów trasy,
/// która je otworzyła.
class ProjectSettingsCubitRegistry {
  ProjectSettingsCubitRegistry({
    required this.ports,
    required this.project,
    required this.onMutation,
  });

  final ProjectSettingsComposition ports;
  final ProjectListItem project;
  final ValueChanged<ProjectSettingsTab> onMutation;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  ProjectGeneralSettingsCubit? general;
  ProjectMembersSettingsCubit? members;
  CustomWorkflowSettingsCubit? workflow;
  TaskCustomFieldsSettingsCubit? customFields;
  TaskLabelsSettingsCubit? labels;
  MilestoneSettingsCubit? milestones;
  AutomationSettingsCubit? automations;
  ProjectTemplatesCubit? templates;

  void ensure(ProjectSettingsTab tab) {
    switch (tab) {
      case ProjectSettingsTab.general:
        _createGeneral();
      case ProjectSettingsTab.templates:
        _createTemplates();
      case ProjectSettingsTab.members:
        _createMembers();
      case ProjectSettingsTab.workflow:
        _createWorkflow();
      case ProjectSettingsTab.customFields:
        _createCustomFields();
      case ProjectSettingsTab.labels:
        _createLabels();
      case ProjectSettingsTab.milestones:
        _createMilestones();
      case ProjectSettingsTab.automations:
        _createAutomations();
    }
  }

  void _createGeneral() {
    if (general != null) return;
    final cubit = ProjectGeneralSettingsCubit(
      workspaceId: project.workspaceId,
      projectId: project.id,
      repository: ports.projects,
    );
    _subscriptions.add(
      cubit.stream.listen((state) {
        if (state is ProjectGeneralSettingsLoaded && state.saveSuccess) {
          onMutation(ProjectSettingsTab.general);
        }
      }),
    );
    unawaited(cubit.load(initialProject: project));
    general = cubit;
  }

  void _createTemplates() {
    if (templates != null) return;
    final cubit = ProjectTemplatesCubit(
      workspaceId: project.workspaceId,
      projectId: project.id,
      repository: ports.projectTemplates,
    );
    _observeSaving<ProjectTemplatesReady>(
      cubit.stream,
      ProjectSettingsTab.templates,
      (state) => state.isSaving,
      (state) => state.error,
    );
    unawaited(cubit.load());
    templates = cubit;
  }

  void _createMembers() {
    if (members != null) return;
    final cubit = ProjectMembersSettingsCubit(
      workspaceId: project.workspaceId,
      projectId: project.id,
      projectsRepository: ports.projects,
      workspacesRepository: ports.workspaces,
    );
    _observeSaving<ProjectMembersSettingsLoaded>(
      cubit.stream,
      ProjectSettingsTab.members,
      (state) => state.isMutating,
      (state) => state.error,
    );
    unawaited(cubit.load());
    members = cubit;
  }

  void _createWorkflow() {
    if (workflow != null) return;
    final cubit = CustomWorkflowSettingsCubit(
      workspaceId: project.workspaceId,
      projectId: project.id,
      repository: ports.customWorkflow,
    );
    _observeSaving<CustomWorkflowSettingsReady>(
      cubit.stream,
      ProjectSettingsTab.workflow,
      (state) => state.isSaving,
      (state) => state.error,
    );
    unawaited(cubit.load());
    workflow = cubit;
  }

  void _createCustomFields() {
    if (customFields != null) return;
    final cubit = TaskCustomFieldsSettingsCubit(
      workspaceId: project.workspaceId,
      projectId: project.id,
      repository: ports.taskMetadata,
    );
    _observeSaving<TaskCustomFieldsSettingsReady>(
      cubit.stream,
      ProjectSettingsTab.customFields,
      (state) => state.isSaving,
      (state) => state.error,
    );
    unawaited(cubit.load());
    customFields = cubit;
  }

  void _createLabels() {
    if (labels != null) return;
    final cubit = TaskLabelsSettingsCubit(
      workspaceId: project.workspaceId,
      projectId: project.id,
      repository: ports.taskMetadata,
    );
    _observeSaving<TaskLabelsSettingsReady>(
      cubit.stream,
      ProjectSettingsTab.labels,
      (state) => state.isSaving,
      (state) => state.error,
    );
    unawaited(cubit.load());
    labels = cubit;
  }

  void _createMilestones() {
    if (milestones != null) return;
    final cubit = MilestoneSettingsCubit(
      workspaceId: project.workspaceId,
      projectId: project.id,
      repository: ports.milestones,
    );
    _observeSaving<MilestoneSettingsReady>(
      cubit.stream,
      ProjectSettingsTab.milestones,
      (state) => state.isSaving,
      (state) => state.error,
    );
    unawaited(cubit.load());
    milestones = cubit;
  }

  void _createAutomations() {
    if (automations != null) return;
    final cubit = AutomationSettingsCubit(
      workspaceId: project.workspaceId,
      projectId: project.id,
      repository: ports.automations,
      tasksRepository: ports.tasks,
      memberProfilesRepository: ports.memberProfiles,
      taskMetadataRepository: ports.taskMetadata,
    );
    var wasBusy = false;
    _subscriptions.add(
      cubit.stream.listen((state) {
        if (state is AutomationSettingsReady) {
          final busy = state.busyRuleId != null || state.isInstallingRecipe;
          if (wasBusy && !busy && state.error == null) {
            onMutation(ProjectSettingsTab.automations);
          }
          wasBusy = busy;
        }
      }),
    );
    unawaited(cubit.load());
    automations = cubit;
  }

  void _observeSaving<T>(
    Stream<dynamic> stream,
    ProjectSettingsTab tab,
    bool Function(T state) isSaving,
    Object? Function(T state) error,
  ) {
    var wasSaving = false;
    _subscriptions.add(
      stream.listen((state) {
        if (state is T) {
          if (wasSaving && !isSaving(state) && error(state) == null) {
            onMutation(tab);
          }
          wasSaving = isSaving(state);
        }
      }),
    );
  }

  void dispose() {
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    unawaited(general?.close());
    unawaited(members?.close());
    unawaited(workflow?.close());
    unawaited(customFields?.close());
    unawaited(labels?.close());
    unawaited(milestones?.close());
    unawaited(automations?.close());
    unawaited(templates?.close());
  }
}
