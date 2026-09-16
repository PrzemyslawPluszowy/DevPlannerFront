import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ready_next/app/shell/overlay/app_modal_coordinator.dart';
import 'package:ready_next/app/shell/overlay/app_modal_host.dart';
import 'package:ready_next/shared/presentation/widgets/app_draggable_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';

/// Klucze stabilizujące asercje route'ów i modalnej warstwy testowej.
abstract final class ModalRouterTestKeys {
  /// Prywatna strona routingu zagnieżdżonego.
  static const privatePage = ValueKey<String>('private-modal-page');

  /// Publiczna strona logowania.
  static const loginPage = ValueKey<String>('login-page');

  /// Publiczna strona udostępnionego pliku.
  static const sharedFilePage = ValueKey<String>('shared-file-page');

  /// Akcja działająca w tle prywatnej strony.
  static const backgroundAction = ValueKey<String>('background-action');

  /// Pierwsza kontrolka fokusu modalu.
  static const modalFirstAction = ValueKey<String>('modal-first-action');

  /// Druga kontrolka fokusu modalu.
  static const modalSecondAction = ValueKey<String>('modal-second-action');
}

/// Wariant wspólnego publicznego API, który ma dostać identyczny kontrakt hosta.
enum _ModalApi { dialog, sideSheet, bottomSheet }

/// Teksty nagłówków odróżniające modal każdej publicznej trasy testowej.
abstract final class _ModalRouterTestLabels {
  /// Zwraca widoczny tytuł modalu dla wariantu API.
  static String publicModalTitle(_ModalApi api) => switch (api) {
    _ModalApi.dialog => 'Publiczny dialog',
    _ModalApi.sideSheet => 'Publiczny side sheet',
    _ModalApi.bottomSheet => 'Publiczny bottom sheet',
  };
}

/// GoRouter z trasami publicznymi oraz prywatnym shellem z osobnym navigatoriem.
class _ModalRouterHarness extends StatefulWidget {
  const _ModalRouterHarness({required this.initialLocation});

  final String initialLocation;

  @override
  State<_ModalRouterHarness> createState() => _ModalRouterHarnessState();
}

/// Stan hosta utrzymujący niezależne navigatory root i private shella.
class _ModalRouterHarnessState extends State<_ModalRouterHarness> {
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _privateNavigatorKey =
      GlobalKey<NavigatorState>();
  late final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: widget.initialLocation,
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const _PublicRouteProbe(
          key: ModalRouterTestKeys.loginPage,
          label: 'Logowanie',
        ),
      ),
      GoRoute(
        path: '/storage/public/:shareToken',
        builder: (context, state) => const _PublicRouteProbe(
          key: ModalRouterTestKeys.sharedFilePage,
          label: 'Udostępniony plik',
        ),
      ),
      ShellRoute(
        navigatorKey: _privateNavigatorKey,
        builder: (context, state, child) => _PrivateShell(child: child),
        routes: [
          GoRoute(
            path: '/private/:workspaceId',
            builder: (context, state) => const _PrivateRouteProbe(),
          ),
        ],
      ),
    ],
  );

  /// Bieżący URI, bez odczytywania prywatnego API delegata.
  String get location => _router.routeInformationProvider.value.uri.toString();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: _router,
  );
}

/// Prywatny chrome z geometrią wystarczającą do weryfikacji root bariery.
class _PrivateShell extends StatefulWidget {
  const _PrivateShell({required this.child});

  final Widget child;

  @override
  State<_PrivateShell> createState() => _PrivateShellState();
}

/// Stan prywatnego chrome'u będący właścicielem koordynatora sesyjnych modali.
class _PrivateShellState extends State<_PrivateShell> {
  final AppModalCoordinator _coordinator = AppModalCoordinator();

  @override
  void dispose() {
    _coordinator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppModalCoordinatorScope(
    coordinator: _coordinator,
    child: Scaffold(
      appBar: AppBar(
        key: const ValueKey<String>('shell-topbar'),
        title: const Text('Pasek globalny'),
      ),
      body: Row(
        children: [
          Container(
            key: const ValueKey<String>('shell-rail'),
            color: Colors.indigo,
            width: 72,
          ),
          Expanded(child: widget.child),
        ],
      ),
    ),
  );
}

/// Prywatna trasa udostępniająca API modali i mierzalną akcję tła.
class _PrivateRouteProbe extends StatefulWidget {
  const _PrivateRouteProbe();

