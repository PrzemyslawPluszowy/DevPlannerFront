import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';

enum AppSectionCardTone { base, raised, tinted }

class AppSectionCard extends StatelessWidget {
  const AppSectionCard({
    required this.child,
    super.key,
    this.title,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.all(Sizes.p16),
    this.showBorder = true,
    this.tone = AppSectionCardTone.raised,
    this.borderRadius = const BorderRadius.all(.circular(Sizes.p20)),
    this.expandChild = false,
  });

  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsets padding;
  final bool showBorder;
  final AppSectionCardTone tone;
  final BorderRadius borderRadius;
  final bool expandChild;

  @override
  Widget build(BuildContext context) {
    final hasHeader = title != null || subtitle != null || trailing != null;
    final surfaceRoles = context.surfaceRoles;
    final (backgroundColor, borderColor) = switch (tone) {
      AppSectionCardTone.base => (
        surfaceRoles.baseBackground,
        surfaceRoles.baseBorder,
      ),
      AppSectionCardTone.raised => (
        surfaceRoles.raisedBackground,
        surfaceRoles.raisedBorder,
      ),
      AppSectionCardTone.tinted => (
        surfaceRoles.tintedBackground,
        surfaceRoles.tintedBorder,
      ),
    };

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          if (hasHeader) ...[
            Row(
              crossAxisAlignment: .start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      if (title case final value)
                        AppText(
                          value,
                          style: context.text.titleMedium?.copyWith(
                            fontWeight: .w700,
                          ),
                        ),
                      if (subtitle case final value) ...[
                        if (title != null) Gaps.h4,
                        AppText(
                          value,
                          style: context.text.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[Gaps.w12, trailing!],
              ],
            ),
            Gaps.h16,
          ],
          if (expandChild) Expanded(child: child) else child,
        ],
      ),
    );
  }
}
