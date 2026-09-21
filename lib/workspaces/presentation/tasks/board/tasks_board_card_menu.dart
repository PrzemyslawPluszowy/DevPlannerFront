part of 'tasks_board_page.dart';

/// Zunifikowane menu kontekstowe dla kart zadań Kanbana.
///
/// Obsługuje:
/// - Prawy przycisk myszy (PPM) na karcie
/// - Przycisk wielokropka „...” / skrót klawiaturowy Shift+F10
/// - Szybkie akcje: Otwórz szczegóły, Kopiuj kod, Kopiuj link
/// - Zmiana statusu, priorytetu, wykonawcy, terminu
/// - Przypnij / odepnij, obserwuj / przestań obserwować
class KanbanCardContextMenuHelper {
  KanbanCardContextMenuHelper._();

  static Future<void> show({
    required BuildContext context,
    required KanbanTaskCardResponse task,
    required String workspaceId,
    required String projectId,
    required Map<String, ProjectMemberProfile> memberProfilesByUserId,
    Offset? globalPosition,
  }) async {
    final cubit = context.read<TasksBoardCubit>();
    final colors = context.colors;
    final l10n = context.l10n;

    final menuPosition = globalPosition ?? AppContextMenu.positionFor(context);

    final selectedAction = await AppContextMenu.select<_KanbanCardMenuAction>(
      context,
      globalPosition: menuPosition,
      options: [
        AppContextMenuOption(
          value: _KanbanCardMenuAction.open,
          label: l10n.tasksContextMenuOpen,
          icon: Symbols.open_in_new_rounded,
        ),
        AppContextMenuOption(
          value: _KanbanCardMenuAction.copyCode,
          label: l10n.tasksContextMenuCopyCode,
          icon: Symbols.content_copy_rounded,
        ),
        AppContextMenuOption(
          value: _KanbanCardMenuAction.copyLink,
          label: l10n.tasksContextMenuCopyLink,
          icon: Symbols.link_rounded,
        ),
        AppContextMenuOption(
          separatorBefore: true,

          value: _KanbanCardMenuAction.status,
          label: l10n.tasksContextMenuStatus,
          icon: Symbols.flowsheet_rounded,
        ),
        AppContextMenuOption(
          value: _KanbanCardMenuAction.priority,
          label: l10n.tasksContextMenuPriority,
          icon: Symbols.flag_rounded,
        ),
        AppContextMenuOption(
          value: _KanbanCardMenuAction.assignee,
          label: l10n.tasksContextMenuAssignee,
          icon: Symbols.person_rounded,
        ),
        // Widok osób dopiero czyni zmianę wykonawcy osobną operacją, więc
        // pozycja pojawia się wyłącznie tam: w widoku statusów wykonawca jest
        // edytowany w szczegółach zadania.
        if (cubit.state case TasksBoardReady(
          grouping: TasksBoardGrouping.assignee,
          assigneeBoard: != null,
        ))
          AppContextMenuOption(
            value: _KanbanCardMenuAction.moveToPerson,
            label: l10n.tasksBoardMoveToPerson,
            icon: Symbols.arrow_forward_rounded,
          ),
        AppContextMenuOption(
          value: _KanbanCardMenuAction.dueDate,
          label: l10n.tasksContextMenuDueDate,
          icon: Symbols.event_rounded,
        ),
        AppContextMenuOption(
          separatorBefore: true,

          value: _KanbanCardMenuAction.pin,
          label: task.isPinned ? l10n.tasksUnpinTask : l10n.tasksPinTask,
          icon: task.isPinned ? Symbols.push_pin_rounded : Symbols.push_pin,
          iconColor: task.isPinned ? colors.primary : null,
        ),
        AppContextMenuOption(
          value: _KanbanCardMenuAction.watch,
          label: task.isWatchedByMe
              ? l10n.tasksUnwatchTask
              : l10n.tasksWatchTask,
          icon: task.isWatchedByMe
              ? Symbols.visibility_rounded
              : Symbols.visibility,
          iconColor: task.isWatchedByMe ? colors.primary : null,
        ),
      ],
    );

    if (!context.mounted || selectedAction == null) return;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    switch (selectedAction) {
      case _KanbanCardMenuAction.open:
        final router = GoRouter.maybeOf(context);
        if (router == null) break;
        unawaited(
          DevPlannerNavigation(router).go(
            '/workspaces/$workspaceId/projects/$projectId/tasks/${task.id}',
          ),
        );

      case _KanbanCardMenuAction.copyCode:
        await Clipboard.setData(ClipboardData(text: task.taskCode));
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Skopiowano kod: ${task.taskCode}'),
            duration: const Duration(seconds: 2),
          ),
        );

