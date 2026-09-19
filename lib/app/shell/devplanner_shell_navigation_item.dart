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

  @override
  Widget build(BuildContext context) {
    final shellTheme = context.devPlannerShellTheme;
    final content = Padding(
      padding: EdgeInsets.only(
        left: isCollapsed ? 12 : 12 + (depth * 16),
        right: 8,
      ),
      child: SizedBox(
        height: 36,
        child: Row(
          children: [
            Icon(icon, size: 20, color: shellTheme.sidebarIcon),
            if (!isCollapsed) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: onTap == null
                        ? shellTheme.sidebarText.withValues(alpha: .62)
                        : shellTheme.sidebarText,
                    fontWeight: isSelected ? FontWeight.w600 : null,
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
                    size: 18,
                    color: shellTheme.sidebarIcon,
                  ),
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
        borderRadius: BorderRadius.circular(18),
      ),
      child: content,
    );
    final result = onTap == null
        ? decorated
        : InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            hoverColor: shellTheme.sidebarHover,
            child: decorated,
          );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: isCollapsed ? Tooltip(message: label, child: result) : result,
    );
  }
}
