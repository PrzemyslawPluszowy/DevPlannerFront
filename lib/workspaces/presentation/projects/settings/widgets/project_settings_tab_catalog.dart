import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/workspaces/domain/models/project_capabilities.dart';
import 'package:devplanner/workspaces/domain/models/project_settings_tab.dart';
import 'package:flutter/material.dart';

/// Sekcje tematyczne nawigacji centrum ustawień projektu.
enum ProjectSettingsSection {
  project,
  workOrganization,
  peopleAndAccess,
  automations,
}

/// Metadane nawigacyjne jednej zakładki ustawień.
class ProjectSettingsTabDescriptor {
  const ProjectSettingsTabDescriptor({
    required this.tab,
    required this.section,
    required this.icon,
    required this.labelBuilder,
    required this.keywordsBuilder,
    required this.isVisible,
  });

  final ProjectSettingsTab tab;
  final ProjectSettingsSection section;
  final IconData icon;
  final String Function(BuildContext context) labelBuilder;
  final List<String> Function(BuildContext context) keywordsBuilder;
  final bool Function(ProjectCapabilities capabilities) isVisible;
}

/// Katalog zakładek i słów kluczowych wyszukiwarki ustawień projektu.
class ProjectSettingsTabCatalog {
  const ProjectSettingsTabCatalog._();

  static final List<ProjectSettingsTabDescriptor> descriptors = [
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.general,
      section: ProjectSettingsSection.project,
      icon: Icons.tune_rounded,
      labelBuilder: (context) => context.l10n.projectSettingsTabGeneral,
      keywordsBuilder: (_) => ['ogólne', 'nazwa', 'opis', 'widoczność', 'usuń'],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.general),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.templates,
      section: ProjectSettingsSection.project,
      icon: Icons.dashboard_customize_rounded,
      labelBuilder: (context) => context.l10n.projectSettingsTabTemplates,
      keywordsBuilder: (_) => ['szablony', 'template', 'zapisz'],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.templates),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.members,
      section: ProjectSettingsSection.peopleAndAccess,
      icon: Icons.people_outline_rounded,
      labelBuilder: (context) => context.l10n.projectSettingsTabMembers,
      keywordsBuilder: (_) => ['członkowie', 'role', 'użytkownicy', 'dostęp'],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.members),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.workflow,
      section: ProjectSettingsSection.workOrganization,
      icon: Icons.view_kanban_outlined,
      labelBuilder: (context) => context.l10n.projectSettingsTabWorkflow,
      keywordsBuilder: (_) => ['workflow', 'statusy', 'przepływ', 'kanban'],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.workflow),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.customFields,
      section: ProjectSettingsSection.workOrganization,
      icon: Icons.data_object_rounded,
      labelBuilder: (context) => context.l10n.projectSettingsTabCustomFields,
      keywordsBuilder: (_) => ['pola', 'własne', 'custom fields', 'kolumny'],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.customFields),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.labels,
      section: ProjectSettingsSection.workOrganization,
      icon: Icons.label_outline_rounded,
      labelBuilder: (context) => context.l10n.projectSettingsTabLabels,
      keywordsBuilder: (_) => ['etykiety', 'tagi', 'kolory'],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.labels),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.milestones,
      section: ProjectSettingsSection.workOrganization,
      icon: Icons.flag_outlined,
      labelBuilder: (context) => context.l10n.projectSettingsTabMilestones,
      keywordsBuilder: (_) => ['kamienie', 'milowe', 'milestones', 'cele'],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.milestones),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.automations,
      section: ProjectSettingsSection.automations,
      icon: Icons.bolt_rounded,
      labelBuilder: (context) => context.l10n.projectSettingsTabAutomations,
      keywordsBuilder: (_) => [
        'automatyzacje',
        'reguły',
        'akcje',
        'wyzwalacze',
      ],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.automations),
    ),
  ];

  static String sectionLabel(ProjectSettingsSection section) =>
      switch (section) {
        ProjectSettingsSection.project => 'Projekt',
        ProjectSettingsSection.workOrganization => 'Organizacja pracy',
        ProjectSettingsSection.peopleAndAccess => 'Ludzie i dostęp',
        ProjectSettingsSection.automations => 'Automatyzacje',
      };
}
