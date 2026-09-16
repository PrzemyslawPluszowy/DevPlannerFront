import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';

/// Uniwersalny kontener informacyjny pod sekcje contentu.
///
/// Kiedy używać:
/// - gdy potrzebujesz „karty sekcji” z tytułem i opisem,
/// - gdy chcesz zachować spójny wygląd bloków informacyjnych w projekcie.
///
/// `child` jest opcjonalny, więc kontener może służyć zarówno jako sam nagłówek
/// sekcji, jak i pełny blok z dodatkowymi widgetami.
class AppInfoContainer extends StatelessWidget {
  const AppInfoContainer({
    super.key,
    this.title,
    this.subtitle,
    this.child,
    this.padding = const .all(Sizes.p20),
    this.flat = false,
    this.showBorder = true,
    this.backgroundColor,
  });

  final String? title;
  final String? subtitle;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final bool flat;
  final bool showBorder;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? colors.surfaceContainerLowest,
        borderRadius: flat ? .zero : const .all(.circular(Sizes.p20)),
        border: showBorder ? Border.all(color: colors.outlineVariant) : null,
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: context.text.headlineSmall?.copyWith(fontWeight: .w700),
            ),
            if (subtitle != null) Gaps.h8,
          ],
          if (subtitle != null) ...[
            Text(
              subtitle!,
              style: context.text.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
          if (child != null) ...[Gaps.h12, child!],
        ],
      ),
    );
  }
}

/// Mała karta typu „label + value” do metryk i statusów.
///
/// Używaj jej w siatkach/wrapach podsumowujących dane (np. status sesji,
/// identyfikatory, liczniki).
class AppInfoStatCard extends StatelessWidget {
  const AppInfoStatCard({
    required this.label,
    required this.value,
    super.key,
    this.width = 216,
  });

  final String label;
  final String value;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: width,
      padding: const .all(Sizes.p16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: const .all(.circular(Sizes.p16)),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            label,
            style: context.text.labelLarge?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          Gaps.h8,
          Text(
            value,
            style: context.text.titleMedium?.copyWith(fontWeight: .w700),
          ),
        ],
      ),
    );
  }
}
