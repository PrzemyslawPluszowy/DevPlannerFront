import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  testWidgets('compact anchored picker accepts localized manual date', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey<_PickerHarnessState>();

    await tester.pumpWidget(_pickerApp(key, const Locale('en')));
    await tester.tap(find.text('Pick date'));
    await tester.pumpAndSettle();

    expect(find.byType(CompactWebDatePickerPanel), findsOneWidget);
    expect(find.byType(DatePickerDialog), findsNothing);
    final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)))!;
    final desired = DateTime(2026, 10, 15);
    await tester.enterText(
      find.byType(TextField),
      DateFormat.yMd('en').format(desired),
    );
    await tester.tap(find.text(l10n.tasksDatePickerManualApply));
    await tester.pump();
    await tester.tap(find.text(l10n.tasksListSaveButton));
    await tester.pumpAndSettle();

    expect(key.currentState!.selected, DateTime(2026, 10, 15));
    expect(find.byType(CompactWebDatePickerPanel), findsNothing);
  });

  testWidgets(
    'calendar selection updates manual date and cannot be reverted by apply',
    (tester) async {
      tester.view.physicalSize = const Size(1000, 760);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final key = GlobalKey<_PickerHarnessState>();
      await tester.pumpWidget(_pickerApp(key, const Locale('pl')));
      await tester.tap(find.text('Pick date'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.pump();
      final field = tester.widget<TextField>(find.byType(TextField));
      expect(
        field.controller!.text,
        DateFormat.yMd('pl').format(DateTime(2026, 10, 15)),
      );
      final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)))!;
      await tester.tap(find.text(l10n.tasksDatePickerManualApply));
      await tester.pump();
      await tester.tap(find.text(l10n.tasksListSaveButton));
      await tester.pumpAndSettle();
      expect(key.currentState!.selected, DateTime(2026, 10, 15));
    },
  );

  testWidgets('UTC calendar date keeps its day in western time zones', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final key = GlobalKey<_PickerHarnessState>();
    await tester.pumpWidget(
      _pickerApp(key, const Locale('en'), initialValue: DateTime.utc(2026, 10)),
    );
    await tester.tap(find.text('Pick date'));
    await tester.pumpAndSettle();
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(
      field.controller!.text,
      DateFormat.yMd('en').format(DateTime(2026, 10)),
    );
  });

  for (final language in ['pl', 'en']) {
    testWidgets('calendar day aligns with weekday header in $language', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1000, 760);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        _pickerApp(GlobalKey<_PickerHarnessState>(), Locale(language)),
      );
      await tester.tap(find.text('Pick date'));
      await tester.pumpAndSettle();
      final weekday = DateFormat.E(language).format(DateTime(2026, 10));
      expect(
        tester.getCenter(find.text('1')).dx,
        closeTo(tester.getCenter(find.text(weekday)).dx, 1),
      );
    });
  }

  testWidgets(
    'calendar disables both month arrows for a single allowed month',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: MaterialTheme.crm().light(),
          home: Scaffold(
            body: CompactWebDatePickerPanel(
              initialValue: DateTime(2026, 10, 15),
              firstDate: DateTime(2026, 10),
              lastDate: DateTime(2026, 10, 31),
              onSelected: (_) {},
              onCancelled: () {},
            ),
          ),
        ),
      );
      final material = MaterialLocalizations.of(
        tester.element(find.byType(Scaffold)),
      );
      for (final tooltip in [
        material.previousMonthTooltip,
        material.nextMonthTooltip,
      ]) {
        final button = tester.widget<IconButton>(
          find.byWidgetPredicate(
            (widget) => widget is IconButton && widget.tooltip == tooltip,
          ),
        );
        expect(button.onPressed, isNull);
      }
    },
  );

  testWidgets('invalid manual date stays in picker with localized error', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _pickerApp(GlobalKey<_PickerHarnessState>(), const Locale('pl')),
    );
    await tester.tap(find.text('Pick date'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '99.99.2026');
    final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)))!;
    await tester.tap(find.text(l10n.tasksDatePickerManualApply));
    await tester.pump();

    expect(find.text(l10n.tasksDatePickerInvalidDate), findsOneWidget);
    expect(find.byType(CompactWebDatePickerPanel), findsOneWidget);
  });
}

Widget _pickerApp(
  GlobalKey<_PickerHarnessState> key,
  Locale locale, {
  DateTime? initialValue,
}) => MaterialApp(
  locale: locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  theme: MaterialTheme.crm().light(),
  home: Scaffold(
    body: _PickerHarness(key: key, initialValue: initialValue),
  ),
);

final class _PickerHarness extends StatefulWidget {
  const _PickerHarness({required super.key, this.initialValue});

  final DateTime? initialValue;

  @override
  State<_PickerHarness> createState() => _PickerHarnessState();
}

final class _PickerHarnessState extends State<_PickerHarness> {
  DateTime? selected;

  Future<void> _open(BuildContext sourceContext) async {
    final result = await TaskDatePicker.pick(
      sourceContext,
      initialValue: widget.initialValue ?? DateTime(2026, 10),
      globalPosition: AppContextMenu.positionFor(sourceContext),
      firstDate: DateTime(2026),
      lastDate: DateTime(2026, 12, 31),
    );
    if (!mounted || !sourceContext.mounted || result == null) return;
    setState(() => selected = result.value);
  }

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Builder(
          builder: (buttonContext) => TextButton(
            onPressed: () => _open(buttonContext),
            child: const Text('Pick date'),
          ),
        ),
        if (selected != null) Text(DateFormat.yMd().format(selected!)),
      ],
    ),
  );
}
