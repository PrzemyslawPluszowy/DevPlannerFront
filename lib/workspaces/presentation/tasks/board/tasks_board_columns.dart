part of 'tasks_board_page.dart';

/// Poziomy viewport tablicy z kontrolerem przypisanym wyłącznie do Scrollbara.
class _KanbanColumns extends StatefulWidget {
  const _KanbanColumns({
    required this.workspaceId,
    required this.projectId,
    required this.state,
  });

  final String workspaceId;
  final String projectId;
  final TasksBoardReady state;

  @override
  State<_KanbanColumns> createState() => _KanbanColumnsState();
}

class _KanbanColumnsState extends State<_KanbanColumns> {
  final ScrollController _controller = ScrollController();
  KanbanAutoScrollCoordinator? _coordinator;

  static const _keyboardColumnStep = 318.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final coordinator = KanbanAutoScrollScope.maybeOf(context);
    if (!identical(_coordinator, coordinator)) {
      _coordinator?.unregisterBoardController(_controller);
      _coordinator = coordinator;
      _coordinator?.registerBoardController(_controller);
    }
  }

  @override
  void dispose() {
    _coordinator?.unregisterBoardController(_controller);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: const {
      SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true):
          _PreviousKanbanColumnIntent(),
      SingleActivator(LogicalKeyboardKey.arrowRight, alt: true):
          _NextKanbanColumnIntent(),
    },
    child: Actions(
      actions: {
        _PreviousKanbanColumnIntent:
            CallbackAction<_PreviousKanbanColumnIntent>(
              onInvoke: (_) => _scrollBy(-_keyboardColumnStep),
            ),
        _NextKanbanColumnIntent: CallbackAction<_NextKanbanColumnIntent>(
          onInvoke: (_) => _scrollBy(_keyboardColumnStep),
        ),
      },
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: const {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.stylus,
              PointerDeviceKind.trackpad,
            },
          ),
          child: Scrollbar(
            controller: _controller,
            thumbVisibility: true,
            trackVisibility: true,
            interactive: true,
            child: ListView.separated(
              controller: _controller,
              primary: false,
              padding: const .all(KanbanCardTokens.boardGutter),
              scrollDirection: Axis.horizontal,
              itemCount: widget.state.board.columns.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: KanbanCardTokens.columnGap),
              itemBuilder: (context, index) {
                final column = widget.state.board.columns[index];
                return FocusTraversalOrder(
                  order: NumericFocusOrder(index.toDouble()),
                  child: FocusTraversalGroup(
                    policy: WidgetOrderTraversalPolicy(),
                    child: _KanbanColumn(
                      key: ValueKey(
                        column.customStatusId ?? column.status.name,
                      ),
                      workspaceId: widget.workspaceId,
                      projectId: widget.projectId,
                      column: column,
                      visibleCardFields: widget.state.board.visibleCardFields,
                      density: widget.state.board.defaultCardDensity,
                      selectedTaskIds: widget.state.selectedTaskIds,
                      pendingTaskIds: widget.state.pendingTaskIds,
                      memberProfilesByCoreUserId:
                          widget.state.memberProfilesByCoreUserId,
                      isCollapsed: _isCollapsed(column),
                      onToggleCollapsed: () => unawaited(
                        context.read<TasksBoardCubit>().toggleColumnCollapsed(
                          column,
                        ),
                      ),
                      isLoadingMore: widget.state.loadingColumnKeys.contains(
                        column.customStatusId ?? column.status.name,
                      ),
                      loadError:
                          widget.state.columnLoadErrors[column.customStatusId ??
                              column.status.name],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ),
  );

  void _scrollBy(double delta) {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    final target = (_controller.offset + delta).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    _controller.animateTo(
      target,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
    );
  }

  bool _isCollapsed(KanbanColumnResponse column) {
    final preference = widget.state.userPreference;
    if (preference == null) return false;
    final customStatusId = column.customStatusId;
    return customStatusId == null
        ? preference.collapsedColumns.contains(column.status)
        : preference.collapsedCustomStatusIds.contains(customStatusId);
  }
}

class _PreviousKanbanColumnIntent extends Intent {
  const _PreviousKanbanColumnIntent();
}

class _NextKanbanColumnIntent extends Intent {
  const _NextKanbanColumnIntent();
}

class KanbanColumnWidget extends StatefulWidget {
  const KanbanColumnWidget({
    required this.workspaceId,
    required this.projectId,
    required this.column,
    required this.visibleCardFields,
    required this.density,
    required this.selectedTaskIds,
    required this.pendingTaskIds,
    required this.memberProfilesByCoreUserId,
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
  final Map<String, ProjectMemberProfile> memberProfilesByCoreUserId;
  final bool isCollapsed;
  final VoidCallback onToggleCollapsed;
  final bool isLoadingMore;
  final String? loadError;

  @override
  State<KanbanColumnWidget> createState() => _KanbanColumnWidgetState();
}

typedef _KanbanColumn = KanbanColumnWidget;

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
    final accent = _parseColor(widget.column.color);
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
      return _TaskDropZone(
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
          return _TaskDropZone(
            column: widget.column,
            targetIndex: index ~/ 2,
            expand: isEndDropZone,
            child: isEndDropZone ? const SizedBox(height: 64) : null,
          );
        }
        final task = tasks[index ~/ 2];
        return _TaskAfterCardDropTarget(
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
            memberProfilesByCoreUserId: widget.memberProfilesByCoreUserId,
          ),
        );
      },
    );
  }
}

