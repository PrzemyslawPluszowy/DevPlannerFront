part of 'tasks_board_page.dart';

/// Oś czasu Gantta zadanego zakresu; pozycja pasków wynika wyłącznie z dat API.
class TaskTimelineView extends StatelessWidget {
  const TaskTimelineView({
    required this.workspaceId,
    required this.projectId,
    super.key,
  });
  final String workspaceId;
  final String projectId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = TaskTimelineCubit(
        repository: context.read<TasksRepository>(),
        workspaceId: workspaceId,
        projectId: projectId,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: const _TimelineBody(),
  );
}

class _TimelineBody extends StatelessWidget {
  const _TimelineBody();
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskTimelineCubit, TaskTimelineState>(
        builder: (context, state) => switch (state) {
          TaskTimelineLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          TaskTimelineFailure(:final message) => Center(
            child: TextButton.icon(
              onPressed: () =>
                  unawaited(context.read<TaskTimelineCubit>().load()),
              icon: const Icon(Symbols.refresh_rounded),
              label: Text(message),
            ),
          ),
          TaskTimelineReady() => _TimelineReady(state: state),
        },
      );
}

class _TimelineReady extends StatelessWidget {
  const _TimelineReady({required this.state});
  final TaskTimelineReady state;
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.tasksTimelineTitle,
                      style: context.text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${state.timeline.dependencies.length} ${context.l10n.tasksTimelineDependencies}',
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    unawaited(_chooseTimelineRange(context, state)),
                icon: const Icon(Symbols.date_range, size: 16),
                label: Text(
                  '${_formatDate(state.fromUtc)} – ${_formatDate(state.toUtc)}',
                  style: context.text.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: colors.outlineVariant),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: state.timeline.items.isEmpty
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      constraints: const BoxConstraints(maxWidth: 440),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colors.outlineVariant.withValues(alpha: .5),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: .08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Symbols.timeline_rounded,
                              size: 36,
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            context.l10n.tasksListEmpty,
                            style: context.text.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colors.onSurface,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Zadania z przypisanymi datami rozpoczęcia lub zakończenia pojawią się na tej osi czasu.',
                            style: context.text.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: () => unawaited(
                              _chooseTimelineRange(context, state),
                            ),
                            icon: const Icon(Symbols.calendar_month, size: 16),
                            label: const Text('Zmień zakres dat'),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: state.timeline.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) => _TimelineRow(
                      item: state.timeline.items[index],
                      fromUtc: state.fromUtc,
                      toUtc: state.toUtc,
                      dependencies: state.timeline.dependencies,
                      taskTitles: {
                        for (final item in state.timeline.items)
                          item.id: item.title,
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.item,
    required this.fromUtc,
    required this.toUtc,
    required this.dependencies,
    required this.taskTitles,
  });
  final TaskTimelineItemResponse item;
  final DateTime fromUtc;
  final DateTime toUtc;
  final List<TaskTimelineDependencyResponse> dependencies;
  final Map<String, String> taskTitles;
  @override
  Widget build(BuildContext context) {
    final span = toUtc.difference(fromUtc).inMilliseconds;
    final start = item.startAtUtc ?? item.dueAtUtc;
    final end = item.dueAtUtc ?? item.startAtUtc;
    final left = start == null
        ? 0.0
        : (start.difference(fromUtc).inMilliseconds / span).clamp(0.0, 1.0);
    final right = end == null
        ? left
        : (end.difference(fromUtc).inMilliseconds / span).clamp(0.0, 1.0);
    final incoming = dependencies.where(
      (item) => item.targetTaskId == this.item.id,
    );
    final outgoing = dependencies.where(
      (item) => item.sourceTaskId == this.item.id,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 210,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.text.titleSmall,
                  ),
                  Text(
                    item.key,
                    style: context.text.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 28,
                    child: start == null
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              context.l10n.tasksTimelineUndated,
                              style: context.text.bodySmall,
                            ),
                          )
                        : LayoutBuilder(
                            builder: (context, constraints) => Stack(
                              children: [
                                Positioned(
                                  left: constraints.maxWidth * left,
                                  top: 7,
                                  width: (constraints.maxWidth * (right - left))
                                      .clamp(
                                        12.0,
                                        constraints.maxWidth * (1 - left),
                                      ),
                                  height: 14,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: _timelinePriorityColor(
                                        item.priority,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                  if (incoming.isNotEmpty || outgoing.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          for (final dependency in incoming)
                            _TimelineDependencyChip(
                              leading: true,
                              title: taskTitles[dependency.sourceTaskId] ?? '—',
                              type: dependency.type,
                            ),
                          for (final dependency in outgoing)
                            _TimelineDependencyChip(
                              leading: false,
                              title: taskTitles[dependency.targetTaskId] ?? '—',
                              type: dependency.type,
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineDependencyChip extends StatelessWidget {
  const _TimelineDependencyChip({
    required this.leading,
    required this.title,
    required this.type,
  });
  final bool leading;
  final String title;
  final TaskDependencyType type;
  @override
  Widget build(BuildContext context) => Tooltip(
    message: type.name,
    child: Chip(
      visualDensity: VisualDensity.compact,
      avatar: Icon(
        leading ? Symbols.arrow_back_rounded : Symbols.arrow_forward_rounded,
        size: 14,
      ),
      label: Text(title, overflow: TextOverflow.ellipsis),
    ),
  );
}

Future<void> _chooseTimelineRange(
  BuildContext context,
  TaskTimelineReady state,
) async {
  final range = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    initialDateRange: DateTimeRange(start: state.fromUtc, end: state.toUtc),
    helpText: context.l10n.tasksTimelineRange,
  );
  if (range != null && context.mounted) {
    await context.read<TaskTimelineCubit>().load(
      fromUtc: range.start.toUtc(),
      toUtc: range.end.add(const Duration(days: 1)).toUtc(),
    );
  }
}

Color _timelinePriorityColor(TaskPriority priority) => switch (priority) {
  TaskPriority.low => const Color(0xFF60A5FA),
  TaskPriority.normal => const Color(0xFF10B981),
  TaskPriority.high => const Color(0xFFF59E0B),
  TaskPriority.critical => const Color(0xFFEF4444),
};
