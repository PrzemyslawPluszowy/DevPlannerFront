import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/task_list_grid.dart';

/// Komórka obserwujących zadania w tabeli listy zadań.
///
/// Wyświetla liczbę obserwatorów, stan czy bieżący użytkownik obserwuje zadanie,
/// oraz umożliwia natychmiastowe przełączenie obserwowania jednym kliknięciem myszy.
class TaskCellWatchers extends StatelessWidget {
  const TaskCellWatchers({
    required this.task,
    super.key,
    this.onWatchingToggled,
  });

  /// Rekord zadania.
  final ProjectTaskListItemResponse task;

  /// Callback wywoływany po kliknięciu przełącznika obserwowania.
  final Future<bool> Function()? onWatchingToggled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isWatched = task.isWatchedByMe;
    final count = task.watcherCount;

    return SizedBox(
      width: TaskListGrid.metric,
      child: Padding(
        padding: const .symmetric(horizontal: 8),
        child: Align(
          alignment: .centerLeft,
          child: Builder(
            builder: (cellContext) {
              if (count <= 0 && !isWatched) {
                return InkWell(
                  mouseCursor: onWatchingToggled != null
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.basic,
                  borderRadius: .circular(4),
                  onTap: onWatchingToggled == null
                      ? null
                      : () => unawaited(onWatchingToggled!()),
                  child: TaskCellEmptyPlaceholder(
                    icon: Symbols.visibility,
                    tooltip: 'Kliknij, aby obserwować to zadanie',
                    isInteractive: onWatchingToggled != null,
                  ),
                );
              }

              final tooltipMessage = isWatched
                  ? 'Obserwujesz to zadanie ($count). Kliknij, aby przestać.'
                  : 'Liczba obserwujących: $count. Kliknij, aby obserwować.';

              return Tooltip(
                message: tooltipMessage,
                child: InkWell(
                  mouseCursor: onWatchingToggled != null
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.basic,
                  borderRadius: .circular(6),
                  onTap: onWatchingToggled == null
                      ? null
                      : () => unawaited(onWatchingToggled!()),
                  child: Container(
                    padding: const .symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: .circular(6),
                      color: isWatched
                          ? colors.primary.withValues(alpha: 0.1)
                          : colors.surfaceContainerHigh.withValues(alpha: 0.5),
                    ),
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        Icon(
                          Symbols.visibility_rounded,
                          size: 14,
                          color: isWatched
                              ? colors.primary
                              : colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$count',
                          style: context.text.labelSmall?.copyWith(
                            color: isWatched
                                ? colors.primary
                                : colors.onSurface,
                            fontWeight: isWatched
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
