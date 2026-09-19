import 'dart:async';

import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
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
    Offset? position,
    AssigneeMenuAction? initialAction,
    EligibleProfilesPageLoader? searchEligibleProfiles,
  }) async {
    final menuPosition = position ?? AppContextMenu.positionFor(context);
    final action =
        initialAction ??
        await _showAssigneeActionContext(
          context: context,
          globalPosition: menuPosition,
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
      globalPosition: menuPosition,
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
    required Offset globalPosition,
  }) => AppContextMenu.select<AssigneeMenuAction>(
    context,
    globalPosition: globalPosition,
    headerTitle: 'Przypisanie',
    options: const [
      AppContextMenuOption(
        value: AssigneeMenuAction.setOwner,
        label: 'Ustaw właściciela',
        icon: Symbols.person_rounded,
      ),
      AppContextMenuOption(
        value: AssigneeMenuAction.toggleCollaborator,
        label: 'Współpracownicy',
        icon: Symbols.group_add,
      ),
      AppContextMenuOption(
        value: AssigneeMenuAction.clear,
        label: 'Usuń przypisanie',
        icon: Symbols.person_remove,
        separatorBefore: true,
      ),
    ],
  );

  /// Wyszukiwanie osób jest interaktywną zawartością, więc korzysta z tej
  /// samej powierzchni menu przez `showCustom`, a wybór wraca przez `pop`.
  static Future<String?> _showAssigneeSearchContext(
    BuildContext context, {
    required Offset globalPosition,
    required List<ProjectMemberProfile> candidates,
    required List<String> selectedIds,
    required String? primaryId,
    required AssigneeMenuAction selectionMode,
    EligibleProfilesPageLoader? searchEligibleProfiles,
  }) {
    final result = Completer<String?>();
    unawaited(
      AppContextMenu.showCustom(
        context,
        globalPosition: globalPosition,
        maxWidth: 340,
        contentBuilder: (panelContext, _) {
          final navigator = Navigator.of(panelContext);
          return TaskAssigneeSearchMenu(
            candidates: candidates,
            selectedIds: selectedIds,
            primaryId: primaryId,
            selectionMode: selectionMode,
            searchEligibleProfiles: searchEligibleProfiles,
            onSelected: (value) {
              if (!result.isCompleted) result.complete(value);
              navigator.pop();
            },
          );
        },
      ),
    );
    return result.future;
  }
}
