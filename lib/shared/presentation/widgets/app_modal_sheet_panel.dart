import 'package:flutter/material.dart';
import 'package:ready_next/core/theme/theme.dart';

/// Panel wizualny używany przez wspólny modal/sheet.
///
/// Wydzielony od orkiestracji dialogu, aby wspólny modal pozostał małym,
/// kompatybilnym API, a układ nagłówka/body/footer był testowalny osobno.
class AppModalSheetPanel extends StatelessWidget {
  const AppModalSheetPanel({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.footer,
    required this.leading,
    required this.headerActions,
    required this.padding,
    required this.showCloseButton,
    required this.isBusy,
    required this.canClose,
    required this.onClose,
    required this.minBodyHeight,
    required this.maxBodyHeight,
    required this.scrollBody,
    required this.borderRadius,
    super.key,
  });

  final String? title;
  final String? subtitle;
  final Widget body;
  final Widget? footer;
  final Widget? leading;
  final List<Widget>? headerActions;
  final EdgeInsetsGeometry padding;
  final bool showCloseButton;
  final bool isBusy;
  final bool canClose;
  final VoidCallback? onClose;
  final double minBodyHeight;
  final double maxBodyHeight;
  final bool scrollBody;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final blockClose = isBusy || !canClose;
    final titleStyle = context.text.titleLarge?.copyWith(fontWeight: .w700);
    final subtitleStyle = context.text.bodyMedium?.copyWith(
      color: colors.onSurfaceVariant,
    );

    return Material(
      color: colors.surfaceContainerLowest,
      elevation: 8,
      borderRadius: borderRadius,
      clipBehavior: .antiAlias,
      child: Column(
        mainAxisSize: maxBodyHeight == double.infinity
            ? MainAxisSize.max
            : MainAxisSize.min,
        children: [
          Container(
            padding: padding,
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              border: Border(bottom: BorderSide(color: colors.outlineVariant)),
            ),
            child: Row(
              crossAxisAlignment: .start,
              children: [
                if (leading != null) ...[leading!, Gaps.w12],
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      if (title != null) Text(title!, style: titleStyle),
                      if (subtitle != null) ...[
                        if (title != null) Gaps.h4,
                        Text(subtitle!, style: subtitleStyle),
                      ],
                    ],
                  ),
                ),
                if (headerActions != null)
                  Row(mainAxisSize: .min, children: headerActions!),
                if (showCloseButton)
                  IconButton(
                    onPressed: blockClose
                        ? null
                        : (onClose ?? () => Navigator.of(context).maybePop()),
                    tooltip: 'Zamknij',
                    icon: const Icon(Icons.close_rounded),
                  ),
              ],
            ),
          ),
          Flexible(
            fit: maxBodyHeight == double.infinity
                ? FlexFit.tight
                : FlexFit.loose,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: minBodyHeight,
                maxHeight: maxBodyHeight,
              ),
              child: scrollBody
                  ? SingleChildScrollView(padding: padding, child: body)
                  : Padding(
                      padding: padding,
                      child: SizedBox(
                        width: double.infinity,
                        height: maxBodyHeight == double.infinity
                            ? double.infinity
                            : null,
                        child: body,
                      ),
                    ),
            ),
          ),
          if (footer case final value)
            Container(
              width: double.infinity,
              padding: padding,
              decoration: BoxDecoration(
                color: colors.surfaceContainerLow,
                border: Border(top: BorderSide(color: colors.outlineVariant)),
              ),
              child: value,
            ),
        ],
      ),
    );
  }
}
