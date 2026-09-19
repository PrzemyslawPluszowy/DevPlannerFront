import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_assignees.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_title_actions.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/rows/task_list_row_actions.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

class TaskCellTitle extends StatefulWidget {
  const TaskCellTitle({
    required this.task,
    this.showKey = false,
    required this.hierarchyDepth,
    super.key,
    this.onTitleChanged,
    this.onPinnedChanged,
    this.onWatchingToggled,
    this.onOpen,
    this.onDuplicate,
    this.onCreateSubtask,
    this.onArchive,
    this.onRecurrenceToggled,
    this.onRecurrenceConfigured,
    this.profiles = const {},
    this.customFields = const [],
    this.onCustomFieldChanged,
    this.onSearchEligibleProfiles,
    this.onStatusChanged,
    this.onPriorityChanged,
    this.onAssigneesChanged,
    this.onDueDateChanged,
  });

  final ProjectTaskListItemResponse task;
  final bool showKey;
  final int hierarchyDepth;
  final Future<bool> Function(String title)? onTitleChanged;
  final Future<bool> Function(bool isPinned)? onPinnedChanged;
  final Future<bool> Function()? onWatchingToggled;
  final VoidCallback? onOpen;
  final Future<void> Function()? onDuplicate;
  final Future<void> Function()? onCreateSubtask;
  final Future<bool> Function()? onArchive;
  final Future<bool> Function()? onRecurrenceToggled;
  final Future<void> Function(Offset position)? onRecurrenceConfigured;
  final Map<String, ProjectMemberProfile> profiles;
  final List<TaskCustomFieldResponse> customFields;
  final Future<bool> Function(TaskCustomFieldResponse field, Object? value)?
  onCustomFieldChanged;
  final EligibleProfilesPageLoader? onSearchEligibleProfiles;
  final Future<bool> Function(ProjectTaskStatus status)? onStatusChanged;
  final Future<bool> Function(TaskPriority priority)? onPriorityChanged;
  final Future<bool> Function(List<String> userIds)? onAssigneesChanged;
  final Future<bool> Function(DateTime? dueAtUtc)? onDueDateChanged;

  @override
  State<TaskCellTitle> createState() => _TaskCellTitleState();
}

