import 'dart:async';

import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final sideSheet in [false, true]) {
    for (final brightness in Brightness.values) {
      testWidgets(
        'builder inherits caller theme: side=$sideSheet, $brightness',
        (tester) async {
          const rootAccent = Colors.red;
          const scopedAccent = Colors.blue;
          final root = ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: rootAccent,
              brightness: brightness,
            ).copyWith(primary: rootAccent),
          );
          final scoped = root.copyWith(
            colorScheme: root.colorScheme.copyWith(primary: scopedAccent),
          );
          await tester.pumpWidget(
            MaterialApp(
              theme: root,
              home: Scaffold(
                body: Theme(
                  data: scoped,
                  child: _ScopedLauncher(sideSheet: sideSheet),
                ),
              ),
            ),
          );
          await tester.tap(find.text('Open'));
          await tester.pumpAndSettle();
          expect(
            tester
                .widget<ColoredBox>(
                  find.byKey(const ValueKey('builder-accent')),
                )
                .color,
            scopedAccent,
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}

final class _ScopedLauncher extends StatelessWidget {
  const _ScopedLauncher({required this.sideSheet});

  final bool sideSheet;

  void _open(BuildContext context) {
    final show = sideSheet
        ? DevPlannerModalHost.showSideSheet<void>
        : DevPlannerModalHost.showDialog<void>;
    unawaited(show(context, builder: _content));
  }

  Widget _content(BuildContext context) => SizedBox(
    width: 180,
    height: 120,
    child: ColoredBox(
      key: const ValueKey('builder-accent'),
      color: Theme.of(context).colorScheme.primary,
    ),
  );

  @override
  Widget build(BuildContext context) =>
      TextButton(onPressed: () => _open(context), child: const Text('Open'));
}
