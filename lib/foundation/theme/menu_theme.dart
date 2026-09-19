import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Tokeny jednej powierzchni menu kontekstowego DevPlanner.
///
/// Menu używa zarówno Tasks, jak i Storage czy katalog workspace'ów, dlatego
/// miary i role powierzchni żyją w warstwie theme, a nie w pojedynczym widoku.
/// Dzięki temu kliknięcie `…`, prawy klik i picker mają ten sam wiersz, ikonę,
/// promień i zachowanie, niezależnie od modułu.
final class DevPlannerMenuTheme extends ThemeExtension<DevPlannerMenuTheme> {
  const DevPlannerMenuTheme({
    required this.itemText,
    required this.sectionText,
    required this.shortcutText,
    required this.rowHeight,
    required this.iconSize,
    required this.minWidth,
    required this.maxWidth,
    required this.radius,
    required this.padding,
    required this.sectionPadding,
    required this.surface,
    required this.border,
    required this.shadow,
    required this.divider,
    required this.itemForeground,
    required this.itemHover,
    required this.itemSelectedForeground,
    required this.itemSelectedSurface,
    required this.sectionForeground,
    required this.destructive,
    required this.destructiveHover,
    required this.disabledOpacity,
  });

  /// Buduje tokeny menu z aktywnego motywu i palety aplikacji.
  factory DevPlannerMenuTheme.of(TextTheme text, ColorScheme colors) {
    final body = text.bodyMedium ?? const TextStyle();
    return DevPlannerMenuTheme(
      itemText: body.copyWith(fontSize: 13, height: 18 / 13),
      sectionText: (text.labelSmall ?? body).copyWith(
        fontSize: 11,
        height: 16 / 11,
        fontWeight: FontWeight.w700,
        letterSpacing: .4,
      ),
      shortcutText: (text.labelSmall ?? body).copyWith(
        fontSize: 11,
        height: 16 / 11,
      ),
      rowHeight: 32,
      iconSize: 16,
      minWidth: 220,
      maxWidth: 300,
      radius: 8,
      padding: 4,
      sectionPadding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
      surface: colors.surfaceContainerLowest,
      border: colors.outlineVariant,
      shadow: colors.shadow,
      divider: colors.outlineVariant,
      itemForeground: colors.onSurface,
      itemHover: colors.primary.withValues(alpha: .06),
      itemSelectedForeground: colors.primary,
      itemSelectedSurface: colors.primary.withValues(alpha: .09),
      sectionForeground: colors.onSurfaceVariant,
      destructive: colors.error,
      destructiveHover: colors.error.withValues(alpha: .10),
      disabledOpacity: .4,
    );
  }

  /// Etykieta pozycji menu.
  final TextStyle itemText;

  /// Nagłówek sekcji menu.
  final TextStyle sectionText;

  /// Skrót klawiaturowy pokazywany po prawej stronie wiersza.
  final TextStyle shortcutText;

  /// Wysokość wiersza pozycji.
  final double rowHeight;

  /// Rozmiar ikony pozycji.
  final double iconSize;

  /// Minimalna i maksymalna szerokość powierzchni menu.
  final double minWidth;
  final double maxWidth;

  /// Promień powierzchni i wiersza menu.
  final double radius;

  /// Padding powierzchni menu.
  final double padding;

  /// Padding nagłówka sekcji.
  final EdgeInsets sectionPadding;

  /// Tło powierzchni menu.
  final Color surface;

  /// Obramowanie powierzchni menu.
  final Color border;

  /// Cień powierzchni menu.
  final Color shadow;

  /// Linia oddzielająca sekcje.
  final Color divider;

  /// Kolor zwykłej pozycji.
  final Color itemForeground;

  /// Tło wiersza pod kursorem lub wyróżnionego klawiaturą.
  final Color itemHover;

  /// Kolor pozycji wybranej.
  final Color itemSelectedForeground;

  /// Tło pozycji wybranej.
  final Color itemSelectedSurface;

  /// Kolor nagłówka sekcji.
  final Color sectionForeground;

  /// Kolor akcji destrukcyjnej.
  final Color destructive;

  /// Tło akcji destrukcyjnej pod kursorem.
  final Color destructiveHover;

  /// Krycie pozycji wyłączonej.
  final double disabledOpacity;

