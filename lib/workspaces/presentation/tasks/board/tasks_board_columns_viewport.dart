import 'dart:async';
import 'dart:ui';

import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/viewport/kanban_auto_scroll_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Poziomy viewport tablicy z osobnym kontrolerem Scrollbara.
class KanbanColumnsViewport extends StatefulWidget {
  const KanbanColumnsViewport({
    required this.workspaceId,
    required this.projectId,
    required this.state,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final TasksBoardReady state;

  @override
  State<KanbanColumnsViewport> createState() => _KanbanColumnsViewportState();
}

class _KanbanColumnsViewportState extends State<KanbanColumnsViewport> {
  final ScrollController _controller = ScrollController();
  KanbanAutoScrollCoordinator? _coordinator;

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
          PreviousKanbanColumnIntent(),
      SingleActivator(LogicalKeyboardKey.arrowRight, alt: true):
          NextKanbanColumnIntent(),
    },
    child: Actions(
      actions: {
        PreviousKanbanColumnIntent: CallbackAction<PreviousKanbanColumnIntent>(
          onInvoke: (_) => _scrollBy(-_columnStep),
        ),
        NextKanbanColumnIntent: CallbackAction<NextKanbanColumnIntent>(
          onInvoke: (_) => _scrollBy(_columnStep),
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
            thickness: KanbanCardTokens.boardScrollbarThickness,
            // Dolne pasmo należy do paska: kolumny kończą się nad nim, więc
            // przeciąganie paska nie zasłania ich krawędzi.
            child: ListView.separated(
              controller: _controller,
              primary: false,
              padding: const .fromLTRB(
                KanbanCardTokens.boardGutter,
                KanbanCardTokens.boardGutter,
                KanbanCardTokens.boardGutter,
                KanbanCardTokens.boardScrollbarReserve,
              ),
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
                    child: KanbanColumnWidget(
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
                      memberProfilesByUserId:
                          widget.state.memberProfilesByUserId,
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

  /// Krok przewijania klawiszami: jedna kolumna w bieżącej gęstości plus odstęp.
  double get _columnStep =>
      KanbanCardTokens.columnWidthFor(widget.state.board.defaultCardDensity) +
      KanbanCardTokens.columnGap;

  void _scrollBy(double delta) {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    _controller.animateTo(
      (_controller.offset + delta).clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
    );
  }

  bool _isCollapsed(KanbanColumnResponse column) {
    final preference = widget.state.userPreference;
    if (preference == null) return false;
    return column.customStatusId == null
        ? preference.collapsedColumns.contains(column.status)
        : preference.collapsedCustomStatusIds.contains(column.customStatusId);
  }
}

class PreviousKanbanColumnIntent extends Intent {
  const PreviousKanbanColumnIntent();
}

class NextKanbanColumnIntent extends Intent {
  const NextKanbanColumnIntent();
}
