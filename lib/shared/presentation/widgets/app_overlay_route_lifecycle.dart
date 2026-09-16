import 'package:flutter/material.dart';

/// Sygnał zmiany trasy dla lokalnych, zakotwiczonych overlayów.
///
/// Właściciel lifetime'u (obecnie private shell) przekazuje go przez scope,
/// dzięki czemu wspólny widget nie zależy od konkretnego routera.
class AppOverlayRouteLifecycle extends ChangeNotifier {
  /// Informuje lokalne overlaye, że ich kotwice nie są już wiarygodne.
  void didChangeRoute() => notifyListeners();
}

/// Udostępnia lifecycle tras wyłącznie potomkom aktualnego ownera UI.
class AppOverlayRouteLifecycleScope
    extends InheritedNotifier<AppOverlayRouteLifecycle> {
  const AppOverlayRouteLifecycleScope({
    required AppOverlayRouteLifecycle lifecycle,
    required super.child,
    super.key,
  }) : super(notifier: lifecycle);

  /// Zwraca lifecycle dla widgetu, gdy owner udostępnił go w drzewie.
  static AppOverlayRouteLifecycle? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppOverlayRouteLifecycleScope>()
        ?.notifier;
  }
}
