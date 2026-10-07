import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_contextual_bulk_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'mouse menu and delayed confirmation return focus to their action',
    (
      tester,
    ) async {
      final checkboxFocus = FocusNode();
      addTearDown(checkboxFocus.dispose);
      final prepared = Completer<void>();
      final pending = ValueNotifier(false);
      addTearDown(pending.dispose);
      var confirmed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  Checkbox(
                    focusNode: checkboxFocus,
                    value: true,
                    onChanged: (_) {},
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: pending,
                    builder: (context, isPending, _) => TasksBulkMenu<int>(
                      isLoading: isPending,
                      icon: Icons.edit,
                      label: 'Entire result',
                      options: const [
                        AppContextMenuOption(value: 1, label: 'Backlog'),
                      ],
                      onSelected: (_) async {
                        pending.value = true;
                        await prepared.future;
                        pending.value = false;
                        if (!context.mounted) return;
                        confirmed = await AppConfirmDialog.show(
                          context,
                          title: 'Confirm entire result',
                          message: 'Includes unloaded tasks.',
                          cancelLabel: 'Cancel',
                          confirmLabel: 'Save',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      checkboxFocus.requestFocus();
      await tester.pump();
      expect(checkboxFocus.hasFocus, isTrue);
      await tester.tap(find.text('Entire result'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Backlog'));
      await tester.pumpAndSettle();
      final trigger = tester
          .widget<InkWell>(
            find.descendant(
              of: find.byType(TasksBulkButton),
              matching: find.byType(InkWell),
            ),
          )
          .focusNode!;
      expect(pending.value, isTrue);
      expect(trigger.hasFocus, isTrue);
      expect(trigger.skipTraversal, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(find.text('Backlog'), findsNothing);
      prepared.complete();
      await tester.pumpAndSettle();
      expect(find.text('Includes unloaded tasks.'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(trigger.hasFocus, isFalse);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.byType(AppConfirmDialog), findsNothing);
      expect(confirmed, isFalse);
      expect(trigger.hasFocus, isTrue);
      expect(checkboxFocus.hasFocus, isFalse);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );
}
