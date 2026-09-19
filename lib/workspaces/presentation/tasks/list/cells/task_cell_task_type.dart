import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/empty/task_cell_empty_placeholder.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_type_picker.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grid.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Komórka typu zadania w tabeli listy zadań.
///
/// Wyświetla kolorowy badge typu zadania z ikoną lub dyskretną ikonę pustego stanu.
class TaskCellTaskType extends StatelessWidget {
  const TaskCellTaskType({
    required this.taskType,
    this.onChanged,
    this.canManage = false,
    this.onConfigureTypes,
    super.key,
  });

  /// Wartość typu zadania.
  final String? taskType;

  /// Callback wywoływany po zmianie typu zadania.
  final Future<bool> Function(String value)? onChanged;

  /// Czy użytkownik posiada uprawnienia zarządcze w projekcie (SuperAdmin, Admin, Owner).
  final bool canManage;

  /// Opcjonalny callback konfiguracji typów zadań.
  final VoidCallback? onConfigureTypes;

  @override
  Widget build(BuildContext context) {
    final text = taskType?.trim() ?? '';
    final preset = TaskPresetType.fromName(text);
    final displayLabel = preset?.label ?? text;

    return SizedBox(
      width: TaskListGrid.taskType,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Sizes.p6,
          horizontal: Sizes.p8,
        ),
        child: Builder(
          builder: (cellContext) {
            if (text.isEmpty) {
              return TaskCellEmptyPlaceholder(
                icon: Symbols.category_rounded,
                tooltip: onChanged != null ? 'Ustaw typ zadania' : null,
                isInteractive: onChanged != null,
                onTap: onChanged == null
                    ? null
                    : () => unawaited(
                        TaskTypePicker.show(
                          cellContext,
                          currentType: taskType,
                          onSave: onChanged!,
                          canManage: canManage,
                          onConfigureTypes: onConfigureTypes,
                        ),
                      ),
              );
            }

            final icon = preset?.icon ?? Symbols.label_important_rounded;
            final typeColor = preset?.color ?? context.colors.primary;

            return Tooltip(
              message: displayLabel,
              child: InkWell(
                mouseCursor: onChanged != null
                    ? SystemMouseCursors.click
                    : SystemMouseCursors.basic,
                borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
                onTap: onChanged == null
                    ? null
                    : () => unawaited(
                        TaskTypePicker.show(
                          cellContext,
                          currentType: taskType,
                          onSave: onChanged!,
                          canManage: canManage,
                          onConfigureTypes: onConfigureTypes,
                        ),
                      ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.12),
                    borderRadius: const BorderRadius.all(.circular(Sizes.p4)),
                    border: Border.all(
                      color: typeColor.withValues(alpha: 0.4),
                      width: 0.8,
                    ),
                  ),
                  child: Padding(
                    padding: const .symmetric(horizontal: Sizes.p6),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: .center,
                        mainAxisSize: .min,
                        children: [
                          Icon(icon, size: 13, color: typeColor),
                          const SizedBox(width: Sizes.p4),
                          Flexible(
                            child: Text(
                              displayLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.labelSmall?.copyWith(
                                color: typeColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
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
