import 'package:flutter/material.dart';

/// Utrzymuje nagłówek grupy w poziomym obszarze widocznym tabeli.
final class TaskListHorizontalStickyRow extends StatelessWidget {
  const TaskListHorizontalStickyRow({
    required this.controller,
    required this.viewportWidth,
    required this.child,
    super.key,
  });
  final ScrollController controller;
  final double viewportWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: AnimatedBuilder(
      animation: controller,
      child: SizedBox(width: viewportWidth, child: child),
      builder: (context, child) => Transform.translate(
        offset: Offset(controller.hasClients ? controller.offset : 0, 0),
        child: child,
      ),
    ),
  );
}
