import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_bubble_toast.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/task_recurrence_editor_options_section.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/task_recurrence_editor_presets.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/task_recurrence_editor_schedule_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Otwiera wizualny edytor cykliczności z kontrolowanym lifecycle Cubitu.
final class TaskRecurrenceContextEditorLauncher {
  const TaskRecurrenceContextEditorLauncher._();

  static Future<void> show(
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
    final targetPosition = globalPosition ?? _targetPosition(context);
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
        child: _TaskRecurrenceContextEditor(onSaved: onSaved, dismiss: dismiss),
      ),
    );
  }

  static Offset _targetPosition(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;
    return box?.localToGlobal(Offset(0, box.size.height)) ?? Offset.zero;
  }
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
            TaskRecurrenceEditorPresets(
              selectedPreset: state.preset,
              interval: state.interval,
              frequency: state.frequency,
              onPresetSelected: cubit.setPreset,
              onIntervalChanged: cubit.setInterval,
              onFrequencyChanged: cubit.setFrequency,
            ),
            Gaps.h12,
            TaskRecurrenceEditorScheduleSection(
              scheduledDate: state.scheduledDate,
              scheduledTime: TimeOfDay(
                hour: state.scheduledTime.hour,
                minute: state.scheduledTime.minute,
              ),
              onPickDate: () async {
                final picked = await DevPlannerModalPickerHost.showDate(
                  context,
                  initialDate: state.scheduledDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 1)),
                  lastDate: DateTime.now().add(const Duration(days: 3650)),
                );
                if (picked != null) cubit.setScheduledDate(picked);
              },
              onPickTime: () async {
                final picked = await DevPlannerModalPickerHost.showTime(
                  context,
                  initialTime: TimeOfDay(
                    hour: state.scheduledTime.hour,
                    minute: state.scheduledTime.minute,
                  ),
                );
                if (picked != null) {
                  cubit.setScheduledTime(
                    TaskRecurrenceScheduledTime(
                      hour: picked.hour,
                      minute: picked.minute,
                    ),
                  );
                }
              },
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
}
