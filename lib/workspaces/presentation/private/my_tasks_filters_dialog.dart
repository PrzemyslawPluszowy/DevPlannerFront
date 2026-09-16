import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/shell/overlay/app_modal_picker_host.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';

/// Kryteria odczytu listy „Moje zadania”, zgodne z parametrami endpointu.
final class MyTasksFilters {
  const MyTasksFilters({
    this.status,
    this.priority,
    this.involvement,
    this.dueFromUtc,
    this.dueToUtc,
  });

  final ProjectTaskStatus? status;
  final TaskPriority? priority;
  final TaskInvolvementFilter? involvement;
  final DateTime? dueFromUtc;
  final DateTime? dueToUtc;
}

/// Dialog filtrów zadań, wydzielony z routingu dla małego rozmiaru widżetów.
class MyTasksFiltersDialog extends StatefulWidget {
  const MyTasksFiltersDialog({required this.initial, super.key});

  final MyTasksFilters initial;

  @override
  State<MyTasksFiltersDialog> createState() => _MyTasksFiltersDialogState();
}

class _MyTasksFiltersDialogState extends State<MyTasksFiltersDialog> {
  late ProjectTaskStatus? _status = widget.initial.status;
  late TaskPriority? _priority = widget.initial.priority;
  late TaskInvolvementFilter? _involvement = widget.initial.involvement;
  late DateTime? _dueFromUtc = widget.initial.dueFromUtc;
  late DateTime? _dueToUtc = widget.initial.dueToUtc;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return WorkspaceCreationModalWrapper(
      title: l10n.myTasksFiltersTitle,
      subtitle: l10n.myTasksFiltersSubtitle,
      icon: Symbols.filter_alt_rounded,
      submitLabel: l10n.myTasksApply,
      cancelLabel: l10n.cancel,
      maxWidth: 420,
      onSubmit: _apply,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.myTasksStatus,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h6,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ProjectTaskStatus?>(
                value: _status,
                isExpanded: true,
                dropdownColor: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                elevation: 3,
                menuMaxHeight: 260,
                style: context.text.bodySmall?.copyWith(fontSize: 13),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                items: [
                  DropdownMenuItem(
                    child: Text(
                      l10n.myTasksAll,
                      style: const TextStyle(fontSize: 12.5),
                    ),
                  ),
                  for (final status in ProjectTaskStatus.values)
                    DropdownMenuItem(
                      value: status,
                      child: Text(
                        myTasksStatusLabel(l10n, status),
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => _status = value),
              ),
            ),
          ),
          Gaps.h12,
          Text(
            l10n.myTasksPriority,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h6,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<TaskPriority?>(
                value: _priority,
                isExpanded: true,
                dropdownColor: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                elevation: 3,
                menuMaxHeight: 260,
                style: context.text.bodySmall?.copyWith(fontSize: 13),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                items: [
                  DropdownMenuItem(
                    child: Text(
                      l10n.myTasksAll,
                      style: const TextStyle(fontSize: 12.5),
                    ),
                  ),
                  for (final priority in TaskPriority.values)
                    DropdownMenuItem(
                      value: priority,
                      child: Text(
                        myTasksPriorityLabel(l10n, priority),
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => _priority = value),
              ),
            ),
          ),
          Gaps.h12,
          Text(
            l10n.myTasksInvolvement,
            style: context.text.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h6,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<TaskInvolvementFilter?>(
                value: _involvement,
                isExpanded: true,
                dropdownColor: colors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(8),
                elevation: 3,
                menuMaxHeight: 260,
                style: context.text.bodySmall?.copyWith(fontSize: 13),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                items: [
                  DropdownMenuItem(
                    child: Text(
                      l10n.myTasksAny,
                      style: const TextStyle(fontSize: 12.5),
                    ),
                  ),
                  for (final involvement in TaskInvolvementFilter.values)
                    DropdownMenuItem(
                      value: involvement,
                      child: Text(
                        myTasksInvolvementLabel(l10n, involvement),
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                ],
                onChanged: (value) => setState(() => _involvement = value),
              ),
            ),
          ),
          Gaps.h12,
          _DateFilterField(
            label: l10n.myTasksDueFrom,
            value: _dueFromUtc,
            onChanged: (value) => setState(() => _dueFromUtc = value),
          ),
          Gaps.h8,
          _DateFilterField(
            label: l10n.myTasksDueTo,
            value: _dueToUtc,
            onChanged: (value) => setState(() => _dueToUtc = value),
          ),
          if (_error != null) ...[
            Gaps.h8,
            Text(
              _error!,
              style: TextStyle(color: colors.error, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  void _apply() {
    if (_dueFromUtc != null &&
        _dueToUtc != null &&
        _dueToUtc!.isBefore(_dueFromUtc!)) {
      setState(
        () => _error = context.l10n.myTasksInvalidDueRange,
      );
      return;
    }
    Navigator.of(context).pop(
      MyTasksFilters(
        status: _status,
        priority: _priority,
        involvement: _involvement,
        dueFromUtc: _dueFromUtc,
        dueToUtc: _dueToUtc,
      ),
    );
  }
}

class _DateFilterField extends StatelessWidget {
  const _DateFilterField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.text.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: colors.onSurfaceVariant,
          ),
        ),
        Gaps.h4,
        InkWell(
          onTap: () async {
            final date = await AppModalPickerHost.showDate(
              context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: value ?? DateTime.now(),
            );
            if (date != null) onChanged(date);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.outlineVariant.withValues(alpha: 0.7),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Symbols.calendar_today_rounded,
                  size: 15,
                  color: colors.onSurfaceVariant,
                ),
                Gaps.w8,
                Expanded(
                  child: Text(
                    value == null
                        ? context.l10n.myTasksAnyDueDate
                        : MaterialLocalizations.of(context)
                              .formatMediumDate(value!),
                    style: TextStyle(
                      fontSize: 12.5,
                      color: value == null
                          ? colors.onSurfaceVariant.withValues(alpha: .7)
                          : colors.onSurface,
                    ),
                  ),
                ),
                if (value != null)
                  IconButton(
                    tooltip: context.l10n.myTasksClear,
                    onPressed: () => onChanged(null),
                    icon: const Icon(Symbols.close_rounded, size: 14),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

String? myTasksStatusValue(ProjectTaskStatus? value) => switch (value) {
  ProjectTaskStatus.backlog => 'Backlog',
  ProjectTaskStatus.todo => 'Todo',
  ProjectTaskStatus.inProgress => 'InProgress',
  ProjectTaskStatus.blocked => 'Blocked',
  ProjectTaskStatus.done => 'Done',
  ProjectTaskStatus.cancelled => 'Cancelled',
  null => null,
};

String? myTasksPriorityValue(TaskPriority? value) => switch (value) {
  TaskPriority.low => 'Low',
  TaskPriority.normal => 'Normal',
  TaskPriority.high => 'High',
  TaskPriority.critical => 'Critical',
  null => null,
};

String? myTasksInvolvementValue(TaskInvolvementFilter? value) =>
    switch (value) {
      TaskInvolvementFilter.any => 'Any',
      TaskInvolvementFilter.primaryAssignee => 'PrimaryAssignee',
      TaskInvolvementFilter.collaborator => 'Collaborator',
      TaskInvolvementFilter.assignee => 'Assignee',
      TaskInvolvementFilter.watcher => 'Watcher',
      null => null,
    };

String myTasksStatusLabel(AppLocalizations l10n, ProjectTaskStatus value) =>
    switch (value) {
      ProjectTaskStatus.backlog => l10n.taskStatusBacklog,
      ProjectTaskStatus.todo => l10n.taskStatusTodo,
      ProjectTaskStatus.inProgress => l10n.taskStatusInProgress,
      ProjectTaskStatus.blocked => l10n.taskStatusBlocked,
      ProjectTaskStatus.done => l10n.taskStatusDone,
      ProjectTaskStatus.cancelled => l10n.taskStatusCanceled,
    };

String myTasksPriorityLabel(AppLocalizations l10n, TaskPriority value) =>
    switch (value) {
      TaskPriority.low => l10n.myTasksPriorityLow,
      TaskPriority.normal => l10n.myTasksPriorityNormal,
      TaskPriority.high => l10n.myTasksPriorityHigh,
      TaskPriority.critical => l10n.myTasksPriorityCritical,
    };

String myTasksInvolvementLabel(
  AppLocalizations l10n,
  TaskInvolvementFilter value,
) => switch (value) {
  TaskInvolvementFilter.any => l10n.myTasksInvolvementAny,
  TaskInvolvementFilter.primaryAssignee =>
    l10n.myTasksInvolvementPrimaryAssignee,
  TaskInvolvementFilter.collaborator => l10n.myTasksInvolvementCollaborator,
  TaskInvolvementFilter.assignee => l10n.myTasksInvolvementAssignee,
  TaskInvolvementFilter.watcher => l10n.myTasksInvolvementWatcher,
};
