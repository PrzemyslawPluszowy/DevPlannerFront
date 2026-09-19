import 'package:flutter/material.dart';

/// Wspolne stale rozmiarow.
abstract final class Sizes {
  static const double p999 = 999;
  static const double p2 = 2;
  static const double p4 = 4;
  static const double p6 = 6;
  static const double p8 = 8;
  static const double p10 = 10;
  static const double p12 = 12;
  static const double p16 = 16;
  static const double p18 = 18;
  static const double p20 = 20;
  static const double p24 = 24;
  static const double p28 = 28;
  static const double p32 = 32;
  static const double p36 = 36;
  static const double p40 = 40;
  static const double p44 = 44;
  static const double p48 = 48;
}

abstract final class Gaps {
  static const h2 = SizedBox(height: Sizes.p2);
  static const h4 = SizedBox(height: Sizes.p4);
  static const h6 = SizedBox(height: Sizes.p6);
  static const h8 = SizedBox(height: Sizes.p8);
  static const h12 = SizedBox(height: Sizes.p12);
  static const h16 = SizedBox(height: Sizes.p16);
  static const h20 = SizedBox(height: Sizes.p20);
  static const h24 = SizedBox(height: Sizes.p24);
  static const h28 = SizedBox(height: Sizes.p28);
  static const h32 = SizedBox(height: Sizes.p32);
  static const h36 = SizedBox(height: Sizes.p36);
  static const h40 = SizedBox(height: Sizes.p40);
  static const h44 = SizedBox(height: Sizes.p44);
  static const h48 = SizedBox(height: Sizes.p48);

  static const w2 = SizedBox(width: Sizes.p2);
  static const w4 = SizedBox(width: Sizes.p4);
  static const w6 = SizedBox(width: Sizes.p6);
  static const w8 = SizedBox(width: Sizes.p8);
  static const w12 = SizedBox(width: Sizes.p12);
  static const w16 = SizedBox(width: Sizes.p16);
  static const w20 = SizedBox(width: Sizes.p20);
  static const w24 = SizedBox(width: Sizes.p24);
  static const w28 = SizedBox(width: Sizes.p28);
  static const w32 = SizedBox(width: Sizes.p32);
  static const w36 = SizedBox(width: Sizes.p36);
  static const w40 = SizedBox(width: Sizes.p40);
  static const w44 = SizedBox(width: Sizes.p44);
  static const w48 = SizedBox(width: Sizes.p48);
}

extension DevPlannerThemeX on ThemeData {
  ColorScheme get colors => colorScheme;
  AppFeedbackColors get feedback =>
      extension<AppFeedbackColors>() ?? AppFeedbackColors.fallback();
  AppSurfaceRoles get surfaceRoles =>
      extension<AppSurfaceRoles>() ?? AppSurfaceRoles.fallback(colorScheme);
}

extension DevPlannerContextThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get text => theme.textTheme;
  AppFeedbackColors get feedback => theme.feedback;
  AppSurfaceRoles get surfaceRoles => theme.surfaceRoles;

  Color formControlFillColor({required bool isFilled}) {
    return isFilled
        ? colors.surfaceContainerLow
        : colors.surfaceContainerLowest;
  }

  Color formControlEnabledBorderColor({required bool isFilled}) {
    return isFilled
        ? colors.outlineVariant.withValues(alpha: .9)
        : colors.outline.withValues(alpha: .65);
  }

  Color formControlDisabledBorderColor({required bool isFilled}) {
    return formControlEnabledBorderColor(
      isFilled: isFilled,
    ).withValues(alpha: .6);
  }

  Color get formControlHintColor =>
      colors.onSurfaceVariant.withValues(alpha: .88);

  Color get formControlInlineLabelColor =>
      colors.onSurfaceVariant.withValues(alpha: .7);
}

/// Semantyczne kolory feedbacku (info/success/warning/error).
///
/// Trzymamy je jako `ThemeExtension`, zeby miec stale odcienie
/// niezalezne od bazowych tonalnych ról Material (np. tertiary).
class AppFeedbackColors extends ThemeExtension<AppFeedbackColors> {
  const AppFeedbackColors({
    required this.infoBackground,
    required this.infoForeground,
    required this.successBackground,
    required this.successForeground,
    required this.warningBackground,
    required this.warningForeground,
    required this.errorBackground,
    required this.errorForeground,
  });

  factory AppFeedbackColors.fallback() {
    return const AppFeedbackColors(
      infoBackground: Color(0xffdbe7ff),
      infoForeground: Color(0xff041e49),
      successBackground: Color(0xffd8f8e1),
      successForeground: Color(0xff0f5a26),
      warningBackground: Color(0xffffe4bf),
      warningForeground: Color(0xff7a3f00),
      errorBackground: Color(0xffffdad6),
      errorForeground: Color(0xff93000a),
    );
  }

