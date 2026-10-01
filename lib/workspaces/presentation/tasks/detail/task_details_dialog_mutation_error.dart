import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

/// Keeps a failed command visible in the editor that initiated it.
final class TaskDetailsDialogMutationError extends StatelessWidget {
  const TaskDetailsDialogMutationError({this.hideConflict = false, super.key});

  final bool hideConflict;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskDetailsCubit, TaskDetailsState>(
        builder: (context, state) {
          if (state is! TaskDetailsReady) return const SizedBox.shrink();
          if (state.mutationFailure case final error?
              when !hideConflict || error.type != ApiErrorType.conflict) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TaskDetailsModalError(error: error),
            );
          }
          if (state.mutationError case final message?) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
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
