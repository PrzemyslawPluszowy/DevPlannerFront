import 'dart:async';

import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_assignee_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/kanban_assignee_visuals.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/kanban_column_surface.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/viewport/kanban_auto_scroll_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Buduje kartę zadania z danymi i uprawnieniem do przeciągania.
typedef KanbanAssigneeCardBuilder = Widget Function(
  KanbanTaskCardResponse task,
  KanbanCardStatusBadge? statusBadge,
  bool canDrag,
);

/// Buduje kontrolkę tworzenia zadania dla wskazanej kolumny.
typedef KanbanAssigneeQuickCreateBuilder = Widget Function(
  KanbanColumnResponse backlogColumn,
);

/// Kolumna jednej osoby albo grupy „Nieprzypisane”.
class KanbanAssigneeColumn extends StatefulWidget {
  const KanbanAssigneeColumn({
    required this.workspaceId,
    required this.projectId,
    required this.state,
    required this.group,
    required this.cardBuilder,
    required this.quickCreateBuilder,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final TasksBoardReady state;
  final AssigneeKanbanGroupResponse group;
  final KanbanAssigneeCardBuilder cardBuilder;
  final KanbanAssigneeQuickCreateBuilder quickCreateBuilder;

  @override
  State<KanbanAssigneeColumn> createState() => _KanbanAssigneeColumnState();
}

/// Obsługuje stronicowanie i przeciąganie zadań w kolumnie.
class _KanbanAssigneeColumnState extends State<KanbanAssigneeColumn> {
  final ScrollController _controller = ScrollController();
  KanbanAutoScrollCoordinator? _coordinator;
  Key? _registeredKey;

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
            ? widget.quickCreateBuilder(_backlogColumn(state))
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: KanbanCardTokens.columnHeaderHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: KanbanAssigneeColumnHeader(group: group),
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
                    final statusBadge = KanbanAssigneeStatusBadge.resolve(
                      state,
                      task,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: KanbanCardTokens.cardGap,
                      ),
                      child: widget.cardBuilder(task, statusBadge, canWrite),
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

  String? _groupKeyOfCard(TasksBoardReady state, KanbanTaskCardResponse task) {
    final groups = state.assigneeBoard?.groups ?? const [];
    for (final group in groups) {
      if (group.tasks.any((item) => item.id == task.id)) {
        return TasksBoardAssigneeCommands.keyOf(group);
      }
    }
    return null;
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
/// Pokazuje pustą kolumnę jako dostępną strefę upuszczania.
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

/// Udostępnia ładowanie kolejnej strony zadań grupy.
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
