import 'dart:async';

import 'package:devplanner/shared/presentation/widgets/workspace_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_assignee_search_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Lokalny launcher zakotwiczonego menu przypisania osób do zadania.
///
/// Nie pobiera danych ani nie mutuje domeny: pełny zapis jest przekazanym
/// callbackiem właściciela Cubita/listy.
final class TaskAssigneePicker {
  const TaskAssigneePicker._();

  static Future<void> show(
    BuildContext context, {
    required List<TaskAssigneeResponse> assignees,
    required Map<String, ProjectMemberProfile> profiles,
    required Future<bool> Function(List<String> userIds) onSave,
    RelativeRect? menuPosition,
    AssigneeMenuAction? initialAction,
    EligibleProfilesPageLoader? searchEligibleProfiles,
  }) async {
    final position = menuPosition ?? _menuPositionFor(context);
    final action =
        initialAction ??
        await _showAssigneeActionContext(
          context: context,
          position: position,
        );
    if (action == null) return;
    if (action == AssigneeMenuAction.clear) {
      await onSave(const []);
      return;
    }
    if (!context.mounted) return;
    final candidates =
        profiles.values.toList(
          growable: false,
        )..sort(
          (left, right) => TaskAssigneeSearchMenu.profileLabel(
            left,
          ).compareTo(TaskAssigneeSearchMenu.profileLabel(right)),
        );
    if (candidates.isEmpty && searchEligibleProfiles == null) return;
    final currentIds = assignees
        .map((item) => item.userId)
        .toList(growable: false);
    final primaryId =
        assignees.where((item) => item.isPrimary).firstOrNull?.userId ??
        currentIds.firstOrNull;
    final selectedId = await _showAssigneeSearchContext(
      context,
      position: position,
      candidates: candidates,
      selectedIds: currentIds,
      primaryId: primaryId,
      selectionMode: action,
      searchEligibleProfiles: searchEligibleProfiles,
    );
    if (selectedId == null) return;
    if (selectedId == '__clear_owner__') {
      await onSave(currentIds.where((id) => id != primaryId).toList());
      return;
    }
    if (action == AssigneeMenuAction.setOwner) {
      await onSave([selectedId, ...currentIds.where((id) => id != selectedId)]);
      return;
    }
    final ids = [...currentIds];
    ids.contains(selectedId) ? ids.remove(selectedId) : ids.add(selectedId);
    if (primaryId != null && ids.remove(primaryId)) ids.insert(0, primaryId);
    await onSave(ids);
  }

  static Future<AssigneeMenuAction?> _showAssigneeActionContext({
    required BuildContext context,
    required RelativeRect position,
  }) => WorkspaceContextMenu.select<AssigneeMenuAction>(
    context,
    position: position,
    items: const [
      PopupMenuItem(
        value: AssigneeMenuAction.setOwner,
        height: 32,
        padding: .symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(Symbols.person_rounded, size: 16),
            SizedBox(width: 8),
            Text('Ustaw właściciela'),
          ],
        ),
      ),
      PopupMenuItem(
        value: AssigneeMenuAction.toggleCollaborator,
        height: 32,
        padding: .symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(Symbols.group_add, size: 16),
            SizedBox(width: 8),
            Text('Współpracownicy'),
          ],
        ),
      ),
      PopupMenuItem(
        value: AssigneeMenuAction.clear,
        height: 32,
        padding: .symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(Symbols.person_remove, size: 16),
            SizedBox(width: 8),
            Text('Usuń przypisanie'),
          ],
        ),
      ),
    ],
  );

  static Future<String?> _showAssigneeSearchContext(
    BuildContext context, {
    required RelativeRect position,
    required List<ProjectMemberProfile> candidates,
    required List<String> selectedIds,
    required String? primaryId,
    required AssigneeMenuAction selectionMode,
    EligibleProfilesPageLoader? searchEligibleProfiles,
  }) => WorkspaceContextMenu.select<String>(
    context,
    position: position,
    items: [
      TaskAssigneeSearchMenu(
        candidates: candidates,
        selectedIds: selectedIds,
        primaryId: primaryId,
        selectionMode: selectionMode,
        searchEligibleProfiles: searchEligibleProfiles,
      ),
    ],
  );

  static RelativeRect _menuPositionFor(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return RelativeRect.fill;
    final translation = renderBox.getTransformTo(null).getTranslation();
    final size = renderBox.size;
    return RelativeRect.fromLTRB(
      translation.x,
      translation.y + size.height,
      translation.x + size.width,
      translation.y + size.height,
    );
  }
}
