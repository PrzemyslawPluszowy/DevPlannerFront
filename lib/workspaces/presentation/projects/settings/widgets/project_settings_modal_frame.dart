import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_capabilities.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_settings_tab.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/widgets/project_settings_tab_catalog.dart';
import 'package:flutter/material.dart';

/// Responsywna rama modala: nagłówek, zakres i nawigacja ustawień.
class ProjectSettingsModalFrame extends StatelessWidget {
  const ProjectSettingsModalFrame({
    required this.project,
    required this.capabilities,
    required this.currentTab,
    required this.searchController,
    required this.searchQuery,
    required this.onClose,
    required this.onTabSelected,
    required this.onSearchChanged,
    required this.onRolePreviewChanged,
    required this.content,
    super.key,
  });

  final ProjectListItem project;
  final ProjectCapabilities capabilities;
  final ProjectSettingsTab currentTab;
  final TextEditingController searchController;
  final String searchQuery;
  final VoidCallback onClose;
  final ValueChanged<ProjectSettingsTab> onTabSelected;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<ProjectRole?> onRolePreviewChanged;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = MediaQuery.sizeOf(context);
    final compact = size.width < 768;
    final descriptors = _visibleDescriptors(context);
    return Dialog(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.all(compact ? Sizes.p8 : Sizes.p24),
      shape: RoundedRectangleBorder(borderRadius: .circular(Sizes.p16)),
      clipBehavior: .antiAlias,
      child: SizedBox(
        width: compact
            ? (size.width - 16).clamp(320.0, size.width)
            : (size.width * .88).clamp(640.0, 1080.0),
        height: compact
            ? (size.height - 24).clamp(420.0, size.height)
            : (size.height * .85).clamp(520.0, 800.0),
        child: Column(
          children: [
            _ModalHeader(
              project: project,
              capabilities: capabilities,
              compact: compact,
              onClose: onClose,
              onRolePreviewChanged: onRolePreviewChanged,
            ),
            _ScopeBanner(capabilities: capabilities),
            if (compact)
              _CompactNavigation(
                descriptors: descriptors,
                currentTab: currentTab,
                onSelected: onTabSelected,
              ),
            Expanded(
              child: Row(
                children: [
                  if (!compact)
                    _DesktopNavigation(
                      descriptors: descriptors,
                      currentTab: currentTab,
                      controller: searchController,
                      searchQuery: searchQuery,
                      onSearchChanged: onSearchChanged,
                      onSelected: onTabSelected,
                    ),
                  Expanded(child: content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ProjectSettingsTabDescriptor> _visibleDescriptors(BuildContext context) {
    final query = searchQuery.toLowerCase();
    return ProjectSettingsTabCatalog.descriptors.where((descriptor) {
      if (!descriptor.isVisible(capabilities)) return false;
      return query.isEmpty ||
          descriptor.labelBuilder(context).toLowerCase().contains(query) ||
          descriptor
              .keywordsBuilder(context)
              .any((keyword) => keyword.toLowerCase().contains(query));
    }).toList();
  }
}

class _ModalHeader extends StatelessWidget {
  const _ModalHeader({
    required this.project,
    required this.capabilities,
    required this.compact,
    required this.onClose,
    required this.onRolePreviewChanged,
  });
  final ProjectListItem project;
  final ProjectCapabilities capabilities;
  final bool compact;
  final VoidCallback onClose;
  final ValueChanged<ProjectRole?> onRolePreviewChanged;
  @override
  Widget build(BuildContext context) => Container(
    padding: const .symmetric(horizontal: Sizes.p20, vertical: Sizes.p12),
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: context.colors.outlineVariant.withValues(alpha: .5),
        ),
      ),
    ),
    child: Row(
      children: [
        Icon(
          Icons.settings_suggest_rounded,
          color: context.colors.primary,
          size: Sizes.p24,
        ),
        Gaps.w12,
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              Text(
                context.l10n.projectSettingsTitle,
                style: context.text.titleMedium?.copyWith(fontWeight: .w700),
              ),
              Text(
                project.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        if (!compact && capabilities.canManage)
          _RolePreview(
            capabilities: capabilities,
            onChanged: onRolePreviewChanged,
          ),
        IconButton(
          icon: const Icon(Icons.close_rounded),
          tooltip: context.l10n.close,
          onPressed: onClose,
        ),
      ],
    ),
  );
}

class _RolePreview extends StatelessWidget {
  const _RolePreview({required this.capabilities, required this.onChanged});
  final ProjectCapabilities capabilities;
  final ValueChanged<ProjectRole?> onChanged;
  @override
  Widget build(BuildContext context) => DropdownButtonHideUnderline(
    child: DropdownButton<ProjectRole?>(
      value: capabilities.simulatedRole,
      isDense: true,
      hint: const Text('Zobacz jako rola'),
      onChanged: onChanged,
      items: [
        DropdownMenuItem(
          child: Text('Domyślna (${capabilities.role?.name ?? 'Brak'})'),
        ),
        ...ProjectRole.values.map(
          (role) => DropdownMenuItem(value: role, child: Text(role.name)),
        ),
      ],
    ),
  );
}

class _ScopeBanner extends StatelessWidget {
  const _ScopeBanner({required this.capabilities});
  final ProjectCapabilities capabilities;
  @override
  Widget build(BuildContext context) => Container(
    padding: const .symmetric(horizontal: Sizes.p16, vertical: Sizes.p6),
    color: context.colors.primaryContainer.withValues(alpha: .2),
    child: Row(
      children: [
        Icon(
          Icons.shield_outlined,
          size: Sizes.p16,
          color: context.colors.primary,
        ),
        Gaps.w8,
        Expanded(
          child: Text(
            'Zakres: Projekt • Modyfikacje konfiguracji dotyczą wszystkich członków tego projektu.',
            style: context.text.labelSmall,
          ),
        ),
        if (capabilities.simulatedRole != null)
          Text(
            'Podgląd jako: ${capabilities.simulatedRole!.name}',
            style: context.text.labelSmall?.copyWith(fontWeight: .w700),
          ),
      ],
    ),
  );
}

class _DesktopNavigation extends StatelessWidget {
  const _DesktopNavigation({
    required this.descriptors,
    required this.currentTab,
    required this.controller,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onSelected,
  });
  final List<ProjectSettingsTabDescriptor> descriptors;
  final ProjectSettingsTab currentTab;
  final TextEditingController controller;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<ProjectSettingsTab> onSelected;
  @override
  Widget build(BuildContext context) {
    final grouped =
        <ProjectSettingsSection, List<ProjectSettingsTabDescriptor>>{};
    for (final item in descriptors) {
      grouped.putIfAbsent(item.section, () => []).add(item);
    }
    return SizedBox(
      width: 230,
      child: Column(
        children: [
          Padding(
            padding: const .all(Sizes.p12),
            child: TextField(
              controller: controller,
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Szukaj ustawień...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: searchQuery.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          controller.clear();
                          onSearchChanged('');
                        },
                      ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                for (final entry in grouped.entries) ...[
                  Padding(
                    padding: const .all(Sizes.p8),
                    child: Text(
                      ProjectSettingsTabCatalog.sectionLabel(entry.key)
                          .toUpperCase(),
                      style: context.text.labelSmall?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                  ),
                  for (final descriptor in entry.value)
                    _NavigationButton(
                      descriptor: descriptor,
                      selected: currentTab == descriptor.tab,
                      onSelected: onSelected,
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactNavigation extends StatelessWidget {
  const _CompactNavigation({
    required this.descriptors,
    required this.currentTab,
    required this.onSelected,
  });
  final List<ProjectSettingsTabDescriptor> descriptors;
  final ProjectSettingsTab currentTab;
  final ValueChanged<ProjectSettingsTab> onSelected;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: ListView(
      scrollDirection: .horizontal,
      children: [
        for (final descriptor in descriptors)
          _NavigationButton(
            descriptor: descriptor,
            selected: currentTab == descriptor.tab,
            onSelected: onSelected,
          ),
      ],
    ),
  );
}

class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.descriptor,
    required this.selected,
    required this.onSelected,
  });
  final ProjectSettingsTabDescriptor descriptor;
  final bool selected;
  final ValueChanged<ProjectSettingsTab> onSelected;
  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: () => onSelected(descriptor.tab),
    icon: Icon(descriptor.icon, size: Sizes.p16),
    label: Text(descriptor.labelBuilder(context)),
    style: TextButton.styleFrom(
      foregroundColor: selected
          ? context.colors.primary
          : context.colors.onSurfaceVariant,
    ),
  );
}
