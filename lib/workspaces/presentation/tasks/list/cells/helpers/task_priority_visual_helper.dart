import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';

/// Pomocnik wizualny dla priorytetów zadań.
abstract final class TaskPriorityVisualHelper {
  /// Zwraca zlokalizowaną etykietę priorytetu.
  static String label(BuildContext context, TaskPriority priority) =>
      switch (priority) {
        TaskPriority.low => context.l10n.tasksPriorityLow,
        TaskPriority.normal => context.l10n.tasksPriorityNormal,
        TaskPriority.high => context.l10n.tasksPriorityHigh,
        TaskPriority.critical => context.l10n.tasksPriorityCritical,
      };

  /// Zwraca kolor semantyczny priorytetu.
  static Color color(TaskPriority priority) => switch (priority) {
    TaskPriority.low => const Color(0xFF64748B),
    TaskPriority.normal => const Color(0xFF3B82F6),
    TaskPriority.high => const Color(0xFFF97316),
    TaskPriority.critical => const Color(0xFFEF4444),
  };

  /// Zwraca ikonę reprezentującą dany priorytet.
  static IconData icon(TaskPriority priority) => switch (priority) {
    TaskPriority.low => Symbols.keyboard_arrow_down_rounded,
    TaskPriority.normal => Symbols.remove_rounded,
    TaskPriority.high => Symbols.keyboard_arrow_up_rounded,
    TaskPriority.critical => Symbols.priority_high_rounded,
  };
}
