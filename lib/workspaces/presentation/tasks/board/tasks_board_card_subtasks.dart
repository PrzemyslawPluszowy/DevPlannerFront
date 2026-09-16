part of 'tasks_board_page.dart';

/// Zwijany/rozwijany podgląd podzadań wewnątrz karty Kanbana.
///
/// Zgodnie ze specyfikacją naprawy UI (Etap C):
/// - Nowy, zwarty nagłówek sekcji z obracanym chevronem, licznikiem i cienkim paskiem postępu (48 px).
/// - Usunięto kropkowany separator i punktowe drzewko — zastąpiono je czystą, subtelną linią pionową 1 px.
/// - Stała oś wyrównania tekstu dla stanów pustego, ładowania, błędu, listy podzadań i formularza dodawania.
/// - Wiersz dziecka: status 16 px, tytuł z przekreśleniem dla ukończonych, opcjonalny termin i awatar 20 px.
/// - Pełny stan hover (tło 6 px radius) oraz focus ring (2 px primary) dla dostępności.
/// - Dedykowane klucze testowe dla nagłówka, każdego wiersza dziecka, stronicowania i dodawania.
class KanbanCardSubtasksSection extends StatefulWidget {
  const KanbanCardSubtasksSection({
    required this.task,
    required this.workspaceId,
    required this.projectId,
    required this.memberProfilesByCoreUserId,
    this.density = KanbanCardDensity.comfortable,
    super.key,
  });

  final KanbanTaskCardResponse task;
  final String workspaceId;
  final String projectId;
  final Map<String, ProjectMemberProfile> memberProfilesByCoreUserId;
  final KanbanCardDensity density;

  @override
  State<KanbanCardSubtasksSection> createState() =>
      _KanbanCardSubtasksSectionState();
}