  factory AppFeedbackColors.light() {
    return const AppFeedbackColors(
      infoBackground: Color(0xffdbe7ff),
      infoForeground: Color(0xff041e49),
      successBackground: Color(0xffd8f8e1),
      successForeground: Color(0xff0f5a26),
      warningBackground: Color(0xffffe4bf),
      warningForeground: Color(0xff7a3f00),
      errorBackground: Color(0xffffdad6),
      errorForeground: Color(0xff93000a),
    );
  }

  factory AppFeedbackColors.dark() {
    return const AppFeedbackColors(
      infoBackground: Color(0xff0f3f82),
      infoForeground: Color(0xffdbe7ff),
      successBackground: Color(0xff1a5d33),
      successForeground: Color(0xffd8f8e1),
      warningBackground: Color(0xff7a3f00),
      warningForeground: Color(0xffffe4bf),
      errorBackground: Color(0xff93000a),
      errorForeground: Color(0xffffdad6),
    );
  }

  final Color infoBackground;
  final Color infoForeground;
  final Color successBackground;
  final Color successForeground;
  final Color warningBackground;
  final Color warningForeground;
  final Color errorBackground;
  final Color errorForeground;

  @override
  AppFeedbackColors copyWith({
    Color? infoBackground,
    Color? infoForeground,
    Color? successBackground,
    Color? successForeground,
    Color? warningBackground,
    Color? warningForeground,
    Color? errorBackground,
    Color? errorForeground,
  }) {
    return AppFeedbackColors(
      infoBackground: infoBackground ?? this.infoBackground,
      infoForeground: infoForeground ?? this.infoForeground,
      successBackground: successBackground ?? this.successBackground,
      successForeground: successForeground ?? this.successForeground,
      warningBackground: warningBackground ?? this.warningBackground,
      warningForeground: warningForeground ?? this.warningForeground,
      errorBackground: errorBackground ?? this.errorBackground,
      errorForeground: errorForeground ?? this.errorForeground,
    );
  }

  @override
  AppFeedbackColors lerp(ThemeExtension<AppFeedbackColors>? other, double t) {
    if (other is! AppFeedbackColors) {
      return this;
    }

    return AppFeedbackColors(
      infoBackground: Color.lerp(infoBackground, other.infoBackground, t)!,
      infoForeground: Color.lerp(infoForeground, other.infoForeground, t)!,
      successBackground: Color.lerp(
        successBackground,
        other.successBackground,
        t,
      )!,
      successForeground: Color.lerp(
        successForeground,
        other.successForeground,
        t,
      )!,
      warningBackground: Color.lerp(
        warningBackground,
        other.warningBackground,
        t,
      )!,
      warningForeground: Color.lerp(
        warningForeground,
        other.warningForeground,
        t,
      )!,
      errorBackground: Color.lerp(errorBackground, other.errorBackground, t)!,
      errorForeground: Color.lerp(errorForeground, other.errorForeground, t)!,
    );
  }
}

/// Semantyczne role powierzchni do budowania bardziej czytelnych warstw UI.
///
/// Te kolory porządkują relacje typu:
/// - tło bazowe,
/// - karta wyniesiona,
/// - karta tonalna,
/// - mocniejsza powierzchnia kontrastowa,
/// - lekkie overlaye interakcyjne.
class AppSurfaceRoles extends ThemeExtension<AppSurfaceRoles> {
  /// Tworzy zestaw semantycznych ról powierzchni.
  const AppSurfaceRoles({
    required this.baseBackground,
    required this.baseBorder,
    required this.raisedBackground,
    required this.raisedBorder,
    required this.tintedBackground,
    required this.tintedBorder,
    required this.contrastBackground,
    required this.contrastBorder,
    required this.hoverOverlay,
    required this.pressedOverlay,
  });

  /// Awaryjny zestaw ról powierzchni oparty o bieżący ColorScheme.
  factory AppSurfaceRoles.fallback(ColorScheme colors) {
    return AppSurfaceRoles.light(colors);
  }

