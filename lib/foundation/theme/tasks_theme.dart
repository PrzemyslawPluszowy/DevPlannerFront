import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Tokeny gęstości, typografii i powierzchni modułu Tasks.
///
/// Lista, Kanban, command bar, nagłówek i menu kontekstowe muszą opisywać tę
/// samą gęstość, więc miary i role powierzchni żyją w jednym rozszerzeniu
/// motywu, a nie w lokalnych `copyWith(fontSize: ...)` i `Colors.*`.
///
/// Style tekstu pochodzą z motywu aplikacji, żeby produkt zachował rodzinę
/// Inter także po zmianie rozmiaru lub wagi.
final class DevPlannerTasksTheme extends ThemeExtension<DevPlannerTasksTheme> {
  const DevPlannerTasksTheme({
    required this.projectTitleText,
    required this.dataText,
    required this.dataStrongText,
    required this.cardTitleText,
    required this.controlText,
    required this.metaText,
    required this.contextRowHeight,
    required this.commandRowHeight,
    required this.tableHeaderHeight,
    required this.tableRowHeight,
    required this.tableGroupRowHeight,
    required this.controlRadius,
    required this.menuRadius,
    required this.panelRadius,
    required this.tightGap,
    required this.controlGap,
    required this.rowGutter,
    required this.sectionGap,
    required this.blockGap,
    required this.canvas,
    required this.canvasBorder,
    required this.commandBarSurface,
    required this.commandBarBorder,
    required this.cardSurface,
    required this.cardBorder,
    required this.divider,
    required this.rowHover,
    required this.rowSelected,
    required this.bulkBarSurface,
    required this.bulkBarBorder,
    required this.selectionAccent,
    required this.onAccent,
    required this.shadow,
    required this.scrim,
  });

  /// Buduje tokeny Tasks z aktywnego motywu i palety aplikacji.
  ///
  /// Podstawowy tekst danych to 13/18, kontrolki 12/16 z wagą 600, a metadane
  /// 11/16 — dzięki temu żadna interaktywna etykieta nie schodzi do 10 px.
  factory DevPlannerTasksTheme.of(TextTheme text, ColorScheme colors) {
    final data = text.bodyLarge ?? const TextStyle();
    final meta = text.bodySmall ?? const TextStyle();
    return DevPlannerTasksTheme(
      projectTitleText: (text.titleMedium ?? data).copyWith(
        fontSize: 15,
        height: 20 / 15,
        fontWeight: FontWeight.w600,
      ),
      dataText: data.copyWith(fontSize: 13, height: 18 / 13),
      dataStrongText: data.copyWith(
        fontSize: 13,
        height: 18 / 13,
        fontWeight: FontWeight.w600,
      ),
      // Karta Kanbanu jest mniejszym nośnikiem niż wiersz tabeli, więc jej
      // tytuł ma własny token zamiast lokalnego `fontSize` w widgecie.
      cardTitleText: data.copyWith(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
      ),
      controlText: (text.labelLarge ?? data).copyWith(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w600,
      ),
      metaText: meta.copyWith(fontSize: 11, height: 16 / 11),
      contextRowHeight: 46,
      commandRowHeight: 38,
      tableHeaderHeight: 36,
      tableRowHeight: 38,
      tableGroupRowHeight: 40,
      controlRadius: 8,
      menuRadius: 8,
      panelRadius: 12,
      tightGap: 4,
      controlGap: 8,
      rowGutter: 12,
      sectionGap: 16,
      blockGap: 24,
      canvas: colors.surface,
      canvasBorder: colors.outlineVariant,
      commandBarSurface: colors.surfaceContainerLow,
      commandBarBorder: colors.outlineVariant,
      cardSurface: colors.surfaceContainerLowest,
      cardBorder: colors.outlineVariant,
      divider: colors.outlineVariant,
      rowHover: colors.primary.withValues(alpha: .045),
      rowSelected: colors.primary.withValues(alpha: .09),
      bulkBarSurface: colors.surfaceContainerHigh,
      bulkBarBorder: colors.outline,
      selectionAccent: colors.primary,
      onAccent: colors.onPrimary,
      shadow: colors.shadow,
      scrim: colors.scrim,
    );
  }

  /// Nagłówek projektu i jego licznik.
  final TextStyle projectTitleText;

  /// Podstawowy tekst danych: tytuł zadania, komórki tabeli.
  final TextStyle dataText;

  /// Ten sam rozmiar co [dataText], ale z wagą dla wiersza wyróżnionego.
  final TextStyle dataStrongText;

