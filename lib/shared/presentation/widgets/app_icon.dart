import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_control_size.dart';
import 'package:flutter/material.dart';

enum AppIconTone {
  normal,
  muted,
  primary,
  primarySolid,
  contrast,
  success,
  warning,
  danger,
}

/// Lekki wrapper na `Icon`, ktory trzyma spojne skale i tony kolorow.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.icon, {
    super.key,
    this.size = AppControlSize.small,
    this.tone = AppIconTone.normal,
    this.tooltip,
    this.semanticLabel,
    this.decorated = false,
    this.showBorder = true,
  });

  final IconData icon;
  final AppControlSize size;
  final AppIconTone tone;
  final String? tooltip;
  final String? semanticLabel;
  final bool decorated;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final palette = _resolvePalette(context);
    final icon = Icon(
      this.icon,
      size: size.iconSize,
      color: palette.foreground,
      semanticLabel: semanticLabel,
    );
    final content = decorated
        ? Container(
            width: _containerSize,
            height: _containerSize,
            decoration: BoxDecoration(
              color: palette.background,
              borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
              border: showBorder ? Border.all(color: palette.border) : null,
            ),
            alignment: .center,
            child: icon,
          )
        : icon;

    if (tooltip == null || tooltip!.trim().isEmpty) {
      return content;
    }

    return Tooltip(message: tooltip, child: content);
  }

  double get _containerSize => switch (size) {
    AppControlSize.small => Sizes.p28,
    AppControlSize.large => Sizes.p36,
  };

  _AppIconPalette _resolvePalette(BuildContext context) {
    final colors = context.colors;
    final feedback = context.feedback;

    return switch (tone) {
      AppIconTone.normal => _AppIconPalette(
        foreground: colors.onSurface,
        background: colors.surfaceContainerLow,
        border: colors.outlineVariant,
      ),
      AppIconTone.muted => _AppIconPalette(
        foreground: colors.onSurfaceVariant,
        background: colors.surfaceContainer,
        border: colors.outlineVariant,
      ),
      AppIconTone.primary => _AppIconPalette(
        foreground: colors.primary,
        background: colors.primaryContainer.withValues(alpha: .42),
        border: colors.primary.withValues(alpha: .18),
      ),
      AppIconTone.primarySolid => _AppIconPalette(
        foreground: colors.onPrimary,
        background: colors.primary,
        border: colors.primary,
      ),
      AppIconTone.contrast => _AppIconPalette(
        foreground: colors.onInverseSurface,
        background: colors.inverseSurface,
        border: colors.inverseSurface,
      ),
      AppIconTone.success => _AppIconPalette(
        foreground: feedback.successForeground,
        background: feedback.successBackground,
        border: feedback.successForeground.withValues(alpha: .16),
      ),
      AppIconTone.warning => _AppIconPalette(
        foreground: feedback.warningForeground,
        background: feedback.warningBackground,
        border: feedback.warningForeground.withValues(alpha: .16),
      ),
      AppIconTone.danger => _AppIconPalette(
        foreground: feedback.errorForeground,
        background: feedback.errorBackground,
        border: feedback.errorForeground.withValues(alpha: .16),
      ),
    };
  }
}

class _AppIconPalette {
  const _AppIconPalette({
    required this.foreground,
    required this.background,
    required this.border,
  });

  final Color foreground;
  final Color background;
  final Color border;
}
