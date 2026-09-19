import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
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
    Offset? position,
  }) async {
    final selected = await AppContextMenu.select<int>(
      context,
      globalPosition: position ?? AppContextMenu.positionFor(context),
      options: [
        for (final size in TaskTShirtSize.values)
          AppContextMenuOption(
            sectionTitle: 'Rozmiar zadania',
            value: size.value,
            label: '${size.label} – ${size.description}',
            icon: Symbols.straighten_rounded,
            iconColor: size.color,
            selected: TaskTShirtSize.fromValue(currentSize) == size,
          ),
        if (currentSize != null)
          AppContextMenuOption(
            value: 0,
            label: 'Wyczyść rozmiar',
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