  /// Tytuł karty Kanbanu: 14/20 z wagą 600.
  final TextStyle cardTitleText;

  /// Etykiety kontrolek, nagłówki kolumn i zakładki.
  final TextStyle controlText;

  /// Metadane: klucz zadania, liczniki, terminy, podpisy.
  final TextStyle metaText;

  /// Wysokość wiersza kontekstu w nagłówku (nazwa projektu, zakładki, CTA).
  final double contextRowHeight;

  /// Wysokość wiersza poleceń (wyszukiwanie, filtry, widoki, sortowanie).
  final double commandRowHeight;

  /// Wysokość nagłówka tabeli Listy.
  final double tableHeaderHeight;

  /// Bazowa wysokość wiersza Listy.
  final double tableRowHeight;

  /// Wysokość wiersza grupy Listy.
  final double tableGroupRowHeight;

  /// Promień kontrolek, pól i chipów.
  final double controlRadius;

  /// Promień powierzchni menu.
  final double menuRadius;

  /// Promień większego panelu lub arkusza.
  final double panelRadius;

  /// Skala odstępów oparta na siatce 4 px: 4/8/12/16/24.
  final double tightGap;
  final double controlGap;
  final double rowGutter;
  final double sectionGap;
  final double blockGap;

  /// Jedna powierzchnia obszaru roboczego Listy i Kanbanu.
  final Color canvas;

  /// Cienka linia oddzielająca canvas od ramy.
  final Color canvasBorder;

  /// Powierzchnia wiersza poleceń.
  final Color commandBarSurface;
  final Color commandBarBorder;

  /// Powierzchnia karty Kanbanu.
  final Color cardSurface;
  final Color cardBorder;

  /// Linia podziału wierszy i sekcji.
  final Color divider;

  /// Overlay wiersza pod kursorem.
  final Color rowHover;

  /// Overlay wiersza zaznaczonego.
  final Color rowSelected;

  /// Powierzchnia kontekstowego paska akcji masowych.
  final Color bulkBarSurface;
  final Color bulkBarBorder;

  /// Akcent wyboru i akcji.
  final Color selectionAccent;

  /// Tekst i ikona na kolorze akcentu lub statusu.
  final Color onAccent;

  /// Cień kart i pasków akcji.
  final Color shadow;

  /// Tło pod modalem i arkuszem.
  final Color scrim;

  @override
  DevPlannerTasksTheme copyWith({
    TextStyle? projectTitleText,
    TextStyle? dataText,
    TextStyle? dataStrongText,
    TextStyle? cardTitleText,
    TextStyle? controlText,
    TextStyle? metaText,
    double? contextRowHeight,
    double? commandRowHeight,
    double? tableHeaderHeight,
    double? tableRowHeight,
    double? tableGroupRowHeight,
    double? controlRadius,
    double? menuRadius,
    double? panelRadius,
    double? tightGap,
    double? controlGap,
    double? rowGutter,
    double? sectionGap,
    double? blockGap,
    Color? canvas,
    Color? canvasBorder,
    Color? commandBarSurface,
    Color? commandBarBorder,
    Color? cardSurface,
    Color? cardBorder,
    Color? divider,
    Color? rowHover,
    Color? rowSelected,
    Color? bulkBarSurface,
    Color? bulkBarBorder,
    Color? selectionAccent,
    Color? onAccent,
    Color? shadow,
    Color? scrim,
  }) => DevPlannerTasksTheme(
    projectTitleText: projectTitleText ?? this.projectTitleText,
    dataText: dataText ?? this.dataText,
    dataStrongText: dataStrongText ?? this.dataStrongText,
    cardTitleText: cardTitleText ?? this.cardTitleText,
    controlText: controlText ?? this.controlText,
    metaText: metaText ?? this.metaText,
    contextRowHeight: contextRowHeight ?? this.contextRowHeight,
    commandRowHeight: commandRowHeight ?? this.commandRowHeight,
    tableHeaderHeight: tableHeaderHeight ?? this.tableHeaderHeight,
    tableRowHeight: tableRowHeight ?? this.tableRowHeight,
    tableGroupRowHeight: tableGroupRowHeight ?? this.tableGroupRowHeight,
    controlRadius: controlRadius ?? this.controlRadius,
    menuRadius: menuRadius ?? this.menuRadius,
    panelRadius: panelRadius ?? this.panelRadius,
    tightGap: tightGap ?? this.tightGap,
    controlGap: controlGap ?? this.controlGap,
    rowGutter: rowGutter ?? this.rowGutter,
    sectionGap: sectionGap ?? this.sectionGap,
    blockGap: blockGap ?? this.blockGap,
    canvas: canvas ?? this.canvas,
    canvasBorder: canvasBorder ?? this.canvasBorder,
    commandBarSurface: commandBarSurface ?? this.commandBarSurface,
    commandBarBorder: commandBarBorder ?? this.commandBarBorder,
    cardSurface: cardSurface ?? this.cardSurface,
    cardBorder: cardBorder ?? this.cardBorder,
    divider: divider ?? this.divider,
    rowHover: rowHover ?? this.rowHover,
    rowSelected: rowSelected ?? this.rowSelected,
    bulkBarSurface: bulkBarSurface ?? this.bulkBarSurface,
    bulkBarBorder: bulkBarBorder ?? this.bulkBarBorder,
    selectionAccent: selectionAccent ?? this.selectionAccent,
    onAccent: onAccent ?? this.onAccent,
    shadow: shadow ?? this.shadow,
    scrim: scrim ?? this.scrim,
  );

