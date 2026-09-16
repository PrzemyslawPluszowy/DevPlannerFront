import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu.dart';

void main() {
  testWidgets('wykonuje akcje i zamyka menu', (tester) async {
    var actionCalls = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => AppContextMenu.show(
                  context,
                  globalPosition: const Offset(40, 40),
                  actions: [
                    AppContextMenuAction(
                      label: 'Zmień nazwę',
                      icon: Icons.edit_outlined,
                      onTap: (_) => actionCalls++,
                    ),
                  ],
                ),
                child: const Text('Otwórz'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Otwórz'));
    await tester.pumpAndSettle();

    expect(find.text('Zmień nazwę'), findsOneWidget);

    await tester.tap(find.text('Zmień nazwę'));
    await tester.pumpAndSettle();

    expect(actionCalls, 1);
    expect(find.text('Zmień nazwę'), findsNothing);
  });

  testWidgets('zamyka menu po kliknięciu poza nim', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return TextButton(
                onPressed: () => AppContextMenu.show(
                  context,
                  globalPosition: const Offset(40, 40),
                  actions: [
                    AppContextMenuAction(
                      label: 'Usuń',
                      onTap: (_) {},
                    ),
                  ],
                ),
                child: const Text('Otwórz'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Otwórz'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(700, 500));
    await tester.pumpAndSettle();

    expect(find.text('Usuń'), findsNothing);
  });
}
