import 'package:flutter/material.dart';

/// Parsuje zapisane kolory hex i stosuje stały kolor zastępczy.
final class TaskBoardColorParser {
  const TaskBoardColorParser._();

  static Color parse(String value) {
    final normalized = value.replaceFirst('#', '');
    final parsed = int.tryParse(normalized, radix: 16);
    return parsed == null
        ? const Color(0xFF6C5CE7)
        : Color(0xFF000000 | parsed);
  }
}
