import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/navigation/task_detail_open_intent.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

/// Opens the parent through the same modal navigation and draft guards.
final class TaskParentNavigationLink extends StatelessWidget {
  const TaskParentNavigationLink({
    required this.workspaceId,
    required this.projectId,
    required this.parentTaskId,
    required this.enabled,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final String parentTaskId;
  final bool enabled;

  void _openParent(BuildContext context) {
    final navigation = DevPlannerNavigation.of(context);
    unawaited(
      navigation.goToTask(
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: parentTaskId,
        currentLocation: Uri.parse(navigation.currentPath),
        source: TaskDetailOpenSource.subtask,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: enabled ? () => _openParent(context) : null,
    icon: const Icon(Symbols.subdirectory_arrow_left_rounded, size: 16),
    label: Text(context.l10n.taskDetailsParentTask),
  );
}
