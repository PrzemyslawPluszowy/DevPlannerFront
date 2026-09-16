import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/settings/application/local_settings_cubit.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_lauout/app_module_layout.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_lauout/app_module_top_bar.dart';
import 'package:ready_next/shared/presentation/widgets/app_navigation_preference_key.dart';
import 'package:ready_next/workspaces/presentation/workspace_shell/content/workspace_shell_content.dart';
import 'package:ready_next/workspaces/presentation/workspace_shell/navigation/cubit/workspace_shell_navigation_cubit.dart';
import 'package:ready_next/workspaces/presentation/workspace_shell/navigation/workspace_static_menu.dart';

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
    final preferenceKey = appNavigationPreferenceKey(
      context,
      'workspaces.shell',
    );

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
          onBack: () => unawaited(context.router.navigatePath('/workspaces')),
          onFiles: () => unawaited(
            context.router.navigatePath('/workspaces/$workspaceId/files'),
          ),
        ),
      ),
      contentBuilder: (context, _, _) => const WorkspaceShellContent(),
    );
  }
}
