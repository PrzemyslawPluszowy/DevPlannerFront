import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_modal_tabs.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/modal/task_details_visited_tab_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('keeps an edited description mounted across tab changes', (
    tester,
  ) async {
    await tester.pumpWidget(const _TabHarness());

    await tester.enterText(find.byKey(const ValueKey('description')), 'Draft');
    await tester.tap(find.text('Pliki'));
    await tester.pumpAndSettle();
    expect(find.text('Pliki panel'), findsOneWidget);

    await tester.tap(find.text('Praca'));
    await tester.pumpAndSettle();
    expect(find.text('Draft'), findsOneWidget);
  });
}

final class _TabHarness extends StatefulWidget {
  const _TabHarness();

  @override
  State<_TabHarness> createState() => _TabHarnessState();
}

final class _TabHarnessState extends State<_TabHarness> {
  TaskDetailsModalTab _selected = TaskDetailsModalTab.work;

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: Column(
        children: [
          TextButton(
            onPressed: () =>
                setState(() => _selected = TaskDetailsModalTab.work),
            child: const Text('Praca'),
          ),
          TextButton(
            onPressed: () =>
                setState(() => _selected = TaskDetailsModalTab.files),
            child: const Text('Pliki'),
          ),
          Expanded(
            child: TaskDetailsVisitedTabStack(
              selected: _selected,
              children: const {
                TaskDetailsModalTab.work: TextField(
                  key: ValueKey('description'),
                ),
                TaskDetailsModalTab.conversation: Text('Rozmowa panel'),
                TaskDetailsModalTab.files: Text('Pliki panel'),
                TaskDetailsModalTab.planAndTime: Text('Plan panel'),
                TaskDetailsModalTab.history: Text('Historia panel'),
              },
            ),
          ),
        ],
      ),
    ),
  );
}
