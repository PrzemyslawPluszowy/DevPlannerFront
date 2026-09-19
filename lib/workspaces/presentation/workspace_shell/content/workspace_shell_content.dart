import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/workspace_shell/dashboard/workspace_dashboard_skeleton.dart';
import 'package:devplanner/workspaces/presentation/workspace_shell/navigation/cubit/workspace_shell_navigation_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Centralna treść z animacją ograniczoną do obszaru workspace’u.
class WorkspaceShellContent extends StatelessWidget {
  const WorkspaceShellContent({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocSelector<
        WorkspaceShellNavigationCubit,
        WorkspaceShellNavigationState,
        WorkspaceShellSection
      >(
        selector: (state) => state.section,
        builder: (context, section) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: child,
          ),
          child: switch (section) {
            WorkspaceShellSection.dashboard => const WorkspaceDashboardSkeleton(
              key: ValueKey('workspace-dashboard'),
            ),
            WorkspaceShellSection.projects => const _ProjectsSkeleton(
              key: ValueKey('workspace-projects'),
            ),
          },
        ),
      );
}

class _ProjectsSkeleton extends StatelessWidget {
  const _ProjectsSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Sizes.p24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.workspaceShellProjects,
          style: context.text.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Gaps.h8,
        Text(
          context.l10n.workspaceShellProjectsPlaceholder,
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}
