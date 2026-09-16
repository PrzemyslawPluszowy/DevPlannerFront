import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/directory_menu/widgets/workspace_directory_empty_state.dart';

void main() {
  testWidgets('kompaktowy empty state pokazuje CTA utworzenia workspace’u', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('pl'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: WorkspaceDirectoryEmptyState(),
        ),
      ),
    );

    expect(find.text('Utwórz workspace'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
