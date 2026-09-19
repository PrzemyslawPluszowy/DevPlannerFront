import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Definicja poziomu złożoności zadania (1..5).
enum TaskComplexityLevel {
  veryLow(1, '1 – Bardzo niska', Color(0xFF10B981)),
  low(2, '2 – Niska', Color(0xFF06B6D4)),
  medium(3, '3 – Średnia', Color(0xFFF59E0B)),
  high(4, '4 – Wysoka', Color(0xFFF97316)),
  veryHigh(5, '5 – Bardzo wysoka', Color(0xFFEF4444));

  const TaskComplexityLevel(this.value, this.label, this.color);

  final int value;
  final String label;
  final Color color;

  static TaskComplexityLevel? fromValue(int? value) => switch (value) {
    1 => veryLow,
    2 => low,
    3 => medium,
    4 => high,
    5 => veryHigh,
    _ => null,
  };
}

/// Lokalny launcher menu wyboru poziomu złożoności.
final class TaskComplexityPicker {
  const TaskComplexityPicker._();

  static Future<void> show(
    BuildContext context, {
    required int? currentComplexity,
    required Future<bool> Function(int? value) onSave,
    Offset? position,
  }) async {
    final selected = await AppContextMenu.select<int>(
      context,
      globalPosition: position ?? AppContextMenu.positionFor(context),
      options: [
        for (final level in TaskComplexityLevel.values)
          AppContextMenuOption(
            value: level.value,
            label: level.label,
            icon: Symbols.tune_rounded,
            iconColor: level.color,
            selected: currentComplexity == level.value,
          ),
        if (currentComplexity != null)
          AppContextMenuOption(
            value: 0,
            label: 'Wyczyść złożoność',
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
