part of 'task_details_page.dart';

class _TaskTimeTrackingSection extends StatelessWidget {
  const _TaskTimeTrackingSection({required this.taskId});
  final String taskId;
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
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const _TaskTimeTrackingBody(),
    );
  }
}

class _TaskTimeTrackingBody extends StatelessWidget {
  const _TaskTimeTrackingBody();
  @override
  Widget build(BuildContext context) => _Section(
    title: context.l10n.taskDetailsTimeTracking,
    action: TextButton.icon(
      onPressed: () => showDialog<void>(
        context: context,
        builder: (_) => BlocProvider.value(
          value: context.read<TaskTimeTrackingCubit>(),
          child: const _ManualTimeEntryDialog(),
        ),
      ),
      icon: const Icon(Symbols.add_rounded, size: 18),
      label: Text(context.l10n.taskDetailsTimeAdd),
    ),
    child: BlocBuilder<TaskTimeTrackingCubit, TaskTimeTrackingState>(
      builder: (context, state) => switch (state) {
        TaskTimeTrackingLoading() => const Padding(
          padding: EdgeInsets.all(18),
          child: Center(child: CircularProgressIndicator()),
        ),
        TaskTimeTrackingFailure(:final message) => Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Text(message),
              TextButton(
                onPressed: () =>
                    unawaited(context.read<TaskTimeTrackingCubit>().load()),
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
        TaskTimeTrackingReady() => _TimeTrackingReady(state: state),
      },
    ),
  );
}

class _TimeTrackingReady extends StatelessWidget {
  const _TimeTrackingReady({required this.state});
  final TaskTimeTrackingReady state;
  @override
  Widget build(BuildContext context) {
    final minutes = state.entries.fold<int>(
      0,
      (sum, entry) =>
          sum +
          (entry.durationMinutes ??
              TaskTimeTrackingPresentation.timerMinutes(entry, state.nowUtc)),
    );
    final active = state.activeTimers.isNotEmpty;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
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
                      TaskTimeTrackingPresentation.durationLabel(minutes),
                    ),
                    style: context.text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: state.isSaving
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
            if (state.error != null) ...[
              const SizedBox(height: 9),
              Text(state.error!, style: TextStyle(color: context.colors.error)),
            ],
            for (final entry in state.entries)
              _TimeEntryTile(entry: entry, isSaving: state.isSaving),
          ],
        ),
      ),
    );
  }
}

class _TimeEntryTile extends StatelessWidget {
  const _TimeEntryTile({required this.entry, required this.isSaving});
  final TaskTimeEntryResponse entry;
  final bool isSaving;
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
      '${TaskTimeTrackingPresentation.durationLabel(entry.durationMinutes ?? TaskTimeTrackingPresentation.timerMinutes(entry, DateTime.now().toUtc()))} · ${TaskTimeTrackingPresentation.approvalLabel(context, entry.approvalStatus)}',
    ),
    trailing: switch (entry.approvalStatus) {
      TaskTimeEntryApprovalStatus.draft => TextButton(
        onPressed: isSaving
            ? null
            : () => unawaited(
                context.read<TaskTimeTrackingCubit>().submit(entry),
              ),
        child: Text(context.l10n.taskDetailsTimeSubmit),
      ),
      TaskTimeEntryApprovalStatus.submitted => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.green,
              size: 20,
            ),
            tooltip: 'Zatwierdź czas',
            onPressed: isSaving
                ? null
                : () => unawaited(
                    context.read<TaskTimeTrackingCubit>().approve(entry),
                  ),
          ),
          IconButton(
            icon: const Icon(
              Icons.cancel_outlined,
              color: Colors.red,
              size: 20,
            ),
            tooltip: 'Odrzuć czas',
            onPressed: isSaving
                ? null
                : () => unawaited(
                    context.read<TaskTimeTrackingCubit>().reject(entry),
                  ),
          ),
        ],
      ),
      TaskTimeEntryApprovalStatus.approved => const Padding(
        padding: EdgeInsets.only(right: 8),
        child: Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
      ),
      TaskTimeEntryApprovalStatus.rejected => const Padding(
        padding: EdgeInsets.only(right: 8),
        child: Icon(Icons.cancel_rounded, color: Colors.red, size: 18),
      ),
    },
  );
}

class _ManualTimeEntryDialog extends StatefulWidget {
  const _ManualTimeEntryDialog();
  @override
  State<_ManualTimeEntryDialog> createState() => _ManualTimeEntryDialogState();
}

class _ManualTimeEntryDialogState extends State<_ManualTimeEntryDialog> {
  final _minutes = TextEditingController();
  final _description = TextEditingController();
  final ValueNotifier<bool> _billable = ValueNotifier(true);
  final ValueNotifier<bool> _saving = ValueNotifier(false);
  @override
  void dispose() {
    _minutes.dispose();
    _description.dispose();
    _billable.dispose();
    _saving.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return AnimatedBuilder(
      animation: Listenable.merge([_billable, _saving]),
      builder: (context, _) => WorkspaceCreationModalWrapper(
        title: l10n.taskDetailsTimeAdd,
        icon: Symbols.timer_rounded,
        accentColor: colors.primary,
        isSubmitting: _saving.value,
        submitLabel: l10n.save,
        cancelLabel: l10n.cancel,
        maxWidth: 440,
        onSubmit: _save,
        body: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.taskDetailsTimeMinutes,
              style: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h8,
            TextField(
              controller: _minutes,
              autofocus: true,
              keyboardType: TextInputType.number,
              enabled: !_saving.value,
              decoration: InputDecoration(
                hintText: l10n.taskDetailsTimeMinutes,
                border: const OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: const .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p12,
                ),
              ),
            ),
            Gaps.h12,
            Text(
              l10n.taskDetailsTimeDescription,
              style: context.text.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: colors.onSurfaceVariant,
              ),
            ),
            Gaps.h8,
            TextField(
              controller: _description,
              maxLines: 2,
              enabled: !_saving.value,
              decoration: InputDecoration(
                hintText: l10n.taskDetailsTimeDescription,
                border: const OutlineInputBorder(
                  borderRadius: .all(.circular(10)),
                ),
                contentPadding: const .symmetric(
                  horizontal: Sizes.p12,
                  vertical: Sizes.p12,
                ),
              ),
            ),
            Gaps.h12,
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.taskDetailsTimeBillable),
              value: _billable.value,
              onChanged: _saving.value
                  ? null
                  : (value) => _billable.value = value,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final duration = int.tryParse(_minutes.text.trim());
    if (duration == null || duration <= 0) return;
    _saving.value = true;
    final saved = await context.read<TaskTimeTrackingCubit>().create(
      CreateTaskTimeEntryPayload(
        durationMinutes: duration,
        description: _description.text.trim().isEmpty
            ? null
            : _description.text.trim(),
        isBillable: _billable.value,
      ),
    );
    if (mounted) {
      if (saved) {
        Navigator.of(context).pop();
      } else {
        _saving.value = false;
      }
    }
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

  static String durationLabel(int minutes) =>
      '${minutes ~/ 60}h ${minutes % 60}m';

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
