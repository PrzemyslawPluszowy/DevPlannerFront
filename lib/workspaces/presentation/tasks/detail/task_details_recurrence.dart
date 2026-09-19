part of 'task_details_page.dart';

class _TaskRecurrenceSection extends StatelessWidget {
  const _TaskRecurrenceSection({required this.task});

  final ProjectTaskResponse task;

  @override
  Widget build(BuildContext context) {
    final recurrence = task.recurrence;
    return _Section(
      title: context.l10n.taskDetailsRecurrence,
      action: TextButton.icon(
        onPressed: () =>
            unawaited(TaskRecurrenceDialogLauncher.show(context, task)),
        icon: const Icon(Symbols.repeat_rounded, size: 18),
        label: Text(context.l10n.taskDetailsConfigureRecurrence),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: recurrence == null
              ? Text(
                  context.l10n.taskDetailsRecurrenceNotConfigured,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                )
              : Row(
                  children: [
                    Icon(
                      recurrence.isActive
                          ? Symbols.repeat_rounded
                          : Symbols.pause_circle_outline_rounded,
                      color: recurrence.isActive
                          ? context.colors.primary
                          : context.colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${TaskRecurrenceFrequencyLabeler.label(context, recurrence.frequency)} '
                        '· ${context.l10n.taskDetailsRecurrenceEvery(recurrence.interval)}',
                      ),
                    ),
                    Text(
                      recurrence.isActive
                          ? context.l10n.taskDetailsRecurrenceActive
                          : context.l10n.taskDetailsRecurrencePaused,
                      style: context.text.labelMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Składa dialog cykliczności z zależnościami bieżącego szczegółu zadania.
///
/// Launcher nie przechowuje stanu i nie przenosi logiki zapisu poza Cubit.
final class TaskRecurrenceDialogLauncher {
  const TaskRecurrenceDialogLauncher._();

  static Future<void> show(BuildContext context, ProjectTaskResponse task) {
    final detailsCubit = context.read<TaskDetailsCubit>();
    final recurrenceRepository = context.read<TaskRecurrenceRepository>();
    return showDialog<void>(
      context: context,
      builder: (_) => BlocProvider(
        create: (_) {
          final cubit = TaskRecurrenceCubit(
            repository: recurrenceRepository,
            workspaceId: detailsCubit.workspaceId,
            projectId: detailsCubit.projectId,
            taskId: detailsCubit.taskId,
          );
          unawaited(cubit.load(hasRecurrence: task.recurrence != null));
          return cubit;
        },
        child: _TaskRecurrenceDialog(
          task: task,
          onChanged: detailsCubit.load,
        ),
      ),
    );
  }
}

class _TaskRecurrenceDialog extends StatelessWidget {
  const _TaskRecurrenceDialog({required this.task, required this.onChanged});

  final ProjectTaskResponse task;
  final Future<void> Function() onChanged;

  @override
  Widget build(BuildContext context) => Dialog(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 540, maxHeight: 700),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 18, 14, 18),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Symbols.repeat_rounded, color: context.colors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.taskDetailsRecurrence,
                    style: context.text.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.taskDetailsClose,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Symbols.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _TaskRecurrenceForm(task: task, onChanged: onChanged),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Tłumaczy częstotliwość cykliczności wyłącznie dla warstwy prezentacji.
final class TaskRecurrenceFrequencyLabeler {
  const TaskRecurrenceFrequencyLabeler._();

  static String label(
    BuildContext context,
    TaskRecurrenceFrequency frequency,
  ) => switch (frequency) {
    TaskRecurrenceFrequency.daily =>
      context.l10n.taskDetailsRecurrenceFrequencyDaily,
    TaskRecurrenceFrequency.weekly =>
      context.l10n.taskDetailsRecurrenceFrequencyWeekly,
    TaskRecurrenceFrequency.monthly =>
      context.l10n.taskDetailsRecurrenceFrequencyMonthly,
  };
}
