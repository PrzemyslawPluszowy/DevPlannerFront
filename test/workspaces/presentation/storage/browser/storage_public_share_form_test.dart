import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/standalone/storage_public_share_form.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  Widget harness({
    required Future<String?> Function(String?, DateTime?) onCreate,
  }) => MaterialApp(
    locale: const Locale('pl'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    theme: ThemeData(useMaterial3: true),
    home: Scaffold(
      body: StoragePublicShareForm(onCreate: onCreate),
    ),
  );

  testWidgets('expiry uses compact web picker and sends local end of day UTC', (
    tester,
  ) async {
    DateTime? receivedExpiry;
    await tester.pumpWidget(
      harness(
        onCreate: (_, expiry) async {
          receivedExpiry = expiry;
          return null;
        },
      ),
    );
    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    expect(find.byType(CompactWebDatePickerPanel), findsOneWidget);
    expect(find.byType(DatePickerDialog), findsNothing);
    final day = DateTime.now().add(const Duration(days: 15));
    final selected = DateTime(day.year, day.month, day.day);
    final manual = find.descendant(
      of: find.byType(CompactWebDatePickerPanel),
      matching: find.byType(TextField),
    );
    await tester.enterText(manual, DateFormat.yMd('pl').format(selected));
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Zapisz'));
    await tester.pumpAndSettle();
    expect(find.byType(CompactWebDatePickerPanel), findsNothing);
    await tester.tap(find.widgetWithText(FilledButton, 'Generuj link'));
    await tester.pump();
    expect(
      receivedExpiry,
      DateTime(selected.year, selected.month, selected.day, 23, 59, 59).toUtc(),
    );
    expect(receivedExpiry?.isUtc, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('pokazuje i kopiuje link po potwierdzonym utworzeniu', (
    tester,
  ) async {
    String? receivedPassword;
    DateTime? receivedExpiry;
    await tester.pumpWidget(
      harness(
        onCreate: (password, expiresAtUtc) async {
          receivedPassword = password;
          receivedExpiry = expiresAtUtc;
          return 'https://public.example/storage/public/opaque-token';
        },
      ),
    );
    await tester.enterText(find.byType(TextField), 'tajne-haslo');
    await tester.tap(find.widgetWithText(FilledButton, 'Generuj link'));
    await tester.pump();

    expect(receivedPassword, 'tajne-haslo');
    expect(receivedExpiry, isNull);
    expect(
      find.text('https://public.example/storage/public/opaque-token'),
      findsOneWidget,
    );
    expect(find.byTooltip('Kopiuj link publiczny'), findsOneWidget);
  });
}
