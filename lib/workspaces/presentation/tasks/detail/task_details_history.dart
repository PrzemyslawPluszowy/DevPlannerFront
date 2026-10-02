import 'package:devplanner/workspaces/presentation/tasks/detail/history/task_history_presentation.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';

/// Otwiera modal historii dla aktualnie złożonego szczegółu zadania.
///
/// Pobiera wyłącznie zależności z najbliższego drzewa widgetów i przekazuje je
/// do lokalnego Cubita; nie przechowuje stanu ani nie wykonuje I/O poza tym
/// Cubitem.
final class TaskHistoryDialogLauncher {
  const TaskHistoryDialogLauncher._();

  static Future<void> show(BuildContext context) {
    final detailsCubit = context.read<TaskDetailsCubit>();
    final historyRepository = context.read<TaskHistoryRepository>();
    final memberProfilesRepository = context
        .read<ProjectMemberProfilesRepository?>();
    return DevPlannerModalHost.showDialog<void>(
      context,
      builder: (_) => BlocProvider(
        create: (_) {
          final cubit = TaskHistoryCubit(
            repository: historyRepository,
            memberProfilesRepository: memberProfilesRepository,
            workspaceId: detailsCubit.workspaceId,
            projectId: detailsCubit.projectId,
            taskId: detailsCubit.taskId,
            onAccessLost: (error) =>
                unawaited(detailsCubit.reportAccessLost(error)),
          );
          unawaited(cubit.load());
          return cubit;
        },
        child: const TaskHistoryDialog(),
      ),
    );
  }
}

class TaskHistoryDialog extends StatelessWidget {
  const TaskHistoryDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680, maxHeight: 680),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 18, 14, 14),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Symbols.history_rounded, color: context.colors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.taskDetailsHistory,
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
            const SizedBox(height: 8),
            const Expanded(child: TaskHistoryBody()),
          ],
        ),
      ),
    ),
  );
}

class TaskHistoryBody extends StatelessWidget {
  const TaskHistoryBody({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskHistoryCubit, TaskHistoryState>(
        builder: (context, state) => switch (state) {
          TaskHistoryInitial() || TaskHistoryLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          TaskHistoryFailure(:final message, :final apiError) =>
            TaskHistoryError(
              message: message,
              apiError: apiError,
            ),
          TaskHistoryReady() => TaskHistoryList(state: state),
        },
      );
}

class TaskHistoryError extends StatelessWidget {
  const TaskHistoryError({required this.message, this.apiError, super.key});

  final String message;
  final ApiError? apiError;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.history_toggle_off_rounded,
              color: context.colors.error,
            ),
            const SizedBox(height: 10),
            if (apiError case final error?)
              TaskDetailsModalError(
                error: error,
                fallbackMessage: context.l10n.taskHistoryReadFailed,
              )
            else
              Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () =>
                  unawaited(context.read<TaskHistoryCubit>().load()),
              icon: const Icon(Symbols.refresh_rounded),
              label: Text(context.l10n.taskDetailsHistoryRetry),
            ),
          ],
        ),
      ),
    ),
  );
}

class TaskHistoryList extends StatelessWidget {
  const TaskHistoryList({required this.state, super.key});

  final TaskHistoryReady state;

  @override
  Widget build(BuildContext context) {
    if (state.events.isEmpty) {
      return Center(child: Text(context.l10n.taskDetailsHistoryEmpty));
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.extentAfter < 160) {
          unawaited(context.read<TaskHistoryCubit>().loadMore());
        }
        return false;
      },
      child: ListView.separated(
        itemCount: state.events.length + 1,
        separatorBuilder: (_, _) =>
            Divider(color: context.colors.outlineVariant),
        itemBuilder: (context, index) {
          if (index == state.events.length) {
            return TaskHistoryFooter(state: state);
          }
          return TaskHistoryEventTile(
            event: state.events[index],
            actorNames: state.actorNames,
          );
        },
      ),
    );
  }
}

class TaskHistoryFooter extends StatelessWidget {
  const TaskHistoryFooter({required this.state, super.key});

