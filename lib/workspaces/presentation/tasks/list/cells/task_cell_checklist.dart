import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_checklist_popover.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cubit/project_tasks_list_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Komórka postępu checklisty zadania w tabeli.
///
/// Wyświetla pasek postępu oraz licznik (np. 3/5).
/// Kliknięcie otwiera interaktywny popover do odznaczania punktów.
class TaskCellChecklist extends StatelessWidget {
  const TaskCellChecklist({
    required this.task,
    super.key,
  });

  /// Dane zadania z liczbą ukończonych i wszystkich punktów.
  final ProjectTaskListItemResponse task;

  @override
  Widget build(BuildContext context) {
    final total = task.checklistTotalCount;
    final completed = task.checklistCompletedCount;
    final ratio = total == 0 ? 0.0 : completed / total;

    final content = total == 0
        ? TaskCellEmptyPlaceholder(
            icon: Symbols.checklist_rounded,
            tooltip: 'Dodaj checklistę',
            onTap: () => unawaited(_openChecklistPopover(context)),
          )
        : InkWell(
            borderRadius: const BorderRadius.all(.circular(Sizes.p6)),
            hoverColor: context.colors.primary.withValues(alpha: 0.05),
            onTap: () => unawaited(_openChecklistPopover(context)),
            child: Container(
              padding: const .symmetric(
                horizontal: Sizes.p6,
                vertical: Sizes.p4,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(.circular(Sizes.p6)),
                border: Border.all(
                  color: context.colors.outlineVariant.withValues(alpha: 0.35),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: .min,
                children: [
                  Icon(
                    Symbols.checklist_rounded,
                    size: 14,
                    color: ratio == 1.0
                        ? const Color(0xFF10B981)
                        : context.colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          '$completed/$total',
                          style: context.text.labelSmall?.copyWith(
                            color: ratio == 1.0
                                ? const Color(0xFF10B981)
                                : context.colors.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: context.tasksTheme.metaText.fontSize,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            .circular(Sizes.p4),
                          ),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 3.5,
                            color: ratio == 1.0
                                ? const Color(0xFF10B981)
                                : context.colors.primary,
                            backgroundColor:
                                context.colors.surfaceContainerHighest,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

    return Builder(
      builder: (cellContext) => SizedBox(
        width: TaskListGrid.progress,
        child: Padding(
          padding: const .symmetric(horizontal: Sizes.p6, vertical: Sizes.p4),
          child: content,
        ),
      ),
    );
  }

  Future<void> _openChecklistPopover(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final pos = box != null
        ? box.localToGlobal(Offset(0, box.size.height + 2))
        : Offset.zero;

    final cubit = context.read<ProjectTasksListCubit>();

    await AppContextMenu.showCustom(
      context,
      globalPosition: pos,
      maxWidth: 340,
      contentBuilder: (_, dismiss) => TaskChecklistPopover(
        task: task,
        workspaceId: cubit.workspaceId,
        projectId: cubit.projectId,
        onCountsChanged: (completed, total, version) {
          cubit.updateChecklistCounts(
            taskId: task.id,
            completedCount: completed,
            totalCount: total,
            newVersion: version,
          );
        },
      ),
    );
  }
}
