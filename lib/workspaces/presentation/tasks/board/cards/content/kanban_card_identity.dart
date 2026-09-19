part of '../../tasks_board_page.dart';

/// Górny wiersz karty: selekcja, kod, cykliczność, priorytet i menu akcji.
class _CardIdentity extends StatefulWidget {
  const _CardIdentity({
    required this.task,
    required this.isSelected,
    required this.workspaceId,
    required this.projectId,
    required this.memberProfilesByUserId,
  });

  final KanbanTaskCardResponse task;
  final bool isSelected;
  final String workspaceId;
  final String projectId;
  final Map<String, ProjectMemberProfile> memberProfilesByUserId;

  @override
  State<_CardIdentity> createState() => _CardIdentityState();
}

class _CardIdentityState extends State<_CardIdentity> {
  final _isHovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isHovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: _isHovered,
    builder: (context, hovered, _) {
      final showCheckbox = widget.isSelected || hovered;
      return MouseRegion(
        onEnter: (_) => _isHovered.value = true,
        onExit: (_) => _isHovered.value = false,
        child: Row(
          children: [
            SizedBox(
              width: 18,
              height: 18,
              child: Opacity(
                opacity: showCheckbox ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: !showCheckbox,
                  child: Semantics(
                    label: context.l10n.tasksSelectTask(widget.task.taskCode),
                    child: Checkbox(
                      value: widget.isSelected,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (_) => context
                          .read<TasksBoardCubit>()
                          .toggleTaskSelection(widget.task),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 160),
              child: Text(
                widget.task.taskCode,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: KanbanCardTokens.taskCode(context),
              ),
            ),
            if (widget.task.recurrence case final recurrence?) ...[
              const SizedBox(width: 6),
              Icon(
                recurrence.isActive
                    ? Symbols.repeat_rounded
                    : Symbols.repeat_one_on_rounded,
                size: 13,
                color: recurrence.isSourceTask
                    ? context.colors.primary
                    : context.colors.onSurfaceVariant.withValues(alpha: .7),
              ),
            ],
            const Spacer(),
            _PriorityIndicator(priority: widget.task.priority),
            const SizedBox(width: 4),
            Builder(
              builder: (buttonContext) => IconButton(
                tooltip: context.l10n.tasksListMoreOptionsTooltip,
                visualDensity: VisualDensity.compact,
                constraints: const BoxConstraints.tightFor(
                  width: KanbanCardTokens.minTouchTarget,
                  height: KanbanCardTokens.minTouchTarget,
                ),
                padding: EdgeInsets.zero,
                onPressed: () => unawaited(
                  KanbanCardContextMenuHelper.show(
                    context: buttonContext,
                    task: widget.task,
                    workspaceId: widget.workspaceId,
                    projectId: widget.projectId,
                    memberProfilesByUserId: widget.memberProfilesByUserId,
                  ),
                ),
                icon: const Icon(Symbols.more_horiz_rounded, size: 16),
              ),
            ),
          ],
        ),
      );
    },
  );
}
