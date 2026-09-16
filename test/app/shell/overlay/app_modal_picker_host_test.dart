import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/app/shell/overlay/app_modal_picker_host.dart';

/// Obserwator zapamiętujący route'y dodane do konkretnego navigatora testowego.
class _PickerRouteObserver extends NavigatorObserver {
  final List<Route<dynamic>> pushedRoutes = <Route<dynamic>>[];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    pushedRoutes.add(route);
    super.didPush(route, previousRoute);
  }
}

/// Harness tworzący zagnieżdżony navigator, z którego otwierany jest picker.
class _PickerHostHarness extends StatelessWidget {
  const _PickerHostHarness({
    required this.nestedObserver,
    required this.onOpen,
  });

  final NavigatorObserver nestedObserver;
  final Future<void> Function(BuildContext context) onOpen;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Navigator(
      observers: [nestedObserver],
      onGenerateRoute: (_) => MaterialPageRoute<void>(
        builder: (context) => Center(
          child: FilledButton(
            onPressed: () => unawaited(onOpen(context)),
            child: const Text('Otwórz picker'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('picker daty jest route rootowego navigatora', (tester) async {
    final rootObserver = _PickerRouteObserver();
    final nestedObserver = _PickerRouteObserver();
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [rootObserver],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('pl')],
        home: _PickerHostHarness(
          nestedObserver: nestedObserver,
          onOpen: (context) async {
            await AppModalPickerHost.showDate(
              context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDate: DateTime(2026),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    rootObserver.pushedRoutes.clear();
    nestedObserver.pushedRoutes.clear();

    await tester.tap(find.text('Otwórz picker'));
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsOneWidget);
    expect(rootObserver.pushedRoutes, hasLength(1));
    expect(nestedObserver.pushedRoutes, isEmpty);
  });

  testWidgets('picker czasu zachowuje locale i custom builder na root route', (
    tester,
  ) async {
    final rootObserver = _PickerRouteObserver();
    final nestedObserver = _PickerRouteObserver();
    const builderKey = ValueKey<String>('time-picker-custom-builder');
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [rootObserver],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('pl')],
        home: _PickerHostHarness(
          nestedObserver: nestedObserver,
          onOpen: (context) async {
            await AppModalPickerHost.showTime(
              context,
              initialTime: const TimeOfDay(hour: 13, minute: 37),
              locale: const Locale('pl'),
              builder: (context, child) => Container(
                key: builderKey,
                child: child,
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    rootObserver.pushedRoutes.clear();
    nestedObserver.pushedRoutes.clear();

    await tester.tap(find.text('Otwórz picker'));
    await tester.pumpAndSettle();

    final timePicker = find.byType(TimePickerDialog);
    expect(timePicker, findsOneWidget);
    expect(find.byKey(builderKey), findsOneWidget);
    expect(
      Localizations.localeOf(tester.element(timePicker)),
      const Locale('pl'),
    );
    expect(rootObserver.pushedRoutes, hasLength(1));
    expect(nestedObserver.pushedRoutes, isEmpty);
  });
}
