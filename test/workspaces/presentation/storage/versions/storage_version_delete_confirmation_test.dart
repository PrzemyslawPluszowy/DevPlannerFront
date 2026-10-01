import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/storage_version_delete_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Launcher extends StatefulWidget {
  const _Launcher({required this.onResult});
  final ValueChanged<bool?> onResult;

  @override
  State<_Launcher> createState() => _LauncherState();
}

final class _LauncherState extends State<_Launcher> {
  Future<void> _open() async {
    final result = await StorageVersionDeleteConfirmation.show(context, 123456);
    if (!mounted) return;
    widget.onResult(result);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(
      key: const ValueKey('open_confirmation'),
      onPressed: _open,
      child: const Text('Open'),
    ),
  );
}

void main() {
  for (final dark in [false, true]) {
    testWidgets(
      'confirmation keeps actions visible at 200 percent; dark=$dark',
      (tester) async {
        tester.view.physicalSize = const Size(420, 600);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final results = <bool?>[];
        final materialTheme = MaterialTheme.crm();
        await tester.pumpWidget(
          MaterialApp(
            theme: dark ? materialTheme.dark() : materialTheme.light(),
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
        await tester.tap(find.byKey(const ValueKey('open_confirmation')));
        await tester.pumpAndSettle();
        final cancel = find.byKey(
          const ValueKey('storage_version_delete_cancel'),
        );
        final confirm = find.byKey(
          const ValueKey('storage_version_delete_confirm'),
        );
        expect(cancel.hitTestable(), findsOneWidget);
        expect(confirm.hitTestable(), findsOneWidget);
        final dialog = tester.widget<AlertDialog>(find.byType(AlertDialog));
        final dialogContext = tester.element(find.byType(AlertDialog));
        expect(dialog.backgroundColor, dialogContext.tasksTheme.canvas);
        expect(dialog.surfaceTintColor, Colors.transparent);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(results, [false]);
        await tester.tap(find.byKey(const ValueKey('open_confirmation')));
        await tester.pumpAndSettle();
        await tester.tap(confirm);
        await tester.pumpAndSettle();
        expect(results, [false, true]);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
