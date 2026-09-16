import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/shared/presentation/widgets/app_expandable_side_sheet.dart';

void main() {
  testWidgets('otwiera, rozszerza i zamyka desktopowy panel boczny', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () => AppExpandableSideSheet.show<void>(
                context,
                title: 'Ustawienia projektu',
                subtitle: 'Konfiguracja administratora',
                collapsedWidth: 420,
                expandedWidth: 720,
                bodyBuilder: (_, controller) => Center(
                  child: FilledButton(
                    onPressed: controller.expand,
                    child: const Text('Pokaż szczegóły'),
                  ),
                ),
              ),
              child: const Text('Otwórz ustawienia'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Otwórz ustawienia'));
    await tester.pumpAndSettle();

    expect(find.text('Ustawienia projektu'), findsOneWidget);
    expect(find.text('Konfiguracja administratora'), findsOneWidget);
    expect(find.byTooltip('Zamknij'), findsOneWidget);
    expect(
      tester.getSize(find.byType(AnimatedContainer)).width,
      420,
    );

    await tester.tap(find.text('Pokaż szczegóły'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(AnimatedContainer)).width,
      720,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Ustawienia projektu'), findsNothing);
  });

  testWidgets('nie wychodzi poza viewport po zwężeniu okna webowego', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(300, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => FilledButton(
              onPressed: () => AppExpandableSideSheet.show<void>(
                context,
                collapsedWidth: 620,
                expandedWidth: 960,
                bodyBuilder: (_, _) => const Text('Treść panelu'),
              ),
              child: const Text('Otwórz'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Otwórz'));
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byType(AnimatedContainer)).width,
      lessThanOrEqualTo(300),
    );
  });
}
