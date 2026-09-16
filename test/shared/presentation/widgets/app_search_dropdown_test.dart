import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/shared/presentation/widgets/app_overlay_route_lifecycle.dart';
import 'package:ready_next/shared/presentation/widgets/app_search_dropdown.dart';

void main() {
  testWidgets(
    'odswieza otwarty panel po asynchronicznej zmianie opcji',
    (tester) async {
      final options = ValueNotifier<List<AppSearchDropdownOption<String>>>(
        const [],
      );
      final selected = <String>[];

      addTearDown(options.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValueListenableBuilder<List<AppSearchDropdownOption<String>>>(
              valueListenable: options,
              builder: (context, value, _) {
                return AppSearchDropdown<String>(
                  options: value,
                  noResultsText: 'Brak wynikow',
                  onSelected: (option) => selected.add(option.value),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField));
      await tester.enterText(find.byType(TextField), 'paulina');
      await tester.pump();

      expect(find.text('Brak wynikow'), findsOneWidget);

      options.value = const [
        AppSearchDropdownOption(
          value: 'paulina-nowak',
          label: 'Paulina Nowak',
          keywords: ['paulina'],
        ),
      ];
      await tester.pumpAndSettle();

      expect(find.text('Brak wynikow'), findsNothing);
      expect(find.text('Paulina Nowak'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'paulin');
      await tester.pumpAndSettle();

      expect(find.text('Paulina Nowak'), findsOneWidget);

      await tester.tap(find.text('Paulina Nowak'));
      await tester.pump();

      expect(selected, ['paulina-nowak']);
    },
  );

  testWidgets('zamyka panel po zmianie trasy private shella', (tester) async {
    final lifecycle = AppOverlayRouteLifecycle();
    addTearDown(lifecycle.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: AppOverlayRouteLifecycleScope(
          lifecycle: lifecycle,
          child: Scaffold(
            body: AppSearchDropdown<String>(
              options: const [],
              noResultsText: 'Brak wynikow',
              onSelected: (_) {},
              isLoading: true,
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();
    expect(find.text('Trwa wyszukiwanie...'), findsOneWidget);

    lifecycle.didChangeRoute();
    await tester.pump();

    expect(find.text('Trwa wyszukiwanie...'), findsNothing);
  });

  testWidgets('zamyka panel po zmianie rozmiaru viewportu', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(900, 600));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppSearchDropdown<String>(
            options: const [],
            noResultsText: 'Brak wynikow',
            onSelected: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(find.text('Brak wynikow'), findsOneWidget);

    await tester.binding.setSurfaceSize(const Size(700, 600));
    await tester.pumpAndSettle();

    expect(find.text('Brak wynikow'), findsNothing);
  });

  testWidgets('usuwa panel razem z utraconą kotwicą', (tester) async {
    final visible = ValueNotifier(true);
    addTearDown(visible.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<bool>(
            valueListenable: visible,
            builder: (context, isVisible, _) {
              if (!isVisible) {
                return const SizedBox.shrink();
              }
              return AppSearchDropdown<String>(
                options: const [],
                noResultsText: 'Brak wynikow',
                onSelected: (_) {},
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(find.text('Brak wynikow'), findsOneWidget);

    visible.value = false;
    await tester.pumpAndSettle();

    expect(find.text('Brak wynikow'), findsNothing);
  });
}
