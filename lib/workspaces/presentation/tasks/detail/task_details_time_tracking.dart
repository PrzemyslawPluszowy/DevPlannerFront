import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_time_entry_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_time_entry_review_dialog.dart';

class TaskTimeTrackingSection extends StatelessWidget {
  const TaskTimeTrackingSection({
    required this.taskId,
    required this.isEditable,
    super.key,
  });
  final String taskId;
  final bool isEditable;
  @override
  Widget build(BuildContext context) {
    final details = context.read<TaskDetailsCubit>();
    return BlocProvider(
      create: (context) {
        final cubit = TaskTimeTrackingCubit(
          repository: context.read<TaskTimeTrackingRepository>(),
          workspaceId: details.workspaceId,
          projectId: details.projectId,
          taskId: taskId,
          canEdit: () => switch (details.state) {
            TaskDetailsReady(:final canEdit) => canEdit,
            _ => false,
          },
          onAccessLost: (error) => unawaited(details.reportAccessLost(error)),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: TaskTimeTrackingBody(isEditable: isEditable),
    );
  }
}

class TaskTimeTrackingBody extends StatelessWidget {
  const TaskTimeTrackingBody({required this.isEditable, super.key});
  final bool isEditable;
  @override
  Widget build(BuildContext context) => Section(
    title: context.l10n.taskDetailsTimeTracking,
    action: BlocBuilder<TaskTimeTrackingCubit, TaskTimeTrackingState>(
      builder: (context, state) => TextButton.icon(
        onPressed: isEditable && !state.isRetryBlocked
            ? () => DevPlannerModalHost.showDialog<void>(
                context,
                builder: (_) => BlocProvider.value(
                  value: context.read<TaskTimeTrackingCubit>(),
                  child: const ManualTimeEntryDialog(),
                ),
              )
            : null,
        icon: const Icon(Symbols.add_rounded, size: 18),
        label: Text(context.l10n.taskDetailsTimeAdd),
      ),
    ),
    child: BlocBuilder<TaskTimeTrackingCubit, TaskTimeTrackingState>(
      builder: (context, state) => switch (state) {
        TaskTimeTrackingLoading() => const Padding(
          padding: EdgeInsets.all(18),
          child: Center(child: CircularProgressIndicator()),
        ),
        TaskTimeTrackingFailure(:final message) => Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              if (state.apiError case final error?)
                TaskDetailsModalError(
                  error: error,
                  fallbackMessage:
                      context.l10n.taskDetailsTimeOperationFailed,
                )
              else
                Text(message),
              TextButton(
                onPressed: state.isRetryBlocked
                    ? null
                    : () => unawaited(
                        context.read<TaskTimeTrackingCubit>().load(),
                      ),
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
        TaskTimeTrackingReady() => TimeTrackingReady(
          state: state,
          isEditable: isEditable,
        ),
      },
    ),
  );
}

class TimeTrackingReady extends StatelessWidget {
  const TimeTrackingReady({
    required this.state,
    required this.isEditable,
    super.key,
  });
  final TaskTimeTrackingReady state;
  final bool isEditable;
  @override
  Widget build(BuildContext context) {
    final minutes = state.totalMinutes;
    final active = state.ownActiveTimers.isNotEmpty;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Symbols.timer, color: context.colors.primary),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    context.l10n.taskDetailsTimeTotal(
                      TaskTimeTrackingPresentation.durationLabel(
                        context,
                        minutes,
                      ),
                    ),
                    style: context.text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed:
                      state.isSaving ||
                          state.isRetryBlocked ||
                          (!active && !isEditable)
                      ? null
                      : () => unawaited(
                          active
                              ? context
                                    .read<TaskTimeTrackingCubit>()
                                    .stopTimer()
                              : context
                                    .read<TaskTimeTrackingCubit>()
                                    .startTimer(),
                        ),
                  icon: Icon(
                    active ? Symbols.stop_rounded : Symbols.play_arrow_rounded,
                  ),
                  label: Text(
                    active
                        ? context.l10n.taskDetailsTimeStop
                        : context.l10n.taskDetailsTimeStart,
                  ),
                ),
              ],
            ),
            if (state.apiError case final error?) ...[
              const SizedBox(height: 9),
              TaskDetailsModalError(
                error: error,
                fallbackMessage: context.l10n.taskDetailsTimeOperationFailed,
              ),
            ] else if (state.error != null) ...[
              const SizedBox(height: 9),
              Text(state.error!, style: TextStyle(color: context.colors.error)),
            ],
            for (final entry in state.entries)
              TimeEntryTile(
                entry: entry,
                isSaving: state.isSaving || state.isRetryBlocked,
                nowUtc: state.nowUtc,
              ),
          ],
        ),
      ),
    );
  }
}

