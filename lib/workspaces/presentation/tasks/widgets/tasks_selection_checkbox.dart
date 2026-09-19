import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Checkbox zaznaczania w widokach Tasks: wiersz i nagłówek tabeli Listy oraz
/// karta Kanbanu.
///
/// Material rysuje kwadrat kontrolki o stałym boku [Checkbox.width] (18 px) i
/// obrysie 2 px, więc `visualDensity` zmienia wyłącznie pole wokół glyphu.
/// Ten widget skaluje glyph do [glyphSize] i zamienia obrys na lżejszy, żeby
/// kolumna zaznaczenia nie konkurowała wizualnie z tytułem zadania.
class TasksSelectionCheckbox extends StatelessWidget {
  const TasksSelectionCheckbox({
    required this.value,
    this.onChanged,
    this.semanticLabel,
    super.key,
  });

  final bool value;

  /// `null` renderuje kontrolkę w stanie wyłączonym, tak jak [Checkbox].
  final ValueChanged<bool>? onChanged;

  final String? semanticLabel;

  /// Bok rysowanego kwadratu kontrolki.
  static const double glyphSize = 16.0;

  /// Obrys pola w stanie niezaznaczonym.
  static const double borderWidth = 1.5;

  static const double _glyphScale = glyphSize / Checkbox.width;

  @override
  Widget build(BuildContext context) => Transform.scale(
    scale: _glyphScale,
    // Mniejszy glyph nie może zabrać obszaru klikalnego: pole układu zostaje
    // takie, jakie dostał widget, a trafienia nie są skalowane razem z nim.
    transformHitTests: false,
    child: Checkbox(
      value: value,
      semanticLabel: semanticLabel,
      onChanged: onChanged == null ? null : (value) => onChanged!(value ?? false),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(color: context.colors.outline, width: borderWidth),
    ),
  );
}
