import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_recurrence_fields.dart';

class TaskRecurrenceForm extends StatefulWidget {
  const TaskRecurrenceForm({
    required this.task,
    required this.onChanged,
    required this.draft,
    super.key,
  });

  final ProjectTaskResponse task;
  final Future<void> Function() onChanged;
  final TaskDetailDraftRegistration? draft;

  @override
  State<TaskRecurrenceForm> createState() => TaskRecurrenceFormState();
}

class TaskRecurrenceFormState extends State<TaskRecurrenceForm> {
  late final TextEditingController _intervalController;
  late final TextEditingController _timeZoneController;
  late final ValueNotifier<TaskRecurrenceMode> _mode;
  late final ValueNotifier<TaskRecurrenceFrequency> _frequency;
  late final ValueNotifier<ProjectTaskStatus> _occurrenceStatus;
  late final ValueNotifier<bool> _skipIfPreviousOpen;
  late final ValueNotifier<DateTime?> _occurrenceAtUtc;
  late final Listenable _formChanges;

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
    _intervalController.addListener(_refreshDraft);
    _timeZoneController.addListener(_refreshDraft);
    _formChanges = Listenable.merge([
      _intervalController,
      _timeZoneController,
      _mode,
      _frequency,
      _occurrenceStatus,
      _skipIfPreviousOpen,
      _occurrenceAtUtc,
    ]);
  }

  void _refreshDraft() {
    final recurrence = widget.task.recurrence;
    final isDirty =
        _intervalController.text != '${recurrence?.interval ?? 1}' ||
        _timeZoneController.text != (recurrence?.timeZoneId ?? 'Etc/UTC') ||
        _mode.value != (recurrence?.mode ?? TaskRecurrenceMode.scheduled) ||
        _frequency.value !=
            (recurrence?.frequency ?? TaskRecurrenceFrequency.weekly) ||
        _occurrenceStatus.value !=
            (recurrence?.occurrenceStatus ?? ProjectTaskStatus.todo) ||
        _skipIfPreviousOpen.value != (recurrence?.skipIfPreviousOpen ?? true) ||
        _occurrenceAtUtc.value != recurrence?.nextOccurrenceAtUtc;
    if (isDirty) {
      widget.draft?.markDirty();
    } else {
      widget.draft?.clear();
    }
  }

  @override
  void dispose() {
    _intervalController.removeListener(_refreshDraft);
    _timeZoneController.removeListener(_refreshDraft);
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
    animation: _formChanges,
    builder: (context, _) =>
        BlocBuilder<TaskRecurrenceCubit, TaskRecurrenceState>(
          builder: (context, state) {
            if (state is TaskRecurrenceLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state case TaskRecurrenceFailure(
              :final message,
              :final apiError,
            )) {
              return TaskRecurrenceLoadFailure(
                message: message,
                apiError: apiError,
                isRetryBlocked: state.isRetryBlocked,
              );
            }
            final ready = state as TaskRecurrenceReady;
            final recurrenceCubit = context.read<TaskRecurrenceCubit>();
            final recurrence = ready.recurrence;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (ready.apiError case final error?) ...[
                    TaskDetailsModalError(
                      error: error,
                      fallbackMessage:
                          context.l10n.taskDetailsRecurrenceOperationFailed,
                    ),
                    const SizedBox(height: 12),
                  ] else if (ready.error != null) ...[
                    Text(
                      ready.error!,
                      style: TextStyle(color: context.colors.error),
                    ),
                    const SizedBox(height: 12),
                  ],
                  TaskRecurrenceFields(
                    mode: _mode.value,
                    frequency: _frequency.value,
                    intervalController: _intervalController,
                    timeZoneController: _timeZoneController,
                    timeZoneRepository: recurrenceCubit.repository,
                    timeZoneSelectionScope: recurrenceCubit,
                    workspaceId: widget.task.workspaceId,
                    projectId: widget.task.projectId,
                    occurrenceStatus: _occurrenceStatus.value,
                    skipIfPreviousOpen: _skipIfPreviousOpen.value,
                    occurrenceAtUtc: _occurrenceAtUtc.value,
                    recurrence: recurrence,
                    enabled: !ready.isSaving && !ready.isRetryBlocked,
                    onModeChanged: (value) {
                      _mode.value = value;
                      _refreshDraft();
                    },
                    onFrequencyChanged: (value) {
                      _frequency.value = value;
                      _refreshDraft();
                    },
                    onStatusChanged: (value) {
                      _occurrenceStatus.value = value;
                      _refreshDraft();
                    },
                    onSkipChanged: (value) {
                      _skipIfPreviousOpen.value = value;
                      _refreshDraft();
                    },
                    onDateChanged: (value) {
                      _occurrenceAtUtc.value = value;
                      _refreshDraft();
                    },
                    onTimeZoneChanged: (value) =>
                        _setTimeZone(value, recurrenceCubit),
                  ),
                  const SizedBox(height: 18),
                  if (recurrence != null) ...[
                    Row(
                      children: [
                        Tooltip(
                          message: context.l10n.tasksRecurrenceDelete,
                          child: IconButton.outlined(
                            onPressed: ready.isSaving || ready.isRetryBlocked
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
                            onPressed: ready.isSaving || ready.isRetryBlocked
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
                    onPressed: ready.isSaving || ready.isRetryBlocked
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
    if (interval == null || interval < 1 || timeZoneId.isEmpty) {
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
    if (!mounted) return;
    if (cubit.isClosed ||
        !identical(cubit, this.context.read<TaskRecurrenceCubit>())) {
      return;
    }
    if (saved) {
      widget.draft?.clear();
      await widget.onChanged();
    }
  }

  void _setTimeZone(String value, TaskRecurrenceCubit source) {
    if (!mounted ||
        source.isClosed ||
        source.workspaceId != widget.task.workspaceId ||
        source.projectId != widget.task.projectId ||
        source.taskId != widget.task.id ||
        !identical(source, context.read<TaskRecurrenceCubit>())) {
      return;
    }
    _timeZoneController.text = value;
    _refreshDraft();
  }

  Future<void> _toggleActive(BuildContext context) async {
    final cubit = context.read<TaskRecurrenceCubit>();
    final saved = await cubit.toggleActive();
    if (!mounted ||
        cubit.isClosed ||
        !identical(cubit, this.context.read<TaskRecurrenceCubit>())) {
      return;
    }
    if (saved) await widget.onChanged();
  }

  Future<void> _delete(BuildContext context) async {
    final cubit = context.read<TaskRecurrenceCubit>();
    final deleted = await cubit.delete();
    if (!mounted ||
        cubit.isClosed ||
        !identical(cubit, this.context.read<TaskRecurrenceCubit>())) {
      return;
    }
    if (deleted) {
      widget.draft?.clear();
      await widget.onChanged();
      if (mounted && context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }
}

class TaskRecurrenceLoadFailure extends StatelessWidget {
  const TaskRecurrenceLoadFailure({
    required this.message,
    this.apiError,
    this.isRetryBlocked = false,
    super.key,
  });
  final String message;
  final ApiError? apiError;
  final bool isRetryBlocked;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (apiError case final error?)
          TaskDetailsModalError(
            error: error,
            fallbackMessage: context.l10n.taskDetailsRecurrenceOperationFailed,
          )
        else
          Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: isRetryBlocked
              ? null
              : () => unawaited(
                  context.read<TaskRecurrenceCubit>().load(hasRecurrence: true),
                ),
          child: Text(context.l10n.taskDetailsRecurrenceRetry),
        ),
      ],
    ),
  );
}
