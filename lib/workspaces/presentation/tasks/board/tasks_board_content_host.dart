import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/kanban_assignee_board_content.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/kanban_assignee_column.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_columns_viewport.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/viewport/kanban_auto_scroll_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Zarządza trwałym koordynatorem przewijania planszy.
class TasksBoardContentHost extends StatefulWidget {
  const TasksBoardContentHost({
    required this.workspaceId,
    required this.projectId,
    required this.state,
    required this.emptyStateBuilder,
    required this.cardBuilder,
    required this.quickCreateBuilder,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final TasksBoardReady state;
  final WidgetBuilder emptyStateBuilder;
  final KanbanAssigneeCardBuilder cardBuilder;
  final KanbanAssigneeQuickCreateBuilder quickCreateBuilder;

  @override
  State<TasksBoardContentHost> createState() => _TasksBoardContentHostState();
}

/// Zwalnia koordynator przewijania razem z widokiem tablicy.
class _TasksBoardContentHostState extends State<TasksBoardContentHost> {
  final KanbanAutoScrollCoordinator _coordinator =
      KanbanAutoScrollCoordinator();

  @override
  void dispose() {
    _coordinator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: widget.state.grouping == TasksBoardGrouping.assignee
            ? KanbanAssigneeBoardContent(
                workspaceId: widget.workspaceId,
                projectId: widget.projectId,
                state: widget.state,
                coordinator: _coordinator,
                cardBuilder: widget.cardBuilder,
                quickCreateBuilder: widget.quickCreateBuilder,
                emptyStateBuilder: widget.emptyStateBuilder,
              )
            : widget.state.board.columns.isEmpty
            ? widget.emptyStateBuilder(context)
            : KanbanAutoScrollScope(
                coordinator: _coordinator,
                child: KanbanColumnsViewport(
                  workspaceId: widget.workspaceId,
                  projectId: widget.projectId,
                  state: widget.state,
                ),
              ),
      ),
    ],
  );
}

/// Ogranicza skróty zaznaczania zadań do aktywnego Kanbana.
class TasksBoardKeyboardShortcuts extends StatelessWidget {
  const TasksBoardKeyboardShortcuts({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Shortcuts(
    shortcuts: const {
      SingleActivator(LogicalKeyboardKey.keyA, control: true):
          _SelectAllLoadedTasksIntent(),
      SingleActivator(LogicalKeyboardKey.keyA, meta: true):
          _SelectAllLoadedTasksIntent(),
      SingleActivator(LogicalKeyboardKey.escape): _ClearTaskSelectionIntent(),
    },
    child: Actions(
      actions: {
        _SelectAllLoadedTasksIntent:
            CallbackAction<_SelectAllLoadedTasksIntent>(
              onInvoke: (_) {
                context.read<TasksBoardCubit>().selectAllLoadedTasks();
                return null;
              },
            ),
        _ClearTaskSelectionIntent: CallbackAction<_ClearTaskSelectionIntent>(
          onInvoke: (_) {
            context.read<TasksBoardCubit>().clearTaskSelection();
            return null;
          },
        ),
      },
      child: Focus(autofocus: true, child: child),
    ),
  );
}

/// Intencja skrótu wybierającego wszystkie załadowane zadania.
class _SelectAllLoadedTasksIntent extends Intent {
  const _SelectAllLoadedTasksIntent();
}

/// Intencja skrótu czyszczącego zaznaczenie zadań.
class _ClearTaskSelectionIntent extends Intent {
  const _ClearTaskSelectionIntent();
}
