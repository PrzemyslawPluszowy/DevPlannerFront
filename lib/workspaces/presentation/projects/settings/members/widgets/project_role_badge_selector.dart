import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';

/// Przełącznik / badge wyboru roli członka projektu (`Owner`, `Admin`, `Member`, `Observer`).
class ProjectRoleBadgeSelector extends StatelessWidget {
  const ProjectRoleBadgeSelector({
    required this.currentRole,
    required this.onRoleChanged,
    this.enabled = true,
    super.key,
  });

  /// Aktualna rola członka.
  final ProjectRole currentRole;

  /// Callback zmiany roli.
  final ValueChanged<ProjectRole> onRoleChanged;

  /// Czy użytkownik może zmienić rolę.
  final bool enabled;

  Color _roleColor(BuildContext context, ProjectRole role) {
    final colors = context.colors;
    return switch (role) {
      ProjectRole.owner => colors.error,
      ProjectRole.admin => colors.primary,
      ProjectRole.member => colors.secondary,
      ProjectRole.observer => colors.outline,
    };
  }

  String _roleLabel(BuildContext context, ProjectRole role) {
    final l10n = context.l10n;
    return switch (role) {
      ProjectRole.owner => l10n.projectSettingsMemberRoleOwner,
      ProjectRole.admin => l10n.projectSettingsMemberRoleAdmin,
      ProjectRole.member => l10n.projectSettingsMemberRoleMember,
      ProjectRole.observer => l10n.projectSettingsMemberRoleObserver,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _roleColor(context, currentRole);

    if (!enabled) {
      return Container(
        padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: .circular(Sizes.p6),
          border: Border.all(color: color.withValues(alpha: .3)),
        ),
        child: Text(
          _roleLabel(context, currentRole),
          style: context.text.labelSmall?.copyWith(
            fontWeight: .w700,
            color: color,
          ),
        ),
      );
    }

    return PopupMenuButton<ProjectRole>(
      initialValue: currentRole,
      tooltip: 'Zmień rolę',
      onSelected: onRoleChanged,
      itemBuilder: (ctx) => [
        for (final role in ProjectRole.values)
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
                if (role == currentRole) ...[
                  Gaps.w8,
                  const Icon(Icons.check, size: Sizes.p16),
                ],
              ],
            ),
          ),
      ],
      child: Container(
        padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: .circular(Sizes.p6),
          border: Border.all(color: color.withValues(alpha: .4)),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Text(
              _roleLabel(context, currentRole),
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
