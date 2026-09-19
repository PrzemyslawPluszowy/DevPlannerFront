import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_milestone_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Komórka kamienia milowego zadania w tabeli.
///
/// Wyświetla nazwę przypisanego kamienia milowego lub placeholder "—".
/// Kliknięcie otwiera zunifikowane menu wyboru kamienia milowego.
class TaskCellMilestone extends StatelessWidget {
  const TaskCellMilestone({
    required this.task,
    required this.milestones,
    super.key,
    this.onChanged,
  });

  /// Dane zadania zawierające `milestoneId`.
  final ProjectTaskListItemResponse task;

  /// Słownik dostępnych kamieni milowych w projekcie.
  final Map<String, MilestoneResponse> milestones;

  /// Callback wywoływany przy zmianie lub usunięciu kamienia milowego.
  final Future<bool> Function(String? milestoneId)? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = context.text;
    final milestone = task.milestoneId == null
        ? null
        : milestones[task.milestoneId];

    return Builder(
      builder: (cellContext) => InkWell(
        mouseCursor: onChanged != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onTap: onChanged == null
            ? null
            : () => unawaited(
                TaskMilestonePicker.show(
                  cellContext,
                  milestones: milestones.values.toList(growable: false),
                  selectedMilestoneId: task.milestoneId,
                  onSelected: (id) async => onChanged!(id),
                ),
              ),
        child: SizedBox(
          width: TaskListGrid.milestone,
          child: Padding(
            padding: const .symmetric(horizontal: Sizes.p8, vertical: Sizes.p6),
            child: milestone == null
                ? TaskCellEmptyPlaceholder(
                    icon: Symbols.flag_rounded,
                    tooltip: onChanged != null ? 'Ustaw kamień milowy' : null,
                    isInteractive: onChanged != null,
                  )
                : DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.14),
                      borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.4),
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
                              Symbols.flag_rounded,
                              size: 14,
                              color: colors.primary,
                            ),
                            const SizedBox(width: Sizes.p4),
                            Flexible(
                              child: Text(
                                milestone.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: text.labelSmall?.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
