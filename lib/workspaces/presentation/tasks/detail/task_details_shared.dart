part of 'task_details_page.dart';

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.format,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final DateFormat format;
  final bool enabled;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) => InputDecorator(
    decoration: InputDecoration(labelText: label),
    child: Row(
      children: [
        Expanded(
          child: Text(
            value == null
                ? context.l10n.taskDetailsNoDate
                : format.format(value!.toLocal()),
          ),
        ),
        if (value != null)
          IconButton(
            tooltip: context.l10n.taskDetailsClearDate,
            onPressed: enabled ? () => onChanged(null) : null,
            icon: const Icon(Symbols.clear_rounded, size: 18),
          ),
        IconButton(
          tooltip: label,
          onPressed: enabled ? () => _pick(context) : null,
          icon: const Icon(Symbols.calendar_month, size: 19),
        ),
      ],
    ),
  );

  Future<void> _pick(BuildContext context) async {
    final localValue = value?.toLocal();
    final selected = await DevPlannerModalPickerHost.showDate(
      context,
      initialDate: localValue ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected == null) return;
    final local = DateTime(
      selected.year,
      selected.month,
      selected.day,
      localValue?.hour ?? 0,
      localValue?.minute ?? 0,
    );
    onChanged(local.toUtc());
  }
}

class _PropertyRow extends StatelessWidget {
  const _PropertyRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Row(
            children: [
              Icon(icon, size: 18, color: context.colors.onSurfaceVariant),
              const SizedBox(width: 10),
              SizedBox(
                width: 112,
                child: Text(label, style: context.text.bodySmall),
              ),
              Expanded(child: Text(value, style: context.text.bodyMedium)),
            ],
          ),
        ),
      ),
      if (showDivider) Divider(height: 1, color: context.colors.outlineVariant),
    ],
  );
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: context.colors.surface.withValues(alpha: .8),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: context.colors.outlineVariant),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [Icon(icon, size: 15), const SizedBox(width: 6), Text(label)],
    ),
  );
}

class _TaskDetailsLoading extends StatelessWidget {
  const _TaskDetailsLoading();

  @override
  Widget build(BuildContext context) => const Center(
    child: SizedBox.square(
      dimension: 28,
      child: CircularProgressIndicator(strokeWidth: 2.5),
    ),
  );
}

class _TaskDetailsFailureView extends StatelessWidget {
  const _TaskDetailsFailureView({required this.failure});

  final TaskDetailsFailure failure;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Symbols.error_outline_rounded,
            size: 42,
            color: context.colors.error,
          ),
          const SizedBox(height: 14),
          Text(failure.message, textAlign: TextAlign.center),
          const SizedBox(height: 18),
          FilledButton.tonalIcon(
            onPressed: () => unawaited(context.read<TaskDetailsCubit>().load()),
            icon: const Icon(Symbols.refresh_rounded),
            label: Text(context.l10n.retry),
          ),
        ],
      ),
    ),
  );
}

/// Lokalizowane etykiety statusu i priorytetu szczegółów zadania.
final class TaskDetailsLabeler {
  const TaskDetailsLabeler._();

  static String status(BuildContext context, ProjectTaskStatus value) =>
      switch (value) {
        ProjectTaskStatus.backlog => context.l10n.taskStatusBacklog,
        ProjectTaskStatus.todo => context.l10n.taskStatusTodo,
        ProjectTaskStatus.inProgress => context.l10n.taskStatusInProgress,
        ProjectTaskStatus.blocked => context.l10n.taskStatusBlocked,
        ProjectTaskStatus.done => context.l10n.taskStatusDone,
        ProjectTaskStatus.cancelled => context.l10n.taskStatusCanceled,
      };

  static String priority(BuildContext context, TaskPriority value) =>
      switch (value) {
        TaskPriority.low => context.l10n.tasksPriorityLow,
        TaskPriority.normal => context.l10n.tasksPriorityNormal,
        TaskPriority.high => context.l10n.tasksPriorityHigh,
        TaskPriority.critical => context.l10n.tasksPriorityCritical,
      };
}
