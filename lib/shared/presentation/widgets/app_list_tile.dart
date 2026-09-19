import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// Wspolny tile do list i menu.
class AppListTile extends StatelessWidget {
  const AppListTile({
    required this.title,
    super.key,
    this.titleSpan,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.selected = false,
    this.enabled = true,
    this.dense = true,
    this.titleSelectable = false,
    this.subtitleSelectable = false,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Sizes.p12,
      vertical: Sizes.p4,
    ),
    this.borderRadius = const BorderRadius.all(.circular(Sizes.p8)),
  });

  final String title;
  final InlineSpan? titleSpan;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;
  final bool enabled;
  final bool dense;
  final bool titleSelectable;
  final bool subtitleSelectable;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final titleStyle = context.text.bodyMedium?.copyWith(
      fontWeight: selected ? .w700 : .w600,
      color: enabled
          ? selected
                ? colors.primary
                : colors.onSurface
          : colors.onSurfaceVariant.withValues(alpha: .6),
    );
    final subtitleStyle = context.text.bodySmall?.copyWith(
      color: colors.onSurfaceVariant,
    );

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: borderRadius,
      child: Ink(
        decoration: BoxDecoration(
          color: selected
              ? colors.primaryContainer.withValues(alpha: .42)
              : Colors.transparent,
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: padding,
          child: Row(
            children: [
              if (leading != null) ...[leading!, Gaps.w8],
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    if (titleSpan == null)
                      AppText(
                        title,
                        style: titleStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        selectable: titleSelectable,
                      )
                    else
                      RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: titleStyle,
                          children: [titleSpan!],
                        ),
                      ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: Sizes.p2),
                        child: AppText(
                          subtitle,
                          style: subtitleStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          selectable: subtitleSelectable,
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null) ...[Gaps.w8, trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

/// Wspolny expansion tile do list grupowanych.
class AppExpansionListTile extends StatelessWidget {
  const AppExpansionListTile({
    required this.title,
    required this.children,
    super.key,
    this.titleSpan,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onExpansionChanged,
    this.initiallyExpanded = false,
    this.selected = false,
    this.enabled = true,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Sizes.p12,
      vertical: Sizes.p4,
    ),
    this.childrenPadding = const EdgeInsets.only(
      left: Sizes.p16,
      right: Sizes.p8,
      bottom: Sizes.p8,
    ),
    this.borderRadius = const BorderRadius.all(.circular(Sizes.p12)),
  });

  final String title;
  final InlineSpan? titleSpan;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final List<Widget> children;
  final ValueChanged<bool>? onExpansionChanged;
  final bool initiallyExpanded;
  final bool selected;
  final bool enabled;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry childrenPadding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final titleStyle = context.text.bodyMedium?.copyWith(
      fontWeight: selected ? .w700 : .w600,
      color: enabled
          ? selected
                ? colors.primary
                : colors.onSurface
          : colors.onSurfaceVariant.withValues(alpha: .6),
    );
    final subtitleStyle = context.text.bodySmall?.copyWith(
      color: colors.onSurfaceVariant,
    );

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: ExpansionTile(
          dense: true,
          enabled: enabled,
          initiallyExpanded: initiallyExpanded,
          onExpansionChanged: (expanded) {
            onExpansionChanged?.call(expanded);
            onTap?.call();
          },
          tilePadding: padding,
          childrenPadding: childrenPadding,
          collapsedBackgroundColor: selected
              ? colors.primaryContainer.withValues(alpha: .3)
              : Colors.transparent,
          backgroundColor: selected
              ? colors.primaryContainer.withValues(alpha: .42)
              : colors.surfaceContainerLow.withValues(alpha: .35),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          collapsedShape: RoundedRectangleBorder(borderRadius: borderRadius),
          leading: leading,
          trailing: trailing,
          title: titleSpan == null
              ? AppText(
                  title,
                  style: titleStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              : RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(style: titleStyle, children: [titleSpan!]),
                ),
          subtitle: subtitle == null
              ? null
              : AppText(
                  subtitle,
                  style: subtitleStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
          children: children,
        ),
      ),
    );
  }
}
