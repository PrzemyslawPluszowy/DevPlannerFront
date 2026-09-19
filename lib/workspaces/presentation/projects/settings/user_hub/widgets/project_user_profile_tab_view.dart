import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/user_hub/cubit/project_user_hub_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Zakładka profilu użytkownika w projekcie z informacją o roli i opcją opuszczenia projektu.
class ProjectUserProfileTabView extends StatelessWidget {
  const ProjectUserProfileTabView({
    required this.project,
    required this.userRole,
    super.key,
  });

  final ProjectListItem project;
  final ProjectRole? userRole;

  String _roleTitle(BuildContext context, ProjectRole? role) => switch (role) {
    ProjectRole.owner => context.l10n.projectSettingsMemberRoleOwner,
    ProjectRole.admin => context.l10n.projectSettingsMemberRoleAdmin,
    ProjectRole.member => context.l10n.projectSettingsMemberRoleMember,
    ProjectRole.observer => context.l10n.projectSettingsMemberRoleObserver,
    null => context.l10n.projectSettingsMemberRoleMember,
  };

  String _roleDescription(BuildContext context, ProjectRole? role) =>
      switch (role) {
        ProjectRole.owner => context.l10n.projectUserHubRoleOwnerDesc,
        ProjectRole.admin => context.l10n.projectUserHubRoleAdminDesc,
        ProjectRole.member => context.l10n.projectUserHubRoleMemberDesc,
        ProjectRole.observer => context.l10n.projectUserHubRoleObserverDesc,
        null => context.l10n.projectUserHubProfileDesc,
      };

  IconData _roleIcon(ProjectRole? role) => switch (role) {
    ProjectRole.owner => Icons.shield_rounded,
    ProjectRole.admin => Icons.admin_panel_settings_rounded,
    ProjectRole.member => Icons.person_rounded,
    ProjectRole.observer => Icons.visibility_rounded,
    null => Icons.person_outline_rounded,
  };

