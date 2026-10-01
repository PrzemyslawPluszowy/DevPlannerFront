import 'dart:async';

import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/custom_workflow/models/custom_workflow_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_details_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/cubit/task_status_control_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_custom_status_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// One inline control for both a project's custom workflow and system status.
final class TaskCustomStatusHeaderControl extends StatefulWidget {
  const TaskCustomStatusHeaderControl({
    required this.details,
    required this.fallbackLabel,
    required this.enabled,
    super.key,
  });

  final ProjectTaskDetailsResponse details;
  final String fallbackLabel;
  final bool enabled;

  @override
  State<TaskCustomStatusHeaderControl> createState() =>
      _TaskCustomStatusHeaderControlState();
}

final class _TaskCustomStatusHeaderControlState
    extends State<TaskCustomStatusHeaderControl> {
  TaskDetailsCubit? _sourceCubit;
  TaskStatusControlCubit? _catalogCubit;
  String? _workspaceId;
  String? _projectId;
  String? _taskId;
  int _scopeGeneration = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncScope();
  }

  @override
  void didUpdateWidget(TaskCustomStatusHeaderControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncScope();
  }

  void _syncScope() {
    final source = context.read<TaskDetailsCubit>();
    final task = widget.details.task;
    final sourceChanged = !identical(source, _sourceCubit);
    final scopeChanged = sourceChanged ||
        task.workspaceId != _workspaceId ||
        task.projectId != _projectId ||
        task.id != _taskId ||
        _catalogCubit == null;
    _sourceCubit = source;
    _workspaceId = task.workspaceId;
    _projectId = task.projectId;
    _taskId = task.id;
    if (scopeChanged) _scopeGeneration++;
    if (scopeChanged) {
      final previous = _catalogCubit;
      if (previous == null || sourceChanged) {
        _catalogCubit = TaskStatusControlCubit(
          source: source,
          workspaceId: task.workspaceId,
          projectId: task.projectId,
          taskId: task.id,
        );
        if (previous != null) unawaited(previous.close());
      } else {
        previous.replaceScope(
          source: source,
          workspaceId: task.workspaceId,
          projectId: task.projectId,
          taskId: task.id,
        );
      }
      return;
    }
  }

  @override
  void dispose() {
    final cubit = _catalogCubit;
    if (cubit != null) unawaited(cubit.close());
    super.dispose();
  }

  Future<void> _openStatusOptions(
    TaskStatusCatalogState catalog,
    TaskDetailsCubit source,
  ) async {
    if (!widget.enabled || catalog.isLoading) return;
    if (catalog.error case final error?) {
      await TaskCustomStatusPicker.show(
        context,
        widget.details,
        initialError: error,
      );
      return;
    }
    if (catalog.statuses.isNotEmpty) {
      await _openCustomStatusOptions(source, catalog.statuses);
      return;
    }
    await _openSystemStatusOptions(source);
  }

  Future<void> _openCustomStatusOptions(
    TaskDetailsCubit cubit,
    List<ProjectCustomStatusResponse> statuses,
  ) async {
    final generation = _scopeGeneration;
    final task = widget.details.task;
    final current = widget.details.customStatus;
    final selected = await AppContextMenu.select<ProjectCustomStatusResponse>(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      headerTitle: context.l10n.taskDetailsCustomStatusTitle,
      options: [
        for (final status in statuses)
          AppContextMenuOption<ProjectCustomStatusResponse>(
            value: status,
            label: status.name,
            leading: _StatusColorDot(
              color: TaskCustomStatusPresentation.parseColor(
                status.colorHex,
                context.colors.primary,
              ),
            ),
            trailing: _StatusWipCount(
              status: status,
              currentId: widget.details.task.customStatusId,
            ),
            selected: status.id == current?.id,
          ),
      ],
    );
    if (!_isCurrentScope(cubit, generation, task) ||
        selected == null ||
        selected.id == current?.id) {
      return;
    }
    await cubit.moveCustomStatus(selected.id);
  }

  Future<void> _openSystemStatusOptions(TaskDetailsCubit cubit) async {
    final generation = _scopeGeneration;
    final task = widget.details.task;
    final current = task.status;
    final statuses = TaskWorkflowStatusOptions.allowedFor(widget.details);
    final options = statuses.isEmpty ? <ProjectTaskStatus>[current] : statuses;
    final selected = await AppContextMenu.select<ProjectTaskStatus>(
      context,
      globalPosition: AppContextMenu.positionFor(context),
      headerTitle: context.l10n.taskDetailsStatusField,
      options: [
        for (final status in options)
          AppContextMenuOption<ProjectTaskStatus>(
            value: status,
            label: widget.details.workflow.statuses
                    .where((item) => item.status == status)
                    .map((item) => item.displayName)
                    .firstOrNull ??
                TaskStatusVisualHelper.label(context, status),
            icon: TaskStatusVisualHelper.icon(status),
            iconColor: widget.details.workflow.statuses
                    .where((item) => item.status == status)
                    .map(
                      (item) => TaskCustomStatusPresentation.parseColor(
                        item.color,
                        TaskStatusVisualHelper.color(status),
                      ),
                    )
                    .firstOrNull ??
                TaskStatusVisualHelper.color(status),
            selected: status == current,
          ),
      ],
    );
    if (!_isCurrentScope(cubit, generation, task) ||
        selected == null ||
        selected == current) {
      return;
    }
    await cubit.changeSystemStatus(selected);
  }

  bool _isCurrentScope(
    TaskDetailsCubit cubit,
    int generation,
    ProjectTaskResponse task,
  ) =>
      mounted &&
      identical(cubit, _sourceCubit) &&
      generation == _scopeGeneration &&
      task.workspaceId == _workspaceId &&
      task.projectId == _projectId &&
      task.id == _taskId &&
      widget.details.task.version == task.version &&
      widget.details.task.status == task.status &&
      widget.details.task.customStatusId == task.customStatusId;

  @override
  Widget build(BuildContext context) {
    final source = context.watch<TaskDetailsCubit>();
    final status = widget.details.customStatus;
    final systemStatus = widget.details.workflow.statuses
        .where((item) => item.status == widget.details.task.status)
        .firstOrNull;
    final foreground = status == null
        ? TaskCustomStatusPresentation.parseColor(
            systemStatus?.color ?? '',
            TaskStatusVisualHelper.color(widget.details.task.status),
          )
        : TaskCustomStatusPresentation.parseColor(
            status.color,
            context.colors.primary,
          );
    return BlocBuilder<TaskStatusControlCubit, TaskStatusCatalogState>(
      bloc: _catalogCubit,
      builder: (context, catalog) => Tooltip(
        message: context.l10n.taskDetailsCustomStatusChoose,
        child: TextButton.icon(
          onPressed: widget.enabled && !catalog.isLoading
              ? () => _openStatusOptions(catalog, source)
              : null,
          icon: catalog.isLoading
              ? SizedBox.square(
                  dimension: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.8,
                    color: context.colors.onSurfaceVariant,
                  ),
                )
              : Icon(
                  status == null
                      ? TaskStatusVisualHelper.icon(widget.details.task.status)
                      : Symbols.circle,
                  size: 14,
                  color: foreground,
                ),
          label: Text(
            status?.name ?? systemStatus?.displayName ?? widget.fallbackLabel,
          ),
          style: TextButton.styleFrom(
            foregroundColor: foreground,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            textStyle: context.tasksTheme.controlText,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                context.tasksTheme.controlRadius,
              ),
              side: BorderSide(color: context.tasksTheme.canvasBorder),
            ),
          ),
        ),
      ),
    );
  }
}

final class _StatusColorDot extends StatelessWidget {
  const _StatusColorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    width: 10,
    height: 10,
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

final class _StatusWipCount extends StatelessWidget {
  const _StatusWipCount({required this.status, required this.currentId});

  final ProjectCustomStatusResponse status;
  final String? currentId;

  @override
  Widget build(BuildContext context) {
    final limit = status.wipLimit;
    if (limit == null) return const SizedBox.shrink();
    final projected = status.taskCount + (currentId == status.id ? 0 : 1);
    final exceedsLimit = projected > limit;
    return Text(
      '$projected/$limit',
      style: context.tasksTheme.metaText.copyWith(
        color: exceedsLimit ? context.colors.error : null,
      ),
    );
  }
}

final class TaskCustomStatusPicker {
  const TaskCustomStatusPicker._();

  static Future<void> show(
    BuildContext context,
    ProjectTaskDetailsResponse details, {
    ApiError? initialError,
  }) {
    final detailsCubit = context.read<TaskDetailsCubit>();
    return DevPlannerModalHost.showDialog<void>(
      context,
      builder: (_) => BlocProvider.value(
        value: detailsCubit,
        child: TaskCustomStatusDialog(
          details: details,
          initialError: initialError,
        ),
      ),
    );
  }
}
