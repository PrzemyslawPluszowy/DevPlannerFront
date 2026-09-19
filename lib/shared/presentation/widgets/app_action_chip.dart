import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_control_size.dart';
import 'package:devplanner/shared/presentation/widgets/app_text.dart';
import 'package:devplanner/shared/presentation/widgets/app_tooltip.dart';
import 'package:flutter/material.dart';

enum AppActionChipTone { neutral, primary, danger }

/// Wspolny przycisk chipowy do szybkich akcji i filtrow kontekstowych.
class AppActionChip extends StatelessWidget {
  /// Tworzy chip akcji w stylu lekkiego, zaokraglonego przycisku.
  const AppActionChip({
    required this.label,
    super.key,
    this.icon,
    this.tooltip,
    this.onPressed,
    this.selected = false,
    this.tone = AppActionChipTone.neutral,
    this.size = AppControlSize.small,
  });

  /// Etykieta widoczna na chipie.
  final String label;

  /// Opcjonalna ikona poprzedzajaca etykiete.
  final IconData? icon;

  /// Opcjonalny opis widoczny po najechaniu kursorem.
  final String? tooltip;

  /// Callback po kliknieciu.
  final VoidCallback? onPressed;

  /// Wskazuje, czy chip jest aktywny / wybrany.
  final bool selected;

  /// Ton semantyczny komponentu.
  final AppActionChipTone tone;

  /// Skala rozmiaru komponentu.
  final AppControlSize size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final palette = _resolvePalette(colors);

    final chip = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: ShapeDecoration(
        color: palette.background,
        shape: StadiumBorder(
          side: BorderSide(color: palette.border),
        ),
        shadows: selected
            ? [
                BoxShadow(
                  color: palette.foreground.withValues(alpha: .08),
                  blurRadius: Sizes.p12,
                  offset: const Offset(0, 4),
                ),
              ]
            : const [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size == AppControlSize.small ? Sizes.p12 : Sizes.p16,
              vertical: size == AppControlSize.large ? Sizes.p10 : Sizes.p8,
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                if (icon case final chipIcon) ...[
                  Icon(
                    chipIcon,
                    size: size.iconSize,
                    color: palette.foreground,
                  ),
                  Gaps.w8,
                ],
                AppText(
                  label,
                  style: context.text.labelLarge?.copyWith(
                    color: palette.foreground,
                    fontWeight: .w600,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (tooltip case final message?) {
      final trimmedMessage = message.trim();
      if (trimmedMessage.isNotEmpty) {
        return AppTooltip(message: trimmedMessage, child: chip);
      }
    }

    return chip;
  }

  _AppActionChipPalette _resolvePalette(ColorScheme colors) {
    final isEnabled = onPressed != null;
    final disabledForeground = colors.onSurface.withValues(alpha: .42);
    final disabledBorder = colors.outlineVariant.withValues(alpha: .4);
    final disabledBackground = colors.surfaceContainerLow;

    if (!isEnabled) {
      return _AppActionChipPalette(
        foreground: disabledForeground,
        background: disabledBackground,
        border: disabledBorder,
      );
    }

    return switch ((tone, selected)) {
      (AppActionChipTone.primary, true) => _AppActionChipPalette(
        foreground: colors.onPrimary,
        background: colors.primary,
        border: colors.primary,
      ),
      (AppActionChipTone.primary, false) => _AppActionChipPalette(
        foreground: colors.primary,
        background: colors.primaryContainer.withValues(alpha: .28),
        border: colors.primary.withValues(alpha: .2),
      ),
      (AppActionChipTone.danger, true) => _AppActionChipPalette(
        foreground: colors.onError,
        background: colors.error,
        border: colors.error,
      ),
      (AppActionChipTone.danger, false) => _AppActionChipPalette(
        foreground: colors.error,
        background: colors.errorContainer.withValues(alpha: .3),
        border: colors.error.withValues(alpha: .18),
      ),
      (AppActionChipTone.neutral, true) => _AppActionChipPalette(
        foreground: colors.onSecondaryContainer,
        background: colors.secondaryContainer,
        border: colors.secondaryContainer,
      ),
      (AppActionChipTone.neutral, false) => _AppActionChipPalette(
        foreground: colors.onSurface,
        background: colors.surfaceContainerLow,
        border: colors.outlineVariant.withValues(alpha: .9),
      ),
    };
  }
}

/// Zestaw kolorów obliczonych dla chipa akcji.
class _AppActionChipPalette {
  const _AppActionChipPalette({
    required this.foreground,
    required this.background,
    required this.border,
  });

  final Color foreground;
  final Color background;
  final Color border;
}
