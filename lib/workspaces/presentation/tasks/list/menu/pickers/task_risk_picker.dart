import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/menu/task_context_menu.dart';

/// Definicja poziomu ryzyka zadania z etykietą i kolorem.
enum TaskRiskLevel {
  low(1, 'Niskie', Color(0xFF10B981)),
  medium(2, 'Średnie', Color(0xFFF59E0B)),
  high(3, 'Wysokie', Color(0xFFF97316)),
  critical(4, 'Krytyczne', Color(0xFFEF4444));

  const TaskRiskLevel(this.value, this.label, this.color);

  final int value;
  final String label;
  final Color color;

  static TaskRiskLevel? fromValue(int? value) => switch (value) {
    1 => low,
    2 => medium,
    3 => high,
    4 => critical,
    _ => null,
  };
}

/// Wyświetla zakotwiczone menu wyboru poziomu ryzyka z kolorami.
Future<void> showTaskRiskPicker(
  BuildContext context, {
  required int? currentRisk,
  required Future<bool> Function(int? value) onSave,
  RelativeRect? menuPosition,
}) async {
  final position = menuPosition ?? TaskContextMenu.positionFor(context);

  final selected = await TaskContextMenu.show<int?>(
    context,
    position: position,
    items: [
      for (final level in TaskRiskLevel.values)
        TaskContextMenuItem<int?>(
          value: level.value,
          title: level.label,
          icon: Symbols.shield_rounded,
          iconColor: level.color,
          isSelected: currentRisk == level.value,
        ),
      if (currentRisk != null) ...[
        const TaskContextMenuDivider(),
        TaskContextMenuItem<int?>(
          value: 0,
          title: 'Wyczyść ryzyko',
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
