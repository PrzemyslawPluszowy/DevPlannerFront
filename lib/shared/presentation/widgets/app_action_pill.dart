import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_control_size.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

enum AppActionPillTone { surface, contrast, primary, danger }

/// Kontrastowy przycisk typu pill do akcji szybkich i toolbarow modułu.
///
/// W odróżnieniu od lekkiego `AppActionChip` ma mocniejsze tło,
/// wyraźniejszą sylwetkę i bardziej "medialny" charakter.
class AppActionPill extends StatelessWidget {
  /// Tworzy kontrastowy przycisk typu pill.
  const AppActionPill({
    required this.label,
    super.key,
    this.icon,
    this.trailingIcon,
    this.onPressed,
    this.selected = false,
    this.tone = AppActionPillTone.surface,
    this.size = AppControlSize.small,
  });

  /// Etykieta przycisku.
  final String label;

  /// Opcjonalna ikona początkowa.
  final IconData? icon;

  /// Opcjonalna ikona końcowa.
  final IconData? trailingIcon;

  /// Callback uruchamiany po kliknięciu.
  final VoidCallback? onPressed;

  /// Określa, czy przycisk jest zaznaczony.
  final bool selected;

  /// Ton kolorystyczny przycisku.
  final AppActionPillTone tone;

  /// Skala rozmiaru komponentu.
  final AppControlSize size;