  Color _roleColor(BuildContext context, ProjectRole? role) => switch (role) {
    ProjectRole.owner => context.colors.primary,
    ProjectRole.admin => const Color(0xFF8B5CF6),
    ProjectRole.member => const Color(0xFF0284C7),
    ProjectRole.observer => const Color(0xFF64748B),
    null => context.colors.onSurfaceVariant,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final role = userRole ?? project.myRole;
    final roleColor = _roleColor(context, role);
    final isShared = project.visibility == ProjectVisibility.shared;

    final authUser = context.watch<AuthSessionPort?>()?.snapshot.user;

    return BlocBuilder<ProjectUserHubCubit, ProjectUserHubState>(
      builder: (context, state) {
        final isLeaving = state is ProjectUserHubReady && state.isLeaving;

        return SingleChildScrollView(
          padding: const .all(Sizes.p24),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                l10n.projectUserHubProfileHeader,
                style: context.text.titleMedium?.copyWith(
                  fontWeight: .w700,
                  color: colors.onSurface,
                ),
              ),
              Gaps.h4,
              Text(
                l10n.projectUserHubProfileDesc,
                style: context.text.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              Gaps.h20,

              // Karta tożsamości użytkownika
              if (authUser != null) ...[
                Container(
                  padding: const .all(Sizes.p16),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerLowest,
                    borderRadius: .circular(Sizes.p12),
                    border: Border.all(color: colors.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: Sizes.p24,
                        backgroundColor: colors.primaryContainer,
                        child: Text(
                          authUser.displayName.isNotEmpty
                              ? authUser.displayName
                                    .substring(0, 1)
                                    .toUpperCase()
                              : 'U',
                          style: context.text.titleMedium?.copyWith(
                            fontWeight: .w700,
                            color: colors.onPrimaryContainer,
                          ),
                        ),
                      ),
                      Gaps.w16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              authUser.displayName.isNotEmpty
                                  ? authUser.displayName
                                  : authUser.login,
                              style: context.text.bodyLarge?.copyWith(
                                fontWeight: .w700,
                                color: colors.onSurface,
                              ),
                            ),
                            if (authUser.login.isNotEmpty) ...[
                              Gaps.h2,
                              Text(
                                authUser.login,
                                style: context.text.bodySmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.h16,
              ],

              // Karta Roli
              Container(
                padding: const .all(Sizes.p20),
                decoration: BoxDecoration(
                  color: colors.surfaceContainerLowest,
                  borderRadius: .circular(Sizes.p12),
                  border: Border.all(color: colors.outlineVariant),
                ),
                child: Row(
                  crossAxisAlignment: .start,
                  children: [
                    Container(
                      padding: const .all(Sizes.p12),
                      decoration: BoxDecoration(
                        color: roleColor.withValues(alpha: .15),
                        borderRadius: .circular(Sizes.p12),
                      ),
                      child: Icon(
                        _roleIcon(role),
                        color: roleColor,
                        size: Sizes.p28,
                      ),
                    ),
                    Gaps.w16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _roleTitle(context, role),
                                style: context.text.bodyLarge?.copyWith(
                                  fontWeight: .w700,
                                  color: colors.onSurface,
                                ),
                              ),
                              Gaps.w8,
                              Container(
                                padding: const .symmetric(
                                  horizontal: Sizes.p8,
                                  vertical: Sizes.p2,
                                ),
                                decoration: BoxDecoration(
                                  color: roleColor.withValues(alpha: .2),
                                  borderRadius: .circular(Sizes.p6),
                                ),
                                child: Text(
                                  role?.name.toUpperCase() ?? 'MEMBER',
                                  style: context.text.labelSmall?.copyWith(
                                    fontWeight: .w800,
                                    color: roleColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Gaps.h6,
                          Text(
                            _roleDescription(context, role),
                            style: context.text.bodyMedium?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Gaps.h24,

              // Sekcja opuszczenia projektu
              if (role != ProjectRole.owner) ...[
                Text(
                  l10n.projectUserHubLeaveProjectTitle,
                  style: context.text.titleSmall?.copyWith(
                    fontWeight: .w700,
                    color: colors.onSurface,
                  ),
                ),
                Gaps.h8,
                Container(
                  padding: const .all(Sizes.p16),
                  decoration: BoxDecoration(
                    color: colors.errorContainer.withValues(alpha: .15),
                    borderRadius: .circular(Sizes.p12),
                    border: Border.all(
                      color: colors.error.withValues(alpha: .4),
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 500;
                      final button = OutlinedButton(
                        onPressed: isLeaving
                            ? null
                            : () => _confirmLeave(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.error,
                          side: BorderSide(color: colors.error),
                        ),
                        child: isLeaving
                            ? const SizedBox(
                                width: Sizes.p16,
                                height: Sizes.p16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.projectUserHubLeaveProjectButton),
                      );

                      if (isNarrow) {
                        return Column(
                          crossAxisAlignment: .start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.logout_rounded,
                                  color: colors.error,
                                  size: Sizes.p24,
                                ),
                                Gaps.w12,
                                Expanded(
                                  child: Text(
                                    l10n.projectUserHubLeaveProjectButton,
                                    style: context.text.bodyMedium?.copyWith(
                                      fontWeight: .w700,
                                      color: colors.onSurface,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Gaps.h8,
                            Text(
                              isShared
                                  ? l10n.projectUserHubLeaveProjectSharedDesc
                                  : l10n.projectUserHubLeaveProjectPrivateDesc,
                              style: context.text.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            Gaps.h12,
                            button,
                          ],
                        );
                      }

                      return Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: colors.error,
                            size: Sizes.p24,
                          ),
                          Gaps.w16,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  l10n.projectUserHubLeaveProjectButton,
                                  style: context.text.bodyMedium?.copyWith(
                                    fontWeight: .w700,
                                    color: colors.onSurface,
                                  ),
                                ),
                                Gaps.h2,
                                Text(
                                  isShared
                                      ? l10n.projectUserHubLeaveProjectSharedDesc
                                      : l10n.projectUserHubLeaveProjectPrivateDesc,
                                  style: context.text.bodySmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Gaps.w16,
                          button,
                        ],
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmLeave(BuildContext context) async {
    final cubit = context.read<ProjectUserHubCubit>();
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.projectUserHubLeaveConfirmTitle),
        content: Text(l10n.projectUserHubLeaveConfirmContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.workspacesCancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: ctx.colors.error,
              foregroundColor: ctx.colors.onError,
            ),
            child: Text(l10n.projectUserHubLeaveConfirmAction),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await cubit.leaveProject();
    }
  }
}
