part of 'task_details_page.dart';

class _EditPlanningDialog extends StatefulWidget {
  const _EditPlanningDialog({required this.task});

  final ProjectTaskResponse task;

  @override
  State<_EditPlanningDialog> createState() => _EditPlanningDialogState();
}

class _EditPlanningDialogState extends State<_EditPlanningDialog> {
  late final TextEditingController _estimateController;
  late final ValueNotifier<DateTime?> _startAtUtc;
  late final ValueNotifier<DateTime?> _dueAtUtc;
  final ValueNotifier<ScheduleCascadeResponse?> _cascadePreview = ValueNotifier(
    null,
  );
  final ValueNotifier<String?> _validationMessage = ValueNotifier(null);
  final ValueNotifier<bool> _saving = ValueNotifier(false);
  final ValueNotifier<bool> _previewingCascade = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _startAtUtc = ValueNotifier(widget.task.startAtUtc);
    _dueAtUtc = ValueNotifier(widget.task.dueAtUtc);
    _estimateController = TextEditingController(
      text: widget.task.estimatedMinutes?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _estimateController.dispose();
    _startAtUtc.dispose();
    _dueAtUtc.dispose();
    _cascadePreview.dispose();
    _validationMessage.dispose();
    _saving.dispose();
    _previewingCascade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return AnimatedBuilder(
      animation: Listenable.merge([
        _startAtUtc,
        _dueAtUtc,
        _cascadePreview,
        _validationMessage,
        _saving,
        _previewingCascade,
      ]),
      builder: (context, _) => WorkspaceCreationModalWrapper(
        title: context.l10n.taskDetailsEditPlanning,
        icon: Symbols.calendar_month_rounded,
        accentColor: context.colors.primary,
        isSubmitting: _saving.value,
        submitLabel: context.l10n.save,
        cancelLabel: context.l10n.cancel,
        onSubmit: _previewingCascade.value ? () {} : _save,
        additionalActions: [
          OutlinedButton.icon(
            onPressed: _saving.value || _previewingCascade.value
                ? null
                : _previewCascade,
            icon: _previewingCascade.value
                ? const SizedBox.square(
                    dimension: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Symbols.visibility),
            label: Text(context.l10n.taskDetailsCascadePreview),
          ),
          if (_cascadePreview.value != null) ...[
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _saving.value ? null : _applyCascade,
              icon: _saving.value
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
              _DateField(
                label: context.l10n.taskDetailsStartDate,
                value: _startAtUtc.value,
                format: format,
                enabled: !_saving.value,
                onChanged: (value) {
                  _startAtUtc.value = value;
                  _cascadePreview.value = null;
                  _validationMessage.value = null;
                },
              ),
              const SizedBox(height: 12),
              _DateField(
                label: context.l10n.taskDetailsDueDate,
                value: _dueAtUtc.value,
                format: format,
                enabled: !_saving.value,
                onChanged: (value) {
                  _dueAtUtc.value = value;
                  _cascadePreview.value = null;
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
              if (_validationMessage.value case final message?) ...[
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
              if (_cascadePreview.value case final preview?) ...[
                const SizedBox(height: 18),
                _CascadePreview(preview: preview, format: format),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
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
    final saved = await context.read<TaskDetailsCubit>().updatePlanning(
      startAtUtc: _startAtUtc.value,
      dueAtUtc: _dueAtUtc.value,
      estimatedMinutes: estimate,
    );
    if (!mounted) return;
    if (saved) {
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
    _previewingCascade.value = true;
    _validationMessage.value = null;
    final result = await context.read<TaskScheduleRepository>().previewCascade(
      workspaceId: context.read<TaskDetailsCubit>().workspaceId,
      projectId: context.read<TaskDetailsCubit>().projectId,
      payload: PreviewScheduleCascadePayload(
        taskId: widget.task.id,
        newStartAtUtc: _startAtUtc.value!,
        newDueAtUtc: _dueAtUtc.value!,
      ),
    );
    if (!mounted) return;
    result.fold(
      (error) {
        _previewingCascade.value = false;
        _validationMessage.value = error.message;
      },
      (preview) {
        _previewingCascade.value = false;
        _cascadePreview.value = preview;
      },
    );
  }

  Future<void> _applyCascade() async {
    final preview = _cascadePreview.value;
    if (preview == null || !_validateDateRange()) return;
    if (_startAtUtc.value == null || _dueAtUtc.value == null) return;
    _saving.value = true;
    final result = await context.read<TaskScheduleRepository>().applyCascade(
      workspaceId: context.read<TaskDetailsCubit>().workspaceId,
      projectId: context.read<TaskDetailsCubit>().projectId,
      payload: ApplyScheduleCascadePayload(
        taskId: widget.task.id,
        newStartAtUtc: _startAtUtc.value!,
        newDueAtUtc: _dueAtUtc.value!,
        expectedTaskVersions: {
          for (final shift in preview.dateShifts)
            shift.taskId: shift.expectedVersion,
        },
      ),
    );
    if (!mounted) return;
    result.fold(
      (error) {
        _saving.value = false;
        _validationMessage.value = error.message;
      },
      (_) => unawaited(_reloadAfterCascade()),
    );
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

class _CascadePreview extends StatelessWidget {
  const _CascadePreview({required this.preview, required this.format});

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
