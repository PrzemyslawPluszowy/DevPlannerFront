import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/domain/models/project_capabilities.dart';
import 'package:ready_next/workspaces/domain/models/project_list_item.dart';
import 'package:ready_next/workspaces/domain/models/project_settings_tab.dart';
import 'package:ready_next/workspaces/domain/repositories/automation_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/custom_workflow_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/milestone_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/project_templates_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/projects_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/tasks_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/admin/tabs/templates/cubit/project_templates_cubit.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/admin/tabs/templates/project_templates_tab_view.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/automations/widgets/project_automations_tab_view.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/custom_fields/widgets/project_custom_fields_tab_view.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/general/cubit/project_general_settings_cubit.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/general/widgets/project_general_tab_view.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/labels/widgets/project_labels_tab_view.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/members/cubit/project_members_settings_cubit.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/members/widgets/project_members_tab_view.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/milestones/widgets/project_milestones_tab_view.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/workflow/widgets/project_workflow_tab_view.dart';
import 'package:ready_next/workspaces/presentation/tasks/settings/cubit/automation_settings_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/settings/cubit/custom_workflow_settings_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/settings/cubit/milestone_settings_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/settings/cubit/task_custom_fields_settings_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/settings/cubit/task_labels_settings_cubit.dart';

export 'package:ready_next/workspaces/domain/models/project_settings_tab.dart';

/// Wynik zamknięcia centrum ustawień projektu określający zmodyfikowane obszary.
class ProjectSettingsResult {
  const ProjectSettingsResult({
    this.mutatedTabs = const {},
  });

  /// Zbiór zakładek, w których dokonano trwałych zmian.
  final Set<ProjectSettingsTab> mutatedTabs;

  /// Czy jakakolwiek zmiana została zapisana.
  bool get hasChanges => mutatedTabs.isNotEmpty;

  /// Czy zmodyfikowano organizację pracy wpływającą na strukturę grup zadań.
  bool get affectsWorkflow => mutatedTabs.contains(ProjectSettingsTab.workflow);

  /// Czy zmodyfikowano metadane zadań (pola własne, etykiety, kamienie milowe).
  bool get affectsMetadata =>
      mutatedTabs.contains(ProjectSettingsTab.customFields) ||
      mutatedTabs.contains(ProjectSettingsTab.labels) ||
      mutatedTabs.contains(ProjectSettingsTab.milestones);

  /// Czy zmodyfikowano ogólne dane projektu (nazwa, kolor, widoczność itp.).
  bool get affectsGeneral => mutatedTabs.contains(ProjectSettingsTab.general);
}

/// Wyświetla pełnoekranowy modal centrum ustawień projektu w standardzie Web/Desktop.
///
/// Implementuje lazy loading dla Cubitów poszczególnych zakładek, eliminując
/// pobieranie danych dla niewidocznych sekcji, oraz centralny model uprawnień
/// [ProjectCapabilities].
Future<ProjectSettingsResult?> showProjectSettingsModal({
  required BuildContext context,
  required ProjectListItem project,
  ProjectRole? userRole,
  VoidCallback? onProjectDeleted,
  ProjectSettingsTab initialTab = ProjectSettingsTab.general,
}) {
  final authState = context.read<AuthCubit?>()?.state;
  final isSuperAdmin = switch (authState) {
    AuthAuthenticated(:final user) =>
      user?.permissions.contains('bswfms.custom_modules.RNext-admin') == true ||
          user?.permissions.contains('SuperAdmin') == true,
    _ => false,
  };

  final resolvedRole = userRole ?? project.myRole;
  final capabilities = ProjectCapabilities(
    role: resolvedRole,
    isSuperAdmin: isSuperAdmin,
  );

  final safeInitialTab = capabilities.canViewTab(initialTab)
      ? initialTab
      : ProjectSettingsTab.general;

  return showDialog<ProjectSettingsResult>(
    context: context,
    builder: (ctx) => ProjectSettingsModal(
      project: project,
      userRole: resolvedRole,
      onProjectDeleted: onProjectDeleted,
      initialTab: safeInitialTab,
      initialCapabilities: capabilities,
    ),
  );
}

