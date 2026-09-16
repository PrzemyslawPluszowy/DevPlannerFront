import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_shimmer.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/cubit/workspaces_home_cubit.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/cubit/workspaces_home_state.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/directory_menu/widgets/directory_link.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/directory_menu/widgets/directory_section_header.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/directory_menu/widgets/favorite_workspace_link.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/directory_menu/widgets/hidden_workspaces_section.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/directory_menu/widgets/workspace_directory_empty_state.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/directory_menu/widgets/workspace_directory_item.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/manage_workspace/create_workspace_dialog.dart';

/// Panel boczny katalogu Workspaces: sekcje Prywatne, Ulubione, Przestrzenie zespołowe i Ukryte.
class WorkspaceDirectoryMenu extends StatefulWidget {
  const WorkspaceDirectoryMenu({super.key});

  @override
  State<WorkspaceDirectoryMenu> createState() => _WorkspaceDirectoryMenuState();
}

class _WorkspaceDirectoryMenuState extends State<WorkspaceDirectoryMenu> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const .all(Sizes.p12),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          // Pole wyszukiwarki katalogu
          AppSearchTextField(
            hintText: 'Szukaj w przestrzeniach...',
            onChanged: (val) =>
                setState(() => _searchQuery = val.trim().toLowerCase()),
          ),
          Gaps.h12,

          // Główna przewijana zawartość menu
          Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<WorkspacesHomeCubit, WorkspacesHomeState>(
                builder: (context, state) {
                  return switch (state) {
                    WorkspacesHomeInitial() || WorkspacesHomeLoading() =>
                      const AppShimmerMenu(itemCount: 6),
                    WorkspacesHomeFailure(:final message) => Padding(
                      padding: const .all(Sizes.p8),
                      child: Text(
                        message,
                        style: context.text.bodySmall?.copyWith(
                          color: colors.error,
                        ),
                      ),
                    ),
                    WorkspacesHomeEmpty() =>
                      const WorkspaceDirectoryEmptyState(),
                    WorkspacesHomeForbidden(:final message) ||
                    WorkspacesHomeUnauthorized(:final message) => Padding(
                      padding: const .all(Sizes.p8),
                      child: Text(message),
                    ),
                    WorkspacesHomeLoaded(:final items, :final hiddenItems) =>
                      Builder(
                        builder: (context) {
                          final filteredItems = _searchQuery.isEmpty
                              ? items
                              : items
                                    .where(
                                      (w) => w.name.toLowerCase().contains(
                                        _searchQuery,
                                      ),
                                    )
                                    .toList();

                          final personalWorkspaces = filteredItems
                              .where((w) => w.isOwner)
                              .toList();
                          final teamWorkspaces = filteredItems
                              .where((w) => !w.isOwner)
                              .toList();
                          final favorites = filteredItems
                              .where((workspace) => workspace.isPinned)
                              .toList();

                          return Column(
                            crossAxisAlignment: .start,
                            children: [
                              // SEKTO: PRYWATNE
                              Container(
                                decoration: BoxDecoration(
                                  color: colors.surfaceContainerHigh.withValues(
                                    alpha: .35,
                                  ),
                                  borderRadius: const .all(.circular(10)),
                                  border: Border.all(
                                    color: colors.outlineVariant.withValues(
                                      alpha: .3,
                                    ),
                                  ),
                                ),
                                padding: const .all(Sizes.p8),
                                child: Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    DirectorySectionHeader(
                                      label:
                                          l10n.workspacesMyPrivateSectionLabel,
                                      icon: Symbols.person_outline_rounded,
                                      onAdd: () => unawaited(
                                        showCreateWorkspaceDialog(context),
                                      ),
                                    ),
                                    Gaps.h4,
                                    DirectoryLink(
                                      label: l10n.workspacesMyTasksLabel,
                                      icon: Symbols.task_alt_rounded,
                                      path: AppRoutePaths.meTasks,
                                    ),
                                    Gaps.h2,
                                    DirectoryLink(
                                      label: l10n.workspacesMyFilesLabel,
                                      icon: Symbols.folder_shared_rounded,
                                      path: AppRoutePaths.meFiles,
                                    ),

                                    if (personalWorkspaces.isNotEmpty) ...[
                                      Gaps.h8,
                                      Padding(
                                        padding: const .symmetric(
                                          horizontal: Sizes.p4,
                                        ),
                                        child: Text(
                                          l10n.workspacesMyWorkspacesSection
                                              .toUpperCase(),
                                          style: context.text.labelSmall
                                              ?.copyWith(
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w700,
                                                color: colors.onSurfaceVariant
                                                    .withValues(alpha: .6),
                                                letterSpacing: .3,
                                              ),
                                        ),
                                      ),
                                      Gaps.h4,
                                      ReorderableListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        buildDefaultDragHandles: false,
                                        proxyDecorator:
                                            (child, index, animation) =>
                                                Material(
                                                  color: Colors.transparent,
                                                  elevation: 8,
                                                  shadowColor: Colors.black
                                                      .withValues(alpha: .35),
                                                  borderRadius: const .all(
                                                    .circular(8),
                                                  ),
                                                  child: child,
                                                ),
                                        itemCount: personalWorkspaces.length,
                                        onReorderItem: (oldIndex, newIndex) {
                                          if (_searchQuery.isNotEmpty ||
                                              oldIndex == newIndex ||
                                              oldIndex < 0 ||
                                              oldIndex >=
                                                  personalWorkspaces.length ||
                                              newIndex < 0 ||
                                              newIndex >
                                                  personalWorkspaces.length) {
                                            return;
                                          }
                                          final destination =
                                              newIndex > oldIndex
                                              ? newIndex - 1
                                              : newIndex;
                                          final moved =
                                              personalWorkspaces[oldIndex];
                                          final reordered =
                                              [...personalWorkspaces]
                                                ..removeAt(oldIndex)
                                                ..insert(destination, moved);
                                          final positions = personalWorkspaces
                                              .map(items.indexOf)
                                              .toList();
                                          final allIds = items
                                              .map((item) => item.id)
                                              .toList();
                                          for (
                                            var index = 0;
                                            index < positions.length;
                                            index++
                                          ) {
                                            allIds[positions[index]] =
                                                reordered[index].id;
                                          }
                                          unawaited(
                                            context
                                                .read<WorkspacesHomeCubit>()
                                                .reorderWorkspaces(allIds),
                                          );
                                        },
                                        itemBuilder: (context, index) {
                                          final item =
                                              personalWorkspaces[index];
                                          return Padding(
                                            key: ValueKey(item.id),
                                            padding: const .only(bottom: 2),
                                            child: WorkspaceDirectoryItem(
                                              item: item,
                                              index: index,
                                            ),
                                          );
                                        },
                                      ),
                                    ] else ...[
                                      Gaps.h8,
                                      Material(
                                        color: Colors.transparent,
                                        borderRadius: const .all(.circular(6)),
                                        child: InkWell(
                                          onTap: () => unawaited(
                                            showCreateWorkspaceDialog(context),
                                          ),
                                          borderRadius: const .all(
                                            .circular(6),
                                          ),
                                          hoverColor: colors.primary.withValues(
                                            alpha: .08,
                                          ),
                                          child: Padding(
                                            padding: const .symmetric(
                                              horizontal: Sizes.p8,
                                              vertical: 4,
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .add_circle_outline_rounded,
                                                  size: 15,
                                                  color: colors.primary,
                                                ),
                                                Gaps.w8,
                                                Expanded(
                                                  child: Text(
                                                    l10n.workspacesCreatePrivateWorkspace,
                                                    style: context
                                                        .text
                                                        .bodySmall
                                                        ?.copyWith(
                                                          color: colors.primary,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              // SEKTO: ULUBIONE
                              if (favorites.isNotEmpty) ...[
                                Gaps.h12,
                                DirectorySectionHeader(
                                  label: l10n.workspacesFavoritesSection(
                                    favorites.length,
                                  ),
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

                              // SEKTO: PRZESTRZENIE ZESPOŁOWE
                              Gaps.h12,
                              DirectorySectionHeader(
                                label: teamWorkspaces.isNotEmpty
                                    ? l10n.workspacesTeamWorkspacesSection(
                                        teamWorkspaces.length,
                                      )
                                    : l10n.workspacesAllWorkspacesSection,
                                icon: Symbols.groups_rounded,
                                onAdd: () => unawaited(
                                  showCreateWorkspaceDialog(context),
                                ),
                              ),
                              Gaps.h8,

                              if (teamWorkspaces.isNotEmpty)
                                ReorderableListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  buildDefaultDragHandles: false,
                                  proxyDecorator: (child, index, animation) =>
                                      Material(
                                        color: Colors.transparent,
                                        elevation: 8,
                                        shadowColor: Colors.black.withValues(
                                          alpha: .35,
                                        ),
                                        borderRadius: const .all(.circular(8)),
                                        child: child,
                                      ),
                                  itemCount: teamWorkspaces.length,
                                  onReorderItem: (oldIndex, newIndex) {
                                    if (_searchQuery.isNotEmpty ||
                                        oldIndex == newIndex ||
                                        oldIndex < 0 ||
                                        oldIndex >= teamWorkspaces.length ||
                                        newIndex < 0 ||
                                        newIndex > teamWorkspaces.length) {
                                      return;
                                    }
                                    final destination = newIndex > oldIndex
                                        ? newIndex - 1
                                        : newIndex;
                                    final moved = teamWorkspaces[oldIndex];
                                    final reordered = [...teamWorkspaces]
                                      ..removeAt(oldIndex)
                                      ..insert(destination, moved);
                                    final positions = teamWorkspaces
                                        .map(items.indexOf)
                                        .toList();
                                    final allIds = items
                                        .map((item) => item.id)
                                        .toList();
                                    for (
                                      var index = 0;
                                      index < positions.length;
                                      index++
                                    ) {
                                      allIds[positions[index]] =
                                          reordered[index].id;
                                    }
                                    unawaited(
                                      context
                                          .read<WorkspacesHomeCubit>()
                                          .reorderWorkspaces(allIds),
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    final item = teamWorkspaces[index];
                                    return Padding(
                                      key: ValueKey(item.id),
                                      padding: const .only(bottom: 2),
                                      child: WorkspaceDirectoryItem(
                                        item: item,
                                        index: index,
                                      ),
                                    );
                                  },
                                )
                              else if (personalWorkspaces.isEmpty &&
                                  items.isEmpty)
                                const WorkspaceDirectoryEmptyState()
                              else
                                const SizedBox.shrink(),

                              // SEKTO: UKRYTE
                              HiddenWorkspacesSection(
                                hiddenWorkspaces: hiddenItems,
                              ),
                            ],
                          );
                        },
                      ),
                  };
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
