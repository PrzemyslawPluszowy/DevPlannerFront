import 'package:flutter/painting.dart';

/// Centralna paleta żywych i stałych kolorów dedykowana dla wykresów BHP.
abstract final class BhpChartColors {
  /// Niebieski
  static const Color blue = Color(0xFF3B82F6);

  /// Zielony
  static const Color green = Color(0xFF10B981);

  /// Pomarańczowy
  static const Color orange = Color(0xFFF59E0B);

  /// Czerwony
  static const Color red = Color(0xFFEF4444);

  /// Fioletowy
  static const Color purple = Color(0xFF8B5CF6);

  /// Różowy
  static const Color pink = Color(0xFFEC4899);

  /// Morski / Turkusowy
  static const Color teal = Color(0xFF14B8A6);

  /// Pełna paleta stałych kolorów do kolorowania serii na wykresach.
  static const List<Color> palette = [
    blue,
    green,
    orange,
    red,
    purple,
    pink,
    teal,
  ];

  /// Kolory dla wykresu porównań 3-letnich (od najstarszego do najnowszego).
  static const List<Color> comparisonYears = [
    orange, // Rok X-2 (najstarszy)
    blue,   // Rok X-1
    green,  // Rok X (bieżący)
  ];
}
