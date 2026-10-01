import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

class TaskDetailsConversationSlot extends StatelessWidget {
  const TaskDetailsConversationSlot({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.chat_bubble_outline_rounded,
              size: 28,
              color: context.colors.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.taskDetailsConversationUnavailable,
              textAlign: TextAlign.center,
              style: context.tasksTheme.dataText.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
