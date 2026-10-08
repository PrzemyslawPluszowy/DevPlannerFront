import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

/// Pola typu zależności i przesunięcia harmonogramu, współdzielone przez dialogi.
class DependencyScheduleFields extends StatelessWidget {
  const DependencyScheduleFields({
    required this.kind,
    required this.lagController,
    required this.enabled,
    required this.onKindChanged,
    this.lagError,
    super.key,
  });

  final TaskDependencyKind kind;
  final TextEditingController lagController;
  final bool enabled;
  final ValueChanged<TaskDependencyKind> onKindChanged;
  final String? lagError;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      TaskDetailsSelectField<TaskDependencyKind>(
        label: context.l10n.taskDetailsDependencyKind,
        value: kind,
        enabled: enabled,
        options: [
          for (final value in TaskDependencyKind.values)
            TaskDetailsSelectOption(
              value: value,
              label: TaskDependencyLabeler.kind(context, value),
            ),
        ],
        onChanged: onKindChanged,
      ),
      const SizedBox(height: 12),
      TextField(
        controller: lagController,
        enabled: enabled,
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        decoration: InputDecoration(
          labelText: context.l10n.taskDetailsDependencyLagDays,
          helperText: context.l10n.taskDetailsDependencyLagHint,
          helperMaxLines: 4,
          errorText: lagError,
        ),
      ),
    ],
  );
}

/// Lokalizuje rodzaj zależności w formularzach szczegółu zadania.
final class TaskDependencyLabeler {
  const TaskDependencyLabeler._();

  static String kind(BuildContext context, TaskDependencyKind value) =>
      switch (value) {
        TaskDependencyKind.finishToStart =>
          context.l10n.taskDependencyKindFinishToStart,
        TaskDependencyKind.startToStart =>
          context.l10n.taskDependencyKindStartToStart,
        TaskDependencyKind.finishToFinish =>
          context.l10n.taskDependencyKindFinishToFinish,
        TaskDependencyKind.startToFinish =>
          context.l10n.taskDependencyKindStartToFinish,
      };
}
