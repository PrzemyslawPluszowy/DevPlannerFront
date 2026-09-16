import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_control_size.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_tooltip.dart';

enum AppStatusBadgeTone { neutral, info, success, warning, danger }

class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    required this.label,
    super.key,
    this.tone = AppStatusBadgeTone.neutral,
    this.icon,
    this.tooltip,
    this.size = AppControlSize.small,
    this.expandable = false,
    this.showBorder = true,
  });

  final String label;
  final AppStatusBadgeTone tone;
  final IconData? icon;
  final String? tooltip;
  final AppControlSize size;
  final bool expandable;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    final palette = _resolvePalette(context);

    final badge = SizedBox(
      width: expandable ? double.infinity : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: const BorderRadius.all(.circular(Sizes.p999)),
          border: showBorder ? Border.all(color: palette.border) : null,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _horizontalPadding,
            vertical: _verticalPadding,
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: expandable ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: .center,
              children: [
                if (icon case final value) ...[
                  Icon(
                    value,
                    size: _iconSize,
                    color: palette.foreground,
                    opticalSize: _iconSize,
                  ),
                  Gaps.w4,
                ],
                AppText(
                  label,
                  style: _textStyle(context)?.copyWith(
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
    );

    if (tooltip case final message?) {
      final trimmedMessage = message.trim();
      if (trimmedMessage.isNotEmpty) {
        return AppTooltip(message: trimmedMessage, child: badge);
      }
    }

    return badge;
  }

  double get _horizontalPadding => switch (size) {
    AppControlSize.small => Sizes.p8,
    AppControlSize.large => Sizes.p12,
  };

  double get _verticalPadding => switch (size) {
    AppControlSize.small => Sizes.p4,
    AppControlSize.large => Sizes.p8,
  };

  double get _iconSize => switch (size) {
    AppControlSize.small => Sizes.p16,
    AppControlSize.large => Sizes.p18,
  };

  TextStyle? _textStyle(BuildContext context) {
    return switch (size) {
      AppControlSize.small => context.text.labelSmall,
      AppControlSize.large => context.text.labelLarge,
    };
  }

  _AppStatusBadgePalette _resolvePalette(BuildContext context) {
    final colors = context.colors;
    final feedback = context.feedback;

    return switch (tone) {
      AppStatusBadgeTone.neutral => _AppStatusBadgePalette(
        background: colors.surfaceContainerLow,
        foreground: colors.onSurface.withValues(alpha: .92),
        border: colors.outline,
      ),
      AppStatusBadgeTone.info => _AppStatusBadgePalette(
        background: feedback.infoBackground.withValues(alpha: .72),
        foreground: feedback.infoForeground,
        border: feedback.infoForeground.withValues(alpha: .16),
      ),
      AppStatusBadgeTone.success => _AppStatusBadgePalette(
        background: feedback.successBackground.withValues(alpha: .78),
        foreground: feedback.successForeground,
        border: feedback.successForeground.withValues(alpha: .16),
      ),
      AppStatusBadgeTone.warning => _AppStatusBadgePalette(
        background: feedback.warningBackground.withValues(alpha: .82),
        foreground: feedback.warningForeground,
        border: feedback.warningForeground.withValues(alpha: .16),
      ),
      AppStatusBadgeTone.danger => _AppStatusBadgePalette(
        background: feedback.errorBackground.withValues(alpha: .8),
        foreground: feedback.errorForeground,
        border: feedback.errorForeground.withValues(alpha: .16),
      ),
    };
  }
}

class _AppStatusBadgePalette {
  const _AppStatusBadgePalette({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final Color border;
}
