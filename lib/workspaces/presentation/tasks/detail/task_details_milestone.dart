part of 'task_details_page.dart';

class _TaskMilestoneProperty extends StatelessWidget {
  const _TaskMilestoneProperty({required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    final details = context
        .select<TaskDetailsCubit, ProjectTaskDetailsResponse?>(
          (cubit) => switch (cubit.state) {
            TaskDetailsReady(:final details) => details,
            _ => null,
          },
        );
    if (details == null) return const SizedBox.shrink();
    return BlocProvider(
      key: ValueKey(taskId),
      create: (context) {
        final cubit = TaskMilestoneCubit(
          repository: context.read<MilestoneRepository>(),
          workspaceId: details.task.workspaceId,
          projectId: details.task.projectId,
          taskId: taskId,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const _TaskMilestoneValue(),
    );
  }
}

class _TaskMilestoneValue extends StatelessWidget {
  const _TaskMilestoneValue();

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<TaskMilestoneCubit, TaskMilestoneState>(
        listenWhen: (previous, current) =>
            current is TaskMilestoneReady && current.error != null,
        listener: (context, state) {
          final ready = state as TaskMilestoneReady;
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(ready.error!)));
        },
        builder: (context, state) => switch (state) {
          TaskMilestoneLoading() => _PropertyRow(
            icon: Symbols.flag,
            label: context.l10n.taskDetailsMilestone,
            value: context.l10n.taskDetailsLoading,
          ),
          TaskMilestoneFailure() => _PropertyRow(
            icon: Symbols.flag,
            label: context.l10n.taskDetailsMilestone,
            value: context.l10n.taskDetailsMilestoneUnavailable,
            onTap: () => unawaited(context.read<TaskMilestoneCubit>().load()),
          ),
          TaskMilestoneReady() => _TaskMilestoneReadyValue(state: state),
        },
      );
}

class _TaskMilestoneReadyValue extends StatelessWidget {
  const _TaskMilestoneReadyValue({required this.state});

  final TaskMilestoneReady state;

  @override
  Widget build(BuildContext context) => _PropertyRow(
    icon: Symbols.flag,
    label: context.l10n.taskDetailsMilestone,
    value: state.assigned?.name ?? context.l10n.taskDetailsNoMilestone,
    onTap: state.isSaving
        ? null
        : () => TaskMilestonePickerLauncher.show(context, state),
  );
}

/// Otwiera wybór milestone z Cubitem już utworzonym dla szczegółu zadania.
final class TaskMilestonePickerLauncher {
  const TaskMilestonePickerLauncher._();

  static Future<void> show(BuildContext context, TaskMilestoneReady state) =>
      showModalBottomSheet<void>(
        context: context,
        builder: (_) => BlocProvider.value(
          value: context.read<TaskMilestoneCubit>(),
          child: _TaskMilestonePicker(assigned: state.assigned),
        ),
      );
}

class _TaskMilestonePicker extends StatelessWidget {
  const _TaskMilestonePicker({required this.assigned});

  final MilestoneResponse? assigned;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 20),
      child: BlocBuilder<TaskMilestoneCubit, TaskMilestoneState>(
        builder: (context, state) {
          final ready = state as TaskMilestoneReady;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.taskDetailsMilestone,
                style: context.text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              if (assigned != null)
                ListTile(
                  leading: const Icon(Symbols.link_off_rounded),
                  title: Text(context.l10n.taskDetailsRemoveMilestone),
                  onTap: ready.isSaving
                      ? null
                      : () async {
                          await context.read<TaskMilestoneCubit>().unassign();
                          if (context.mounted) Navigator.of(context).pop();
                        },
                )
              else
                for (final milestone in ready.milestones)
                  ListTile(
                    leading: const Icon(Symbols.flag),
                    title: Text(milestone.name),
                    onTap: ready.isSaving
                        ? null
                        : () async {
                            await context.read<TaskMilestoneCubit>().assign(
                              milestone,
                            );
                            if (context.mounted) Navigator.of(context).pop();
                          },
                  ),
            ],
          );
        },
      ),
    ),
  );
}