  @override
  State<_PrivateRouteProbe> createState() => _PrivateRouteProbeState();
}

/// Stan private child route z kontrolkami focusu i licznikiem hit-testu tła.
class _PrivateRouteProbeState extends State<_PrivateRouteProbe> {
  final FocusNode _originFocus = FocusNode(debugLabel: 'private-origin');
  final FocusNode _firstModalFocus = FocusNode(debugLabel: 'modal-first');
  final FocusNode _secondModalFocus = FocusNode(debugLabel: 'modal-second');
  int backgroundTapCount = 0;

  bool get originHasFocus => _originFocus.hasFocus;
  bool get firstModalHasFocus => _firstModalFocus.hasFocus;
  bool get secondModalHasFocus => _secondModalFocus.hasFocus;

  /// Ustawia fokus aktywatora bez zależności od zachowania wskaźnika platformy testowej.
  void requestOriginFocus() => _originFocus.requestFocus();

  @override
  void dispose() {
    _originFocus.dispose();
    _firstModalFocus.dispose();
    _secondModalFocus.dispose();
    super.dispose();
  }

  /// Otwiera jeden z trzech publicznych adapterów modalnych z poziomu child route.
  void open(_ModalApi api, {String title = 'Modal testowy'}) {
    switch (api) {
      case _ModalApi.dialog:
        unawaited(
          AppModalHost.showDialog<void>(
            context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text(title),
              content: _ModalFocusActions(
                firstFocus: _firstModalFocus,
                secondFocus: _secondModalFocus,
              ),
            ),
          ),
        );
      case _ModalApi.sideSheet:
        unawaited(
          AppModalSheet.showSideSheet<void>(
            context,
            title: title,
            barrierDismissible: false,
            width: 360,
            showCloseButton: false,
            body: _ModalFocusActions(
              firstFocus: _firstModalFocus,
              secondFocus: _secondModalFocus,
            ),
          ),
        );
      case _ModalApi.bottomSheet:
        unawaited(
          AppDraggableSheet.show<void>(
            context,
            title: title,
            barrierDismissible: false,
            minHeight: 220,
            initialHeight: 220,
            maxHeight: 320,
            showCloseButton: false,
            builder: (context, scrollController) => _ModalFocusActions(
              firstFocus: _firstModalFocus,
              secondFocus: _secondModalFocus,
            ),
          ),
        );
    }
  }

  /// Symuluje równoczesne wejścia globalnego czatu i powiadomień.
  void openGlobalPanel(String title) {
    unawaited(
      AppModalHost.showSideSheet<void>(
        context,
        builder: (context) => Align(
          alignment: Alignment.centerRight,
          child: Material(
            child: SizedBox(width: 320, child: Center(child: Text(title))),
          ),
        ),
      ),
    );
  }

  /// Otwiera świadomie lokalny dialog, który nie może przykrywać chrome'u shella.
  void openNestedDialog() {
    unawaited(
      AppModalHost.showDialog<void>(
        context,
        navigatorScope: AppModalNavigatorScope.nested,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          title: Text('Modal lokalnego navigatora'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            key: ModalRouterTestKeys.backgroundAction,
            focusNode: _originFocus,
            onPressed: () => setState(() => backgroundTapCount += 1),
            child: const Text('Akcja tła'),
          ),
        ],
      ),
    ),
  );
}

/// Dwie kontrolki, które pozwalają sprawdzić cykl focusu bez zależności od ikon chrome'u.
class _ModalFocusActions extends StatelessWidget {
  const _ModalFocusActions({
    required this.firstFocus,
    required this.secondFocus,
  });

  final FocusNode firstFocus;
  final FocusNode secondFocus;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      TextButton(
        key: ModalRouterTestKeys.modalFirstAction,
        focusNode: firstFocus,
        autofocus: true,
        onPressed: () {},
        child: const Text('Pierwsza akcja modalu'),
      ),
      TextButton(
        key: ModalRouterTestKeys.modalSecondAction,
        focusNode: secondFocus,
        onPressed: () {},
        child: const Text('Druga akcja modalu'),
      ),
    ],
  );
}

