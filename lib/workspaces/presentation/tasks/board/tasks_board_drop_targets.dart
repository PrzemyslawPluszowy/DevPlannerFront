import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Upuszczenie pod kartą wstawia przeciągane zadanie pod jej pozycją.
class TaskAfterCardDropTarget extends StatelessWidget {
  const TaskAfterCardDropTarget({
    required this.column,
    required this.targetIndex,
    required this.child,
    super.key,
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
                bottom: BorderSide(color: context.colors.primary, width: 3),
              ),
      ),
      child: child,
    ),
  );
}

/// Strefa dropu przed kartą albo na końcu kolumny.
class TaskDropZone extends StatelessWidget {
  const TaskDropZone({
    required this.column,
    required this.targetIndex,
    this.expand = false,
    this.child,
    super.key,
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
    onAcceptWithDetails: (details) => unawaited(
      context.read<TasksBoardCubit>().moveTask(
        task: details.data,
        targetColumn: column,
        targetIndex: targetIndex,
      ),
    ),
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
            child: child,
          ),
        );
      }
      return AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        height: highlighted ? 40 : KanbanCardTokens.cardGap - 2,
        margin: const .symmetric(vertical: 1),
        decoration: BoxDecoration(
          color: highlighted
              ? context.colors.primary.withValues(alpha: .18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: highlighted
              ? Border.all(color: context.colors.primary.withValues(alpha: .5))
              : null,
        ),
      );
    },
  );
}