/// Sekcje tematyczne grupujące zakładki ustawień w panelu administratora.
enum ProjectSettingsSection {
  project,
  workOrganization,
  peopleAndAccess,
  automations,
}

/// Deskryptor pojedynczej zakładki w centrum ustawień.
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

/// Dedykowany modal ustawień projektu z nawigacją zakładkami i lazy loadingiem.
class ProjectSettingsModal extends StatefulWidget {
  const ProjectSettingsModal({
    required this.project,
    required this.userRole,
    this.onProjectDeleted,
    this.initialTab = ProjectSettingsTab.general,
    this.initialCapabilities,
    super.key,
  });

  /// Dane projektu.
  final ProjectListItem project;

  /// Rola użytkownika w projekcie.
  final ProjectRole? userRole;

  /// Callback po trwałym usunięciu projektu.
  final VoidCallback? onProjectDeleted;

  /// Początkowa zakładka w modalnym oknie ustawień.
  final ProjectSettingsTab initialTab;

  /// Opcjonalne bazowe uprawnienia projektu.
  final ProjectCapabilities? initialCapabilities;

  @override
  State<ProjectSettingsModal> createState() => _ProjectSettingsModalState();
}

class _ProjectSettingsModalState extends State<ProjectSettingsModal> {
  late ProjectSettingsTab _currentTab;
  late ProjectCapabilities _capabilities;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Pamięć podręczna (cache) dla Cubitów tworzonych na żądanie (lazy-loaded).
  ProjectGeneralSettingsCubit? _generalCubit;
  ProjectMembersSettingsCubit? _membersCubit;
  CustomWorkflowSettingsCubit? _workflowCubit;
  TaskCustomFieldsSettingsCubit? _customFieldsCubit;
  TaskLabelsSettingsCubit? _labelsCubit;
  MilestoneSettingsCubit? _milestonesCubit;
  AutomationSettingsCubit? _automationsCubit;
  ProjectTemplatesCubit? _templatesCubit;

