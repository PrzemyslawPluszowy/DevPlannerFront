import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/shared/presentation/widgets/app_collapsible_navigation.dart';

void main() {
  test('kontroler wywołuje callback tylko po realnej zmianie', () {
    final changes = <bool>[];
    final controller = AppCollapsibleNavigationController(
      onChanged: changes.add,
    );
    addTearDown(controller.dispose);

    controller.expand();
    controller.collapse();
    controller.collapse();
    controller.toggle();

    expect(changes, [false, true]);
  });

  testWidgets('panel animuje się pomiędzy pełną i zwiniętą szerokością', (
    tester,
  ) async {
    final controller = AppCollapsibleNavigationController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: AppCollapsibleNavigationPanel(
            controller: controller,
            expandedBuilder: (_) => const Text('Pełne menu'),
            collapsedBuilder: (_) => const Text('Ikony'),
            expandedWidth: 240,
            collapsedWidth: 64,
          ),
        ),
      ),
    );

    expect(find.text('Pełne menu'), findsOneWidget);
    expect(find.text('Ikony'), findsNothing);
    expect(
      tester.getSize(find.byType(AppCollapsibleNavigationPanel)).width,
      240,
    );

    controller.collapse();
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(AppCollapsibleNavigationPanel)).width,
      64,
    );
    expect(find.text('Pełne menu'), findsNothing);
    expect(find.text('Ikony'), findsOneWidget);
  });

  testWidgets('Expansible pokazuje i ukrywa podmenu przez chevron', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppExpansibleNavigationItem(
          label: 'Workspace',
          icon: Icons.workspaces_outlined,
          hasChildren: true,
          body: Text('Projekty'),
        ),
      ),
    );

    expect(find.text('Projekty'), findsNothing);
    expect(find.byTooltip('Rozwiń'), findsOneWidget);

    await tester.tap(find.byTooltip('Rozwiń'));
    await tester.pumpAndSettle();
    expect(find.text('Projekty'), findsOneWidget);
    expect(find.byTooltip('Zwiń'), findsOneWidget);
  });

  testWidgets('kontrolowany element rozwija wyłącznie aktywny workspace', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Column(
          children: [
            AppExpansibleNavigationItem(
              label: 'Nieaktywny',
              icon: Icons.workspaces_outlined,
              hasChildren: true,
              expanded: false,
              body: Text('Ukryte dzieci'),
            ),
            AppExpansibleNavigationItem(
              label: 'Aktywny',
              icon: Icons.workspaces_outlined,
              hasChildren: true,
              expanded: true,
              body: Text('Widoczne dzieci'),
            ),
          ],
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Ukryte dzieci'), findsNothing);
    expect(find.text('Widoczne dzieci'), findsOneWidget);
    expect(find.byTooltip('Aktywny workspace rozwija podmenu'), findsOneWidget);

    await tester.tap(find.byTooltip('Aktywny workspace rozwija podmenu'));
    await tester.pump();
    expect(find.text('Ukryte dzieci'), findsNothing);
  });

  testWidgets('ArrowRight i ArrowLeft sterują hierarchią z klawiatury', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AppExpansibleNavigationItem(
          label: 'Workspace',
          icon: Icons.workspaces_outlined,
          hasChildren: true,
          body: Text('Projekty'),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('Projekty'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(find.text('Projekty'), findsNothing);
  });
}
