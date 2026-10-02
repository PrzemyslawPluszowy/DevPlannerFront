import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_error.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/task_recurrence_editor_options_section.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/task_recurrence_editor_presets.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/task_recurrence_editor_schedule_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

final class TaskRecurrenceEditorLoadedContent extends StatelessWidget {
  const TaskRecurrenceEditorLoadedContent({
    required this.state,
    required this.cubit,
    super.key,
  });

  final TaskRecurrenceEditorLoaded state;
  final TaskRecurrenceEditorCubit cubit;

  Future<void> _pickScheduledDate(
    BuildContext sourceContext,
    DateTime current,
  ) async {
    final now = DateTime.now();
    final selection = await TaskDatePicker.pick(
      sourceContext,
      initialValue: current,
      globalPosition: AppContextMenu.positionFor(sourceContext),
      allowClear: false,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 3650)),
    );
    if (!sourceContext.mounted ||
        selection?.value == null ||
        cubit.isClosed ||
        !identical(sourceContext.read<TaskRecurrenceEditorCubit>(), cubit)) {
      return;
    }
    cubit.setScheduledDate(selection!.value!);
  }

  Future<void> _pickScheduledTime(
    BuildContext sourceContext,
    TimeOfDay current,
  ) async {
    final selected = await DevPlannerModalPickerHost.showTime(
      sourceContext,
      initialTime: current,
    );
    if (!sourceContext.mounted ||
        selected == null ||
        cubit.isClosed ||
        !identical(sourceContext.read<TaskRecurrenceEditorCubit>(), cubit)) {
      return;
    }
    cubit.setScheduledTime(
      TaskRecurrenceScheduledTime(
        hour: selected.hour,
        minute: selected.minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const .symmetric(horizontal: Sizes.p16, vertical: Sizes.p12),
    child: SingleChildScrollView(
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          Row(
            children: [
              Icon(
                Symbols.repeat_rounded,
                color: context.colors.primary,
                size: Sizes.p24,
              ),
              Gaps.w8,
              Text(
                context.l10n.taskRecurrenceHeader,
                style: context.text.titleSmall?.copyWith(
                  fontWeight: .w800,
                  letterSpacing: -.2,
                ),
              ),
            ],
          ),
          Gaps.h12,
          if (state.apiError case final apiError?) ...[
            TaskDetailsModalError(error: apiError),
            if (state.errorOperation == TaskRecurrenceEditorErrorOperation.load)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: state.isLoadingRecurrence
                      ? null
                      : () => unawaited(cubit.retryLoad()),
                  icon: state.isLoadingRecurrence
                      ? const SizedBox.square(
                          dimension: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Symbols.refresh_rounded),
                  label: Text(context.l10n.retry),
                ),
              ),
            Gaps.h12,
          ] else if (state.errorMessage case final error?) ...[
            Container(
              padding: const .all(Sizes.p8),
              decoration: BoxDecoration(
                color: context.colors.errorContainer.withValues(alpha: .5),
                borderRadius: const BorderRadius.all(.circular(Sizes.p6)),
              ),
              child: Row(
                children: [
                  Icon(
                    Symbols.error_outline_rounded,
                    size: Sizes.p16,
                    color: context.colors.error,
                  ),
                  Gaps.w6,
                  Expanded(
                    child: Text(
                      error,
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gaps.h12,
          ],
          TaskRecurrenceEditorPresets(
            selectedPreset: state.preset,
            enabled: !state.isSaving,
            interval: state.interval,
            frequency: state.frequency,
            onPresetSelected: cubit.setPreset,
            onIntervalChanged: cubit.setInterval,
            onFrequencyChanged: cubit.setFrequency,
          ),
          Gaps.h12,
          TaskRecurrenceEditorScheduleSection(
            scheduledDate: state.scheduledDate,
            seriesTimeZoneId: state.recurrence?.timeZoneId,
            enabled: !state.isSaving,
            scheduledTime: TimeOfDay(
              hour: state.scheduledTime.hour,
              minute: state.scheduledTime.minute,
            ),
            onPickDate: (sourceContext) =>
                _pickScheduledDate(sourceContext, state.scheduledDate),
            onPickTime: (sourceContext) => _pickScheduledTime(
              sourceContext,
              TimeOfDay(
                hour: state.scheduledTime.hour,
                minute: state.scheduledTime.minute,
              ),
            ),
          ),
          Gaps.h12,
          TaskRecurrenceEditorOptionsSection(
            mode: state.mode,
            occurrenceStatus: state.occurrenceStatus,
            skipIfPreviousOpen: state.skipIfPreviousOpen,
            isSourceTask: state.isSourceTask,
            hasRecurrence: state.hasRecurrence,
            isActive: state.isActive,
            isSubmitting: state.isSaving,
            onModeChanged: cubit.setMode,
            onOccurrenceStatusChanged: cubit.setOccurrenceStatus,
            onSkipIfPreviousOpenChanged: cubit.setSkipIfPreviousOpen,
            onTogglePause: () => unawaited(cubit.toggleActive()),
            onDelete: () => unawaited(cubit.delete()),
            onSave: () => unawaited(cubit.save()),
          ),
        ],
      ),
    ),
  );
}
