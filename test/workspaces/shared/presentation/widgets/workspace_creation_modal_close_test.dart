import 'dart:async';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/shared/presentation/widgets/workspace_creation_modal_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('late close guard does not pop the next route', (tester) async {
    final navigator = GlobalKey<NavigatorState>();
    final guard = Completer<bool>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navigator,
        theme: MaterialTheme.crm().light(),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: Text('Home route')),
      ),
    );
    navigator.currentState!.push<void>(
      MaterialPageRoute<void>(
        builder: (_) => Scaffold(
          body: WorkspaceCreationModalWrapper(
            title: 'Fixture modal',
            cancelLabel: 'Cancel fixture',
            onBeforeClose: () => guard.future,
            body: const Text('Fixture body'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel fixture').hitTestable());
    await tester.pump();
    navigator.currentState!.push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Text('Next route')),
      ),
    );
    await tester.pumpAndSettle();
    guard.complete(true);
    await tester.pumpAndSettle();
    expect(find.text('Next route').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
