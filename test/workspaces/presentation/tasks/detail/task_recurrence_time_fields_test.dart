import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_imports.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_recurrence_time_fields.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final locale in const [Locale('pl'), Locale('en')]) {
    testWidgets('time selection retains local date and sends UTC: $locale', (
      tester,
    ) async {
      final original = DateTime(2026, 10, 17, 9, 17, 21, 5, 7).toUtc();
      DateTime? result;
      await tester.pumpWidget(
        _host(locale, original, (value) => result = value),
      );
      final fields = find.byType(TaskDetailsSelectField<int>);
      await tester.tap(fields.first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('13').last);
      await tester.pumpAndSettle();
      expect(result, DateTime(2026, 10, 17, 13, 17).toUtc());
      expect(result!.isUtc, isTrue);
      result = null;
      await tester.tap(fields.last);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('23').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('23').last);
      await tester.pumpAndSettle();
      expect(result, DateTime(2026, 10, 17, 9, 23).toUtc());
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('disabled or missing date cannot change the time', (
    tester,
  ) async {
    var changes = 0;
    await tester.pumpWidget(_host(const Locale('pl'), null, (_) => changes++));
    for (final field in tester.widgetList<TaskDetailsSelectField<int>>(
      find.byType(TaskDetailsSelectField<int>),
    )) {
      expect(field.enabled, isFalse);
    }
    await tester.tap(find.byType(TaskDetailsSelectField<int>).first);
    await tester.pumpAndSettle();
    expect(changes, 0);
    await tester.pumpWidget(
      _host(
        const Locale('pl'),
        DateTime.utc(2026),
        (_) => changes++,
        enabled: false,
      ),
    );
    await tester.tap(find.byType(TaskDetailsSelectField<int>).last);
    await tester.pumpAndSettle();
    expect(changes, 0);
  });

  testWidgets('unchanged time preserves sub-minute precision', (tester) async {
    var changes = 0;
    await tester.pumpWidget(
      _host(
        const Locale('en'),
        DateTime(2026, 10, 17, 9, 17, 21, 5, 7).toUtc(),
        (_) => changes++,
      ),
    );
    await tester.tap(find.byType(TaskDetailsSelectField<int>).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('09').last);
    await tester.pumpAndSettle();
    expect(changes, 0);
  });

  testWidgets('pending menu result is discarded after source date changes', (
    tester,
  ) async {
    final date = ValueNotifier(DateTime(2026, 10, 17, 9, 17).toUtc());
    var changes = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: MaterialTheme.crm().light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ValueListenableBuilder<DateTime>(
            valueListenable: date,
            builder: (context, value, _) => TaskRecurrenceTimeFields(
              value: value,
              enabled: true,
              selectionScope: 'owner',
              onChanged: (_) => changes++,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(TaskDetailsSelectField<int>).first);
    await tester.pumpAndSettle();
    date.value = date.value.add(const Duration(days: 1));
    await tester.pump();
    await tester.tap(find.text('13').last);
    await tester.pumpAndSettle();
    expect(changes, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    date.dispose();
  });
}

Widget _host(
  Locale locale,
  DateTime? value,
  ValueChanged<DateTime?> onChanged, {
  bool enabled = true,
}) => MaterialApp(
  locale: locale,
  theme: MaterialTheme.crm().light(),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: Scaffold(
    body: SizedBox(
      width: 500,
      child: TaskRecurrenceTimeFields(
        value: value,
        enabled: enabled,
        selectionScope: 'owner',
        onChanged: onChanged,
      ),
    ),
  ),
);
