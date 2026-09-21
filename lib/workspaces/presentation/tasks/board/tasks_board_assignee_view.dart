part of 'tasks_board_page.dart';

/// Etykieta i kolor statusu pokazywane jako badge karty.
typedef KanbanCardStatusBadge = ({String label, Color color});

/// Badge statusu używany wyłącznie w widoku grupowanym po osobach.
///
/// W widoku statusów status opisuje kolumna, więc powtarzanie go na karcie
/// byłoby szumem; w widoku osób kolumna opisuje osobę i status musi wrócić na
/// kartę, bo inaczej znika cała informacja o etapie pracy.
class _CardStatusBadge extends StatelessWidget {
  const _CardStatusBadge({required this.badge});

  final KanbanCardStatusBadge badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: badge.color.withValues(alpha: .14),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: badge.color.withValues(alpha: .38)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            badge.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: KanbanCardTokens.metaText(context).copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Pasek wyboru grupowania tablicy: status workflow albo osoba przypisana.
///
/// Wyglądem odpowiada przełącznikowi z listy zadań (smukły pill 28 px,
/// powierzchnia `surfaceContainerHigh`, subtelna ramka), żeby tablica nie
/// odstawała od reszty modułu i nie zajmowała pół ekranu.
class KanbanBoardGroupingBar extends StatelessWidget {
  const KanbanBoardGroupingBar({required this.state, super.key});

  final TasksBoardReady state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final options = <(TasksBoardGrouping, String, IconData)>[
      (
        TasksBoardGrouping.status,
        l10n.tasksBoardGroupByStatus,
        Symbols.grid_view_rounded,
      ),
      (
        TasksBoardGrouping.assignee,
        l10n.tasksKanbanSwimlaneAssignee,
        Symbols.person_rounded,
      ),
    ];

    // Kontrolka wiersza poleceń: bez paddingu, bez własnego scrolla i **bez
    // elementów rozciągliwych**. Wiersz poleceń to poziomy scroll, więc szerokość
    // jest nieograniczona i każdy `Spacer`/`Expanded` skończyłby się błędem
    // layoutu („non-zero flex but incoming width constraints are unbounded”).
    return Container(
      height: 28,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh.withValues(alpha: .7),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: .35),
          width: .8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.isAssigneeBoardLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          for (final (value, label, icon) in options)
            _GroupingSegment(
              label: label,
              icon: icon,
              isSelected: state.grouping == value,
              // Cubit czytamy w momencie kliknięcia, nie w buildzie: nagłówek
              // montuje się także w testach i podglądach bez dostawcy cubita.
              onTap: () => unawaited(
                context.read<TasksBoardCubit>().setGrouping(value),
              ),
            ),
        ],
      ),
    );
  }
}

