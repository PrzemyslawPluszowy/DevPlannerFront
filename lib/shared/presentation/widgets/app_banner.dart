import 'package:devplanner/core/theme/theme.dart';
import 'package:flutter/material.dart';

enum AppBannerTone { info, success, warning, error }

/// Inline banner do komunikatow w sekcjach i formularzach.
class AppBanner extends StatelessWidget {
  const AppBanner({
    required this.message, super.key,
    this.title,
    this.tone = AppBannerTone.info,
    this.onClose,
    this.trailing,
  });

  final String message;
  final String? title;
  final AppBannerTone tone;
  final VoidCallback? onClose;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final feedback = context.feedback;
    final background = _backgroundFor(feedback, tone);
    final foreground = _foregroundFor(feedback, tone);

    return Container(
      width: double.infinity,
      padding: const .all(Sizes.p12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
        border: Border.all(color: foreground.withValues(alpha: .18)),
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Icon(_iconFor(tone), color: foreground, size: Sizes.p16),
          Gaps.w8,
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: context.text.labelLarge?.copyWith(
                      color: foreground,
                      fontWeight: .w700,
                    ),
                  ),
                  Gaps.h4,
                ],
                Text(
                  message,
                  style: context.text.bodyMedium?.copyWith(
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[Gaps.w8, trailing!],
          if (onClose != null) ...[
            Gaps.w4,
            IconButton(
              visualDensity: .compact,
              tooltip: 'Zamknij',
              onPressed: onClose,
              icon: Icon(Icons.close_rounded, color: foreground, size: Sizes.p16),
            ),
          ],
        ],
      ),
    );
  }

  static IconData _iconFor(AppBannerTone tone) {
    return switch (tone) {
      AppBannerTone.info => Icons.info_outline_rounded,
      AppBannerTone.success => Icons.check_circle_outline_rounded,
      AppBannerTone.warning => Icons.warning_amber_rounded,
      AppBannerTone.error => Icons.error_outline_rounded,
    };
  }

  static Color _backgroundFor(AppFeedbackColors feedback, AppBannerTone tone) {
    return switch (tone) {
      AppBannerTone.info => feedback.infoBackground.withValues(alpha: .7),
      AppBannerTone.success => feedback.successBackground.withValues(alpha: .7),
      AppBannerTone.warning => feedback.warningBackground.withValues(alpha: .72),
      AppBannerTone.error => feedback.errorBackground.withValues(alpha: .74),
    };
  }

  static Color _foregroundFor(AppFeedbackColors feedback, AppBannerTone tone) {
    return switch (tone) {
      AppBannerTone.info => feedback.infoForeground,
      AppBannerTone.success => feedback.successForeground,
      AppBannerTone.warning => feedback.warningForeground,
      AppBannerTone.error => feedback.errorForeground,
    };
  }
}