  @override
  Widget build(BuildContext context) {
    final palette = _resolvePalette(context);
    final iconSize = size.iconSize;
    final surfaceRoles = context.surfaceRoles;

    return SizedBox(
      height: size.minHeight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        decoration: ShapeDecoration(
          color: palette.background,
          shape: StadiumBorder(
            side: BorderSide(color: palette.border),
          ),
          shadows: palette.shadow == null
              ? const []
              : [
                  BoxShadow(
                    color: palette.shadow!,
                    blurRadius: Sizes.p12,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            customBorder: const StadiumBorder(),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return surfaceRoles.pressedOverlay;
              }
              if (states.contains(WidgetState.hovered) ||
                  states.contains(WidgetState.focused)) {
                return surfaceRoles.hoverOverlay;
              }
              return null;
            }),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.horizontalPadding,
              ),
              child: Row(
                mainAxisSize: .min,
                children: [
                  if (icon case final leadingIcon?) ...[
                    _PillIconBubble(
                      icon: leadingIcon,
                      iconColor: palette.accentForeground,
                      background: palette.accentBackground,
                      size: size,
                    ),
                    Gaps.w8,
                  ],
                  AppText(
                    label,
                    style:
                        switch (size) {
                          AppControlSize.small => context.text.labelSmall,
                          AppControlSize.large => context.text.labelLarge,
                        }?.copyWith(
                          color: palette.foreground,
                          fontWeight: .w700,
                          height: 1,
                          letterSpacing: -.1,
                        ),
                  ),
                  if (trailingIcon case final endIcon?) ...[
                    Gaps.w8,
                    Icon(
                      endIcon,
                      size: iconSize,
                      color: palette.foreground,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _AppActionPillPalette _resolvePalette(BuildContext context) {
    final colors = context.colors;
    final surfaceRoles = context.surfaceRoles;
    final isEnabled = onPressed != null;

    if (!isEnabled) {
      return _AppActionPillPalette(
        foreground: colors.onSurface.withValues(alpha: .42),
        background: surfaceRoles.raisedBackground,
        border: surfaceRoles.raisedBorder.withValues(alpha: .5),
        accentForeground: colors.onSurface.withValues(alpha: .42),
        accentBackground: surfaceRoles.contrastBackground,
      );
    }

    return switch ((tone, selected)) {
      (AppActionPillTone.surface, false) => _AppActionPillPalette(
        foreground: colors.onSurface,
        background: surfaceRoles.raisedBackground,
        border: surfaceRoles.raisedBorder,
        accentForeground: colors.onSurface,
        accentBackground: surfaceRoles.baseBackground,
      ),
      (AppActionPillTone.surface, true) => _AppActionPillPalette(
        foreground: colors.onSurface,
        background: surfaceRoles.tintedBackground,
        border: surfaceRoles.tintedBorder,
        accentForeground: colors.onSecondaryContainer,
        accentBackground: surfaceRoles.baseBackground,
        shadow: colors.shadow.withValues(alpha: .06),
      ),
      (AppActionPillTone.contrast, false) => _AppActionPillPalette(
        foreground: colors.onSurface,
        background: surfaceRoles.contrastBackground,
        border: surfaceRoles.contrastBorder,
        accentForeground: colors.onSurface,
        accentBackground: surfaceRoles.baseBackground,
      ),
      (AppActionPillTone.contrast, true) => _AppActionPillPalette(
        foreground: colors.onInverseSurface,
        background: colors.inverseSurface,
        border: colors.inverseSurface,
        accentForeground: colors.inverseSurface,
        accentBackground: colors.onInverseSurface,
        shadow: colors.shadow.withValues(alpha: .14),
      ),
      (AppActionPillTone.primary, false) => _AppActionPillPalette(
        foreground: colors.onPrimaryContainer,
        background: colors.primaryContainer,
        border: colors.primary.withValues(alpha: .15),
        accentForeground: colors.onPrimary,
        accentBackground: colors.primary,
        shadow: colors.primary.withValues(alpha: .12),
      ),
      (AppActionPillTone.primary, true) => _AppActionPillPalette(
        foreground: colors.onPrimary,
        background: colors.primary,
        border: colors.primary,
        accentForeground: colors.primary,
        accentBackground: colors.onPrimary,
        shadow: colors.primary.withValues(alpha: .18),
      ),
      (AppActionPillTone.danger, false) => _AppActionPillPalette(
        foreground: colors.onErrorContainer,
        background: colors.errorContainer,
        border: colors.error.withValues(alpha: .18),
        accentForeground: colors.onError,
        accentBackground: colors.error,
        shadow: colors.error.withValues(alpha: .1),
      ),
      (AppActionPillTone.danger, true) => _AppActionPillPalette(
        foreground: colors.onError,
        background: colors.error,
        border: colors.error,
        accentForeground: colors.error,
        accentBackground: colors.onError,
        shadow: colors.error.withValues(alpha: .18),
      ),
    };
  }
}

/// Mała kapsuła ikonowa osadzona w przycisku pill.
class _PillIconBubble extends StatelessWidget {
  /// Tworzy kapsułę ikonową dla przycisku pill.
  const _PillIconBubble({
    required this.icon,
    required this.iconColor,
    required this.background,
    required this.size,
  });

  /// Ikona do wyrenderowania.
  final IconData icon;

  /// Kolor ikony.
  final Color iconColor;

  /// Tło kapsuły.
  final Color background;

  /// Rozmiar wariantu.
  final AppControlSize size;

  @override
  Widget build(BuildContext context) {
    final dimension = switch (size) {
      AppControlSize.small => Sizes.p20,
      AppControlSize.large => Sizes.p28,
    };

    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.all(.circular(Sizes.p999)),
      ),
      alignment: .center,
      child: Icon(
        icon,
        size: size.iconSize,
        color: iconColor,
      ),
    );
  }
}

/// Paleta kolorystyczna przycisku pill.
class _AppActionPillPalette {
  /// Tworzy paletę przycisku pill.
  const _AppActionPillPalette({
    required this.foreground,
    required this.background,
    required this.border,
    required this.accentForeground,
    required this.accentBackground,
    this.shadow,
  });

  /// Kolor tekstu i ikon.
  final Color foreground;

  /// Tło główne przycisku.
  final Color background;

  /// Kolor obramowania.
  final Color border;

  /// Kolor ikony w kapsule.
  final Color accentForeground;

  /// Tło kapsuły ikony.
  final Color accentBackground;

  /// Opcjonalny kolor cienia.
  final Color? shadow;
}
