import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/shared/presentation/widgets/app_expansible_navigation_item.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:devplanner/workspaces/domain/models/workspace_list_item.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/cubit/workspaces_home_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/manage_workspace/edit_workspace_dialog.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/workspace_project_menu.dart';
import 'package:devplanner/workspaces/presentation/workspaces_settings/workspace_settings_modal.dart';
import 'package:devplanner/workspaces/shared/helpers/workspace_icon_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Element katalogu pojedynczego workspace’u z obsługą rozwijania projektów, menu akcji i Drag & Drop.
class WorkspaceDirectoryItem extends StatefulWidget {
  const WorkspaceDirectoryItem({
    required this.item,
    required this.index,
    super.key,
  });

  /// Dane przestrzeni roboczej.
  final WorkspaceListItem item;

  /// Indeks na liście dla przeciągania.
  final int index;

  @override
  State<WorkspaceDirectoryItem> createState() => _WorkspaceDirectoryItemState();
}

class _WorkspaceDirectoryItemState extends State<WorkspaceDirectoryItem> {
  final ValueNotifier<_WorkspaceDirectoryItemUiState> _uiState = ValueNotifier(
    const _WorkspaceDirectoryItemUiState(),
  );
  String? _autoExpandedWorkspacePath;

  @override
  void dispose() {
    _uiState.dispose();
    super.dispose();
  }

  void _openWorkspace(BuildContext context) {
    if (!_uiState.value.isExpanded) {
      _uiState.value = _uiState.value.copyWith(isExpanded: true);
    }
    unawaited(
      context.plannerNavigation.go('/workspaces/${widget.item.id}'),
    );
  }

