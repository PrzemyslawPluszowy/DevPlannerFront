part of 'task_details_page.dart';

class _TaskProperties extends StatelessWidget {
  const _TaskProperties({required this.details});

  final ProjectTaskDetailsResponse details;

  @override
  Widget build(BuildContext context) {
    final task = details.task;
    final users = {
      for (final user in details.includedUsers) user.coreUserId: user,
    };
    final assignees = task.assignees
        .map((item) => users[item.coreUserId]?.displayName ?? item.coreUserId)
        .join(', ');
    final dateFormat = DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return _Section(
      title: context.l10n.taskDetailsProperties,
      action: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: context.l10n.taskDetailsEditAssignees,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: _EditAssigneesDialog(task: task),
              ),
            ),
            icon: const Icon(Symbols.group_add, size: 20),
          ),
          IconButton(
            tooltip: context.l10n.taskDetailsEditPlanning,
            onPressed: () => showDialog<void>(
              context: context,
              builder: (_) => BlocProvider.value(
                value: context.read<TaskDetailsCubit>(),
                child: _EditPlanningDialog(task: task),
              ),
            ),
            icon: const Icon(Symbols.event_note, size: 20),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: context.colors.outlineVariant),
        ),
        child: Column(
          children: [
            _PropertyRow(
              icon: Symbols.people_outline_rounded,
              label: context.l10n.taskDetailsAssignees,
              value: assignees.isEmpty
                  ? context.l10n.taskDetailsNobody
                  : assignees,
            ),
            _PropertyRow(
              icon: Symbols.play_circle_rounded,
              label: context.l10n.taskDetailsStartDate,
              value: task.startAtUtc == null
                  ? context.l10n.taskDetailsNoDate
                  : dateFormat.format(task.startAtUtc!.toLocal()),
            ),
            _PropertyRow(
              icon: Symbols.calendar_today,
              label: context.l10n.taskDetailsDueDate,
              value: task.dueAtUtc == null
                  ? context.l10n.taskDetailsNoDueDate
                  : dateFormat.format(task.dueAtUtc!.toLocal()),
            ),
            _TaskMilestoneProperty(taskId: task.id),
            _PropertyRow(
              icon: Symbols.schedule,
              label: context.l10n.taskDetailsEstimate,
              value: task.estimatedMinutes == null
                  ? context.l10n.taskDetailsNoEstimate
                  : context.l10n.taskDetailsMinutes(task.estimatedMinutes!),
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child, this.action});

  final String title;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.text.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ?action,
        ],
      ),
      const SizedBox(height: 10),
      child,
    ],
  );
}

class _EditPlanningDialog extends StatefulWidget {
  const _EditPlanningDialog({required this.task});

  final ProjectTaskResponse task;

  @override
  State<_EditPlanningDialog> createState() => _EditPlanningDialogState();
}

class _EditPlanningDialogState extends State<_EditPlanningDialog> {
  late final TextEditingController _estimateController;
  DateTime? _startAtUtc;
  DateTime? _dueAtUtc;
  ScheduleCascadeResponse? _cascadePreview;
  String? _validationMessage;
  var _saving = false;
  var _previewingCascade = false;

