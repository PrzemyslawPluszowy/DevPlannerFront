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
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      Sizes.p16,
                      Sizes.p8,
                      Sizes.p8,
                      Sizes.p4,
                    ),
                    child: Text(
                      ProjectSettingsTabCatalog.sectionLabel(entry.key)
                          .toUpperCase(),
                      style: context.text.labelSmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
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
    height: Sizes.p44,
    child: ListView(
      scrollDirection: .horizontal,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: Sizes.p12),
      children: [
        for (final descriptor in descriptors)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: Sizes.p6),
            child: Center(
              child: _NavigationButton(
                descriptor: descriptor,
                selected: currentTab == descriptor.tab,
                onSelected: onSelected,
                expanded: false,
              ),
            ),
          ),
      ],
    ),
  );
}

/// Wiersz nawigacji ustawień.
///
/// Wariant rozciągnięty (panel boczny) zajmuje pełną szerokość i wyrównuje
/// treść do lewej krawędzi, wariant kompaktowy jest chipem przewijanej listy.
/// Zaznaczenie jest widoczne tłem i kolorem ikony, nie tylko kolorem tekstu.
class _NavigationButton extends StatelessWidget {
  const _NavigationButton({
    required this.descriptor,
    required this.selected,
    required this.onSelected,
    this.expanded = true,
  });

  final ProjectSettingsTabDescriptor descriptor;
  final bool selected;
  final ValueChanged<ProjectSettingsTab> onSelected;
  final bool expanded;

  static const double _rowHeight = Sizes.p36;
  static const double _rowIndent = Sizes.p8;
  static const double _rowMargin = Sizes.p8;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final surfaceRoles = context.surfaceRoles;
    final label = descriptor.labelBuilder(context);

    return Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: expanded ? _rowMargin : 0,
      ),
      child: TextButton(
        onPressed: () => onSelected(descriptor.tab),
        style:
            TextButton.styleFrom(
              alignment: AlignmentDirectional.centerStart,
              minimumSize: const Size(0, _rowHeight),
              padding: EdgeInsetsDirectional.symmetric(
                horizontal: expanded ? _rowIndent : Sizes.p12,
              ),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Sizes.p8),
              ),
              foregroundColor: selected ? colors.primary : colors.onSurface,
              backgroundColor: selected ? surfaceRoles.tintedBackground : null,
              side: selected
                  ? BorderSide(color: surfaceRoles.tintedBorder)
                  : null,
              textStyle: context.text.labelLarge?.copyWith(
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return surfaceRoles.pressedOverlay;
                }
                if (states.contains(WidgetState.hovered) ||
                    states.contains(WidgetState.focused)) {
                  return surfaceRoles.hoverOverlay;
                }
                return null;
              }),
            ),
        child: Row(
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          children: [
            Icon(descriptor.icon, size: Sizes.p16),
            Gaps.w8,
            if (expanded)
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            else
              Text(label, maxLines: 1),
          ],
        ),
      ),
    );
  }
}
