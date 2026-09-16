import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Klasy szerokości obsługiwane przez globalny chrome aplikacji.
enum AppShellViewport { compact, medium, wide }

/// Kontekstowe tokeny geometrii globalnego shellu.
///
/// Shell odczytuje je z aktywnego `ThemeData`, dzięki czemu ekrany modułów nie
/// znają ani wysokości belki, ani szerokości raila. Token zawiera wyłącznie
/// niezmienne reguły prezentacji, bez stanu nawigacji lub logiki biznesowej.
@immutable
class AppShellMetrics extends ThemeExtension<AppShellMetrics> {
  const AppShellMetrics({
    required this.topBarHeight,
    required this.topBarTopInset,
    required this.topBarBottomInset,
    required this.topBarHorizontalInset,
    required this.collapsedRailWidth,
    required this.expandedRailWidth,
    required this.compactBreakpoint,
    required this.wideBreakpoint,
    required this.minimumTouchTarget,
  });

  /// Standardowy kontrakt dla jasnego i ciemnego motywu.
  const AppShellMetrics.standard()
    : topBarHeight = 44,
      topBarTopInset = 8,
      topBarBottomInset = 4,
      topBarHorizontalInset = 12,
      collapsedRailWidth = 56,
      expandedRailWidth = 220,
      compactBreakpoint = 600,
      wideBreakpoint = 1024,
      minimumTouchTarget = 44;

  /// Odczytuje token aktywnego motywu z bezpiecznym standardem dla izolowanego UI.
  factory AppShellMetrics.of(BuildContext context) {
    return Theme.of(context).extension<AppShellMetrics>() ??
        const AppShellMetrics.standard();
  }

  /// Klucz identyfikujący slot paska górnego w testach geometrii shellu.
  static const topBarSlotKey = ValueKey<String>('app-shell-top-bar-slot');

  /// Klucz identyfikujący obszar trasowany wewnątrz prywatnego shellu.
  static const routedContentKey = ValueKey<String>('app-shell-routed-content');

  final double topBarHeight;
  final double topBarTopInset;
  final double topBarBottomInset;
  final double topBarHorizontalInset;
  final double collapsedRailWidth;
  final double expandedRailWidth;
  final double compactBreakpoint;
  final double wideBreakpoint;
  final double minimumTouchTarget;

  /// Wysokość slotu należąca do aplikacji, bez systemowego `viewPadding`.
  double get topBarSlotHeight =>
      topBarTopInset + topBarHeight + topBarBottomInset;

  /// Klasyfikuje logiczną szerokość całego viewportu, nie panelu topbara.
  ///
  /// Dzięki temu rail oraz insets nie przesuwają breakpointów między ekranami.
  AppShellViewport viewportFor(double viewportWidth) {
    if (viewportWidth < compactBreakpoint) return AppShellViewport.compact;
    if (viewportWidth < wideBreakpoint) return AppShellViewport.medium;
    return AppShellViewport.wide;
  }

  @override
  AppShellMetrics copyWith({
    double? topBarHeight,
    double? topBarTopInset,
    double? topBarBottomInset,
    double? topBarHorizontalInset,
    double? collapsedRailWidth,
    double? expandedRailWidth,
    double? compactBreakpoint,
    double? wideBreakpoint,
    double? minimumTouchTarget,
  }) {
    return AppShellMetrics(
      topBarHeight: topBarHeight ?? this.topBarHeight,
      topBarTopInset: topBarTopInset ?? this.topBarTopInset,
      topBarBottomInset: topBarBottomInset ?? this.topBarBottomInset,
      topBarHorizontalInset:
          topBarHorizontalInset ?? this.topBarHorizontalInset,
      collapsedRailWidth: collapsedRailWidth ?? this.collapsedRailWidth,
      expandedRailWidth: expandedRailWidth ?? this.expandedRailWidth,
      compactBreakpoint: compactBreakpoint ?? this.compactBreakpoint,
      wideBreakpoint: wideBreakpoint ?? this.wideBreakpoint,
      minimumTouchTarget: minimumTouchTarget ?? this.minimumTouchTarget,
    );
  }

  @override
  AppShellMetrics lerp(ThemeExtension<AppShellMetrics>? other, double t) {
    if (other is! AppShellMetrics) return this;
    return AppShellMetrics(
      topBarHeight: lerpDouble(topBarHeight, other.topBarHeight, t)!,
      topBarTopInset: lerpDouble(topBarTopInset, other.topBarTopInset, t)!,
      topBarBottomInset: lerpDouble(
        topBarBottomInset,
        other.topBarBottomInset,
        t,
      )!,
      topBarHorizontalInset: lerpDouble(
        topBarHorizontalInset,
        other.topBarHorizontalInset,
        t,
      )!,
      collapsedRailWidth: lerpDouble(
        collapsedRailWidth,
        other.collapsedRailWidth,
        t,
      )!,
      expandedRailWidth: lerpDouble(
        expandedRailWidth,
        other.expandedRailWidth,
        t,
      )!,
      compactBreakpoint: lerpDouble(
        compactBreakpoint,
        other.compactBreakpoint,
        t,
      )!,
      wideBreakpoint: lerpDouble(wideBreakpoint, other.wideBreakpoint, t)!,
      minimumTouchTarget: lerpDouble(
        minimumTouchTarget,
        other.minimumTouchTarget,
        t,
      )!,
    );
  }
}
