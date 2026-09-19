part of 'tasks_board_page.dart';

class _DraggableTaskCard extends StatefulWidget {
  const _DraggableTaskCard({
    required this.task,
    required this.workspaceId,
    required this.projectId,
    required this.visibleCardFields,
    required this.density,
    required this.isSelected,
    required this.isPending,
    required this.memberProfilesByUserId,
  });

  final KanbanTaskCardResponse task;
  final String workspaceId;
  final String projectId;
  final List<KanbanCardField> visibleCardFields;
  final KanbanCardDensity density;
  final bool isSelected;
  final bool isPending;
  final Map<String, ProjectMemberProfile> memberProfilesByUserId;

  @override
  State<_DraggableTaskCard> createState() => _DraggableTaskCardState();
}

class _DraggableTaskCardState extends State<_DraggableTaskCard>
    with TickerProviderStateMixin {
  double _cardWidth = 286.0;

  @override
  Widget build(BuildContext context) {
    final card = _TaskCard(
      task: widget.task,
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      visibleCardFields: widget.visibleCardFields,
      density: widget.density,
      isSelected: widget.isSelected,
      memberProfilesByUserId: widget.memberProfilesByUserId,
    );

    final coordinator = KanbanAutoScrollScope.maybeOf(context);

    return Draggable<KanbanTaskCardResponse>(
      data: widget.task,
      maxSimultaneousDrags: widget.isPending ? 0 : 1,
      onDragStarted: () {
        final box = context.findRenderObject() as RenderBox?;
        if (box != null) {
          _cardWidth = box.size.width;
        }
        final initialPos = box != null
            ? box.localToGlobal(Offset.zero)
            : Offset.zero;
        coordinator?.startDrag(this, initialPos);
      },
      onDragUpdate: (details) {
        coordinator?.updatePointer(details.globalPosition);
      },
      onDragEnd: (_) {
        coordinator?.endDrag();
      },
      onDraggableCanceled: (_, _) {
        coordinator?.endDrag();
      },
      feedback: Material(
        color: Colors.transparent,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(KanbanCardTokens.cardRadius),
        child: SizedBox(
          width: _cardWidth,
          child: KanbanCardDragPreview(
            task: widget.task,
            density: widget.density,
            visibleCardFields: widget.visibleCardFields,
            memberProfilesByUserId: widget.memberProfilesByUserId,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: .35,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(KanbanCardTokens.cardRadius),
            color: context.colors.surfaceContainerHighest.withValues(alpha: .2),
          ),
          child: card,
        ),
      ),
      child: card,
    );
  }
}

/// Bezstanowy podgląd karty podczas przeciągania (drag preview).
///
/// Zgodnie z punktem 29 i sekcją 4.12 specyfikacji:
/// - Bezstanowy preview nie tworzy nowego Cubita ani nie inicjuje dodatkowego pobierania danych.
/// - Wyświetla kluczowe metadane rodzica i licznik podzadań w zwartej formie.
/// - Używa spójnej ramki `KanbanDottedCardFrame` z punktowym obrysem.
class KanbanCardDragPreview extends StatelessWidget {
  const KanbanCardDragPreview({
    required this.task,
    required this.density,
    required this.visibleCardFields,
    required this.memberProfilesByUserId,
    super.key,
  });

  final KanbanTaskCardResponse task;
  final KanbanCardDensity density;
  final List<KanbanCardField> visibleCardFields;
  final Map<String, ProjectMemberProfile> memberProfilesByUserId;

  bool get _isCompact => density == KanbanCardDensity.compact;
  bool shows(KanbanCardField field) => visibleCardFields.contains(field);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final padding = _isCompact
        ? KanbanCardTokens.contentPaddingCompact
        : KanbanCardTokens.contentPaddingComfortable;

    return KanbanCardFrame(
      isSelected: true,
      padding: padding,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.taskCode,
                    style: KanbanCardTokens.taskCode(context),
                  ),
                ),
                _PriorityDot(priority: task.priority),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              task.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: KanbanCardTokens.parentTitle(context),
            ),
            if (shows(KanbanCardField.subtasks) && task.subtaskTotal > 0) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Symbols.account_tree_rounded,
                    size: 14,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${context.l10n.tasksSubtasksTitle} (${task.subtaskCompleted}/${task.subtaskTotal})',
                    style: KanbanCardTokens.metaText(context),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PriorityDot extends StatelessWidget {
  const _PriorityDot({required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final label = switch (priority) {
      TaskPriority.low => context.l10n.tasksPriorityLow,
      TaskPriority.normal => context.l10n.tasksPriorityNormal,
      TaskPriority.high => context.l10n.tasksPriorityHigh,
      TaskPriority.critical => context.l10n.tasksPriorityCritical,
    };
    final color = switch (priority) {
      TaskPriority.low => const Color(0xFF3B82F6),
      TaskPriority.normal => const Color(0xFF10B981),
      TaskPriority.high => const Color(0xFFF59E0B),
      TaskPriority.critical => const Color(0xFFEF4444),
    };
    return Tooltip(
      message: label,
      child: Semantics(
        label: label,
        child: Icon(
          Symbols.flag_rounded,
          size: 14,
          color: color,
        ),
      ),
    );
  }
}
