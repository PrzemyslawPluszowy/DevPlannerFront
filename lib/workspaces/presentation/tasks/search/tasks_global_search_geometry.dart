import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Wspólna geometria wierszy i przewijania klawiaturą dla skali tekstu.
final class TasksGlobalSearchGeometry {
  const TasksGlobalSearchGeometry._();

  static double rowExtent({
    required TextScaler textScaler,
    required TextStyle titleStyle,
    required TextStyle metaStyle,
  }) => math.max(
    72,
    textScaler.scale(titleStyle.fontSize ?? 13) *
            (titleStyle.height ?? 18 / 13) *
            2 +
        textScaler.scale(metaStyle.fontSize ?? 11) *
            (metaStyle.height ?? 16 / 11) +
        19,
  );
}
