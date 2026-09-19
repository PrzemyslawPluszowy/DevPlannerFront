part of 'task_details_page.dart';

/// Pola typu zależności i przesunięcia harmonogramu, współdzielone przez dialogi.
class _DependencyScheduleFields extends StatelessWidget {
  const _DependencyScheduleFields({
    required this.kind,
    required this.lagController,
    required this.enabled,
    required this.onKindChanged,
  });

  final TaskDependencyKind kind;
  final TextEditingController lagController;
  final bool enabled;
  final ValueChanged<TaskDependencyKind> onKindChanged;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      DropdownButtonFormField<TaskDependencyKind>(
        initialValue: kind,
        decoration: InputDecoration(
          labelText: context.l10n.taskDetailsDependencyKind,
        ),
        items: [
          for (final value in TaskDependencyKind.values)
            DropdownMenuItem(
              value: value,
              child: Text(TaskDependencyLabeler.kind(context, value)),
            ),
        ],
        onChanged: enabled
            ? (value) {
                if (value != null) onKindChanged(value);
              }
            : null,
      ),
      const SizedBox(height: 12),
      TextField(
        controller: lagController,
        enabled: enabled,
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        decoration: InputDecoration(
          labelText: context.l10n.taskDetailsDependencyLagDays,
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