/// Pojedynczy segment przełącznika: kolor zaznaczenia bierze z motywu, więc
/// wybór jest widoczny od pierwszego rzutu oka.
class _GroupingSegment extends StatefulWidget {
  const _GroupingSegment({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_GroupingSegment> createState() => _GroupingSegmentState();
}

class _GroupingSegmentState extends State<_GroupingSegment> {
  final _state = ValueNotifier<({bool hovered, bool focused})>((
    hovered: false,
    focused: false,
  ));

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<
        ({
          bool hovered,
          bool focused,
        })
      >(
        valueListenable: _state,
        builder: (context, interaction, _) {
          final colors = context.colors;
          final selected = widget.isSelected;
          final background = selected
              ? colors.primaryContainer
              : interaction.hovered
              ? colors.surfaceContainerHighest
              : Colors.transparent;
          final foreground = selected
              ? colors.onPrimaryContainer
              : colors.onSurfaceVariant;
          return Semantics(
            button: true,
            selected: selected,
            label: widget.label,
            child: FocusableActionDetector(
              mouseCursor: SystemMouseCursors.click,
              onShowHoverHighlight: (hovered) => _state.value = (
                hovered: hovered,
                focused: _state.value.focused,
              ),
              onShowFocusHighlight: (focused) => _state.value = (
                hovered: _state.value.hovered,
                focused: focused,
              ),
              actions: {
                ActivateIntent: CallbackAction<ActivateIntent>(
                  onInvoke: (_) {
                    widget.onTap();
                    return null;
                  },
                ),
              },
              child: GestureDetector(
                onTap: widget.onTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(5),
                    border: interaction.focused
                        ? Border.all(color: colors.primary, width: 1.4)
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.icon, size: 14, color: foreground),
                      const SizedBox(width: 5),
                      Text(
                        widget.label,
                        style:
                            KanbanCardTokens.metaText(
                              context,
                            ).copyWith(
                              color: foreground,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
}

/// Treść tablicy w trybie grupowania po osobach.
class KanbanAssigneeBoardContent extends StatelessWidget {
  const KanbanAssigneeBoardContent({
    required this.workspaceId,
    required this.projectId,
    required this.state,
    required this.coordinator,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final TasksBoardReady state;
  final KanbanAutoScrollCoordinator coordinator;

  @override
  Widget build(BuildContext context) {
    final board = state.assigneeBoard;
    if (board == null) {
      return state.isAssigneeBoardLoading
          ? const Center(child: CircularProgressIndicator())
          : const _BoardEmpty();
    }
    if (board.groups.isEmpty) return const _BoardEmpty();
    return KanbanAutoScrollScope(
      coordinator: coordinator,
      child: KanbanAssigneeColumnsViewport(
        workspaceId: workspaceId,
        projectId: projectId,
        state: state,
        board: board,
      ),
    );
  }
}

/// Poziomy viewport kolumn osób z zachowanym porządkiem grup z Backendu.
class KanbanAssigneeColumnsViewport extends StatefulWidget {
  const KanbanAssigneeColumnsViewport({
    required this.workspaceId,
    required this.projectId,
    required this.state,
    required this.board,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final TasksBoardReady state;
  final AssigneeKanbanBoardResponse board;

  @override
  State<KanbanAssigneeColumnsViewport> createState() =>
      _KanbanAssigneeColumnsViewportState();
}

class _KanbanAssigneeColumnsViewportState
    extends State<KanbanAssigneeColumnsViewport> {
  // Poziomy pasek przewijania wymaga własnego kontrolera: ListView poziomy nie
  // używa PrimaryScrollController, więc bez niego `thumbVisibility` nie ma się
  // do czego przyczepić.
  final ScrollController _controller = ScrollController();
  KanbanAutoScrollCoordinator? _coordinator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ten sam koordynator co w widoku statusów: przeciąganie karty do krawędzi
    // przewija planszę, więc zachowanie obu trybów jest identyczne.
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
  Widget build(BuildContext context) {
    // Widoczność kolumn jest filtrem lokalnym: grupy przychodzą z Backendu
    // wszystkie, a użytkownik decyduje, które z nich ma przed oczami.
    final groups = widget.board.groups
        .where((group) {
          final key = TasksBoardAssigneeCommands.keyOf(group);
          if (widget.state.hiddenAssigneeUserIds.contains(key)) return false;
          if (widget.state.hideEmptyAssigneeColumns &&
              group.totalTaskCount == 0) {
            return false;
          }
          return true;
        })
        .toList(growable: false);
    if (groups.isEmpty) {
      return _AssigneeColumnsHidden(
        allHidden:
            widget.state.hiddenAssigneeUserIds.length >=
            widget.board.groups.length,
      );
    }
    return Scrollbar(
      // Pasek na dole tablicy: przy wielu osobach pozwala przewinąć planszę
      // bez łapania kółka myszy nad kolumną.
      controller: _controller,
      thumbVisibility: true,
      trackVisibility: true,
      interactive: true,
      thickness: KanbanCardTokens.boardScrollbarThickness,
      radius: const Radius.circular(6),
      child: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        // Pasmo na dole należy do paska przewijania, tak samo jak w widoku
        // statusów: pełnowysokie kolumny nie mogą wchodzić pod jego uchwyt.
        padding: const EdgeInsets.fromLTRB(
          KanbanCardTokens.boardGutter,
          4,
          KanbanCardTokens.boardGutter,
          KanbanCardTokens.boardScrollbarReserve,
        ),
        itemCount: groups.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: KanbanCardTokens.columnGap),
        itemBuilder: (context, index) => KanbanAssigneeColumn(
          key: ValueKey(
            'assignee-column-${TasksBoardAssigneeCommands.keyOf(groups[index])}',
          ),
          workspaceId: widget.workspaceId,
          projectId: widget.projectId,
          state: widget.state,
          group: groups[index],
        ),
      ),
    );
  }
}

/// Stan, w którym filtr widoczności nie zostawił żadnej kolumny.
///
/// Pusty ekran nie może udawać, że projekt nie ma zadań, więc dostaje komunikat
/// i jedną akcję przywracającą wszystkie kolumny.
class _AssigneeColumnsHidden extends StatelessWidget {
  const _AssigneeColumnsHidden({required this.allHidden});

  final bool allHidden;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Symbols.view_column_rounded,
              size: 28,
              color: context.colors.onSurfaceVariant,
            ),
            const SizedBox(height: 8),
            Text(
              allHidden
                  ? l10n.tasksBoardAssigneeColumnsAllHidden
                  : l10n.tasksBoardAssigneeColumnsHideEmpty,
              textAlign: TextAlign.center,
              style: KanbanCardTokens.metaText(context),
            ),
            const SizedBox(height: 8),
            TextButton(
              key: const ValueKey('assignee_column_show_all'),
              onPressed: () => unawaited(
                context.read<TasksBoardCubit>().showAllAssigneeColumns(),
              ),
              child: Text(l10n.tasksBoardAssigneeColumnsShowAll),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kolumna jednej osoby albo grupy „Nieprzypisane”.
class KanbanAssigneeColumn extends StatefulWidget {
  const KanbanAssigneeColumn({
    required this.workspaceId,
    required this.projectId,
    required this.state,
    required this.group,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final TasksBoardReady state;
  final AssigneeKanbanGroupResponse group;

  @override
  State<KanbanAssigneeColumn> createState() => _KanbanAssigneeColumnState();
}

class _KanbanAssigneeColumnState extends State<KanbanAssigneeColumn> {
  final ScrollController _controller = ScrollController();
  final ValueNotifier<bool> _hovered = ValueNotifier<bool>(false);
  KanbanAutoScrollCoordinator? _coordinator;
  Key? _registeredKey;

  String get workspaceId => widget.workspaceId;
  String get projectId => widget.projectId;
  TasksBoardReady get state => widget.state;
  AssigneeKanbanGroupResponse get group => widget.group;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
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

  /// Doładowanie strony grupy przy dojechaniu do końca listy — tak samo jak
  /// w kolumnach statusów, żeby użytkownik nie musiał szukać przycisku.
  void _onScroll() {
    if (!_controller.hasClients) return;
    if (_controller.position.extentAfter >= 300) return;
    final group = widget.group;
    if (group.nextCursor == null) return;
    final key = TasksBoardAssigneeCommands.keyOf(group);
    if (widget.state.loadingAssigneeGroupKeys.contains(key)) return;
    unawaited(context.read<TasksBoardCubit>().loadMoreAssigneeGroup(group));
  }

  @override
  void dispose() {
    _hovered.dispose();
    if (_registeredKey != null) _coordinator?.unregisterColumn(_registeredKey!);
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  /// Nowe zadanie z kolumny osoby powstaje w Backlogu (pierwsza kolumna
  /// workflow jako zapas), bo widok osób nie ma własnego statusu.
  static KanbanColumnResponse _backlogColumn(TasksBoardReady state) =>
      state.board.columns.firstWhere(
        (column) => column.status == ProjectTaskStatus.backlog,
        orElse: () => state.board.columns.first,
      );

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final group = widget.group;
    final colors = context.colors;
    final groupKey = TasksBoardAssigneeCommands.keyOf(group);
    final isLoadingMore = state.loadingAssigneeGroupKeys.contains(groupKey);
    final loadError = state.assigneeGroupLoadErrors[groupKey];
    final cubit = context.read<TasksBoardCubit>();
    // Obserwator nie może zaczynać przeciągania ani przyjmować upuszczenia:
    // backend i tak odrzuci mutację, ale interakcja nie może udawać dostępnej.
    // Brak profilu bieżącego użytkownika nie odbiera prawa zapisu.
    // Provider rejestruje sesję pod typem nie-nullable, więc odczyt nullable
    // zwracałby null także wtedy, gdy sesja jest dostępna (np. w testach
    // widgetowych bez trasy). Brak sesji oznacza brak informacji o roli.
    AuthSessionPort? session;
    try {
      session = context.read<AuthSessionPort>();
    } on Object {
      session = null;
    }
    final currentUserId = session?.snapshot.user?.userId;
    final role = currentUserId == null
        ? null
        : state.memberProfilesByUserId[currentUserId]?.role;
    final canWrite = role != ProjectRole.observer;

    // Kolor kolumny bierze się z tożsamości osoby (hash) albo ze statusu,
    // a gradient jest tylko delikatnym tłem — nie konkuruje z kartami.
    final assigneeId = group.assigneeUserId;
    final accent = assigneeId != null
        ? TaskBoardAvatarPalette.colorFor(assigneeId)
        : colors.onSurfaceVariant;
    return DragTarget<KanbanTaskCardResponse>(
      onWillAcceptWithDetails: (details) =>
          canWrite && _groupKeyOfCard(state, details.data) != groupKey,
      onAcceptWithDetails: (details) =>
          unawaited(_acceptDrop(context, cubit, details.data)),
      builder: (context, candidates, _) => KanbanColumnSurface(
        accent: accent,
        density:
            state.assigneeBoard?.defaultCardDensity ??
            state.board.defaultCardDensity,
        highlighted: candidates.isNotEmpty,
        // Wiersz dodawania tylko w kolumnie „Nieprzypisane”: nowe zadanie
        // powstaje w Backlogu bez wykonawcy, więc pojawia się dokładnie tam.
        footer: assigneeId == null
            ? _QuickCreateTask(column: _backlogColumn(state))
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: KanbanCardTokens.columnHeaderHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _header(context),
              ),
            ),
            if (group.tasks.isEmpty)
              Expanded(
                child: _EmptyAssigneeDropZone(
                  displayName: group.displayName,
                  highlighted: candidates.isNotEmpty,
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  key: PageStorageKey<String>(
                    'assignee-column-list-$groupKey',
                  ),
                  padding: const EdgeInsets.fromLTRB(9, 0, 9, 9),
                  itemCount:
                      group.tasks.length + (group.nextCursor != null ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= group.tasks.length) {
                      return _LoadMoreAssigneeTile(
                        isLoading: isLoadingMore,
                        onPressed: () => unawaited(
                          context.read<TasksBoardCubit>().loadMoreAssigneeGroup(
                            group,
                          ),
                        ),
                      );
                    }
                    final task = group.tasks[index];
                    final card = KanbanTaskCard(
                      task: task,
                      workspaceId: workspaceId,
                      projectId: projectId,
                      visibleCardFields: state.board.visibleCardFields,
                      density: state.board.defaultCardDensity,
                      isSelected: state.selectedTaskIds.contains(task.id),
                      isPending: state.pendingTaskIds.contains(task.id),
                      hasError: state.failedTaskIds.contains(task.id),
                      memberProfilesByUserId: state.memberProfilesByUserId,
                      statusBadge: _statusBadgeFor(state, task),
                    );
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: KanbanCardTokens.cardGap,
                      ),
                      child: canWrite
                          ? _DraggableTaskCard(
                              key: ValueKey('assignee-card-${task.id}'),
                              task: task,
                              workspaceId: workspaceId,
                              projectId: projectId,
                              visibleCardFields: state.board.visibleCardFields,
                              density: state.board.defaultCardDensity,
                              isSelected: state.selectedTaskIds.contains(
                                task.id,
                              ),
                              isPending: state.pendingTaskIds.contains(
                                task.id,
                              ),
                              hasError: state.failedTaskIds.contains(task.id),
                              memberProfilesByUserId:
                                  state.memberProfilesByUserId,
                              statusBadge: _statusBadgeFor(state, task),
                            )
                          : card,
                    );
                  },
                ),
              ),
            if (loadError != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: Text(
                  loadError,
                  style: KanbanCardTokens.metaText(
                    context,
                  ).copyWith(color: colors.error),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        _AssigneeAvatar(
          displayName: group.displayName,
          avatarUrl: group.avatarUrl,
          isUnassigned: group.assigneeUserId == null,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Tooltip(
            message: group.displayName,
            child: Text(
              group.displayName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: KanbanCardTokens.columnTitle(context),
            ),
          ),
        ),
        if (group.isCurrentUser) ...[
          const SizedBox(width: 4),
          _CurrentUserBadge(label: l10n.tasksBoardCurrentUserBadge),
        ],
        const SizedBox(width: 6),
        _AssigneeCountBadge(count: group.totalTaskCount),
      ],
    );
  }

  /// Reguła D2 dla grupy „Nieprzypisane”: usunięcie wszystkich wykonawców
  /// wymaga jawnego potwierdzenia, bo tego nie da się cofnąć jednym gestem.
  Future<void> _acceptDrop(
    BuildContext context,
    TasksBoardCubit cubit,
    KanbanTaskCardResponse task,
  ) async {
    if (group.assigneeUserId != null) {
      await cubit.moveTaskToAssignee(
        task: task,
        targetUserId: group.assigneeUserId,
      );
      return;
    }
    final l10n = context.l10n;
    final confirmed = await AppConfirmDialog.show(
      context,
      title: l10n.tasksBoardUnassignedDropTitle,
      message: l10n.tasksBoardUnassignedDropBody,
      // Krótka etykieta akcji: pytanie z tytułu jest za długie na przycisk
      // i przepełniało dialog w wąskim oknie.
      confirmLabel: l10n.tasksBoardUnassignedDropConfirm,
      cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
    );
    if (!confirmed) return;
    await cubit.moveTaskToAssignee(task: task, targetUserId: null);
  }
}

/// Stan pustej kolumny osoby: cała kolumna pozostaje strefą upuszczenia.
class _EmptyAssigneeDropZone extends StatelessWidget {
  const _EmptyAssigneeDropZone({
    required this.displayName,
    required this.highlighted,
  });

  final String displayName;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      label: context.l10n.tasksDropAtEnd(displayName),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        margin: const EdgeInsets.fromLTRB(9, 0, 9, 9),
        decoration: BoxDecoration(
          color: highlighted
              ? colors.primary.withValues(alpha: .08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: highlighted
                ? colors.primary.withValues(alpha: .45)
                : colors.outlineVariant.withValues(alpha: .4),
          ),
        ),
      ),
    );
  }
}

class _LoadMoreAssigneeTile extends StatelessWidget {
  const _LoadMoreAssigneeTile({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: KanbanCardTokens.cardGap),
    child: TextButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(context.l10n.tasksBoardLoadMore),
    ),
  );
}

/// Avatar osoby z fallbackiem inicjałów; brak awatara nie może psuć nagłówka.
class _AssigneeAvatar extends StatelessWidget {
  const _AssigneeAvatar({
    required this.displayName,
    required this.avatarUrl,
    required this.isUnassigned,
  });

  static const double _size = 28;

  final String displayName;
  final String? avatarUrl;
  final bool isUnassigned;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final initials = _initials(displayName);
    final fallback = DecoratedBox(
      decoration: BoxDecoration(
        color: isUnassigned
            ? colors.surfaceContainerHighest
            : colors.primary.withValues(alpha: .16),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: isUnassigned
            ? Icon(
                Symbols.person_rounded,
                size: _size * .6,
                color: colors.onSurfaceVariant,
              )
            : Text(
                initials,
                style: KanbanCardTokens.childAvatarInitials(
                  context,
                ).copyWith(color: colors.onSurface),
              ),
      ),
    );
    final url = avatarUrl;
    return SizedBox(
      width: _size,
      height: _size,
      child: ClipOval(
        child: url == null
            ? fallback
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => fallback,
              ),
      ),
    );
  }

  static String _initials(String displayName) {
    final parts = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .toList(growable: false);
    if (parts.isEmpty) return '?';
    return parts.map((part) => part.characters.first.toUpperCase()).join();
  }
}

class _CurrentUserBadge extends StatelessWidget {
  const _CurrentUserBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        child: Text(
          label,
          style:
              KanbanCardTokens.metaText(
                context,
              ).copyWith(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class _AssigneeCountBadge extends StatelessWidget {
  const _AssigneeCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
        child: Text(
          '$count',
          style: KanbanCardTokens.metaText(context).copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Klucz grupy, w której aktualnie leży karta; brak karty oznacza brak grupy.
String? _groupKeyOfCard(TasksBoardReady state, KanbanTaskCardResponse task) {
  final groups = state.assigneeBoard?.groups ?? const [];
  for (final group in groups) {
    if (group.tasks.any((item) => item.id == task.id)) {
      return TasksBoardAssigneeCommands.keyOf(group);
    }
  }
  return null;
}

/// Status karty opisany przez kolumnę statusu o tym samym statusie lub własnym
/// statusie projektu; brak kolumny oznacza brak badge'a.
KanbanCardStatusBadge? _statusBadgeFor(
  TasksBoardReady state,
  KanbanTaskCardResponse task,
) {
  final columns = state.board.columns;
  final customStatusId = task.customStatusId;
  final column = customStatusId != null
      ? columns
            .where((item) => item.customStatusId == customStatusId)
            .firstOrNull
      : columns
            .where(
              (item) =>
                  item.customStatusId == null && item.status == task.status,
            )
            .firstOrNull;
  if (column == null) return null;
  return (
    label: column.displayName,
    color: TaskBoardColorParser.parse(column.color),
  );
}

/// Sentinel wyboru grupy „Nieprzypisane”; `null` z dialogu oznacza anulowanie.
const String _unassignedPick = '__unassigned__';

/// Wybór nowej osoby dla karty z menu kontekstowego.
///
/// To alternatywa klawiaturowa dla przeciągania: menu karty jest osiągalne
/// z klawiatury, a ten dialog prowadzi przez wybór osoby bez użycia myszy.
/// Zwraca `null` przy anulowaniu; grupa „Nieprzypisane” wymaga potwierdzenia,
/// bo usuwa wszystkich wykonawców zadania (reguła D2).
Future<({String? targetUserId})?> showKanbanMoveToPersonDialog(
  BuildContext context, {
  required TasksBoardReady state,
  required String taskId,
}) async {
  final board = state.assigneeBoard;
  if (board == null) return null;
  final l10n = context.l10n;
  final currentGroupKey = board.groups
      .where((group) => group.tasks.any((item) => item.id == taskId))
      .map(TasksBoardAssigneeCommands.keyOf)
      .firstOrNull;
  final options = board.groups
      .where(
        (group) => TasksBoardAssigneeCommands.keyOf(group) != currentGroupKey,
      )
      .toList(growable: false);
  if (options.isEmpty) return null;

  const unassignedPick = _unassignedPick;
  final picked = await DevPlannerModalHost.showDialog<String>(
    context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.tasksBoardMoveToPerson),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      content: SizedBox(
        width: 340,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            final group = options[index];
            final isUnassigned = group.assigneeUserId == null;
            return ListTile(
              leading: _AssigneeAvatar(
                displayName: group.displayName,
                avatarUrl: group.avatarUrl,
                isUnassigned: isUnassigned,
              ),
              title: Text(
                isUnassigned
                    ? l10n.tasksKanbanQuickFilterUnassigned
                    : group.displayName,
              ),
              subtitle: group.isCurrentUser
                  ? Text(l10n.tasksBoardCurrentUserBadge)
                  : null,
              onTap: () =>
                  // Wybór grupy Nieprzypisane musi różnić się od anulowania,
                  // inaczej potwierdzenie D2 nigdy by się nie pokazało.
                  Navigator.of(
                    dialogContext,
                  ).pop(group.assigneeUserId ?? _unassignedPick),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
        ),
      ],
    ),
  );
  if (picked == null || picked == '__cancel__') return null;
  if (picked != unassignedPick) return (targetUserId: picked);

  // Potwierdzenie po pierwszym await: kontekst mógł zostać zdjęty z drzewa.
  if (!context.mounted) return null;
  final confirmed = await AppConfirmDialog.show(
    context,
    title: l10n.tasksBoardUnassignedDropTitle,
    message: l10n.tasksBoardUnassignedDropBody,
    confirmLabel: l10n.tasksBoardUnassignedDropConfirm,
    cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
  );
  return confirmed ? (targetUserId: null) : null;
}