class TimeEntryTile extends StatelessWidget {
  const TimeEntryTile({
    required this.entry,
    required this.isSaving,
    required this.nowUtc,
    super.key,
  });
  final TaskTimeEntryResponse entry;
  final bool isSaving;
  final DateTime? nowUtc;
  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    contentPadding: EdgeInsets.zero,
    leading: Icon(
      entry.kind == TaskTimeEntryKind.timer
          ? Symbols.timer
          : Symbols.edit_calendar,
    ),
    title: Text(
      entry.description?.trim().isNotEmpty == true
          ? entry.description!
          : context.l10n.taskDetailsTimeNoDescription,
    ),
    subtitle: Text(
      '${TaskTimeTrackingPresentation.durationLabel(context, entry.durationMinutes ?? TaskTimeTrackingPresentation.timerMinutes(entry, nowUtc))} · ${TaskTimeTrackingPresentation.approvalLabel(context, entry.approvalStatus)}',
    ),
    trailing: TimeEntryActions(entry: entry, isSaving: isSaving),
  );
}

class TimeEntryActions extends StatelessWidget {
  const TimeEntryActions({
    required this.entry,
    required this.isSaving,
    super.key,
  });
  final TaskTimeEntryResponse entry;
  final bool isSaving;

  @override
  Widget build(BuildContext context) {
    if (entry.canSubmit) {
      return TextButton(
        onPressed: isSaving
            ? null
            : () => unawaited(
                context.read<TaskTimeTrackingCubit>().submit(entry),
              ),
        child: Text(context.l10n.taskDetailsTimeSubmit),
      );
    }
    if (entry.canReview) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.check_circle_outline_rounded,
              color: context.colors.tertiary,
              size: 20,
            ),
            tooltip: context.l10n.taskDetailsTimeApprove,
            onPressed: isSaving
                ? null
                : () => _openReview(context, approve: true),
          ),
          IconButton(
            icon: Icon(
              Icons.cancel_outlined,
              color: context.colors.error,
              size: 20,
            ),
            tooltip: context.l10n.taskDetailsTimeReject,
            onPressed: isSaving
                ? null
                : () => _openReview(context, approve: false),
          ),
        ],
      );
    }
    if (entry.canStopTimer) {
      return IconButton(
        tooltip: context.l10n.taskDetailsTimeStop,
        onPressed: isSaving
            ? null
            : () =>
                  unawaited(context.read<TaskTimeTrackingCubit>().stopTimer()),
        icon: const Icon(Symbols.stop_rounded),
      );
    }
    return switch (entry.approvalStatus) {
      TaskTimeEntryApprovalStatus.approved => Icon(
        Icons.check_circle_rounded,
        color: context.colors.tertiary,
        size: 18,
      ),
      TaskTimeEntryApprovalStatus.rejected => Icon(
        Icons.cancel_rounded,
        color: context.colors.error,
        size: 18,
      ),
      TaskTimeEntryApprovalStatus.draft ||
      TaskTimeEntryApprovalStatus.submitted => const SizedBox.shrink(),
    };
  }

  void _openReview(BuildContext context, {required bool approve}) {
    unawaited(
      DevPlannerModalHost.showDialog<void>(
        context,
        builder: (_) => BlocProvider.value(
          value: context.read<TaskTimeTrackingCubit>(),
          child: TaskTimeEntryReviewDialog(entry: entry, approve: approve),
        ),
      ),
    );
  }
}

/// Formatuje wartości czasu wyłącznie na potrzeby widoku szczegółu zadania.
///
/// Nie wykonuje I/O ani nie przechowuje stanu. Dzięki temu reguły prezentacji
/// nie są rozproszone pomiędzy widgetami i pozostają łatwe do testowania.
final class TaskTimeTrackingPresentation {
  const TaskTimeTrackingPresentation._();

  static int timerMinutes(TaskTimeEntryResponse entry, DateTime? nowUtc) =>
      entry.stoppedAtUtc == null
      ? (nowUtc ?? DateTime.now().toUtc())
            .difference(entry.startedAtUtc)
            .inMinutes
            .clamp(0, 1 << 31)
      : entry.stoppedAtUtc!.difference(entry.startedAtUtc).inMinutes;

  static String durationLabel(BuildContext context, int minutes) {
    final hours = minutes ~/ 60;
    final remainder = minutes % 60;
    final l10n = context.l10n;
    if (hours == 0) return l10n.taskDetailsTimeMinuteCount(remainder);
    if (remainder == 0) return l10n.taskDetailsTimeHourCount(hours);
    return '${l10n.taskDetailsTimeHourCount(hours)} '
        '${l10n.taskDetailsTimeMinuteCount(remainder)}';
  }

  static String approvalLabel(
    BuildContext context,
    TaskTimeEntryApprovalStatus status,
  ) => switch (status) {
    TaskTimeEntryApprovalStatus.draft => context.l10n.taskDetailsTimeDraft,
    TaskTimeEntryApprovalStatus.submitted =>
      context.l10n.taskDetailsTimeSubmitted,
    TaskTimeEntryApprovalStatus.approved =>
      context.l10n.taskDetailsTimeApproved,
    TaskTimeEntryApprovalStatus.rejected =>
      context.l10n.taskDetailsTimeRejected,
  };
}
