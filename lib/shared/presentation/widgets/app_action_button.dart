import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_control_size.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';

enum AppActionButtonVariant { text, outlined, filled }

enum AppActionButtonTone { neutral, primary, danger }

typedef AppActionButtonAsyncCallback = Future<void> Function();

/// Wspolny przycisk akcji dla calej aplikacji.
///
/// Uzywaj fabryk:
/// - `AppActionButton.text(...)`
/// - `AppActionButton.outlined(...)`
/// - `AppActionButton.filled(...)`
///
/// Kolory sa brane z Material `colorScheme`, bez hardcodowanych barw.
class AppActionButton extends StatefulWidget {
  const AppActionButton({
    required this.label,
    required this.icon,
    required this.variant,
    super.key,
    this.onPressed,
    this.onPressedAsync,
    this.tone = AppActionButtonTone.primary,
    this.size = AppControlSize.small,
    this.dense,
  });

  factory AppActionButton.text({
    required String label,
    required IconData icon,
    Key? key,
    VoidCallback? onPressed,
    AppActionButtonAsyncCallback? onPressedAsync,
    AppActionButtonTone tone = AppActionButtonTone.primary,
    AppControlSize size = AppControlSize.small,
    bool? dense,
  }) {
    return AppActionButton(
      key: key,
      label: label,
      icon: icon,
      onPressed: onPressed,
      onPressedAsync: onPressedAsync,
      variant: .text,
      tone: tone,
      size: size,
      dense: dense,
    );
  }

  factory AppActionButton.outlined({
    required String label,
    required IconData icon,
    Key? key,
    VoidCallback? onPressed,
    AppActionButtonAsyncCallback? onPressedAsync,
    AppActionButtonTone tone = AppActionButtonTone.primary,
    AppControlSize size = AppControlSize.small,
    bool? dense,
  }) {
    return AppActionButton(
      key: key,
      label: label,
      icon: icon,
      onPressed: onPressed,
      onPressedAsync: onPressedAsync,
      variant: .outlined,
      tone: tone,
      size: size,
      dense: dense,
    );
  }

  factory AppActionButton.filled({
    required String label,
    required IconData icon,
    Key? key,
    VoidCallback? onPressed,
    AppActionButtonAsyncCallback? onPressedAsync,
    AppActionButtonTone tone = AppActionButtonTone.primary,
    AppControlSize size = AppControlSize.small,
    bool? dense,
  }) {
    return AppActionButton(
      key: key,
      label: label,
      icon: icon,
      onPressed: onPressed,
      onPressedAsync: onPressedAsync,
      variant: .filled,
      tone: tone,
      size: size,
      dense: dense,
    );
  }

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final AppActionButtonAsyncCallback? onPressedAsync;
  final AppActionButtonVariant variant;
  final AppActionButtonTone tone;
  final AppControlSize size;
  final bool? dense;

  @override
  State<AppActionButton> createState() => _AppActionButtonState();

  _AppActionButtonPalette _resolvePalette(ColorScheme scheme) {
    switch ((variant, tone)) {
      case (AppActionButtonVariant.text, AppActionButtonTone.primary):
        return _AppActionButtonPalette(
          foreground: scheme.primary,
          background: Colors.transparent,
          border: Colors.transparent,
          overlay: scheme.primary.withValues(alpha: .08),
        );
      case (AppActionButtonVariant.text, AppActionButtonTone.neutral):
        return _AppActionButtonPalette(
          foreground: scheme.onSurface,
          background: Colors.transparent,
          border: Colors.transparent,
          overlay: scheme.onSurface.withValues(alpha: .08),
        );
      case (AppActionButtonVariant.text, AppActionButtonTone.danger):
        return _AppActionButtonPalette(
          foreground: scheme.error,
          background: Colors.transparent,
          border: Colors.transparent,
          overlay: scheme.error.withValues(alpha: .08),
        );
      case (AppActionButtonVariant.outlined, AppActionButtonTone.primary):
        return _AppActionButtonPalette(
          foreground: scheme.primary,
          background: scheme.surfaceContainerLowest,
          border: scheme.outlineVariant,
          overlay: scheme.primary.withValues(alpha: .08),
        );
      case (AppActionButtonVariant.outlined, AppActionButtonTone.neutral):
        return _AppActionButtonPalette(
          foreground: scheme.onSurface,
          background: scheme.surfaceContainerLowest,
          border: scheme.outlineVariant,
          overlay: scheme.onSurface.withValues(alpha: .08),
        );
      case (AppActionButtonVariant.outlined, AppActionButtonTone.danger):
        return _AppActionButtonPalette(
          foreground: scheme.error,
          background: scheme.errorContainer.withValues(alpha: .16),
          border: scheme.error.withValues(alpha: .36),
          overlay: scheme.error.withValues(alpha: .08),
        );
      case (AppActionButtonVariant.filled, AppActionButtonTone.primary):
        return _AppActionButtonPalette(
          foreground: scheme.onPrimary,
          background: scheme.primary,
          border: Colors.transparent,
          overlay: scheme.onPrimary.withValues(alpha: .12),
        );
      case (AppActionButtonVariant.filled, AppActionButtonTone.neutral):
        return _AppActionButtonPalette(
          foreground: scheme.onSecondaryContainer,
          background: scheme.secondaryContainer,
          border: Colors.transparent,
          overlay: scheme.onSecondaryContainer.withValues(alpha: .1),
        );
      case (AppActionButtonVariant.filled, AppActionButtonTone.danger):
        return _AppActionButtonPalette(
          foreground: scheme.onErrorContainer,
          background: scheme.errorContainer,
          border: scheme.error.withValues(alpha: .2),
          overlay: scheme.onErrorContainer.withValues(alpha: .08),
        );
    }
  }
}

