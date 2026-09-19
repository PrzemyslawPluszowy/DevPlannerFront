import 'package:devplanner/core/l10n/l10n_extensions.dart';
import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:flutter/material.dart';

/// Przełącznik roli członka przestrzeni roboczej w formie kompaktowego badge'a.
class WorkspaceRoleBadgeSelector extends StatelessWidget {
  const WorkspaceRoleBadgeSelector({
    required this.currentRole,
    required this.onRoleChanged,
    this.enabled = true,
    super.key,
  });

  /// Aktualna rola członka.
  final WorkspaceRole currentRole;

  /// Callback po wybraniu nowej roli.
  final ValueChanged<WorkspaceRole> onRoleChanged;

  /// Czy użytkownik może modyfikować rolę.
  final bool enabled;

  Color _roleColor(BuildContext context, WorkspaceRole role) {
    final colors = context.colors;
    return switch (role) {
      WorkspaceRole.owner => colors.primary,
      WorkspaceRole.admin => colors.secondary,
      WorkspaceRole.member => colors.tertiary,
      WorkspaceRole.observer => colors.outline,
    };
  }

  String _roleLabel(BuildContext context, WorkspaceRole role) {
    final l10n = context.l10n;
    return switch (role) {
      WorkspaceRole.owner => l10n.workspaceSettingsMemberRoleOwner,
      WorkspaceRole.admin => l10n.workspaceSettingsMemberRoleAdmin,
      WorkspaceRole.member => l10n.workspaceSettingsMemberRoleMember,
      WorkspaceRole.observer => l10n.workspaceSettingsMemberRoleObserver,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _roleColor(context, currentRole);
    final label = _roleLabel(context, currentRole);

    if (!enabled) {
      return Container(
        padding: const .symmetric(
          horizontal: Sizes.p10,
          vertical: Sizes.p4,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: .circular(Sizes.p8),
          border: Border.all(color: color.withValues(alpha: .3)),
        ),
        child: Text(
          label,
          style: context.text.labelSmall?.copyWith(
            fontWeight: .w700,
            color: color,
          ),
        ),
      );
    }

    return PopupMenuButton<WorkspaceRole>(
      tooltip: 'Zmień rolę',
      initialValue: currentRole,
      onSelected: onRoleChanged,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(Sizes.p8),
      ),
      itemBuilder: (ctx) => [
        for (final role in [
          WorkspaceRole.admin,
          WorkspaceRole.member,
          WorkspaceRole.observer,
        ])
          PopupMenuItem(
            value: role,
            child: Row(
              children: [
                Container(
                  width: Sizes.p8,
                  height: Sizes.p8,
                  decoration: BoxDecoration(
                    color: _roleColor(ctx, role),
                    shape: .circle,
                  ),
                ),
                Gaps.w8,
                Text(
                  _roleLabel(ctx, role),
                  style: TextStyle(
                    fontWeight: role == currentRole ? .w700 : .w400,
                  ),
                ),
              ],
            ),
          ),
      ],
      child: Container(
        padding: const .symmetric(
          horizontal: Sizes.p10,
          vertical: Sizes.p4,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: .circular(Sizes.p8),
          border: Border.all(color: color.withValues(alpha: .3)),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Text(
              label,
              style: context.text.labelSmall?.copyWith(
                fontWeight: .w700,
                color: color,
              ),
            ),
            Gaps.w4,
            Icon(
              Icons.arrow_drop_down_rounded,
              size: Sizes.p16,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
