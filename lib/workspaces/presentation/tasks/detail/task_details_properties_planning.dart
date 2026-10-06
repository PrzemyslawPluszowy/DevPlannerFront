import 'package:devplanner/foundation/platform/calendar_time_zone.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cascade/task_schedule_cascade_preview.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_dialog_mutation_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';

class EditPlanningDialog extends StatefulWidget {
  const EditPlanningDialog({required this.task, super.key});

  final ProjectTaskResponse task;

  @override
  State<EditPlanningDialog> createState() => EditPlanningDialogState();
}

class EditPlanningDialogState extends State<EditPlanningDialog> {
  TaskDetailDraftRegistration? _draft;
  late final TextEditingController _estimateController;
  late final ValueNotifier<DateTime?> _startAtUtc;
  late final ValueNotifier<DateTime?> _dueAtUtc;
  final ValueNotifier<String?> _validationMessage = ValueNotifier(null);
  final ValueNotifier<bool> _saving = ValueNotifier(false);
  late final Listenable _formChanges;
  int _draftGeneration = 0;
  bool _cascadeApplied = false;

  /// Podgląd i zapis kaskady mają własny stan: widget tylko przekazuje daty.
  late final TaskScheduleCascadeCubit _cascadeCubit;

  @override
  void initState() {
    super.initState();
    _startAtUtc = ValueNotifier(widget.task.startAtUtc);
    _dueAtUtc = ValueNotifier(widget.task.dueAtUtc);
    _estimateController = TextEditingController(
      text: widget.task.estimatedMinutes?.toString() ?? '',
    );
    final detailsCubit = context.read<TaskDetailsCubit>();
    _cascadeCubit = TaskScheduleCascadeCubit(
      repository: context.read<TaskScheduleRepository>(),
      workspaceId: detailsCubit.workspaceId,
      projectId: detailsCubit.projectId,
      calendarTimeZoneId: const CalendarTimeZone().read(),
      canEdit: () => switch (detailsCubit.state) {
        TaskDetailsReady(:final canEdit) => canEdit,
        _ => false,
      },
      onAccessLost: (error) => unawaited(detailsCubit.reportAccessLost(error)),
    );
    _estimateController.addListener(_refreshDraft);
    _formChanges = Listenable.merge([
      _startAtUtc,
      _dueAtUtc,
      _validationMessage,
      _saving,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsEditPlanning,
    );
  }

  void _refreshDraft() {
    _draftGeneration++;
    _cascadeCubit.clearPreview();
    final task = widget.task;
    final estimateText = _estimateController.text.trim();
    final originalEstimate = task.estimatedMinutes?.toString() ?? '';
    final isDirty =
        _startAtUtc.value != task.startAtUtc ||
        _dueAtUtc.value != task.dueAtUtc ||
        estimateText != originalEstimate;
    if (isDirty) {
      _draft?.markDirty();
    } else {
      _draft?.clear();
    }
  }

  @override
  void dispose() {
    _draft?.dispose();
    _estimateController.removeListener(_refreshDraft);
    _estimateController.dispose();
    _startAtUtc.dispose();
    _dueAtUtc.dispose();
    _validationMessage.dispose();
    _saving.dispose();
    unawaited(_cascadeCubit.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return BlocConsumer<TaskScheduleCascadeCubit, TaskScheduleCascadeState>(
      bloc: _cascadeCubit,
      listener: (context, cascade) {
        final error = cascade.error;
        if (error != null && cascade.apiError == null) {
          _validationMessage.value = error;
        }
      },
      builder: (context, cascade) => AnimatedBuilder(
        animation: _formChanges,
        builder: (context, _) => WorkspaceCreationModalWrapper(
          title: context.l10n.taskDetailsEditPlanning,
          icon: Symbols.calendar_month_rounded,
          accentColor: context.colors.primary,
          isSubmitting: _saving.value || cascade.isApplying,
          submitLabel: context.l10n.save,
          cancelLabel: context.l10n.cancel,
          onBeforeClose: () => TaskDetailEditorCloseGuard.canClose(
            context,
            _draft,
          ),
          onSubmit: cascade.isPreviewing ? () {} : _save,
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TaskDetailsDialogMutationError(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.l10n.taskDetailsCascadeExplanation,
                    style: context.text.bodySmall,
                  ),
                ),
                const SizedBox(height: 12),
                DateField(
                  label: context.l10n.taskDetailsStartDate,
                  value: _startAtUtc.value,
                  format: format,
                  enabled:
                      !_saving.value && !cascade.isApplying && !_cascadeApplied,
                  onChanged: (value) {
                    _startAtUtc.value = value;
                    _refreshDraft();
                    _validationMessage.value = null;
                  },
                ),
                const SizedBox(height: 12),
                DateField(
                  label: context.l10n.taskDetailsDueDate,
                  value: _dueAtUtc.value,
                  format: format,
                  enabled:
                      !_saving.value && !cascade.isApplying && !_cascadeApplied,
                  onChanged: (value) {
                    _dueAtUtc.value = value;
                    _refreshDraft();
                    _validationMessage.value = null;
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _estimateController,
                  enabled: !_saving.value && !cascade.isApplying,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: context.l10n.taskDetailsEstimateMinutes,
                    suffixText: 'min',
                  ),
                ),
                const SizedBox(height: 12),
                _PlanningCascadeActions(
                  cascade: cascade,
                  isSaving: _saving.value,
                  isApplied: _cascadeApplied,
                  onPreview: _previewCascade,
                  onApply: _applyCascade,
                ),
                if (cascade.apiError case final error?) ...[
                  TaskDetailsModalError(error: error),
                  const SizedBox(height: 12),
                ] else if (_validationMessage.value case final message?) ...[
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      message,
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.error,
                      ),
                    ),
                  ),
                ],
                if (cascade.preview case final preview?) ...[
                  const SizedBox(height: 18),
                  CascadePreview(preview: preview, format: format),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (_saving.value || _cascadeCubit.state.isBusy) return;
    final estimateText = _estimateController.text.trim();
    final estimate = estimateText.isEmpty ? null : int.tryParse(estimateText);
    if ((estimateText.isNotEmpty && estimate == null) ||
        (estimate != null && estimate <= 0)) {
      _validationMessage.value = context.l10n.taskDetailsInvalidEstimate;
      return;
    }
    if (_startAtUtc.value != null &&
        _dueAtUtc.value != null &&
        _dueAtUtc.value!.isBefore(_startAtUtc.value!)) {
      _validationMessage.value = context.l10n.taskDetailsInvalidDateRange;
      return;
    }
    _saving.value = true;
    final source = context.read<TaskDetailsCubit>();
    if (_cascadeApplied) {
      await _completeAppliedCascade(source, estimate);
      return;
    }
    final saved = await source.updatePlanning(
      startAtUtc: _startAtUtc.value,
      dueAtUtc: _dueAtUtc.value,
      estimatedMinutes: estimate,
    );
    if (!mounted) return;
    if (source.isClosed ||
        !identical(source, context.read<TaskDetailsCubit>())) {
      _saving.value = false;
      return;
    }
    if (saved) {
      _draft?.clear();
      Navigator.of(context).pop();
    } else {
      _saving.value = false;
    }
  }

  Future<void> _previewCascade() async {
    if (!_validateDateRange()) return;
    if (_startAtUtc.value == null || _dueAtUtc.value == null) {
      _validationMessage.value = context.l10n.taskDetailsCascadeDatesRequired;
      return;
    }
    _validationMessage.value = null;
    await _cascadeCubit.preview(
      taskId: widget.task.id,
      newStartAtUtc: _startAtUtc.value!,
      newDueAtUtc: _dueAtUtc.value!,
      draftGeneration: _draftGeneration,
    );
  }

  Future<void> _applyCascade() async {
    if (_saving.value || _cascadeCubit.state.isBusy || _cascadeApplied) return;
    if (!_validateDateRange()) return;
    if (_startAtUtc.value == null || _dueAtUtc.value == null) return;
    final estimateText = _estimateController.text.trim();
    final estimate = estimateText.isEmpty ? null : int.tryParse(estimateText);
    if ((estimateText.isNotEmpty && estimate == null) ||
        (estimate != null && estimate <= 0)) {
      _validationMessage.value = context.l10n.taskDetailsInvalidEstimate;
      return;
    }
    final source = context.read<TaskDetailsCubit>();
    final generation = _draftGeneration;
    _saving.value = true;
    _validationMessage.value = null;
    final applied = await _cascadeCubit.apply(
      taskId: widget.task.id,
      newStartAtUtc: _startAtUtc.value!,
      newDueAtUtc: _dueAtUtc.value!,
      draftGeneration: generation,
    );
    if (!mounted) return;
    if (!applied) {
      _saving.value = false;
      return;
    }
    _cascadeApplied = true;
    if (generation != _draftGeneration ||
        source.isClosed ||
        !identical(source, context.read<TaskDetailsCubit>())) {
      _saving.value = false;
      _validationMessage.value = context.l10n.taskDetailsCascadeEstimatePending;
      return;
    }
    await _completeAppliedCascade(source, estimate);
  }

  Future<void> _completeAppliedCascade(
    TaskDetailsCubit source,
    int? estimate,
  ) async {
    await source.load();
    if (!mounted) return;
    if (source.isClosed ||
        !identical(source, context.read<TaskDetailsCubit>())) {
      _saving.value = false;
      _validationMessage.value = context.l10n.taskDetailsCascadeEstimatePending;
      return;
    }
    final current = source.state;
    if (current is! TaskDetailsReady ||
        current.details.task.id != widget.task.id ||
        !current.canEdit) {
      _saving.value = false;
      _validationMessage.value = context.l10n.taskDetailsCascadeEstimatePending;
      return;
    }
    final task = current.details.task;
    // Daty pochodzą z zapisanego wyniku kaskady, a wersja z aktualnego odczytu.
    final saved =
        estimate == widget.task.estimatedMinutes ||
        estimate == task.estimatedMinutes ||
        await source.updatePlanning(
          startAtUtc: task.startAtUtc,
          dueAtUtc: task.dueAtUtc,
          estimatedMinutes: estimate,
        );
    if (!mounted) return;
    if (!saved ||
        source.isClosed ||
        !identical(source, context.read<TaskDetailsCubit>())) {
      _saving.value = false;
      _validationMessage.value = context.l10n.taskDetailsCascadeEstimatePending;
      return;
    }
    _draft?.clear();
    Navigator.of(context).pop();
  }

  bool _validateDateRange() {
    if (_startAtUtc.value != null &&
        _dueAtUtc.value != null &&
        _dueAtUtc.value!.isBefore(_startAtUtc.value!)) {
      _validationMessage.value = context.l10n.taskDetailsInvalidDateRange;
      return false;
    }
    return true;
  }
}

final class _PlanningCascadeActions extends StatelessWidget {
  const _PlanningCascadeActions({
    required this.cascade,
    required this.isSaving,
    required this.isApplied,
    required this.onPreview,
    required this.onApply,
  });
  final TaskScheduleCascadeState cascade;
  final bool isSaving;
  final bool isApplied;
  final VoidCallback onPreview;
  final VoidCallback onApply;
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        Tooltip(
          message: context.l10n.taskDetailsCascadeExplanation,
          child: OutlinedButton.icon(
            onPressed: isSaving || cascade.isBusy || isApplied
                ? null
                : onPreview,
            icon: cascade.isPreviewing
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Symbols.visibility),
            label: Text(context.l10n.taskDetailsCascadePreview),
          ),
        ),
        if (cascade.preview != null) ...[
          FilledButton.icon(
            onPressed: isSaving || cascade.isBusy ? null : onApply,
            icon: cascade.isApplying
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Symbols.account_tree),
            label: Text(context.l10n.taskDetailsCascadeApply),
          ),
        ],
      ],
    ),
  );
}
