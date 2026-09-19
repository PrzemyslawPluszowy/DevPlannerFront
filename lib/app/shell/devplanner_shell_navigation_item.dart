part of 'devplanner_shell.dart';

/// Pojedynczy wiersz drzewiastego menu. Renderuje tylko wygląd i intencje
/// przekazane przez właściciela shella; nie zna routingu ani źródeł danych.
final class _NavigationTreeItem extends StatelessWidget {
  const _NavigationTreeItem({
    required this.label,
    required this.icon,
    required this.depth,
    required this.isCollapsed,
    required this.isSelected,
    required this.isExpandable,
    required this.isExpanded,
    required this.onTap,
    required this.onToggle,
    this.trailingAction,
    super.key,
  });

  final String label;
  final IconData icon;
  final int depth;
  final bool isCollapsed;
  final bool isSelected;
  final bool isExpandable;
  final bool isExpanded;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? trailingAction;

  @override
  Widget build(BuildContext context) {
    final shellTheme = context.devPlannerShellTheme;
    final navigationTheme = context.devPlannerNavigationTheme;
    final content = Padding(
      padding: EdgeInsets.only(
        left: isCollapsed
            ? navigationTheme.rowHorizontalPadding
            : navigationTheme.rowHorizontalPadding +
                  (depth * navigationTheme.depthIndent),
        right: navigationTheme.rowHorizontalPadding,
      ),
      child: SizedBox(
        height: navigationTheme.rowHeight,
        child: Row(
          children: [
            Icon(
              icon,
              size: navigationTheme.rowIconSize,
              color: shellTheme.sidebarIcon,
            ),
            if (!isCollapsed) ...[
              SizedBox(width: navigationTheme.rowHorizontalPadding),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontSize: navigationTheme.rowFontSize,
                    height: 20 / 12,
                    color: onTap == null
                        ? shellTheme.sidebarText.withValues(alpha: .62)
                        : shellTheme.sidebarText,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (isExpandable)
                IconButton(
                  tooltip: isExpanded
                      ? AppLocalizations.of(context)!
                            .workspaceNavigationCollapseBranch
                      : AppLocalizations.of(context)!
                            .workspaceNavigationExpandBranch,
                  onPressed: onToggle,
                  icon: Icon(
                    isExpanded ? Icons.expand_more : Icons.chevron_right,
                    size: 16,
                    color: shellTheme.sidebarIcon,
                  ),
                  constraints: BoxConstraints.tightFor(
                    width: navigationTheme.rowHeight,
                    height: navigationTheme.rowHeight,
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              if (trailingAction != null)
                IconButton(
                  tooltip: AppLocalizations.of(context)!
                      .workspacesCreateProjectTitle,
                  onPressed: trailingAction,
                  icon: const Icon(Icons.add, size: 16),
                  constraints: BoxConstraints.tightFor(
                    width: navigationTheme.rowHeight,
                    height: navigationTheme.rowHeight,
                  ),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ],
        ),
      ),
    );
    final decorated = DecoratedBox(
      decoration: BoxDecoration(
        color: isSelected ? shellTheme.sidebarSelected : null,
        borderRadius: BorderRadius.circular(navigationTheme.selectedRadius),
      ),
      child: content,
    );
    final result = onTap == null
        ? decorated
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(navigationTheme.selectedRadius),
            hoverColor: shellTheme.sidebarHover,
            child: decorated,
          );
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: navigationTheme.sidebarHorizontalPadding,
      ),
      child: isCollapsed ? Tooltip(message: label, child: result) : result,
    );
  }
}
