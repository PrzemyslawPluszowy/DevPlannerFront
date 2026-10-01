import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_create_document_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Launcher extends StatefulWidget {
  const _Launcher({required this.onResult});
  final ValueChanged<StorageCreateDocumentRequest?> onResult;
  @override
  State<_Launcher> createState() => _LauncherState();
}

final class _LauncherState extends State<_Launcher> {
  Future<void> _open() async {
    final result = await StorageCreateDocumentDialog.show(context);
    if (!mounted) return;
    widget.onResult(result);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(onPressed: _open, child: const Text('Open')),
  );
}

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'document validation and open format menu at 200%; dark=$dark',
      (
        tester,
      ) async {
        tester.view.physicalSize = const Size(420, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final results = <StorageCreateDocumentRequest?>[];
        final theme = MaterialTheme.crm();
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? theme.dark() : theme.light(),
            locale: Locale(dark ? 'pl' : 'en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            ),
            home: _Launcher(onResult: results.add),
          ),
        );
        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();
        final create = find.byKey(const ValueKey('storage_document_create'));
        expect(create.hitTestable(), findsOneWidget);
        await tester.tap(create);
        await tester.pumpAndSettle();
        final name = find.byKey(const ValueKey('storage_document_name'));
        final l10n = AppLocalizations.of(tester.element(name))!;
        expect(find.text(l10n.authFieldRequired), findsOneWidget);
        expect(results, isEmpty);
        await tester.ensureVisible(name);
        await tester.enterText(name, '  Quarterly report  ');
        await tester.pumpAndSettle();
        expect(find.text(l10n.authFieldRequired), findsNothing);
        final format = find.byKey(const ValueKey('storage_document_format'));
        await tester.ensureVisible(format);
        await tester.tap(find.byType(DropdownButton<StorageDocumentFormat>));
        await tester.pumpAndSettle();
        final xlsx = find.text(l10n.storageFormatXlsx).last;
        await tester.scrollUntilVisible(
          find.text(l10n.storageFormatXlsx),
          80,
          scrollable: find.byType(Scrollable).last,
        );
        await tester.tap(xlsx);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(create.hitTestable(), findsOneWidget);
        await tester.tap(create);
        await tester.pumpAndSettle();
        expect(results, [
          (name: 'Quarterly report', format: StorageDocumentFormat.xlsx),
        ]);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
