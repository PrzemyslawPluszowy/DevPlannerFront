import 'package:flutter/material.dart';

/// Zamienia kolor wybrany przez kontrolkę Fluttera na kontrakt `#RRGGBB`.
final class ProjectDialogColorHexCodec {
  const ProjectDialogColorHexCodec._();

  static String toRgbHex(Color color) {
    final argb = color.toARGB32().toRadixString(16).padLeft(8, '0');
    return '#${argb.substring(2)}';
  }

  /// Rozpoznaje kolor zapisany jako `#RRGGBB` albo `#RRGGBBAA`.
  ///
  /// Zwraca `null` dla wartości spoza kontraktu, żeby kontrolka nie zgadywała
  /// koloru, którego nie da się pokazać użytkownikowi.
  static Color? toColor(String? hex) {
    final value = hex?.trim().replaceFirst('#', '');
    if (value == null) return null;
    if (value.length == 6) {
      final rgb = int.tryParse(value, radix: 16);
      return rgb == null ? null : Color(0xFF000000 | rgb);
    }
    if (value.length == 8) {
      // Kontrakt używa `#RRGGBBAA`, Flutter `0xAARRGGBB`.
      final rgba = int.tryParse(value, radix: 16);
      if (rgba == null) return null;
      return Color(((rgba & 0xFF) << 24) | (rgba >> 8));
    }
    return null;
  }
}