class _KanbanCardSubtasksSectionState extends State<KanbanCardSubtasksSection>
    with SingleTickerProviderStateMixin {
  late final KanbanSubtasksCubit _cubit;
  late final AnimationController _chevronController;
  late final Animation<double> _chevronAnimation;

  var _isExpanded = false;
  var _isAddingSubtask = false;
  final TextEditingController _subtaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = KanbanSubtasksCubit(
      tasksRepository: context.read<TasksRepository>(),
      workspaceId: widget.workspaceId,
      projectId: widget.projectId,
      parentTaskId: widget.task.id,
      initialSubtaskTotal: widget.task.subtaskTotal,
      initialSubtaskCompleted: widget.task.subtaskCompleted,
    );

    _chevronController = AnimationController(
      vsync: this,
      duration: KanbanCardTokens.chevronDuration,
    );

    _chevronAnimation = Tween<double>(begin: 0.0, end: 0.25).animate(
      CurvedAnimation(
        parent: _chevronController,
        curve: KanbanCardTokens.expandCurve,
      ),
    );
  }

  @override
  void dispose() {
    _subtaskController.dispose();
    _chevronController.dispose();
    unawaited(_cubit.close());
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant KanbanCardSubtasksSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.task.id == widget.task.id) {
      _cubit.syncParentCounters(
        subtaskTotal: widget.task.subtaskTotal,
        subtaskCompleted: widget.task.subtaskCompleted,
      );
    }
  }

  void _toggleExpanded() {
    final nextState = !_isExpanded;
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    setState(() {
      _isExpanded = nextState;
      if (!nextState) {
        _isAddingSubtask = false;
        if (reducedMotion) {
          _chevronController.value = 0.0;
        } else {
          _chevronController.reverse();
        }
      } else {
        if (reducedMotion) {
          _chevronController.value = 1.0;
        } else {
          _chevronController.forward();
        }
      }
    });

    if (nextState) {
      unawaited(_cubit.loadInitial());
    }
  }

  Future<void> _submitNewSubtask() async {
    final title = _subtaskController.text.trim();
    if (title.isEmpty) return;

    final success = await _cubit.createSubtask(title);
    if (success && mounted) {
      _subtaskController.clear();
      setState(() => _isAddingSubtask = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCompact = widget.density == KanbanCardDensity.compact;
    final toggleMinHeight = isCompact
        ? KanbanCardTokens.toggleRowMinHeightCompact
        : KanbanCardTokens.toggleRowMinHeightComfortable;
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    return BlocProvider.value(
      value: _cubit,
      child: _OptionalTasksBoardListener(
        listenWhen: (previous, current) {
          final previousRevision = previous is TasksBoardReady
              ? previous.realtimeRevision
              : -1;
          final currentRevision = current is TasksBoardReady
              ? current.realtimeRevision
              : -1;
          return previousRevision != currentRevision;
        },
        listener: (_, boardState) {
          if (!_isExpanded || boardState is! TasksBoardReady) return;
          final mutation = boardState.latestRealtimeMutation;
          if (mutation == null || mutation.parentTaskId != widget.task.id) {
            return;
          }
          // The realtime snapshot is intentionally partial. A refreshed local
          // child list prevents an out-of-date expanded card without opening a
          // second SignalR connection for every Kanban card.
          unawaited(_cubit.refresh());
        },
        child: BlocBuilder<KanbanSubtasksCubit, KanbanSubtasksState>(
          builder: (context, state) {
            final total = state.subtaskTotal;
            final completed = state.subtaskCompleted;
            final progress = total > 0
                ? (completed / total).clamp(0.0, 1.0)
                : 0.0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nagłówek sekcji: jeden dostępny przycisk z obracanym chevronem, licznikiem i progress barem
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: toggleMinHeight),
                  child: Material(
                    color: Colors.transparent,
                    child: Semantics(
                      button: true,
                      expanded: _isExpanded,
                      label:
                          '${context.l10n.tasksSubtasksTitle} ($completed/$total)',
                      child: InkWell(
                        key: const ValueKey('subtasks_toggle_button'),
                        onTap: _toggleExpanded,
                        borderRadius: BorderRadius.circular(6),
                        hoverColor: colors.surfaceContainerHighest.withValues(
                          alpha: .5,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          child: Row(
                            children: [
                              RotationTransition(
                                turns: _chevronAnimation,
                                child: Icon(
                                  Symbols.keyboard_arrow_right_rounded,
                                  size: 16,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  context.l10n.tasksSubtasksTitle,
                                  style: KanbanCardTokens.subtasksHeader(
                                    context,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '($completed/$total)',
                                style: KanbanCardTokens.metaText(
                                  context,
                                  weight: .w500,
                                ),
                              ),
                              const Spacer(),
                              // Wyrazisty, zintegrowany pasek postępu (64 × 5 px)
                              Container(
                                width: 64,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: colors.outlineVariant.withValues(
                                    alpha: .25,
                                  ),
                                  borderRadius: .circular(2.5),
                                ),
                                child: ClipRRect(
                                  borderRadius: .circular(2.5),
                                  child: LinearProgressIndicator(
                                    value: progress,
                                    backgroundColor: Colors.transparent,
                                    color: (completed == total && total > 0)
                                        ? const Color(0xFF10B981)
                                        : colors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Rozwijana zawartość z animacją
                AnimatedSize(
                  duration: reducedMotion
                      ? Duration.zero
                      : KanbanCardTokens.expandDuration,
                  curve: KanbanCardTokens.expandCurve,
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.antiAlias,
                  child: _isExpanded
                      ? _buildExpandedContent(context, state)
                      : const SizedBox.shrink(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildExpandedContent(
    BuildContext context,
    KanbanSubtasksState state,
  ) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: colors.outlineVariant.withValues(
                alpha: isDark ? .35 : .22,
              ),
            ),
          ),
        ),
        padding: const EdgeInsets.only(left: 8),
        child: switch (state) {
          KanbanSubtasksLoading() => const _SubtasksSkeletonRows(),
          KanbanSubtasksError(:final message) => _buildErrorRow(
            context,
            message,
          ),
          KanbanSubtasksReady() => _buildSubtasksList(context, state),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }

  Widget _buildErrorRow(BuildContext context, String message) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Symbols.error_outline_rounded, size: 16, color: colors.error),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              context.l10n.tasksSubtasksError,
              style: KanbanCardTokens.metaText(
                context,
              ).copyWith(color: colors.error),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Semantics(
            label: context.l10n.retry,
            button: true,
            child: IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Symbols.refresh_rounded, size: 16),
              onPressed: () => _cubit.loadInitial(),
              constraints: const BoxConstraints.tightFor(
                width: KanbanCardTokens.minTouchTarget,
                height: KanbanCardTokens.minTouchTarget,
              ),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtasksList(BuildContext context, KanbanSubtasksReady state) {
    final colors = context.colors;
    final children = state.subtasks;
    final hasChildren = children.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!hasChildren && !_isAddingSubtask)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              context.l10n.tasksSubtasksEmpty,
              style: KanbanCardTokens.metaText(context),
            ),
          ),

        // Lista wierszy podzadań o czystej hierarchii
        for (final child in children) ...[
          () {
            final primaryAssigneeId =
                child.assignees
                    .where((a) => a.isPrimary)
                    .firstOrNull
                    ?.coreUserId ??
                child.assignees.firstOrNull?.coreUserId;
            final profile = primaryAssigneeId == null
                ? null
                : widget.memberProfilesByCoreUserId[primaryAssigneeId];

            return _SubtaskRow(
              key: ValueKey('subtask_row_${child.id}'),
              task: child,
              workspaceId: widget.workspaceId,
              projectId: widget.projectId,
              profile: profile,
              isSaving: state.pendingSubtaskIds.contains(child.id),
              onStatusChanged: (status, customStatusId) => _cubit.updateStatus(
                child.id,
                status,
                customStatusId: customStatusId,
              ),
            );
          }(),
        ],

        if (state.mutationError != null)
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 4),
            child: Text(
              state.mutationError!,
              style: KanbanCardTokens.metaText(
                context,
              ).copyWith(color: colors.error),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

        // Paginacja
        if (state.isLoadingMore)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox.square(
                  dimension: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  context.l10n.tasksSubtasksLoading,
                  style: KanbanCardTokens.metaText(context),
                ),
              ],
            ),
          )
        else if (state.loadMoreError != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    state.loadMoreError!,
                    style: KanbanCardTokens.metaText(
                      context,
                    ).copyWith(color: colors.error),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton(
                  onPressed: () => _cubit.loadMore(),
                  child: Text(context.l10n.retry),
                ),
              ],
            ),
          )
        else if (state.hasMore) ...[
          () {
            final remaining = state.subtaskTotal - children.length;
            final nextBatchCount = math.min(5, math.max(1, remaining));

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: const ValueKey('subtasks_show_more_button'),
                  onTap: () => _cubit.loadMore(),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 3,
                    ),
                    child: Text(
                      context.l10n.tasksSubtasksShowMoreRemaining(
                        nextBatchCount,
                      ),
                      style: KanbanCardTokens.metaText(
                        context,
                        weight: FontWeight.w500,
                      ).copyWith(color: colors.primary),
                    ),
                  ),
                ),
              ),
            );
          }(),
        ],

        // Formularz dodawania podzadania lub dyskretna akcja tekstowa
        if (_isAddingSubtask)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TaskInlineInputField(
                  key: const ValueKey('subtask_inline_input'),
                  controller: _subtaskController,
                  dense: true,
                  isSubmitting: state.isSubmittingSubtask,
                  hintText: context.l10n.tasksAddSubtask,
                  keyboardHint: 'Enter ↵',
                  onCancel: () {
                    if (!state.isSubmittingSubtask) {
                      setState(() => _isAddingSubtask = false);
                      _cubit.clearCreateError();
                    }
                  },
                  onSubmit: _submitNewSubtask,
                ),
                if (state.createError != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    state.createError!,
                    style: KanbanCardTokens.metaText(
                      context,
                    ).copyWith(color: colors.error),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                key: const ValueKey('subtasks_add_button'),
                onTap: () => setState(() => _isAddingSubtask = true),
                borderRadius: BorderRadius.circular(6),
                hoverColor: colors.surfaceContainerHighest.withValues(
                  alpha: .5,
                ),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 32),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: colors.outlineVariant.withValues(alpha: .4),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Symbols.add_rounded,
                        size: 14,
                        color: colors.primary,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          context.l10n.tasksAddSubtask,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: KanbanCardTokens.metaText(
                            context,
                            weight: FontWeight.w600,
                          ).copyWith(color: colors.primary),
                        ),
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
}