class _TaskCellTitleState extends State<TaskCellTitle> {
  final ValueNotifier<bool> _isHovered = ValueNotifier(false);
  final ValueNotifier<bool> _isEditing = ValueNotifier(false);
  late final TextEditingController _titleController;
  late final FocusNode _editFocusNode;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _editFocusNode = FocusNode();
  }

  @override
  void didUpdateWidget(TaskCellTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.title != widget.task.title && !_isEditing.value) {
      _titleController.text = widget.task.title;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _editFocusNode.dispose();
    _isHovered.dispose();
    _isEditing.dispose();
    super.dispose();
  }

  void _startEditing() {
    _titleController.text = widget.task.title;
    _titleController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _titleController.text.length,
    );
    _isEditing.value = true;
    _editFocusNode.requestFocus();
  }

  Future<void> _submitTitle() async {
    if (!_isEditing.value) return;
    final newTitle = _titleController.text.trim();
    _isEditing.value = false;
    if (newTitle.isNotEmpty && newTitle != widget.task.title) {
      final success = await widget.onTitleChanged?.call(newTitle) ?? false;
      if (!success && mounted) {
        _titleController.text = widget.task.title;
      }
    } else {
      _titleController.text = widget.task.title;
    }
  }

  void _cancelEditing() {
    _titleController.text = widget.task.title;
    _isEditing.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: SizedBox(
        width: TaskListGrid.task,
        child: Padding(
          padding: const .symmetric(horizontal: Sizes.p8),
          child: Row(
            children: [
              if (widget.hierarchyDepth > 0) ...[
                SizedBox(width: widget.hierarchyDepth * 16.0),
                Icon(
                  Symbols.subdirectory_arrow_right_rounded,
                  size: 17,
                  color: context.colors.onSurfaceVariant,
                ),
                const SizedBox(width: 5),
              ],
              Expanded(
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isEditing,
                  builder: (context, isEditing, _) {
                    if (isEditing) {
                      return Focus(
                        onKeyEvent: (node, event) {
                          if (event is KeyDownEvent) {
                            if (event.logicalKey == LogicalKeyboardKey.enter) {
                              unawaited(_submitTitle());
                              return KeyEventResult.handled;
                            }
                            if (event.logicalKey == LogicalKeyboardKey.escape) {
                              _cancelEditing();
                              return KeyEventResult.handled;
                            }
                          }
                          return KeyEventResult.ignored;
                        },
                        child: TextField(
                          controller: _titleController,
                          focusNode: _editFocusNode,
                          autofocus: true,
                          style: context.text.bodyMedium?.copyWith(
                            color: context.colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const .symmetric(
                              horizontal: Sizes.p6,
                              vertical: Sizes.p4,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: context.colors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                          onTapOutside: (_) => unawaited(_submitTitle()),
                          onSubmitted: (_) => unawaited(_submitTitle()),
                        ),
                      );
                    }

                    return GestureDetector(
                      onDoubleTap: _startEditing,
                      onSecondaryTapDown: (details) {
                        unawaited(
                          TaskRowContextMenu.show(
                            context,
                            task: task,
                            position: details.globalPosition,
                            onOpen: widget.onOpen,
                            onDuplicate: widget.onDuplicate,
                            onCreateSubtask: widget.onCreateSubtask,
                            onStatusChanged: widget.onStatusChanged,
                            onPriorityChanged: widget.onPriorityChanged,
                            onAssigneesChanged: widget.onAssigneesChanged,
                            onDueDateChanged: widget.onDueDateChanged,
                            onArchive: widget.onArchive,
                            onPinnedChanged: widget.onPinnedChanged,
                            onWatchingToggled: widget.onWatchingToggled,
                            onRecurrenceToggled: widget.onRecurrenceToggled,
                            onRecurrenceConfigured:
                                widget.onRecurrenceConfigured,
                            profiles: widget.profiles,
                            customFields: widget.customFields,
                            onCustomFieldChanged: widget.onCustomFieldChanged,
                            searchEligibleProfiles:
                                widget.onSearchEligibleProfiles,
                          ),
                        );
                      },
                      excludeFromSemantics: true,
                      child: Column(
                        mainAxisSize: .min,
                        crossAxisAlignment: .start,
                        mainAxisAlignment: .center,
                        children: [
                          Text(
                            task.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.bodyMedium?.copyWith(
                              color: context.colors.onSurface,
                              fontWeight: task.isPinned
                                  ? FontWeight.w700
                                  : FontWeight.w600,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Row(
                            mainAxisSize: .min,
                            children: [
                              Text(
                                task.key,
                                // Klucz zadania to metadana: token 11 px zamiast
                                // lokalnego 9,5 px, które schodziło pod podłogę
                                // czytelności.
                                style: context.tasksTheme.metaText.copyWith(
                                  height: 1,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: .1,
                                  color: context.colors.onSurfaceVariant,
                                ),
                              ),
                              if (task.milestoneId != null) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const .symmetric(
                                    horizontal: 4,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.colors.tertiaryContainer
                                        .withValues(alpha: .5),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Row(
                                    mainAxisSize: .min,
                                    children: [
                                      Icon(
                                        Icons.flag_rounded,
                                        size: 9,
                                        color:
                                            context.colors.onTertiaryContainer,
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        context.l10n.tasksListMilestone,
                                        style: context.tasksTheme.metaText
                                            .copyWith(
                                              height: 1,
                                              fontWeight: FontWeight.w600,
                                              color: context
                                                  .colors
                                                  .onTertiaryContainer,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (task.recurrence case final recurrence?) ...[
                const SizedBox(width: 4),
                Tooltip(
                  message: TaskRecurrenceSummaryLabeler.format(recurrence),
                  child: Container(
                    padding: const .symmetric(
                      horizontal: Sizes.p6,
                      vertical: Sizes.p2,
                    ),
                    decoration: BoxDecoration(
                      color: recurrence.isSourceTask
                          ? context.colors.primaryContainer.withValues(
                              alpha: .6,
                            )
                          : context.colors.surfaceContainerHighest,
                      borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
                      border: Border.all(
                        color: recurrence.isSourceTask
                            ? context.colors.primary.withValues(alpha: .3)
                            : context.colors.outlineVariant.withValues(
                                alpha: .5,
                              ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        Icon(
                          recurrence.isActive
                              ? Symbols.repeat_rounded
                              : Symbols.repeat_one_on_rounded,
                          size: 12,
                          color: recurrence.isActive
                              ? (recurrence.isSourceTask
                                    ? context.colors.primary
                                    : context.colors.onSurfaceVariant)
                              : context.colors.onSurfaceVariant.withValues(
                                  alpha: .5,
                                ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recurrence.isSourceTask
                              ? context.l10n.tasksListRecurrenceSeriesBadge
                              : context.l10n.tasksListRecurrenceCycleBadge,
                          style: context.text.labelSmall?.copyWith(
                            fontSize: context.tasksTheme.metaText.fontSize,
                            fontWeight: .w700,
                            letterSpacing: .2,
                            color: recurrence.isSourceTask
                                ? context.colors.onPrimaryContainer
                                : context.colors.onSurfaceVariant,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              TaskCellTitleActions(
                task: task,
                isHovered: _isHovered,
                onStartEditing: _startEditing,
                onPinnedChanged: widget.onPinnedChanged,
                onWatchingToggled: widget.onWatchingToggled,
                onOpen: widget.onOpen,
                onDuplicate: widget.onDuplicate,
                onCreateSubtask: widget.onCreateSubtask,
                onStatusChanged: widget.onStatusChanged,
                onPriorityChanged: widget.onPriorityChanged,
                onAssigneesChanged: widget.onAssigneesChanged,
                onDueDateChanged: widget.onDueDateChanged,
                onArchive: widget.onArchive,
                onRecurrenceToggled: widget.onRecurrenceToggled,
                onRecurrenceConfigured: widget.onRecurrenceConfigured,
                profiles: widget.profiles,
                customFields: widget.customFields,
                onCustomFieldChanged: widget.onCustomFieldChanged,
                onSearchEligibleProfiles: widget.onSearchEligibleProfiles,
              ),
              if (widget.showKey) ...[
                const SizedBox(width: 8),
                Text(
                  task.key,
                  style: context.text.labelSmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
