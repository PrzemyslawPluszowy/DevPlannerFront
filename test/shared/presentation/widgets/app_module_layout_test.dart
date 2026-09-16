import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/shared/presentation/widgets/app_collapsible_navigation.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_lauout/app_module_layout.dart';

void main() {
  testWidgets(
    'compact układa treść na pełnej szerokości i otwiera sidebar jako overlay',
    (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SizedBox(
            width: 520,
            height: 420,
            child: AppModuleLayout(
              compactBreakpoint: 1000,
              scrollContent: false,
              sidebarBuilder: _sidebar,
              contentBuilder: _content,
            ),
          ),
        ),
      );

      expect(find.text('Menu boczne'), findsNothing);
      expect(find.text('Treść'), findsOneWidget);
      expect(tester.getTopLeft(find.text('Treść')).dy, greaterThanOrEqualTo(0));

      await tester.tap(find.byTooltip('Otwórz menu'));
      await tester.pumpAndSettle();

      expect(find.text('Menu boczne'), findsOneWidget);
      expect(find.byTooltip('Zamknij menu'), findsOneWidget);
      expect(tester.getSize(find.text('Treść')).width, greaterThan(0));

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Menu boczne'), findsNothing);
    },
  );

  testWidgets(
    'desktop animuje warstwę contentu bez relayoutu w każdej klatce',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1400, 800);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      final controller = AppCollapsibleNavigationController();
      addTearDown(controller.dispose);
      final contentWidths = <double>[];

      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            width: 1400,
            height: 800,
            child: AppModuleLayout(
              navigationController: controller,
              navigationExpandedWidth: 240,
              navigationCollapsedWidth: 64,
              scrollContent: false,
              sidebarBuilder: (context, isCompact, padding) =>
                  AppCollapsibleNavigationPanel(
                    controller: controller,
                    expandedWidth: 240,
                    collapsedWidth: 64,
                    margin: EdgeInsets.only(right: padding),
                    expandedBuilder: (_) => const Text('Pełne menu'),
                    collapsedBuilder: (_) => const Text('Ikony'),
                  ),
              contentBuilder: (context, isCompact, padding) => LayoutBuilder(
                builder: (context, constraints) {
                  contentWidths.add(constraints.maxWidth);
                  return const ColoredBox(
                    key: ValueKey('composited-content'),
                    color: Colors.blue,
                  );
                },
              ),
            ),
          ),
        ),
      );

      final initialLeft = tester
          .getTopLeft(find.byKey(const ValueKey('composited-content')))
          .dx;
      expect(
        tester.getTopLeft(find.byKey(const ValueKey('composited-content'))).dy,
        lessThan(30),
      );
      controller.collapse();
      await tester.pump();
      final layoutsAfterStateChange = contentWidths.length;

      await tester.pump(const Duration(milliseconds: 80));
      final animatedLeft = tester
          .getTopLeft(find.byKey(const ValueKey('composited-content')))
          .dx;
      await tester.pump(const Duration(milliseconds: 80));

      expect(contentWidths.length, layoutsAfterStateChange);
      // Szerokość pozostaje stała; zwijanie przesuwa composited layer.
      expect(contentWidths.toSet(), hasLength(1));
      expect(animatedLeft, lessThan(initialLeft));

      await tester.pumpAndSettle();
      final collapsedLeft = tester
          .getTopLeft(find.byKey(const ValueKey('composited-content')))
          .dx;
      expect(collapsedLeft, lessThanOrEqualTo(animatedLeft));
    },
  );

  testWidgets('reaguje na zmianę szerokości viewportu bez overflowu', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1400, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final controller = AppCollapsibleNavigationController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox.expand(
          child: AppModuleLayout(
            navigationController: controller,
            compactBreakpoint: 900,
            navigationExpandedWidth: 240,
            navigationCollapsedWidth: 64,
            scrollContent: false,
            sidebarBuilder: (context, isCompact, padding) =>
                AppCollapsibleNavigationPanel(
                  controller: controller,
                  expandedWidth: 240,
                  collapsedWidth: 64,
                  margin: EdgeInsets.only(right: padding),
                  expandedBuilder: (_) => const Text('Pełne menu'),
                  collapsedBuilder: (_) => const Text('Ikony'),
                ),
            contentBuilder: (context, isCompact, padding) => const ColoredBox(
              key: ValueKey('resize-content'),
              color: Colors.blue,
              child: SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
    expect(find.byKey(const ValueKey('resize-content')), findsOneWidget);

    tester.view.physicalSize = const Size(700, 800);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('resize-content')), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(1280, 800);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('resize-content')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _sidebar(BuildContext context, bool isCompact, double padding) =>
    const Center(child: Text('Menu boczne'));

Widget _content(BuildContext context, bool isCompact, double padding) =>
    const SizedBox.expand(child: Center(child: Text('Treść')));
