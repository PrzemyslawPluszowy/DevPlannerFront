import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_collapsible_navigation.dart';
import 'package:devplanner/workspaces/presentation/workspace_shell/navigation/cubit/workspace_shell_navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Statyczne menu workspace’u używane do czasu potwierdzenia kontraktów API.
///
/// Nie ma callbacków nawigacyjnych ani źródeł danych: widoczna hierarchia służy
/// wyłącznie weryfikacji webowego układu i nie może generować błędów po kliknięciu.
class WorkspaceStaticMenu extends StatelessWidget {
  const WorkspaceStaticMenu({
    required this.outerPadding,
    required this.onBack,
    required this.onFiles,
    super.key,
  });

  final double outerPadding;
  final VoidCallback onBack;
  final VoidCallback onFiles;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = context.colors;
    return BlocBuilder<
      WorkspaceShellNavigationCubit,
      WorkspaceShellNavigationState
    >(
      builder: (context, state) {
        final cubit = context.read<WorkspaceShellNavigationCubit>();
        return AppCollapsibleNavigationPanel(
          controller: cubit.panelController,
          expandedWidth: 260,
          margin: EdgeInsets.only(right: outerPadding, bottom: Sizes.p12),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF171824).withValues(alpha: .88)
                : Colors.white.withValues(alpha: .88),
            borderRadius: const BorderRadius.horizontal(
              right: Radius.circular(16),
            ),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: .14)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          enableKeyboardShortcut: false,
          expandedBuilder: (context) => _ExpandedMenu(
            colors: colors,
            controller: cubit.panelController,
            onBack: onBack,
            onFiles: onFiles,
            section: state.section,
            onSectionSelected: cubit.select,
          ),
          collapsedBuilder: (context) => _CollapsedMenu(
            controller: cubit.panelController,
            onBack: onBack,
            onFiles: onFiles,
          ),
        );
      },
    );
  }
}

class _ExpandedMenu extends StatelessWidget {
  const _ExpandedMenu({
    required this.colors,
    required this.controller,
    required this.onBack,
    required this.onFiles,
    required this.section,
    required this.onSectionSelected,
  });

  final ColorScheme colors;
  final AppCollapsibleNavigationController controller;
  final VoidCallback onBack;
  final VoidCallback onFiles;
  final WorkspaceShellSection section;
  final ValueChanged<WorkspaceShellSection> onSectionSelected;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(Sizes.p12),
    children: [
      Row(
        children: [
          IconButton(
            tooltip: context.l10n.workspaceShellBackToDirectory,
            onPressed: onBack,
            icon: const Icon(Symbols.arrow_back_rounded),
          ),
          const Icon(Symbols.grid_view_rounded, size: 18),
          Gaps.w8,
          Expanded(child: Text(context.l10n.workspaceShellNavigationTitle)),
          IconButton(
            tooltip: context.l10n.workspaceShellCollapseMenu,
            onPressed: controller.collapse,
            icon: const Icon(Symbols.first_page_rounded),
          ),
        ],
      ),
      Gaps.h8,
      _StaticMenuItem(
        label: context.l10n.workspaceShellDashboard,
        icon: Symbols.dashboard,
        selected: section == WorkspaceShellSection.dashboard,
        onTap: () => onSectionSelected(WorkspaceShellSection.dashboard),
      ),
      Gaps.h8,
      Text(
        context.l10n.workspaceShellProjects,
        style: context.text.labelSmall?.copyWith(
          color: colors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
      Gaps.h4,
      _StaticMenuItem(
        label: context.l10n.workspaceShellProjects,
        icon: Symbols.folder,
        selected: section == WorkspaceShellSection.projects,
        onTap: () => onSectionSelected(WorkspaceShellSection.projects),
      ),
      Gaps.h4,
      _StaticMenuItem(
        label: context.l10n.workspacesSectionFiles,
        icon: Symbols.folder_copy_rounded,
        onTap: onFiles,
      ),
    ],
  );
}

class _CollapsedMenu extends StatelessWidget {
  const _CollapsedMenu({
    required this.controller,
    required this.onBack,
    required this.onFiles,
  });

  final AppCollapsibleNavigationController controller;
  final VoidCallback onBack;
  final VoidCallback onFiles;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      IconButton(
        tooltip: context.l10n.workspaceShellBackToDirectory,
        onPressed: onBack,
        icon: const Icon(Symbols.arrow_back_rounded),
      ),
      IconButton(
        tooltip: context.l10n.workspaceShellExpandMenu,
        onPressed: controller.expand,
        icon: const Icon(Symbols.last_page_rounded),
      ),
      IconButton(
        tooltip: context.l10n.workspacesSectionFiles,
        onPressed: onFiles,
        icon: const Icon(Symbols.folder_copy_rounded),
      ),
      const Spacer(),
      Tooltip(
        message: context.l10n.workspaceShellDashboard,
        child: const Icon(Symbols.dashboard),
      ),
      Gaps.h12,
    ],
  );
}

class _StaticMenuItem extends StatelessWidget {
  const _StaticMenuItem({
    required this.label,
    required this.icon,
    this.selected = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final foreground = selected ? colors.primary : colors.onSurface;
    return Semantics(
      button: onTap != null,
      enabled: onTap != null,
      selected: selected,
      child: Material(
        color: selected
            ? colors.primary.withValues(alpha: .10)
            : Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.p8,
              vertical: Sizes.p8,
            ),
            child: Row(
              children: [
                Icon(icon, size: 18, color: foreground),
                Gaps.w8,
                Expanded(
                  child: Text(
                    label,
                    style: context.text.bodySmall?.copyWith(color: foreground),
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
