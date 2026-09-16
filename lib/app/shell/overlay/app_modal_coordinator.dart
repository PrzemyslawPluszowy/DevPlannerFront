import 'package:flutter/material.dart';

/// Lokalna dla sesji polityka jednego aktywnego systemowego panelu.
///
/// Nie jest globalnym singletonem i nie przechowuje danych biznesowych. Jej
/// lifecycle należy do `AppGlobalShell`, więc po wylogowaniu wszystkie locki
/// znikają razem z shellem.
class AppModalCoordinator extends ChangeNotifier {
  bool _isPresenting = false;

  /// Czy route modalny jest aktualnie aktywny w tej sesji shellu.
  bool get isPresenting => _isPresenting;

  /// Rezerwuje jedyny slot; drugi równoległy request jest jawnie odrzucany.
  bool tryAcquire() {
    if (_isPresenting) return false;
    _isPresenting = true;
    notifyListeners();
    return true;
  }

  /// Zwrot slotu po zamknięciu route'u.
  void release() {
    if (!_isPresenting) return;
    _isPresenting = false;
    notifyListeners();
  }
}

/// Udostępnia lokalny koordynator tylko potomkom prywatnego shellu.
class AppModalCoordinatorScope extends InheritedNotifier<AppModalCoordinator> {
  const AppModalCoordinatorScope({
    required AppModalCoordinator coordinator,
    required super.child,
    super.key,
  }) : super(notifier: coordinator);

  /// Odczytuje koordynator wtedy, gdy route jest pod prywatnym shellem.
  static AppModalCoordinator? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppModalCoordinatorScope>()
        ?.notifier;
  }
}