  void _syncActiveExpansion(bool isSelected) {
    final workspacePath = '/workspaces/${widget.item.id}';
    if (!isSelected) {
      _autoExpandedWorkspacePath = null;
      return;
    }
    if (_uiState.value.isExpanded ||
        _autoExpandedWorkspacePath == workspacePath) {
      return;
    }
    _autoExpandedWorkspacePath = workspacePath;
    if (isSelected && !_uiState.value.isExpanded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_uiState.value.isExpanded) {
          _uiState.value = _uiState.value.copyWith(isExpanded: true);
        }
      });
    }
  }

  void _showContextMenu(BuildContext context, Offset globalPosition) {
    final cubit = context.read<WorkspacesHomeCubit>();
    final l10n = context.l10n;

    unawaited(
      AppContextMenu.show(
        context,
        globalPosition: globalPosition,
        actions: [
          AppContextMenuAction(
            label: l10n.workspaceSettingsTitle,
            icon: Symbols.settings_rounded,
            onTap: (_) => unawaited(
              WorkspaceSettingsModal.show(
                context: context,
                workspace: widget.item,
                userRole: widget.item.isOwner
                    ? WorkspaceRole.owner
                    : WorkspaceRole.member,
              ),
            ),
          ),
          AppContextMenuAction(
            label: l10n.workspacesEditAction,
            icon: Symbols.edit_rounded,
            onTap: (_) => unawaited(
              EditWorkspaceDialog.show(context, item: widget.item),
            ),
          ),
          AppContextMenuAction(
            label: widget.item.isPinned
                ? l10n.workspacesUnpinAction
                : l10n.workspacesPinAction,
            icon: widget.item.isPinned
                ? Symbols.star_rounded
                : Symbols.star_border_rounded,
            onTap: (_) => unawaited(
              cubit.setPinned(widget.item.id, !widget.item.isPinned),
            ),
          ),
          AppContextMenuAction(
            label: widget.item.isHidden
                ? l10n.workspacesShowAction
                : l10n.workspacesHideAction,
            icon: widget.item.isHidden
                ? Symbols.visibility_rounded
                : Symbols.visibility_off_rounded,
            isDestructive: !widget.item.isHidden,
            onTap: (_) => unawaited(
              cubit.setHidden(widget.item.id, !widget.item.isHidden),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final currentPath = context.plannerNavigation.currentPath;
    final workspacePath = '/workspaces/${widget.item.id}';
    final isSelected =
        currentPath == workspacePath ||
        currentPath.startsWith('$workspacePath/');
    _syncActiveExpansion(isSelected);
    final accentColor = WorkspaceIconHelper.parseColor(
      widget.item.accentColorHex,
    );

    return ValueListenableBuilder<_WorkspaceDirectoryItemUiState>(
      valueListenable: _uiState,
      builder: (context, uiState, _) => RepaintBoundary(
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          children: [
            MouseRegion(
              onEnter: (_) =>
                  _uiState.value = uiState.copyWith(isHovered: true),
              onExit: (_) =>
                  _uiState.value = uiState.copyWith(isHovered: false),
              child: GestureDetector(
                onSecondaryTapDown: (details) =>
                    _showContextMenu(context, details.globalPosition),
                child: Material(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: const .all(.circular(6)),
                    side: BorderSide(
                      color: isSelected
                          ? colors.primary.withValues(alpha: .24)
                          : Colors.transparent,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => _openWorkspace(context),
                    borderRadius: const .all(.circular(6)),
                    hoverColor: colors.primary.withValues(alpha: .06),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colors.primary.withValues(alpha: .09)
                            : Colors.transparent,
                        borderRadius: const .all(.circular(6)),
                      ),
                      padding: const .symmetric(
                        horizontal: 4,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          // Uchwyt przeciągania
                          ReorderableDragStartListener(
                            index: widget.index,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.grab,
                              child: Padding(
                                padding: const .symmetric(horizontal: 2),
                                child: Icon(
                                  Symbols.drag_indicator_rounded,
                                  size: 14,
                                  color: uiState.isHovered
                                      ? colors.onSurfaceVariant.withValues(
                                          alpha: .6,
                                        )
                                      : Colors.transparent,
                                ),
                              ),
                            ),
                          ),

                          // Przycisk rozwijania drzewa projektów
                          InkWell(
                            onTap: () => _uiState.value = uiState.copyWith(
                              isExpanded: !uiState.isExpanded,
                            ),
                            borderRadius: const .all(.circular(4)),
                            child: Padding(
                              padding: const .all(2),
                              child: AnimatedRotation(
                                turns: uiState.isExpanded ? .25 : 0,
                                duration: const Duration(milliseconds: 150),
                                child: Icon(
                                  Symbols.chevron_right_rounded,
                                  size: 15,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                          Gaps.w4,

                          // Ikona przestrzeni z kolorem akcentu
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: .18),
                              borderRadius: const .all(.circular(5)),
                            ),
                            alignment: .center,
                            child: Icon(
                              WorkspaceIconHelper.getIcon(widget.item.iconKey),
                              size: 12,
                              color: accentColor,
                            ),
                          ),
                          Gaps.w6,

                          // Nazwa przestrzeni
                          Expanded(
                            child: Text(
                              widget.item.name,
                              style: context.text.bodySmall?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? colors.primary
                                    : colors.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Gwiazdka ulubionych
                          if (widget.item.isPinned)
                            Padding(
                              padding: const .only(right: 2),
                              child: Icon(
                                Symbols.star_rounded,
                                size: 13,
                                color: colors.primary,
                              ),
                            ),

                          // Przycisk menu akcji
                          if (uiState.isHovered || isSelected)
                            InkWell(
                              onTapDown: (details) => _showContextMenu(
                                context,
                                details.globalPosition,
                              ),
                              borderRadius: const .all(.circular(4)),
                              child: Padding(
                                padding: const .all(2),
                                child: Icon(
                                  Symbols.more_horiz_rounded,
                                  size: 15,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Rozwijane drzewo projektów i zasobów
            if (uiState.isExpanded)
              Padding(
                padding: const .only(left: Sizes.p16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppExpansibleNavigationItem(
                      label: context.l10n.workspacesSectionFiles,
                      icon: WorkspaceIcons.file,
                      depth: 1,
                      selected: context.plannerNavigation.currentPath
                          .startsWith(
                            '/workspaces/${widget.item.id}/files',
                          ),
                      onTap: () => unawaited(
                        context.plannerNavigation.go(
                          '/workspaces/${widget.item.id}/files',
                        ),
                      ),
                    ),
                    BlocProvider(
                      create: (context) {
                        final cubit = WorkspaceProjectsCubit(
                          workspaceId: widget.item.id,
                          gateway: context.read<ProjectsGateway>(),
                        );
                        unawaited(cubit.load());
                        return cubit;
                      },
                      child: WorkspaceProjectMenu(
                        workspaceId: widget.item.id,
                        onProjectTap: (path) =>
                            unawaited(context.plannerNavigation.go(path)),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceDirectoryItemUiState {
  const _WorkspaceDirectoryItemUiState({
    this.isExpanded = false,
    this.isHovered = false,
  });

  final bool isExpanded;
  final bool isHovered;

  _WorkspaceDirectoryItemUiState copyWith({
    bool? isExpanded,
    bool? isHovered,
  }) {
    return _WorkspaceDirectoryItemUiState(
      isExpanded: isExpanded ?? this.isExpanded,
      isHovered: isHovered ?? this.isHovered,
    );
  }
}
