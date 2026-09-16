part of '../project_recurrences_sheet.dart';

/// Nowoczesny, zwarty wiersz historii wykonania cyklu.
class _ProjectRecurrencesRunCard extends StatefulWidget {
  const _ProjectRecurrencesRunCard({required this.run});

  final ProjectTaskRecurrenceRunResponse run;

  @override
  State<_ProjectRecurrencesRunCard> createState() =>
      _ProjectRecurrencesRunCardState();
}

class _ProjectRecurrencesRunCardState
    extends State<_ProjectRecurrencesRunCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd('pl').add_Hm();
    final timeText = dateFormat.format(widget.run.executedAtUtc.toLocal());

    final isCreated = widget.run.outcome == TaskRecurrenceRunOutcome.created;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        height: 42,
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
        padding: const .symmetric(horizontal: Sizes.p16),
        child: Row(
          children: [
            // Status wyniku jako mała pigułka
            SizedBox(
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
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Sizes.p999),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCreated
                            ? Symbols.check_circle_rounded
                            : Symbols.info_rounded,
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
            ),
            // Zadanie źródłowe (Klucz + Tytuł)
            Expanded(
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
                        borderRadius: const BorderRadius.all(
                          Radius.circular(Sizes.p4),
                        ),
                      ),
                      child: Text(
                        widget.run.taskKey,
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
                        widget.run.taskTitle,
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
            ),
            // Utworzone zadanie (jeśli utworzono)
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.only(right: Sizes.p12),
                child: widget.run.createdTaskKey != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Symbols.arrow_forward_rounded,
                            size: Sizes.p16,
                            color: context.colors.primary,
                          ),
                          Gaps.w6,
                          Text(
                            widget.run.createdTaskKey!,
                            style: context.text.bodySmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: context.colors.primary,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        '—',
                        style: context.text.bodySmall?.copyWith(
                          color: context.colors.onSurfaceVariant.withValues(
                            alpha: .5,
                          ),
                        ),
                      ),
              ),
            ),
            // Czas wykonania
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
    );
  }
}
