import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_lauout/app_module_layout.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_lauout/app_module_top_bar.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_lauout/app_side_menu_panel.dart';

/// Sekcje nawigacyjne modułu BHP.
enum BhpSection {
  /// Dashboard alertów terminów.
  dashboard(icon: Icons.space_dashboard_outlined, path: AppRoutePaths.bhp),

  /// Globalna historia operacji BHP.
  operations(icon: Icons.manage_history_outlined, path: '/bhp/operations'),

  /// Statystyki operacji BHP.
  statistics(icon: Icons.insights_outlined, path: '/bhp/statistics'),

  /// Lista pracowników BHP.
  users(icon: Icons.badge_outlined, path: AppRoutePaths.bhpUsers),

  /// Słownik stanowisk BHP.
  positions(icon: Icons.work_outline_rounded, path: AppRoutePaths.bhpPositions),

  /// Katalog wyposażenia BHP.
  equipment(icon: Icons.inventory_2_outlined, path: AppRoutePaths.bhpEquipment);

  const BhpSection({required this.icon, required this.path});

  /// Ikona sekcji.
  final IconData icon;

  /// Ścieżka URL sekcji.
  final String path;
}

/// Strona główna modułu BHP.
class BhpHomePage extends StatelessWidget {
  /// Tworzy stronę główną modułu BHP.
  const BhpHomePage({required this.child, super.key});

  /// Treść aktualnie wybranej podtrasy.
  final Widget child;

  BhpSection _sectionForPath(String path) {
    if (path.startsWith(AppRoutePaths.bhpUsers)) return BhpSection.users;
    if (path.startsWith(AppRoutePaths.bhpPositions)) return BhpSection.positions;
    if (path.startsWith(AppRoutePaths.bhpEquipment)) return BhpSection.equipment;
    if (path.startsWith('/bhp/operations')) return BhpSection.operations;
    if (path.startsWith('/bhp/statistics')) return BhpSection.statistics;
    return BhpSection.dashboard;
  }

  String _sectionLabel(BuildContext context, BhpSection section) {
    final intl = context.l10n;
    return switch (section) {
      BhpSection.dashboard => intl.bhpSectionDashboard,
      BhpSection.operations => intl.bhpSectionOperations,
      BhpSection.users => intl.bhpSectionUsers,
      BhpSection.positions => intl.bhpSectionPositions,
      BhpSection.equipment => intl.bhpSectionEquipment,
      BhpSection.statistics => intl.bhpSectionStatistics,
    };
  }

  List<AppSideMenuSection> _buildMenuSections(
    BuildContext context,
    BhpSection activeSection,
  ) {
    final intl = context.l10n;
    final specs = <AppSideMenuSectionSpec>[
      AppSideMenuSectionSpec.simple(
        title: intl.bhpModuleTitle,
        items: [
          AppSideMenuEntrySpec.route(
            label: intl.bhpSectionDashboard,
            icon: BhpSection.dashboard.icon,
            isSelected: activeSection == BhpSection.dashboard,
            onTap: (_) => context.go(BhpSection.dashboard.path),
          ),
          AppSideMenuEntrySpec.route(
            label: intl.bhpSectionUsers,
            icon: BhpSection.users.icon,
            isSelected: activeSection == BhpSection.users,
            onTap: (_) => context.go(BhpSection.users.path),
          ),
          AppSideMenuEntrySpec.route(
            label: intl.bhpSectionPositions,
            icon: BhpSection.positions.icon,
            isSelected: activeSection == BhpSection.positions,
            onTap: (_) => context.go(BhpSection.positions.path),
          ),
          AppSideMenuEntrySpec.route(
            label: intl.bhpSectionEquipment,
            icon: BhpSection.equipment.icon,
            isSelected: activeSection == BhpSection.equipment,
            onTap: (_) => context.go(BhpSection.equipment.path),
          ),
          AppSideMenuEntrySpec.route(
            label: intl.bhpSectionOperations,
            icon: BhpSection.operations.icon,
            isSelected: activeSection == BhpSection.operations,
            onTap: (_) => context.go(BhpSection.operations.path),
          ),
          AppSideMenuEntrySpec.route(
            label: intl.bhpSectionStatistics,
            icon: BhpSection.statistics.icon,
            isSelected: activeSection == BhpSection.statistics,
            onTap: (_) => context.go(BhpSection.statistics.path),
          ),
        ],
      ),
    ];

    return buildSideMenuSectionsFromSpecs(context, specs, null);
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    final activeSection = _sectionForPath(currentPath);

    return Scaffold(
      body: AppModuleLayout(
        topBar: AppModuleTopBar(
          title: context.l10n.bhpModuleTitle,
          subtitle: _sectionLabel(context, activeSection),
          height: 40,
          horizontalPadding: 22,
          showBottomBorder: true,
          backgroundColor: Colors.transparent,
        ),
        showSidebarDivider: false,
        scrollContent: false,
        compactOuterPadding: Sizes.p16,
        regularOuterPadding: Sizes.p20,
        contentLeadingInset: Sizes.p20,
        contentMaxWidth: 1800,
        sidebarBuilder: (context, isCompact, outerPadding) {
          return AppSideMenuPanel(
            primaryIcon: activeSection.icon,
            title: context.l10n.bhpModuleTitle,
            subtitle: context.l10n.bhpSidebarSubtitle,
            width: isCompact ? 168 : 240,
            margin: .zero,
            flat: true,
            showBorder: false,
            menuSections: _buildMenuSections(context, activeSection),
          );
        },
        contentBuilder: (context, isCompact, outerPadding) => child,
      ),
    );
  }
}
