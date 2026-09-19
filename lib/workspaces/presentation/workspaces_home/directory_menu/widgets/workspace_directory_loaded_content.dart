import 'dart:async';

import 'package:devplanner/app/router/devplanner_router.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/domain/models/workspace_list_item.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/directory_menu/widgets/directory_link.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/directory_menu/widgets/directory_section_header.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/directory_menu/widgets/favorite_workspace_link.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/directory_menu/widgets/hidden_workspaces_section.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/directory_menu/widgets/workspace_directory_empty_state.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/directory_menu/widgets/workspace_directory_reorderable_list.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/create_workspace_dialog.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Renderuje sekcje widocznego katalogu dla już pobranych workspace’ów.
class WorkspaceDirectoryLoadedContent extends StatelessWidget {
  const WorkspaceDirectoryLoadedContent({
    required this.items,
    required this.hiddenItems,
    required this.searchQuery,
    super.key,
  });

  final List<WorkspaceListItem> items;
  final List<WorkspaceListItem> hiddenItems;
  final String searchQuery;

  void _createWorkspace(BuildContext context) {
    unawaited(CreateWorkspaceDialog.show(context));
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = searchQuery.isEmpty
        ? items
        : items
              .where(
                (workspace) => workspace.name.toLowerCase().contains(
                  searchQuery,
                ),
              )
              .toList(growable: false);
    final personalWorkspaces = filteredItems
        .where((workspace) => workspace.isOwner)
        .toList(growable: false);
    final teamWorkspaces = filteredItems
        .where((workspace) => !workspace.isOwner)
        .toList(growable: false);
    final favorites = filteredItems
        .where((workspace) => workspace.isPinned)
        .toList(growable: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PrivateWorkspaceSection(
          allItems: items,
          personalWorkspaces: personalWorkspaces,
          searchQuery: searchQuery,
          onCreate: () => _createWorkspace(context),
        ),
        if (favorites.isNotEmpty) ...[
          Gaps.h12,
          DirectorySectionHeader(
            label: context.l10n.workspacesFavoritesSection(favorites.length),
            icon: Symbols.star_border_rounded,
          ),
          Gaps.h4,
          for (final item in favorites)
            FavoriteWorkspaceLink(
              label: item.name,
              item: item,
              path: '/workspaces/${item.id}',
            ),
        ],
        Gaps.h12,
        DirectorySectionHeader(
          label: teamWorkspaces.isNotEmpty
              ? context.l10n.workspacesTeamWorkspacesSection(
                  teamWorkspaces.length,
                )
              : context.l10n.workspacesAllWorkspacesSection,
          icon: Symbols.groups_rounded,
          onAdd: () => _createWorkspace(context),
        ),
        Gaps.h8,
        if (teamWorkspaces.isNotEmpty)
          WorkspaceDirectoryReorderableList(
            allItems: items,
            visibleItems: teamWorkspaces,
            searchQuery: searchQuery,
          )
        else if (personalWorkspaces.isEmpty && items.isEmpty)
          const WorkspaceDirectoryEmptyState(),
        HiddenWorkspacesSection(hiddenWorkspaces: hiddenItems),
      ],
    );
  }
}

class _PrivateWorkspaceSection extends StatelessWidget {
  const _PrivateWorkspaceSection({
    required this.allItems,
    required this.personalWorkspaces,
    required this.searchQuery,
    required this.onCreate,
  });

  final List<WorkspaceListItem> allItems;
  final List<WorkspaceListItem> personalWorkspaces;
  final String searchQuery;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DirectorySectionHeader(
          label: context.l10n.workspacesMyPrivateSectionLabel,
          icon: Symbols.person_outline_rounded,
          onAdd: onCreate,
        ),
        Gaps.h4,
        DirectoryLink(
          label: context.l10n.workspacesMyTasksLabel,
          icon: Symbols.task_alt_rounded,
          path: DevPlannerRouteCatalog.myTasks,
        ),
        Gaps.h2,
        DirectoryLink(
          label: context.l10n.workspacesMyFilesLabel,
          icon: Symbols.folder_shared_rounded,
          path: DevPlannerRouteCatalog.myFiles,
        ),
        if (personalWorkspaces.isNotEmpty) ...[
          Gaps.h8,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              context.l10n.workspacesMyWorkspacesSection.toUpperCase(),
              style: context.text.labelSmall?.copyWith(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: colors.onSurfaceVariant.withValues(alpha: .6),
                letterSpacing: .3,
              ),
            ),
          ),
          Gaps.h4,
          WorkspaceDirectoryReorderableList(
            allItems: allItems,
            visibleItems: personalWorkspaces,
            searchQuery: searchQuery,
          ),
        ] else ...[
          Gaps.h8,
          _CreatePrivateWorkspaceAction(onCreate: onCreate),
        ],
      ],
    );
  }
}

class _CreatePrivateWorkspaceAction extends StatelessWidget {
  const _CreatePrivateWorkspaceAction({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      borderRadius: const BorderRadius.all(Radius.circular(6)),
      child: InkWell(
        onTap: onCreate,
        borderRadius: const BorderRadius.all(Radius.circular(6)),
        hoverColor: colors.primary.withValues(alpha: .08),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Icon(
                Icons.add_circle_outline_rounded,
                size: 15,
                color: colors.primary,
              ),
              Gaps.w8,
              Expanded(
                child: Text(
                  context.l10n.workspacesCreatePrivateWorkspace,
                  style: context.text.bodySmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
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
