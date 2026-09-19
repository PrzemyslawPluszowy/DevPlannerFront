import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Wspólna geometria i typografia nawigacji w całym DevPlannerze.
///
/// Menu shella, katalog workspace'ów oraz drzewa zasobów korzystają z tych
/// samych miar. Dzięki temu aktywny wiersz, jego ikona i wcięcie nie zmieniają
/// się przy przejściu między modułami.
final class DevPlannerNavigationTheme
    extends ThemeExtension<DevPlannerNavigationTheme> {
  const DevPlannerNavigationTheme({
    required this.sidebarWidth,
    required this.collapsedSidebarWidth,
    required this.headerHeight,
    required this.rowHeight,
    required this.rowIconSize,
    required this.rowFontSize,
    required this.sectionFontSize,
    required this.rowHorizontalPadding,
    required this.sidebarHorizontalPadding,
    required this.depthIndent,
    required this.selectedRadius,
  });

  const DevPlannerNavigationTheme.standard()
    : sidebarWidth = 224,
      collapsedSidebarWidth = 56,
      headerHeight = 56,
      rowHeight = 28,
      rowIconSize = 18,
      rowFontSize = 12,
      sectionFontSize = 11,
      rowHorizontalPadding = 8,
      sidebarHorizontalPadding = 8,
      depthIndent = 16,
      selectedRadius = 14;

  final double sidebarWidth;
  final double collapsedSidebarWidth;
  final double headerHeight;
  final double rowHeight;
  final double rowIconSize;
  final double rowFontSize;
  final double sectionFontSize;
  final double rowHorizontalPadding;
  final double sidebarHorizontalPadding;
  final double depthIndent;
  final double selectedRadius;

  @override
  DevPlannerNavigationTheme copyWith({
    double? sidebarWidth,
    double? collapsedSidebarWidth,
    double? headerHeight,
    double? rowHeight,
    double? rowIconSize,
    double? rowFontSize,
    double? sectionFontSize,
    double? rowHorizontalPadding,
    double? sidebarHorizontalPadding,
    double? depthIndent,
    double? selectedRadius,
  }) => DevPlannerNavigationTheme(
    sidebarWidth: sidebarWidth ?? this.sidebarWidth,
    collapsedSidebarWidth: collapsedSidebarWidth ?? this.collapsedSidebarWidth,
    headerHeight: headerHeight ?? this.headerHeight,
    rowHeight: rowHeight ?? this.rowHeight,
    rowIconSize: rowIconSize ?? this.rowIconSize,
    rowFontSize: rowFontSize ?? this.rowFontSize,
    sectionFontSize: sectionFontSize ?? this.sectionFontSize,
    rowHorizontalPadding: rowHorizontalPadding ?? this.rowHorizontalPadding,
    sidebarHorizontalPadding:
        sidebarHorizontalPadding ?? this.sidebarHorizontalPadding,
    depthIndent: depthIndent ?? this.depthIndent,
    selectedRadius: selectedRadius ?? this.selectedRadius,
  );

  @override
  DevPlannerNavigationTheme lerp(
    ThemeExtension<DevPlannerNavigationTheme>? other,
    double t,
  ) {
    if (other is! DevPlannerNavigationTheme) return this;
    return DevPlannerNavigationTheme(
      sidebarWidth: lerpDouble(sidebarWidth, other.sidebarWidth, t)!,
      collapsedSidebarWidth: lerpDouble(
        collapsedSidebarWidth,
        other.collapsedSidebarWidth,
        t,
      )!,
      headerHeight: lerpDouble(headerHeight, other.headerHeight, t)!,
      rowHeight: lerpDouble(rowHeight, other.rowHeight, t)!,
      rowIconSize: lerpDouble(rowIconSize, other.rowIconSize, t)!,
      rowFontSize: lerpDouble(rowFontSize, other.rowFontSize, t)!,
      sectionFontSize: lerpDouble(sectionFontSize, other.sectionFontSize, t)!,
      rowHorizontalPadding: lerpDouble(
        rowHorizontalPadding,
        other.rowHorizontalPadding,
        t,
      )!,
      sidebarHorizontalPadding: lerpDouble(
        sidebarHorizontalPadding,
        other.sidebarHorizontalPadding,
        t,
      )!,
      depthIndent: lerpDouble(depthIndent, other.depthIndent, t)!,
      selectedRadius: lerpDouble(selectedRadius, other.selectedRadius, t)!,
    );
  }
}

extension DevPlannerNavigationThemeContextX on BuildContext {
  DevPlannerNavigationTheme get devPlannerNavigationTheme =>
      Theme.of(this).extension<DevPlannerNavigationTheme>() ??
      const DevPlannerNavigationTheme.standard();
}
