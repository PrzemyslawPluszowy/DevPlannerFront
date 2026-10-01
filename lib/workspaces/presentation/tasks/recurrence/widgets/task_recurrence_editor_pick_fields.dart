import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

final class TaskRecurrenceFrequencyPicker extends StatefulWidget {
  const TaskRecurrenceFrequencyPicker({
    required this.frequency,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final TaskRecurrenceFrequency frequency;
  final bool enabled;
  final ValueChanged<TaskRecurrenceFrequency> onChanged;

  @override
  State<TaskRecurrenceFrequencyPicker> createState() =>
      _TaskRecurrenceFrequencyPickerState();
}

final class _TaskRecurrenceFrequencyPickerState
    extends State<TaskRecurrenceFrequencyPicker> {
  Future<void> _open(BuildContext sourceContext) async {
    final sourceValue = widget.frequency;
    final l10n = sourceContext.l10n;
    final selected = await AppContextMenu.select<TaskRecurrenceFrequency>(
      sourceContext,
      globalPosition: AppContextMenu.positionFor(sourceContext),
      headerTitle: l10n.taskRecurrenceFrequencyLabel,
      options: [
        AppContextMenuOption(
          value: TaskRecurrenceFrequency.daily,
          label: l10n.taskRecurrenceUnitDays,
          selected: sourceValue == TaskRecurrenceFrequency.daily,
        ),
        AppContextMenuOption(
          value: TaskRecurrenceFrequency.weekly,
          label: l10n.taskRecurrenceUnitWeeks,
          selected: sourceValue == TaskRecurrenceFrequency.weekly,
        ),
        AppContextMenuOption(
          value: TaskRecurrenceFrequency.monthly,
          label: l10n.taskRecurrenceUnitMonths,
          selected: sourceValue == TaskRecurrenceFrequency.monthly,
        ),
      ],
    );
    if (!mounted ||
        !sourceContext.mounted ||
        selected == null ||
        !widget.enabled ||
        widget.frequency != sourceValue ||
        selected == sourceValue) {
      return;
    }
    widget.onChanged(selected);
  }

  String _label(BuildContext context) => switch (widget.frequency) {
    TaskRecurrenceFrequency.daily => context.l10n.taskRecurrenceUnitDays,
    TaskRecurrenceFrequency.weekly => context.l10n.taskRecurrenceUnitWeeks,
    TaskRecurrenceFrequency.monthly => context.l10n.taskRecurrenceUnitMonths,
  };

  @override
  Widget build(BuildContext context) => _RecurrenceMenuField(
    label: context.l10n.taskRecurrenceFrequencyLabel,
    value: _label(context),
    enabled: widget.enabled,
    onPressed: _open,
  );
}

final class TaskRecurrenceStatusPicker extends StatefulWidget {
  const TaskRecurrenceStatusPicker({
    required this.status,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  final ProjectTaskStatus status;
  final bool enabled;
  final ValueChanged<ProjectTaskStatus> onChanged;

  @override
  State<TaskRecurrenceStatusPicker> createState() =>
      _TaskRecurrenceStatusPickerState();
}

final class _TaskRecurrenceStatusPickerState
    extends State<TaskRecurrenceStatusPicker> {
  Future<void> _open(BuildContext sourceContext) async {
    final sourceValue = widget.status;
    final l10n = sourceContext.l10n;
    final selected = await AppContextMenu.select<ProjectTaskStatus>(
      sourceContext,
      globalPosition: AppContextMenu.positionFor(sourceContext),
      headerTitle: l10n.taskRecurrenceOccurrenceStatus,
      options: [
        AppContextMenuOption(
          value: ProjectTaskStatus.todo,
          label: l10n.tasksListStatusTodo,
          selected: sourceValue == ProjectTaskStatus.todo,
        ),
        AppContextMenuOption(
          value: ProjectTaskStatus.inProgress,
          label: l10n.tasksListStatusInProgress,
          selected: sourceValue == ProjectTaskStatus.inProgress,
        ),
      ],
    );
    if (!mounted ||
        !sourceContext.mounted ||
        selected == null ||
        !widget.enabled ||
        widget.status != sourceValue ||
        selected == sourceValue) {
      return;
    }
    widget.onChanged(selected);
  }

  String _label(BuildContext context) => switch (widget.status) {
    ProjectTaskStatus.backlog => context.l10n.tasksListStatusBacklog,
    ProjectTaskStatus.todo => context.l10n.tasksListStatusTodo,
    ProjectTaskStatus.inProgress => context.l10n.tasksListStatusInProgress,
    ProjectTaskStatus.blocked => context.l10n.tasksListStatusBlocked,
    ProjectTaskStatus.done => context.l10n.tasksListStatusDone,
    ProjectTaskStatus.cancelled => context.l10n.tasksListStatusCancelled,
  };

  @override
  Widget build(BuildContext context) => _RecurrenceMenuField(
    label: context.l10n.taskRecurrenceOccurrenceStatus,
    value: _label(context),
    enabled: widget.enabled,
    onPressed: _open,
  );
}

final class _RecurrenceMenuField extends StatelessWidget {
  const _RecurrenceMenuField({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final String value;
  final bool enabled;
  final ValueChanged<BuildContext> onPressed;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        style: context.tasksTheme.metaText.copyWith(
          color: context.colors.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: Sizes.p4),
      Builder(
        builder: (buttonContext) => Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? () => onPressed(buttonContext) : null,
            borderRadius: BorderRadius.circular(
              context.tasksTheme.controlRadius,
            ),
            child: Container(
              constraints: const BoxConstraints(minHeight: 36),
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
              decoration: BoxDecoration(
                color: enabled
                    ? context.tasksTheme.canvas
                    : context.tasksTheme.commandBarSurface,
                borderRadius: BorderRadius.circular(
                  context.tasksTheme.controlRadius,
                ),
                border: Border.all(color: context.tasksTheme.canvasBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.tasksTheme.controlText.copyWith(
                        color: enabled
                            ? context.colors.onSurface
                            : context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Icon(
                    Symbols.expand_more_rounded,
                    size: 18,
                    color: context.colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
