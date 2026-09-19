import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_capabilities.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_settings_tab.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/admin/tabs/templates/project_templates_tab_view.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/automations/widgets/project_automations_tab_view.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/cubit/project_settings_cubit_registry.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/custom_fields/widgets/project_custom_fields_tab_view.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/general/widgets/project_general_tab_view.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/labels/widgets/project_labels_tab_view.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/members/widgets/project_members_tab_view.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/milestones/widgets/project_milestones_tab_view.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/workflow/widgets/project_workflow_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Montuje wyłącznie aktywną zakładkę z odpowiadającym jej lazy Cubitem.
class ProjectSettingsTabContent extends StatelessWidget {
  const ProjectSettingsTabContent({
    required this.tab,
    required this.project,
    required this.capabilities,
    required this.registry,
    required this.onProjectDeleted,
    super.key,
  });

  final ProjectSettingsTab tab;
  final ProjectListItem project;
  final ProjectCapabilities capabilities;
  final ProjectSettingsCubitRegistry registry;
  final VoidCallback onProjectDeleted;

  @override
  Widget build(BuildContext context) {
    registry.ensure(tab);
    final role = capabilities.effectiveRole ?? ProjectRole.observer;
    return switch (tab) {
      ProjectSettingsTab.general => BlocProvider.value(
        value: registry.general!,
        child: ProjectGeneralTabView(
          project: project,
          userRole: role,
          onProjectDeleted: onProjectDeleted,
        ),
      ),
      ProjectSettingsTab.templates => BlocProvider.value(
        value: registry.templates!,
        child: ProjectTemplatesTabView(
          project: project,
          canManage: capabilities.canManageTemplates,
        ),
      ),
      ProjectSettingsTab.members => BlocProvider.value(
        value: registry.members!,
        child: ProjectMembersTabView(userRole: role),
      ),
      ProjectSettingsTab.workflow => BlocProvider.value(
        value: registry.workflow!,
        child: ProjectWorkflowTabView(userRole: role),
      ),
      ProjectSettingsTab.customFields => BlocProvider.value(
        value: registry.customFields!,
        child: ProjectCustomFieldsTabView(userRole: role),
      ),
      ProjectSettingsTab.labels => BlocProvider.value(
        value: registry.labels!,
        child: ProjectLabelsTabView(userRole: role),
      ),
      ProjectSettingsTab.milestones => BlocProvider.value(
        value: registry.milestones!,
        child: ProjectMilestonesTabView(userRole: role),
      ),
      ProjectSettingsTab.automations => BlocProvider.value(
        value: registry.automations!,
        child: ProjectAutomationsTabView(userRole: role),
      ),
    };
  }
}
