import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('one Tab stop per select; Space opens and Escape returns focus', (
    tester,
  ) async {
    final before = FocusNode(debugLabel: 'before');
    final after = FocusNode(debugLabel: 'after');
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        theme: MaterialTheme.crm().light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Column(
            children: [
              TextButton(
                focusNode: before,
                onPressed: () {},
                child: const Text('Before'),
              ),
              TaskDetailsSelectField<int>(
                label: 'Hour',
                value: 9,
                options: const [
                  TaskDetailsSelectOption(value: 9, label: '09'),
                  TaskDetailsSelectOption(value: 10, label: '10'),
                ],
                onChanged: (_) {},
              ),
              TextButton(
                focusNode: after,
                onPressed: () {},
                child: const Text('After'),
              ),
            ],
          ),
        ),
      ),
    );
    before.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(find.text('10'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('10'), findsNothing);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(after.hasFocus, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    before.dispose();
    after.dispose();
  });
}
