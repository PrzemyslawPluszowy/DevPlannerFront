import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_assignee_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/kanban_assignee_visuals.dart';
import 'package:flutter/material.dart';

/// Wybiera docelowego wykonawcę z aktualnego widoku grupowania.
abstract final class KanbanMoveToPersonDialog {
  static const String unassignedPick = '__unassigned__';

  /// Zwraca null po anulowaniu albo pusty identyfikator dla grupy bez wykonawcy.
  static Future<({String? targetUserId})?> show(
    BuildContext context, {
    required TasksBoardReady state,
    required String taskId,
  }) async {
    final board = state.assigneeBoard;
    if (board == null) return null;
    final l10n = context.l10n;
    final currentGroupKey = board.groups
        .where((group) => group.tasks.any((item) => item.id == taskId))
        .map(TasksBoardAssigneeCommands.keyOf)
        .firstOrNull;
    final options = board.groups
        .where(
          (group) => TasksBoardAssigneeCommands.keyOf(group) != currentGroupKey,
        )
        .toList(growable: false);
    if (options.isEmpty) return null;

    final picked = await DevPlannerModalHost.showDialog<String>(
      context,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      builder: (dialogContext) => KanbanMoveToPersonDialogPanel(
        title: l10n.tasksBoardMoveToPerson,
        groups: options,
        onSelected: (value) => Navigator.of(dialogContext).pop(value),
      ),
    );
    if (picked == null) return null;
    if (picked != unassignedPick) return (targetUserId: picked);
    if (!context.mounted) return null;

    final confirmed = await AppConfirmDialog.show(
      context,
      title: l10n.tasksBoardUnassignedDropTitle,
      message: l10n.tasksBoardUnassignedDropBody,
      confirmLabel: l10n.tasksBoardUnassignedDropConfirm,
      cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
    );
    return confirmed ? (targetUserId: null) : null;
  }
}

/// Lista celów w stylu desktopowym na głównym navigatorze modali.
class KanbanMoveToPersonDialogPanel extends StatelessWidget {
  const KanbanMoveToPersonDialogPanel({
    required this.title,
    required this.groups,
    required this.onSelected,
    super.key,
  });

  final String title;
  final List<AssigneeKanbanGroupResponse> groups;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380, maxHeight: 520),
        child: Padding(
          padding: EdgeInsets.all(tasks.sectionGap),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: context.text.titleMedium),
              SizedBox(height: tasks.controlGap),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: groups.length,
                  separatorBuilder: (context, index) =>
                      SizedBox(height: tasks.tightGap),
                  itemBuilder: (context, index) {
                    final group = groups[index];
                    final unassigned = group.assigneeUserId == null;
                    return _KanbanMoveToPersonOption(
                      group: group,
                      label: unassigned
                          ? context.l10n.tasksKanbanQuickFilterUnassigned
                          : group.displayName,
                      isUnassigned: unassigned,
                      onTap: () => onSelected(
                        group.assigneeUserId ??
                            KanbanMoveToPersonDialog.unassignedPick,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: tasks.controlGap),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    MaterialLocalizations.of(context).cancelButtonLabel,
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

/// Opcja wyboru osoby w oknie przenoszenia zadania.
class _KanbanMoveToPersonOption extends StatelessWidget {
  const _KanbanMoveToPersonOption({
    required this.group,
    required this.label,
    required this.isUnassigned,
    required this.onTap,
  });

  final AssigneeKanbanGroupResponse group;
  final String label;
  final bool isUnassigned;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tasks = context.tasksTheme;
    final colors = context.colors;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(tasks.controlRadius),
          hoverColor: colors.surfaceContainerHighest,
          focusColor: colors.surfaceContainerHighest,
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(tasks.controlGap),
            child: Row(
              children: [
                KanbanAssigneeAvatar(
                  displayName: group.displayName,
                  avatarUrl: group.avatarUrl,
                  isUnassigned: isUnassigned,
                ),
                SizedBox(width: tasks.controlGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: tasks.controlText),
                      if (group.isCurrentUser)
                        Text(
                          context.l10n.tasksBoardCurrentUserBadge,
                          style: tasks.metaText.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
