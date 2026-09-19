import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/helpers/task_status_visual_helper.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_status_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Komórka statusu systemowego zadania w tabeli.
///
/// Wyświetla estetyczną pigułkę ze statusem i umożliwia szybką zmianę
/// jednym kliknięciem poprzez zunifikowane menu kontekstowe.
class TaskCellStatus extends StatelessWidget {
  const TaskCellStatus({
    required this.status,
    super.key,
    this.onChanged,
    this.canManage = false,
    this.onConfigureWorkflow,
  });

  /// Aktualny status zadania.
  final ProjectTaskStatus status;

  /// Callback wywoływany przy zmianie statusu przez użytkownika.
  final Future<bool> Function(ProjectTaskStatus status)? onChanged;

  /// Czy użytkownik posiada uprawnienia zarządcze w projekcie.
  final bool canManage;

  /// Opcjonalny callback konfiguracji workflow projektu.
  final VoidCallback? onConfigureWorkflow;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (cellContext) => SizedBox(
      width: TaskListGrid.status,
      child: Padding(
        padding: const .symmetric(vertical: Sizes.p6, horizontal: Sizes.p8),
        child: InkWell(
          borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
          onTap: onChanged == null
              ? null
              : () => unawaited(
                  TaskStatusPicker.show(
                    cellContext,
                    selected: status,
                    onChanged: onChanged!,
                    canManage: canManage,
                    onConfigureWorkflow: onConfigureWorkflow,
                  ),
                ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: TaskStatusVisualHelper.color(status),
              borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
            ),
            child: Center(
              child: Text(
                TaskStatusVisualHelper.label(context, status),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Komórka własnego statusu zadania (workflow projektu).
class TaskCellCustomStatus extends StatelessWidget {
  const TaskCellCustomStatus({
    required this.task,
    super.key,
    this.onChanged,
    this.canManage = false,
    this.onConfigureWorkflow,
  });

  /// Dane zadania z informacją o customStatusId i customStatusName.
  final ProjectTaskListItemResponse task;

  /// Callback wywoływany przy zmianie własnego statusu.
  final Future<bool> Function(String? customStatusId)? onChanged;

  /// Czy użytkownik posiada uprawnienia zarządcze w projekcie.
  final bool canManage;

  /// Opcjonalny callback konfiguracji workflow projektu.
  final VoidCallback? onConfigureWorkflow;

  @override
  Widget build(BuildContext context) => Builder(
    builder: (cellContext) => SizedBox(
      width: TaskListGrid.status,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p8,
          vertical: Sizes.p6,
        ),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
          onTap: onChanged == null
              ? null
              : () => unawaited(_showCustomStatusMenu(cellContext)),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: task.customStatusName != null
                  ? context.colors.primary.withValues(alpha: .14)
                  : context.colors.surfaceContainerHighest.withValues(
                      alpha: .3,
                    ),
              borderRadius: const BorderRadius.all(Radius.circular(Sizes.p4)),
              border: Border.all(
                color: task.customStatusName != null
                    ? context.colors.primary.withValues(alpha: .4)
                    : context.colors.outlineVariant.withValues(alpha: .3),
                width: 0.8,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p6),
              child: Center(
                child: Text(
                  task.customStatusName ?? '—',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: task.customStatusName != null
                        ? context.colors.primary
                        : context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _showCustomStatusMenu(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final pos = box != null
        ? box.localToGlobal(Offset(0, box.size.height + 2))
        : Offset.zero;

    await AppContextMenu.show(
      context,
      globalPosition: pos,
      headerTitle: context.l10n.tasksListCustomStatusLabel,
      actions: [
        AppContextMenuAction(
          label: context.l10n.tasksListCustomStatusNone,
          icon: Symbols.remove_circle_outline_rounded,
          selected: task.customStatusId == null,
          onTap: (_) => onChanged?.call(null),
        ),
        if (canManage && onConfigureWorkflow != null)
          AppContextMenuAction(
            label: 'Zarządzaj workflow projektu...',
            icon: Symbols.settings_rounded,
            onTap: (_) => onConfigureWorkflow!(),
          ),
      ],
    );
  }
}
