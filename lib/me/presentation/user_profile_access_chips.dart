import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/me/domain/models/user_profile.dart';
import 'package:flutter/material.dart';

/// Prezentuje role i uprawnienia zwrócone przez profil użytkownika.
class UserProfileAccessChips extends StatelessWidget {
  const UserProfileAccessChips({required this.profile, super.key});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (profile.roles.isNotEmpty) ...[
          Text(
            l10n.meRolesLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Gaps.h8,
          Wrap(
            spacing: Sizes.p8,
            runSpacing: Sizes.p8,
            children: profile.roles
                .map(
                  (role) => Chip(
                    avatar: Icon(
                      Icons.shield_outlined,
                      size: 16,
                      color: theme.colorScheme.primary,
                    ),
                    label: Text(role),
                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                )
                .toList(),
          ),
          Gaps.h16,
        ],
        if (profile.permissions.isNotEmpty) ...[
          Text(
            l10n.mePermissionsLabel,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Gaps.h8,
          Wrap(
            spacing: Sizes.p6,
            runSpacing: Sizes.p6,
            children: profile.permissions
                .map((permission) => _PermissionChip(label: permission))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _PermissionChip extends StatelessWidget {
  const _PermissionChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p4),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: const .all(.circular(Sizes.p6)),
      border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );
}
