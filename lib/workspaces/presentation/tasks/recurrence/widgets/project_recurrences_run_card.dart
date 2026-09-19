import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_advanced_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_advanced_enums.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wiersz historii wykonania serii z lokalnym stanem hover.
final class ProjectRecurrencesRunCard extends StatefulWidget {
  const ProjectRecurrencesRunCard({required this.run, super.key});

  final ProjectTaskRecurrenceRunResponse run;

  @override
  State<ProjectRecurrencesRunCard> createState() =>
      _ProjectRecurrencesRunCardState();
}

final class _ProjectRecurrencesRunCardState
    extends State<ProjectRecurrencesRunCard> {
  final _isHovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timeText = DateFormat.yMMMd('pl').add_Hm().format(
      widget.run.executedAtUtc.toLocal(),
    );
    final isCreated = widget.run.outcome == TaskRecurrenceRunOutcome.created;
    return MouseRegion(
      onEnter: (_) => _isHovered.value = true,
      onExit: (_) => _isHovered.value = false,
      child: ValueListenableBuilder<bool>(
        valueListenable: _isHovered,
        builder: (context, isHovered, _) => Container(
          height: 42,
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
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
          child: Row(
            children: [
              _RunOutcomeCell(isCreated: isCreated),
              _RunTaskCell(
                taskKey: widget.run.taskKey,
                taskTitle: widget.run.taskTitle,
              ),
              _RunCreatedTaskCell(createdTaskKey: widget.run.createdTaskKey),
              Expanded(
                flex: 2,
                child: Text(
                  timeText,
                  style: context.text.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _RunOutcomeCell extends StatelessWidget {
  const _RunOutcomeCell({required this.isCreated});

  final bool isCreated;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Sizes.p8,
            vertical: Sizes.p2,
          ),
          decoration: BoxDecoration(
            color: isCreated
                ? context.colors.primaryContainer
                : context.colors.surfaceContainerHighest,
            borderRadius: const BorderRadius.all(Radius.circular(Sizes.p999)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isCreated ? Symbols.check_circle_rounded : Symbols.info_rounded,
                size: Sizes.p16,
                color: isCreated
                    ? context.colors.onPrimaryContainer
                    : context.colors.onSurfaceVariant,
              ),
              Gaps.w6,
              Text(
                isCreated
                    ? context.l10n.tasksRecurrenceOutcomeCreated
                    : context.l10n.tasksRecurrenceOutcomeSkipped,
                style: context.text.labelSmall?.copyWith(
                  color: isCreated
                      ? context.colors.onPrimaryContainer
                      : context.colors.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _RunTaskCell extends StatelessWidget {
  const _RunTaskCell({required this.taskKey, required this.taskTitle});

  final String taskKey;
  final String taskTitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
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
                  letterSpacing: -.1,
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _RunCreatedTaskCell extends StatelessWidget {
  const _RunCreatedTaskCell({required this.createdTaskKey});

  final String? createdTaskKey;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.only(right: Sizes.p12),
        child: createdTaskKey == null
            ? Text(
                '—',
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant.withValues(alpha: .5),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Symbols.arrow_forward_rounded,
                    size: Sizes.p16,
                    color: context.colors.primary,
                  ),
                  Gaps.w6,
                  Text(
                    createdTaskKey!,
                    style: context.text.bodySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: context.colors.primary,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
