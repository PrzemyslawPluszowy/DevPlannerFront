part of 'tasks_board_page.dart';

/// Widok obciążenia zespołu oparty o zakres dat i faktyczną capacity backendu.
class TaskWorkloadView extends StatelessWidget {
  const TaskWorkloadView({
    required this.workspaceId,
    required this.projectId,
    super.key,
  });

  final String workspaceId;
  final String projectId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = TaskWorkloadCubit(
        repository: context.read<TaskCapacityRepository>(),
        memberProfilesRepository: context
            .read<ProjectMemberProfilesRepository>(),
        workspaceId: workspaceId,
        projectId: projectId,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: const _TaskWorkloadBody(),
  );
}

class _TaskWorkloadBody extends StatelessWidget {
  const _TaskWorkloadBody();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskWorkloadCubit, TaskWorkloadState>(
        builder: (context, state) => switch (state) {
          TaskWorkloadLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          TaskWorkloadFailure(:final message) => Center(
            child: TextButton.icon(
              onPressed: () =>
                  unawaited(context.read<TaskWorkloadCubit>().load()),
              icon: const Icon(Symbols.refresh_rounded),
              label: Text(message),
            ),
          ),
          TaskWorkloadReady() => _TaskWorkloadReady(state: state),
        },
      );
}

class _TaskWorkloadReady extends StatelessWidget {
  const _TaskWorkloadReady({required this.state});
  final TaskWorkloadReady state;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1060),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    context.l10n.tasksWorkloadTitle,
                    style: context.text.headlineSmall,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => unawaited(_pickRange(context, state)),
                  icon: const Icon(Symbols.date_range, size: 18),
                  label: Text(
                    '${_formatDate(state.fromDate)} – ${_formatDate(state.toDate)}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Expanded(
              child: state.workload.users.isEmpty
                  ? Center(child: Text(context.l10n.tasksWorkloadEmpty))
                  : ListView.separated(
                      itemCount: state.workload.users.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) => _WorkloadCard(
                        value: state.workload.users[index],
                        name:
                            state
                                .profilesByCoreUserId[state
                                    .workload
                                    .users[index]
                                    .coreUserId]
                                ?.displayName ??
                            context.l10n.tasksCapacityUnknownMember,
                      ),
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _WorkloadCard extends StatelessWidget {
  const _WorkloadCard({required this.value, required this.name});
  final TaskWorkloadUserResponse value;
  final String name;

  @override
  Widget build(BuildContext context) {
    final capacity = value.availableCapacityMinutes;
    final used = value.estimatedMinutes;
    final ratio = capacity == 0
        ? (used == 0 ? 0.0 : 1.0)
        : (used / capacity).clamp(0.0, 1.0);
    final color = value.isOverCapacity
        ? context.colors.error
        : context.colors.primary;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(name, style: context.text.titleMedium)),
                if (value.isOverCapacity)
                  Chip(
                    label: Text(context.l10n.tasksWorkloadOverCapacity),
                    avatar: Icon(
                      Symbols.warning_amber_rounded,
                      color: context.colors.error,
                      size: 17,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: ratio,
              color: color,
              minHeight: 8,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 18,
              runSpacing: 6,
              children: [
                _WorkloadMetric(
                  label: context.l10n.tasksWorkloadTasks,
                  value: value.assignedTaskCount.toString(),
                ),
                _WorkloadMetric(
                  label: context.l10n.tasksWorkloadAvailable,
                  value: '${value.availableCapacityMinutes} min',
                ),
                _WorkloadMetric(
                  label: context.l10n.tasksWorkloadRemaining,
                  value: '${value.remainingCapacityMinutes} min',
                  color: color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkloadMetric extends StatelessWidget {
  const _WorkloadMetric({required this.label, required this.value, this.color});
  final String label;
  final String value;
  final Color? color;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: context.text.labelSmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
      Text(value, style: context.text.titleSmall?.copyWith(color: color)),
    ],
  );
}

Future<void> _pickRange(BuildContext context, TaskWorkloadReady state) async {
  final range = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    initialDateRange: DateTimeRange(start: state.fromDate, end: state.toDate),
    helpText: context.l10n.tasksWorkloadRange,
  );
  if (range != null && context.mounted) {
    await context.read<TaskWorkloadCubit>().load(
      fromDate: range.start,
      toDate: range.end,
    );
  }
}
