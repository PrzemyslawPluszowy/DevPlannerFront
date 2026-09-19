import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/task_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Koszykowe rozmiary zadań (T-shirt sizes) z mapowaniem na int.
enum TaskTShirtSize {
  xs(1, 'XS', 'Bardzo mały (1)', Color(0xFF10B981)),
  s(2, 'S', 'Mały (2)', Color(0xFF06B6D4)),
  m(3, 'M', 'Średni (3)', Color(0xFF3B82F6)),
  l(4, 'L', 'Duży (4)', Color(0xFFF59E0B)),
  xl(5, 'XL', 'Bardzo duży (5)', Color(0xFFEF4444));

  const TaskTShirtSize(this.value, this.label, this.description, this.color);

  final int value;
  final String label;
  final String description;
  final Color color;

  static TaskTShirtSize? fromValue(int? value) => switch (value) {
    1 => xs,
    2 => s,
    3 || 8 => m,
    4 || 13 => l,
    5 || 21 => xl,
    _ => null,
  };
}

/// Lokalny launcher selektora rozmiaru zadania.
final class TaskSizePicker {
  const TaskSizePicker._();

  static Future<void> show(
    BuildContext context, {
    required int? currentSize,
    required Future<bool> Function(int? value) onSave,
    RelativeRect? menuPosition,
  }) async {
    final position = menuPosition ?? TaskContextMenu.positionFor(context);

    final selected = await TaskContextMenu.show<int?>(
      context,
      position: position,
      items: [
        const TaskContextMenuHeader(title: 'Rozmiar zadania'),
        for (final size in TaskTShirtSize.values)
          TaskContextMenuItem<int?>(
            value: size.value,
            title: '${size.label} – ${size.description}',
            icon: Symbols.straighten_rounded,
            iconColor: size.color,
            isSelected: TaskTShirtSize.fromValue(currentSize) == size,
          ),
        if (currentSize != null) ...[
          const TaskContextMenuDivider(),
          TaskContextMenuItem<int?>(
            value: 0,
            title: 'Wyczyść rozmiar',
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