  @override
  DevPlannerTasksTheme lerp(
    ThemeExtension<DevPlannerTasksTheme>? other,
    double t,
  ) {
    if (other is! DevPlannerTasksTheme) return this;
    return DevPlannerTasksTheme(
      projectTitleText: TextStyle.lerp(
        projectTitleText,
        other.projectTitleText,
        t,
      )!,
      dataText: TextStyle.lerp(dataText, other.dataText, t)!,
      dataStrongText: TextStyle.lerp(dataStrongText, other.dataStrongText, t)!,
      cardTitleText: TextStyle.lerp(cardTitleText, other.cardTitleText, t)!,
      controlText: TextStyle.lerp(controlText, other.controlText, t)!,
      metaText: TextStyle.lerp(metaText, other.metaText, t)!,
      contextRowHeight: lerpDouble(
        contextRowHeight,
        other.contextRowHeight,
        t,
      )!,
      commandRowHeight: lerpDouble(
        commandRowHeight,
        other.commandRowHeight,
        t,
      )!,
      tableHeaderHeight: lerpDouble(
        tableHeaderHeight,
        other.tableHeaderHeight,
        t,
      )!,
      tableRowHeight: lerpDouble(tableRowHeight, other.tableRowHeight, t)!,
      tableGroupRowHeight: lerpDouble(
        tableGroupRowHeight,
        other.tableGroupRowHeight,
        t,
      )!,
      controlRadius: lerpDouble(controlRadius, other.controlRadius, t)!,
      menuRadius: lerpDouble(menuRadius, other.menuRadius, t)!,
      panelRadius: lerpDouble(panelRadius, other.panelRadius, t)!,
      tightGap: lerpDouble(tightGap, other.tightGap, t)!,
      controlGap: lerpDouble(controlGap, other.controlGap, t)!,
      rowGutter: lerpDouble(rowGutter, other.rowGutter, t)!,
      sectionGap: lerpDouble(sectionGap, other.sectionGap, t)!,
      blockGap: lerpDouble(blockGap, other.blockGap, t)!,
      canvas: Color.lerp(canvas, other.canvas, t)!,
      canvasBorder: Color.lerp(canvasBorder, other.canvasBorder, t)!,
      commandBarSurface: Color.lerp(
        commandBarSurface,
        other.commandBarSurface,
        t,
      )!,
      commandBarBorder: Color.lerp(
        commandBarBorder,
        other.commandBarBorder,
        t,
      )!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      rowHover: Color.lerp(rowHover, other.rowHover, t)!,
      rowSelected: Color.lerp(rowSelected, other.rowSelected, t)!,
      bulkBarSurface: Color.lerp(bulkBarSurface, other.bulkBarSurface, t)!,
      bulkBarBorder: Color.lerp(bulkBarBorder, other.bulkBarBorder, t)!,
      selectionAccent: Color.lerp(selectionAccent, other.selectionAccent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      scrim: Color.lerp(scrim, other.scrim, t)!,
    );
  }
}

/// Odczyt tokenów Tasks bez kopiowania miar i kolorów do widgetów.
extension DevPlannerTasksThemeContextX on BuildContext {
  DevPlannerTasksTheme get tasksTheme {
    final theme = Theme.of(this);
    return theme.extension<DevPlannerTasksTheme>() ??
        DevPlannerTasksTheme.of(theme.textTheme, theme.colorScheme);
  }
}