  final Set<ProjectSettingsTab> _mutatedTabs = {};
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  static final List<ProjectSettingsTabDescriptor> _tabDescriptors = [
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.general,
      section: ProjectSettingsSection.project,
      icon: Icons.tune_rounded,
      labelBuilder: (context) => context.l10n.projectSettingsTabGeneral,
      keywordsBuilder: (context) => [
        'ogólne',
        'nazwa',
        'opis',
        'widoczność',
        'usuń',
      ],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.general),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.templates,
      section: ProjectSettingsSection.project,
      icon: Icons.dashboard_customize_rounded,
      labelBuilder: (context) => context.l10n.projectSettingsTabTemplates,
      keywordsBuilder: (context) => ['szablony', 'template', 'zapisz'],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.templates),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.members,
      section: ProjectSettingsSection.peopleAndAccess,
      icon: Icons.people_outline_rounded,
      labelBuilder: (context) => context.l10n.projectSettingsTabMembers,
      keywordsBuilder: (context) => [
        'członkowie',
        'role',
        'użytkownicy',
        'dostęp',
      ],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.members),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.workflow,
      section: ProjectSettingsSection.workOrganization,
      icon: Icons.view_kanban_outlined,
      labelBuilder: (context) => context.l10n.projectSettingsTabWorkflow,
      keywordsBuilder: (context) => [
        'workflow',
        'statusy',
        'przepływ',
        'kanban',
      ],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.workflow),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.customFields,
      section: ProjectSettingsSection.workOrganization,
      icon: Icons.data_object_rounded,
      labelBuilder: (context) => context.l10n.projectSettingsTabCustomFields,
      keywordsBuilder: (context) => [
        'pola',
        'własne',
        'custom fields',
        'kolumny',
      ],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.customFields),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.labels,
      section: ProjectSettingsSection.workOrganization,
      icon: Icons.label_outline_rounded,
      labelBuilder: (context) => context.l10n.projectSettingsTabLabels,
      keywordsBuilder: (context) => ['etykiety', 'tagi', 'kolory'],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.labels),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.milestones,
      section: ProjectSettingsSection.workOrganization,
      icon: Icons.flag_outlined,
      labelBuilder: (context) => context.l10n.projectSettingsTabMilestones,
      keywordsBuilder: (context) => [
        'kamienie',
        'milowe',
        'milestones',
        'cele',
      ],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.milestones),
    ),
    ProjectSettingsTabDescriptor(
      tab: ProjectSettingsTab.automations,
      section: ProjectSettingsSection.automations,
      icon: Icons.bolt_rounded,
      labelBuilder: (context) => context.l10n.projectSettingsTabAutomations,
      keywordsBuilder: (context) => [
        'automatyzacje',
        'reguły',
        'akcje',
        'wyzwalacze',
      ],
      isVisible: (caps) => caps.canViewTab(ProjectSettingsTab.automations),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
    _capabilities =
        widget.initialCapabilities ??
        ProjectCapabilities(role: widget.userRole ?? widget.project.myRole);
    _ensureCubitForTab(_currentTab);
  }

  @override
  void dispose() {
    _searchController.dispose();
    for (final sub in _subscriptions) {
      unawaited(sub.cancel());
    }
    _subscriptions.clear();
    if (_generalCubit != null) unawaited(_generalCubit!.close());
    if (_membersCubit != null) unawaited(_membersCubit!.close());
    if (_workflowCubit != null) unawaited(_workflowCubit!.close());
    if (_customFieldsCubit != null) unawaited(_customFieldsCubit!.close());
    if (_labelsCubit != null) unawaited(_labelsCubit!.close());
    if (_milestonesCubit != null) unawaited(_milestonesCubit!.close());
    if (_automationsCubit != null) unawaited(_automationsCubit!.close());
    if (_templatesCubit != null) unawaited(_templatesCubit!.close());
    super.dispose();
  }

  void _closeModal() {
    Navigator.of(context).pop(
      ProjectSettingsResult(
        mutatedTabs: Set.unmodifiable(_mutatedTabs),
      ),
    );
  }

  void _ensureCubitForTab(ProjectSettingsTab tab) {
    switch (tab) {
      case ProjectSettingsTab.general:
        if (_generalCubit == null) {
          final repo = context.read<ProjectsRepository>();
          final cubit = ProjectGeneralSettingsCubit(
            workspaceId: widget.project.workspaceId,
            projectId: widget.project.id,
            repository: repo,
          );
          _subscriptions.add(
            cubit.stream.listen((s) {
              if (s is ProjectGeneralSettingsLoaded && s.saveSuccess) {
                _mutatedTabs.add(ProjectSettingsTab.general);
              }
            }),
          );
          unawaited(cubit.load(initialProject: widget.project));
          _generalCubit = cubit;
        }
      case ProjectSettingsTab.templates:
        if (_templatesCubit == null) {
          final repo = context.read<ProjectTemplatesRepository>();
          final cubit = ProjectTemplatesCubit(
            workspaceId: widget.project.workspaceId,
            projectId: widget.project.id,
            repository: repo,
          );
          var wasSaving = false;
          _subscriptions.add(
            cubit.stream.listen((s) {
              if (s is ProjectTemplatesReady) {
                if (wasSaving && !s.isSaving && s.error == null) {
                  _mutatedTabs.add(ProjectSettingsTab.templates);
                }
                wasSaving = s.isSaving;
              }
            }),
          );
          unawaited(cubit.load());
          _templatesCubit = cubit;
        }
      case ProjectSettingsTab.members:
        if (_membersCubit == null) {
          final projectsRepo = context.read<ProjectsRepository>();
          final workspacesRepo = context.read<WorkspacesRepository>();
          final cubit = ProjectMembersSettingsCubit(
            workspaceId: widget.project.workspaceId,
            projectId: widget.project.id,
            projectsRepository: projectsRepo,
            workspacesRepository: workspacesRepo,
          );
          var wasMutating = false;
          _subscriptions.add(
            cubit.stream.listen((s) {
              if (s is ProjectMembersSettingsLoaded) {
                if (wasMutating && !s.isMutating && s.error == null) {
                  _mutatedTabs.add(ProjectSettingsTab.members);
                }
                wasMutating = s.isMutating;
              }
            }),
          );
          unawaited(cubit.load());
          _membersCubit = cubit;
        }
      case ProjectSettingsTab.workflow:
        if (_workflowCubit == null) {
          final repo = context.read<CustomWorkflowRepository>();
          final cubit = CustomWorkflowSettingsCubit(
            workspaceId: widget.project.workspaceId,
            projectId: widget.project.id,
            repository: repo,
          );
          var wasSaving = false;
          _subscriptions.add(
            cubit.stream.listen((s) {
              if (s is CustomWorkflowSettingsReady) {
                if (wasSaving && !s.isSaving && s.error == null) {
                  _mutatedTabs.add(ProjectSettingsTab.workflow);
                }
                wasSaving = s.isSaving;
              }
            }),
          );
          unawaited(cubit.load());
          _workflowCubit = cubit;
        }
      case ProjectSettingsTab.customFields:
        if (_customFieldsCubit == null) {
          final repo = context.read<TaskMetadataRepository>();
          final cubit = TaskCustomFieldsSettingsCubit(
            workspaceId: widget.project.workspaceId,
            projectId: widget.project.id,
            repository: repo,
          );
          var wasSaving = false;
          _subscriptions.add(
            cubit.stream.listen((s) {
              if (s is TaskCustomFieldsSettingsReady) {
                if (wasSaving && !s.isSaving && s.error == null) {
                  _mutatedTabs.add(ProjectSettingsTab.customFields);
                }
                wasSaving = s.isSaving;
              }
            }),
          );
          unawaited(cubit.load());
          _customFieldsCubit = cubit;
        }
      case ProjectSettingsTab.labels:
        if (_labelsCubit == null) {
          final repo = context.read<TaskMetadataRepository>();
          final cubit = TaskLabelsSettingsCubit(
            workspaceId: widget.project.workspaceId,
            projectId: widget.project.id,
            repository: repo,
          );
          var wasSaving = false;
          _subscriptions.add(
            cubit.stream.listen((s) {
              if (s is TaskLabelsSettingsReady) {
                if (wasSaving && !s.isSaving && s.error == null) {
                  _mutatedTabs.add(ProjectSettingsTab.labels);
                }
                wasSaving = s.isSaving;
              }
            }),
          );
          unawaited(cubit.load());
          _labelsCubit = cubit;
        }
      case ProjectSettingsTab.milestones:
        if (_milestonesCubit == null) {
          final repo = context.read<MilestoneRepository>();
          final cubit = MilestoneSettingsCubit(
            workspaceId: widget.project.workspaceId,
            projectId: widget.project.id,
            repository: repo,
          );
          var wasSaving = false;
          _subscriptions.add(
            cubit.stream.listen((s) {
              if (s is MilestoneSettingsReady) {
                if (wasSaving && !s.isSaving && s.error == null) {
                  _mutatedTabs.add(ProjectSettingsTab.milestones);
                }
                wasSaving = s.isSaving;
              }
            }),
          );
          unawaited(cubit.load());
          _milestonesCubit = cubit;
        }
      case ProjectSettingsTab.automations:
        if (_automationsCubit == null) {
          final automationRepo = context.read<AutomationRepository>();
          final tasksRepo = context.read<TasksRepository>();
          final profilesRepo = context.read<ProjectMemberProfilesRepository>();
          final metadataRepo = context.read<TaskMetadataRepository>();
          final cubit = AutomationSettingsCubit(
            workspaceId: widget.project.workspaceId,
            projectId: widget.project.id,
            repository: automationRepo,
            tasksRepository: tasksRepo,
            memberProfilesRepository: profilesRepo,
            taskMetadataRepository: metadataRepo,
          );
          var wasBusy = false;
          _subscriptions.add(
            cubit.stream.listen((s) {
              if (s is AutomationSettingsReady) {
                final isBusy = s.busyRuleId != null || s.isInstallingRecipe;
                if (wasBusy && !isBusy && s.error == null) {
                  _mutatedTabs.add(ProjectSettingsTab.automations);
                }
                wasBusy = isBusy;
              }
            }),
          );
          unawaited(cubit.load());
          _automationsCubit = cubit;
        }
    }
  }

  void _selectTab(ProjectSettingsTab tab) {
    if (_currentTab == tab) return;
    _ensureCubitForTab(tab);
    setState(() => _currentTab = tab);
  }

  String _sectionLabel(BuildContext context, ProjectSettingsSection section) =>
      switch (section) {
        ProjectSettingsSection.project => 'Projekt',
        ProjectSettingsSection.workOrganization => 'Organizacja pracy',
        ProjectSettingsSection.peopleAndAccess => 'Ludzie i dostęp',
        ProjectSettingsSection.automations => 'Automatyzacje',
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.width < 768;

    final dialogWidth = isCompact
        ? (size.width - 16).clamp(320.0, size.width)
        : (size.width * 0.88).clamp(640.0, 1080.0);
    final dialogHeight = isCompact
        ? (size.height - 24).clamp(420.0, size.height)
        : (size.height * 0.85).clamp(520.0, 800.0);

    final visibleDescriptors = _tabDescriptors.where((descriptor) {
      if (!descriptor.isVisible(_capabilities)) return false;
      if (_searchQuery.isEmpty) return true;
      final query = _searchQuery.toLowerCase();
      final label = descriptor.labelBuilder(context).toLowerCase();
      final keywords = descriptor.keywordsBuilder(context);
      return label.contains(query) ||
          keywords.any((k) => k.toLowerCase().contains(query));
    }).toList();

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): _closeModal,
      },
      child: Focus(
        autofocus: true,
        child: Dialog(
          backgroundColor: colors.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: .circular(Sizes.p16),
            side: BorderSide(
              color: colors.outlineVariant.withValues(alpha: .6),
            ),
          ),
          insetPadding: EdgeInsets.all(isCompact ? Sizes.p8 : Sizes.p24),
          clipBehavior: .antiAlias,
          child: SizedBox(
            width: dialogWidth,
            height: dialogHeight,
            child: Column(
              children: [
                // Header z informacją o zakresie i symulacją roli
                _buildHeader(context, colors, l10n, isCompact),

                // Pasek informacyjny zakresu zmian
                _buildScopeBanner(context, colors),

                // Zakładki mobilne
                if (isCompact)
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerLow,
                      border: Border(
                        bottom: BorderSide(
                          color: colors.outlineVariant.withValues(alpha: .5),
                        ),
                      ),
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const .symmetric(
                        horizontal: Sizes.p8,
                        vertical: Sizes.p6,
                      ),
                      children: [
                        for (final descriptor in visibleDescriptors)
                          _buildCompactTabPill(
                            descriptor: descriptor,
                            context: context,
                          ),
                      ],
                    ),
                  ),

                // Ciało modala (Sidebar + Content)
                Expanded(
                  child: Row(
                    children: [
                      // Sidebar desktopowy
                      if (!isCompact)
                        _buildDesktopSidebar(
                          context,
                          colors,
                          visibleDescriptors,
                        ),

                      // Obszar zawartości aktywnej zakładki
                      Expanded(
                        child: _buildContentArea(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colors,
    AppLocalizations l10n,
    bool isCompact,
  ) => Container(
    padding: const .symmetric(
      horizontal: Sizes.p20,
      vertical: Sizes.p12,
    ),
    decoration: BoxDecoration(
      color: colors.surfaceContainerLowest,
      border: Border(
        bottom: BorderSide(
          color: colors.outlineVariant.withValues(alpha: .5),
        ),
      ),
    ),
    child: Row(
      children: [
        Icon(
          Icons.settings_suggest_rounded,
          color: colors.primary,
          size: Sizes.p24,
        ),
        Gaps.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.projectSettingsTitle,
                style: context.text.titleMedium?.copyWith(
                  fontWeight: .w700,
                  color: colors.onSurface,
                ),
              ),
              Gaps.h2,
              Text(
                widget.project.name,
                style: context.text.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (!isCompact && _capabilities.canManage) ...[
          _buildRolePreviewSelector(context, colors),
          Gaps.w12,
        ],
        IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: l10n.close,
          onPressed: _closeModal,
        ),
      ],
    ),
  );

  Widget _buildScopeBanner(BuildContext context, ColorScheme colors) =>
      Container(
        padding: const .symmetric(horizontal: Sizes.p16, vertical: Sizes.p6),
        decoration: BoxDecoration(
          color: colors.primaryContainer.withValues(alpha: .2),
          border: Border(
            bottom: BorderSide(
              color: colors.outlineVariant.withValues(alpha: .3),
              width: 0.8,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.shield_outlined,
              size: Sizes.p16,
              color: colors.primary,
            ),
            Gaps.w8,
            Expanded(
              child: Text(
                'Zakres: Projekt • Modyfikacje konfiguracji dotyczą wszystkich członków tego projektu.',
                style: context.text.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
            ),
            if (_capabilities.simulatedRole != null) ...[
              Container(
                padding: const .symmetric(horizontal: Sizes.p6, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.tertiaryContainer,
                  borderRadius: .circular(Sizes.p4),
                ),
                child: Text(
                  'Podgląd jako: ${_capabilities.simulatedRole!.name}',
                  style: context.text.labelSmall?.copyWith(
                    color: colors.onTertiaryContainer,
                    fontWeight: .w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ],
        ),
      );

  Widget _buildRolePreviewSelector(
    BuildContext context,
    ColorScheme colors,
  ) => Container(
    height: 32,
    padding: const .symmetric(horizontal: Sizes.p8),
    decoration: BoxDecoration(
      borderRadius: .circular(Sizes.p8),
      border: Border.all(color: colors.outlineVariant.withValues(alpha: .6)),
      color: colors.surface,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.visibility_outlined,
          size: Sizes.p16,
          color: colors.onSurfaceVariant,
        ),
        Gaps.w6,
        DropdownButtonHideUnderline(
          child: DropdownButton<ProjectRole?>(
            value: _capabilities.simulatedRole,
            hint: Text(
              'Zobacz jako rola',
              style: context.text.labelSmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            isDense: true,
            style: context.text.labelSmall?.copyWith(
              color: colors.onSurface,
              fontWeight: .w600,
            ),
            items: [
              DropdownMenuItem(
                child: Text('Domyślna (${_capabilities.role?.name ?? 'Brak'})'),
              ),
              ...ProjectRole.values.map(
                (role) => DropdownMenuItem(
                  value: role,
                  child: Text(role.name),
                ),
              ),
            ],
            onChanged: (selectedRole) {
              setState(() {
                _capabilities = _capabilities.withPreviewRole(selectedRole);
                if (!_capabilities.canViewTab(_currentTab)) {
                  _currentTab = ProjectSettingsTab.general;
                  _ensureCubitForTab(_currentTab);
                }
              });
            },
          ),
        ),
      ],
    ),
  );

  Widget _buildDesktopSidebar(
    BuildContext context,
    ColorScheme colors,
    List<ProjectSettingsTabDescriptor> visibleDescriptors,
  ) {
    final grouped =
        <ProjectSettingsSection, List<ProjectSettingsTabDescriptor>>{};
    for (final desc in visibleDescriptors) {
      grouped.putIfAbsent(desc.section, () => []).add(desc);
    }

    return Container(
      width: 230,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        border: Border(
          right: BorderSide(
            color: colors.outlineVariant.withValues(alpha: .5),
          ),
        ),
      ),
      child: Column(
        children: [
          // Wyszukiwarka zakładek
          Padding(
            padding: const .fromLTRB(Sizes.p12, Sizes.p10, Sizes.p12, Sizes.p6),
            child: SizedBox(
              height: 32,
              child: TextField(
                controller: _searchController,
                style: context.text.bodySmall,
                decoration: InputDecoration(
                  hintText: 'Szukaj ustawień...',
                  hintStyle: context.text.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, size: Sizes.p16),
                  prefixIconConstraints: const BoxConstraints.tightFor(
                    width: 28,
                    height: 28,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 14),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding: const .symmetric(horizontal: 8, vertical: 6),
                  border: OutlineInputBorder(
                    borderRadius: .circular(Sizes.p8),
                    borderSide: BorderSide(
                      color: colors.outlineVariant.withValues(alpha: .5),
                    ),
                  ),
                ),
                onChanged: (val) => setState(() => _searchQuery = val.trim()),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const .symmetric(
                horizontal: Sizes.p8,
                vertical: Sizes.p4,
              ),
              children: [
                for (final entry in grouped.entries) ...[
                  Padding(
                    padding: const .fromLTRB(
                      Sizes.p8,
                      Sizes.p10,
                      Sizes.p8,
                      Sizes.p4,
                    ),
                    child: Text(
                      _sectionLabel(context, entry.key).toUpperCase(),
                      style: context.text.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: .w700,
                        color: colors.onSurfaceVariant.withValues(alpha: .8),
                        letterSpacing: .6,
                      ),
                    ),
                  ),
                  for (final desc in entry.value)
                    _TabButton(
                      icon: desc.icon,
                      label: desc.labelBuilder(context),
                      isSelected: _currentTab == desc.tab,
                      onTap: () => _selectTab(desc.tab),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTabPill({
    required ProjectSettingsTabDescriptor descriptor,
    required BuildContext context,
  }) {
    final colors = context.colors;
    final isSelected = _currentTab == descriptor.tab;
    final label = descriptor.labelBuilder(context);

    return Padding(
      padding: const EdgeInsets.only(right: Sizes.p6),
      child: Material(
        color: isSelected
            ? colors.primary.withValues(alpha: .12)
            : colors.surfaceContainerLowest,
        borderRadius: .circular(Sizes.p8),
        child: InkWell(
          onTap: () => _selectTab(descriptor.tab),
          borderRadius: .circular(Sizes.p8),
          child: Container(
            padding: const .symmetric(
              horizontal: Sizes.p10,
              vertical: Sizes.p4,
            ),
            decoration: BoxDecoration(
              borderRadius: .circular(Sizes.p8),
              border: Border.all(
                color: isSelected
                    ? colors.primary.withValues(alpha: .5)
                    : colors.outlineVariant.withValues(alpha: .4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  descriptor.icon,
                  size: Sizes.p16,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
                Gaps.w6,
                Text(
                  label,
                  style: context.text.labelSmall?.copyWith(
                    fontWeight: isSelected ? .w700 : .w500,
                    color: isSelected
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentArea(BuildContext context) {
    final effectiveRole = _capabilities.effectiveRole ?? ProjectRole.observer;

    return switch (_currentTab) {
      ProjectSettingsTab.general => BlocProvider.value(
        value: _generalCubit ?? (_getOrCreateGeneralCubit()),
        child: ProjectGeneralTabView(
          project: widget.project,
          userRole: effectiveRole,
          onProjectDeleted: () {
            Navigator.of(context).pop();
            widget.onProjectDeleted?.call();
          },
        ),
      ),
      ProjectSettingsTab.members => BlocProvider.value(
        value: _membersCubit ?? (_getOrCreateMembersCubit()),
        child: ProjectMembersTabView(
          userRole: effectiveRole,
        ),
      ),
      ProjectSettingsTab.workflow => BlocProvider.value(
        value: _workflowCubit ?? (_getOrCreateWorkflowCubit()),
        child: ProjectWorkflowTabView(
          userRole: effectiveRole,
        ),
      ),
      ProjectSettingsTab.customFields => BlocProvider.value(
        value: _customFieldsCubit ?? (_getOrCreateCustomFieldsCubit()),
        child: ProjectCustomFieldsTabView(
          userRole: effectiveRole,
        ),
      ),
      ProjectSettingsTab.labels => BlocProvider.value(
        value: _labelsCubit ?? (_getOrCreateLabelsCubit()),
        child: ProjectLabelsTabView(
          userRole: effectiveRole,
        ),
      ),
      ProjectSettingsTab.milestones => BlocProvider.value(
        value: _milestonesCubit ?? (_getOrCreateMilestonesCubit()),
        child: ProjectMilestonesTabView(
          userRole: effectiveRole,
        ),
      ),
      ProjectSettingsTab.automations => BlocProvider.value(
        value: _automationsCubit ?? (_getOrCreateAutomationsCubit()),
        child: ProjectAutomationsTabView(
          userRole: effectiveRole,
        ),
      ),
      ProjectSettingsTab.templates => BlocProvider.value(
        value: _templatesCubit ?? (_getOrCreateTemplatesCubit()),
        child: ProjectTemplatesTabView(
          project: widget.project,
          canManage: _capabilities.canManageTemplates,
        ),
      ),
    };
  }

  ProjectGeneralSettingsCubit _getOrCreateGeneralCubit() {
    _ensureCubitForTab(ProjectSettingsTab.general);
    return _generalCubit!;
  }

  ProjectMembersSettingsCubit _getOrCreateMembersCubit() {
    _ensureCubitForTab(ProjectSettingsTab.members);
    return _membersCubit!;
  }

  CustomWorkflowSettingsCubit _getOrCreateWorkflowCubit() {
    _ensureCubitForTab(ProjectSettingsTab.workflow);
    return _workflowCubit!;
  }

  TaskCustomFieldsSettingsCubit _getOrCreateCustomFieldsCubit() {
    _ensureCubitForTab(ProjectSettingsTab.customFields);
    return _customFieldsCubit!;
  }

  TaskLabelsSettingsCubit _getOrCreateLabelsCubit() {
    _ensureCubitForTab(ProjectSettingsTab.labels);
    return _labelsCubit!;
  }

  MilestoneSettingsCubit _getOrCreateMilestonesCubit() {
    _ensureCubitForTab(ProjectSettingsTab.milestones);
    return _milestonesCubit!;
  }

  AutomationSettingsCubit _getOrCreateAutomationsCubit() {
    _ensureCubitForTab(ProjectSettingsTab.automations);
    return _automationsCubit!;
  }

  ProjectTemplatesCubit _getOrCreateTemplatesCubit() {
    _ensureCubitForTab(ProjectSettingsTab.templates);
    return _templatesCubit!;
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: isSelected ? colors.surfaceContainerLowest : Colors.transparent,
        borderRadius: .circular(Sizes.p8),
        border: Border.all(
          color: isSelected
              ? colors.outlineVariant.withValues(alpha: .8)
              : Colors.transparent,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: .04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: .circular(Sizes.p8),
        child: InkWell(
          onTap: onTap,
          borderRadius: .circular(Sizes.p8),
          child: Padding(
            padding: const .symmetric(
              horizontal: Sizes.p12,
              vertical: Sizes.p10,
            ),
            child: Row(
              children: [
                if (isSelected)
                  Container(
                    width: 3,
                    height: 16,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: .circular(2),
                    ),
                  ),
                Icon(
                  icon,
                  size: Sizes.p18,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
                Gaps.w8,
                Expanded(
                  child: Text(
                    label,
                    style: context.text.bodyMedium?.copyWith(
                      fontWeight: isSelected ? .w700 : .w500,
                      color: isSelected
                          ? colors.onSurface
                          : colors.onSurfaceVariant,
                      letterSpacing: -.1,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
