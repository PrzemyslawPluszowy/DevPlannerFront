import 'dart:async';

import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/standalone/storage_public_share_form.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/menu/pickers/task_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (_) async => null);
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });
  Widget harness({
    required Future<String?> Function(String?, DateTime?) onCreate,
    bool enabled = true,
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
      body: StoragePublicShareForm(onCreate: onCreate, enabled: enabled),
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
  testWidgets('expiry can be cleared without creating a link on cancel', (
    tester,
  ) async {
    final expiries = <DateTime?>[];
    await tester.pumpWidget(
      harness(
        onCreate: (_, expiry) async {
          expiries.add(expiry);
          return null;
        },
      ),
    );
    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Zapisz'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Generuj link'));
    await tester.pumpAndSettle();
    expect(expiries.single, isNotNull);
    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Anuluj'));
    await tester.pumpAndSettle();
    expect(expiries.length, 1);
    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wyczyść'));
    await tester.pumpAndSettle();
    expect(find.text('Bez daty wygaśnięcia'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Generuj link'));
    await tester.pumpAndSettle();
    expect(expiries.first, isNotNull);
    expect(expiries.last, isNull);
    expect(expiries.length, 2);
  });

  testWidgets(
    'password edit discards previous generated result and uses new draft',
    (tester) async {
      final passwords = <String?>[];
      await tester.pumpWidget(
        harness(
          onCreate: (password, _) async {
            passwords.add(password);
            return 'https://public.example/link-${passwords.length}';
          },
        ),
      );
      await tester.enterText(find.byType(TextField), 'first');
      await tester.tap(find.widgetWithText(FilledButton, 'Generuj link'));
      await tester.pumpAndSettle();
      expect(find.text('https://public.example/link-1'), findsOneWidget);
      expect(find.text('Link skopiowany do schowka'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'second');
      await tester.pump();
      expect(find.text('https://public.example/link-1'), findsNothing);
      expect(find.text('Link skopiowany do schowka'), findsNothing);
      expect(find.widgetWithText(FilledButton, 'Generuj link'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Generuj link'));
      await tester.pumpAndSettle();
      expect(passwords, ['first', 'second']);
      expect(find.text('https://public.example/link-2'), findsOneWidget);
    },
  );

  testWidgets(
    'password and expiry stay disabled while link creation is pending',
    (tester) async {
      final pending = Completer<String?>();
      await tester.pumpWidget(harness(onCreate: (_, _) => pending.future));
      await tester.tap(find.widgetWithText(FilledButton, 'Generuj link'));
      await tester.pump();
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);
      expect(
        tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
        isNull,
      );
      pending.complete(null);
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(find.byType(TextField)).enabled, isTrue);
    },
  );

  testWidgets('permission change during calendar ignores its late selection', (
    tester,
  ) async {
    final expiries = <DateTime?>[];
    Future<String?> create(String? _, DateTime? expiry) async {
      expiries.add(expiry);
      return null;
    }

    await tester.pumpWidget(harness(onCreate: create));
    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();
    await tester.pumpWidget(harness(onCreate: create, enabled: false));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Zapisz'));
    await tester.pumpAndSettle();
    expect(find.text('Bez daty wygaśnięcia'), findsOneWidget);
    await tester.pumpWidget(harness(onCreate: create));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Generuj link'));
    await tester.pumpAndSettle();
    expect(expiries, [null]);
  });
  testWidgets('old clipboard completion cannot confirm an edited draft', (
    tester,
  ) async {
    final clipboard = Completer<void>();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') await clipboard.future;
          return null;
        });
    await tester.pumpWidget(
      harness(onCreate: (_, _) async => 'https://public.example/old'),
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Generuj link'));
    await tester.pump();
    expect(find.text('https://public.example/old'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'new-draft');
    await tester.pump();
    clipboard.complete();
    await tester.pumpAndSettle();
    expect(find.text('https://public.example/old'), findsNothing);
    expect(find.text('Link skopiowany do schowka'), findsNothing);
    expect(find.widgetWithText(FilledButton, 'Generuj link'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'clipboard failure preserves link and explicit copy can recover',
    (tester) async {
      var failCopy = true;
      var creates = 0;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
            if (call.method == 'Clipboard.setData' && failCopy) {
              throw PlatformException(code: 'clipboard-denied');
            }
            return null;
          });
      await tester.pumpWidget(
        harness(
          onCreate: (_, _) async {
            creates++;
            return 'https://public.example/retained';
          },
        ),
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Generuj link'));
      await tester.pumpAndSettle();
      expect(find.text('https://public.example/retained'), findsOneWidget);
      expect(find.textContaining('nie udało się go skopiować'), findsOneWidget);
      expect(find.text('Link skopiowany do schowka'), findsNothing);
      expect(tester.takeException(), isNull);
      failCopy = false;
      await tester.tap(find.byTooltip('Kopiuj link publiczny'));
      await tester.pumpAndSettle();
      expect(find.text('Link skopiowany do schowka'), findsOneWidget);
      expect(find.textContaining('nie udało się go skopiować'), findsNothing);
      expect(creates, 1);
    },
  );
}
