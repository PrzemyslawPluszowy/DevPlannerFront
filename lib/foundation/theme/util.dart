import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Buduje `TextTheme` laczacy dwa kroje pisma.
///
/// W tym projekcie font "display" obsluguje wieksze naglowki, a font "body"
/// podstawowe teksty, etykiety i tytuly.
TextTheme createTextTheme(String bodyFontString, String displayFontString) {
  final baseTextTheme = Typography.material2021().black;

  // Preferujemy lokalny font "Inter", jesli jest dostepny w pubspec.
  // GoogleFonts automatycznie uzyje lokalnego fontu o tej samej nazwie,
  // jesli jest on zdefiniowany w pubspec.yaml pod ta sama rodzina.
  final bodyTextTheme = GoogleFonts.getTextTheme(
    bodyFontString,
    baseTextTheme,
  );
  final displayTextTheme = GoogleFonts.getTextTheme(
    displayFontString,
    baseTextTheme,
  );
  final textTheme = displayTextTheme.copyWith(
    bodyLarge: bodyTextTheme.bodyLarge,
    bodyMedium: bodyTextTheme.bodyMedium,
    bodySmall: bodyTextTheme.bodySmall,
    labelLarge: bodyTextTheme.labelLarge,
    labelMedium: bodyTextTheme.labelMedium,
    labelSmall: bodyTextTheme.labelSmall,
    titleLarge: bodyTextTheme.titleLarge,
    titleMedium: bodyTextTheme.titleMedium,
    titleSmall: bodyTextTheme.titleSmall,
  );
  return textTheme;
}
