import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/time_tracking/task_time_entry_error_banner.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
import 'package:flutter/services.dart';

class ManualTimeEntryDialog extends StatefulWidget {
  const ManualTimeEntryDialog({super.key});
  @override
  State<ManualTimeEntryDialog> createState() => ManualTimeEntryDialogState();
}

class ManualTimeEntryDialogState extends State<ManualTimeEntryDialog> {
  TaskDetailDraftRegistration? _draft;
  final _minutes = TextEditingController();
  final _description = TextEditingController();
  final ValueNotifier<bool> _billable = ValueNotifier(true);
  final ValueNotifier<bool> _saving = ValueNotifier(false);
  final ValueNotifier<DateTime?> _startedAt = ValueNotifier(null);
  final ValueNotifier<String?> _durationError = ValueNotifier(null);
  late final Listenable _formChanges;

  @override
  void initState() {
    super.initState();
    _minutes.addListener(_refreshDraft);
    _description.addListener(_refreshDraft);
    _formChanges = Listenable.merge([
      _billable,
      _saving,
      _startedAt,
      _durationError,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _draft ??= TaskDetailDraftScope.maybeOf(context)?.registerDraft(
      label: context.l10n.taskDetailsTimeAdd,
    );
  }

  void _refreshDraft() {
    if (_minutes.text.trim().isEmpty &&
        _description.text.trim().isEmpty &&
        _billable.value &&
        _startedAt.value == null) {
      _draft?.clear();
    } else {
      _draft?.markDirty();
    }
  }

  @override
  void dispose() {
    _draft?.dispose();
    _minutes.removeListener(_refreshDraft);
    _description.removeListener(_refreshDraft);
    _minutes.dispose();
    _description.dispose();
    _billable.dispose();
    _saving.dispose();
    _startedAt.dispose();
    _durationError.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final tasks = context.tasksTheme;

    return BlocBuilder<TaskTimeTrackingCubit, TaskTimeTrackingState>(
      builder: (context, state) => AnimatedBuilder(
        animation: _formChanges,
        builder: (context, _) => WorkspaceCreationModalWrapper(
        title: l10n.taskDetailsTimeAdd,
        icon: Symbols.timer_rounded,
        accentColor: tasks.selectionAccent,
        isSubmitting: _saving.value,
        submitLabel: l10n.save,
        cancelLabel: l10n.cancel,
        maxWidth: 460,
        onBeforeClose: () => TaskDetailEditorCloseGuard.canClose(
          context,
          _draft,
        ),
        onSubmit: context.read<TaskTimeTrackingCubit>().canSubmit
            ? _save
            : null,
        body: Column(
          mainAxisSize: .min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TaskTimeEntryErrorBanner(),
            Text(
              l10n.taskDetailsTimeStartedAt,
              style: tasks.controlText.copyWith(color: colors.onSurfaceVariant),
            ),
            Gaps.h8,
            Builder(
              builder: (buttonContext) => OutlinedButton.icon(
                onPressed: _saving.value
                    ? null
                    : () => _selectStartedAt(buttonContext),
                icon: const Icon(Symbols.calendar_clock_rounded, size: 18),
                label: Text(_startedAtLabel(context)),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(tasks.controlRadius),
                  ),
                  side: BorderSide(color: tasks.canvasBorder),
                  foregroundColor: colors.onSurface,
                ),
              ),
            ),
            Gaps.h12,
            Text(
              l10n.taskDetailsTimeMinutes,
              style: tasks.controlText.copyWith(color: colors.onSurfaceVariant),
            ),
            Gaps.h8,
            TextField(
              controller: _minutes,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: 4,
              enabled: !_saving.value,
              onChanged: (_) => _durationError.value = null,
              decoration: _inputDecoration(
                context,
                l10n.taskDetailsTimeMinutes,
              ).copyWith(errorText: _durationError.value),
            ),
            Gaps.h12,
            Text(
              l10n.taskDetailsTimeDescription,
              style: tasks.controlText.copyWith(color: colors.onSurfaceVariant),
            ),
            Gaps.h8,
            TextField(
              controller: _description,
              maxLines: 2,
              enabled: !_saving.value,
              decoration: _inputDecoration(
                context,
                l10n.taskDetailsTimeDescription,
              ),
            ),
            Gaps.h8,
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.taskDetailsTimeBillable),
              value: _billable.value,
              onChanged: _saving.value
                  ? null
                  : (value) {
                      _billable.value = value;
                      _refreshDraft();
                    },
            ),
          ],
        ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) =>
      InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.tasksTheme.controlRadius),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Sizes.p12,
          vertical: Sizes.p12,
        ),
        counterText: '',
      );

  String _startedAtLabel(BuildContext context) {
    final value = _startedAt.value;
    if (value == null) return context.l10n.taskDetailsTimeChooseStart;
    final date = MaterialLocalizations.of(context).formatMediumDate(value);
    final time = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(value),
    );
    return '$date · $time';
  }

  Future<void> _selectStartedAt(BuildContext sourceContext) async {
    final sourceCubit = sourceContext.read<TaskTimeTrackingCubit>();
    final now = DateTime.now();
    final current = _startedAt.value ?? now;
    final selection = await TaskDatePicker.pick(
      sourceContext,
      initialValue: current,
      globalPosition: AppContextMenu.positionFor(sourceContext),
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (!mounted ||
        !sourceContext.mounted ||
        selection == null ||
        sourceCubit.isClosed ||
        !identical(sourceContext.read<TaskTimeTrackingCubit>(), sourceCubit)) {
      return;
    }
    if (selection.value == null) {
      _startedAt.value = null;
      _refreshDraft();
      return;
    }
    final time = await showTimePicker(
      context: sourceContext,
      initialTime: TimeOfDay.fromDateTime(current),
      helpText: sourceContext.l10n.taskDetailsTimeChooseStart,
    );
    if (!mounted ||
        !sourceContext.mounted ||
        time == null ||
        sourceCubit.isClosed ||
        !identical(sourceContext.read<TaskTimeTrackingCubit>(), sourceCubit)) {
      return;
    }
    _startedAt.value = DateTime(
      selection.value!.year,
      selection.value!.month,
      selection.value!.day,
      time.hour,
      time.minute,
    );
    _refreshDraft();
  }

  Future<void> _save() async {
    if (_saving.value) return;
    final duration = int.tryParse(_minutes.text.trim());
    if (duration == null || duration < 1 || duration > 1440) {
      _durationError.value = context.l10n.taskDetailsTimeDurationInvalid;
      return;
    }
    _saving.value = true;
    final cubit = context.read<TaskTimeTrackingCubit>();
    try {
      if (!cubit.canSubmit) return;
      final saved = await cubit.create(
        CreateTaskTimeEntryPayload(
          startedAtUtc: _startedAt.value?.toUtc(),
          durationMinutes: duration,
          description: _description.text.trim().isEmpty
              ? null
              : _description.text.trim(),
          isBillable: _billable.value,
        ),
      );
      if (!mounted) return;
      if (saved) {
        _draft?.clear();
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) _saving.value = false;
    }
  }
}
