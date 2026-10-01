import 'package:flutter/material.dart';

/// Captures the root route after mounting without doing work in a builder.
final class TaskDetailModalRouteTracker extends StatefulWidget {
  const TaskDetailModalRouteTracker({
    required this.taskId,
    required this.generation,
    required this.onRouteMounted,
    required this.child,
    super.key,
  });

  final String taskId;
  final int generation;
  final void Function(ModalRoute<dynamic>?, String, int) onRouteMounted;
  final Widget child;

  @override
  State<TaskDetailModalRouteTracker> createState() =>
      _TaskDetailModalRouteTrackerState();
}

final class _TaskDetailModalRouteTrackerState
    extends State<TaskDetailModalRouteTracker> {
  bool _scheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_scheduled) return;
    _scheduled = true;
    final route = ModalRoute.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onRouteMounted(route, widget.taskId, widget.generation);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