class _OptionalTasksBoardListener extends StatelessWidget {
  const _OptionalTasksBoardListener({
    required this.listenWhen,
    required this.listener,
    required this.child,
  });

  final BlocListenerCondition<TasksBoardState> listenWhen;
  final BlocWidgetListener<TasksBoardState> listener;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TasksBoardCubit?>();
    if (cubit == null) return child;
    return BlocListener<TasksBoardCubit, TasksBoardState>(
      bloc: cubit,
      listenWhen: listenWhen,
      listener: listener,
      child: child,
    );
  }
}

/// Trzy szkieletowe wiersze ładowania (28 px) o stałej osi tekstu.
class _SubtasksSkeletonRows extends StatelessWidget {
  const _SubtasksSkeletonRows();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final skeletonBg = colors.surfaceContainerHighest.withValues(alpha: .4);

    return Column(
      children: [
        for (final width in [130.0, 160.0, 100.0])
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: skeletonBg,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: width,
                  height: 10,
                  decoration: BoxDecoration(
                    color: skeletonBg,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Wiersz podzadania: status 16 px → tytuł 12.5–13/18 → termin → awatar 20 px.
///
/// Posiada pełne tło hover o radius 6 px oraz focus ring (2 px).
class _SubtaskRow extends StatefulWidget {
  const _SubtaskRow({
    required this.task,
    required this.workspaceId,
    required this.projectId,
    this.profile,
    required this.isSaving,
    required this.onStatusChanged,
    super.key,
  });

  final ProjectTaskListItemResponse task;
  final String workspaceId;
  final String projectId;
  final ProjectMemberProfile? profile;
  final bool isSaving;
  final Future<bool> Function(ProjectTaskStatus, String?) onStatusChanged;

  @override
  State<_SubtaskRow> createState() => _SubtaskRowState();
}

class _SubtaskRowState extends State<_SubtaskRow> {
  var _isFocused = false;

  void _showStatusPicker([Offset? globalPosition]) {
    if (widget.isSaving) return;
    final boardState = context.read<TasksBoardCubit>().state;
    if (boardState is! TasksBoardReady || boardState.board.columns.isEmpty) {
      return;
    }
    final position = globalPosition == null
        ? TaskContextMenu.positionFor(context)
        : _positionForGlobal(globalPosition);
    unawaited(_showColumnPicker(boardState.board.columns, position));
  }

  RelativeRect _positionForGlobal(Offset globalPosition) {
    final overlay = Navigator.of(context, rootNavigator: true).overlay;
    final overlayBox = overlay?.context.findRenderObject() as RenderBox?;
    if (overlayBox == null) return RelativeRect.fill;
    return RelativeRect.fromRect(
      globalPosition & const Size(1, 1),
      Offset.zero & overlayBox.size,
    );
  }

  Future<void> _showColumnPicker(
    List<KanbanColumnResponse> columns,
    RelativeRect position,
  ) async {
    final selected = await TaskContextMenu.show<KanbanColumnResponse>(
      context,
      position: position,
      items: [
        for (final column in columns)
          TaskContextMenuItem<KanbanColumnResponse>(
            value: column,
            title: column.displayName,
            icon: TaskStatusVisualHelper.icon(column.status),
            iconColor: TaskStatusVisualHelper.color(column.status),
            isSelected: column.customStatusId != null
                ? column.customStatusId == widget.task.customStatusId
                : widget.task.customStatusId == null &&
                      column.status == widget.task.status,
          ),
      ],
    );
    if (!mounted || selected == null) return;
    await widget.onStatusChanged(selected.status, selected.customStatusId);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDone = widget.task.status == ProjectTaskStatus.done;

    final rowContent = Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.f10, shift: true):
            _ShowSubtaskContextMenuIntent(),
        SingleActivator(LogicalKeyboardKey.contextMenu):
            _ShowSubtaskContextMenuIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          _ShowSubtaskContextMenuIntent:
              CallbackAction<_ShowSubtaskContextMenuIntent>(
                onInvoke: (_) {
                  _showStatusPicker();
                  return null;
                },
              ),
        },
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final router = context.read<AppRouter?>();
              if (router != null) {
                unawaited(
                  router.navigatePath(
                    '/workspaces/${widget.workspaceId}/projects/${widget.projectId}/tasks/${widget.task.id}',
                  ),
                );
              }
            },
            onFocusChange: (focused) => setState(() => _isFocused = focused),
            onSecondaryTapUp: widget.isSaving
                ? null
                : (details) => _showStatusPicker(details.globalPosition),
            borderRadius: BorderRadius.circular(6),
            hoverColor: colors.surfaceContainerHighest.withValues(alpha: .5),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
              child: Row(
                children: [
                  // 1. Ikona statusu / checkbox (16 px)
                  Icon(
                    TaskStatusVisualHelper.icon(widget.task.status),
                    size: 16,
                    color: TaskStatusVisualHelper.color(widget.task.status),
                  ),
                  const SizedBox(width: 6),

                  if (widget.isSaving)
                    const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 1.5),
                    )
                  else
                    Semantics(
                      label: context.l10n.tasksContextMenuStatus,
                      button: true,
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints.tightFor(
                          width: 24,
                          height: 24,
                        ),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Symbols.more_horiz_rounded, size: 16),
                        onPressed: _showStatusPicker,
                      ),
                    ),

