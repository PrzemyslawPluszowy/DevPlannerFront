import 'package:flutter/widgets.dart';

/// Owns mounted root routes so stale modal generations can be removed safely.
final class TaskDetailModalRouteReferences {
  ModalRoute<dynamic>? _dialog;
  ModalRoute<dynamic>? _confirmation;

  void captureDialog(ModalRoute<dynamic>? route, {required bool accepted}) {
    if (route == null) return;
    if (!accepted) {
      _remove(route);
      return;
    }
    _dialog = route;
  }

  void captureConfirmation(
    ModalRoute<dynamic>? route, {
    required bool accepted,
  }) {
    if (route == null) return;
    if (!accepted) {
      _remove(route);
      return;
    }
    _confirmation = route;
  }

  void removeDialog() {
    final route = _dialog;
    _dialog = null;
    if (route != null) _remove(route);
  }

  void removeConfirmation() {
    final route = _confirmation;
    _confirmation = null;
    if (route != null) _remove(route);
  }

  void dispose() {
    removeDialog();
    removeConfirmation();
  }

  void _remove(ModalRoute<dynamic> route) {
    final navigator = route.navigator;
    if (route.isActive && navigator != null) navigator.removeRoute(route);
  }
}
