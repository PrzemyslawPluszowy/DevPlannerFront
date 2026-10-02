import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

/// Przełącznik formularza szczegółów zadań ze wspólnymi tokenami desktop UI.
class TaskDetailsSwitchField extends StatelessWidget {
  const TaskDetailsSwitchField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    dense: true,
    activeThumbColor: context.colors.primary,
    activeTrackColor: context.colors.primaryContainer,
    inactiveTrackColor: context.colors.surfaceContainerHighest,
    title: Text(label, style: context.tasksTheme.controlText),
    value: value,
    onChanged: onChanged,
  );
}
