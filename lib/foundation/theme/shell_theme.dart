import 'package:flutter/material.dart';

/// Semantyczne kolory zewnętrznej ramy DevPlanner.
///
/// Oddzielamy je od ogólnych ról Material, ponieważ tło gradientowe, sidebar
/// i powierzchnia treści tworzą jeden układ desktopowy inspirowany Gmailem.
/// Ekrany funkcjonalne nie powinny znać ani odtwarzać tych kolorów lokalnie.
final class DevPlannerShellTheme extends ThemeExtension<DevPlannerShellTheme> {
  const DevPlannerShellTheme({
    required this.backdropStart,
    required this.backdropMiddle,
    required this.backdropEnd,
    required this.topBar,
    required this.sidebarText,
    required this.sidebarIcon,
    required this.sidebarSelected,
    required this.sidebarHover,
    required this.contentSurface,
    required this.contentBorder,
  });

  factory DevPlannerShellTheme.light() => const DevPlannerShellTheme(
    backdropStart: Color(0xff063c46),
    backdropMiddle: Color(0xff0c6b7a),
    backdropEnd: Color(0xff168b9c),
    topBar: Color(0x33063c46),
    sidebarText: Color(0xfff1f6f7),
    sidebarIcon: Color(0xffb9d2d6),
    sidebarSelected: Color(0x52ffffff),
    sidebarHover: Color(0x24ffffff),
    contentSurface: Color(0xffffffff),
    contentBorder: Color(0x26ffffff),
  );

  factory DevPlannerShellTheme.dark() => const DevPlannerShellTheme(
    backdropStart: Color(0xff082d35),
    backdropMiddle: Color(0xff104450),
    backdropEnd: Color(0xff185864),
    topBar: Color(0x3d071f25),
    sidebarText: Color(0xffe7eff1),
    sidebarIcon: Color(0xffafccd1),
    sidebarSelected: Color(0x4dffffff),
    sidebarHover: Color(0x1fffffff),
    contentSurface: Color(0xff20252b),
    contentBorder: Color(0x26ffffff),
  );

  /// Pełnoekranowy obraz tła ramy. Asset jest częścią katalogu
  /// `assets/images/` zadeklarowanego w `pubspec.yaml`.
  static const String backdropImageAsset = 'assets/images/bg.jpeg';
  static const AssetImage backdropImage = AssetImage(backdropImageAsset);

  /// Logotyp ramy. Zastępuje tekstową nazwę marki i ikonę w nagłówku menu.
  /// Szeroki lockup z nazwą produktu, więc widget skaluje go szerokością.
  static const String logoAsset = 'assets/images/logo-small.png';
  static const AssetImage logoImage = AssetImage(logoAsset);

  final Color backdropStart;
  final Color backdropMiddle;
  final Color backdropEnd;
  final Color topBar;
  final Color sidebarText;
  final Color sidebarIcon;
  final Color sidebarSelected;
  final Color sidebarHover;
  final Color contentSurface;
  final Color contentBorder;

  LinearGradient get backdropGradient =>
      LinearGradient(colors: [backdropStart, backdropMiddle, backdropEnd]);

  @override
  DevPlannerShellTheme copyWith({
    Color? backdropStart,
    Color? backdropMiddle,
    Color? backdropEnd,
    Color? topBar,
    Color? sidebarText,
    Color? sidebarIcon,
    Color? sidebarSelected,
    Color? sidebarHover,
    Color? contentSurface,
    Color? contentBorder,
  }) => DevPlannerShellTheme(
    backdropStart: backdropStart ?? this.backdropStart,
    backdropMiddle: backdropMiddle ?? this.backdropMiddle,
    backdropEnd: backdropEnd ?? this.backdropEnd,
    topBar: topBar ?? this.topBar,
    sidebarText: sidebarText ?? this.sidebarText,
    sidebarIcon: sidebarIcon ?? this.sidebarIcon,
    sidebarSelected: sidebarSelected ?? this.sidebarSelected,
    sidebarHover: sidebarHover ?? this.sidebarHover,
    contentSurface: contentSurface ?? this.contentSurface,
    contentBorder: contentBorder ?? this.contentBorder,
  );

  @override
  DevPlannerShellTheme lerp(
    ThemeExtension<DevPlannerShellTheme>? other,
    double t,
  ) {
    if (other is! DevPlannerShellTheme) return this;
    return DevPlannerShellTheme(
      backdropStart: Color.lerp(backdropStart, other.backdropStart, t)!,
      backdropMiddle: Color.lerp(backdropMiddle, other.backdropMiddle, t)!,
      backdropEnd: Color.lerp(backdropEnd, other.backdropEnd, t)!,
      topBar: Color.lerp(topBar, other.topBar, t)!,
      sidebarText: Color.lerp(sidebarText, other.sidebarText, t)!,
      sidebarIcon: Color.lerp(sidebarIcon, other.sidebarIcon, t)!,
      sidebarSelected: Color.lerp(sidebarSelected, other.sidebarSelected, t)!,
      sidebarHover: Color.lerp(sidebarHover, other.sidebarHover, t)!,
      contentSurface: Color.lerp(contentSurface, other.contentSurface, t)!,
      contentBorder: Color.lerp(contentBorder, other.contentBorder, t)!,
    );
  }
}

/// Wygodny odczyt shellowych tokenów bez kopiowania palety do widgetów.
extension DevPlannerShellThemeContextX on BuildContext {
  DevPlannerShellTheme get devPlannerShellTheme =>
      Theme.of(this).extension<DevPlannerShellTheme>() ??
      (Theme.of(this).brightness == Brightness.dark
          ? DevPlannerShellTheme.dark()
          : DevPlannerShellTheme.light());
}
