import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/pickers/task_size_picker.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/table/task_list_grid.dart';

/// Komórka rozmiaru zadania w tabeli listy zadań.
///
/// Wyświetla zwięzły tag rozmiaru koszulkowego (XS, S, M, L, XL)
/// lub dyskretną ikonę pustego stanu, z zakotwiczonym szybkim pickerem.
class TaskCellSize extends StatelessWidget {
  const TaskCellSize({
    required this.size,
    super.key,
    this.onChanged,
  });

  /// Wartość rozmiaru (1..5 dla XS..XL lub int).
  final int? size;

  /// Callback wywoływany po zmianie rozmiaru.
  final Future<bool> Function(int? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final tShirt = TaskTShirtSize.fromValue(size);
    final label = tShirt?.label ?? size?.toString();

    return SizedBox(
      width: TaskListGrid.metric,
      child: Padding(
        padding: const .symmetric(horizontal: 8),
        child: Align(
          alignment: .centerLeft,
          child: Builder(
            builder: (cellContext) {
              if (label == null || label.isEmpty) {
                return TaskCellEmptyPlaceholder(
                  icon: Symbols.straighten_rounded,
                  tooltip: onChanged != null ? 'Ustaw rozmiar' : null,
                  isInteractive: onChanged != null,
                  onTap: onChanged == null
                      ? null
                      : () => unawaited(
                          showTaskSizePicker(
                            cellContext,
                            currentSize: size,
                            onSave: onChanged!,
                          ),
                        ),
                );
              }

              return InkWell(
                mouseCursor: onChanged != null
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                borderRadius: .circular(6),
                onTap: onChanged == null
                    ? null
                    : () => unawaited(
                        showTaskSizePicker(
                          cellContext,
                          currentSize: size,
                          onSave: onChanged!,
                        ),
                      ),
                child: Container(
                  padding: const .symmetric(horizontal: 7, vertical: 2.5),
                  decoration: BoxDecoration(
                    borderRadius: .circular(6),
                    color: context.colors.surfaceContainerHigh,
                    border: Border.all(
                      color: context.colors.outlineVariant.withValues(
                        alpha: 0.6,
                      ),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    label,
                    style: context.text.labelSmall?.copyWith(
                      color: context.colors.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
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
