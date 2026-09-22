import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/app/shell/overlays/devplanner_global_panels_host.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/presentation/devplanner_panels.dart';
import 'package:devplanner/workspaces/presentation/chat/shell/layout/chat_panel_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Regression test for R03.
///
/// W aplikacji host paneli jest montowany w `MaterialApp.router(builder:)`,
/// czyli **nad** routerem, a panel jest rodzeństwem aktywnej trasy. Panel nie
/// ma wtedy przodka `Navigator`: `showDialog` z panelu rzuca „no Navigator”
/// (kreator się nie otwiera), a modal rootowy otwarty z trasy renderuje się
/// pod panelem i jego barrier zjada kliknięcia. Drzewo w testach odwzorowuje
/// dokładnie ten kształt — inaczej test nie rozstrzyga niczego.
void main() {
  Future<GoRouter> pumpHostWithPanel(
    WidgetTester tester, {
    required Widget Function(BuildContext context) routeContent,
  }) async {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (context, _) => routeContent(context)),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) => DevPlannerGlobalPanelsHost(
          navigation: DevPlannerNavigation(router),
          child: child ?? const SizedBox.shrink(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  // Powierzchnia panelu istnieje w obu trybach; barrier tylko w compact.
  // Powierzchnia panelu istnieje w obu trybach; barrier tylko w compact.
  Finder panelSurface() =>
      find.byKey(const ValueKey('devplanner-panel-surface'));
  Finder panelBarrier() =>
      find.byKey(const ValueKey('devplanner-panel-barrier'));

  testWidgets(
    'panel nie ma przodka Navigator, a i tak otwiera modal nad sobą',
    (
      tester,
    ) async {
      var confirmed = false;
      await pumpHostWithPanel(
        tester,
        routeContent: (context) => TextButton(
          key: const ValueKey('open-panel'),
          onPressed: DevPlannerPanelsScope.controllerOf(context)!.showChat,
          child: const Text('Otwórz czat'),
        ),
      );

      await tester.tap(find.byKey(const ValueKey('open-panel')));
      await tester.pumpAndSettle();
      expect(panelSurface(), findsOneWidget);

      final panelContext = tester.element(panelSurface());
      final dialog = DevPlannerModalHost.showDialog<bool>(
        panelContext,
        builder: (context) => AlertDialog(
          content: const Text('Treść kreatora'),
          actions: [
            TextButton(
              onPressed: () {
                confirmed = true;
                Navigator.of(context).pop(true);
              },
              child: const Text('Potwierdź'),
            ),
          ],
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Treść kreatora'), findsOneWidget);

      // Akcja modala jest nad panelem: gdyby panel był wyżej, hit-test trafiłby
      // w jego barrier i zamknął panel.
      await tester.tap(find.text('Potwierdź'));
      await tester.pumpAndSettle();

      expect(confirmed, isTrue);
      expect(
        panelSurface(),
        findsOneWidget,
        reason: 'modal jest nad panelem, więc jego akcja nie zamyka panelu',
      );
      expect(await dialog, isTrue);
    },
  );

  testWidgets('back systemowy zamyka modal warstwy, nie trasę', (tester) async {
    await pumpHostWithPanel(
      tester,
      routeContent: (context) => TextButton(
        key: const ValueKey('open-panel'),
        onPressed: DevPlannerPanelsScope.controllerOf(context)!.showChat,
        child: const Text('Otwórz czat'),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-panel')));
    await tester.pumpAndSettle();
    unawaited(
      DevPlannerModalHost.showDialog<void>(
        tester.element(panelSurface()),
        builder: (context) => const AlertDialog(content: Text('Modal warstwy')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Modal warstwy'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Modal warstwy'), findsNothing);
    expect(
      panelSurface(),
      findsOneWidget,
      reason: 'back zamyka modal, nie panel ani trasę',
    );
  });

  testWidgets('Escape zamyka najpierw modal, a panel dopiero potem', (
    tester,
  ) async {
    await pumpHostWithPanel(
      tester,
      routeContent: (context) => TextButton(
        key: const ValueKey('open-panel'),
        onPressed: DevPlannerPanelsScope.controllerOf(context)!.showChat,
        child: const Text('Otwórz czat'),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-panel')));
    await tester.pumpAndSettle();
    unawaited(
      DevPlannerModalHost.showDialog<void>(
        tester.element(panelSurface()),
        builder: (context) => const AlertDialog(content: Text('Modal warstwy')),
      ),
    );
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Modal warstwy'), findsNothing);
    expect(
      panelSurface(),
      findsOneWidget,
      reason: 'Escape zamknął tylko modal',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(panelSurface(), findsNothing, reason: 'drugi Escape zamyka panel');
  });

  testWidgets('panel startuje z 30% okna i nie blokuje aplikacji', (
    tester,
  ) async {
    // Desktop: panel jest wąskim panelem obok aplikacji, więc nie przyciemnia
    // ani nie blokuje treści — inaczej nie da się pracować przy otwartym czacie.
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    var appClicks = 0;
    await pumpHostWithPanel(
      tester,
      routeContent: (context) => Row(
        children: [
          TextButton(
            key: const ValueKey('open-panel'),
            onPressed: DevPlannerPanelsScope.controllerOf(context)!.showChat,
            child: const Text('Otwórz czat'),
          ),
          TextButton(
            key: const ValueKey('app-action'),
            onPressed: () => appClicks++,
            child: const Text('Akcja aplikacji'),
          ),
        ],
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-panel')));
    await tester.pumpAndSettle();

    expect(
      panelBarrier(),
      findsNothing,
      reason: 'szerokie okno jest niemodalne',
    );
    expect(
      tester.getSize(panelSurface()).width,
      moreOrLessEquals(
        1400 * ChatPanelSizeController.defaultWidthFraction -
            ChatPanelSizeController.resizeHandleWidth,
        epsilon: 1,
      ),
      reason: 'panel startuje z około 30% szerokości okna',
    );

    await tester.tap(find.byKey(const ValueKey('app-action')));
    await tester.pumpAndSettle();
    expect(appClicks, 1, reason: 'panel nie blokuje aplikacji');
  });

  testWidgets('ponowne naciśnięcie przycisku chowa panel', (tester) async {
    await pumpHostWithPanel(
      tester,
      routeContent: (context) => TextButton(
        key: const ValueKey('toggle-panel'),
        onPressed: DevPlannerPanelsScope.controllerOf(context)!.toggleChat,
        child: const Text('Czat'),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('toggle-panel')));
    await tester.pumpAndSettle();
    expect(panelSurface(), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('toggle-panel')));
    await tester.pumpAndSettle();
    expect(
      panelSurface(),
      findsNothing,
      reason: 'przycisk w belce działa jak przełącznik',
    );
  });

  testWidgets('Escape chowa panel także wtedy, gdy focus jest w aplikacji', (
    tester,
  ) async {
    await pumpHostWithPanel(
      tester,
      routeContent: (context) => Row(
        children: [
          TextButton(
            key: const ValueKey('open-panel'),
            onPressed: DevPlannerPanelsScope.controllerOf(context)!.showChat,
            child: const Text('Otwórz czat'),
          ),
          TextButton(
            key: const ValueKey('app-action'),
            onPressed: () {},
            child: const Text('Akcja aplikacji'),
          ),
        ],
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-panel')));
    await tester.pumpAndSettle();
    expect(panelSurface(), findsOneWidget);

    // Klik w treści aplikacji przenosi focus poza panel; wtedy Escape musi
    // nadal zamykać panel, inaczej nie da się go zamknąć klawiaturą.
    await tester.tap(find.byKey(const ValueKey('app-action')));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(panelSurface(), findsNothing);
  });

  testWidgets('przeciągnięcie uchwytu poza minimum zwija panel animacją', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpHostWithPanel(
      tester,
      routeContent: (context) => TextButton(
        key: const ValueKey('open-panel'),
        onPressed: DevPlannerPanelsScope.controllerOf(context)!.showChat,
        child: const Text('Otwórz czat'),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-panel')));
    await tester.pumpAndSettle();
    final handle = find.byKey(
      const ValueKey('devplanner-panel-resize-handle'),
    );
    expect(handle, findsOneWidget);

    // Uchwyt jest na lewej krawędzi, więc zwężanie to ruch w prawo. Pierwszy
    // ruch zjada slop gestu, drugi trafia do uchwytu: 300 px z 420 px przechodzi
    // przez minimum 320 px i zbiera ponad 70 px nadwyżki (5% szerokości okna).
    final gesture = await tester.startGesture(tester.getCenter(handle));
    await gesture.moveBy(const Offset(60, 0));
    await gesture.moveBy(const Offset(300, 0));
    await gesture.up();
    await tester.pump();
    expect(
      panelSurface(),
      findsOneWidget,
      reason: 'w trakcie animacji zwijania panel jeszcze jest widoczny',
    );

    await tester.pumpAndSettle();
    expect(panelSurface(), findsNothing, reason: 'gest zwija panel');
  });

  testWidgets('krótkie przeciągnięcie uchwytu nie zamyka panelu', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpHostWithPanel(
      tester,
      routeContent: (context) => TextButton(
        key: const ValueKey('open-panel'),
        onPressed: DevPlannerPanelsScope.controllerOf(context)!.showChat,
        child: const Text('Otwórz czat'),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-panel')));
    await tester.pumpAndSettle();
    final handle = find.byKey(
      const ValueKey('devplanner-panel-resize-handle'),
    );

    // Zwężenie o 40 px to jeszcze nie próg zwinięcia (5% z 1400 = 70 px).
    final gesture = await tester.startGesture(tester.getCenter(handle));
    await gesture.moveBy(const Offset(60, 0));
    await gesture.moveBy(const Offset(40, 0));
    await gesture.up();
    await tester.pumpAndSettle();

    expect(panelSurface(), findsOneWidget);
    expect(
      tester.getSize(panelSurface()).width,
      moreOrLessEquals(
        420 - 40 - ChatPanelSizeController.resizeHandleWidth,
        epsilon: 1,
      ),
      reason: 'szerokość podąża za uchwytem',
    );
  });

  testWidgets('compact panel jest modalnym arkuszem na całą szerokość', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(520, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await pumpHostWithPanel(
      tester,
      routeContent: (context) => TextButton(
        key: const ValueKey('open-panel'),
        onPressed: DevPlannerPanelsScope.controllerOf(context)!.showChat,
        child: const Text('Otwórz czat'),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('open-panel')));
    await tester.pumpAndSettle();

    expect(panelBarrier(), findsOneWidget);
    expect(
      tester.getSize(panelSurface()).width,
      520,
      reason: 'na compact panel zajmuje całą dostępną szerokość',
    );

    // Arkusz zajmuje całą przestrzeń roboczą, więc zamyka go Escape albo
    // przycisk zamknięcia — tap poza panelem nie ma gdzie trafić.
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(panelSurface(), findsNothing, reason: 'Escape zamyka arkusz');
  });
}