/// Upuszczenie na kartę oznacza wstawienie przeciąganego zadania bezpośrednio
/// pod nią. Pozwala to zachować małe odstępy między kartami bez utraty wygody
/// przeciągania.
class _TaskAfterCardDropTarget extends StatelessWidget {
  const _TaskAfterCardDropTarget({
    required this.column,
    required this.targetIndex,
    required this.child,
  });

  final KanbanColumnResponse column;
  final int targetIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) => DragTarget<KanbanTaskCardResponse>(
    onWillAcceptWithDetails: (details) => context
        .read<TasksBoardCubit>()
        .canMoveTaskTo(task: details.data, targetColumn: column),
    onAcceptWithDetails: (details) => unawaited(
      context.read<TasksBoardCubit>().moveTask(
        task: details.data,
        targetColumn: column,
        targetIndex: targetIndex,
      ),
    ),
    builder: (context, candidates, _) => DecoratedBox(
      decoration: BoxDecoration(
        border: candidates.isEmpty
            ? null
            : Border(
                bottom: BorderSide(
                  color: context.colors.primary,
                  width: 3,
                ),
              ),
      ),
      child: child,
    ),
  );
}

class _TaskDropZone extends StatelessWidget {
  const _TaskDropZone({
    required this.column,
    required this.targetIndex,
    this.expand = false,
    this.child,
  });

  final KanbanColumnResponse column;
  final int targetIndex;
  final bool expand;
  final Widget? child;

  @override
  Widget build(BuildContext context) => DragTarget<KanbanTaskCardResponse>(
    onWillAcceptWithDetails: (details) => context
        .read<TasksBoardCubit>()
        .canMoveTaskTo(task: details.data, targetColumn: column),
    onAcceptWithDetails: (details) {
      debugPrint(
        '[Kanban] Drop ${details.data.id} → '
        '${column.customStatusId ?? column.status.name} @ $targetIndex',
      );
      unawaited(
        context.read<TasksBoardCubit>().moveTask(
          task: details.data,
          targetColumn: column,
          targetIndex: targetIndex,
        ),
      );
    },
    builder: (context, candidates, _) {
      final highlighted = candidates.isNotEmpty;
      if (expand) {
        return Container(
          margin: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: highlighted
                ? context.colors.primary.withValues(alpha: .08)
                : null,
            borderRadius: BorderRadius.circular(10),
            border: highlighted
                ? Border.all(
                    color: context.colors.primary.withValues(alpha: .45),
                  )
                : null,
          ),
          child: Semantics(
            label: context.l10n.tasksDropAtEnd(column.displayName),
            // To ma być niewidoczny, duży obszar końcowego dropu. Zostawiamy
            // opis semantyczny dla czytników ekranu, ale nie dokładamy napisu
            // do interfejsu ani podczas przeciągania.
            child: child,
          ),
        );
      }
      return AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        // Zwykły rytm kart pozostaje zwarty. Strefa rozwija się dopiero po
        // wejściu z przeciąganą kartą, a wygodny drop na końcu zapewnia duży
        // dedykowany obszar na dole kolumny.
        height: highlighted ? 40 : KanbanCardTokens.cardGap - 2,
        margin: const .symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: highlighted
              ? context.colors.primary.withValues(alpha: .18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: highlighted
              ? Border.all(
                  color: context.colors.primary.withValues(alpha: .5),
                )
              : null,
        ),
      );
    },
  );
}
