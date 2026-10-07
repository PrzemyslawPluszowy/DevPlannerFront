import 'package:devplanner/workspaces/presentation/tasks/list/table/task_list_grouped_viewport.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

bool _isGroup(String row) => row.startsWith('group');
bool _isHeader(String row) => row.startsWith('header');

void main() {
  testWidgets('pins the current group header and retains its action scope', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    final rows = [
      'group A',
      'header A',
      for (var i = 0; i < 20; i++) 'A$i',
      'group B',
      'header B',
      for (var i = 0; i < 20; i++) 'B$i',
    ];
    String? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          height: 300,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 300,
              child: TaskListGroupedViewport<String>(
                key: const ValueKey('viewport'),
                rows: rows,
                controller: controller,
                isGroupStart: _isGroup,
                isColumnHeader: _isHeader,
                rowBuilder: (context, row) => SizedBox(
                  height: 42,
                  child: _isHeader(row)
                      ? TextButton(
                          onPressed: () => selected = row,
                          child: Text(row),
                        )
                      : Text(row),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    controller.jumpTo(200);
    await tester.pump();
    final viewportTop = tester
        .getTopLeft(find.byKey(const ValueKey('viewport')))
        .dy;
    final headerA = find.widgetWithText(TextButton, 'header A');
    expect(tester.getRect(headerA).top, closeTo(viewportTop, .01));
    expect(tester.getRect(headerA).height, 42);
    expect(find.text('A19'), findsNothing); // Rows are lazy, not all built.
    controller.jumpTo(1100);
    await tester.pump();
    final headerB = find.widgetWithText(TextButton, 'header B');
    expect(tester.getRect(headerB).top, closeTo(viewportTop, .01));
    expect(tester.getRect(headerB).height, 42);
    expect(headerA.hitTestable(), findsNothing);
    await tester.tap(find.text('header B'));
    expect(selected, 'header B');
    expect(tester.takeException(), isNull);
  });

  testWidgets('collapsed groups omit headers and flat rows have one header', (
    tester,
  ) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        home: TaskListGroupedViewport<String>(
          rows: const [
            'group collapsed',
            'group expanded',
            'header expanded',
            'row',
          ],
          controller: controller,
          isGroupStart: _isGroup,
          isColumnHeader: _isHeader,
          rowBuilder: (context, row) => SizedBox(height: 42, child: Text(row)),
        ),
      ),
    );
    expect(find.byType(SliverPersistentHeader), findsOneWidget);
    await tester.pumpWidget(
      MaterialApp(
        home: TaskListGroupedViewport<String>(
          rows: const ['header flat', 'row'],
          controller: controller,
          isGroupStart: _isGroup,
          isColumnHeader: _isHeader,
          rowBuilder: (context, row) => SizedBox(height: 42, child: Text(row)),
        ),
      ),
    );
    expect(find.text('header flat'), findsOneWidget);
    expect(find.text('header expanded'), findsNothing);
    expect(find.byType(SliverPersistentHeader), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('same rows rebuild header state and track horizontal resizing', (
    tester,
  ) async {
    final vertical = ScrollController();
    final horizontal = ScrollController();
    addTearDown(vertical.dispose);
    addTearDown(horizontal.dispose);
    final rows = ['header flat', for (var i = 0; i < 30; i++) 'row$i'];
    var width = 1000.0;
    var selected = false;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) {
            update = setState;
            return SingleChildScrollView(
              controller: horizontal,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: width,
                child: TaskListGroupedViewport<String>(
                  rows: rows,
                  controller: vertical,
                  isGroupStart: _isGroup,
                  isColumnHeader: _isHeader,
                  rowBuilder: (context, row) => SizedBox(
                    key: ValueKey(row),
                    height: 42,
                    child: _isHeader(row)
                        ? Material(
                            child: Checkbox(value: selected, onChanged: (_) {}),
                          )
                        : Text(row),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
    vertical.jumpTo(200);
    horizontal.jumpTo(120);
    await tester.pump();
    expect(
      tester.getRect(find.byKey(const ValueKey('header flat'))).left,
      -120,
    );
    expect(tester.getRect(find.byKey(const ValueKey('row5'))).left, -120);
    update(() {
      selected = true;
      width = 1200;
    });
    await tester.pump();
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
    expect(
      tester.getRect(find.byKey(const ValueKey('header flat'))).width,
      1200,
    );
    expect(tester.getRect(find.byKey(const ValueKey('row5'))).width, 1200);
    expect(vertical.offset, 200);
    expect(horizontal.offset, 120);
    expect(tester.takeException(), isNull);
  });
}
