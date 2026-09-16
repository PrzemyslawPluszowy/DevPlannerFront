part of 'task_details_page.dart';

Future<void> _showTaskHistory(BuildContext context) {
  final detailsCubit = context.read<TaskDetailsCubit>();
  final historyRepository = context.read<TaskHistoryRepository>();
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) {
        final cubit = TaskHistoryCubit(
          repository: historyRepository,
          workspaceId: detailsCubit.workspaceId,
          projectId: detailsCubit.projectId,
          taskId: detailsCubit.taskId,
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const _TaskHistoryDialog(),
    ),
  );
}

class _TaskHistoryDialog extends StatelessWidget {
  const _TaskHistoryDialog();

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
            const Expanded(child: _TaskHistoryBody()),
          ],
        ),
      ),
    ),
  );
}

class _TaskHistoryBody extends StatelessWidget {
  const _TaskHistoryBody();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<TaskHistoryCubit, TaskHistoryState>(
        builder: (context, state) => switch (state) {
          TaskHistoryInitial() || TaskHistoryLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
          TaskHistoryFailure(:final message) => _TaskHistoryError(
            message: message,
          ),
          TaskHistoryReady() => _TaskHistoryList(state: state),
        },
      );
}

class _TaskHistoryError extends StatelessWidget {
  const _TaskHistoryError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Symbols.history_toggle_off_rounded, color: context.colors.error),
          const SizedBox(height: 10),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => unawaited(context.read<TaskHistoryCubit>().load()),
            icon: const Icon(Symbols.refresh_rounded),
            label: Text(context.l10n.taskDetailsHistoryRetry),
          ),
        ],
      ),
    ),
  );
}

class _TaskHistoryList extends StatelessWidget {
  const _TaskHistoryList({required this.state});

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
            return _TaskHistoryFooter(state: state);
          }
          return _TaskHistoryEventTile(event: state.events[index]);
        },
      ),
    );
  }
}

class _TaskHistoryFooter extends StatelessWidget {
  const _TaskHistoryFooter({required this.state});

  final TaskHistoryReady state;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: Center(
          child: SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (state.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.all(10),
        child: TextButton.icon(
          onPressed: () =>
              unawaited(context.read<TaskHistoryCubit>().loadMore()),
          icon: const Icon(Symbols.refresh_rounded),
          label: Text(context.l10n.taskDetailsHistoryRetry),
        ),
      );
    }
    return state.hasMore
        ? const SizedBox(height: 44)
        : const SizedBox(height: 10);
  }
}

class _TaskHistoryEventTile extends StatelessWidget {
  const _TaskHistoryEventTile({required this.event});

  final TaskHistoryEventResponse event;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd().add_Hm().format(
      event.createdAtUtc.toLocal(),
    );
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      leading: CircleAvatar(
        backgroundColor: context.colors.primaryContainer,
        foregroundColor: context.colors.onPrimaryContainer,
        child: Icon(_eventIcon(event.eventType), size: 19),
      ),
      title: Text(
        event.actionLabel,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 3),
          Text('${_actorLabel(context, event.actor)} · $date'),
          if (event.changes.isNotEmpty) ...[
            const SizedBox(height: 5),
            for (final change in event.changes.take(3))
              Text(
                '${change.field}: ${_historyValue(change.before)} → ${_historyValue(change.after)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodySmall,
              ),
          ],
        ],
      ),
      trailing: Text(
        context.l10n.taskDetailsHistoryVersion(event.taskVersion),
        style: context.text.labelSmall?.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

IconData _eventIcon(TaskHistoryEventType type) => switch (type) {
  TaskHistoryEventType.created => Symbols.add_task_rounded,
  TaskHistoryEventType.statusChanged ||
  TaskHistoryEventType.kanbanMoved => Symbols.swap_horiz_rounded,
  TaskHistoryEventType.archived => Symbols.archive,
  TaskHistoryEventType.restored => Symbols.unarchive,
  _ => Symbols.edit_note_rounded,
};

String _actorLabel(BuildContext context, TaskHistoryActorResponse actor) =>
    switch (actor.type) {
      TaskActorType.system => context.l10n.taskDetailsHistoryActorSystem,
      TaskActorType.automation =>
        context.l10n.taskDetailsHistoryActorAutomation,
      TaskActorType.user =>
        actor.coreUserId ?? context.l10n.taskDetailsHistoryActorUser,
    };

String _historyValue(Object? value) {
  if (value == null) return '—';
  final text = value.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  return text.length <= 80 ? text : '${text.substring(0, 77)}…';
}
