import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/domain/repositories/tasks_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cubit/project_tasks_list_state.dart';

/// Pełny, typowany zestaw filtrów aktywnej listy.
///
/// Jedno źródło budowania requestów zapobiega sytuacji, w której doładowanie
/// strony lub grupy przypadkiem pomija filtr użyty przy pierwszym odczycie.
final class TaskListQuery {
  const TaskListQuery({
    this.status,
    this.priority,
    this.assigneeCoreUserId,
    this.myInvolvement,
    this.unassignedOnly = false,
    this.pinnedOnly = false,
    this.savedViewId,
  });

  factory TaskListQuery.fromReady(
    ProjectTasksListReady state, {
    required String? savedViewId,
  }) => TaskListQuery(
    status: state.status,
    priority: state.priority,
    assigneeCoreUserId: state.assigneeCoreUserId,
    myInvolvement: state.myInvolvement,
    unassignedOnly: state.unassignedOnly,
    pinnedOnly: state.pinnedOnly,
    savedViewId: savedViewId,
  );

  final ProjectTaskStatus? status;
  final TaskPriority? priority;
  final String? assigneeCoreUserId;
  final TaskInvolvementFilter? myInvolvement;
  final bool unassignedOnly;
  final bool pinnedOnly;
  final String? savedViewId;

  ProjectTasksQuery listPage({String? cursor, String? parentTaskId}) =>
      ProjectTasksQuery(
        cursor: cursor,
        parentTaskId: parentTaskId,
        status: status?.name,
        priority: priority?.name,
        assigneeCoreUserId: assigneeCoreUserId,
        myInvolvement: _involvementWireValue(myInvolvement),
        unassignedOnly: unassignedOnly,
        pinnedOnly: pinnedOnly,
        savedViewId: savedViewId,
      );

  ProjectTasksGroupedQuery groups({
    required TaskSavedViewGroupBy groupBy,
    String? groupKey,
    String? cursor,
  }) => ProjectTasksGroupedQuery(
    groupBy: _groupByWireValue(groupBy),
    groupKey: groupKey,
    cursor: cursor,
    status: status?.name,
    priority: priority?.name,
    assigneeCoreUserId: assigneeCoreUserId,
    myInvolvement: _involvementWireValue(myInvolvement),
    unassignedOnly: unassignedOnly,
    pinnedOnly: pinnedOnly,
    savedViewId: savedViewId,
  );

  TaskSelectionQueryPayload selectionTokenPayload() =>
      TaskSelectionQueryPayload(
        savedViewId: savedViewId,
        status: status?.name,
        priority: priority?.name,
        assigneeCoreUserId: assigneeCoreUserId,
        myInvolvement: _involvementWireValue(myInvolvement),
        pinnedOnly: pinnedOnly,
        unassignedOnly: unassignedOnly,
      );

  static String? statusWireValue(ProjectTaskStatus? value) => value?.name;

  static String? priorityWireValue(TaskPriority? value) => value?.name;
}

String? _groupByWireValue(TaskSavedViewGroupBy value) => switch (value) {
  TaskSavedViewGroupBy.none => null,
  TaskSavedViewGroupBy.status => 'Status',
  TaskSavedViewGroupBy.customStatus => 'CustomStatus',
  TaskSavedViewGroupBy.priority => 'Priority',
  TaskSavedViewGroupBy.assignee => 'Assignee',
};

String? _involvementWireValue(TaskInvolvementFilter? value) => switch (value) {
  null => null,
  TaskInvolvementFilter.any => 'Any',
  TaskInvolvementFilter.primaryAssignee => 'PrimaryAssignee',
  TaskInvolvementFilter.collaborator => 'Collaborator',
  TaskInvolvementFilter.assignee => 'Assignee',
  TaskInvolvementFilter.watcher => 'Watcher',
};
