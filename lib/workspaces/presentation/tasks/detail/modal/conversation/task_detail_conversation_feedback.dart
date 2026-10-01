import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_error.dart';
import 'package:flutter/material.dart';

/// Pełny błąd resolvera rozmowy z widocznym, jawnym ponowieniem odczytu.
final class TaskDetailConversationFeedback extends StatelessWidget {
  const TaskDetailConversationFeedback({
    required this.error,
    required this.onRetry,
    super.key,
  });
  final ApiError? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final tasks = context.tasksTheme;
      final height = constraints.hasBoundedHeight
          ? constraints.maxHeight
          : MediaQuery.sizeOf(context).height;
      return Center(
        child: Padding(
          padding: EdgeInsets.all(tasks.controlGap),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.chatConversationLoadFailureMessage,
                textAlign: TextAlign.center,
                style: tasks.controlText,
              ),
              if (error case final error?) ...[
                SizedBox(height: tasks.controlGap),
                Flexible(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: (height * .5).clamp(80.0, 240.0),
                    ),
                    child: SingleChildScrollView(
                      child: TaskDetailsModalError(error: error),
                    ),
                  ),
                ),
              ],
              SizedBox(height: tasks.controlGap),
              TextButton(
                key: const ValueKey('task_conversation_resolve_retry'),
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: context.colors.onSurface,
                  textStyle: tasks.controlText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(tasks.controlRadius),
                  ),
                ),
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
      );
    },
  );
}
