import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/standalone/storage_public_share_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

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
