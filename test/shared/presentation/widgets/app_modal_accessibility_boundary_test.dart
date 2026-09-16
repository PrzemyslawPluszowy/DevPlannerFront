import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_accessibility_boundary.dart';

void main() {
  testWidgets('Escape wywołuje zamknięcie draweru', (tester) async {
    var dismissed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: AppModalAccessibilityBoundary(
          onDismiss: () => dismissed = true,
          child: const Scaffold(body: TextField(autofocus: true)),
        ),
      ),
    );
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);

    expect(dismissed, isTrue);
  });

  testWidgets('Tab pozostaje w obrębie panelu', (tester) async {
    final firstFocus = FocusNode();
    final secondFocus = FocusNode();
    addTearDown(firstFocus.dispose);
    addTearDown(secondFocus.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: AppModalAccessibilityBoundary(
          onDismiss: () {},
          child: Scaffold(
            body: Column(
              children: [
                Focus(
                  autofocus: true,
                  focusNode: firstFocus,
                  child: const SizedBox(height: 40),
                ),
                Focus(
                  focusNode: secondFocus,
                  child: const SizedBox(height: 40),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    expect(secondFocus.hasFocus, isTrue);
  });
}
