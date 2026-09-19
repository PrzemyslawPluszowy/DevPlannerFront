import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_duration_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Komórka czasu zadania (estymata lub czas rzeczywisty) w tabeli.
///
/// Prezentuje czas w formacie humanistycznym (np. 1h 30m) z ikoną zegara,
/// a w stanie pustym wyświetla dyskretną ikonę placeholderu z kursem i dymkiem.
class TaskCellDuration extends StatelessWidget {
  const TaskCellDuration({
    required this.minutes,
    required this.title,
    super.key,
    this.isEstimated = true,
    this.onChanged,
  });

  /// Czas w minutach.
  final int? minutes;

  /// Tytuł kolumny (np. "Estymata", "Czas rzeczywisty").
  final String title;

  /// Czy jest to estymata (ikona schedule), czy czas rzeczywisty (ikona timer).
  final bool isEstimated;

  /// Callback wywoływany po zmianie wartości.
  final Future<bool> Function(int? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final text = TaskDurationFormatter.format(minutes);
    final icon = isEstimated ? Symbols.schedule_rounded : Symbols.timer_rounded;

    return SizedBox(
      width: TaskListGrid.metric,
      child: Padding(
        padding: const .symmetric(horizontal: 8),
        child: Align(
          alignment: .centerLeft,
          child: Builder(
            builder: (cellContext) {
              if (text.isEmpty) {
                return TaskCellEmptyPlaceholder(
                  icon: icon,
                  tooltip: onChanged != null ? 'Ustaw $title' : null,
                  isInteractive: onChanged != null,
                  onTap: onChanged == null
                      ? null
                      : () => unawaited(
                          TaskDurationEditor.show(
                            cellContext,
                            currentMinutes: minutes,
                            title: title,
                            onSave: onChanged!,
                          ),
                        ),
                );
              }

              final content = Row(
                mainAxisSize: .min,
                children: [
                  Icon(
                    icon,
                    size: 14,
                    color: context.colors.onSurfaceVariant.withValues(
                      alpha: 0.8,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.labelMedium?.copyWith(
                        color: context.colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );

              return Tooltip(
                message: '$title: $text (${minutes!} min)',
                child: InkWell(
                  mouseCursor: onChanged != null
                      ? SystemMouseCursors.click
                      : SystemMouseCursors.basic,
                  borderRadius: .circular(4),
                  onTap: onChanged == null
                      ? null
                      : () => unawaited(
                          TaskDurationEditor.show(
                            cellContext,
                            currentMinutes: minutes,
                            title: title,
                            onSave: onChanged!,
                          ),
                        ),
                  child: Padding(
                    padding: const .symmetric(horizontal: 4, vertical: 2),
                    child: content,
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
