import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_bubble_toast.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/task_recurrence_editor_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/widgets/task_recurrence_editor_loaded_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

final class _TaskRecurrenceContextEditor extends StatelessWidget {
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
              message: switch (state.operation) {
                TaskRecurrenceEditorSuccessOperation.saved =>
                  context.l10n.taskRecurrenceSaveSuccess,
                TaskRecurrenceEditorSuccessOperation.paused =>
                  context.l10n.taskRecurrencePauseSuccess,
                TaskRecurrenceEditorSuccessOperation.resumed =>
                  context.l10n.taskRecurrenceResumeSuccess,
              },
              tone: AppBubbleToastTone.success,
            );
            dismiss();
          } else if (state is TaskRecurrenceEditorDeleted) {
            AppBubbleToast.show(
              context,
              message: context.l10n.taskRecurrenceDeleteSuccess,
              tone: AppBubbleToastTone.success,
            );
            dismiss();
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
          TaskRecurrenceEditorLoaded() => TaskRecurrenceEditorLoadedContent(
            state: state,
            cubit: context.read<TaskRecurrenceEditorCubit>(),
          ),
        },
      );
}
