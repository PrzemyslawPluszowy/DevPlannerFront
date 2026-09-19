import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_bubble_toast.dart';
import 'package:devplanner/shared/presentation/widgets/app_icon.dart';
import 'package:devplanner/shared/presentation/widgets/app_text.dart';
import 'package:devplanner/shared/presentation/widgets/app_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppCopyField extends StatelessWidget {
  const AppCopyField({
    required this.value,
    super.key,
    this.label,
    this.copiedMessage,
    this.maxLines = 1,
  });

  final String value;
  final String? label;
  final String? copiedMessage;
  final int maxLines;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) {
      return;
    }

    AppBubbleToast.show(
      context,
      message: copiedMessage ?? 'Skopiowano do schowka',
      tone: AppBubbleToastTone.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p12,
        vertical: Sizes.p10,
      ),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                if (label case final item) ...[
                  AppText(
                    item,
                    style: context.text.labelSmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                      fontWeight: .w700,
                    ),
                  ),
                  Gaps.h4,
                ],
                AppText(
                  value,
                  selectable: true,
                  maxLines: maxLines,
                  overflow: maxLines == 1 ? .ellipsis : .clip,
                  style: context.text.bodyMedium?.copyWith(
                    fontWeight: .w600,
                    color: context.colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Gaps.w8,
          AppTooltip(
            message: 'Kopiuj',
            child: InkWell(
              onTap: () => _copy(context),
              borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
              child: Container(
                width: Sizes.p32,
                height: Sizes.p32,
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerLow,
                  borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
                ),
                alignment: .center,
                child: const AppIcon(
                  Icons.content_copy_rounded,
                  tone: AppIconTone.muted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
