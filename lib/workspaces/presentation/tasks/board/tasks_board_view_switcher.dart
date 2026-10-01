import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/tasks_project_view_contract.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Desktopowy pasek kart do przełączania widoków zadań.
class TasksBoardViewSwitcher extends StatelessWidget {
  const TasksBoardViewSwitcher({
    required this.view,
    required this.onChanged,
    super.key,
  });

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
        TaskProjectViewTab(
          icon: Symbols.view_kanban,
          label: context.l10n.tasksViewBoard,
        ),
        TaskProjectViewTab(
          icon: Symbols.view_list,
          label: context.l10n.tasksViewList,
        ),
        TaskProjectViewTab(
          icon: Symbols.timeline,
          label: context.l10n.tasksViewTimeline,
        ),
        TaskProjectViewTab(
          icon: Symbols.people_alt,
          label: context.l10n.tasksViewWorkload,
        ),
        TaskProjectViewTab(
          icon: Symbols.repeat_rounded,
          label: context.l10n.tasksViewRecurrence,
        ),
      ],
    ),
  );
}

/// Pojedyncza zwarta karta w pasku widoków zadań.
class TaskProjectViewTab extends StatelessWidget {
  const TaskProjectViewTab({
    required this.icon,
    required this.label,
    super.key,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Tab(
    iconMargin: const .only(right: 6),
    height: 32,
    child: Row(
      mainAxisSize: .min,
      children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
    ),
  );
}
