part of 'tasks_board_page.dart';

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
            final action = await TaskContextMenu.show<String>(
              context,
              position: TaskContextMenu.positionFor(buttonContext),
              items: [
                if (canManage)
                  TaskContextMenuItem<String>(
                    value: 'admin_settings',
                    icon: Symbols.admin_panel_settings_rounded,
                    title: l10n.tasksListAdminPanelButton,
                  ),
                TaskContextMenuItem<String>(
                  value: 'connection',
                  icon: Symbols.wifi_rounded,
                  iconColor: statusColor,
                  title: connected
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
    final colors = context.colors;
    final l10n = context.l10n;
    final count = state.selectedTaskIds.length;

    return Container(
      constraints: const BoxConstraints(minHeight: 44),
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p12,
        vertical: Sizes.p4,
      ),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(Sizes.p10),
        border: Border.all(color: colors.primary.withValues(alpha: .3)),
      ),
      child: Row(
        children: [
          Icon(
            Symbols.check_box_rounded,
            color: colors.onPrimaryContainer,
            size: Sizes.p20,
          ),
          const SizedBox(width: Sizes.p8),
          Text(
            l10n.tasksBulkSelected(count),
            style: context.text.labelLarge?.copyWith(
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: Sizes.p8),

          // Przewijane akcje masowe
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Akcja masowa: zmiana kolumny / statusu
                  Builder(
                    builder: (buttonContext) => _BulkActionButton(
                      icon: Symbols.drive_file_move_outline,
                      label: isCompact ? null : l10n.tasksBulkMove,
                      isLoading: state.isBulkSaving,
                      onTap: state.isBulkSaving
                          ? null
                          : () async {
                              final column =
                                  await TaskContextMenu.show<
                                    KanbanColumnResponse
                                  >(
                                    context,
                                    position: TaskContextMenu.positionFor(
                                      buttonContext,
                                    ),
                                    items: [
                                      for (final col in state.board.columns)
                                        TaskContextMenuItem<
                                          KanbanColumnResponse
                                        >(
                                          value: col,
                                          title: col.displayName,
                                          icon: Symbols.view_column_rounded,
                                        ),
                                    ],
                                  );
                              if (column != null && context.mounted) {
                                unawaited(
                                  context.read<TasksBoardCubit>().bulkMoveTasks(
                                    column,
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                  const SizedBox(width: Sizes.p6),

                  // Akcja masowa: zmiana priorytetu
                  Builder(
                    builder: (buttonContext) => _BulkActionButton(
                      icon: Symbols.flag,
                      label: isCompact ? null : l10n.tasksBulkPriority,
                      isLoading: state.isBulkSaving,
                      onTap: state.isBulkSaving
                          ? null
                          : () async {
                              final priority = await TaskContextMenu.show<TaskPriority>(
                                context,
                                position: TaskContextMenu.positionFor(
                                  buttonContext,
                                ),
                                items: [
                                  for (final priority in TaskPriority.values)
                                    TaskContextMenuItem<TaskPriority>(
                                      value: priority,
                                      title:
                                          _BoardHeaderHelpers.boardPriorityLabel(
                                            context,
                                            priority,
                                          ),
                                      icon: Symbols.flag_rounded,
                                      iconColor:
                                          _BoardHeaderHelpers.boardPriorityColor(
                                            priority,
                                          ),
                                    ),
                                ],
                              );
                              if (priority != null && context.mounted) {
                                unawaited(
                                  context
                                      .read<TasksBoardCubit>()
                                      .bulkUpdatePriority(priority),
                                );
                              }
                            },
                    ),
                  ),
                  const SizedBox(width: Sizes.p6),

                  // Akcja masowa: zmiana terminu
                  _BulkActionButton(
                    icon: Symbols.event,
                    label: isCompact ? null : l10n.tasksBulkDueDate,
                    onTap: state.isBulkSaving
                        ? null
                        : () => _BulkDueDateAction.pick(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: Sizes.p6),

          // Odznaczenie wszystkich
          IconButton(
            tooltip: l10n.tasksBulkClearSelection,
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
            onPressed: state.isBulkSaving
                ? null
                : () => context.read<TasksBoardCubit?>()?.clearTaskSelection(),
            icon: Icon(
              Symbols.close_rounded,
              color: colors.onPrimaryContainer,
              size: Sizes.p20,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulkActionButton extends StatelessWidget {
  const _BulkActionButton({
    required this.icon,
    this.label,
    this.onTap,
    this.isLoading = false,
  });

  final IconData icon;
  final String? label;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Sizes.p8),
        child: Container(
          constraints: const BoxConstraints(minHeight: 38, minWidth: 44),
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p10,
            vertical: Sizes.p6,
          ),
          decoration: BoxDecoration(
            color: colors.surface.withValues(alpha: .75),
            borderRadius: BorderRadius.circular(Sizes.p8),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: .5),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(icon, size: Sizes.p18, color: colors.onSurface),
              if (label != null) ...[
                const SizedBox(width: Sizes.p6),
                Text(
                  label!,
                  style: context.text.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
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
