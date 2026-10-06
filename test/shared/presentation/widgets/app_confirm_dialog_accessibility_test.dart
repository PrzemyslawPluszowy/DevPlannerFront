import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'confirmation exposes full consequences and cancels through Escape',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        final triggerFocus = FocusNode();
        addTearDown(triggerFocus.dispose);
        final results = <bool>[];
        const message =
            'Status: Backlog\nThis affects 5 tasks, including unloaded pages. Filter: Backlog.';
        await tester.pumpWidget(
          MaterialApp(
            theme: MaterialTheme.crm().dark(),
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  focusNode: triggerFocus,
                  autofocus: true,
                  onPressed: () async {
                    results.add(
                      await AppConfirmDialog.show(
                        context,
                        title: 'Confirm scope',
                        message: message,
                        cancelLabel: 'Cancel',
                        confirmLabel: 'Save',
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(find.bySemanticsLabel(message), findsOneWidget);
        for (var i = 0; i < 4; i++) {
          await tester.sendKeyEvent(LogicalKeyboardKey.tab);
          await tester.pump();
          expect(
            FocusManager.instance.primaryFocus!.context!
                .findAncestorWidgetOfExactType<Dialog>(),
            isNotNull,
          );
        }
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(results, [false]);
        expect(find.byType(AppConfirmDialog), findsNothing);
        expect(triggerFocus.hasFocus, isTrue);
        await tester.pumpWidget(const SizedBox());
      } finally {
        semantics.dispose();
      }
    },
  );
}
