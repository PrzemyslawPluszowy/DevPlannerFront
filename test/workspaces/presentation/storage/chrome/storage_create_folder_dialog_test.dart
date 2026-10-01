import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_create_folder_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Launcher extends StatefulWidget {
  const _Launcher({required this.onResult});
  final ValueChanged<String?> onResult;
  @override
  State<_Launcher> createState() => _LauncherState();
}

final class _LauncherState extends State<_Launcher> {
  Future<void> _open() async {
    final result = await StorageCreateFolderDialog.show(context);
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
      'folder validation and submit at 200%; dark=$dark',
      (
        tester,
      ) async {
        tester.view.physicalSize = const Size(420, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final results = <String?>[];
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
        final create = find.byKey(
          const ValueKey('storage_folder_create_confirm'),
        );
        expect(create.hitTestable(), findsOneWidget);
        await tester.tap(create);
        await tester.pumpAndSettle();
        final name = find.byKey(const ValueKey('storage_folder_create_name'));
        final l10n = AppLocalizations.of(tester.element(name))!;
        expect(find.text(l10n.authFieldRequired), findsOneWidget);
        expect(results, isEmpty);
        await tester.ensureVisible(name);
        await tester.enterText(name, '  Quarterly report  ');
        await tester.pumpAndSettle();
        expect(find.text(l10n.authFieldRequired), findsNothing);
        expect(create.hitTestable(), findsOneWidget);
        if (dark) {
          await tester.testTextInput.receiveAction(TextInputAction.done);
        } else {
          await tester.tap(create);
        }
        await tester.pumpAndSettle();
        expect(results, ['Quarterly report']);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
