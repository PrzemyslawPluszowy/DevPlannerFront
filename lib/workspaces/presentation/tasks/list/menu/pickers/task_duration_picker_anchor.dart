import 'package:flutter/material.dart';

/// Wyznacza bezpieczne położenie pickera czasu w granicach viewportu.
final class TaskDurationPickerAnchor {
  const TaskDurationPickerAnchor._();

  static Offset resolve({
    required RelativeRect anchor,
    required Size viewport,
    required double popupWidth,
    required double estimatedHeight,
    required double margin,
  }) {
    var left = anchor.left;
    if (left + popupWidth + margin > viewport.width) {
      left = viewport.width - popupWidth - margin;
    }
    if (left < margin) left = margin;

    var top = anchor.top;
    if (top + estimatedHeight + margin > viewport.height) {
      final above = viewport.height - anchor.bottom - estimatedHeight;
      top = above >= margin
          ? above
          : (viewport.height - estimatedHeight - margin).clamp(
              margin,
              viewport.height,
            );
    }
    if (top < margin) top = margin;
    return Offset(left, top);
  }
}
