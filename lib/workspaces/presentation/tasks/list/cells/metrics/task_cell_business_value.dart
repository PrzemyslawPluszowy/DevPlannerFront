import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Komórka wartości biznesowej zadania w tabeli.
class TaskCellBusinessValue extends StatelessWidget {
  const TaskCellBusinessValue({
    required this.value,
    super.key,
    this.onChanged,
  });

  /// Wartość biznesowa zadania.
  final int? value;

  /// Callback wywoływany po zmianie wartości.
  final Future<bool> Function(int? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: TaskListGrid.metric,
      child: Padding(
        padding: const .symmetric(horizontal: 8),
        child: Align(
          alignment: .centerLeft,
          child: Builder(
            builder: (cellContext) {
              if (value == null) {
                return TaskCellEmptyPlaceholder(
                  icon: Symbols.stars_rounded,
                  tooltip: onChanged != null ? 'Ustaw wartość biznesową' : null,
                  isInteractive: onChanged != null,
                  onTap: onChanged == null
                      ? null
                      : () => unawaited(
                          TaskBusinessValuePicker.show(
                            cellContext,
                            currentValue: value,
                            onSave: onChanged!,
                          ),
                        ),
                );
              }

              return Tooltip(
                message: 'Wartość biznesowa: $value',
                child: InkWell(
                  mouseCursor: onChanged != null
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.basic,
                  borderRadius: .circular(6),
                  onTap: onChanged == null
                      ? null
                      : () => unawaited(
                          TaskBusinessValuePicker.show(
                            cellContext,
                            currentValue: value,
                            onSave: onChanged!,
                          ),
                        ),
                  child: Container(
                    padding: const .symmetric(horizontal: 7, vertical: 2.5),
                    decoration: BoxDecoration(
                      borderRadius: .circular(6),
                      color: colors.primary.withValues(alpha: 0.08),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.3),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: .min,
                      children: [
                        Icon(
                          Symbols.stars_rounded,
                          size: 13,
                          color: colors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$value',
                          style: context.text.labelSmall?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w700,
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

/// Lokalny launcher wartości biznesowej używany przez listę i formularze.
final class TaskBusinessValuePicker {
  const TaskBusinessValuePicker._();

  static Future<void> show(
    BuildContext context, {
    required int? currentValue,
    required Future<bool> Function(int? value) onSave,
    Offset? position,
  }) async {
    final menuPosition = position ?? AppContextMenu.positionFor(context);
    const presets = [10, 20, 50, 80, 100];

    final selected = await AppContextMenu.select<int?>(
      context,
      globalPosition: menuPosition,
      options: [
        for (final val in presets)
          AppContextMenuOption(
            sectionTitle: 'Wartość biznesowa',

            value: val,
            label: '$val pkt',
            icon: Symbols.trending_up_rounded,
            iconColor: context.colors.primary,
            selected: currentValue == val,
          ),
        if (currentValue != null) ...[
          AppContextMenuOption(
            separatorBefore: true,

            value: 0,
            label: 'Wyczyść wartość',
            icon: Symbols.close_rounded,
            iconColor: context.colors.error,
          ),
        ],
      ],
    );

    if (selected == null) return;
    if (selected == 0) {
      await onSave(null);
    } else {
      await onSave(selected);
    }
  }
}
