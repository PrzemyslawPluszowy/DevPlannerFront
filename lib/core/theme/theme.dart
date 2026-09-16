import 'package:flutter/material.dart';
import 'package:ready_next/app/shell/app_shell_metrics.dart';
import 'package:ready_next/core/theme/theme_extensions.dart';
import 'package:ready_next/core/theme/util.dart';

export 'theme_extensions.dart';

/// Centralna definicja motywu Material 3 dla calej aplikacji.
///
/// Ten plik zawiera:
/// - zestawy `ColorScheme` dla trybu jasnego i ciemnego,
/// - fabryke fontow,
/// - finalne skladanie wszystkiego do `ThemeData`.
class MaterialTheme {
  const MaterialTheme(this.textTheme);

  /// Domyslny wariant brandingu uzywany przez aplikacje Ready Next.
  factory MaterialTheme.crm() {
    return MaterialTheme(createTextTheme('Inter', 'Inter'));
  }
  final TextTheme textTheme;

  /// Bazowa paleta dla jasnego motywu.
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0b57d0),
      surfaceTint: Color(0xff0b57d0),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffdbe7ff),
      onPrimaryContainer: Color(0xff041e49),
      secondary: Color(0xff596175),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffdde3f2),
      onSecondaryContainer: Color(0xff171c2b),
      tertiary: Color(0xff00639b),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd0e4ff),
      onTertiaryContainer: Color(0xff001d33),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfff6f8fc),
      onSurface: Color(0xff374151),
      onSurfaceVariant: Color(0xff64748b),
      outline: Color(0xffaeb4bf),
      outlineVariant: Color(0xffdde3ec),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3033),
      inversePrimary: Color(0xffadc6ff),
      primaryFixed: Color(0xffdbe7ff),
      onPrimaryFixed: Color(0xff001a43),
      primaryFixedDim: Color(0xffadc6ff),
      onPrimaryFixedVariant: Color(0xff00409c),
      secondaryFixed: Color(0xffdde3f2),
      onSecondaryFixed: Color(0xff151b28),
      secondaryFixedDim: Color(0xffc1c8d7),
      onSecondaryFixedVariant: Color(0xff42495d),
      tertiaryFixed: Color(0xffd0e4ff),
      onTertiaryFixed: Color(0xff001d33),
      tertiaryFixedDim: Color(0xff9fcbff),
      onTertiaryFixedVariant: Color(0xff004b76),
      surfaceDim: Color(0xffe5eaf1),
      surfaceBright: Color(0xfffcfdff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8fafd),
      surfaceContainer: Color(0xfff0f4f9),
      surfaceContainerHigh: Color(0xffe9eef6),
      surfaceContainerHighest: Color(0xffe2e8f1),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  /// Wariant pomocniczy o podwyzszonym kontraście.
  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff133665),
      surfaceTint: Color(0xff415f91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff506da0),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff2e3647),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff646d80),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff452e4a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff7f6484),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff0f1116),
      onSurfaceVariant: Color(0xff33363e),
      outline: Color(0xff4f525a),
      outlineVariant: Color(0xff6a6d75),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3036),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xff506da0),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff375586),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff646d80),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4c5567),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff7f6484),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff654c6b),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc5c6cd),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff3f3fa),
      surfaceContainer: Color(0xffe7e8ee),
      surfaceContainerHigh: Color(0xffdcdce3),
      surfaceContainerHighest: Color(0xffd1d1d8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  /// Najbardziej kontrastowy wariant jasnego motywu.
  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff032b5b),
      surfaceTint: Color(0xff415f91),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff2a497a),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff232c3d),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff41495b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff3a2440),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff59405e),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff9f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292c33),
      outlineVariant: Color(0xff464951),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3036),
      inversePrimary: Color(0xffaac7ff),
      primaryFixed: Color(0xff2a497a),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff0e3262),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff41495b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2a3344),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff59405e),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff412a47),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb8b8bf),
      surfaceBright: Color(0xfff9f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff0f0f7),
      surfaceContainer: Color(0xffe2e2e9),
      surfaceContainerHigh: Color(0xffd3d4db),
      surfaceContainerHighest: Color(0xffc5c6cd),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  /// Bazowa paleta dla ciemnego motywu.
  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffadc6ff),
      surfaceTint: Color(0xffadc6ff),
      onPrimary: Color(0xff002e6a),
      primaryContainer: Color(0xff00419e),
      onPrimaryContainer: Color(0xffdbe7ff),
      secondary: Color(0xffc1c8d7),
      onSecondary: Color(0xff2b313d),
      secondaryContainer: Color(0xff42495d),
      onSecondaryContainer: Color(0xffdde3f2),
      tertiary: Color(0xff9fcbff),
      onTertiary: Color(0xff003352),
      tertiaryContainer: Color(0xff004b76),
      onTertiaryContainer: Color(0xffd0e4ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff131418),
      onSurface: Color(0xffe8eaed),
      onSurfaceVariant: Color(0xffc1c7d0),
      outline: Color(0xff8b919b),
      outlineVariant: Color(0xff41464d),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe8eaed),
      inversePrimary: Color(0xff0b57d0),
      primaryFixed: Color(0xffdbe7ff),
      onPrimaryFixed: Color(0xff001a43),
      primaryFixedDim: Color(0xffadc6ff),
      onPrimaryFixedVariant: Color(0xff00419e),
      secondaryFixed: Color(0xffdde3f2),
      onSecondaryFixed: Color(0xff151b28),
      secondaryFixedDim: Color(0xffc1c8d7),
      onSecondaryFixedVariant: Color(0xff42495d),
      tertiaryFixed: Color(0xffd0e4ff),
      onTertiaryFixed: Color(0xff001d33),
      tertiaryFixedDim: Color(0xff9fcbff),
      onTertiaryFixedVariant: Color(0xff004b76),
      surfaceDim: Color(0xff131418),
      surfaceBright: Color(0xff38393d),
      surfaceContainerLowest: Color(0xff0e1013),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1e2025),
      surfaceContainerHigh: Color(0xff282b30),
      surfaceContainerHighest: Color(0xff33363b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  /// Wariant pomocniczy o podwyzszonym kontraście dla dark mode.
  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffcdddff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff002551),
      primaryContainer: Color(0xff7491c7),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffd4dcf2),
      onSecondary: Color(0xff1d2636),
      secondaryContainer: Color(0xff8891a5),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff3d2f7),
      onTertiary: Color(0xff331d39),
      tertiaryContainer: Color(0xffa487a9),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdadce6),
      outline: Color(0xffafb2bb),
      outlineVariant: Color(0xff8e9099),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff294878),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff00112b),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff133665),
      secondaryFixed: Color(0xffdae2f9),
      onSecondaryFixed: Color(0xff081121),
      secondaryFixedDim: Color(0xffbec6dc),
      onSecondaryFixedVariant: Color(0xff2e3647),
      tertiaryFixed: Color(0xfffad8fd),
      onTertiaryFixed: Color(0xff1d0823),
      tertiaryFixedDim: Color(0xffddbce0),
      onTertiaryFixedVariant: Color(0xff452e4a),
      surfaceDim: Color(0xff111318),
      surfaceBright: Color(0xff43444a),
      surfaceContainerLowest: Color(0xff06070c),
      surfaceContainerLow: Color(0xff1b1e22),
      surfaceContainer: Color(0xff26282d),
      surfaceContainerHigh: Color(0xff313238),
      surfaceContainerHighest: Color(0xff3c3e43),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  /// Najbardziej kontrastowy wariant ciemnego motywu.
  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffebf0ff),
      surfaceTint: Color(0xffaac7ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa6c3fc),
      onPrimaryContainer: Color(0xff000b20),
      secondary: Color(0xffebf0ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbac3d8),
      onSecondaryContainer: Color(0xff030b1a),
      tertiary: Color(0xffffe9ff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffd8b8dc),
      onTertiaryContainer: Color(0xff16041d),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff111318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeeeff9),
      outlineVariant: Color(0xffc0c2cc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe2e2e9),
      inversePrimary: Color(0xff294878),
      primaryFixed: Color(0xffd6e3ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffaac7ff),
      onPrimaryFixedVariant: Color(0xff00112b),
      secondaryFixed: Color(0xffdae2f9),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbec6dc),
      onSecondaryFixedVariant: Color(0xff081121),
      tertiaryFixed: Color(0xfffad8fd),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffddbce0),
      onTertiaryFixedVariant: Color(0xff1d0823),
      surfaceDim: Color(0xff111318),
      surfaceBright: Color(0xff4e5056),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1d2024),
      surfaceContainer: Color(0xff2e3036),
      surfaceContainerHigh: Color(0xff393b41),
      surfaceContainerHighest: Color(0xff45474c),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  /// Sklada finalne `ThemeData` z wybranego `ColorScheme`.
  ThemeData theme(ColorScheme colorScheme) {
    final effectiveColorScheme = colorScheme.brightness == Brightness.light
        ? colorScheme.copyWith(
            onSurface: const Color(0xff374151),
            onSurfaceVariant: const Color(0xff64748b),
          )
        : colorScheme;
    final appTextTheme = _compactTextTheme(effectiveColorScheme);

    return ThemeData(
      useMaterial3: true,
      brightness: effectiveColorScheme.brightness,
      colorScheme: effectiveColorScheme,
      extensions: [
        const AppShellMetrics.standard(),
        if (effectiveColorScheme.brightness == Brightness.dark)
          AppFeedbackColors.dark()
        else
          AppFeedbackColors.light(),
        if (effectiveColorScheme.brightness == Brightness.dark)
          AppSurfaceRoles.dark(effectiveColorScheme)
        else
          AppSurfaceRoles.light(effectiveColorScheme),
      ],
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textTheme: appTextTheme,
      scaffoldBackgroundColor: effectiveColorScheme.surface,
      canvasColor: effectiveColorScheme.surface,
      appBarTheme: AppBarTheme(
        centerTitle: false,
        scrolledUnderElevation: 0,
        toolbarHeight: 46,
        titleTextStyle: appTextTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: .all(.circular(16))),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        isDense: true,
        contentPadding: .symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: .all(.circular(12))),
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        visualDensity: VisualDensity.compact,
        contentPadding: .symmetric(horizontal: 12, vertical: 0),
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: appTextTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -.1,
        ),
        unselectedLabelStyle: appTextTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const .symmetric(horizontal: 14, vertical: 10),
          minimumSize: const Size(0, 36),
          shape: const RoundedRectangleBorder(
            borderRadius: .all(.circular(12)),
          ),
          textStyle: appTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const .symmetric(horizontal: 14, vertical: 10),
          minimumSize: const Size(0, 36),
          shape: const RoundedRectangleBorder(
            borderRadius: .all(.circular(12)),
          ),
          textStyle: appTextTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      popupMenuTheme: const PopupMenuThemeData(
        position: PopupMenuPosition.under,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  TextTheme _compactTextTheme(ColorScheme colorScheme) {
    final baseTextTheme = textTheme.apply(
      // Tekst główny i nagłówki używają jednolitej, czytelnej barwy onSurface (lekko szary grafit),
      // eliminując niespójność pomiędzy czernią a szarością w elementach interfejsu.
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return baseTextTheme.copyWith(
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontSize: 22,
        color: colorScheme.onSurface,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: 18,
        color: colorScheme.onSurface,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 16,
        color: colorScheme.onSurface,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 14,
        color: colorScheme.onSurface,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize: 13,
        color: colorScheme.onSurface,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 14,
        color: colorScheme.onSurface,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 13,
        color: colorScheme.onSurface,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 12,
        color: colorScheme.onSurfaceVariant,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 13,
        color: colorScheme.onSurface,
      ),
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize: 11,
        color: colorScheme.onSurface,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize: 10,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  List<ExtendedColor> get extendedColors => [];
}

/// Miejsce na dodatkowe kolory spoza bazowego `ColorScheme`.
class ExtendedColor {
  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
  final Color seed;
  final Color value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;
}

/// Zestaw odcieni jednego dodatkowego koloru.
class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