/// Publiczny probe, który świadomie nie dziedziczy prywatnego shellu.
class _PublicRouteProbe extends StatefulWidget {
  const _PublicRouteProbe({required super.key, required this.label});

  final String label;

  @override
  State<_PublicRouteProbe> createState() => _PublicRouteProbeState();
}

/// Stan publicznej trasy uruchamiający trzy publiczne adaptery bez scope shella.
class _PublicRouteProbeState extends State<_PublicRouteProbe> {
  /// Otwiera modal na publicznej trasie; brak koordynatora jest zamierzony.
  void open(_ModalApi api) {
    switch (api) {
      case _ModalApi.dialog:
        unawaited(
          AppModalHost.showDialog<void>(
            context,
            barrierDismissible: false,
            builder: (context) => const AlertDialog(
              title: Text('Publiczny dialog'),
            ),
          ),
        );
      case _ModalApi.sideSheet:
        unawaited(
          AppModalSheet.showSideSheet<void>(
            context,
            title: _ModalRouterTestLabels.publicModalTitle(api),
            barrierDismissible: false,
            showCloseButton: false,
            body: const SizedBox(height: 120),
          ),
        );
      case _ModalApi.bottomSheet:
        unawaited(
          AppDraggableSheet.show<void>(
            context,
            title: _ModalRouterTestLabels.publicModalTitle(api),
            barrierDismissible: false,
            showCloseButton: false,
            minHeight: 180,
            initialHeight: 180,
            maxHeight: 260,
            builder: (context, scrollController) => const SizedBox.expand(),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(widget.label)));
}

void main() {
  for (final api in _ModalApi.values) {
    testWidgets('${api.name}: root barrier zasłania shell i blokuje tło', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1280, 800);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      const location = '/private/alpha?tab=files#comment-7';
      await tester.pumpWidget(
        const _ModalRouterHarness(initialLocation: location),
      );
      await tester.pumpAndSettle();
      final privateState = tester.state<_PrivateRouteProbeState>(
        find.byType(_PrivateRouteProbe),
      );

      privateState.open(api);
      await tester.pumpAndSettle();

      final barrier = tester.getRect(find.byType(ModalBarrier).last);
      final targets = <Finder>[
        find.byKey(const ValueKey<String>('shell-topbar')),
        find.byKey(const ValueKey<String>('shell-rail')),
        find.byKey(ModalRouterTestKeys.backgroundAction),
      ];
      for (final target in targets) {
        expect(barrier.contains(tester.getCenter(target)), isTrue);
      }
      await tester.tap(
        find.byKey(ModalRouterTestKeys.backgroundAction),
        warnIfMissed: false,
      );
      await tester.pump();
      expect(privateState.backgroundTapCount, 0);

      Navigator.of(
        tester.element(find.byType(_PrivateRouteProbe)),
        rootNavigator: true,
      ).pop();
      await tester.pumpAndSettle();
    });

    testWidgets(
      '${api.name}: Escape zamyka modal, cykl focusu i URI pozostają spójne',
      (
        tester,
      ) async {
        const location = '/private/alpha?tab=files#comment-7';
        await tester.pumpWidget(
          const _ModalRouterHarness(initialLocation: location),
        );
        await tester.pumpAndSettle();
        final harness = tester.state<_ModalRouterHarnessState>(
          find.byType(_ModalRouterHarness),
        );
        final privateState = tester.state<_PrivateRouteProbeState>(
          find.byType(_PrivateRouteProbe),
        );
        privateState.requestOriginFocus();
        await tester.pump();
        expect(privateState.originHasFocus, isTrue);
        privateState.open(api);
        await tester.pumpAndSettle();

        expect(privateState.firstModalHasFocus, isTrue);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        expect(privateState.secondModalHasFocus, isTrue);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        expect(privateState.firstModalHasFocus, isTrue);
        await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
        expect(privateState.secondModalHasFocus, isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.byKey(ModalRouterTestKeys.modalFirstAction), findsNothing);
        expect(harness.location, location);
        expect(privateState.originHasFocus, isTrue);
      },
    );
  }

