import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:flutter/material.dart';

/// Lokalizowane etykiety filtrów, sortowania i grupowania Listy.
abstract final class TaskListCommandBarLabels {
  static String assignee(
    BuildContext context, {
    required bool unassignedOnly,
    required String? userId,
    required Map<String, ProjectMemberProfile> memberProfiles,
  }) {
    if (unassignedOnly) return context.l10n.tasksSavedViewsUnassigned;
    if (userId == null) return context.l10n.tasksBoardFilterAssignee;
    return profileName(context, memberProfiles[userId]);
  }

  static String profileName(
    BuildContext context,
    ProjectMemberProfile? profile,
  ) {
    final displayName = profile?.displayName?.trim();
    return displayName?.isNotEmpty == true
        ? displayName!
        : context.l10n.tasksAutomationsUnknownMember;
  }

  static String? sortField(
    BuildContext context,
    TaskSavedViewSortField? field,
  ) => switch (field) {
    TaskSavedViewSortField.position => context.l10n.tasksSavedViewsSortPosition,
    TaskSavedViewSortField.updatedAtUtc =>
      context.l10n.tasksSavedViewsSortUpdated,
    TaskSavedViewSortField.dueAtUtc => context.l10n.tasksSavedViewsSortDueDate,
    TaskSavedViewSortField.priority => context.l10n.tasksSavedViewsSortPriority,
    TaskSavedViewSortField.title => context.l10n.tasksSavedViewsSortTitle,
    null => null,
  };

  static String? sortDirection(
    BuildContext context,
    TaskSavedViewSortDirection? direction,
  ) => switch (direction) {
    TaskSavedViewSortDirection.ascending =>
      context.l10n.tasksSavedViewsAscending,
    TaskSavedViewSortDirection.descending =>
      context.l10n.tasksSavedViewsDescending,
    null => null,
  };

  static String groupBy(
    BuildContext context,
    TaskSavedViewGroupBy groupBy,
  ) => switch (groupBy) {
    TaskSavedViewGroupBy.none => context.l10n.tasksSavedViewsGroupNone,
    TaskSavedViewGroupBy.status => context.l10n.tasksSavedViewsGroupStatus,
    TaskSavedViewGroupBy.customStatus =>
      context.l10n.tasksListGroupProjectWorkflow,
    TaskSavedViewGroupBy.priority => context.l10n.tasksSavedViewsGroupPriority,
    TaskSavedViewGroupBy.assignee => context.l10n.tasksSavedViewsGroupAssignee,
  };

  static String involvement(
    BuildContext context,
    TaskInvolvementFilter involvement,
  ) => switch (involvement) {
    TaskInvolvementFilter.primaryAssignee =>
      context.l10n.myTasksInvolvementPrimaryAssignee,
    TaskInvolvementFilter.collaborator =>
      context.l10n.myTasksInvolvementCollaborator,
    TaskInvolvementFilter.watcher => context.l10n.myTasksInvolvementWatcher,
    TaskInvolvementFilter.assignee => context.l10n.myTasksInvolvementAssignee,
    TaskInvolvementFilter.any => context.l10n.myTasksInvolvementAny,
  };
}
