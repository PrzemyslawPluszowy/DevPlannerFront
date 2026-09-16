import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wspólna granica dostępności dla modalnych drawerów i side sheetów.
///
/// Przenosi fokus do panelu po otwarciu, ogranicza przechodzenie Tabem do
/// elementów panelu i zamyka go klawiszem Escape. Kliknięcie poza panelem
/// pozostaje obsługą bariery `showGeneralDialog`.
class AppModalAccessibilityBoundary extends StatelessWidget {
  const AppModalAccessibilityBoundary({
    required this.child,
    required this.onDismiss,
    super.key,
  });

  final Widget child;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => CallbackShortcuts(
    bindings: <ShortcutActivator, VoidCallback>{
      const SingleActivator(LogicalKeyboardKey.escape): onDismiss,
    },
    child: FocusScope(
      autofocus: true,
      canRequestFocus: true,
      child: FocusTraversalGroup(
        policy: ReadingOrderTraversalPolicy(),
        child: child,
      ),
    ),
  );
}
