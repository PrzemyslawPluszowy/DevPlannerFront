import 'package:flutter/material.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu.dart';

typedef DashboardWidgetContextMenuActionsBuilder =
    List<AppContextMenuAction> Function(BuildContext context);

/// Kontroler akcji nagłówka widgetu dashboardu.
///
/// Pozwala widgetowi podrzędnemu zarejestrować dodatkowe akcje,
/// które ma pokazać wrapper pulpitu obok menu z trzema kropkami.
class DashboardWidgetHeaderActionController extends ChangeNotifier {
  VoidCallback? _refreshAction;
  DashboardWidgetContextMenuActionsBuilder? _contextMenuActionsBuilder;

  /// Czy widget ma zarejestrowaną akcję odświeżenia.
  bool get hasRefreshAction => _refreshAction != null;

  /// Akcja odświeżenia udostępniona przez widget.
  VoidCallback? get refreshAction => _refreshAction;

  /// Czy widget udostępnia własne akcje menu kontekstowego.
  bool get hasContextMenuActions => _contextMenuActionsBuilder != null;

  /// Zwraca akcje menu kontekstowego zbudowane dla bieżącego kontekstu.
  List<AppContextMenuAction> contextMenuActions(BuildContext context) {
    return _contextMenuActionsBuilder?.call(context) ?? const [];
  }

  /// Rejestruje akcję odświeżenia widoczną w nagłówku widgetu.
  void setRefreshAction(VoidCallback? action) {
    if (identical(_refreshAction, action)) {
      return;
    }

    _refreshAction = action;
    notifyListeners();
  }

  /// Rejestruje własne akcje menu kontekstowego widgetu.
  void setContextMenuActionsBuilder(
    DashboardWidgetContextMenuActionsBuilder? builder,
  ) {
    if (identical(_contextMenuActionsBuilder, builder)) {
      return;
    }

    _contextMenuActionsBuilder = builder;
    notifyListeners();
  }
}

/// Scope udostępniający akcje nagłówka widgetu dla potomków wrappera.
class DashboardWidgetHeaderActionScope extends InheritedWidget {
  /// Tworzy scope akcji nagłówka widgetu.
  const DashboardWidgetHeaderActionScope({
    required this.controller,
    required super.child,
    super.key,
  });

  /// Kontroler akcji nagłówka.
  final DashboardWidgetHeaderActionController controller;

  /// Zwraca kontroler akcji nagłówka lub `null`, jeśli scope nie istnieje.
  static DashboardWidgetHeaderActionController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DashboardWidgetHeaderActionScope>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(
    covariant DashboardWidgetHeaderActionScope oldWidget,
  ) {
    return oldWidget.controller != controller;
  }
}
