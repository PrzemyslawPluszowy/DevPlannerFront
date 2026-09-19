import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_row_actions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Zestaw akcji pokazywany przy hoverze tytułu; nie zarządza stanem edycji.
class TaskCellTitleActions extends StatelessWidget {
  const TaskCellTitleActions({
    required this.task,
    required this.isHovered,
    required this.onStartEditing,
    required this.profiles,
    required this.customFields,
    super.key,
    this.onPinnedChanged,
    this.onWatchingToggled,
    this.onOpen,
    this.onDuplicate,
    this.onCreateSubtask,
    this.onStatusChanged,
    this.onPriorityChanged,
    this.onAssigneesChanged,
    this.onDueDateChanged,
    this.onArchive,
    this.onRecurrenceToggled,
    this.onRecurrenceConfigured,
    this.onCustomFieldChanged,
    this.onSearchEligibleProfiles,
  });

  final ProjectTaskListItemResponse task;
  final ValueListenable<bool> isHovered;
  final VoidCallback onStartEditing;
  final Future<bool> Function(bool isPinned)? onPinnedChanged;
  final Future<bool> Function()? onWatchingToggled;
  final VoidCallback? onOpen;
  final Future<void> Function()? onDuplicate;
  final Future<void> Function()? onCreateSubtask;
  final Future<bool> Function(ProjectTaskStatus status)? onStatusChanged;
  final Future<bool> Function(TaskPriority priority)? onPriorityChanged;
  final Future<bool> Function(List<String> userIds)? onAssigneesChanged;
  final Future<bool> Function(DateTime? dueAtUtc)? onDueDateChanged;
  final Future<bool> Function()? onArchive;
  final Future<bool> Function()? onRecurrenceToggled;
  final Future<void> Function(Offset position)? onRecurrenceConfigured;
  final Map<String, ProjectMemberProfile> profiles;
  final List<TaskCustomFieldResponse> customFields;
  final Future<bool> Function(TaskCustomFieldResponse field, Object? value)?
  onCustomFieldChanged;
  final EligibleProfilesPageLoader? onSearchEligibleProfiles;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: isHovered,
    builder: (context, hovered, _) {
      if (!hovered && !task.isPinned && !task.isWatchedByMe) {
        return const SizedBox.shrink();
      }
      return Row(
        mainAxisSize: .min,
        children: [
          if (hovered) _editButton(context),
          if (task.isPinned || hovered) _pinButton(context),
          if (task.isWatchedByMe || hovered) _watchButton(context),
          if (hovered) _moreButton(context),
        ],
      );
    },
  );

  Widget _editButton(BuildContext context) => IconButton(
    tooltip: context.l10n.tasksListEditTitleTooltip,
    visualDensity: .compact,
    constraints: const BoxConstraints.tightFor(width: 26, height: 26),
    padding: EdgeInsets.zero,
    onPressed: onStartEditing,
    icon: Icon(
      Symbols.edit_rounded,
      size: 15,
      color: context.colors.onSurfaceVariant,
    ),
  );

  Widget _pinButton(BuildContext context) => IconButton(
    tooltip: task.isPinned
        ? context.l10n.tasksListUnpinTooltip
        : context.l10n.tasksListPinTooltip,
    visualDensity: .compact,
    constraints: const BoxConstraints.tightFor(width: 26, height: 26),
    padding: EdgeInsets.zero,
    onPressed: onPinnedChanged == null
        ? null
        : () => unawaited(onPinnedChanged!(!task.isPinned)),
    icon: Icon(
      task.isPinned ? Symbols.push_pin_rounded : Symbols.push_pin,
      size: 15,
      color: task.isPinned
          ? context.colors.primary
          : context.colors.onSurfaceVariant,
    ),
  );

  Widget _watchButton(BuildContext context) => IconButton(
    tooltip: task.isWatchedByMe
        ? context.l10n.tasksListUnwatchTooltip
        : context.l10n.tasksListWatchTooltip,
    visualDensity: .compact,
    constraints: const BoxConstraints.tightFor(width: 26, height: 26),
    padding: EdgeInsets.zero,
    onPressed: onWatchingToggled == null
        ? null
        : () => unawaited(onWatchingToggled!()),
    icon: Icon(
      task.isWatchedByMe ? Symbols.visibility_rounded : Symbols.visibility,
      size: 15,
      color: task.isWatchedByMe
          ? context.colors.primary
          : context.colors.onSurfaceVariant,
    ),
  );

  Widget _moreButton(BuildContext context) => Builder(
    builder: (buttonContext) => IconButton(
      tooltip: context.l10n.tasksListMoreOptionsTooltip,
      visualDensity: .compact,
      constraints: const BoxConstraints.tightFor(width: 26, height: 26),
      padding: EdgeInsets.zero,
      onPressed: () {
        final box = buttonContext.findRenderObject() as RenderBox?;
        final position = box == null
            ? Offset.zero
            : box.localToGlobal(Offset(0, box.size.height));
        unawaited(
          TaskRowContextMenu.show(
            context,
            task: task,
            position: position,
            onOpen: onOpen,
            onDuplicate: onDuplicate,
            onCreateSubtask: onCreateSubtask,
            onStatusChanged: onStatusChanged,
            onPriorityChanged: onPriorityChanged,
            onAssigneesChanged: onAssigneesChanged,
            onDueDateChanged: onDueDateChanged,
            onArchive: onArchive,
            onPinnedChanged: onPinnedChanged,
            onWatchingToggled: onWatchingToggled,
            onRecurrenceToggled: onRecurrenceToggled,
            onRecurrenceConfigured: onRecurrenceConfigured,
            profiles: profiles,
            customFields: customFields,
            onCustomFieldChanged: onCustomFieldChanged,
            searchEligibleProfiles: onSearchEligibleProfiles,
          ),
        );
      },
      icon: Icon(
        Symbols.more_horiz_rounded,
        size: 16,
        color: context.colors.onSurfaceVariant,
      ),
    ),
  );
}
