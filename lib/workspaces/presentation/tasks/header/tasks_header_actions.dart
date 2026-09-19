part of 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';

/// Zwarte menu Więcej w nagłówku zbierające panel administracyjny i status realtime.
class _HeaderMoreMenu extends StatelessWidget {
  const _HeaderMoreMenu({
    required this.state,
    required this.canManage,
    required this.onOpenProjectSettings,
  });

  final TasksBoardReady state;
  final bool canManage;
  final VoidCallback onOpenProjectSettings;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final connected =
        state.connectionState == WorkspaceSignalRConnectionState.connected;
    final connecting =
        state.connectionState == WorkspaceSignalRConnectionState.connecting ||
        state.connectionState == WorkspaceSignalRConnectionState.reconnecting;
    final statusColor = connected
        ? const Color(0xFF00A884)
        : connecting
        ? const Color(0xFFF59E0B)
        : colors.error;

    return Builder(
      builder: (buttonContext) => Tooltip(
        message: l10n.tasksListMoreOptionsTooltip,
        child: InkWell(
          key: const ValueKey('header_more_menu'),
          onTap: () async {
            final action = await AppContextMenu.select<String>(
              context,
              globalPosition: AppContextMenu.positionFor(buttonContext),
              options: [
                if (canManage)
                  AppContextMenuOption(
                    value: 'admin_settings',
                    icon: Symbols.admin_panel_settings_rounded,
                    label: l10n.tasksListAdminPanelButton,
                  ),
                AppContextMenuOption(
                  value: 'connection',
                  icon: Symbols.wifi_rounded,
                  iconColor: statusColor,
                  label: connected
                      ? l10n.tasksRealtimeConnected
                      : connecting
                      ? l10n.tasksRealtimeConnecting
                      : l10n.tasksRealtimeOffline,
                ),
              ],
            );
            if (action == 'admin_settings') onOpenProjectSettings();
          },
          borderRadius: .circular(Sizes.p8),
          hoverColor: colors.surfaceContainerHighest.withValues(alpha: .4),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            child: Center(
              child: Container(
                height: 32,
                padding: EdgeInsets.symmetric(
                  horizontal: !connected ? Sizes.p6 : Sizes.p8,
                ),
                decoration: BoxDecoration(
                  borderRadius: .circular(Sizes.p8),
                  border: .all(
                    color: colors.outlineVariant.withValues(alpha: .5),
                  ),
                ),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      Symbols.more_horiz_rounded,
                      size: 18,
                      color: colors.onSurfaceVariant,
                    ),
                    if (!connected) ...[
                      const SizedBox(width: Sizes.p4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: .circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Kontekstowy pasek akcji masowych, zastępujący Rząd 2 po zaznaczeniu zadań.
class _BulkSelectionToolbar extends StatelessWidget {
  const _BulkSelectionToolbar({
    required this.state,
    required this.isCompact,
    super.key,
  });

  final TasksBoardReady state;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final count = state.selectedTaskIds.length;

    return TasksContextualBulkBar(
      selectedCount: count,
      onClearSelection: () =>
          context.read<TasksBoardCubit?>()?.clearTaskSelection(),
      controls: [
        TasksBulkMenu<KanbanColumnResponse>(
          key: const ValueKey('board_bulk_move'),
          icon: Symbols.drive_file_move_outline,
          label: l10n.tasksBulkMove,
          isLoading: state.isBulkSaving,
          options: [
            for (final column in state.board.columns)
              AppContextMenuOption<KanbanColumnResponse>(
                value: column,
                label: column.displayName,
                icon: Symbols.view_column_rounded,
              ),
          ],
          onSelected: (column) => unawaited(
            context.read<TasksBoardCubit>().bulkMoveTasks(column),
          ),
        ),
        TasksBulkMenu<TaskPriority>(
          key: const ValueKey('board_bulk_priority'),
          icon: Symbols.flag,
          label: l10n.tasksBulkPriority,
          isLoading: state.isBulkSaving,
          options: [
            for (final priority in TaskPriority.values)
              AppContextMenuOption<TaskPriority>(
                value: priority,
                label: _TasksHeaderHelpers.boardPriorityLabel(
                  context,
                  priority,
                ),
                icon: Symbols.flag_rounded,
                iconColor: _TasksHeaderHelpers.boardPriorityColor(priority),
              ),
          ],
          onSelected: (priority) => unawaited(
            context.read<TasksBoardCubit>().bulkUpdatePriority(priority),
          ),
        ),
        TasksBulkButton(
          key: const ValueKey('board_bulk_due_date'),
          icon: Symbols.event,
          label: l10n.tasksBulkDueDate,
          onTap: state.isBulkSaving
              ? null
              : () => _BulkDueDateAction.pick(context),
        ),
      ],
    );
  }
}

/// Operacja biznesowa wyboru terminu dla akcji masowych.
class _BulkDueDateAction {
  const _BulkDueDateAction._();

  static Future<void> pick(BuildContext context) async {
    final cubit = context.read<TasksBoardCubit>();
    final selected = await DevPlannerModalPickerHost.showDate(
      context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (selected == null) return;
    await cubit.bulkUpdateDueDate(selected);
  }
}
