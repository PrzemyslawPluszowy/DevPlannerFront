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
    required Map<String, ProjectMemberProfile> memberProfilesByCoreUserId,
    Offset? globalPosition,
  }) async {
    final cubit = context.read<TasksBoardCubit>();
    final colors = context.colors;
    final l10n = context.l10n;

    final overlay = Navigator.of(context, rootNavigator: true).overlay;
    final overlayBox = overlay?.context.findRenderObject() as RenderBox?;
    if (overlayBox == null) return;

    final RelativeRect position;
    if (globalPosition != null) {
      final rect = Rect.fromCenter(
        center: globalPosition,
        width: 0,
        height: 0,
      );
      position = RelativeRect.fromRect(rect, Offset.zero & overlayBox.size);
    } else {
      position = TaskContextMenu.positionFor(context);
    }

    final selectedAction = await TaskContextMenu.show<_KanbanCardMenuAction>(
      context,
      position: position,
      items: [
        TaskContextMenuItem<_KanbanCardMenuAction>(
          value: _KanbanCardMenuAction.open,
          title: l10n.tasksContextMenuOpen,
          icon: Symbols.open_in_new_rounded,
        ),
        TaskContextMenuItem<_KanbanCardMenuAction>(
          value: _KanbanCardMenuAction.copyCode,
          title: l10n.tasksContextMenuCopyCode,
          icon: Symbols.content_copy_rounded,
        ),
        TaskContextMenuItem<_KanbanCardMenuAction>(
          value: _KanbanCardMenuAction.copyLink,
          title: l10n.tasksContextMenuCopyLink,
          icon: Symbols.link_rounded,
        ),
        const PopupMenuDivider(height: 8),
        TaskContextMenuItem<_KanbanCardMenuAction>(
          value: _KanbanCardMenuAction.status,
          title: l10n.tasksContextMenuStatus,
          icon: Symbols.flowsheet_rounded,
        ),
        TaskContextMenuItem<_KanbanCardMenuAction>(
          value: _KanbanCardMenuAction.priority,
          title: l10n.tasksContextMenuPriority,
          icon: Symbols.flag_rounded,
        ),
        TaskContextMenuItem<_KanbanCardMenuAction>(
          value: _KanbanCardMenuAction.assignee,
          title: l10n.tasksContextMenuAssignee,
          icon: Symbols.person_rounded,
        ),
        TaskContextMenuItem<_KanbanCardMenuAction>(
          value: _KanbanCardMenuAction.dueDate,
          title: l10n.tasksContextMenuDueDate,
          icon: Symbols.event_rounded,
        ),
        const PopupMenuDivider(height: 8),
        TaskContextMenuItem<_KanbanCardMenuAction>(
          value: _KanbanCardMenuAction.pin,
          title: task.isPinned ? l10n.tasksUnpinTask : l10n.tasksPinTask,
          icon: task.isPinned ? Symbols.push_pin_rounded : Symbols.push_pin,
          iconColor: task.isPinned ? colors.primary : null,
        ),
        TaskContextMenuItem<_KanbanCardMenuAction>(
          value: _KanbanCardMenuAction.watch,
          title: task.isWatchedByMe
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
        unawaited(
          context.router.navigatePath(
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
                _kanbanColumnKey(column) != _kanbanColumnKey(currentColumn))
              column,
        ];
        if (availableColumns.isEmpty) {
          scaffoldMessenger.showSnackBar(
            const SnackBar(content: Text('Brak dostępnych przejść statusu.')),
          );
          break;
        }
        final targetColumn = await TaskContextMenu.show<KanbanColumnResponse>(
          context,
          position: position,
          items: [
            for (final column in availableColumns)
              TaskContextMenuItem<KanbanColumnResponse>(
                value: column,
                title: column.displayName,
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
        final currentAssignees = task.primaryAssigneeCoreUserId == null
            ? <TaskAssigneeResponse>[]
            : [
                TaskAssigneeResponse(
                  coreUserId: task.primaryAssigneeCoreUserId!,
                  isPrimary: true,
                  createdAtUtc: DateTime.now().toUtc(),
                ),
              ];
        await showTaskAssigneeEditor(
          context,
          assignees: currentAssignees,
          profiles: memberProfilesByCoreUserId,
          menuPosition: position,
          onSave: (coreUserIds) async {
            return cubit.replaceTaskAssignees(task.id, coreUserIds);
          },
        );

      case _KanbanCardMenuAction.dueDate:
        final pickResult = await pickAnchoredDate(
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
  dueDate,
  pin,
  watch,
}

String _kanbanColumnKey(KanbanColumnResponse column) =>
    column.customStatusId ?? column.status.name;
