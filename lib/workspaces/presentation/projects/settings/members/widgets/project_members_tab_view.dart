import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/members/cubit/project_members_settings_cubit.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/members/widgets/add_project_member_dialog.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/members/widgets/project_members_table.dart';

/// Widok zakładki "Członkowie i dostęp" w ustawieniach projektu.
class ProjectMembersTabView extends StatelessWidget {
  const ProjectMembersTabView({
    required this.userRole,
    super.key,
  });

  /// Rola bieżącego użytkownika w projekcie.
  final ProjectRole? userRole;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isOwnerOrAdmin =
        userRole == ProjectRole.owner || userRole == ProjectRole.admin;

    return BlocBuilder<
      ProjectMembersSettingsCubit,
      ProjectMembersSettingsState
    >(
      builder: (context, state) {
        return switch (state) {
          ProjectMembersSettingsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          ProjectMembersSettingsError(:final error) => Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  size: Sizes.p40,
                  color: colors.error,
                ),
                Gaps.h12,
                Text(
                  error.message,
                  style: context.text.bodyMedium?.copyWith(
                    color: colors.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.h16,
                OutlinedButton(
                  onPressed: () =>
                      context.read<ProjectMembersSettingsCubit>().load(),
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          ),
          ProjectMembersSettingsLoaded(
            :final members,
            :final unassignedWorkspaceMembers,
            :final isMutating,
            :final error,
          ) =>
            SingleChildScrollView(
              padding: const .all(Sizes.p24),
              child: Column(
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
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: colors.error,
                            size: Sizes.p20,
                          ),
                          Gaps.w8,
                          Expanded(
                            child: Text(
                              error.message,
                              style: context.text.bodySmall?.copyWith(
                                color: colors.error,
                              ),
                            ),
                          ),
                        ],
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
                            l10n.projectSettingsTabMembers,
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
                      Tooltip(
                        message: !isOwnerOrAdmin
                            ? 'Brak uprawnień do zarządzania członkami projektu (wymagana rola Właściciel lub Administrator).'
                            : unassignedWorkspaceMembers.isEmpty
                            ? 'Wszyscy członkowie tej przestrzeni roboczej są już w projekcie. Aby dodać nowe osoby, zaproś je najpierw do przestrzeni roboczej.'
                            : 'Dodaj członka przestrzeni roboczej do tego projektu',
                        child: FilledButton.icon(
                          onPressed: !isOwnerOrAdmin || isMutating
                              ? null
                              : unassignedWorkspaceMembers.isEmpty
                              ? () => _showNoAvailableMembersDialog(context)
                              : () => _openAddMember(
                                  context,
                                  unassignedWorkspaceMembers,
                                ),
                          icon: const Icon(
                            Icons.person_add_rounded,
                            size: Sizes.p18,
                          ),
                          label: Text(l10n.projectSettingsAddMemberButton),
                          style: FilledButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(Sizes.p8),
                            ),
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
                    child: ProjectMembersTable(
                      members: members,
                      isOwnerOrAdmin: isOwnerOrAdmin,
                      onRoleChanged: (memberId, role) => context
                          .read<ProjectMembersSettingsCubit>()
                          .changeRole(memberId: memberId, role: role),
                      onRemoveMember: (memberId) => context
                          .read<ProjectMembersSettingsCubit>()
                          .removeMember(memberId: memberId),
                    ),
                  ),
                ],
              ),
            ),
        };
      },
    );
  }

  Future<void> _openAddMember(
    BuildContext context,
    List<WorkspaceMemberResponse> unassignedMembers,
  ) async {
    final cubit = context.read<ProjectMembersSettingsCubit>();
    final result =
        await showDialog<({String workspaceMemberId, ProjectRole role})>(
          context: context,
          builder: (ctx) => AddProjectMemberDialog(
            availableMembers: unassignedMembers,
          ),
        );

    if (result != null) {
      await cubit.addMember(
        workspaceMemberId: result.workspaceMemberId,
        role: result.role,
      );
    }
  }

  Future<void> _showNoAvailableMembersDialog(BuildContext context) =>
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: Icon(
            Icons.info_outline_rounded,
            size: Sizes.p32,
            color: context.colors.primary,
          ),
          title: const Text('Brak dostępnych użytkowników w workspace'),
          content: const Text(
            'Wszyscy aktywni członkowie bieżącego workspace zostali już przypisani do tego projektu.\n\nAby dodać nową osobę, przejdź do Ustawień Przestrzeni Roboczej i wyślij jej zaproszenie.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Rozumiem'),
            ),
          ],
        ),
      );
}
