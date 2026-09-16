import 'package:flutter/material.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_visibility.dart';

/// Komponent wyboru widoczności projektu (Współdzielony / Prywatny).
class ProjectVisibilitySelector extends StatelessWidget {
  const ProjectVisibilitySelector({
    required this.currentVisibility,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  /// Aktualnie wybrana widoczność projektu.
  final ProjectVisibility currentVisibility;

  /// Callback zmiany widoczności.
  final ValueChanged<ProjectVisibility> onChanged;

  /// Czy pole jest edytowalne.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          l10n.projectSettingsVisibilityLabel,
          style: context.text.labelMedium?.copyWith(
            fontWeight: .w700,
            color: colors.onSurface,
          ),
        ),
        Gaps.h8,
        Row(
          children: [
            Expanded(
              child: _VisibilityCard(
                icon: Icons.public_rounded,
                title: l10n.projectSettingsVisibilityShared,
                subtitle: l10n.projectSettingsVisibilitySharedDesc,
                isSelected: currentVisibility == ProjectVisibility.shared,
                enabled: enabled,
                onTap: () => onChanged(ProjectVisibility.shared),
              ),
            ),
            Gaps.w12,
            Expanded(
              child: _VisibilityCard(
                icon: Icons.lock_outline_rounded,
                title: l10n.projectSettingsVisibilityPrivate,
                subtitle: l10n.projectSettingsVisibilityPrivateDesc,
                isSelected: currentVisibility == ProjectVisibility.private,
                enabled: enabled,
                onTap: () => onChanged(ProjectVisibility.private),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _VisibilityCard extends StatelessWidget {
  const _VisibilityCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: isSelected
          ? colors.primaryContainer.withValues(alpha: .2)
          : colors.surfaceContainerLow,
      borderRadius: .circular(Sizes.p12),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: .circular(Sizes.p12),
        child: Container(
          padding: const .all(Sizes.p12),
          decoration: BoxDecoration(
            borderRadius: .circular(Sizes.p12),
            border: Border.all(
              color: isSelected
                  ? colors.primary
                  : colors.outlineVariant.withValues(alpha: .6),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            crossAxisAlignment: .start,
            children: [
              Icon(
                icon,
                size: Sizes.p20,
                color: isSelected ? colors.primary : colors.onSurfaceVariant,
              ),
              Gaps.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      title,
                      style: context.text.titleSmall?.copyWith(
                        fontWeight: .w700,
                        color: isSelected ? colors.primary : colors.onSurface,
                      ),
                    ),
                    Gaps.h4,
                    Text(
                      subtitle,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
