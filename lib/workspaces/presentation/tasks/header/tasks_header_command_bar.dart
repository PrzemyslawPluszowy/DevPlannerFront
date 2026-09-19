part of 'tasks_board_page.dart';

/// Menu filtrowania Kanbanu.
class _KanbanQuickFilterMenu extends StatelessWidget {
  const _KanbanQuickFilterMenu({
    required this.state,
    this.compact = false,
  });

  final TasksBoardReady state;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final selected = state.userPreference?.quickFilter ?? KanbanQuickFilter.all;
    final isEnabled =
        state.userPreference != null && !state.savingUserPreference;
    final colors = context.colors;

    return Tooltip(
      message: context.l10n.tasksKanbanQuickFilter,
      child: Semantics(
        button: true,
        label: context.l10n.tasksKanbanQuickFilter,
        child: Material(
          color: colors.surfaceContainerLow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.p8),
            side: BorderSide(
              color: colors.outlineVariant.withValues(alpha: .6),
            ),
          ),
          child: Builder(
            builder: (buttonContext) => InkWell(
              onTap: isEnabled
                  ? () async {
                      final filter =
                          await TaskContextMenu.show<KanbanQuickFilter>(
                            context,
                            position: TaskContextMenu.positionFor(
                              buttonContext,
                            ),
                            items: [
                              for (final f in KanbanQuickFilter.values)
                                TaskContextMenuItem<KanbanQuickFilter>(
                                  value: f,
                                  title: _BoardHeaderHelpers.quickFilterLabel(
                                    context,
                                    f,
                                  ),
                                  icon: _BoardHeaderHelpers.quickFilterIcon(f),
                                  iconColor: f == KanbanQuickFilter.blocked
                                      ? colors.error
                                      : f == KanbanQuickFilter.dueSoon
                                      ? const Color(0xFFF59E0B)
                                      : null,
                                  isSelected: f == selected,
                                  trailing: f == selected
                                      ? Icon(
                                          Symbols.check_rounded,
                                          size: 16,
                                          color: colors.primary,
                                        )
                                      : null,
                                ),
                            ],
                          );
                      if (filter != null && context.mounted) {
                        unawaited(
                          context.read<TasksBoardCubit>().setQuickFilter(
                            filter,
                          ),
                        );
                      }
                    }
                  : null,
              borderRadius: BorderRadius.circular(Sizes.p8),
              hoverColor: colors.surfaceContainerHighest.withValues(alpha: .4),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? Sizes.p8 : Sizes.p10,
                    vertical: Sizes.p6,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _BoardHeaderHelpers.quickFilterIcon(selected),
                          size: Sizes.p16,
                          color: selected == KanbanQuickFilter.all
                              ? colors.onSurfaceVariant
                              : colors.primary,
                        ),
                        if (!compact) ...[
                          const SizedBox(width: Sizes.p6),
                          Text(
                            _BoardHeaderHelpers.quickFilterLabel(
                              context,
                              selected,
                            ),
                            style: context.text.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(width: Sizes.p4),
                          Icon(
                            Symbols.arrow_drop_down_rounded,
                            size: 18,
                            color: colors.onSurfaceVariant,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pasek z usuwalnym chipem aktywnego filtra.
class _ActiveFilterStrip extends StatelessWidget {
  const _ActiveFilterStrip({
    required this.filter,
    required this.onClear,
  });

  final KanbanQuickFilter filter;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Row(
      children: [
        Icon(
          Symbols.filter_alt_rounded,
          size: Sizes.p16,
          color: colors.onSurfaceVariant,
        ),
        const SizedBox(width: Sizes.p6),
        Text(
          'Aktywny filtr:',
          style: context.text.labelSmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: Sizes.p6),
        InputChip(
          label: Text(_BoardHeaderHelpers.quickFilterLabel(context, filter)),
          onDeleted: onClear,
          deleteIconColor: colors.onSecondaryContainer,
          backgroundColor: colors.secondaryContainer,
          labelStyle: context.text.labelSmall?.copyWith(
            color: colors.onSecondaryContainer,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p4),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const SizedBox(width: Sizes.p6),
        TextButton(
          onPressed: onClear,
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
          ),
          child: Text(
            l10n.tasksListClearValue,
            style: context.text.labelSmall?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

/// Pomocnicze wartości prezentacyjne nagłówka Kanbana.
class _BoardHeaderHelpers {
  const _BoardHeaderHelpers._();

  static IconData quickFilterIcon(KanbanQuickFilter filter) => switch (filter) {
    KanbanQuickFilter.all => Symbols.filter_list_rounded,
    KanbanQuickFilter.mine => Symbols.person_rounded,
    KanbanQuickFilter.unassigned => Symbols.person_off_rounded,
    KanbanQuickFilter.blocked => Symbols.block_rounded,
    KanbanQuickFilter.dueSoon => Symbols.schedule_rounded,
  };

  static Color boardPriorityColor(TaskPriority priority) => switch (priority) {
    TaskPriority.low => const Color(0xFF74B9FF),
    TaskPriority.normal => const Color(0xFF00B894),
    TaskPriority.high => const Color(0xFFFDAA2D),
    TaskPriority.critical => const Color(0xFFFF5252),
  };

  static String quickFilterLabel(
    BuildContext context,
    KanbanQuickFilter filter,
  ) => switch (filter) {
    KanbanQuickFilter.all => context.l10n.tasksKanbanQuickFilterAll,
    KanbanQuickFilter.mine => context.l10n.tasksKanbanQuickFilterMine,
    KanbanQuickFilter.unassigned =>
      context.l10n.tasksKanbanQuickFilterUnassigned,
    KanbanQuickFilter.blocked => context.l10n.tasksKanbanQuickFilterBlocked,
    KanbanQuickFilter.dueSoon => context.l10n.tasksKanbanQuickFilterDueSoon,
  };

  static String boardPriorityLabel(
    BuildContext context,
    TaskPriority priority,
  ) => switch (priority) {
    TaskPriority.low => context.l10n.tasksPriorityLow,
    TaskPriority.normal => context.l10n.tasksPriorityNormal,
    TaskPriority.high => context.l10n.tasksPriorityHigh,
    TaskPriority.critical => context.l10n.tasksPriorityCritical,
  };
}
