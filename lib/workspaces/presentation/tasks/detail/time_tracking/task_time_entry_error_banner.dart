import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

class TaskTimeEntryErrorBanner extends StatelessWidget {
  const TaskTimeEntryErrorBanner({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskTimeTrackingCubit, TaskTimeTrackingState>(
        builder: (context, state) {
          final failure = switch (state) {
            TaskTimeTrackingReady(:final error, :final apiError) => (
              message: error,
              apiError: apiError,
            ),
            TaskTimeTrackingFailure(:final message, :final apiError) => (
              message: message,
              apiError: apiError,
            ),
            TaskTimeTrackingLoading() => null,
          };
          if (failure == null) return const SizedBox.shrink();
          if (failure.apiError case final apiError?) {
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: TaskDetailsModalError(
                error: apiError,
                fallbackMessage: context.l10n.taskDetailsTimeOperationFailed,
              ),
            );
          }
          if (failure.message case final message?) {
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                message,
                style: TextStyle(color: context.colors.error),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      );
}
