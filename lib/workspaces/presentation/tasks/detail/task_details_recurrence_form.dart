part of 'task_details_page.dart';

class _TaskRecurrenceForm extends StatefulWidget {
  const _TaskRecurrenceForm({required this.task, required this.onChanged});

  final ProjectTaskResponse task;
  final Future<void> Function() onChanged;

  @override
  State<_TaskRecurrenceForm> createState() => _TaskRecurrenceFormState();
}

class _TaskRecurrenceFormState extends State<_TaskRecurrenceForm> {
  late final TextEditingController _intervalController;
  late final TextEditingController _timeZoneController;
  late final ValueNotifier<TaskRecurrenceMode> _mode;
  late final ValueNotifier<TaskRecurrenceFrequency> _frequency;
  late final ValueNotifier<ProjectTaskStatus> _occurrenceStatus;
  late final ValueNotifier<bool> _skipIfPreviousOpen;
  late final ValueNotifier<DateTime?> _occurrenceAtUtc;

  @override
  void initState() {
    super.initState();
    final recurrence = widget.task.recurrence;
    _intervalController = TextEditingController(
      text: '${recurrence?.interval ?? 1}',
    );
    _timeZoneController = TextEditingController(
      text: recurrence?.timeZoneId ?? 'Etc/UTC',
    );
    _mode = ValueNotifier(recurrence?.mode ?? TaskRecurrenceMode.scheduled);
    _frequency = ValueNotifier(
      recurrence?.frequency ?? TaskRecurrenceFrequency.weekly,
    );
    _occurrenceStatus = ValueNotifier(
      recurrence?.occurrenceStatus ?? ProjectTaskStatus.todo,
    );
    _skipIfPreviousOpen = ValueNotifier(recurrence?.skipIfPreviousOpen ?? true);
    _occurrenceAtUtc = ValueNotifier(recurrence?.nextOccurrenceAtUtc);
  }

  @override
  void dispose() {
    _intervalController.dispose();
    _timeZoneController.dispose();
    _mode.dispose();
    _frequency.dispose();
    _occurrenceStatus.dispose();
    _skipIfPreviousOpen.dispose();
    _occurrenceAtUtc.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) => AnimatedBuilder(
    animation: Listenable.merge([
      _mode,
      _frequency,
      _occurrenceStatus,
      _skipIfPreviousOpen,
      _occurrenceAtUtc,
    ]),
    builder: (context, _) =>
        BlocBuilder<TaskRecurrenceCubit, TaskRecurrenceState>(
          builder: (context, state) {
            if (state is TaskRecurrenceLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state case TaskRecurrenceFailure(:final message)) {
              return _TaskRecurrenceLoadFailure(message: message);
            }
            final ready = state as TaskRecurrenceReady;
            final recurrence = ready.recurrence;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (ready.error != null) ...[
                    Text(
                      ready.error!,
                      style: TextStyle(color: context.colors.error),
                    ),
                    const SizedBox(height: 12),
                  ],
                  _TaskRecurrenceFields(
                    mode: _mode.value,
                    frequency: _frequency.value,
                    intervalController: _intervalController,
                    timeZoneController: _timeZoneController,
                    occurrenceStatus: _occurrenceStatus.value,
                    skipIfPreviousOpen: _skipIfPreviousOpen.value,
                    occurrenceAtUtc: _occurrenceAtUtc.value,
                    recurrence: recurrence,
                    enabled: !ready.isSaving,
                    onModeChanged: (value) => _mode.value = value,
                    onFrequencyChanged: (value) => _frequency.value = value,
                    onStatusChanged: (value) => _occurrenceStatus.value = value,
                    onSkipChanged: (value) => _skipIfPreviousOpen.value = value,
                    onDateChanged: (value) => _occurrenceAtUtc.value = value,
                  ),
                  const SizedBox(height: 18),
                  if (recurrence != null) ...[
                    Row(
                      children: [
                        Tooltip(
                          message: context.l10n.tasksRecurrenceDelete,
                          child: IconButton.outlined(
                            onPressed: ready.isSaving
                                ? null
                                : () => _delete(context),
                            style: IconButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              foregroundColor: context.colors.error,
                              side: BorderSide(
                                color: context.colors.error.withValues(
                                  alpha: .5,
                                ),
                              ),
                            ),
                            icon: const Icon(Symbols.delete_outline_rounded),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: ready.isSaving
                                ? null
                                : () => _toggleActive(context),
                            icon: Icon(
                              recurrence.isActive
                                  ? Symbols.pause_rounded
                                  : Symbols.play_arrow_rounded,
                            ),
                            label: Text(
                              recurrence.isActive
                                  ? context.l10n.taskDetailsRecurrencePause
                                  : context.l10n.taskDetailsRecurrenceResume,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: ready.isSaving
                        ? null
                        : () => _save(context, recurrence),
                    child: ready.isSaving
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            recurrence == null
                                ? context.l10n.taskDetailsRecurrenceCreate
                                : context.l10n.save,
                          ),
                  ),
                ],
              ),
            );
          },
        ),
  );

