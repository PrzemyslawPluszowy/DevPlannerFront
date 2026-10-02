import 'package:devplanner/workspaces/presentation/tasks/detail/recurrence/cubit/task_recurrence_run_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/task_recurrence_date_formatter.dart';

/// Pokazuje stan ostatniego wykonania, niezależnie od edycji konfiguracji.
final class TaskRecurrenceRunDetails extends StatelessWidget {
  const TaskRecurrenceRunDetails({
    required this.task,
    required this.isEditable,
    super.key,
  });

  final ProjectTaskResponse task;
  final bool isEditable;

  Future<void> _triggerRunNow(BuildContext context, String ruleId) async {
    final runCubit = context.read<TaskRecurrenceRunCubit>();
    final detailsCubit = context.read<TaskDetailsCubit>();
    final succeeded = await runCubit.triggerRunNow(ruleId);
    if (!context.mounted ||
        !succeeded ||
        runCubit.isClosed ||
        detailsCubit.isClosed ||
        !identical(runCubit, context.read<TaskRecurrenceRunCubit>()) ||
        !identical(detailsCubit, context.read<TaskDetailsCubit>())) {
      return;
    }
    await detailsCubit.load();
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<TaskRecurrenceRunCubit, TaskRecurrenceRunState>(
    builder: (context, state) {
      final recurrence = task.recurrence;
      if (recurrence == null ||
          !recurrence.isSourceTask ||
          recurrence.sourceTaskId != task.id) {
        return const SizedBox.shrink();
      }
      final latest = state.latestRun;
      final nextOccurrenceAtUtc = recurrence.nextOccurrenceAtUtc;
      return Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              context.l10n.taskRecurrenceRunSourceHint,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${context.l10n.taskRecurrenceNextOccurrenceLocal}: '
              '${nextOccurrenceAtUtc == null ? context.l10n.taskDetailsNoDate : TaskRecurrenceDateFormatter.local(context, nextOccurrenceAtUtc)}',
              style: context.text.bodySmall,
            ),
            Text(
              '${context.l10n.taskDetailsRecurrenceTimeZone}: '
              '${recurrence.timeZoneId}',
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed:
                  !isEditable ||
                      state.isTriggering ||
                      state.isLoadingHistory ||
                      state.isActionRetryBlocked
                  ? null
                  : () => unawaited(_triggerRunNow(context, recurrence.id)),
              icon: state.isTriggering
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Symbols.play_arrow_rounded),
              label: Text(
                state.isTriggering
                    ? context.l10n.taskDetailsLoading
                    : context.l10n.tasksRecurrenceRunNow,
              ),
            ),
            if (state.actionError case final error?) ...[
              const SizedBox(height: 8),
              TaskDetailsModalError(
                error: error,
                fallbackMessage:
                    context.l10n.taskDetailsRecurrenceOperationFailed,
              ),
            ],
            if (state.isLoadingHistory) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(minHeight: 2),
            ],
            if (state.historyError case final error?) ...[
              const SizedBox(height: 8),
              TaskDetailsModalError(
                error: error,
                fallbackMessage:
                    context.l10n.taskDetailsRecurrenceOperationFailed,
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  onPressed:
                      state.isHistoryRetryBlocked ||
                          state.isLoadingHistory ||
                          state.isTriggering
                      ? null
                      : () => unawaited(
                          context.read<TaskRecurrenceRunCubit>().retryHistory(),
                        ),
                  icon: const Icon(Symbols.refresh_rounded),
                  label: Text(context.l10n.taskDetailsRecurrenceRetry),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              context.l10n.taskRecurrenceLatestRun,
              style: context.text.labelMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (latest == null)
              Text(
                context.l10n.tasksRecurrenceRunsEmptyTitle,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              )
            else ...[
              const SizedBox(height: 4),
              Text(
                latest.outcome == TaskRecurrenceRunOutcome.created
                    ? context.l10n.tasksRecurrenceOutcomeCreated
                    : context.l10n.tasksRecurrenceOutcomeSkipped,
                style: context.text.bodySmall,
              ),
              Text(
                TaskRecurrenceDateFormatter.local(
                  context,
                  latest.executedAtUtc,
                ),
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              if (latest.createdTaskKey case final createdTaskKey?)
                Text(
                  '${context.l10n.taskRecurrenceCreatedTask}: $createdTaskKey',
                  style: context.text.bodySmall,
                ),
            ],
          ],
        ),
      );
    },
  );
}
