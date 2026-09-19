import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

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

/// Lokalny launcher menu wyboru poziomu ryzyka.
final class TaskRiskPicker {
  const TaskRiskPicker._();

  static Future<void> show(
    BuildContext context, {
    required int? currentRisk,
    required Future<bool> Function(int? value) onSave,
    Offset? position,
  }) async {
    final selected = await AppContextMenu.select<int>(
      context,
      globalPosition: position ?? AppContextMenu.positionFor(context),
      options: [
        for (final level in TaskRiskLevel.values)
          AppContextMenuOption(
            value: level.value,
            label: level.label,
            icon: Symbols.shield_rounded,
            iconColor: level.color,
            selected: currentRisk == level.value,
          ),
        if (currentRisk != null)
          AppContextMenuOption(
            value: 0,
            label: 'Wyczyść ryzyko',
            icon: Symbols.close_rounded,
            iconColor: context.colors.error,
            separatorBefore: true,
          ),
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
