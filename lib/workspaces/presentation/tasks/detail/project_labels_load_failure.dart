import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

class ProjectLabelsLoadFailure extends StatelessWidget {
  const ProjectLabelsLoadFailure({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final ApiError error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        context.l10n.taskDetailsProjectLabelsLoadFailed,
        style: context.tasksTheme.dataStrongText,
      ),
      const SizedBox(height: 6),
      TaskDetailsModalError(error: error),
      Align(
        alignment: Alignment.centerRight,
        child: TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Symbols.refresh_rounded),
          label: Text(context.l10n.retry),
        ),
      ),
    ],
  );
}