  /// Role powierzchni dla jasnego motywu, inspirowane produktem w stylu Google Workspace.
  factory AppSurfaceRoles.light(ColorScheme colors) {
    return AppSurfaceRoles(
      baseBackground: colors.surface,
      baseBorder: colors.outlineVariant.withValues(alpha: .82),
      raisedBackground: colors.surfaceContainerLowest,
      raisedBorder: colors.outlineVariant,
      tintedBackground: Color.alphaBlend(
        colors.primary.withValues(alpha: .055),
        colors.surfaceContainerLow,
      ),
      tintedBorder: Color.alphaBlend(
        colors.primary.withValues(alpha: .08),
        colors.outlineVariant,
      ),
      contrastBackground: colors.surfaceContainerHighest,
      contrastBorder: colors.outline,
      hoverOverlay: colors.primary.withValues(alpha: .045),
      pressedOverlay: colors.primary.withValues(alpha: .085),
    );
  }

  /// Role powierzchni dla ciemnego motywu.
  factory AppSurfaceRoles.dark(ColorScheme colors) {
    return AppSurfaceRoles(
      baseBackground: colors.surface,
      baseBorder: colors.outlineVariant.withValues(alpha: .9),
      raisedBackground: colors.surfaceContainerLow,
      raisedBorder: colors.outlineVariant.withValues(alpha: .92),
      tintedBackground: Color.alphaBlend(
        colors.primary.withValues(alpha: .09),
        colors.surfaceContainer,
      ),
      tintedBorder: Color.alphaBlend(
        colors.primary.withValues(alpha: .12),
        colors.outlineVariant,
      ),
      contrastBackground: colors.surfaceContainerHighest,
      contrastBorder: colors.outline,
      hoverOverlay: colors.primary.withValues(alpha: .08),
      pressedOverlay: colors.primary.withValues(alpha: .14),
    );
  }

  /// Bazowe tło aplikacji / obszaru roboczego.
  final Color baseBackground;

  /// Obramowanie bazowej powierzchni.
  final Color baseBorder;

  /// Tło karty wyniesionej ponad tło bazowe.
  final Color raisedBackground;

  /// Obramowanie karty wyniesionej.
  final Color raisedBorder;

  /// Tonalne tło sekcji pomocniczej lub headera.
  final Color tintedBackground;

  /// Obramowanie tonalnej powierzchni.
  final Color tintedBorder;

  /// Mocniejsza, bardziej kontrastowa powierzchnia dla toolbarów i pill buttons.
  final Color contrastBackground;

  /// Obramowanie powierzchni kontrastowej.
  final Color contrastBorder;

  /// Delikatny overlay hover.
  final Color hoverOverlay;

  /// Mocniejszy overlay pressed / active.
  final Color pressedOverlay;

  @override
  AppSurfaceRoles copyWith({
    Color? baseBackground,
    Color? baseBorder,
    Color? raisedBackground,
    Color? raisedBorder,
    Color? tintedBackground,
    Color? tintedBorder,
    Color? contrastBackground,
    Color? contrastBorder,
    Color? hoverOverlay,
    Color? pressedOverlay,
  }) {
    return AppSurfaceRoles(
      baseBackground: baseBackground ?? this.baseBackground,
      baseBorder: baseBorder ?? this.baseBorder,
      raisedBackground: raisedBackground ?? this.raisedBackground,
      raisedBorder: raisedBorder ?? this.raisedBorder,
      tintedBackground: tintedBackground ?? this.tintedBackground,
      tintedBorder: tintedBorder ?? this.tintedBorder,
      contrastBackground: contrastBackground ?? this.contrastBackground,
      contrastBorder: contrastBorder ?? this.contrastBorder,
      hoverOverlay: hoverOverlay ?? this.hoverOverlay,
      pressedOverlay: pressedOverlay ?? this.pressedOverlay,
    );
  }

  @override
  AppSurfaceRoles lerp(ThemeExtension<AppSurfaceRoles>? other, double t) {
    if (other is! AppSurfaceRoles) {
      return this;
    }

    return AppSurfaceRoles(
      baseBackground: Color.lerp(baseBackground, other.baseBackground, t)!,
      baseBorder: Color.lerp(baseBorder, other.baseBorder, t)!,
      raisedBackground: Color.lerp(
        raisedBackground,
        other.raisedBackground,
        t,
      )!,
      raisedBorder: Color.lerp(raisedBorder, other.raisedBorder, t)!,
      tintedBackground: Color.lerp(
        tintedBackground,
        other.tintedBackground,
        t,
      )!,
      tintedBorder: Color.lerp(tintedBorder, other.tintedBorder, t)!,
      contrastBackground: Color.lerp(
        contrastBackground,
        other.contrastBackground,
        t,
      )!,
      contrastBorder: Color.lerp(contrastBorder, other.contrastBorder, t)!,
      hoverOverlay: Color.lerp(hoverOverlay, other.hoverOverlay, t)!,
      pressedOverlay: Color.lerp(pressedOverlay, other.pressedOverlay, t)!,
    );
  }
}
