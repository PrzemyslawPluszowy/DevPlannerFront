part of 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';

/// Filtry tablicy Kanban: wykonawca, priorytet i „Wyczyść wszystko”.
///
/// Kontrolki wysyłają filtr do Backendu razem z odczytem tablicy, więc liczniki
/// kolumn i WIP opisują dokładnie te karty, które widać. Klawisze korzystają ze
/// wspólnego komponentu wiersza poleceń, żeby Lista i Kanban miały jeden język
/// kontrolek.
class _KanbanBoardFilters extends StatelessWidget {
  const _KanbanBoardFilters({required this.state, this.compact = false});

  final TasksBoardReady state;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final tasksTheme = context.tasksTheme;
    final filter = state.filter;
    final profiles = state.memberProfilesByUserId.values.toList()
      ..sort(
        (first, second) => (first.displayName ?? first.userId).compareTo(
          second.displayName ?? second.userId,
        ),
      );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TasksCommandMenu(
          key: const ValueKey('board_filter_priority'),
          icon: Symbols.flag,
          label: context.l10n.tasksListPriority,
          activeLabel: filter.priority == null
              ? null
              : _TasksHeaderHelpers.boardPriorityLabel(
                  context,
                  filter.priority!,
                ),
          options: [
            AppContextMenuOption<String>(
              value: _KanbanBoardFiltersHelpers.all,
              label: context.l10n.tasksListAll,
              selected: filter.priority == null,
            ),
            for (final priority in TaskPriority.values)
              AppContextMenuOption<String>(
                value: priority.name,
                label: _TasksHeaderHelpers.boardPriorityLabel(
                  context,
                  priority,
                ),
                icon: Symbols.flag,
                iconColor: _TasksHeaderHelpers.boardPriorityColor(priority),
                selected: filter.priority == priority,
              ),
          ],
          onSelected: (value) => unawaited(
            context.read<TasksBoardCubit>().setFilterPriority(
              _KanbanBoardFiltersHelpers.priorityOf(value),
            ),
          ),
        ),
        SizedBox(width: tasksTheme.controlGap),
        TasksCommandMenu(
          key: const ValueKey('board_filter_assignee'),
          icon: Symbols.people_alt,
          label: context.l10n.tasksBoardFilterAssignee,
          activeLabel: filter.assigneeUserId == null
              ? null
              : _KanbanBoardFiltersHelpers.profileName(
                  state.memberProfilesByUserId[filter.assigneeUserId],
                ),
          leading: _KanbanBoardFiltersHelpers.avatar(
            context,
            state.memberProfilesByUserId[filter.assigneeUserId],
          ),
          options: [
            AppContextMenuOption<String>(
              value: _KanbanBoardFiltersHelpers.all,
              label: context.l10n.tasksBoardFilterAllPeople,
              icon: Symbols.groups_rounded,
              selected: filter.assigneeUserId == null,
            ),
            for (final profile in profiles)
              AppContextMenuOption<String>(
                value: profile.userId,
                label: _KanbanBoardFiltersHelpers.profileName(profile),
                selected: filter.assigneeUserId == profile.userId,
              ),
          ],
          onSelected: (value) => unawaited(
            context.read<TasksBoardCubit>().setFilterAssignee(
              value == _KanbanBoardFiltersHelpers.all ? null : value,
            ),
          ),
        ),
        if (filter.isActive) ...[
          SizedBox(width: tasksTheme.controlGap),
          TasksCommandButton(
            key: const ValueKey('board_filter_clear'),
            icon: Symbols.filter_alt_off_rounded,
            label: context.l10n.tasksListClearAllFilters,
            onTap: () =>
                unawaited(context.read<TasksBoardCubit>().clearFilters()),
          ),
        ],
      ],
    );
  }
}

/// Wartości pomocnicze filtrów tablicy.
class _KanbanBoardFiltersHelpers {
  const _KanbanBoardFiltersHelpers._();

  /// Znacznik pozycji „wszystkie”; `select` zwraca `null` także po zamknięciu
  /// menu bez wyboru, więc potrzebujemy własnej wartości.
  static const String all = '__tasks_board_filter_all__';

  static TaskPriority? priorityOf(String value) {
    if (value == all) return null;
    for (final priority in TaskPriority.values) {
      if (priority.name == value) return priority;
    }
    return null;
  }

  static String profileName(ProjectMemberProfile? profile) {
    final displayName = profile?.displayName?.trim();
    return displayName?.isNotEmpty == true
        ? displayName!
        : profile?.userId ?? '';
  }

  static Widget? avatar(BuildContext context, ProjectMemberProfile? profile) {
    final name = profileName(profile);
    if (name.isEmpty) return null;
    return CircleAvatar(
      radius: 9,
      foregroundImage: profile?.avatarUrl?.trim().isNotEmpty == true
          ? NetworkImage(profile!.avatarUrl!.trim())
          : null,
      child: profile?.avatarUrl?.trim().isNotEmpty == true
          ? null
          : Text(
              name.characters.first.toUpperCase(),
              style: context.tasksTheme.metaText.copyWith(height: 1),
            ),
    );
  }
}