                  // 2. Tytuł podzadania
                  Expanded(
                    child: Text(
                      widget.task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: KanbanCardTokens.subtaskTitle(
                        context,
                        isDone: isDone,
                      ),
                    ),
                  ),

                  // 3. Opcjonalny termin podzadania (jeśli występuje)
                  if (widget.task.dueAtUtc case final dueAt?) ...[
                    const SizedBox(width: 6),
                    Text(
                      _formatSubtaskDueDate(dueAt),
                      style: KanbanCardTokens.metaText(
                        context,
                        weight: FontWeight.w500,
                      ).copyWith(fontSize: 11),
                    ),
                  ],

                  // 4. Awatar wykonawcy (20 px) z inicjałem 10 px
                  if (widget.profile case final profile?) ...[
                    const SizedBox(width: 6),
                    _ChildAssigneeAvatar(
                      profile: profile,
                      coreUserId:
                          widget.task.assignees.firstOrNull?.coreUserId ?? '',
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (_isFocused) {
      return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: colors.primary, width: 2.0),
        ),
        child: rowContent,
      );
    }

    return rowContent;
  }

  String _formatSubtaskDueDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
  }
}

class _ShowSubtaskContextMenuIntent extends Intent {
  const _ShowSubtaskContextMenuIntent();
}

/// Dedykowany awatar dziecka o średnicy 20 px (radius 10 px) z inicjałem 10 px.
class _ChildAssigneeAvatar extends StatelessWidget {
  const _ChildAssigneeAvatar({
    required this.profile,
    required this.coreUserId,
  });

  final ProjectMemberProfile profile;
  final String coreUserId;

  @override
  Widget build(BuildContext context) {
    final displayName = profile.displayName?.trim();
    final label = displayName?.isNotEmpty == true
        ? displayName!
        : context.l10n.tasksPresenceAnonymousUser;
    final avatarUrl = profile.avatarUrl?.trim();

    return Semantics(
      label: label,
      child: CircleAvatar(
        radius: KanbanCardTokens.childAvatarRadius,
        foregroundImage: avatarUrl?.isNotEmpty == true
            ? NetworkImage(avatarUrl!)
            : null,
        backgroundColor: _cardAvatarColor(coreUserId),
        child: avatarUrl?.isNotEmpty == true
            ? null
            : Text(
                label.characters.first.toUpperCase(),
                style: KanbanCardTokens.childAvatarInitials(
                  context,
                ).copyWith(color: Colors.white),
              ),
      ),
    );
  }
}
