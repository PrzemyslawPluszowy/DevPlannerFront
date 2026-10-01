import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_tabs.dart';
import 'package:flutter/material.dart';

/// Lazily mounts each detail section once, then keeps its editor state alive.
final class TaskDetailsVisitedTabStack extends StatefulWidget {
  const TaskDetailsVisitedTabStack({
    required this.selected,
    required this.children,
    super.key,
  });

  final TaskDetailsModalTab selected;
  final Map<TaskDetailsModalTab, Widget> children;

  @override
  State<TaskDetailsVisitedTabStack> createState() =>
      _TaskDetailsVisitedTabStackState();
}

final class _TaskDetailsVisitedTabStackState
    extends State<TaskDetailsVisitedTabStack> {
  late final Set<TaskDetailsModalTab> _visited = {widget.selected};

  @override
  void didUpdateWidget(covariant TaskDetailsVisitedTabStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selected != widget.selected) {
      _visited.add(widget.selected);
    }
  }

  @override
  Widget build(BuildContext context) => IndexedStack(
    index: widget.selected.index,
    children: [
      for (final tab in TaskDetailsModalTab.values)
        if (_visited.contains(tab))
          widget.children[tab] ?? const SizedBox.shrink()
        else
          const SizedBox.shrink(),
    ],
  );
}