  Future<void> _save(
    BuildContext context,
    TaskRecurrenceResponse? recurrence,
  ) async {
    final interval = int.tryParse(_intervalController.text.trim());
    final timeZoneId = _timeZoneController.text.trim();
    if (interval == null ||
        interval < 1 ||
        timeZoneId.isEmpty ||
        !timeZoneId.contains('/')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.taskDetailsRecurrenceInvalid)),
      );
      return;
    }
    final cubit = context.read<TaskRecurrenceCubit>();
    final saved = recurrence == null
        ? await cubit.create(
            CreateTaskRecurrencePayload(
              mode: _mode.value,
              frequency: _frequency.value,
              interval: interval,
              timeZoneId: timeZoneId,
              firstOccurrenceAtUtc: _occurrenceAtUtc.value,
              expectedVersion: widget.task.version,
              occurrenceStatus: _occurrenceStatus.value,
              skipIfPreviousOpen: _skipIfPreviousOpen.value,
            ),
          )
        : await cubit.update(
            UpdateTaskRecurrencePayload(
              mode: _mode.value,
              frequency: _frequency.value,
              interval: interval,
              timeZoneId: timeZoneId,
              nextOccurrenceAtUtc: _occurrenceAtUtc.value,
              occurrenceStatus: _occurrenceStatus.value,
              skipIfPreviousOpen: _skipIfPreviousOpen.value,
              expectedVersion: recurrence.version,
            ),
          );
    if (saved && mounted) await widget.onChanged();
  }

  Future<void> _toggleActive(BuildContext context) async {
    final saved = await context.read<TaskRecurrenceCubit>().toggleActive();
    if (saved && mounted) await widget.onChanged();
  }

  Future<void> _delete(BuildContext context) async {
    final deleted = await context.read<TaskRecurrenceCubit>().delete();
    if (deleted && mounted) {
      await widget.onChanged();
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class _TaskRecurrenceLoadFailure extends StatelessWidget {
  const _TaskRecurrenceLoadFailure({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => unawaited(
            context.read<TaskRecurrenceCubit>().load(hasRecurrence: true),
          ),
          child: Text(context.l10n.taskDetailsRecurrenceRetry),
        ),
      ],
    ),
  );
}

/// Lokalizuje tryb reguły cykliczności w formularzu zadania.
final class TaskRecurrenceModeLabeler {
  const TaskRecurrenceModeLabeler._();

  static String label(BuildContext context, TaskRecurrenceMode value) =>
      switch (value) {
        TaskRecurrenceMode.scheduled =>
          context.l10n.taskDetailsRecurrenceModeScheduled,
        TaskRecurrenceMode.afterCompletion =>
          context.l10n.taskDetailsRecurrenceModeAfterCompletion,
      };
}
