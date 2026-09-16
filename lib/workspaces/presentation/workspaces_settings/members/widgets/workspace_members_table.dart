import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/workspace_role.dart';
import 'package:ready_next/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:ready_next/workspaces/presentation/workspaces_settings/members/widgets/workspace_role_badge_selector.dart';

/// Tabela listy członków przestrzeni roboczej z możliwością zarządzania rolami i usuwania osób.
class WorkspaceMembersTable extends StatelessWidget {
  const WorkspaceMembersTable({
    required this.members,
    required this.isOwnerOrAdmin,
    required this.onRoleChanged,
    required this.onRemoveMember,
    super.key,
  });

  /// Lista członków workspace.
  final List<WorkspaceMemberResponse> members;

  /// Czy użytkownik posiada uprawnienia do edycji (Owner / Admin).
  final bool isOwnerOrAdmin;

  /// Callback zmiany roli członka.
  final void Function(String memberId, WorkspaceRole newRole) onRoleChanged;

  /// Callback usunięcia członka.
  final void Function(String memberId) onRemoveMember;

  String _formatMemberDisplayName(WorkspaceMemberResponse member) {
    if (member.readyUserId != null) {
      return 'Użytkownik Ready #${member.readyUserId}';
    }
    return 'Użytkownik Core (${member.coreUserId.substring(0, 8)}...)';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (members.isEmpty) {
      return Center(
        child: Padding(
          padding: const .all(Sizes.p32),
          child: Text(
            'Brak członków w tej przestrzeni roboczej.',
            style: context.text.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
            ),
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
        final isOwner = member.role == WorkspaceRole.owner;
        final displayName = _formatMemberDisplayName(member);

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
              WorkspaceRoleBadgeSelector(
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
                  tooltip: 'Usuń z przestrzeni',
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
    WorkspaceMemberResponse member,
    String displayName,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Usuń członka'),
        content: Text(
          l10n.workspaceSettingsRemoveMemberConfirm,
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
