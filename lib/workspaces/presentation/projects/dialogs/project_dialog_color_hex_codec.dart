import 'package:flutter/material.dart';

/// Zamienia kolor wybrany przez kontrolkę Fluttera na kontrakt `#RRGGBB`.
final class ProjectDialogColorHexCodec {
  const ProjectDialogColorHexCodec._();

  static String toRgbHex(Color color) {
    final argb = color.toARGB32().toRadixString(16).padLeft(8, '0');
    return '#${argb.substring(2)}';
  }
}
