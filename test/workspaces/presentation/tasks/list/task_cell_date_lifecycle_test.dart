import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/cells/task_cell_dates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

final class _DateCellHarness extends StatefulWidget {
  const _DateCellHarness({
    required this.onChanged,
    this.initialDate,
    this.useDefaultDate = true,
    super.key,
  });

  final Future<bool> Function(DateTime?) onChanged;
  final DateTime? initialDate;
  final bool useDefaultDate;

  @override
  State<_DateCellHarness> createState() => _DateCellHarnessState();
}

final class _DateCellHarnessState extends State<_DateCellHarness> {
  static final DateTime _defaultDate = DateTime.utc(
    2026,
    10,
    1,
    10,
    27,
    38,
    123,
    456,
  );

  Future<bool> Function(DateTime?)? replacement;
  bool visible = true;
  DateTime? dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = widget.useDefaultDate ? _defaultDate : widget.initialDate;
  }

  void replace(Future<bool> Function(DateTime?) callback) {
    setState(() => replacement = callback);
  }

  void remove() => setState(() => visible = false);

  void replaceDate() => setState(() => dateTime = DateTime.utc(2026, 10, 2));

  @override
  Widget build(BuildContext context) => MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: MaterialTheme.crm().light(),
    home: Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: visible
            ? TaskCellDate(
                dateTime: dateTime,
                icon: Icons.event,
                tooltip: 'Due date',
                onChanged: replacement ?? widget.onChanged,
              )
            : const SizedBox.shrink(),
      ),
    ),
  );
}

void main() {
  testWidgets('replaced callback discards a retained calendar selection', (
    tester,
  ) async {
    var oldWrites = 0;
    var newWrites = 0;
    final key = GlobalKey<_DateCellHarnessState>();
    await tester.pumpWidget(
      _DateCellHarness(
        key: key,
        onChanged: (_) async {
          oldWrites++;
          return true;
        },
      ),
    );
    await tester.tap(find.byType(TaskCellDate));
    await tester.pumpAndSettle();
    key.currentState!.replace((_) async {
      newWrites++;
      return true;
    });
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(oldWrites, 0);
    expect(newWrites, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('removed date cell discards retained calendar selection', (
    tester,
  ) async {
    var writes = 0;
    final key = GlobalKey<_DateCellHarnessState>();
    await tester.pumpWidget(
      _DateCellHarness(
        key: key,
        onChanged: (_) async {
          writes++;
          return true;
        },
      ),
    );
    await tester.tap(find.byType(TaskCellDate));
    await tester.pumpAndSettle();
    key.currentState!.remove();
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(writes, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('updated date discards the older open calendar draft', (
    tester,
  ) async {
    var writes = 0;
    final key = GlobalKey<_DateCellHarnessState>();
    await tester.pumpWidget(
      _DateCellHarness(
        key: key,
        onChanged: (_) async {
          writes++;
          return true;
        },
      ),
    );
    await tester.tap(find.byType(TaskCellDate));
    await tester.pumpAndSettle();
    key.currentState!.replaceDate();
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(writes, 0);
    expect(tester.takeException(), isNull);
  });

  testWidgets('date cell preserves the local clock when changing a task date', (
    tester,
  ) async {
    final previous = _DateCellHarnessState._defaultDate;
    final previousLocal = previous.toLocal();
    DateTime? selected;
    await tester.pumpWidget(
      _DateCellHarness(
        onChanged: (value) async {
          selected = value;
          return true;
        },
      ),
    );
    await tester.tap(find.byType(TaskCellDate));
    await tester.pumpAndSettle();
    final pickerField = tester.widget<TextField>(find.byType(TextField));
    expect(
      pickerField.controller!.text,
      DateFormat.yMd('en').format(previous.toLocal()),
    );
    await tester.tap(find.text('15'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(
      selected,
      DateTime(
        2026,
        10,
        15,
        previousLocal.hour,
        previousLocal.minute,
        previousLocal.second,
        previousLocal.millisecond,
        previousLocal.microsecond,
      ).toUtc(),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('new task date uses local midnight as its UTC instant', (
    tester,
  ) async {
    DateTime? selected;
    await tester.pumpWidget(
      _DateCellHarness(
        useDefaultDate: false,
        onChanged: (value) async {
          selected = value;
          return true;
        },
      ),
    );
    await tester.tap(find.byType(TaskCellDate));
    await tester.pumpAndSettle();
    await tester.tap(find.text('15'));
    await tester.pump();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(selected, DateTime(2026, 10, 15).toUtc());
    expect(tester.takeException(), isNull);
  });

  testWidgets('date picker opens on the task local calendar day', (
    tester,
  ) async {
    final instant = DateTime.utc(2026, 10, 1, 2);
    await tester.pumpWidget(
      _DateCellHarness(
        useDefaultDate: false,
        initialDate: instant,
        onChanged: (_) async => true,
      ),
    );
    await tester.tap(find.byType(TaskCellDate));
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(
      field.controller!.text,
      DateFormat.yMd('en').format(instant.toLocal()),
    );
    expect(tester.takeException(), isNull);
  });
}
