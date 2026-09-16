import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_bubble_toast.dart';

enum AppToastTone { info, success, warning, error }

/// Wspolny helper do pokazywania toastow opartych o `SnackBar`.
///
/// Uzywaj zamiast bezposredniego `ScaffoldMessenger.showSnackBar`,
/// zeby miec jednolity wyglad i semantyke komunikatow.
abstract final class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    AppToastTone tone = AppToastTone.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    if (actionLabel == null || onAction == null) {
      AppBubbleToast.show(
        context,
        message: message,
        duration: duration,
        tone: switch (tone) {
          AppToastTone.info => AppBubbleToastTone.info,
          AppToastTone.success => AppBubbleToastTone.success,
          AppToastTone.warning => AppBubbleToastTone.warning,
          AppToastTone.error => AppBubbleToastTone.error,
        },
      );
      return;
    }

    final feedback = context.feedback;
    final textStyle = context.text.bodyMedium?.copyWith(
      color: _foregroundFor(feedback, tone),
      fontWeight: .w600,
    );

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: .floating,
        duration: duration,
        backgroundColor: _backgroundFor(feedback, tone),
        shape: const RoundedRectangleBorder(
          borderRadius: .all(.circular(Sizes.p8)),
        ),
        content: Row(
          children: [
            Icon(
              _iconFor(tone),
              size: Sizes.p16,
              color: _foregroundFor(feedback, tone),
            ),
            Gaps.w8,
            Expanded(
              child: Text(
                message,
                style: textStyle,
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: actionLabel,
          textColor: _foregroundFor(feedback, tone),
          onPressed: onAction,
        ),
      ),
    );
  }

  static IconData _iconFor(AppToastTone tone) {
    return switch (tone) {
      AppToastTone.info => Icons.info_outline_rounded,
      AppToastTone.success => Icons.check_circle_outline_rounded,
      AppToastTone.warning => Icons.warning_amber_rounded,
      AppToastTone.error => Icons.error_outline_rounded,
    };
  }

  static Color _backgroundFor(AppFeedbackColors feedback, AppToastTone tone) {
    return switch (tone) {
      AppToastTone.info => feedback.infoBackground,
      AppToastTone.success => feedback.successBackground,
      AppToastTone.warning => feedback.warningBackground,
      AppToastTone.error => feedback.errorBackground,
    };
  }

  static Color _foregroundFor(AppFeedbackColors feedback, AppToastTone tone) {
    return switch (tone) {
      AppToastTone.info => feedback.infoForeground,
      AppToastTone.success => feedback.successForeground,
      AppToastTone.warning => feedback.warningForeground,
      AppToastTone.error => feedback.errorForeground,
    };
  }
}
