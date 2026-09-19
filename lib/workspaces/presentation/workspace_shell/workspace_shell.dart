import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/features/settings/application/local_settings_cubit.dart';
import 'package:devplanner/shared/presentation/widgets/app_module_lauout/app_module_layout.dart';
import 'package:devplanner/shared/presentation/widgets/app_module_lauout/app_module_top_bar.dart';
import 'package:devplanner/workspaces/presentation/workspace_shell/content/workspace_shell_content.dart';
import 'package:devplanner/workspaces/presentation/workspace_shell/navigation/cubit/workspace_shell_navigation_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspace_shell/navigation/workspace_static_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Statelessowy webowy shell aktywnego workspace’u.
class WorkspaceShell extends StatelessWidget {
  const WorkspaceShell({
    required this.workspaceId,
    required this.settings,
    super.key,
  });

  final String workspaceId;
  final LocalSettingsCubit settings;

  @override
  Widget build(BuildContext context) {
    final preferenceKey = _preferenceKey(context);

    return BlocProvider(
      create: (_) => WorkspaceShellNavigationCubit(
        initiallyExpanded: settings.isNavigationPanelExpanded(preferenceKey),
        onPanelChanged: (expanded) => settings.setNavigationPanelExpanded(
          preferenceKey: preferenceKey,
          expanded: expanded,
        ),
      ),
      child: _WorkspaceShellLayout(workspaceId: workspaceId),
    );
  }

  String _preferenceKey(BuildContext context) {
    final userId = context.read<AuthSessionPort?>()?.snapshot.user?.userId;
    return 'workspaces.shell:${userId ?? 'anonymous'}';
  }
}

class _WorkspaceShellLayout extends StatelessWidget {
  const _WorkspaceShellLayout({required this.workspaceId});

  final String workspaceId;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navigationController = context
        .read<WorkspaceShellNavigationCubit>()
        .panelController;
    return AppModuleLayout(
      navigationController: navigationController,
      navigationExpandedWidth: 260,
      topBar: AppModuleTopBar(
        title: context.l10n.workspaceShellTitle,
        subtitle: context.l10n.workspaceShellSubtitle,
        height: 44,
        horizontalPadding: Sizes.p20,
        showBottomBorder: true,
        backgroundColor: Colors.transparent,
      ),
      showSidebarDivider: false,
      scrollContent: false,
      contentLeadingInset: Sizes.p16,
      contentMaxWidth: 1800,
      contentBackgroundColor: isDark
          ? const Color(0xFF171824).withValues(alpha: .86)
          : Colors.white.withValues(alpha: .82),
      sidebarBuilder: (context, _, outerPadding) => RepaintBoundary(
        child: WorkspaceStaticMenu(
          outerPadding: outerPadding,
          onBack: () => unawaited(context.plannerNavigation.go('/workspaces')),
          onFiles: () => unawaited(
            context.plannerNavigation.go('/workspaces/$workspaceId/files'),
          ),
        ),
      ),
      contentBuilder: (context, _, _) => const WorkspaceShellContent(),
    );
  }
}
