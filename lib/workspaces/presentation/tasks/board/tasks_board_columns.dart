part of 'tasks_board_page.dart';

class KanbanColumnWidget extends StatefulWidget {
  const KanbanColumnWidget({
    required this.workspaceId,
    required this.projectId,
    required this.column,
    required this.visibleCardFields,
    required this.density,
    required this.selectedTaskIds,
    required this.pendingTaskIds,
    required this.memberProfilesByUserId,
    required this.isCollapsed,
    required this.onToggleCollapsed,
    required this.isLoadingMore,
    this.loadError,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final KanbanColumnResponse column;
  final List<KanbanCardField> visibleCardFields;
  final KanbanCardDensity density;
  final Set<String> selectedTaskIds;
  final Set<String> pendingTaskIds;
  final Map<String, ProjectMemberProfile> memberProfilesByUserId;
  final bool isCollapsed;
  final VoidCallback onToggleCollapsed;
  final bool isLoadingMore;
  final String? loadError;

  @override
  State<KanbanColumnWidget> createState() => _KanbanColumnWidgetState();
}

class _KanbanColumnWidgetState extends State<KanbanColumnWidget> {
  late final ScrollController _controller;
  KanbanAutoScrollCoordinator? _coordinator;
  Key? _registeredKey;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _registerCoordinator();
  }

  void _registerCoordinator() {
    final coordinator = KanbanAutoScrollScope.maybeOf(context);
    final key = widget.key;
    if (!identical(_coordinator, coordinator) && _registeredKey != null) {
      _coordinator?.unregisterColumn(_registeredKey!);
      _registeredKey = null;
    }
    _coordinator = coordinator;
    if (coordinator != null && key != null) {
      if (_registeredKey != null && _registeredKey != key) {
        coordinator.unregisterColumn(_registeredKey!);
      }
      coordinator.registerColumn(
        columnKey: key,
        controller: _controller,
        context: context,
      );
      _registeredKey = key;
    }
  }

  void _onScroll() {
    if (_controller.position.extentAfter < 300) {
      unawaited(context.read<TasksBoardCubit>().loadMore(widget.column));
    }
  }

  @override
  void dispose() {
    if (_registeredKey != null) {
      _coordinator?.unregisterColumn(_registeredKey!);
    }
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCollapsed) {
      return _CollapsedKanbanColumn(
        column: widget.column,
        onExpand: widget.onToggleCollapsed,
      );
    }
    final colors = context.colors;
    final accent = TaskBoardColorParser.parse(widget.column.color);
    return Container(
      width: KanbanCardTokens.columnWidthStandard,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: .circular(10),
        border: .all(
          color: colors.outlineVariant.withValues(alpha: .35),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: KanbanCardTokens.columnHeaderHeight,
            padding: const .symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: .4),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accent,
                    shape: .circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.column.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: KanbanCardTokens.columnTitle(context),
                  ),
                ),
                _CountBadge(column: widget.column),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: widget.onToggleCollapsed,
                  icon: Icon(
                    Symbols.keyboard_arrow_left_rounded,
                    size: 18,
                    color: colors.onSurfaceVariant,
                  ),
                  visualDensity: .compact,
                  tooltip: context.l10n.tasksCollapseColumn,
                ),
              ],
            ),
          ),
          Expanded(child: _buildCards(context)),
        ],
      ),
    );
  }

  Widget _buildCards(BuildContext context) {
    final tasks = widget.column.tasks;
    if (tasks.isEmpty) {
      return TaskDropZone(
        column: widget.column,
        targetIndex: 0,
        expand: true,
        child: Column(
          children: [
            Padding(
              padding: const .only(top: 24, bottom: 8),
              child: Text(
                context.l10n.tasksColumnEmpty,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
            _QuickCreateTask(column: widget.column),
          ],
        ),
      );
    }

    final hasExtra = widget.isLoadingMore || widget.loadError != null;
    final extraCount = hasExtra ? 1 : 0;
    final totalCount =
        tasks.length * 2 +
        1 +
        extraCount +
        1; // +1 dla _QuickCreateTask pod kartami

    return ListView.builder(
      controller: _controller,
      padding: const .symmetric(horizontal: 8, vertical: 4),
      itemCount: totalCount,
      itemBuilder: (context, index) {
        final contentLength = tasks.length * 2 + 1;
        if (index == totalCount - 1) {
          // Quick create bezpośrednio pod ostatnią kartą / drop zone
          return Padding(
            padding: const .only(top: 2),
            child: _QuickCreateTask(column: widget.column),
          );
        }
        if (index == contentLength && widget.isLoadingMore) {
          return const Center(
            child: Padding(
              padding: .all(8),
              child: SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        if (index == contentLength && widget.loadError != null) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.errorContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(
                      Symbols.cloud_off,
                      size: 17,
                      color: context.colors.onErrorContainer,
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        widget.loadError!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodySmall?.copyWith(
                          color: context.colors.onErrorContainer,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: context.l10n.retry,
                      visualDensity: VisualDensity.compact,
                      color: context.colors.onErrorContainer,
                      onPressed: () => unawaited(
                        context.read<TasksBoardCubit>().loadMore(widget.column),
                      ),
                      icon: const Icon(Symbols.refresh_rounded, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (index.isEven) {
          final isEndDropZone = index == contentLength - 1;
          return TaskDropZone(
            column: widget.column,
            targetIndex: index ~/ 2,
            expand: isEndDropZone,
            child: isEndDropZone ? const SizedBox(height: 64) : null,
          );
        }
        final task = tasks[index ~/ 2];
        return TaskAfterCardDropTarget(
          column: widget.column,
          targetIndex: index ~/ 2 + 1,
          child: _DraggableTaskCard(
            task: task,
            workspaceId: widget.workspaceId,
            projectId: widget.projectId,
            visibleCardFields: widget.visibleCardFields,
            density: widget.density,
            isSelected: widget.selectedTaskIds.contains(task.id),
            isPending: widget.pendingTaskIds.contains(task.id),
            memberProfilesByUserId: widget.memberProfilesByUserId,
          ),
        );
      },
    );
  }
}