      case _KanbanCardMenuAction.copyLink:
        final link =
            '${Uri.base.origin}/workspaces/$workspaceId/projects/$projectId/tasks/${task.id}';
        await Clipboard.setData(ClipboardData(text: link));
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Skopiowano link do zadania'),
            duration: Duration(seconds: 2),
          ),
        );

      case _KanbanCardMenuAction.status:
        final currentColumn = cubit.state is TasksBoardReady
            ? (cubit.state as TasksBoardReady).board.columns.firstWhere(
                (col) => col.tasks.any((t) => t.id == task.id),
                orElse: () =>
                    (cubit.state as TasksBoardReady).board.columns.first,
              )
            : null;
        if (currentColumn == null) break;

        final ready = cubit.state;
        if (ready is! TasksBoardReady) break;
        final availableColumns = [
          for (final column in ready.board.columns)
            if (cubit.canMoveTaskTo(task: task, targetColumn: column) &&
                TaskBoardColumnIdentity.keyOf(column) !=
                    TaskBoardColumnIdentity.keyOf(currentColumn))
              column,
        ];
        if (availableColumns.isEmpty) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Brak dostępnych przejść statusu.')),
          );
          break;
        }
        final targetColumn = await AppContextMenu.select<KanbanColumnResponse>(
          context,
          globalPosition: menuPosition,
          options: [
            for (final column in availableColumns)
              AppContextMenuOption(
                value: column,
                label: column.displayName,
                icon: TaskStatusVisualHelper.icon(column.status),
                iconColor: TaskStatusVisualHelper.color(column.status),
              ),
          ],
        );
        if (!context.mounted || targetColumn == null) break;
        await cubit.moveTask(
          task: task,
          targetColumn: targetColumn,
          targetIndex: 0,
        );

      case _KanbanCardMenuAction.priority:
        await TaskPriorityPicker.show(
          context,
          selected: task.priority,
          position: globalPosition,
          onChanged: (newPriority) async {
            return cubit.updateTaskPriority(task.id, newPriority);
          },
        );

      case _KanbanCardMenuAction.assignee:
        final currentAssignees = task.primaryAssigneeUserId == null
            ? <TaskAssigneeResponse>[]
            : [
                TaskAssigneeResponse(
                  userId: task.primaryAssigneeUserId!,
                  isPrimary: true,
                  createdAtUtc: DateTime.now().toUtc(),
                ),
              ];
        await TaskAssigneePicker.show(
          context,
          assignees: currentAssignees,
          profiles: memberProfilesByUserId,
          position: menuPosition,
          onSave: (userIds) async {
            return cubit.replaceTaskAssignees(task.id, userIds);
          },
        );

      case _KanbanCardMenuAction.moveToPerson:
        final ready = cubit.state;
        if (ready is! TasksBoardReady || ready.assigneeBoard == null) break;
        final selection = await showKanbanMoveToPersonDialog(
          context,
          state: ready,
          taskId: task.id,
        );
        if (selection == null) break;
        unawaited(
          cubit.moveTaskToAssignee(
            task: task,
            targetUserId: selection.targetUserId,
          ),
        );

      case _KanbanCardMenuAction.dueDate:
        final pickResult = await TaskDatePicker.pick(
          context,
          initialValue: task.dueAtUtc?.toLocal(),
          globalPosition: globalPosition ?? Offset.zero,
        );
        if (pickResult != null) {
          await cubit.updateTaskDueDate(task.id, pickResult.value?.toUtc());
        }

      case _KanbanCardMenuAction.pin:
        await cubit.togglePinned(task);

      case _KanbanCardMenuAction.watch:
        await cubit.toggleWatching(task);
    }
  }
}

enum _KanbanCardMenuAction {
  open,
  copyCode,
  copyLink,
  status,
  priority,
  assignee,
  moveToPerson,
  dueDate,
  pin,
  watch,
}

final class TaskBoardColumnIdentity {
  const TaskBoardColumnIdentity._();

  static String keyOf(KanbanColumnResponse column) =>
      column.customStatusId ?? column.status.name;
}
