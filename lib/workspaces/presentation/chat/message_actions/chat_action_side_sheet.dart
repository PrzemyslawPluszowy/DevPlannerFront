import 'dart:math' as math;

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:flutter/material.dart';

/// Bounded desktop surface for Chat action lists in the root navigator.
class ChatActionSideSheet extends StatelessWidget {
  const ChatActionSideSheet({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final chat = context.chatTheme;
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        width: math.min(480, constraints.maxWidth),
        height: constraints.maxHeight,
        child: Theme(
          data: chat.applyControls(Theme.of(context)),
          child: Material(
            color: chat.panelSurface,
            shape: Border(left: BorderSide(color: chat.separator)),
            clipBehavior: Clip.antiAlias,
            child: child,
          ),
        ),
      ),
    );
  }
}
