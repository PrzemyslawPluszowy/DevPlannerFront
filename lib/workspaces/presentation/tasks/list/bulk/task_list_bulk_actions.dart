import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_bulk_due_date_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_bulk_interaction.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_priority_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/task_list_snapshot.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/task_saved_views_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class TaskListBulkActions {
  const TaskListBulkActions(
    this.source, {
    required this.dueDateInteraction,
    required this.isCurrentSource,
    this.profiles = const {},
  });
  final TasksBulkInteraction dueDateInteraction;
  final bool Function() isCurrentSource;
  final Map<String, ProjectMemberProfile> profiles;
  final ProjectTasksListCubit source;
  Future<void> apply(
    BuildContext context, {
    ProjectTaskStatus? status,
    TaskPriority? priority,
    DateTime? dueAtUtc,
    bool clearDueAtUtc = false,
    List<String>? assigneeIds,
    String? customStatusId,
    bool clearCustomStatus = false,
    bool archive = false,
    bool entireResult = false,
  }) async {
    if (!isCurrentSource() || source.isClosed) return;
    final revision = source.queryRevision;
    final ready = source.state;
    if (ready is! ProjectTasksListReady || ready.isBulkSaving) return;
    TaskSelectionTokenResponse? token;
    if (entireResult) {
      token = await source.prepareBulkSelection();
      if (!context.mounted ||
          source.isClosed ||
          !isCurrentSource() ||
          token == null ||
          source.queryRevision != revision) {
        return;
      }
      final confirmed = await AppConfirmDialog.show(
        context,
        title: context.l10n.tasksBulkConfirmScope,
        message:
            '${_operationSummary(context, status: status, priority: priority, dueAtUtc: dueAtUtc, clearDueAtUtc: clearDueAtUtc, archive: archive, assigneeIds: assigneeIds, customStatusId: customStatusId, clearCustomStatus: clearCustomStatus)}\n\n${context.l10n.tasksBulkEntireScope(_filterSummary(context, ready), token.totalCount)}',
        confirmLabel: context.l10n.save,
        cancelLabel: context.l10n.cancel,
        tone: archive
            ? AppConfirmDialogTone.danger
            : AppConfirmDialogTone.warning,
      );
      if (!context.mounted ||
          source.isClosed ||
          !isCurrentSource() ||
          !confirmed ||
          source.queryRevision != revision) {
        return;
      }
      await source.bulkUpdateEntireResult(
        preparedSelection: token,
        clearDueAtUtc: clearDueAtUtc,
        status: status,
        customStatusId: customStatusId,
        clearCustomStatus: clearCustomStatus,
        priority: priority,
        dueAtUtc: dueAtUtc,
        assigneeIds: assigneeIds,
        archive: archive,
      );
      return;
    }
    if (archive) {
      final confirmed = await AppConfirmDialog.show(
        context,
        title: context.l10n.tasksBulkArchive,
        message: context.l10n.tasksBulkArchiveSelected(
          ready.selectedTaskIds.length,
        ),
        confirmLabel: context.l10n.tasksBulkArchive,
        cancelLabel: context.l10n.cancel,
        tone: AppConfirmDialogTone.danger,
      );
      if (!context.mounted ||
          source.isClosed ||
          !isCurrentSource() ||
          !confirmed ||
          source.queryRevision != revision ||
          !_sameSelection(ready, source.state)) {
        return;
      }
    }
    // Przeniesienie do grupy workflow obsługuje wyłącznie cały wynik, więc dla
    // zaznaczonych zadań przekazujemy tylko wspierane pola.
    await source.bulkUpdateSelected(
      status: status,
      priority: priority,
      dueAtUtc: dueAtUtc,
      clearDueAtUtc: clearDueAtUtc,
      assigneeIds: assigneeIds,
      archive: archive,
    );
  }

  Future<void> applyEntireResult(BuildContext context, String value) async {
    if (value == 'due_today') {
      await pickDueDate(context, entireResult: true);
      return;
    }
    final separator = value.indexOf(':');
    if (separator == -1) {
      await apply(
        context,
        archive: value == 'archive',
        entireResult: true,
      );
      return;
    }
    final kind = value.substring(0, separator);
    final name = value.substring(separator + 1);
    if (kind == 'status') {
      await apply(
        context,
        status: ProjectTaskStatus.values.firstWhere((s) => s.name == name),
        entireResult: true,
      );
      return;
    }
    await apply(
      context,
      priority: TaskPriority.values.firstWhere((p) => p.name == name),
      entireResult: true,
    );
  }

  bool _sameSelection(
    ProjectTasksListReady previous,
    ProjectTasksListState current,
  ) =>
      current is ProjectTasksListReady &&
      previous.selectedTaskIds.length == current.selectedTaskIds.length &&
      previous.selectedTaskIds.containsAll(current.selectedTaskIds);

  String _operationSummary(
    BuildContext context, {
    ProjectTaskStatus? status,
    TaskPriority? priority,
    DateTime? dueAtUtc,
    bool clearDueAtUtc = false,
    bool archive = false,
    List<String>? assigneeIds,
    String? customStatusId,
    bool clearCustomStatus = false,
  }) {
    if (archive) return context.l10n.tasksBulkArchive;
    if (clearDueAtUtc) return context.l10n.tasksBulkClearDueDate;
    if (dueAtUtc != null) {
      final local = dueAtUtc.toLocal();
      final labels = MaterialLocalizations.of(context);
      return '${context.l10n.tasksBulkDueDate}: ${labels.formatMediumDate(local)} ${labels.formatTimeOfDay(TimeOfDay.fromDateTime(local), alwaysUse24HourFormat: true)} (${source.calendarTimeZoneId ?? local.timeZoneName})';
    }
    if (status != null) {
      return '${context.l10n.tasksBulkStatus}: ${TaskStatusVisualHelper.label(context, status)}';
    }
    if (priority != null) {
      return '${context.l10n.tasksBulkPriority}: ${TaskPriorityVisualHelper.label(context, priority)}';
    }
    if (assigneeIds != null) {
      return '${context.l10n.taskDetailsAssignees}: ${assigneeIds.map((id) => profiles[id]?.displayName ?? context.l10n.taskDetailsProjectMember).join(', ')}';
    }
    final ready = source.state;
    final name = ready is ProjectTasksListReady
        ? ready.groups
              .where((group) => group.key == 'custom-status:$customStatusId')
              .firstOrNull
              ?.displayName
        : null;
    return '${context.l10n.tasksBulkEntireGroup}: ${name ?? context.l10n.taskDetailsNobody}';
  }

  String _filterSummary(BuildContext context, ProjectTasksListReady ready) {
    final savedViews = context.read<TaskSavedViewsCubit?>()?.state;
    final savedName = savedViews is TaskSavedViewsReady
        ? savedViews.views
              .where((view) => view.id == source.savedViewId)
              .firstOrNull
              ?.name
        : null;
    final filters = [
      ?savedName,
      if (source.savedViewId != null && savedName == null)
        context.l10n.tasksBulkSavedViewFilter,
      if (ready.status != null)
        TaskStatusVisualHelper.label(context, ready.status!),
      if (ready.priority != null)
        TaskPriorityVisualHelper.label(context, ready.priority!),
      if (ready.assigneeUserId != null)
        '${context.l10n.taskDetailsAssignees}: ${profiles[ready.assigneeUserId]?.displayName?.trim().isNotEmpty == true ? profiles[ready.assigneeUserId]!.displayName!.trim() : context.l10n.taskDetailsProjectMember}',
      if (ready.myInvolvement != null)
        switch (ready.myInvolvement!) {
          TaskInvolvementFilter.primaryAssignee =>
            context.l10n.myTasksInvolvementPrimaryAssignee,
          TaskInvolvementFilter.collaborator =>
            context.l10n.myTasksInvolvementCollaborator,
          TaskInvolvementFilter.watcher =>
            context.l10n.myTasksInvolvementWatcher,
          TaskInvolvementFilter.assignee =>
            context.l10n.myTasksInvolvementAssignee,
          TaskInvolvementFilter.any => context.l10n.myTasksInvolvementAny,
        },
      if (ready.unassignedOnly) context.l10n.taskDetailsNobody,
      if (ready.pinnedOnly) context.l10n.tasksBulkPinnedFilter,
    ];
    return filters.isEmpty
        ? context.l10n.tasksBulkNoFilters
        : filters.join(', ');
  }

  Future<void> pickDueDate(
    BuildContext context, {
    bool entireResult = false,
  }) => dueDateInteraction.run(
    () => _pickDueDate(context, entireResult: entireResult),
  );

  Future<void> _pickDueDate(
    BuildContext context, {
    required bool entireResult,
  }) async {
    if (!isCurrentSource() || source.isClosed) return;
    final ready = source.state;
    if (ready is! ProjectTasksListReady || ready.isBulkSaving) return;
    final revision = source.queryRevision;
    final values = TaskListSnapshot.allLoadedTasks(ready)
        .where(
          (task) => entireResult || ready.selectedTaskIds.contains(task.id),
        )
        .map((task) => task.dueAtUtc)
        .toList(growable: false);
    final choice = await TasksBulkDueDateDialog.show(
      context,
      currentValues: values,
      hasCompleteClockScope:
          !entireResult && values.length == ready.selectedTaskIds.length,
      scopeLabel: entireResult
          ? context.l10n.tasksBulkEntireResult
          : context.l10n.tasksBulkSelected(ready.selectedTaskIds.length),
      calendarTimeZoneId: source.calendarTimeZoneId,
    );
    if (!context.mounted ||
        source.isClosed ||
        !isCurrentSource() ||
        choice == null ||
        source.queryRevision != revision ||
        (!entireResult && !_sameSelection(ready, source.state))) {
      return;
    }
    await apply(
      context,
      dueAtUtc: choice.value,
      clearDueAtUtc: choice.value == null,
      entireResult: entireResult,
    );
  }
}
