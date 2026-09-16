import 'package:flutter/material.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/theme/theme.dart';

/// Element linku nawigacyjnego w menu katalogu Workspaces.
class DirectoryLink extends StatelessWidget {
  const DirectoryLink({
    required this.label,
    required this.icon,
    required this.path,
    this.badge,
    super.key,
  });

  /// Etykieta linku.
  final String label;

  /// Ikona reprezentująca sekcję.
  final IconData icon;

  /// Ścieżka nawigacji.
  final String path;

  /// Opcjonalny licznik lub badge.
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentPath = context.router.currentPath;
    final isSelected = currentPath == path || currentPath.startsWith('$path/');

    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: const .all(.circular(6)),
        side: BorderSide(
          color: isSelected
              ? colors.primary.withValues(alpha: .22)
              : Colors.transparent,
        ),
      ),
      child: InkWell(
        onTap: () => context.router.navigatePath(path),
        borderRadius: const .all(.circular(6)),
        hoverColor: colors.primary.withValues(alpha: .06),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? colors.primary.withValues(alpha: .08)
                : Colors.transparent,
            borderRadius: const .all(.circular(6)),
          ),
          padding: const .symmetric(
            horizontal: Sizes.p8,
            vertical: 5,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? colors.primary : colors.onSurfaceVariant,
              ),
              Gaps.w8,
              Expanded(
                child: Text(
                  label,
                  style: context.text.bodySmall?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? colors.primary : colors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badge != null)
                Container(
                  padding: const .symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary.withValues(alpha: .14)
                        : colors.surfaceContainerHigh,
                    borderRadius: const .all(.circular(8)),
                  ),
                  child: Text(
                    badge!,
                    style: context.text.labelSmall?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? colors.primary
                          : colors.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