class _AppActionButtonState extends State<AppActionButton> {
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
    final scheme = context.colors;
    final palette = widget._resolvePalette(scheme);
    final effectiveSize = widget.dense == null
        ? widget.size
        : widget.dense!
        ? AppControlSize.small
        : AppControlSize.small;
    final horizontalPadding = effectiveSize.horizontalPadding;
    final iconSize = effectiveSize.iconSize;
    final baseTextStyle = switch (effectiveSize) {
      AppControlSize.small => context.text.labelSmall,
      AppControlSize.large => context.text.labelLarge,
    };
    final textStyle = baseTextStyle?.copyWith(
      fontWeight: widget.variant == AppActionButtonVariant.filled
          ? .w700
          : .w600,
      height: 1,
    );
    final syncTap = widget.onPressed;
    final effectiveOnPressed = isLoading
        ? null
        : widget.onPressedAsync == null
        ? syncTap
        : _handleAsyncPress;
    final leadingIcon = isLoading
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: AppSpinner(
              size: iconSize,
              strokeWidth: 2,
              color: palette.foreground,
            ),
          )
        : Icon(widget.icon, size: iconSize);

    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size(0, effectiveSize.minHeight)),
      maximumSize: WidgetStatePropertyAll(
        Size(double.infinity, effectiveSize.minHeight),
      ),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: .standard,
      alignment: .center,
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: horizontalPadding,
        ),
      ),
      textStyle: WidgetStatePropertyAll(textStyle),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: .all(.circular(Sizes.p8)),
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return palette.foreground.withValues(alpha: .38);
        }
        return palette.foreground;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return palette.background.withValues(alpha: .2);
        }
        return palette.background;
      }),
      overlayColor: WidgetStatePropertyAll(palette.overlay),
      side: WidgetStateProperty.resolveWith((states) {
        if (widget.variant != .outlined) {
          return BorderSide.none;
        }
        final borderColor = states.contains(WidgetState.disabled)
            ? palette.border.withValues(alpha: .28)
            : palette.border;
        return BorderSide(color: borderColor);
      }),
    );

    return SizedBox(
      height: effectiveSize.minHeight,
      child: switch (widget.variant) {
        AppActionButtonVariant.text => TextButton.icon(
          onPressed: effectiveOnPressed,
          style: style,
          icon: leadingIcon,
          label: Text(widget.label),
        ),
        AppActionButtonVariant.outlined => OutlinedButton.icon(
          onPressed: effectiveOnPressed,
          style: style,
          icon: leadingIcon,
          label: Text(widget.label),
        ),
        AppActionButtonVariant.filled => FilledButton.icon(
          onPressed: effectiveOnPressed,
          style: style,
          icon: leadingIcon,
          label: Text(widget.label),
        ),
      },
    );
  }
}

class _AppActionButtonPalette {
  const _AppActionButtonPalette({
    required this.foreground,
    required this.background,
    required this.border,
    required this.overlay,
  });

  final Color foreground;
  final Color background;
  final Color border;
  final Color overlay;
}
