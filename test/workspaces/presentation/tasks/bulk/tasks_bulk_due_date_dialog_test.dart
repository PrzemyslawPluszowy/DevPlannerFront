import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_bulk_due_date_dialog.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_contextual_bulk_bar.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_details_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'overflow bulk actions remain reachable and scroll survives saving',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 200));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var cleared = 0;
      Widget app(bool saving) => MaterialApp(
        locale: const Locale('en'),
        theme: MaterialTheme.crm().dark().copyWith(
          platform: TargetPlatform.macOS,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: TasksContextualBulkBar(
              selectedCount: 2,
              isSaving: saving,
              controls: [
                for (var i = 0; i < 5; i++)
                  TasksBulkButton(
                    icon: Icons.edit,
                    label: 'Action $i',
                    onTap: saving ? null : () {},
                  ),
              ],
              onClearSelection: () => cleared++,
            ),
          ),
        ),
      );
      await tester.pumpWidget(app(false));
      final bar = find.byKey(const ValueKey('contextual_bulk_bar'));
      final height = tester.getSize(bar).height;
      final countRect = tester.getRect(find.text('Selected: 2'));
      final clear = find.byKey(const ValueKey('bulk_clear_selection'));
      final clearRect = tester.getRect(clear);
      final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar));
      expect(scrollbar.thumbVisibility, isTrue);
      await tester.drag(bar, const Offset(-1200, 0));
      await tester.pumpAndSettle();
      final offset = scrollbar.controller!.offset;
      expect(offset, greaterThan(0));
      expect(tester.getRect(find.text('Selected: 2')), countRect);
      expect(tester.getRect(clear), clearRect);
      expect(clearRect.right, lessThanOrEqualTo(500));
      await tester.tap(clear);
      expect(cleared, 1);
      await tester.pumpWidget(app(true));
      await tester.pump();
      expect(tester.getSize(bar).height, height);
      expect(
        tester.widget<Scrollbar>(find.byType(Scrollbar)).controller!.offset,
        offset,
      );
      await tester.tap(clear);
      expect(cleared, 1);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );

  test('changing only day preserves the complete local clock and UTC instant precision', () {
    final clock = DateTime(2026, 10, 10, 12, 34, 56, 123, 456);
    final result = TasksBulkDueDateDialog.resolve(
      DateTime(2026, 10, 11),
      clock,
    )!;
    final local = result.toLocal();
    expect(local, DateTime(2026, 10, 11, 12, 34, 56, 123, 456));
    expect(result.isUtc, isTrue);
    final dstDay = DateTime(2026, 3, 29);
    final requestedClock = DateTime(2000, 1, 1, 2, 30);
    final normalized = DateTime(2026, 3, 29, 2, 30);
    if (normalized.hour != 2 || normalized.minute != 30) {
      expect(TasksBulkDueDateDialog.resolve(dstDay, requestedClock), isNull);
    }
  });

  for (final locale in ['pl', 'en']) {
    testWidgets(
      'desktop time controls preserve precision, clear differs from cancel $locale',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(480, 750));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final results = <TasksBulkDueDateChoice?>[];
        final due = DateTime.utc(2026, 10, 10, 8, 15, 4, 123, 456);
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            theme: MaterialTheme.crm().light(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: TextButton(
                  onPressed: () async {
                    results.add(
                      await TasksBulkDueDateDialog.show(
                        context,
                        currentValues: [due, due.add(const Duration(days: 1))],
                        scopeLabel: '2 tasks',
                        calendarTimeZoneId: 'Europe/Warsaw',
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        expect(find.byType(TaskDetailsSelectField<int>), findsNWidgets(2));
        expect(find.byType(TimePickerDialog), findsNothing);
        await tester.tap(find.text(locale == 'pl' ? 'Zapisz' : 'Save'));
        await tester.pumpAndSettle();
        expect(results.single!.value, due);
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(find.text(locale == 'pl' ? 'Anuluj' : 'Cancel'));
        await tester.pumpAndSettle();
        expect(results.last, isNull);
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        await tester.tap(
          find.text(
            locale == 'pl'
                ? 'Usuń terminy w tym zakresie'
                : 'Clear due dates in this scope',
          ),
        );
        await tester.pumpAndSettle();
        expect(results.last, isNotNull);
        expect(results.last!.value, isNull);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }

  testWidgets(
    'bulk pending reserves height, disables clear and renders durable error with retry',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 220));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var cleared = 0;
      var retried = 0;
      Widget app({bool saving = false, String? error}) => MaterialApp(
        locale: const Locale('en'),
        theme: MaterialTheme.crm().dark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TasksContextualBulkBar(
            selectedCount: 2,
            controls: [
              for (var i = 0; i < 5; i++)
                TasksBulkButton(
                  icon: Icons.edit,
                  label: 'Action $i',
                  onTap: saving ? null : () {},
                ),
            ],
            isSaving: saving,
            errorMessage: error,
            onClearSelection: () => cleared++,
            onRetry: () => retried++,
          ),
        ),
      );
      await tester.pumpWidget(app());
      final height = tester
          .getSize(find.byKey(const ValueKey('contextual_bulk_bar')))
          .height;
      final actionRect = tester.getRect(find.text('Action 0'));
      final feedback = find.byKey(const ValueKey('bulk_feedback'));
      final feedbackRect = tester.getRect(feedback);
      await tester.pumpWidget(app(saving: true));
      await tester.pump();
      expect(
        tester
            .getSize(find.byKey(const ValueKey('contextual_bulk_bar')))
            .height,
        height,
      );
      await tester.tap(find.byKey(const ValueKey('bulk_clear_selection')));
      expect(cleared, 0);
      expect(find.byTooltip('Saving changes…'), findsOneWidget);
      expect(tester.getRect(find.text('Action 0')), actionRect);
      expect(tester.getRect(feedback), feedbackRect);
      await tester.pumpWidget(app(error: 'Due date is before start date.'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Due date is before start date.'), findsOneWidget);
      expect(tester.getRect(find.text('Action 0')), actionRect);
      expect(tester.getRect(feedback), feedbackRect);
      await tester.drag(
        find.byKey(const ValueKey('contextual_bulk_bar')),
        const Offset(-1200, 0),
      );
      await tester.pumpAndSettle();
      expect(tester.getRect(feedback), feedbackRect);
      await tester.tap(find.byKey(const ValueKey('bulk_error_details')));
      await tester.pumpAndSettle();
      expect(find.byType(SelectableText), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Retry'));
      expect(retried, 1);
      expect(
        tester
            .getSize(find.byKey(const ValueKey('contextual_bulk_bar')))
            .height,
        height,
      );
    },
  );
}
