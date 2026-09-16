import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/auth/auth_cubit.dart';
import 'package:ready_next/core/auth/auth_state.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/projects/responses/project_member_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/presentation/projects/settings/members/widgets/project_role_badge_selector.dart';

/// Tabela listy członków projektu z możliwością zmiany ról oraz usuwania osób.
class ProjectMembersTable extends StatelessWidget {
  const ProjectMembersTable({
    required this.members,
    required this.isOwnerOrAdmin,
    required this.onRoleChanged,
    required this.onRemoveMember,
    super.key,
  });

  /// Lista członków projektu.
  final List<ProjectMemberResponse> members;

  /// Czy użytkownik posiada uprawnienia do edycji.
  final bool isOwnerOrAdmin;

  /// Callback zmiany roli członka.
  final void Function(String memberId, ProjectRole newRole) onRoleChanged;

  /// Callback usunięcia członka.
  final void Function(String memberId) onRemoveMember;

  String _formatMemberDisplayName(
    BuildContext context,
    ProjectMemberResponse member,
  ) {
    final authUser = switch (context.watch<AuthCubit?>()?.state) {
      AuthAuthenticated(:final user) => user,
      _ => null,
    };
    if (authUser != null && authUser.coreUserId == member.coreUserId) {
      if (authUser.displayName.isNotEmpty) {
        return '${authUser.displayName} (Ja)';
      }
    }
    if (member.readyUserId != null) {
      return 'Użytkownik #${member.readyUserId}';
    }
    return 'Użytkownik (${member.coreUserId.substring(0, 8)}...)';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    if (members.isEmpty) {
      return Center(
        child: Padding(
          padding: const .all(Sizes.p32),
          child: Column(
            mainAxisSize: .min,
            children: [
              Icon(
                Icons.people_outline_rounded,
                size: Sizes.p40,
                color: colors.outline,
              ),
              Gaps.h8,
              Text(
                l10n.projectSettingsNoMembersFound,
                style: context.text.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: members.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: colors.outlineVariant.withValues(alpha: .5),
      ),
      itemBuilder: (context, index) {
        final member = members[index];
        final isOwner = member.role == ProjectRole.owner;
        final displayName = _formatMemberDisplayName(context, member);

        return Padding(
          padding: const .symmetric(
            horizontal: Sizes.p16,
            vertical: Sizes.p12,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: colors.primaryContainer,
                child: Icon(
                  Icons.person_rounded,
                  size: Sizes.p18,
                  color: colors.onPrimaryContainer,
                ),
              ),
              Gaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      displayName,
                      style: context.text.bodyMedium?.copyWith(
                        fontWeight: .w600,
                        color: colors.onSurface,
                      ),
                    ),
                    Gaps.h2,
                    Text(
                      member.readyUserId != null
                          ? 'Ready ID: ${member.readyUserId}'
                          : 'Core ID: ${member.coreUserId}',
                      style: context.text.labelSmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.w16,
              ProjectRoleBadgeSelector(
                currentRole: member.role,
                enabled: isOwnerOrAdmin && !isOwner,
                onRoleChanged: (role) => onRoleChanged(member.id, role),
              ),
              if (isOwnerOrAdmin && !isOwner) ...[
                Gaps.w8,
                IconButton(
                  icon: Icon(
                    Icons.person_remove_outlined,
                    size: Sizes.p18,
                    color: colors.error,
                  ),
                  tooltip: 'Usuń z projektu',
                  onPressed: () => _confirmRemove(context, member, displayName),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmRemove(
    BuildContext context,
    ProjectMemberResponse member,
    String displayName,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Usuń członka'),
        content: Text(
          'Czy na pewno chcesz usunąć użytkownika $displayName z tego projektu?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.tasksListCancelButton),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: ctx.colors.error,
              foregroundColor: ctx.colors.onError,
            ),
            child: const Text('Usuń'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onRemoveMember(member.id);
    }
  }
}