  @override
  void initState() {
    super.initState();
    _startAtUtc = widget.task.startAtUtc;
    _dueAtUtc = widget.task.dueAtUtc;
    _estimateController = TextEditingController(
      text: widget.task.estimatedMinutes?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _estimateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat.yMMMd(
      Localizations.localeOf(context).toLanguageTag(),
    );
    return WorkspaceCreationModalWrapper(
      title: context.l10n.taskDetailsEditPlanning,
      icon: Symbols.calendar_month_rounded,
      accentColor: context.colors.primary,
      isSubmitting: _saving,
      submitLabel: context.l10n.save,
      cancelLabel: context.l10n.cancel,
      onSubmit: _previewingCascade ? () {} : _save,
      additionalActions: [
        OutlinedButton.icon(
          onPressed: _saving || _previewingCascade ? null : _previewCascade,
          icon: _previewingCascade
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Symbols.visibility),
          label: Text(context.l10n.taskDetailsCascadePreview),
        ),
        if (_cascadePreview != null) ...[
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: _saving ? null : _applyCascade,
            icon: _saving
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
              value: _startAtUtc,
              format: format,
              enabled: !_saving,
              onChanged: (value) => setState(() {
                _startAtUtc = value;
                _cascadePreview = null;
                _validationMessage = null;
              }),
            ),
            const SizedBox(height: 12),
            _DateField(
              label: context.l10n.taskDetailsDueDate,
              value: _dueAtUtc,
              format: format,
              enabled: !_saving,
              onChanged: (value) => setState(() {
                _dueAtUtc = value;
                _cascadePreview = null;
                _validationMessage = null;
              }),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _estimateController,
              enabled: !_saving,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: context.l10n.taskDetailsEstimateMinutes,
                suffixText: 'min',
              ),
            ),
            if (_validationMessage case final message?) ...[
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
            if (_cascadePreview case final preview?) ...[
              const SizedBox(height: 18),
              _CascadePreview(
                preview: preview,
                format: format,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final estimateText = _estimateController.text.trim();
    final estimate = estimateText.isEmpty ? null : int.tryParse(estimateText);
    if ((estimateText.isNotEmpty && estimate == null) ||
        (estimate != null && estimate <= 0)) {
      setState(
        () => _validationMessage = context.l10n.taskDetailsInvalidEstimate,
      );
      return;
    }
    if (_startAtUtc != null &&
        _dueAtUtc != null &&
        _dueAtUtc!.isBefore(_startAtUtc!)) {
      setState(
        () => _validationMessage = context.l10n.taskDetailsInvalidDateRange,
      );
      return;
    }
    setState(() => _saving = true);
    final saved = await context.read<TaskDetailsCubit>().updatePlanning(
      startAtUtc: _startAtUtc,
      dueAtUtc: _dueAtUtc,
      estimatedMinutes: estimate,
    );
    if (!mounted) return;
    if (saved) {
      Navigator.of(context).pop();
    } else {
      setState(() => _saving = false);
    }
  }

  Future<void> _previewCascade() async {
    if (!_validateDateRange()) return;
    if (_startAtUtc == null || _dueAtUtc == null) {
      setState(
        () => _validationMessage = context.l10n.taskDetailsCascadeDatesRequired,
      );
      return;
    }
    setState(() {
      _previewingCascade = true;
      _validationMessage = null;
    });
    final result = await context.read<TaskScheduleRepository>().previewCascade(
      workspaceId: context.read<TaskDetailsCubit>().workspaceId,
      projectId: context.read<TaskDetailsCubit>().projectId,
      payload: PreviewScheduleCascadePayload(
        taskId: widget.task.id,
        newStartAtUtc: _startAtUtc!,
        newDueAtUtc: _dueAtUtc!,
      ),
    );
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _previewingCascade = false;
        _validationMessage = error.message;
      }),
      (preview) => setState(() {
        _previewingCascade = false;
        _cascadePreview = preview;
      }),
    );
  }

  Future<void> _applyCascade() async {
    final preview = _cascadePreview;
    if (preview == null || !_validateDateRange()) return;
    if (_startAtUtc == null || _dueAtUtc == null) return;
    setState(() => _saving = true);
    final result = await context.read<TaskScheduleRepository>().applyCascade(
      workspaceId: context.read<TaskDetailsCubit>().workspaceId,
      projectId: context.read<TaskDetailsCubit>().projectId,
      payload: ApplyScheduleCascadePayload(
        taskId: widget.task.id,
        newStartAtUtc: _startAtUtc!,
        newDueAtUtc: _dueAtUtc!,
        expectedTaskVersions: {
          for (final shift in preview.dateShifts)
            shift.taskId: shift.expectedVersion,
        },
      ),
    );
    if (!mounted) return;
    result.fold(
      (error) => setState(() {
        _saving = false;
        _validationMessage = error.message;
      }),
      (_) async {
        await context.read<TaskDetailsCubit>().load();
        if (mounted) Navigator.of(context).pop();
      },
    );
  }

  bool _validateDateRange() {
    if (_startAtUtc != null &&
        _dueAtUtc != null &&
        _dueAtUtc!.isBefore(_startAtUtc!)) {
      setState(
        () => _validationMessage = context.l10n.taskDetailsInvalidDateRange,
      );
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
