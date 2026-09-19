part of 'task_details_page.dart';

class _TaskProperties extends StatelessWidget {
  const _TaskProperties({required this.details});

  final ProjectTaskDetailsResponse details;

  @override
  Widget build(BuildContext context) {
    final task = details.task;
    final users = {
      for (final user in details.includedUsers) user.userId: user,
    };
    final assignees = task.assignees
        .map((item) => users[item.userId]?.displayName ?? item.userId)
        .join(', ');
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return _Section(
      title: context.l10n.taskDetailsProperties,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: context.l10n.taskDetailsEditAssignees,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: _EditAssigneesDialog(task: task),
              ),
            ),
            icon: const Icon(Symbols.group_add, size: 20),
          ),
          IconButton(
            tooltip: context.l10n.taskDetailsEditPlanning,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: _EditPlanningDialog(task: task),
              ),
            ),
            icon: const Icon(Symbols.event_note, size: 20),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.outlineVariant),
        ),
        child: Column(
          children: [
            _PropertyRow(
              icon: Symbols.people_outline_rounded,
              label: context.l10n.taskDetailsAssignees,
              value: assignees.isEmpty
                  ? context.l10n.taskDetailsNobody
                  : assignees,
            ),
            _PropertyRow(
              icon: Symbols.play_circle_rounded,
              label: context.l10n.taskDetailsStartDate,
              value: task.startAtUtc == null
                  ? context.l10n.taskDetailsNoDate
                  : dateFormat.format(task.startAtUtc!.toLocal()),
            ),
            _PropertyRow(
              icon: Symbols.calendar_today,
              label: context.l10n.taskDetailsDueDate,
              value: task.dueAtUtc == null
                  ? context.l10n.taskDetailsNoDueDate
                  : dateFormat.format(task.dueAtUtc!.toLocal()),
            ),
            _TaskMilestoneProperty(taskId: task.id),
            _PropertyRow(
              icon: Symbols.schedule,
              label: context.l10n.taskDetailsEstimate,
              value: task.estimatedMinutes == null
                  ? context.l10n.taskDetailsNoEstimate
                  : context.l10n.taskDetailsMinutes(task.estimatedMinutes!),
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.action});

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.text.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ?action,
        ],
      ),
      const SizedBox(height: 10),
      child,
    ],
  );
}
