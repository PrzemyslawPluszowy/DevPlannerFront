import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/cubit/project_recurrences_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/task_recurrence_context_editor.dart';
import 'package:devplanner/workspaces/presentation/tasks/recurrence/task_recurrence_text_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wiersz reguły cyklicznej z lokalnym stanem hover i akcjami serii.
final class ProjectRecurrencesRuleCard extends StatefulWidget {
  const ProjectRecurrencesRuleCard({
    required this.rule,
    required this.isActionInProgress,
    required this.workspaceId,
    required this.projectId,
    super.key,
  });

  final ProjectTaskRecurrenceItemResponse rule;
  final bool isActionInProgress;
  final String workspaceId;
  final String projectId;

  @override
  State<ProjectRecurrencesRuleCard> createState() =>
      _ProjectRecurrencesRuleCardState();
}

final class _ProjectRecurrencesRuleCardState
    extends State<ProjectRecurrencesRuleCard> {
  final _isHovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isHovered.dispose();
    super.dispose();
  }

  Future<void> _openEditor(BuildContext context) async {
    final rule = widget.rule;
    final taskRecurrence = TaskRecurrenceSummaryResponse(
      id: rule.id,
      sourceTaskId: rule.sourceTaskId,
      mode: rule.mode,
      frequency: rule.frequency,
      interval: rule.interval,
      timeZoneId: rule.timeZoneId,
      nextOccurrenceAtUtc: rule.nextOccurrenceAtUtc,
      occurrenceStatus: rule.occurrenceStatus,
      skipIfPreviousOpen: rule.skipIfPreviousOpen,
      isActive: rule.isActive,
      isSourceTask: true,
      version: rule.version,
    );
    final box = context.findRenderObject() as RenderBox?;
    final position = box?.localToGlobal(Offset(0, box.size.height));
    final cubit = context.read<ProjectRecurrencesCubit>();
    await TaskRecurrenceContextEditorLauncher.show(
      context,
      globalPosition: position,
      taskRecurrence: taskRecurrence,
      repository: context.read<TaskRecurrenceRepository>(),
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      taskId: rule.sourceTaskId,
      taskVersion: rule.version,
      hasRecurrence: true,
      onSaved: (_) => unawaited(cubit.load()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rule = widget.rule;
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isHovered,
        builder: (context, isHovered, _) => Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
          decoration: BoxDecoration(
            color: isHovered
                ? context.colors.surfaceContainerHighest.withValues(alpha: .5)
                : context.colors.surfaceContainerLow,
            border: Border(
              bottom: BorderSide(
                color: context.colors.outlineVariant.withValues(alpha: .5),
              ),
            ),
          ),
          child: Row(
            children: [
              _RuleStatusCell(isActive: rule.isActive),
              _RuleTaskCell(taskKey: rule.taskKey, taskTitle: rule.taskTitle),
              _RuleScheduleCell(rule: rule),
              _RuleNextOccurrenceCell(rule: rule),
              _RuleActions(
                rule: rule,
                isActionInProgress: widget.isActionInProgress,
                onEdit: () => unawaited(_openEditor(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _RuleStatusCell extends StatelessWidget {
  const _RuleStatusCell({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p8,
            vertical: Sizes.p2,
          ),
          decoration: BoxDecoration(
            color: isActive
                ? context.colors.primaryContainer
                : context.colors.surfaceContainerHighest,
            borderRadius: const BorderRadius.all(Radius.circular(Sizes.p999)),
            border: Border.all(
              color: isActive
                  ? context.colors.primary.withValues(alpha: .2)
                  : context.colors.outlineVariant.withValues(alpha: .4),
            ),
          ),
          child: Text(
            isActive
                ? context.l10n.tasksRecurrenceActive
                : context.l10n.tasksRecurrencePaused,
            style: context.text.labelSmall?.copyWith(
              color: isActive
                  ? context.colors.onPrimaryContainer
                  : context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

final class _RuleTaskCell extends StatelessWidget {
  const _RuleTaskCell({required this.taskKey, required this.taskTitle});

  final String taskKey;
  final String taskTitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.only(right: Sizes.p12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p6,
                vertical: Sizes.p2,
              ),
              decoration: BoxDecoration(
                color: context.colors.surfaceContainerHighest,
                borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
              ),
              child: Text(
                taskKey,
                style: context.text.labelSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
            Gaps.w8,
            Expanded(
              child: Text(
                taskTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _RuleScheduleCell extends StatelessWidget {
  const _RuleScheduleCell({required this.rule});

  final ProjectTaskRecurrenceItemResponse rule;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: _RuleInfoCell(
        icon: Symbols.schedule_rounded,
        label: TaskRecurrenceTextFormatter.intervalLabel(
          context,
          rule.frequency,
          rule.interval,
        ),
      ),
    );
  }
}

final class _RuleNextOccurrenceCell extends StatelessWidget {
  const _RuleNextOccurrenceCell({required this.rule});

  final ProjectTaskRecurrenceItemResponse rule;

  @override
  Widget build(BuildContext context) {
    final date = rule.nextOccurrenceAtUtc;
    final formatted = date == null
        ? rule.mode == TaskRecurrenceMode.scheduled
              ? 'Brak terminu'
              : 'Oczekuje na ukończenie'
        : DateFormat.yMMMd('pl').add_Hm().format(date.toLocal());
    final label =
        rule.mode == TaskRecurrenceMode.afterCompletion && date != null
        ? '$formatted (po ukończeniu)'
        : formatted;
    return Expanded(
      flex: 3,
      child: _RuleInfoCell(icon: Symbols.event, label: label),
    );
  }
}

final class _RuleInfoCell extends StatelessWidget {
  const _RuleInfoCell({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: Sizes.p12),
      child: Row(
        children: [
          Icon(icon, size: Sizes.p16, color: context.colors.onSurfaceVariant),
          Gaps.w6,
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _RuleActions extends StatelessWidget {
  const _RuleActions({
    required this.rule,
    required this.isActionInProgress,
    required this.onEdit,
  });

  final ProjectTaskRecurrenceItemResponse rule;
  final bool isActionInProgress;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectRecurrencesCubit>();
    return SizedBox(
      width: 172,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            tooltip: rule.isActive
                ? context.l10n.taskDetailsRecurrencePause
                : context.l10n.taskDetailsRecurrenceResume,
            onPressed: isActionInProgress
                ? null
                : () => unawaited(cubit.togglePause(rule)),
            icon: Icon(
              rule.isActive
                  ? Symbols.pause_rounded
                  : Symbols.play_arrow_rounded,
              size: Sizes.p18,
            ),
          ),
          IconButton(
            tooltip: context.l10n.tasksRecurrenceRunNow,
            onPressed: isActionInProgress
                ? null
                : () => unawaited(cubit.triggerRunNow(rule)),
            icon: const Icon(Symbols.flash_on_rounded, size: Sizes.p18),
          ),
          IconButton(
            tooltip: context.l10n.tasksRecurrenceEdit,
            onPressed: isActionInProgress ? null : onEdit,
            icon: const Icon(Symbols.edit, size: Sizes.p18),
          ),
          IconButton(
            tooltip: context.l10n.tasksRecurrenceDelete,
            onPressed: isActionInProgress
                ? null
                : () => unawaited(cubit.deleteRule(rule)),
            icon: Icon(
              Symbols.delete_outline_rounded,
              size: Sizes.p18,
              color: context.colors.error,
            ),
          ),
        ],
      ),
    );
  }
}
