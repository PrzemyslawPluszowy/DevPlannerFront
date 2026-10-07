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
class _BulkSelectionToolbar extends StatefulWidget {
  const _BulkSelectionToolbar({
    required this.state,
    required this.isCompact,
    super.key,
  });

  final TasksBoardReady state;
  final bool isCompact;

  @override
  State<_BulkSelectionToolbar> createState() => _BulkSelectionToolbarState();
}

final class _BulkSelectionToolbarState extends State<_BulkSelectionToolbar> {
  final TasksBulkInteraction _dueDateInteraction = TasksBulkInteraction();
  TasksBoardReady get state => widget.state;

  Future<void> _pickDueDate() =>
      _dueDateInteraction.run(() => _BulkDueDateAction.pick(context));

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final count = state.selectedTaskIds.length;

    return TasksContextualBulkBar(
      selectedCount: count,
      isSaving: state.isBulkSaving,
      errorMessage: state.bulkError == null
          ? null
          : switch (state.bulkError!.code) {
              'tasks.bulk.kanban_selection_limit' =>
                context.l10n.tasksBulkKanbanLimit,
              'tasks.bulk.save_failed' => context.l10n.tasksBulkSaveFailed,
              _ =>
                tasksViewErrorText(context.l10n, state.bulkError!.code) ??
                    state.bulkError!.apiError?.message ??
                    state.bulkError!.code,
            },
      onRetry: state.canRetryBulk
          ? () =>
                unawaited(context.read<TasksBoardCubit>().retryBulkOperation())
          : null,
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
          onTap: state.isBulkSaving ? null : () => unawaited(_pickDueDate()),
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
    final initial = cubit.state;
    if (initial is! TasksBoardReady || initial.isBulkSaving) return;
    final scope = TasksBoardBulkDueScope.fromReady(initial);
    final choice = await TasksBulkDueDateDialog.show(
      context,
      currentValues: scope.values,
      hasCompleteClockScope: scope.isComplete,
      scopeLabel: context.l10n.tasksBulkSelected(
        initial.selectedTaskIds.length,
      ),
      calendarTimeZoneId: cubit.calendarTimeZoneId,
    );
    if (!context.mounted ||
        cubit.isClosed ||
        choice == null ||
        !identical(context.read<TasksBoardCubit>(), cubit)) {
      return;
    }
    final current = cubit.state;
    if (current is! TasksBoardReady ||
        current.isBulkSaving ||
        current.filter != initial.filter ||
        current.grouping != initial.grouping ||
        current.selectedTaskIds.length != initial.selectedTaskIds.length ||
        !current.selectedTaskIds.containsAll(initial.selectedTaskIds)) {
      return;
    }
    if (choice.value == null) {
      await cubit.bulkClearDueDate();
    } else {
      await cubit.bulkUpdateDueDate(choice.value!);
    }
  }
}
