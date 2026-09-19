import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_invitation_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/invitations/cubit/workspace_invitations_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/invitations/widgets/create_workspace_invitation_dialog.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/members/cubit/workspace_members_settings_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/members/widgets/workspace_members_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widok zakładki "Członkowie i zaproszenia" w ustawieniach przestrzeni roboczej.
class WorkspaceMembersTabView extends StatelessWidget {
  const WorkspaceMembersTabView({
    required this.userRole,
    super.key,
  });

  /// Rola bieżącego użytkownika w przestrzeni roboczej.
  final WorkspaceRole? userRole;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isOwnerOrAdmin =
        userRole == WorkspaceRole.owner || userRole == WorkspaceRole.admin;

    return SingleChildScrollView(
      padding: const .all(Sizes.p24),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          // 1. Sekcja Aktywnych Członków
          BlocBuilder<
            WorkspaceMembersSettingsCubit,
            WorkspaceMembersSettingsState
          >(
            builder: (context, state) {
              return switch (state) {
                WorkspaceMembersSettingsLoading() => const Center(
                  child: Padding(
                    padding: .all(Sizes.p24),
                    child: CircularProgressIndicator(),
                  ),
                ),
                WorkspaceMembersSettingsError(:final error) => Center(
                  child: Padding(
                    padding: const .all(Sizes.p16),
                    child: Text(
                      error.message,
                      style: context.text.bodyMedium?.copyWith(
                        color: colors.error,
                      ),
                    ),
                  ),
                ),
                WorkspaceMembersSettingsLoaded(
                  :final members,
                  :final isMutating,
                  :final error,
                ) =>
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      if (error != null) ...[
                        Container(
                          padding: const .all(Sizes.p12),
                          decoration: BoxDecoration(
                            color: colors.errorContainer.withValues(alpha: .2),
                            borderRadius: .circular(Sizes.p8),
                            border: Border.all(color: colors.error),
                          ),
                          child: Text(
                            error.message,
                            style: context.text.bodySmall?.copyWith(
                              color: colors.error,
                            ),
                          ),
                        ),
                        Gaps.h16,
                      ],
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                l10n.workspaceSettingsMembersHeader,
                                style: context.text.titleMedium?.copyWith(
                                  fontWeight: .w700,
                                  color: colors.onSurface,
                                ),
                              ),
                              Gaps.h4,
                              Text(
                                'Liczba członków: ${members.length}',
                                style: context.text.bodySmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          if (isOwnerOrAdmin)
                            FilledButton.icon(
                              onPressed: isMutating
                                  ? null
                                  : () => _openInviteDialog(context),
                              icon: const Icon(
                                Icons.person_add_rounded,
                                size: Sizes.p18,
                              ),
                              label: Text(
                                l10n.workspaceSettingsInviteUserButton,
                              ),
                              style: FilledButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(Sizes.p8),
                                ),
                              ),
                            ),
                        ],
                      ),
                      Gaps.h16,
                      Container(
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLowest,
                          borderRadius: .circular(Sizes.p12),
                          border: Border.all(color: colors.outlineVariant),
                        ),
                        child: WorkspaceMembersTable(
                          members: members,
                          isOwnerOrAdmin: isOwnerOrAdmin,
                          onRoleChanged: (memberId, role) => context
                              .read<WorkspaceMembersSettingsCubit>()
                              .changeRole(memberId: memberId, role: role),
                          onRemoveMember: (memberId) => context
                              .read<WorkspaceMembersSettingsCubit>()
                              .removeMember(memberId: memberId),
                        ),
                      ),
                    ],
                  ),
              };
            },
          ),
          Gaps.h32,
          // 2. Sekcja Oczekujących Zaproszeń
          BlocBuilder<
            WorkspaceInvitationsSettingsCubit,
            WorkspaceInvitationsSettingsState
          >(
            builder: (context, state) {
              return switch (state) {
                WorkspaceInvitationsSettingsLoading() =>
                  const SizedBox.shrink(),
                WorkspaceInvitationsSettingsError() => const SizedBox.shrink(),
                WorkspaceInvitationsSettingsLoaded(
                  :final invitations,
                  :final isMutating,
                ) =>
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        l10n.workspaceSettingsInvitationsSentHeader,
                        style: context.text.titleMedium?.copyWith(
                          fontWeight: .w700,
                          color: colors.onSurface,
                        ),
                      ),
                      Gaps.h4,
                      Text(
                        'Oczekujące: ${invitations.where((i) => i.status == WorkspaceInvitationStatus.pending).length}',
                        style: context.text.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      Gaps.h16,
                      if (invitations.isEmpty)
                        Padding(
                          padding: const .symmetric(vertical: Sizes.p16),
                          child: Text(
                            'Brak oczekujących zaproszeń.',
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerLowest,
                            borderRadius: .circular(Sizes.p12),
                            border: Border.all(color: colors.outlineVariant),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: invitations.length,
                            separatorBuilder: (_, _) => Divider(
                              height: 1,
                              color: colors.outlineVariant.withValues(
                                alpha: .5,
                              ),
                            ),
                            itemBuilder: (ctx, index) {
                              final invitation = invitations[index];
                              final isPending =
                                  invitation.status ==
                                  WorkspaceInvitationStatus.pending;

                              return Padding(
                                padding: const .symmetric(
                                  horizontal: Sizes.p16,
                                  vertical: Sizes.p12,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor:
                                          colors.surfaceContainerHigh,
                                      child: Text(
                                        invitation.displayName.isNotEmpty
                                            ? invitation.displayName[0]
                                                  .toUpperCase()
                                            : '?',
                                        style: context.text.labelSmall
                                            ?.copyWith(
                                              fontWeight: .w700,
                                            ),
                                      ),
                                    ),
                                    Gaps.w12,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            invitation.displayName,
                                            style: context.text.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: .w600,
                                                  color: colors.onSurface,
                                                ),
                                          ),
                                          Gaps.h2,
                                          Text(
                                            'Login: ${invitation.login} | Rola: ${invitation.role.name} | Status: ${invitation.status.name}',
                                            style: context.text.labelSmall
                                                ?.copyWith(
                                                  color:
                                                      colors.onSurfaceVariant,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isOwnerOrAdmin && isPending) ...[
                                      TextButton(
                                        onPressed: isMutating
                                            ? null
                                            : () => context
                                                  .read<
                                                    WorkspaceInvitationsSettingsCubit
                                                  >()
                                                  .resendInvitation(
                                                    invitation.id,
                                                  ),
                                        child: Text(
                                          l10n.workspaceSettingsInvitationResend,
                                        ),
                                      ),
                                      Gaps.w8,
                                      IconButton(
                                        icon: Icon(
                                          Icons.close_rounded,
                                          size: Sizes.p18,
                                          color: colors.error,
                                        ),
                                        tooltip: l10n
                                            .workspaceSettingsInvitationCancel,
                                        onPressed: isMutating
                                            ? null
                                            : () => context
                                                  .read<
                                                    WorkspaceInvitationsSettingsCubit
                                                  >()
                                                  .cancelInvitation(
                                                    invitation.id,
                                                  ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
              };
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openInviteDialog(BuildContext context) async {
    final cubit = context.read<WorkspaceInvitationsSettingsCubit>();
    final result = await showDialog<({String userId, WorkspaceRole role})>(
      context: context,
      builder: (_) => CreateWorkspaceInvitationDialog(
        onSearch: cubit.searchLocalUsers,
      ),
    );

    if (result != null) {
      await cubit.inviteUser(
        userId: result.userId,
        role: result.role,
      );
    }
  }
}
