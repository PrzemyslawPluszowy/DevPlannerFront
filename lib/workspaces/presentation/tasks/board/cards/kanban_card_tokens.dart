import 'dart:math' as math;

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Tokeny geometrii, typografii oraz punktowych obramowań dla kart Kanban i podzadań.
///
/// Zgodnie ze specyfikacją visual reset (`docs/kanban-audit-and-rebuild-plan-2026-09-06.md`):
/// - Dyskretny, lekki punktowy dotted border (punkty 1 px co 4 px, radius 10 px) zamiast kresek dashed.
/// - Wyraźna, spokojna hierarchia tekstu: tytuł rodzica 15/20 w500, kod 11/16 w500, podzadanie 13/18.
/// - Ujednolicone odstępy tablicy: gutter 12 px, gap kolumn 12 px, gap kart 8 px.
abstract final class KanbanCardTokens {
  // --- Geometria zewnętrzna karty ---
  static const double cardRadius = 8.0;
  static const double cardBorderWidth = 1.0;
  static const double cardElevationRest = 0.0;
  static const double cardElevationHover = 2.0;

  // Punktowe tokeny zachowane dla kompatybilności historycznej
  static const double cardBorderDotDiameter = 1.0;
  static const double cardBorderDotSpacing = 4.0;

  // --- Geometria drzewa podzadań i separatora ---
  static const double hierarchyDotDiameter = 1.0;
  static const double hierarchyDotSpacing = 4.0;
  static const double hierarchyIndent = 12.0;

  // --- Odstępy wewnątrz karty ---
  static const EdgeInsets contentPaddingCompact = EdgeInsets.all(10.0);
  static const EdgeInsets contentPaddingComfortable = EdgeInsets.all(12.0);

  static const double identityToTitleSpacing = 4.0;
  static const double titleToMetaSpacingCompact = 6.0;
  static const double titleToMetaSpacingComfortable = 8.0;
  static const double sectionSpacingCompact = 6.0;
  static const double sectionSpacingComfortable = 8.0;
  static const double cardGap = 8.0;
  static const double cardGapCompact = 6.0;
  static const double cardGapComfortable = 8.0;

  // --- Wymiary wierszy i kontrolek ---
  static const double toggleRowMinHeightCompact = 28.0;
  static const double toggleRowMinHeightComfortable = 30.0;

  static const double subtaskRowMinHeightCompact = 28.0;
  static const double subtaskRowMinHeightComfortable = 32.0;

  static const double metaIconSize = 16.0;
  static const double actionIconSize = 18.0;

  static const double parentAvatarRadius = 12.0; // średnica 24 px
  static const double childAvatarRadius = 10.0; // średnica 20 px

  static const double minTouchTarget = 44.0;
  static const double minDesktopTarget = 40.0;

  // --- Kolumna Kanban i siatka tablicy ---
  static const double boardGutter = 12.0;
  static const double columnGap = 12.0;
  static const double columnWidthStandard = 308.0;
  static const double columnHeaderHeight = 40.0;

  // --- Czas trwania animacji ---
  static const Duration expandDuration = Duration(milliseconds: 180);
  static const Duration chevronDuration = Duration(milliseconds: 140);
  static const Curve expandCurve = Curves.easeOutCubic;

  // --- Typografia (zgodnie z sekcją 3.1) ---

  /// Tytuł rodzica: token karty, onSurface (najwyższy kontrast w karcie)
  static TextStyle parentTitle(BuildContext context) =>
      context.tasksTheme.cardTitleText.copyWith(
        color: context.colors.onSurface,
      );

  /// Tytuł podzadania: 12.5–13/18, weight 400 (ukończone) lub 500 (aktywne)
  static TextStyle subtaskTitle(BuildContext context, {bool isDone = false}) {
    final theme = Theme.of(context);
    return context.tasksTheme.dataText.copyWith(
      fontWeight: isDone ? FontWeight.w400 : FontWeight.w500,
      color: isDone
          ? theme.colorScheme.onSurfaceVariant.withValues(alpha: .75)
          : theme.colorScheme.onSurface,
      decoration: isDone ? TextDecoration.lineThrough : null,
      decorationColor: theme.colorScheme.onSurfaceVariant.withValues(alpha: .6),
    );
  }

  /// Kod zadania: 11/16, weight 500, onSurfaceVariant (pomocniczy, neutralny)
  static TextStyle taskCode(BuildContext context) =>
      context.tasksTheme.metaText.copyWith(
        fontWeight: FontWeight.w500,
        color: context.colors.onSurfaceVariant,
        letterSpacing: 0.1,
      );

  /// Termin, liczniki, etykiety: 12/16, weight 400–500, onSurfaceVariant
  static TextStyle metaText(
    BuildContext context, {
    FontWeight weight = FontWeight.w400,
  }) => context.tasksTheme.metaText.copyWith(
    fontWeight: weight,
    color: context.colors.onSurfaceVariant,
  );

