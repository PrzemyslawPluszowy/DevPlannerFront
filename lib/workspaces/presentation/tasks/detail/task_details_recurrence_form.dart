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
  late TaskRecurrenceMode _mode;
  late TaskRecurrenceFrequency _frequency;
  late ProjectTaskStatus _occurrenceStatus;
  late bool _skipIfPreviousOpen;
  DateTime? _occurrenceAtUtc;

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
    _mode = recurrence?.mode ?? TaskRecurrenceMode.scheduled;
    _frequency = recurrence?.frequency ?? TaskRecurrenceFrequency.weekly;
    _occurrenceStatus = recurrence?.occurrenceStatus ?? ProjectTaskStatus.todo;
    _skipIfPreviousOpen = recurrence?.skipIfPreviousOpen ?? true;
    _occurrenceAtUtc = recurrence?.nextOccurrenceAtUtc;
  }

  @override
  void dispose() {
    _intervalController.dispose();
    _timeZoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) => BlocBuilder<TaskRecurrenceCubit, TaskRecurrenceState>(
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
              Text(ready.error!, style: TextStyle(color: context.colors.error)),
              const SizedBox(height: 12),
            ],
            _TaskRecurrenceFields(
              mode: _mode,
              frequency: _frequency,
              intervalController: _intervalController,
              timeZoneController: _timeZoneController,
              occurrenceStatus: _occurrenceStatus,
              skipIfPreviousOpen: _skipIfPreviousOpen,
              occurrenceAtUtc: _occurrenceAtUtc,
              recurrence: recurrence,
              enabled: !ready.isSaving,
              onModeChanged: (value) => setState(() => _mode = value),
              onFrequencyChanged: (value) => setState(() => _frequency = value),
              onStatusChanged: (value) =>
                  setState(() => _occurrenceStatus = value),
              onSkipChanged: (value) =>
                  setState(() => _skipIfPreviousOpen = value),
              onDateChanged: (value) =>
                  setState(() => _occurrenceAtUtc = value),
            ),
            const SizedBox(height: 18),
            if (recurrence != null) ...[
              Row(
                children: [
                  Tooltip(
                    message: context.l10n.tasksRecurrenceDelete,
                    child: IconButton.outlined(
                      onPressed: ready.isSaving ? null : () => _delete(context),
                      style: IconButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        foregroundColor: context.colors.error,
                        side: BorderSide(
                          color: context.colors.error.withValues(alpha: .5),
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
              mode: _mode,
              frequency: _frequency,
              interval: interval,
              timeZoneId: timeZoneId,
              firstOccurrenceAtUtc: _occurrenceAtUtc,
              expectedVersion: widget.task.version,
              occurrenceStatus: _occurrenceStatus,
              skipIfPreviousOpen: _skipIfPreviousOpen,
            ),
          )
        : await cubit.update(
            UpdateTaskRecurrencePayload(
              mode: _mode,
              frequency: _frequency,
              interval: interval,
              timeZoneId: timeZoneId,
              nextOccurrenceAtUtc: _occurrenceAtUtc,
              occurrenceStatus: _occurrenceStatus,
              skipIfPreviousOpen: _skipIfPreviousOpen,
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

String _recurrenceModeLabel(BuildContext context, TaskRecurrenceMode mode) =>
    switch (mode) {
      TaskRecurrenceMode.scheduled =>
        context.l10n.taskDetailsRecurrenceModeScheduled,
      TaskRecurrenceMode.afterCompletion =>
        context.l10n.taskDetailsRecurrenceModeAfterCompletion,
    };
