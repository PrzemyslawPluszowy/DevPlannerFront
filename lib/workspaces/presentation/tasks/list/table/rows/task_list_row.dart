import 'dart:async';

import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_column_reference.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_row_body.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Pojedynczy wiersz zadania w tabeli listy zadań.
///
/// Obsługuje interakcje wiersza: zaznaczanie, drag & drop podzadań, menu
/// kontekstowe, skróty klawiaturowe oraz renderowanie poszczególnych komórek.
class TaskListRow extends StatefulWidget {
  const TaskListRow({
    required this.task,
    this.columns = defaultTaskListColumns,
    this.columnReferences,
    required this.memberProfilesByUserId,
    super.key,
    this.onOpen,
    this.onDuplicate,
    this.onCreateSubtask,
    this.onToggleSubtasks,
    this.onStatusChanged,
    this.onCustomStatusChanged,
    this.onPriorityChanged,
    this.onTaskTypeChanged,
    this.onSystemMetricChanged,
    this.onAssigneesChanged,
    this.onDueDateChanged,
    this.onStartDateChanged,
    this.onArchive,
    this.onPinnedChanged,
    this.onWatchingToggled,
    this.onRecurrenceToggled,
    this.onRecurrenceConfigured,
    this.onLabelsChanged,
    this.onMilestoneChanged,
    this.milestones = const {},
    this.onDragStarted,
    this.onTaskDroppedAsSubtask,
    this.isSelected = false,
    this.onSelectionChanged,
    this.isExpanded = false,
    this.isSubtasksLoading = false,
    this.hierarchyDepth = 0,
    this.customFields = const [],
    this.onTitleChanged,
    this.showActions = true,
    this.height = 42,
    this.errorMessage,
    this.onCustomFieldChanged,
    this.columnWidths = const {},
    this.columnWidthsById = const {},
    this.focusNode,
  });

  final ProjectTaskListItemResponse task;
  final List<TaskSavedViewColumn> columns;
  final List<TaskColumnReference>? columnReferences;
  final Map<String, double> columnWidthsById;
  final Map<String, ProjectMemberProfile> memberProfilesByUserId;
  final Future<bool> Function(String title)? onTitleChanged;
  final VoidCallback? onOpen;
  final Future<void> Function()? onDuplicate;
  final Future<void> Function()? onCreateSubtask;
  final VoidCallback? onToggleSubtasks;
  final Future<bool> Function(ProjectTaskStatus status)? onStatusChanged;
  final Future<bool> Function(String? customStatusId)? onCustomStatusChanged;
  final Future<bool> Function(TaskPriority priority)? onPriorityChanged;
  final Future<bool> Function(String taskType)? onTaskTypeChanged;
  final Future<bool> Function(TaskSavedViewColumn column, int? value)?
  onSystemMetricChanged;
  final Future<bool> Function(List<String> userIds)? onAssigneesChanged;
  final Future<bool> Function(DateTime? dueAtUtc)? onDueDateChanged;
  final Future<bool> Function(DateTime? startAtUtc)? onStartDateChanged;
  final Future<bool> Function()? onArchive;
  final Future<bool> Function(bool isPinned)? onPinnedChanged;
  final Future<bool> Function()? onWatchingToggled;
  final Future<bool> Function()? onRecurrenceToggled;
  final Future<void> Function(Offset position)? onRecurrenceConfigured;
  final Future<bool> Function(List<String> labelIds)? onLabelsChanged;
  final Future<bool> Function(String? milestoneId)? onMilestoneChanged;
  final Map<String, MilestoneResponse> milestones;
  final VoidCallback? onDragStarted;
  final ValueChanged<ProjectTaskListItemResponse>? onTaskDroppedAsSubtask;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;
  final bool isExpanded;
  final bool isSubtasksLoading;
  final int hierarchyDepth;
  final List<TaskCustomFieldResponse> customFields;
  final bool showActions;
  final double height;
  final String? errorMessage;
  final Future<bool> Function(TaskCustomFieldResponse field, Object? value)?
  onCustomFieldChanged;
  final Map<TaskSavedViewColumn, double> columnWidths;
  final FocusNode? focusNode;

  @override
  State<TaskListRow> createState() => _TaskListRowState();
}

final class _TaskListRowState extends State<TaskListRow> {
  EligibleProfilesPageLoader? _profilesPageLoader;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncProfilesPageLoader();
  }

  void _syncProfilesPageLoader() {
    final repository = context.watch<ProjectMemberProfilesRepository?>();
    final router = GoRouter.maybeOf(context);
    if (repository == null || router == null) {
      _profilesPageLoader = null;
      return;
    }

    final route = ModalRoute.of(context);
    final pathParameters = route is PageRoute
        ? GoRouterState.of(context).pathParameters
        : router.routerDelegate.currentConfiguration.pathParameters;
    final workspaceId = pathParameters['workspaceId'];
    final projectId = pathParameters['projectId'];
    if (workspaceId == null || projectId == null) {
      _profilesPageLoader = null;
      return;
    }

    final nextLoader = EligibleProfilesPageLoader(
      repository: repository,
      workspaceId: workspaceId,
      projectId: projectId,
    );
    if (_profilesPageLoader?.hasSameScopeAs(nextLoader) ?? false) return;
    _profilesPageLoader = nextLoader;
  }

  @override
  Widget build(BuildContext context) => TaskListRowBody(
    row: widget,
    searchEligibleProfiles: _profilesPageLoader,
  );
}
