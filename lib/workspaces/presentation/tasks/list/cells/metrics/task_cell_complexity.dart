import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/pickers/task_complexity_picker.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/task_list_grid.dart';

/// Komórka złożoności zadania w tabeli listy zadań.
///
/// Wyświetla zwięzły wskaźnik segmentowy (np. 3/5 kresek) oraz dymek informacyjny,
/// a po kliknięciu otwiera zakotwiczony picker.
class TaskCellComplexity extends StatelessWidget {
  const TaskCellComplexity({
    required this.complexity,
    super.key,
    this.onChanged,
  });

  /// Wartość złożoności (1..5).
  final int? complexity;

  /// Callback wywoływany po zmianie złożoności.
  final Future<bool> Function(int? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final val = complexity?.clamp(1, 5);

    return SizedBox(
      width: TaskListGrid.metric,
      child: Padding(
        padding: const .symmetric(horizontal: 8),
        child: Align(
          alignment: .centerLeft,
          child: Builder(
            builder: (cellContext) {
              if (val == null) {
                return TaskCellEmptyPlaceholder(
                  icon: Symbols.tune_rounded,
                  tooltip: onChanged != null ? 'Ustaw złożoność' : null,
                  isInteractive: onChanged != null,
                  onTap: onChanged == null
                      ? null
                      : () => unawaited(
                          showTaskComplexityPicker(
                            cellContext,
                            currentComplexity: complexity,
                            onSave: onChanged!,
                          ),
                        ),
                );
              }

              return Tooltip(
                message: 'Złożoność: $val/5',
                child: InkWell(
                  mouseCursor: onChanged != null
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.basic,
                  borderRadius: .circular(6),
                  onTap: onChanged == null
                      ? null
                      : () => unawaited(
                          showTaskComplexityPicker(
                            cellContext,
                            currentComplexity: complexity,
                            onSave: onChanged!,
                          ),
                        ),
                  child: Container(
                    padding: const .symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: .circular(6),
                      color: colors.surfaceContainerHigh.withValues(alpha: 0.6),
                    ),
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        for (var i = 1; i <= 5; i++)
                          Container(
                            width: 3.5,
                            height: 10,
                            margin: const .only(right: 2),
                            decoration: BoxDecoration(
                              borderRadius: .circular(1),
                              color: i <= val
                                  ? colors.primary
                                  : colors.outlineVariant.withValues(
                                      alpha: 0.35,
                                    ),
                            ),
                          ),
                        const SizedBox(width: 3),
                        Text(
                          '$val',
                          style: context.text.labelSmall?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.5,
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
