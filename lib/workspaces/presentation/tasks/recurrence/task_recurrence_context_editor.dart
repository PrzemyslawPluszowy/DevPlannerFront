import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/shell/overlay/app_modal_picker_host.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_bubble_toast.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toggle_switch.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:ready_next/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_state.dart';

part 'widgets/task_recurrence_editor_options_section.part.dart';
part 'widgets/task_recurrence_editor_presets.part.dart';
part 'widgets/task_recurrence_editor_schedule_section.part.dart';

/// Otwiera wizualny edytor cykliczności zadania w menu kontekstowym.
Future<void> showTaskRecurrenceContextEditor(
  BuildContext context, {
  Offset? globalPosition,
  TaskRecurrenceSummaryResponse? taskRecurrence,
  required TaskRecurrenceRepository repository,
  required String workspaceId,
  required String projectId,
  required String taskId,
  required int taskVersion,
  required bool hasRecurrence,
  required ValueChanged<TaskMutationResponse<TaskRecurrenceResponse>> onSaved,
}) {
  final targetPosition =
      globalPosition ??
      (() {
        final box = context.findRenderObject() as RenderBox?;
        return box?.localToGlobal(Offset(0, box.size.height)) ?? Offset.zero;
      })();

  return AppContextMenu.showCustom(
    context,
    globalPosition: targetPosition,
    maxWidth: 340,
    maxHeight: 560,
    contentBuilder: (_, dismiss) => BlocProvider(
      create: (_) => TaskRecurrenceEditorCubit(
        repository: repository,
        workspaceId: workspaceId,
        projectId: projectId,
        taskId: taskId,
        taskVersion: taskVersion,
        hasRecurrence: hasRecurrence,
        initialSummary: taskRecurrence,
      ),
      child: _TaskRecurrenceContextEditor(
        onSaved: onSaved,
        dismiss: dismiss,
      ),
    ),
  );
}

class _TaskRecurrenceContextEditor extends StatelessWidget {
  const _TaskRecurrenceContextEditor({
    required this.onSaved,
    required this.dismiss,
  });

  final ValueChanged<TaskMutationResponse<TaskRecurrenceResponse>> onSaved;
  final VoidCallback dismiss;

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<TaskRecurrenceEditorCubit, TaskRecurrenceEditorState>(
        listener: (context, state) {
          if (state is TaskRecurrenceEditorSuccess) {
            onSaved(state.mutationResult);
            AppBubbleToast.show(
              context,
              message: state.message,
              tone: AppBubbleToastTone.success,
            );
            dismiss();
          } else if (state is TaskRecurrenceEditorDeleted) {
            AppBubbleToast.show(
              context,
              message: state.message,
              tone: AppBubbleToastTone.success,
            );
            dismiss();
          } else if (state is TaskRecurrenceEditorLoaded &&
              state.errorMessage != null) {
            AppBubbleToast.show(
              context,
              message: state.errorMessage!,
              tone: AppBubbleToastTone.error,
            );
          }
        },
        builder: (context, state) => switch (state) {
          TaskRecurrenceEditorInitial() ||
          TaskRecurrenceEditorLoading() => const Padding(
            padding: .all(Sizes.p32),
            child: Center(child: CircularProgressIndicator()),
          ),
          TaskRecurrenceEditorSuccess() ||
          TaskRecurrenceEditorDeleted() => const SizedBox.shrink(),
          TaskRecurrenceEditorLoaded() => _buildLoaded(context, state),
        },
      );

  Widget _buildLoaded(
    BuildContext context,
    TaskRecurrenceEditorLoaded state,
  ) {
    final cubit = context.read<TaskRecurrenceEditorCubit>();

    return Padding(
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
            if (state.errorMessage case final error?) ...[
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
            _TaskRecurrenceEditorPresets(
              selectedPreset: state.preset,
              interval: state.interval,
              frequency: state.frequency,
              onPresetSelected: cubit.setPreset,
              onIntervalChanged: cubit.setInterval,
              onFrequencyChanged: cubit.setFrequency,
            ),
            Gaps.h12,
            _TaskRecurrenceEditorScheduleSection(
              scheduledDate: state.scheduledDate,
              scheduledTime: state.scheduledTime,
              onPickDate: () async {
                final picked = await AppModalPickerHost.showDate(
                  context,
                  initialDate: state.scheduledDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (picked != null) cubit.setScheduledDate(picked);
              },
              onPickTime: () async {
                final picked = await AppModalPickerHost.showTime(
                  context,
                  initialTime: state.scheduledTime,
                );
                if (picked != null) cubit.setScheduledTime(picked);
              },
            ),
            Gaps.h12,
            _TaskRecurrenceEditorOptionsSection(
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
}
