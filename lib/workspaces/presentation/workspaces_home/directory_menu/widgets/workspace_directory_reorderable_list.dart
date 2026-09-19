import 'dart:async';

import 'package:devplanner/workspaces/domain/models/workspace_list_item.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/cubit/workspaces_home_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/directory_menu/widgets/workspace_directory_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lista jednej sekcji katalogu, która utrzymuje kolejność bez zmiany stanu UI.
class WorkspaceDirectoryReorderableList extends StatelessWidget {
  const WorkspaceDirectoryReorderableList({
    required this.allItems,
    required this.visibleItems,
    required this.searchQuery,
    super.key,
  });

  final List<WorkspaceListItem> allItems;
  final List<WorkspaceListItem> visibleItems;
  final String searchQuery;

  void _reorder(BuildContext context, int oldIndex, int newIndex) {
    if (searchQuery.isNotEmpty ||
        oldIndex == newIndex ||
        oldIndex < 0 ||
        oldIndex >= visibleItems.length ||
        newIndex < 0 ||
        newIndex > visibleItems.length) {
      return;
    }
    final destination = newIndex;
    final reordered = [...visibleItems]
      ..removeAt(oldIndex)
      ..insert(destination, visibleItems[oldIndex]);
    final positions = visibleItems
        .map(allItems.indexOf)
        .toList(growable: false);
    final allIds = allItems.map((item) => item.id).toList(growable: false);
    for (var index = 0; index < positions.length; index++) {
      allIds[positions[index]] = reordered[index].id;
    }
    unawaited(context.read<WorkspacesHomeCubit>().reorderWorkspaces(allIds));
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      proxyDecorator: (child, index, animation) => Material(
        color: Colors.transparent,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: .35),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: child,
      ),
      itemCount: visibleItems.length,
      onReorderItem: (oldIndex, newIndex) =>
          _reorder(context, oldIndex, newIndex),
      itemBuilder: (context, index) {
        final item = visibleItems[index];
        return Padding(
          key: ValueKey(item.id),
          padding: const EdgeInsets.only(bottom: 2),
          child: WorkspaceDirectoryItem(item: item, index: index),
        );
      },
    );
  }
}
