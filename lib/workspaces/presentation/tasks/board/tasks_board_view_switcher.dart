part of 'tasks_board_page.dart';

/// Nawigacja widoków w jednej linii, w formie zakładek znanej z narzędzi PM.
class _TaskViewSwitcher extends StatelessWidget {
  const _TaskViewSwitcher({required this.view, required this.onChanged});

  final TasksProjectView view;
  final ValueChanged<TasksProjectView> onChanged;

  @override
  Widget build(BuildContext context) => DefaultTabController(
    key: ValueKey(view),
    initialIndex: TasksProjectView.values.indexOf(view),
    length: TasksProjectView.values.length,
    child: TabBar(
      isScrollable: true,
      tabAlignment: .start,
      dividerColor: Colors.transparent,
      indicatorSize: .label,
      labelPadding: const .symmetric(horizontal: 10),
      labelColor: context.colors.primary,
      unselectedLabelColor: context.colors.onSurfaceVariant,
      labelStyle: context.text.labelMedium?.copyWith(
        fontWeight: .w600,
        letterSpacing: -.1,
      ),
      unselectedLabelStyle: context.text.labelMedium?.copyWith(
        fontWeight: .w500,
      ),
      onTap: (index) => onChanged(TasksProjectView.values[index]),
      tabs: [
        _tab(context, Symbols.view_kanban, context.l10n.tasksViewBoard),
        _tab(context, Symbols.view_list, context.l10n.tasksViewList),
        _tab(context, Symbols.timeline, context.l10n.tasksViewTimeline),
        _tab(
          context,
          Symbols.people_alt,
          context.l10n.tasksViewWorkload,
        ),
        _tab(
          context,
          Symbols.repeat_rounded,
          context.l10n.tasksViewRecurrence,
        ),
      ],
    ),
  );

  Tab _tab(BuildContext context, IconData icon, String label) => Tab(
    iconMargin: const .only(right: 6),
    height: 32,
    child: Row(
      mainAxisSize: .min,
      children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
    ),
  );
}
