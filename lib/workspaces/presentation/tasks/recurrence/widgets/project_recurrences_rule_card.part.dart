part of '../project_recurrences_sheet.dart';

/// Nowoczesny, zwarty wiersz tabeli reguły zadania cyklicznego w stylu Linear / ClickUp.
class _ProjectRecurrencesRuleCard extends StatefulWidget {
  const _ProjectRecurrencesRuleCard({
    required this.rule,
    required this.isActionInProgress,
    required this.workspaceId,
    required this.projectId,
  });

  final ProjectTaskRecurrenceItemResponse rule;
  final bool isActionInProgress;
  final String workspaceId;
  final String projectId;

  @override
  State<_ProjectRecurrencesRuleCard> createState() =>
      _ProjectRecurrencesRuleCardState();
}

class _ProjectRecurrencesRuleCardState
    extends State<_ProjectRecurrencesRuleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProjectRecurrencesCubit>();
    final dateFormat = DateFormat.yMMMd('pl').add_Hm();
    final nextDateText = switch (widget.rule.mode) {
      TaskRecurrenceMode.scheduled =>
        widget.rule.nextOccurrenceAtUtc != null
            ? dateFormat.format(widget.rule.nextOccurrenceAtUtc!.toLocal())
            : 'Brak terminu',
      TaskRecurrenceMode.afterCompletion =>
        widget.rule.nextOccurrenceAtUtc != null
            ? '${dateFormat.format(widget.rule.nextOccurrenceAtUtc!.toLocal())} (po ukończeniu)'
            : 'Oczekuje na ukończenie',
    };

    final isActive = widget.rule.isActive;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: _isHovered
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
            // Status serii (Aktywna / Wstrzymana) jako zwarta pigułka
            SizedBox(
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
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Sizes.p999),
                    ),
                    border: Border.all(
                      color: isActive
                          ? context.colors.primary.withValues(alpha: .2)
                          : context.colors.outlineVariant.withValues(alpha: .4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? context.colors.primary
                              : context.colors.onSurfaceVariant.withValues(
                                  alpha: .5,
                                ),
                        ),
                      ),
                      Gaps.w6,
                      Text(
                        isActive
                            ? context.l10n.tasksRecurrenceActive
                            : context.l10n.tasksRecurrencePaused,
                        style: context.text.labelSmall?.copyWith(
                          color: isActive
                              ? context.colors.onPrimaryContainer
                              : context.colors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Zadanie źródłowe (Klucz + Tytuł)
            Expanded(
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
                        borderRadius: const BorderRadius.all(
                          Radius.circular(Sizes.p4),
                        ),
                      ),
                      child: Text(
                        widget.rule.taskKey,
                        style: context.text.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.1,
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Gaps.w8,
                    Expanded(
                      child: Text(
                        widget.rule.taskTitle,
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
            ),
            // Interwał / Częstotliwość
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: Sizes.p12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Symbols.schedule_rounded,
                      size: Sizes.p16,
                      color: context.colors.onSurfaceVariant,
                    ),
                    Gaps.w6,
                    Flexible(
                      child: Text(
                        context.recurrenceIntervalLabel(
                          widget.rule.frequency,
                          widget.rule.interval,
                        ),
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
              ),
            ),
            // Następne wystąpienie
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: Sizes.p12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Symbols.event,
                      size: Sizes.p16,
                      color: context.colors.onSurfaceVariant,
                    ),
                    Gaps.w6,
                    Flexible(
                      child: Text(
                        nextDateText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Akcje w wierszu
            SizedBox(
              width: 172,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Tooltip(
                    message: isActive
                        ? context.l10n.taskDetailsRecurrencePause
                        : context.l10n.taskDetailsRecurrenceResume,
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: widget.isActionInProgress
                          ? null
                          : () => unawaited(cubit.togglePause(widget.rule)),
                      icon: Icon(
                        isActive
                            ? Symbols.pause_rounded
                            : Symbols.play_arrow_rounded,
                        size: Sizes.p18,
                      ),
                    ),
                  ),
                  Tooltip(
                    message: context.l10n.tasksRecurrenceRunNow,
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: widget.isActionInProgress
                          ? null
                          : () => unawaited(cubit.triggerRunNow(widget.rule)),
                      icon: const Icon(
                        Symbols.flash_on_rounded,
                        size: Sizes.p18,
                      ),
                    ),
                  ),
                  Builder(
                    builder: (btnContext) => Tooltip(
                      message: context.l10n.tasksRecurrenceEdit,
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: widget.isActionInProgress
                            ? null
                            : () => _openEditor(btnContext),
                        icon: const Icon(Symbols.edit, size: Sizes.p18),
                      ),
                    ),
                  ),
                  Tooltip(
                    message: context.l10n.tasksRecurrenceDelete,
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: widget.isActionInProgress
                          ? null
                          : () => unawaited(cubit.deleteRule(widget.rule)),
                      icon: Icon(
                        Symbols.delete_outline_rounded,
                        size: Sizes.p18,
                        color: context.colors.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openEditor(BuildContext context) async {
    final taskRecurrence = TaskRecurrenceSummaryResponse(
      id: widget.rule.id,
      sourceTaskId: widget.rule.sourceTaskId,
      mode: widget.rule.mode,
      frequency: widget.rule.frequency,
      interval: widget.rule.interval,
      timeZoneId: widget.rule.timeZoneId,
      nextOccurrenceAtUtc: widget.rule.nextOccurrenceAtUtc,
      occurrenceStatus: widget.rule.occurrenceStatus,
      skipIfPreviousOpen: widget.rule.skipIfPreviousOpen,
      isActive: widget.rule.isActive,
      isSourceTask: true,
      version: widget.rule.version,
    );

    final box = context.findRenderObject() as RenderBox?;
    final position = box?.localToGlobal(Offset(0, box.size.height));

    final cubit = context.read<ProjectRecurrencesCubit>();
    await showTaskRecurrenceContextEditor(
      context,
      globalPosition: position,
      taskRecurrence: taskRecurrence,
      repository: context.read<TaskRecurrenceRepository>(),
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      taskId: widget.rule.sourceTaskId,
      taskVersion: widget.rule.version,
      hasRecurrence: true,
      onSaved: (_) {
        unawaited(cubit.load());
      },
    );
  }
}
