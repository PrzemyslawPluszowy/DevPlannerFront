import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Gałąź pojedynczego zasobu w projekcie (np. zadanie, plik, whiteboard, notatka).
class ProjectResourceMenuBranch extends StatelessWidget {
  const ProjectResourceMenuBranch({
    required this.resource,
    required this.workspaceId,
    required this.projectId,
    super.key,
  });

  /// Element zasobu.
  final ProjectResourceListItem resource;

  /// Identyfikator workspace’u.
  final String workspaceId;

  /// Identyfikator projektu.
  final String projectId;

  String _getResourcePath() {
    return switch (resource.kind) {
      ProjectResourceKind.tasks =>
        '/workspaces/$workspaceId/projects/$projectId/tasks/${resource.id}',
      ProjectResourceKind.whiteboards =>
        '/workspaces/$workspaceId/projects/$projectId/whiteboards/${resource.id}',
      ProjectResourceKind.wiki =>
        '/workspaces/$workspaceId/projects/$projectId/wiki/${resource.id}',
      ProjectResourceKind.files =>
        '/workspaces/$workspaceId/projects/$projectId/files/${resource.id}',
      ProjectResourceKind.automations =>
        '/workspaces/$workspaceId/projects/$projectId',
    };
  }

  IconData _getResourceIcon() {
    return switch (resource.kind) {
      ProjectResourceKind.tasks => Symbols.check_circle_outline_rounded,
      ProjectResourceKind.whiteboards => Symbols.dashboard_customize_rounded,
      ProjectResourceKind.wiki => Symbols.description_rounded,
      ProjectResourceKind.files => Symbols.insert_drive_file_rounded,
      ProjectResourceKind.automations => Symbols.auto_mode_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GoRouter.of(context).routerDelegate,
      builder: (context, _) {
        final colors = context.colors;
        final path = _getResourcePath();
        final currentPath = context.plannerNavigation.currentPath;
        final isSelected =
            currentPath == path || currentPath.startsWith('$path/');

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => context.plannerNavigation.go(path),
            borderRadius: const .all(.circular(4)),
            hoverColor: colors.primary.withValues(alpha: .06),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? colors.primary.withValues(alpha: .08)
                    : Colors.transparent,
                borderRadius: const .all(.circular(4)),
              ),
              padding: const .symmetric(
                horizontal: Sizes.p6,
                vertical: 3,
              ),
              child: Row(
                children: [
                  Icon(
                    _getResourceIcon(),
                    size: 13,
                    color: isSelected
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                  Gaps.w6,
                  Expanded(
                    child: Text(
                      resource.title,
                      style: context.text.bodySmall?.copyWith(
                        fontSize: 11.5,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
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
      },
    );
  }
}
