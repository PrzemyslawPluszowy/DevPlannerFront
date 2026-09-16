import 'package:flutter/material.dart';

import 'package:ready_next/app/shell/overlay/app_modal_host.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_icon.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

enum AppConfirmDialogTone { info, warning, danger }

class AppConfirmDialog extends StatefulWidget {
  const AppConfirmDialog({
    required this.title,
    required this.message,
    super.key,
    this.confirmLabel = 'Potwierdz',
    this.cancelLabel = 'Anuluj',
    this.tone = AppConfirmDialogTone.info,
    this.onConfirm,
    this.content,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final AppConfirmDialogTone tone;
  final Future<bool> Function()? onConfirm;
  final Widget? content;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Potwierdz',
    String cancelLabel = 'Anuluj',
    AppConfirmDialogTone tone = AppConfirmDialogTone.info,
    Future<bool> Function()? onConfirm,
    Widget? content,
  }) async {
    final result = await AppModalHost.showDialog<bool>(
      context,
      builder: (_) {
        return AppConfirmDialog(
          title: title,
          message: message,
          confirmLabel: confirmLabel,
          cancelLabel: cancelLabel,
          tone: tone,
          onConfirm: onConfirm,
          content: content,
        );
      },
    );

    return result ?? false;
  }

  @override
  State<AppConfirmDialog> createState() => _AppConfirmDialogState();
}

class _AppConfirmDialogState extends State<AppConfirmDialog> {
  bool isSubmitting = false;

  Future<void> _handleConfirm() async {
    if (isSubmitting) {
      return;
    }

    if (widget.onConfirm == null) {
      Navigator.of(context).pop(true);
      return;
    }

    setState(() => isSubmitting = true);
    try {
      final shouldClose = await widget.onConfirm!.call();
      if (!mounted) {
        return;
      }
      if (shouldClose) {
        Navigator.of(context).pop(true);
      }
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = _resolvePalette(context, widget.tone);

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: Sizes.p24,
        vertical: Sizes.p24,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const .all(Sizes.p20),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            children: [
              Row(
                crossAxisAlignment: .start,
                children: [
                  Container(
                    width: Sizes.p40,
                    height: Sizes.p40,
                    decoration: BoxDecoration(
                      color: palette.background,
                      borderRadius: const BorderRadius.all(
                        .circular(Sizes.p12),
                      ),
                    ),
                    alignment: .center,
                    child: AppIcon(
                      palette.icon,
                      tone: palette.iconTone,
                    ),
                  ),
                  Gaps.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        AppText(
                          widget.title,
                          style: context.text.titleMedium?.copyWith(
                            fontWeight: .w700,
                          ),
                        ),
                        Gaps.h8,
                        widget.content ??
                            AppText(
                              widget.message,
                              style: context.text.bodyMedium?.copyWith(
                                color: context.colors.onSurfaceVariant,
                                height: 1.35,
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ),
              Gaps.h20,
              Row(
                mainAxisAlignment: .end,
                children: [
                  AppActionButton.text(
                    label: widget.cancelLabel,
                    icon: Icons.close_rounded,
                    tone: .neutral,
                    onPressed: isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(false),
                  ),
                  Gaps.w8,
                  AppActionButton.filled(
                    label: widget.confirmLabel,
                    icon: palette.icon,
                    tone: palette.buttonTone,
                    onPressedAsync: _handleConfirm,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _AppConfirmPalette _resolvePalette(
    BuildContext context,
    AppConfirmDialogTone tone,
  ) {
    final feedback = context.feedback;

    return switch (tone) {
      AppConfirmDialogTone.info => _AppConfirmPalette(
        background: feedback.infoBackground.withValues(alpha: .52),
        icon: Icons.info_outline_rounded,
        iconTone: AppIconTone.primary,
        buttonTone: AppActionButtonTone.primary,
      ),
      AppConfirmDialogTone.warning => _AppConfirmPalette(
        background: feedback.warningBackground.withValues(alpha: .72),
        icon: Icons.warning_amber_rounded,
        iconTone: AppIconTone.warning,
        buttonTone: AppActionButtonTone.neutral,
      ),
      AppConfirmDialogTone.danger => _AppConfirmPalette(
        background: feedback.errorBackground.withValues(alpha: .72),
        icon: Icons.delete_outline_rounded,
        iconTone: AppIconTone.danger,
        buttonTone: AppActionButtonTone.danger,
      ),
    };
  }
}

class _AppConfirmPalette {
  const _AppConfirmPalette({
    required this.background,
    required this.icon,
    required this.iconTone,
    required this.buttonTone,
  });

  final Color background;
  final IconData icon;
  final AppIconTone iconTone;
  final AppActionButtonTone buttonTone;
}
