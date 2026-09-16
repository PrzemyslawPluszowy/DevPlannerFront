import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';

/// Reużywalny górny pasek modułu z miejscem na ikony i przyciski akcji.
///
/// `actions` przyjmuje dowolne widgety, np. `IconButton`, `OutlinedButton`,
/// `TextButton.icon` albo własne komponenty akcji.
class AppModuleTopBar extends StatelessWidget {
  const AppModuleTopBar({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.actions = const [],
    this.height = 70,
    this.horizontalPadding = Sizes.p24,
    this.showBottomBorder = false,
    this.backgroundColor,
  });

  final Widget? leading;
  final String? title;
  final String? subtitle;
  final List<Widget> actions;
  final double height;
  final double horizontalPadding;
  final bool showBottomBorder;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isCompactHeader = height <= 44;
    final titleStyle =
        (isCompactHeader ? context.text.titleMedium : context.text.titleLarge)
            ?.copyWith(fontWeight: .w700, height: 1);
    final subtitleStyle = context.text.bodySmall?.copyWith(
      color: colors.onSurfaceVariant,
      height: 1,
      fontSize: isCompactHeader ? 11 : null,
    );

    return Container(
      height: height,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isCompactHeader ? 0 : Sizes.p2,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surfaceContainerLow,
        border: showBottomBorder
            ? Border(
                bottom: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: .8),
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, Gaps.w12],
          if (title != null || subtitle != null)
            Expanded(
              child: Column(
                mainAxisSize: .min,
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                children: [
                  if (title case final value?)
                    Text(
                      value,
                      style: titleStyle,
                      overflow: .ellipsis,
                    ),
                  if (subtitle case final value?)
                    Text(
                      value,
                      style: subtitleStyle,
                      overflow: .ellipsis,
                    ),
                ],
              ),
            )
          else
            const Spacer(),
          if (actions.isNotEmpty)
            Wrap(
              spacing: Sizes.p8,
              runSpacing: Sizes.p8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: actions,
            ),
        ],
      ),
    );
  }
}
