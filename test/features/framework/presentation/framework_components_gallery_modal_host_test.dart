import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:ready_next/app/shell/overlay/app_modal_coordinator.dart';
import 'package:ready_next/features/framework/presentation/framework_components_gallery_page.dart';
import 'package:ready_next/l10n/app_localizations.dart';

/// Stabilne klucze chrome'u i aktywatorów testowej trasy galerii.
abstract final class GalleryModalTestKeys {
  static const topBar = ValueKey<String>('gallery-modal-topbar');
  static const rail = ValueKey<String>('gallery-modal-rail');
  static const hugeTableActivator = ValueKey<String>('gallery-huge-activator');
  static const blocActivator = ValueKey<String>('gallery-bloc-activator');
}

/// Rzeczywisty router z root navigatoriem oraz prywatnym child navigatorem.
class _GalleryModalRouterHarness extends StatefulWidget {
  const _GalleryModalRouterHarness();

  @override
  State<_GalleryModalRouterHarness> createState() =>
      _GalleryModalRouterHarnessState();
}

class _GalleryModalRouterHarnessState
    extends State<_GalleryModalRouterHarness> {
  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _privateNavigatorKey =
      GlobalKey<NavigatorState>();
  late final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/framework/components?source=modal-test#preview',
    routes: [
      ShellRoute(
        navigatorKey: _privateNavigatorKey,
        builder: (context, state, child) => _GalleryModalShell(child: child),
        routes: [
          GoRoute(
            path: '/framework/components',
            builder: (context, state) => const _GalleryModalRouteProbe(),
          ),
        ],
      ),
    ],
  );

  String get location => _router.routeInformationProvider.value.uri.toString();

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('pl'),
    routerConfig: _router,
  );
}

/// Prywatny chrome będący właścicielem sesyjnego koordynatora hosta.
class _GalleryModalShell extends StatefulWidget {
  const _GalleryModalShell({required this.child});

  final Widget child;

  @override
  State<_GalleryModalShell> createState() => _GalleryModalShellState();
}

class _GalleryModalShellState extends State<_GalleryModalShell> {
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
        key: GalleryModalTestKeys.topBar,
        title: const Text('Globalny topbar'),
      ),
      body: Row(
        children: [
          Container(
            key: GalleryModalTestKeys.rail,
            color: Colors.indigo,
            width: 72,
          ),
          Expanded(child: widget.child),
        ],
      ),
    ),
  );
}

/// Child private route wywołujący dokładnie publiczne akcje galerii.
class _GalleryModalRouteProbe extends StatefulWidget {
  const _GalleryModalRouteProbe();

  @override
  State<_GalleryModalRouteProbe> createState() =>
      _GalleryModalRouteProbeState();
}

class _GalleryModalRouteProbeState extends State<_GalleryModalRouteProbe> {
  final FocusNode _hugeTableFocus = FocusNode(debugLabel: 'gallery-huge');
  final FocusNode _blocFocus = FocusNode(debugLabel: 'gallery-bloc');

  bool get blocActivatorHasFocus => _blocFocus.hasFocus;

  void openHugeTable() {
    unawaited(FrameworkComponentsGalleryPage.showHugeTablePreview(context));
  }

  void openBlocModal() {
    unawaited(FrameworkComponentsGalleryPage.showBlocModalPreview(context));
  }

  void requestBlocFocus() => _blocFocus.requestFocus();

  @override
  void dispose() {
    _hugeTableFocus.dispose();
    _blocFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          key: GalleryModalTestKeys.hugeTableActivator,
          focusNode: _hugeTableFocus,
          onPressed: openHugeTable,
          child: const Text('Duża tabela'),
        ),
        TextButton(
          key: GalleryModalTestKeys.blocActivator,
          focusNode: _blocFocus,
          onPressed: openBlocModal,
          child: const Text('Modal BLoC'),
        ),
      ],
    ),
  );
}

void main() {
  const location = '/framework/components?source=modal-test#preview';

  Future<_GalleryModalRouterHarnessState> pumpHarness(
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const _GalleryModalRouterHarness());
    await tester.pumpAndSettle();
    return tester.state<_GalleryModalRouterHarnessState>(
      find.byType(_GalleryModalRouterHarness),
    );
  }

  void expectRootBarrierAboveShell(WidgetTester tester) {
    final barrier = tester.getRect(find.byType(ModalBarrier).last);
    expect(
      barrier.contains(
        tester.getCenter(find.byKey(GalleryModalTestKeys.topBar)),
      ),
      isTrue,
    );
    expect(
      barrier.contains(tester.getCenter(find.byKey(GalleryModalTestKeys.rail))),
      isTrue,
    );
  }

  testWidgets('podgląd tabeli galerii zamyka się przez rootową barierę', (
    tester,
  ) async {
    final harness = await pumpHarness(tester);
    tester
        .state<_GalleryModalRouteProbeState>(
          find.byType(_GalleryModalRouteProbe),
        )
        .openHugeTable();
    await tester.pumpAndSettle();

    expect(find.text('Stress Test Table'), findsOneWidget);
    expectRootBarrierAboveShell(tester);
    expect(
      tester.widget<ModalBarrier>(find.byType(ModalBarrier).last).dismissible,
      isTrue,
    );
    expect(await tester.binding.handlePopRoute(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('Stress Test Table'), findsNothing);
    expect(harness.location, location);
  });

  testWidgets('modal BLoC galerii blokuje barierę i Escape zwraca fokus', (
    tester,
  ) async {
    final harness = await pumpHarness(tester);
    final routeState = tester.state<_GalleryModalRouteProbeState>(
      find.byType(_GalleryModalRouteProbe),
    );
    routeState.requestBlocFocus();
    await tester.pump();
    expect(routeState.blocActivatorHasFocus, isTrue);

    routeState.openBlocModal();
    await tester.pumpAndSettle();
    expect(find.text('Nowy dokument'), findsOneWidget);
    expectRootBarrierAboveShell(tester);
    await tester.tapAt(
      tester.getCenter(find.byKey(GalleryModalTestKeys.topBar)),
    );
    await tester.pump();
    expect(find.text('Nowy dokument'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Nowy dokument'), findsNothing);
    expect(routeState.blocActivatorHasFocus, isTrue);
    expect(harness.location, location);
  });
}
