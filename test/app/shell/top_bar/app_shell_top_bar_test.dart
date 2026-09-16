import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/app/shell/app_shell_metrics.dart';
import 'package:ready_next/app/shell/top_bar/top_bar_export.dart';
import 'package:ready_next/core/auth/auth_models.dart';
import 'package:ready_next/core/auth/auth_repository.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/shared/presentation/widgets/app_global_utility_bar.dart';

/// Minimalne źródło sesji potrzebne wyłącznie do utworzenia routera w teście UI.
class _TopBarAuthRepository implements AuthRepository {
  @override
  String? get accessToken => null;

  @override
  AuthUser? get currentUser => null;

  @override
  bool get isAuthenticated => false;

  @override
  int get sessionGeneration => 0;

  @override
  Future<void> login({
    required String username,
    required String password,
  }) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> restoreSession() async {}

  @override
  Future<bool> tryRefreshSession() async => false;
}

/// Host izolujący geometrię belki od pełnego grafu zależności aplikacji.
class _TopBarHarness extends StatefulWidget {
  const _TopBarHarness({
    required this.brightness,
    required this.textScale,
  });

  final Brightness brightness;
  final double textScale;

  @override
  State<_TopBarHarness> createState() => _TopBarHarnessState();
}

class _TopBarHarnessState extends State<_TopBarHarness> {
  late final AppRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter(
      authRepository: _TopBarAuthRepository(),
      ensureSessionRestored: () async {},
    );
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      theme: ThemeData(
        useMaterial3: true,
        brightness: widget.brightness,
        colorSchemeSeed: const Color(0xff6366f1),
        extensions: const [AppShellMetrics.standard()],
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(widget.textScale)),
          child: Scaffold(body: AppShellTopBar(router: _router, topInset: 0)),
        ),
      ),
    );
  }
}

void main() {
  group('AppShellTopBar — snapshot geometrii responsywnej', () {
    for (final scenario in [
      (name: 'desktop jasny', width: 1280.0, brightness: Brightness.light),
      (name: 'desktop ciemny', width: 1280.0, brightness: Brightness.dark),
      (name: 'medium jasny', width: 800.0, brightness: Brightness.light),
      (name: 'medium ciemny', width: 800.0, brightness: Brightness.dark),
      (name: 'compact jasny', width: 390.0, brightness: Brightness.light),
      (name: 'compact ciemny', width: 390.0, brightness: Brightness.dark),
    ]) {
      for (final textScale in [1.0, 1.3, 1.5]) {
        testWidgets('${scenario.name}, skala $textScale nie ma overflow', (
          tester,
        ) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(scenario.width, 160);
          addTearDown(tester.view.resetDevicePixelRatio);
          addTearDown(tester.view.resetPhysicalSize);

          await tester.pumpWidget(
            _TopBarHarness(
              brightness: scenario.brightness,
              textScale: textScale,
            ),
          );
          await tester.pumpAndSettle();

          final metrics = AppShellMetrics.of(
            tester.element(find.byType(AppShellTopBar)),
          );
          final topBarRect = tester.getRect(find.byType(AppShellTopBar));
          expect(topBarRect.height, metrics.topBarSlotHeight);
          final notificationsButton = find.ancestor(
            of: find.byIcon(AppIcons.notifications),
            matching: find.byType(IconButton),
          );
          final chatButton = find.ancestor(
            of: find.byIcon(AppIcons.chat),
            matching: find.byType(IconButton),
          );
          for (final action in [notificationsButton, chatButton]) {
            final actionRect = tester.getRect(action);
            final button = tester.widget<IconButton>(action);
            expect(button.onPressed, isNotNull);
            expect(actionRect.left, greaterThanOrEqualTo(0));
            expect(actionRect.right, lessThanOrEqualTo(scenario.width));
          }
          expect(tester.takeException(), isNull);
          expect(find.byType(IconButton), findsNWidgets(2));
        });
      }
    }

    for (final scenario in [
      (width: 599.0, expected: AppShellViewport.compact),
      (width: 600.0, expected: AppShellViewport.medium),
      (width: 601.0, expected: AppShellViewport.medium),
      (width: 1023.0, expected: AppShellViewport.medium),
      (width: 1024.0, expected: AppShellViewport.wide),
      (width: 1025.0, expected: AppShellViewport.wide),
    ]) {
      testWidgets(
        'renderuje ${scenario.expected.name} dla viewportu ${scenario.width}',
        (tester) async {
          tester.view.devicePixelRatio = 1;
          tester.view.physicalSize = Size(scenario.width, 160);
          addTearDown(tester.view.resetDevicePixelRatio);
          addTearDown(tester.view.resetPhysicalSize);

          await tester.pumpWidget(
            const _TopBarHarness(
              brightness: Brightness.light,
              textScale: 1,
            ),
          );
          await tester.pumpAndSettle();

          final breadcrumb = tester.widget<AppShellTopBarBreadcrumb>(
            find.byType(AppShellTopBarBreadcrumb),
          );
          expect(breadcrumb.viewport, scenario.expected);
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('token opisuje te same progi co renderowany viewport', (
      tester,
    ) async {
      const metrics = AppShellMetrics.standard();
      expect(
        metrics.viewportFor(metrics.compactBreakpoint - 1),
        AppShellViewport.compact,
      );
      expect(
        metrics.viewportFor(metrics.compactBreakpoint),
        AppShellViewport.medium,
      );
      expect(
        metrics.viewportFor(metrics.compactBreakpoint + 1),
        AppShellViewport.medium,
      );
      expect(
        metrics.viewportFor(metrics.wideBreakpoint - 1),
        AppShellViewport.medium,
      );
      expect(
        metrics.viewportFor(metrics.wideBreakpoint),
        AppShellViewport.wide,
      );
      expect(
        metrics.viewportFor(metrics.wideBreakpoint + 1),
        AppShellViewport.wide,
      );
    });

    testWidgets('compatibility capsule command palette jest disabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: AppGlobalSearchCapsule()),
        ),
      );

      expect(find.byType(InkWell), findsNothing);
      final disabledCapsule = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.enabled == false,
      );
      expect(disabledCapsule, findsOneWidget);
      expect(
        find.text('Global search is coming soon'),
        findsOneWidget,
      );
    });
  });
}
