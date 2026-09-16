import 'package:flutter/material.dart';

import 'package:ready_next/core/theme/theme.dart';

class AppTooltip extends StatelessWidget {
  const AppTooltip({
    required this.message,
    required this.child,
    super.key,
    this.waitDuration = const Duration(milliseconds: 350),
    this.preferBelow,
  });

  final String message;
  final Widget child;
  final Duration waitDuration;
  final bool? preferBelow;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Tooltip(
      message: message,
      waitDuration: waitDuration,
      preferBelow: preferBelow,
      padding: const EdgeInsets.symmetric(
        horizontal: Sizes.p10,
        vertical: Sizes.p8,
      ),
      margin: const EdgeInsets.all(Sizes.p8),
      textStyle: context.text.bodySmall?.copyWith(
        color: colors.onInverseSurface,
        fontWeight: .w600,
      ),
      decoration: BoxDecoration(
        color: colors.inverseSurface,
        borderRadius: const BorderRadius.all(.circular(Sizes.p8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .14),
            blurRadius: Sizes.p16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
