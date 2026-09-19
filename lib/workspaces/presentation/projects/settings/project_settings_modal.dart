import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_capabilities.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_settings_tab.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/cubit/project_settings_cubit_registry.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/widgets/project_settings_modal_frame.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/widgets/project_settings_tab_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'package:devplanner/workspaces/domain/models/project_settings_tab.dart';

/// Wynik zamknięcia centrum ustawień projektu z listą zmienionych obszarów.
class ProjectSettingsResult {
  const ProjectSettingsResult({this.mutatedTabs = const {}});

  final Set<ProjectSettingsTab> mutatedTabs;
  bool get hasChanges => mutatedTabs.isNotEmpty;
  bool get affectsWorkflow => mutatedTabs.contains(ProjectSettingsTab.workflow);
  bool get affectsMetadata =>
      mutatedTabs.contains(ProjectSettingsTab.customFields) ||
      mutatedTabs.contains(ProjectSettingsTab.labels) ||
      mutatedTabs.contains(ProjectSettingsTab.milestones);
  bool get affectsGeneral => mutatedTabs.contains(ProjectSettingsTab.general);
}

/// FASADA otwierania centrum ustawień bez globalnego entrypointu UI.
class ProjectSettingsDialogs {
  const ProjectSettingsDialogs._();

  /// Otwiera responsywne centrum ustawień projektu z lazy loadingiem zakładek.
  static Future<ProjectSettingsResult?> show({
    required BuildContext context,
    required ProjectListItem project,
    ProjectRole? userRole,
    VoidCallback? onProjectDeleted,
    ProjectSettingsTab initialTab = ProjectSettingsTab.general,
  }) {
    final permissions = context
        .read<AuthSessionPort?>()
        ?.snapshot
        .user
        ?.permissions;
    final isSuperAdmin =
        permissions?.contains('SuperAdmin') == true ||
        permissions?.contains('bswfms.custom_modules.RNext-admin') == true;
    final capabilities = ProjectCapabilities(
      role: userRole ?? project.myRole,
      isSuperAdmin: isSuperAdmin,
    );
    return showDialog<ProjectSettingsResult>(
      context: context,
      builder: (_) => ProjectSettingsModal(
        project: project,
        userRole: userRole ?? project.myRole,
        onProjectDeleted: onProjectDeleted,
        initialTab: capabilities.canViewTab(initialTab)
            ? initialTab
            : ProjectSettingsTab.general,
        initialCapabilities: capabilities,
      ),
    );
  }
}

/// Dedykowany modal ustawień projektu z nawigacją i lazy Cubitami.
class ProjectSettingsModal extends StatefulWidget {
  const ProjectSettingsModal({
    required this.project,
    required this.userRole,
    this.onProjectDeleted,
    this.initialTab = ProjectSettingsTab.general,
    this.initialCapabilities,
    super.key,
  });

  final ProjectListItem project;
  final ProjectRole? userRole;
  final VoidCallback? onProjectDeleted;
  final ProjectSettingsTab initialTab;
  final ProjectCapabilities? initialCapabilities;

  @override
  State<ProjectSettingsModal> createState() => _ProjectSettingsModalState();
}

class _ProjectSettingsModalState extends State<ProjectSettingsModal> {
  final TextEditingController _searchController = TextEditingController();
  final Set<ProjectSettingsTab> _mutatedTabs = {};
  late final ValueNotifier<_ProjectSettingsUiState> _uiState;
  late final ProjectSettingsCubitRegistry _registry;

  @override
  void initState() {
    super.initState();
    final capabilities =
        widget.initialCapabilities ??
        ProjectCapabilities(
          role: widget.userRole ?? widget.project.myRole,
        );
    _uiState = ValueNotifier(
      _ProjectSettingsUiState(
        currentTab: widget.initialTab,
        capabilities: capabilities,
      ),
    );
    _registry = ProjectSettingsCubitRegistry(
      context: context,
      project: widget.project,
      onMutation: _mutatedTabs.add,
    );
    _registry.ensure(widget.initialTab);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _uiState.dispose();
    _registry.dispose();
    super.dispose();
  }

  void _selectTab(ProjectSettingsTab tab) {
    final state = _uiState.value;
    if (state.currentTab == tab) return;
    _registry.ensure(tab);
    _uiState.value = state.copyWith(currentTab: tab);
  }

  void _changePreviewRole(ProjectRole? role) {
    final state = _uiState.value;
    final capabilities = state.capabilities.withPreviewRole(role);
    final tab = capabilities.canViewTab(state.currentTab)
        ? state.currentTab
        : ProjectSettingsTab.general;
    _registry.ensure(tab);
    _uiState.value = state.copyWith(
      capabilities: capabilities,
      currentTab: tab,
    );
  }

  void _close() => Navigator.of(context).pop(
    ProjectSettingsResult(
      mutatedTabs: Set.unmodifiable(_mutatedTabs),
    ),
  );

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<_ProjectSettingsUiState>(
        valueListenable: _uiState,
        builder: (context, state, _) => CallbackShortcuts(
          bindings: {const SingleActivator(LogicalKeyboardKey.escape): _close},
          child: Focus(
            autofocus: true,
            child: ProjectSettingsModalFrame(
              project: widget.project,
              capabilities: state.capabilities,
              currentTab: state.currentTab,
              searchController: _searchController,
              searchQuery: state.searchQuery,
              onClose: _close,
              onTabSelected: _selectTab,
              onSearchChanged: (query) =>
                  _uiState.value = state.copyWith(searchQuery: query.trim()),
              onRolePreviewChanged: _changePreviewRole,
              content: ProjectSettingsTabContent(
                tab: state.currentTab,
                project: widget.project,
                capabilities: state.capabilities,
                registry: _registry,
                onProjectDeleted: () {
                  Navigator.of(context).pop();
                  widget.onProjectDeleted?.call();
                },
              ),
            ),
          ),
        ),
      );
}

class _ProjectSettingsUiState {
  const _ProjectSettingsUiState({
    required this.currentTab,
    required this.capabilities,
    this.searchQuery = '',
  });

  final ProjectSettingsTab currentTab;
  final ProjectCapabilities capabilities;
  final String searchQuery;

  _ProjectSettingsUiState copyWith({
    ProjectSettingsTab? currentTab,
    ProjectCapabilities? capabilities,
    String? searchQuery,
  }) => _ProjectSettingsUiState(
    currentTab: currentTab ?? this.currentTab,
    capabilities: capabilities ?? this.capabilities,
    searchQuery: searchQuery ?? this.searchQuery,
  );
}
