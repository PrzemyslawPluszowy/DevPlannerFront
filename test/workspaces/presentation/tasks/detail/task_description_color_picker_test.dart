import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/tasks/detail/task_description_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('kolory zachowują zapis RGB/ARGB Quill i odrzucają błędne kody', () {
    expect(TaskDescriptionColorPicker.normalize(' #ab12ef '), '#AB12EF');
    expect(
      TaskDescriptionColorPicker.preview('#800000FF')!.toARGB32(),
      0x800000FF,
    );
    expect(
      TaskDescriptionColorPicker.preview('#0000FF')!.toARGB32(),
      0xFF0000FF,
    );
    for (final invalid in ['', '#gg0000', '#12345', '#123456789']) {
      expect(TaskDescriptionColorPicker.normalize(invalid), isNull);
    }
  });

  testWidgets('błąd nie zapisuje; cancel, kolor i reset mają osobne wyniki', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(480, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final results = <TaskDescriptionColorChoice?>[];
    await tester.pumpWidget(
      MaterialApp(
        theme: MaterialTheme.crm().dark(),
        locale: const Locale('pl'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async => results.add(
                await TaskDescriptionColorPicker.show(
                  context,
                  title: 'Kolor tekstu',
                  initialValue: '#800000FF',
                ),
              ),
              child: const Text('Otwórz'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Otwórz'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final input = find.byKey(const ValueKey('task_description_color_hex'));
    expect(tester.widget<TextField>(input).controller!.text, '#800000FF');
    await tester.enterText(input, '#XYZ');
    await tester.tap(find.text('Zapisz'));
    await tester.pumpAndSettle();
    expect(results, isEmpty);
    expect(find.byType(TextField), findsOneWidget);
    expect(tester.widget<TextField>(input).decoration!.errorText, isNotNull);
    await tester.tap(find.text('Anuluj'));
    await tester.pumpAndSettle();
    expect(results, [null]);

    await tester.tap(find.text('Otwórz'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('#DC2626'));
    await tester.tap(find.text('Zapisz'));
    await tester.pumpAndSettle();
    expect(results.last!.value, '#DC2626');

    await tester.tap(find.text('Otwórz'));
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(TextField));
    await tester.tap(
      find.text(
        AppLocalizations.of(context)!.taskDescriptionColorDefault,
      ),
    );
    await tester.pumpAndSettle();
    expect(results.last, isNotNull);
    expect(results.last!.value, isNull);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
