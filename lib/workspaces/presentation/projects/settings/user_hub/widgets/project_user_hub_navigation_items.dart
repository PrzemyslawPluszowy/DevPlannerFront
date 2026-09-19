import 'package:devplanner/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

/// Zakładki lokalnego panelu użytkownika projektu.
enum ProjectUserHubTab {
  profile,
  preferences,
}

/// Pozycja desktopowej nawigacji panelu użytkownika.
class ProjectUserHubNavigationItem extends StatelessWidget {
  const ProjectUserHubNavigationItem({
    required this.tab,
    required this.selectedTab,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.onSelected,
    super.key,
  });

  final ProjectUserHubTab tab;
  final ProjectUserHubTab selectedTab;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final ValueChanged<ProjectUserHubTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSelected = selectedTab == tab;
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: isSelected ? colors.surfaceContainerLowest : Colors.transparent,
        borderRadius: .circular(Sizes.p8),
        border: Border.all(
          color: isSelected
              ? colors.outlineVariant.withValues(alpha: .8)
              : Colors.transparent,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: .04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: .circular(Sizes.p8),
        child: InkWell(
          borderRadius: .circular(Sizes.p8),
          onTap: () => onSelected(tab),
          child: Padding(
            padding: const .symmetric(
              horizontal: Sizes.p12,
              vertical: Sizes.p10,
            ),
            child: Row(
              children: [
                if (isSelected)
                  Container(
                    width: 3,
                    height: 16,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: .circular(2),
                    ),
                  ),
                Icon(
                  isSelected ? selectedIcon : icon,
                  size: Sizes.p18,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
                Gaps.w8,
                Expanded(
                  child: Text(
                    label,
                    style: context.text.bodyMedium?.copyWith(
                      fontWeight: isSelected ? .w700 : .w500,
                      color: isSelected
                          ? colors.onSurface
                          : colors.onSurfaceVariant,
                      letterSpacing: -.1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Kompaktowa pozycja horyzontalnej nawigacji panelu użytkownika.
class ProjectUserHubCompactNavigationItem extends StatelessWidget {
  const ProjectUserHubCompactNavigationItem({
    required this.tab,
    required this.selectedTab,
    required this.label,
    required this.icon,
    required this.onSelected,
    super.key,
  });

  final ProjectUserHubTab tab;
  final ProjectUserHubTab selectedTab;
  final String label;
  final IconData icon;
  final ValueChanged<ProjectUserHubTab> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSelected = selectedTab == tab;
    return Padding(
      padding: const EdgeInsets.only(right: Sizes.p6),
      child: Material(
        color: isSelected
            ? colors.primary.withValues(alpha: .12)
            : colors.surfaceContainerLowest,
        borderRadius: .circular(Sizes.p8),
        child: InkWell(
          onTap: () => onSelected(tab),
          borderRadius: .circular(Sizes.p8),
          child: Container(
            padding: const .symmetric(
              horizontal: Sizes.p10,
              vertical: Sizes.p4,
            ),
            decoration: BoxDecoration(
              borderRadius: .circular(Sizes.p8),
              border: Border.all(
                color: isSelected
                    ? colors.primary.withValues(alpha: .5)
                    : colors.outlineVariant.withValues(alpha: .4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: Sizes.p16,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
                Gaps.w6,
                Text(
                  label,
                  style: context.text.labelSmall?.copyWith(
                    fontWeight: isSelected ? .w700 : .w500,
                    color: isSelected
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
