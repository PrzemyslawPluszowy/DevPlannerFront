import 'package:devplanner/workspaces/presentation/tasks/views/cubit/task_saved_views_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Pokazuje komunikaty powodzenia i błędów emitowane przez Cubit zapisanych widoków.
class TaskSavedViewsFeedbackListener extends StatelessWidget {
  const TaskSavedViewsFeedbackListener({
    required this.cubit,
    required this.child,
    super.key,
  });

  final TaskSavedViewsCubit cubit;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      BlocListener<TaskSavedViewsCubit, TaskSavedViewsState>(
        listenWhen: (previous, current) =>
            current is TaskSavedViewsReady &&
            (current.error != null ||
                (previous is TaskSavedViewsReady &&
                    current.successSerial > previous.successSerial)),
        listener: (context, state) {
          if (state is! TaskSavedViewsReady) return;
          final messenger = ScaffoldMessenger.of(context);
          if (state.error != null) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.error!),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            cubit.clearError();
            return;
          }
          if (state.successMessage != null) {
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.successMessage!)));
          }
        },
        child: child,
      );
}
