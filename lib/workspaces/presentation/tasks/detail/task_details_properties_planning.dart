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
          additionalActions: [
            OutlinedButton.icon(
              onPressed: _saving.value || cascade.isBusy
                  ? null
                  : _previewCascade,
              icon: cascade.isPreviewing
                  ? const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Symbols.visibility),
              label: Text(context.l10n.taskDetailsCascadePreview),
            ),
            if (cascade.preview != null) ...[
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: cascade.isApplying ? null : _applyCascade,
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
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const TaskDetailsDialogMutationError(),
                DateField(
                  label: context.l10n.taskDetailsStartDate,
                  value: _startAtUtc.value,
                  format: format,
                  enabled: !_saving.value,
                  onChanged: (value) {
                    _startAtUtc.value = value;
                    _refreshDraft();
                    _cascadeCubit.clearPreview();
                    _validationMessage.value = null;
                  },
                ),
                const SizedBox(height: 12),
                DateField(
                  label: context.l10n.taskDetailsDueDate,
                  value: _dueAtUtc.value,
                  format: format,
                  enabled: !_saving.value,
                  onChanged: (value) {
                    _dueAtUtc.value = value;
                    _refreshDraft();
                    _cascadeCubit.clearPreview();
                    _validationMessage.value = null;
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _estimateController,
                  enabled: !_saving.value,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: context.l10n.taskDetailsEstimateMinutes,
                    suffixText: 'min',
                  ),
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
    );
  }

  Future<void> _applyCascade() async {
    if (!_validateDateRange()) return;
    if (_startAtUtc.value == null || _dueAtUtc.value == null) return;
    final applied = await _cascadeCubit.apply(
      taskId: widget.task.id,
      newStartAtUtc: _startAtUtc.value!,
      newDueAtUtc: _dueAtUtc.value!,
    );
    if (!mounted || !applied) return;
    _draft?.clear();
    await _reloadAfterCascade();
  }

  Future<void> _reloadAfterCascade() async {
    await context.read<TaskDetailsCubit>().load();
    if (mounted) Navigator.of(context).pop();
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

class CascadePreview extends StatelessWidget {
  const CascadePreview({
    required this.preview,
    required this.format,
    super.key,
  });

  final ScheduleCascadeResponse preview;
  final DateFormat format;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.colors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: context.colors.outlineVariant),
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.taskDetailsCascadeChanges,
            style: context.text.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            context.l10n.taskDetailsCascadePreviewDescription,
            style: context.text.bodySmall,
          ),
          const SizedBox(height: 8),
          if (preview.dateShifts.isEmpty)
            Text(context.l10n.taskDetailsCascadeNoChanges)
          else
            ...preview.dateShifts.map(
              (shift) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      shift.isOnCriticalPath
                          ? Symbols.warning_amber_rounded
                          : Symbols.calendar_month,
                      size: 18,
                      color: shift.isOnCriticalPath
                          ? context.colors.error
                          : context.colors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: '${shift.title}\n',
                          style: context.text.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '${format.format(shift.proposedStartAtUtc.toLocal())} – ${format.format(shift.proposedDueAtUtc.toLocal())}',
                              style: context.text.bodySmall?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            if (shift.isOnCriticalPath)
                              TextSpan(
                                text:
                                    ' · ${context.l10n.taskDetailsCascadeCritical}',
                                style: context.text.bodySmall?.copyWith(
                                  color: context.colors.error,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}
