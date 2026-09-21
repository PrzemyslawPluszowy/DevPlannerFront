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
        // W grupowaniu po osobach status jest filtrem kart: kolumnę opisuje
        // osoba, więc „pokaż tylko to, co jest w toku” zawęża karty w każdej
        // kolumnie. W widoku statusów ten wymiar jest zbędny — kolumna sama
        // jest statusem, a jej wybór należy do nagłówka kolumny.
        if (state.grouping == TasksBoardGrouping.assignee) ...[
          SizedBox(width: tasksTheme.controlGap),
          TasksCommandMenu(
            key: const ValueKey('board_filter_status'),
            icon: Symbols.view_column_rounded,
            label: context.l10n.tasksListStatus,
            activeLabel: _KanbanBoardFiltersHelpers.statusLabel(context, state),
            options: [
              AppContextMenuOption<String>(
                value: _KanbanBoardFiltersHelpers.all,
                label: context.l10n.tasksListAll,
                selected:
                    filter.status == null && filter.customStatusId == null,
              ),
              for (final column in state.board.columns)
                AppContextMenuOption<String>(
                  value: column.customStatusId ?? column.status.wireValue,
                  label: column.displayName,
                  icon: Symbols.view_column_rounded,
                  selected: column.customStatusId != null
                      ? filter.customStatusId == column.customStatusId
                      : filter.status == column.status,
                ),
            ],
            onSelected: (value) {
              final cubit = context.read<TasksBoardCubit>();
              // Jeden wymiar, jedna operacja: „wszystkie” i wybór kolumny idą
              // tą samą drogą, więc nie ma stanu pośredniego z dwoma filtrami.
              if (value == _KanbanBoardFiltersHelpers.all) {
                unawaited(cubit.setFilterStatusColumn());
                return;
              }
              final isCustom = state.board.columns.any(
                (column) => column.customStatusId == value,
              );
              unawaited(
                cubit.setFilterStatusColumn(
                  customStatusId: isCustom ? value : null,
                  status: isCustom
                      ? null
                      : _KanbanBoardFiltersHelpers.statusOf(value),
                ),
              );
            },
          ),
        ],
        // W grupowaniu po osobach nie ma filtra wykonawcy: osoba jest tam
        // kolumną, więc jej zawężanie ucinałoby zawartość kolumny w miejscu,
        // w którym użytkownik oczekuje ukrycia całej kolumny.
        if (state.grouping != TasksBoardGrouping.assignee) ...[
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
        ],
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

  /// Nazwa aktywnego filtra statusu; `null`, gdy wymiar nie jest ustawiony.
  static String? statusLabel(BuildContext context, TasksBoardReady state) {
    final customId = state.filter.customStatusId;
    if (customId != null) {
      return state.board.columns
          .where((column) => column.customStatusId == customId)
          .map((column) => column.displayName)
          .firstOrNull;
    }
    final status = state.filter.status;
    if (status == null) return null;
    return state.board.columns
            .where((column) => column.status == status)
            .map((column) => column.displayName)
            .firstOrNull ??
        status.wireValue;
  }

  /// Status systemowy zapisany w wartości pozycji menu.
  static ProjectTaskStatus? statusOf(String value) {
    for (final status in ProjectTaskStatus.values) {
      if (status.wireValue == value) return status;
    }
    return null;
  }

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
