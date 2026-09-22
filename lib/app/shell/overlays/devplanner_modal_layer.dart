import 'package:flutter/material.dart';

/// Nazwa trasy-stojaka warstwy modali; na niej leży cała aplikacja z panelem.
const String kDevPlannerAppRootRouteName = '/app';

/// Warstwa modali nad panelem globalnym.
///
/// Host paneli jest montowany nad routerem, a panel jest rodzeństwem aktywnej
/// trasy, więc panel **nie ma przodka `Navigator`**: `showDialog` wywołany z
/// panelu rzuca wyjątek „no Navigator”, a modal rootowy otwarty z trasy
/// renderuje się pod panelem. Warstwa jest własnym `Navigator`em, którego
/// trasa-stojak zawiera aplikację razem z panelem — dlatego każdy modal
/// otwarty z panelu trafia do tego samego stosu i maluje się nad panelem,
/// z własnym barrierem, focusem i Escape z semantyki tras.
///
/// Kontrakt warstwy:
/// - Escape: najpierw modal (`barrierDismissible` trasy modala), potem panel
///   (skrót panelu działa tylko wtedy, gdy focus jest w jego poddrzewie).
/// - Back systemowy: `didPopRoute` hosta zamyka modal przed zmianą trasy.
/// - Focus: modal przejmuje focus i oddaje go trasie pod spodem po zamknięciu.
final class DevPlannerModalLayer extends StatelessWidget {
  const DevPlannerModalLayer({
    required this.navigatorKey,
    required this.content,
    super.key,
  });

  /// Klucz do stosu warstwy; host używa go w obsłudze backu systemowego.
  final GlobalKey<NavigatorState> navigatorKey;

  /// Aplikacja razem z panelem — zawartość trasy-stojaka.
  final Widget content;

  @override
  Widget build(BuildContext context) => _DevPlannerAppContentScope(
    content: content,
    child: Navigator(
      key: navigatorKey,
      // Trasa-stojak czyta treść z zakresu powyżej `Navigator`a, więc host może
      // przebudowywać aplikację bez odtwarzania trasy (inaczej trzymałaby
      // pierwszy, nieaktualny widget).
      onGenerateRoute: (settings) => PageRouteBuilder<void>(
        settings: settings,
        pageBuilder: (context, _, _) => const _DevPlannerAppRoot(),
      ),
    ),
  );
}

final class _DevPlannerAppRoot extends StatelessWidget {
  const _DevPlannerAppRoot();

  @override
  Widget build(BuildContext context) =>
      _DevPlannerAppContentScope.of(context).content;
}

/// Zakres z aktualną treścią trasy-stojaka; zależność od niego przebudowuje
/// aplikację w miejscu, bez wymiany samej trasy i bez utraty stanu.
final class _DevPlannerAppContentScope extends InheritedWidget {
  const _DevPlannerAppContentScope({
    required this.content,
    required super.child,
  });

  final Widget content;

  static _DevPlannerAppContentScope of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_DevPlannerAppContentScope>();
    assert(scope != null, 'Warstwa modali wymaga treści trasy-stojaka.');
    return scope!;
  }

  @override
  bool updateShouldNotify(_DevPlannerAppContentScope oldWidget) =>
      !identical(content, oldWidget.content);
}