  /// Promień wiersza pozycji liczony z promienia powierzchni.
  double get itemRadius => (radius - 2).clamp(4, radius);

  @override
  DevPlannerMenuTheme copyWith({
    TextStyle? itemText,
    TextStyle? sectionText,
    TextStyle? shortcutText,
    double? rowHeight,
    double? iconSize,
    double? minWidth,
    double? maxWidth,
    double? radius,
    double? padding,
    EdgeInsets? sectionPadding,
    Color? surface,
    Color? border,
    Color? shadow,
    Color? divider,
    Color? itemForeground,
    Color? itemHover,
    Color? itemSelectedForeground,
    Color? itemSelectedSurface,
    Color? sectionForeground,
    Color? destructive,
    Color? destructiveHover,
    double? disabledOpacity,
  }) => DevPlannerMenuTheme(
    itemText: itemText ?? this.itemText,
    sectionText: sectionText ?? this.sectionText,
    shortcutText: shortcutText ?? this.shortcutText,
    rowHeight: rowHeight ?? this.rowHeight,
    iconSize: iconSize ?? this.iconSize,
    minWidth: minWidth ?? this.minWidth,
    maxWidth: maxWidth ?? this.maxWidth,
    radius: radius ?? this.radius,
    padding: padding ?? this.padding,
    sectionPadding: sectionPadding ?? this.sectionPadding,
    surface: surface ?? this.surface,
    border: border ?? this.border,
    shadow: shadow ?? this.shadow,
    divider: divider ?? this.divider,
    itemForeground: itemForeground ?? this.itemForeground,
    itemHover: itemHover ?? this.itemHover,
    itemSelectedForeground: itemSelectedForeground ?? this.itemSelectedForeground,
    itemSelectedSurface: itemSelectedSurface ?? this.itemSelectedSurface,
    sectionForeground: sectionForeground ?? this.sectionForeground,
    destructive: destructive ?? this.destructive,
    destructiveHover: destructiveHover ?? this.destructiveHover,
    disabledOpacity: disabledOpacity ?? this.disabledOpacity,
  );

  @override
  DevPlannerMenuTheme lerp(ThemeExtension<DevPlannerMenuTheme>? other, double t) {
    if (other is! DevPlannerMenuTheme) return this;
    return DevPlannerMenuTheme(
      itemText: TextStyle.lerp(itemText, other.itemText, t)!,
      sectionText: TextStyle.lerp(sectionText, other.sectionText, t)!,
      shortcutText: TextStyle.lerp(shortcutText, other.shortcutText, t)!,
      rowHeight: lerpDouble(rowHeight, other.rowHeight, t)!,
      iconSize: lerpDouble(iconSize, other.iconSize, t)!,
      minWidth: lerpDouble(minWidth, other.minWidth, t)!,
      maxWidth: lerpDouble(maxWidth, other.maxWidth, t)!,
      radius: lerpDouble(radius, other.radius, t)!,
      padding: lerpDouble(padding, other.padding, t)!,
      sectionPadding: EdgeInsets.lerp(
        sectionPadding,
        other.sectionPadding,
        t,
      )!,
      surface: Color.lerp(surface, other.surface, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      itemForeground: Color.lerp(itemForeground, other.itemForeground, t)!,
      itemHover: Color.lerp(itemHover, other.itemHover, t)!,
      itemSelectedForeground: Color.lerp(
        itemSelectedForeground,
        other.itemSelectedForeground,
        t,
      )!,
      itemSelectedSurface: Color.lerp(
        itemSelectedSurface,
        other.itemSelectedSurface,
        t,
      )!,
      sectionForeground: Color.lerp(
        sectionForeground,
        other.sectionForeground,
        t,
      )!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      destructiveHover: Color.lerp(
        destructiveHover,
        other.destructiveHover,
        t,
      )!,
      disabledOpacity: lerpDouble(disabledOpacity, other.disabledOpacity, t)!,
    );
  }
}

/// Odczyt tokenów menu bez kopiowania miar i kolorów do widgetów.
extension DevPlannerMenuThemeContextX on BuildContext {
  DevPlannerMenuTheme get menuTheme {
    final theme = Theme.of(this);
    return theme.extension<DevPlannerMenuTheme>() ??
        DevPlannerMenuTheme.of(theme.textTheme, theme.colorScheme);
  }
}
