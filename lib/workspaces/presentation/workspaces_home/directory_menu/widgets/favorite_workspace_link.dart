import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/workspace_list_item.dart';
import 'package:devplanner/workspaces/shared/helpers/workspace_icon_helper.dart';
import 'package:flutter/material.dart';

/// Link do ulubionej (przypiętej) przestrzeni roboczej w menu katalogu.
class FavoriteWorkspaceLink extends StatelessWidget {
  const FavoriteWorkspaceLink({
    required this.label,
    required this.item,
    required this.path,
    super.key,
  });

  /// Nazwa przestrzeni.
  final String label;

  /// Dane przestrzeni.
  final WorkspaceListItem item;

  /// Ścieżka nawigacji.
  final String path;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentPath = context.plannerNavigation.currentPath;
    final isSelected = currentPath == path || currentPath.startsWith('$path/');
    final accentColor = WorkspaceIconHelper.parseColor(item.accentColorHex);

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
        onTap: () => context.plannerNavigation.go(path),
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
            vertical: 4,
          ),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: .18),
                  borderRadius: const .all(.circular(4)),
                ),
                alignment: .center,
                child: Icon(
                  WorkspaceIconHelper.getIcon(item.iconKey),
                  size: 11,
                  color: accentColor,
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
