import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_assignee_commands.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/kanban_assignee_column.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/viewport/kanban_auto_scroll_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Treść tablicy w trybie grupowania po osobach.
class KanbanAssigneeBoardContent extends StatelessWidget {
  const KanbanAssigneeBoardContent({
    required this.workspaceId,
    required this.projectId,
    required this.state,
    required this.coordinator,
    required this.cardBuilder,
    required this.quickCreateBuilder,
    required this.emptyStateBuilder,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final TasksBoardReady state;
  final KanbanAutoScrollCoordinator coordinator;
  final KanbanAssigneeCardBuilder cardBuilder;
  final KanbanAssigneeQuickCreateBuilder quickCreateBuilder;
  final WidgetBuilder emptyStateBuilder;

  @override
  Widget build(BuildContext context) {
    final board = state.assigneeBoard;
    if (board == null) {
      return state.isAssigneeBoardLoading
          ? const Center(child: CircularProgressIndicator())
          : emptyStateBuilder(context);
    }
    if (board.groups.isEmpty) return emptyStateBuilder(context);
    return KanbanAutoScrollScope(
      coordinator: coordinator,
      child: KanbanAssigneeColumnsViewport(
        workspaceId: workspaceId,
        projectId: projectId,
        state: state,
        board: board,
        cardBuilder: cardBuilder,
        quickCreateBuilder: quickCreateBuilder,
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
    required this.cardBuilder,
    required this.quickCreateBuilder,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final TasksBoardReady state;
  final AssigneeKanbanBoardResponse board;
  final KanbanAssigneeCardBuilder cardBuilder;
  final KanbanAssigneeQuickCreateBuilder quickCreateBuilder;

  @override
  State<KanbanAssigneeColumnsViewport> createState() =>
      _KanbanAssigneeColumnsViewportState();
}

/// Pamięta widoczne kolumny i kontroler ich poziomego przewijania.
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
          cardBuilder: widget.cardBuilder,
          quickCreateBuilder: widget.quickCreateBuilder,
        ),
      ),
    );
  }
}

/// Stan, w którym filtr widoczności nie zostawił żadnej kolumny.
///
/// Pusty ekran nie może udawać, że projekt nie ma zadań, więc dostaje komunikat
/// i jedną akcję przywracającą wszystkie kolumny.
/// Informuje o pustym wyborze i przywraca wszystkie kolumny.
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
