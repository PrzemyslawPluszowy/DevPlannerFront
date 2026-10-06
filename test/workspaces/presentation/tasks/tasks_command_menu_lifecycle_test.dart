import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/chrome/tasks_command_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('menu selection cannot call a disposed command owner', (
    tester,
  ) async {
    final visible = ValueNotifier(true);
    addTearDown(visible.dispose);
    var selected = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: MaterialTheme.crm().dark(),
        home: Scaffold(
          body: ValueListenableBuilder<bool>(
            valueListenable: visible,
            builder: (_, show, _) => show
                ? TasksCommandMenu(
                    icon: Icons.filter_alt,
                    label: 'Status',
                    options: const [
                      AppContextMenuOption(value: 'backlog', label: 'Backlog'),
                    ],
                    onSelected: (_) => selected++,
                  )
                : const SizedBox(),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Status'));
    await tester.pumpAndSettle();
    visible.value = false;
    await tester.pump();
    await tester.tap(find.text('Backlog'));
    await tester.pumpAndSettle();
    expect(selected, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'only menus advertise expansion instead of a duplicate action icon',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: MaterialTheme.crm().dark(),
          home: Scaffold(
            body: Row(
              children: [
                TasksCommandMenu(
                  icon: Icons.filter_alt,
                  label: 'Status',
                  options: const [],
                  onSelected: (_) {},
                ),
                TasksCommandButton(
                  icon: Icons.clear,
                  label: 'Clear',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      );
      expect(find.byIcon(Icons.filter_alt), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
    },
  );
}