  testWidgets(
    'popRoute zamyka root modal z nested private route bez zmiany URI',
    (
      tester,
    ) async {
      const location = '/private/alpha?tab=files#comment-7';
      await tester.pumpWidget(
        const _ModalRouterHarness(initialLocation: location),
      );
      await tester.pumpAndSettle();
      final harness = tester.state<_ModalRouterHarnessState>(
        find.byType(_ModalRouterHarness),
      );
      tester
          .state<_PrivateRouteProbeState>(find.byType(_PrivateRouteProbe))
          .open(
            _ModalApi.sideSheet,
          );
      await tester.pumpAndSettle();

      expect(await tester.binding.handlePopRoute(), isTrue);
      await tester.pumpAndSettle();
      expect(find.text('Modal testowy'), findsNothing);
      expect(harness.location, location);
    },
  );

  for (final api in _ModalApi.values) {
    testWidgets(
      '${api.name}: login i link udostępnionego pliku otwierają i zamykają modal bez shellu',
      (tester) async {
        for (final scenario in [
          (
            location: '/login?redirect=%2Fprivate%2Falpha',
            key: ModalRouterTestKeys.loginPage,
          ),
          (
            location: '/storage/public/share-1?download=true#preview',
            key: ModalRouterTestKeys.sharedFilePage,
          ),
        ]) {
          await tester.pumpWidget(
            _ModalRouterHarness(initialLocation: scenario.location),
          );
          await tester.pumpAndSettle();
          expect(find.byKey(scenario.key), findsOneWidget);
          expect(find.byType(_PrivateShell), findsNothing);
          final publicState = tester.state<_PublicRouteProbeState>(
            find.byKey(scenario.key),
          );
          publicState.open(api);
          await tester.pumpAndSettle();
          expect(find.byType(ModalBarrier), findsWidgets);
          expect(
            find.text(_ModalRouterTestLabels.publicModalTitle(api)),
            findsOneWidget,
          );
          expect(find.byType(_PrivateShell), findsNothing);
          Navigator.of(
            tester.element(find.byKey(scenario.key)),
            rootNavigator: true,
          ).pop();
          await tester.pumpAndSettle();
          expect(
            find.text(_ModalRouterTestLabels.publicModalTitle(api)),
            findsNothing,
          );
          expect(find.byKey(scenario.key), findsOneWidget);
          await tester.pumpWidget(const SizedBox.shrink());
        }
      },
    );
  }

  testWidgets('nested scope pozostawia topbar i rail ponad lokalnym modalem', (
    tester,
  ) async {
    await tester.pumpWidget(
      const _ModalRouterHarness(initialLocation: '/private/alpha'),
    );
    await tester.pumpAndSettle();
    final privateState = tester.state<_PrivateRouteProbeState>(
      find.byType(_PrivateRouteProbe),
    );
    privateState.openNestedDialog();
    await tester.pumpAndSettle();

    final barrier = tester.getRect(find.byType(ModalBarrier).last);
    expect(
      barrier.contains(
        tester.getCenter(find.byKey(const ValueKey<String>('shell-topbar'))),
      ),
      isFalse,
    );
    expect(
      barrier.contains(
        tester.getCenter(find.byKey(const ValueKey<String>('shell-rail'))),
      ),
      isFalse,
    );
    expect(
      barrier.contains(
        tester.getCenter(find.byKey(ModalRouterTestKeys.backgroundAction)),
      ),
      isTrue,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Modal lokalnego navigatora'), findsNothing);
  });

  testWidgets(
    'czat i powiadomienia nie otwierają dwóch równoległych root overlayów',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        const _ModalRouterHarness(initialLocation: '/private/alpha'),
      );
      await tester.pumpAndSettle();
      final privateState = tester.state<_PrivateRouteProbeState>(
        find.byType(_PrivateRouteProbe),
      );

      privateState.openGlobalPanel('Czat');
      await tester.pumpAndSettle();
      privateState.openGlobalPanel('Powiadomienia');
      await tester.pumpAndSettle();
      expect(find.text('Czat'), findsOneWidget);
      expect(find.text('Powiadomienia'), findsNothing);

      Navigator.of(
        tester.element(find.byType(_PrivateRouteProbe)),
        rootNavigator: true,
      ).pop();
      await tester.pumpAndSettle();
      privateState.openGlobalPanel('Powiadomienia');
      await tester.pumpAndSettle();
      privateState.openGlobalPanel('Czat');
      await tester.pumpAndSettle();
      expect(find.text('Powiadomienia'), findsOneWidget);
      expect(find.text('Czat'), findsNothing);
    },
  );
}
