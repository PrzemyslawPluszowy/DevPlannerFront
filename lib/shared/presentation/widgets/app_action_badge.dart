import 'package:flutter/material.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_control_size.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

enum AppActionBadgeTone { neutral, primary, info, success, warning, danger }

typedef AppActionBadgeAsyncCallback = Future<void> Function();

/// Kompaktowy przycisk akcji do toolbarów i headerów sekcji.
///
/// Wyglądem jest bliżej badge niż klasycznego buttona, ale zachowuje
/// interaktywność i obsługę asynchroniczną jak standardowe akcje.
class AppActionBadge extends StatefulWidget {
  /// Tworzy kompaktowy przycisk akcji w stylu badge.
  const AppActionBadge({
    required this.label,
    required this.icon,
    super.key,
    this.onPressed,
    this.onPressedAsync,
    this.tone = AppActionBadgeTone.neutral,
    this.size = AppControlSize.small,
  });

  /// Etykieta przycisku.
  final String label;

  /// Ikona akcji.
  final IconData icon;

  /// Synchroniczny callback uruchamiany po kliknięciu.
  final VoidCallback? onPressed;

  /// Asynchroniczny callback uruchamiany po kliknięciu.
  final AppActionBadgeAsyncCallback? onPressedAsync;

  /// Ton kolorystyczny przycisku.
  final AppActionBadgeTone tone;

  /// Wysokość i gęstość komponentu.
  final AppControlSize size;

  @override
  State<AppActionBadge> createState() => _AppActionBadgeState();
}

/// Stan przycisku badge odpowiedzialny za obsługę asynchroniczną.
class _AppActionBadgeState extends State<AppActionBadge> {
  bool isLoading = false;

  Future<void> _handleAsyncPress() async {
    if (isLoading || widget.onPressedAsync == null) {
      return;
    }

    setState(() => isLoading = true);
    try {
      await widget.onPressedAsync!();
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _resolvePalette(context);
    final surfaceRoles = context.surfaceRoles;
    final effectiveOnTap = isLoading
        ? null
        : widget.onPressedAsync == null
        ? widget.onPressed
        : _handleAsyncPress;
    final iconSize = widget.size.iconSize;

    return SizedBox(
      height: widget.size.minHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
          border: Border.all(color: palette.border),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: effectiveOnTap,
            customBorder: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(.circular(Sizes.p8)),
            ),
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
                horizontal: widget.size.horizontalPadding,
              ),
              child: Row(
                mainAxisSize: .min,
                children: [
                  if (isLoading)
                    SizedBox.square(
                      dimension: iconSize,
                      child: AppSpinner(
                        strokeWidth: 2,
                        color: palette.foreground,
                      ),
                    )
                  else
                    Icon(
                      widget.icon,
                      size: iconSize,
                      color: palette.foreground,
                    ),
                  const SizedBox(width: 6),
                  AppText(
                    widget.label,
                    style:
                        switch (widget.size) {
                          AppControlSize.small => context.text.labelSmall,
                          AppControlSize.large => context.text.labelLarge,
                        }?.copyWith(
                          color: palette.foreground,
                          fontWeight: .w700,
                          height: 1,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _AppActionBadgePalette _resolvePalette(BuildContext context) {
    final colors = context.colors;
    final feedback = context.feedback;
    final disabled = widget.onPressed == null && widget.onPressedAsync == null;

    if (disabled) {
      return _AppActionBadgePalette(
        background: colors.surfaceContainerLow,
        foreground: colors.onSurface.withValues(alpha: .42),
        border: colors.outlineVariant.withValues(alpha: .5),
      );
    }

    return switch (widget.tone) {
      AppActionBadgeTone.neutral => _AppActionBadgePalette(
        background: colors.surfaceContainerHigh,
        foreground: colors.onSurface,
        border: colors.outlineVariant,
      ),
      AppActionBadgeTone.primary => _AppActionBadgePalette(
        background: colors.primaryContainer,
        foreground: colors.onPrimaryContainer,
        border: colors.primary.withValues(alpha: .18),
      ),
      AppActionBadgeTone.info => _AppActionBadgePalette(
        background: feedback.infoBackground.withValues(alpha: .82),
        foreground: feedback.infoForeground,
        border: feedback.infoForeground.withValues(alpha: .16),
      ),
      AppActionBadgeTone.success => _AppActionBadgePalette(
        background: feedback.successBackground.withValues(alpha: .84),
        foreground: feedback.successForeground,
        border: feedback.successForeground.withValues(alpha: .16),
      ),
      AppActionBadgeTone.warning => _AppActionBadgePalette(
        background: feedback.warningBackground.withValues(alpha: .86),
        foreground: feedback.warningForeground,
        border: feedback.warningForeground.withValues(alpha: .16),
      ),
      AppActionBadgeTone.danger => _AppActionBadgePalette(
        background: feedback.errorBackground.withValues(alpha: .84),
        foreground: feedback.errorForeground,
        border: feedback.errorForeground.withValues(alpha: .16),
      ),
    };
  }
}

/// Paleta kolorów dla badge actiona.
class _AppActionBadgePalette {
  /// Tworzy paletę kolorów przycisku badge.
  const _AppActionBadgePalette({
    required this.background,
    required this.foreground,
    required this.border,
  });

  /// Tło przycisku.
  final Color background;

  /// Kolor tekstu i ikony.
  final Color foreground;

  /// Kolor obramowania.
  final Color border;
}