  final TaskHistoryReady state;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (state.actorLookupFailure case final failure?) ...[
        TaskDetailsModalError(
          error: failure,
          fallbackMessage: context.l10n.taskHistoryActorsUnavailable,
        ),
        TextButton.icon(
          onPressed: () => unawaited(context.read<TaskHistoryCubit>().load()),
          icon: const Icon(Symbols.refresh_rounded),
          label: Text(context.l10n.taskDetailsHistoryRetry),
        ),
      ],
      if (state.isLoadingMore)
        const Padding(
          padding: EdgeInsets.all(14),
          child: Center(
            child: SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        )
      else if (state.loadMoreError != null) ...[
        if (state.loadMoreFailure case final failure?)
          TaskDetailsModalError(
            error: failure,
            fallbackMessage: context.l10n.taskHistoryReadFailed,
          ),
        TextButton.icon(
          onPressed: () =>
              unawaited(context.read<TaskHistoryCubit>().loadMore()),
          icon: const Icon(Symbols.refresh_rounded),
          label: Text(context.l10n.taskDetailsHistoryRetry),
        ),
      ] else
        SizedBox(height: state.hasMore ? 44 : 10),
    ],
  );
}

class TaskHistoryEventTile extends StatelessWidget {
  const TaskHistoryEventTile({
    required this.event,
    this.actorNames = const {},
    super.key,
  });

  final TaskHistoryEventResponse event;
  final Map<String, String> actorNames;

  @override
  Widget build(BuildContext context) {
    final date =
        DateFormat.yMMMd(Localizations.localeOf(context).toLanguageTag())
            .add_Hm()
            .format(
              event.createdAtUtc.toLocal(),
            );
    final visibleChanges = <TaskHistoryChangeResponse>[];
    for (final change in event.changes) {
      if (!TaskHistoryPresentation.isTechnicalField(change.field) &&
          visibleChanges.length < 3) {
        visibleChanges.add(change);
      }
    }
    final actorAndDate =
        '${TaskHistoryPresentation.actorLabel(context, event.actor, actorNames)} · $date';
    final title = TaskHistoryPresentation.actionLabel(context, event.eventType);
    final version = Text(
      context.l10n.taskDetailsHistoryVersion(event.taskVersion),
      style: context.text.labelSmall?.copyWith(
        color: context.colors.onSurfaceVariant,
      ),
    );
    final leading = CircleAvatar(
      backgroundColor: context.tasksTheme.commandBarSurface,
      foregroundColor: context.colors.onSurfaceVariant,
      child: Icon(TaskHistoryPresentation.eventIcon(event.eventType), size: 19),
    );

    if (event.changes.isEmpty) {
      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
        leading: leading,
        title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(actorAndDate),
        trailing: version,
      );
    }
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        dense: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 4),
        leading: leading,
        iconColor: context.colors.onSurfaceVariant,
        collapsedIconColor: context.colors.onSurfaceVariant,
        textColor: context.colors.onSurface,
        collapsedTextColor: context.colors.onSurface,
        title: Row(
          children: [
            Expanded(
              child: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 8),
            version,
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(actorAndDate),
            for (final change in visibleChanges)
              TaskHistoryChangeLine(change: change, compact: true),
          ],
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              context.l10n.taskHistoryFullDetails,
              style: context.text.labelMedium,
            ),
          ),
          const SizedBox(height: 4),
          for (final change in event.changes)
            TaskHistoryChangeLine(change: change),
        ],
      ),
    );
  }
}

class TaskHistoryChangeLine extends StatelessWidget {
  const TaskHistoryChangeLine({
    required this.change,
    this.compact = false,
    super.key,
  });

  final TaskHistoryChangeResponse change;
  final bool compact;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 3),
    child: Text(
      '${TaskHistoryPresentation.fieldLabel(context, change.field)}: ${TaskHistoryPresentation.value(context, change.field, change.before, truncate: compact)} → ${TaskHistoryPresentation.value(context, change.field, change.after, truncate: compact)}',
      maxLines: compact ? 1 : null,
      overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
      softWrap: true,
      style: compact
          ? context.text.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            )
          : context.text.bodyMedium,
    ),
  );
}