  /// Nagłówek przełącznika „Podzadania”: 12/16, weight 500, onSurfaceVariant
  static TextStyle subtasksHeader(BuildContext context) =>
      context.tasksTheme.metaText.copyWith(
        fontWeight: FontWeight.w500,
        color: context.colors.onSurfaceVariant,
      );

  /// Nazwa kolumny: 14/20, weight 600, onSurface
  static TextStyle columnTitle(BuildContext context) =>
      context.tasksTheme.cardTitleText.copyWith(
        color: context.colors.onSurface,
      );

  /// Inicjał awatara dziecka: token metadanych, weight 500.
  ///
  /// Wcześniej stały 10 px bez koloru, więc inicjał nie był związany ani
  /// z podłogą czytelności, ani z kolorem powierzchni awatara.
  static TextStyle childAvatarInitials(BuildContext context) =>
      context.tasksTheme.metaText.copyWith(
        height: 1,
        fontWeight: FontWeight.w500,
        color: context.tasksTheme.onAccent,
      );

  // --- Semantyczne kolory obrysów (Etap B) ---

  /// Ciągły obrys karty w spoczynku (bardzo subtelny, czysty border 1 px).
  static Color cardBorderRest(ColorScheme colors, {bool isDark = false}) =>
      colors.outlineVariant.withValues(alpha: isDark ? .40 : .30);

  /// Obrys karty w stanie hover (wyższy kontrast).
  static Color cardBorderHover(ColorScheme colors, {bool isDark = false}) =>
      colors.outlineVariant.withValues(alpha: isDark ? .80 : .70);

  /// Obrys karty w stanie selected.
  static Color cardBorderSelected(ColorScheme colors) => colors.primary;

  /// Aliasy dla zachowania kompatybilności wstecznej
  static Color cardBorderColor(ColorScheme colors, {bool isDark = false}) =>
      cardBorderRest(colors, isDark: isDark);

  static Color cardBorderHoverColor(ColorScheme colors) =>
      cardBorderHover(colors);

  /// Prowadnice hierarchii podzadań i separator
  static Color hierarchyBorderColor(ColorScheme colors) =>
      colors.outlineVariant.withValues(alpha: .38);
}

/// CustomPainter rysujący precyzyjny dotted border wzdłuż zaokrąglonego prostokąta (RRect).
///
/// Używa pojedynczych okrągłych punktów (`canvas.drawCircle`) o średnicy 1.0 px co 4.0 px.
/// Posiada inset o połowę średnicy punktu (0.5 px), by żadna kropka nie została ścięta na brzegu.
class DottedRRectPainter extends CustomPainter {
  const DottedRRectPainter({
    required this.color,
    this.dotDiameter = KanbanCardTokens.cardBorderDotDiameter,
    this.step = KanbanCardTokens.cardBorderDotSpacing,
    this.radius = KanbanCardTokens.cardRadius,
  });

  final Color color;
  final double dotDiameter;
  final double step;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final dotRadius = dotDiameter / 2.0;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        dotRadius,
        dotRadius,
        math.max(0.0, size.width - dotDiameter),
        math.max(0.0, size.height - dotDiameter),
      ),
      Radius.circular(math.max(0.0, radius - dotRadius)),
    );

    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      final length = metric.length;
      if (length <= 0) continue;

      final count = math.max(1, (length / step).round());
      final actualStep = length / count;

      for (var i = 0; i < count; i++) {
        final distance = i * actualStep;
        final tangent = metric.getTangentForOffset(distance);
        if (tangent != null) {
          canvas.drawCircle(tangent.position, dotRadius, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant DottedRRectPainter oldDelegate) =>
      color != oldDelegate.color ||
      dotDiameter != oldDelegate.dotDiameter ||
      step != oldDelegate.step ||
      radius != oldDelegate.radius;
}

/// Poziomy kropkowany separator odsunięty od krawędzi karty.
///
/// Rysuje pojedyncze punkty 1.0 px co 4.0 px o niskim kontraście.
class DottedHorizontalLinePainter extends CustomPainter {
  const DottedHorizontalLinePainter({
    required this.color,
    this.dotDiameter = KanbanCardTokens.hierarchyDotDiameter,
    this.step = KanbanCardTokens.hierarchyDotSpacing,
  });

  final Color color;
  final double dotDiameter;
  final double step;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final dotRadius = dotDiameter / 2.0;
    final y = size.height / 2.0;

    final count = math.max(1, (size.width / step).floor());
    for (var i = 0; i <= count; i++) {
      final x = i * step;
      if (x <= size.width) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DottedHorizontalLinePainter oldDelegate) =>
      color != oldDelegate.color ||
      dotDiameter != oldDelegate.dotDiameter ||
      step != oldDelegate.step;
}
