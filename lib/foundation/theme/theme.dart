import 'package:devplanner/foundation/theme/chat_theme.dart';
import 'package:devplanner/foundation/theme/menu_theme.dart';
import 'package:devplanner/foundation/theme/navigation_theme.dart';
import 'package:devplanner/foundation/theme/shell_theme.dart';
import 'package:devplanner/foundation/theme/tasks_theme.dart';
import 'package:devplanner/foundation/theme/theme_extensions.dart';
import 'package:devplanner/foundation/theme/util.dart';
import 'package:flutter/material.dart';

export 'chat_theme.dart';
export 'menu_theme.dart';
export 'navigation_theme.dart';
export 'shell_theme.dart';
export 'tasks_theme.dart';
export 'theme_extensions.dart';

/// Centralna definicja motywu Material 3 dla calej aplikacji.
///
/// Ten plik zawiera:
/// - zestawy `ColorScheme` dla trybu jasnego i ciemnego,
/// - fabryke fontow,
/// - finalne skladanie wszystkiego do `ThemeData`.
class MaterialTheme {
  const MaterialTheme(this.textTheme);

  /// Domyślny wariant brandingu używany przez aplikację DevPlanner.
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
        if (effectiveColorScheme.brightness == Brightness.dark)
          AppFeedbackColors.dark()
        else
          AppFeedbackColors.light(),
        if (effectiveColorScheme.brightness == Brightness.dark)
          AppSurfaceRoles.dark(effectiveColorScheme)
        else
          AppSurfaceRoles.light(effectiveColorScheme),
        if (effectiveColorScheme.brightness == Brightness.dark)
          DevPlannerShellTheme.dark()
        else
          DevPlannerShellTheme.light(),
        const DevPlannerNavigationTheme.standard(),
        DevPlannerMenuTheme.of(appTextTheme, effectiveColorScheme),
        DevPlannerChatTheme.of(appTextTheme, effectiveColorScheme),
        DevPlannerTasksTheme.of(appTextTheme, effectiveColorScheme),
      ],
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      textTheme: appTextTheme,
      iconTheme: IconThemeData(
        size: 18,
        color: effectiveColorScheme.onSurfaceVariant,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(36, 36),
          padding: const EdgeInsets.all(8),
          visualDensity: VisualDensity.compact,
        ),
      ),
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
      dialogTheme: DialogThemeData(
        backgroundColor: effectiveColorScheme.surfaceContainerHigh,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        titleTextStyle: appTextTheme.titleMedium?.copyWith(
          color: effectiveColorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
        contentTextStyle: appTextTheme.bodyMedium?.copyWith(
          color: effectiveColorScheme.onSurface,
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
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
        fontSize: 20,
        color: colorScheme.onSurface,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: 17,
        color: colorScheme.onSurface,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: 15,
        color: colorScheme.onSurface,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: 13,
        color: colorScheme.onSurface,
      ),
      titleSmall: baseTextTheme.titleSmall?.copyWith(
        fontSize: 12,
        color: colorScheme.onSurface,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: 13,
        color: colorScheme.onSurface,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: 12,
        color: colorScheme.onSurface,
      ),
      bodySmall: baseTextTheme.bodySmall?.copyWith(
        fontSize: 11,
        color: colorScheme.onSurfaceVariant,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: 12,
        color: colorScheme.onSurface,
      ),
      // Podłoga czytelności: etykiety kontrolek 12 px, metadane 11 px.
      // Żadna interaktywna etykieta nie schodzi już do 10 px.
      labelMedium: baseTextTheme.labelMedium?.copyWith(
        fontSize: 12,
        color: colorScheme.onSurface,
      ),
      labelSmall: baseTextTheme.labelSmall?.copyWith(
        fontSize: 11,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
