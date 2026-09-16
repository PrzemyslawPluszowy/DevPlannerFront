import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/pickers/task_risk_picker.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/task_list_grid.dart';

/// Komórka ryzyka zadania w tabeli listy zadań.
///
/// Wyświetla elegancki, kolorowy badge poziomu ryzyka (Niskie, Średnie, Wysokie, Krytyczne)
/// lub dyskretną ikonę pustego stanu, a po kliknięciu otwiera zakotwiczony picker.
class TaskCellRisk extends StatelessWidget {
  const TaskCellRisk({
    required this.risk,
    super.key,
    this.onChanged,
  });

  /// Wartość ryzyka (1..4) lub null.
  final int? risk;

  /// Callback wywoływany po zmianie ryzyka.
  final Future<bool> Function(int? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final level = TaskRiskLevel.fromValue(risk);

    return SizedBox(
      width: TaskListGrid.metric,
      child: Padding(
        padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p6),
        child: Builder(
          builder: (cellContext) {
            if (level == null) {
              return TaskCellEmptyPlaceholder(
                icon: Symbols.shield,
                tooltip: onChanged != null ? 'Ustaw ryzyko' : null,
                isInteractive: onChanged != null,
                onTap: onChanged == null
                    ? null
                    : () => unawaited(
                        showTaskRiskPicker(
                          cellContext,
                          currentRisk: risk,
                          onSave: onChanged!,
                        ),
                      ),
              );
            }

            return InkWell(
              mouseCursor: onChanged != null
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
              onTap: onChanged == null
                  ? null
                  : () => unawaited(
                      showTaskRiskPicker(
                        cellContext,
                        currentRisk: risk,
                        onSave: onChanged!,
                      ),
                    ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
                  color: level.color.withValues(alpha: 0.14),
                  border: Border.all(
                    color: level.color.withValues(alpha: 0.4),
                    width: 0.8,
                  ),
                ),
                child: Padding(
                  padding: const .symmetric(horizontal: Sizes.p6),
                  child: Center(
                    child: Row(
                      mainAxisSize: .min,
                      mainAxisAlignment: .center,
                      children: [
                        Icon(
                          Symbols.shield_rounded,
                          size: 14,
                          color: level.color,
                        ),
                        const SizedBox(width: Sizes.p4),
                        Flexible(
                          child: Text(
                            level.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.text.labelSmall?.copyWith(
                              color: level.color,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
