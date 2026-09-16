import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/app/shell/overlay/app_modal_coordinator.dart';
import 'package:ready_next/app/shell/overlay/app_modal_host.dart';

/// Host testowy weryfikujący lifecycle focusu bez zależności od modułu.
class _ModalHostHarness extends StatefulWidget {
  const _ModalHostHarness();

  @override
  State<_ModalHostHarness> createState() => _ModalHostHarnessState();
}

class _ModalHostHarnessState extends State<_ModalHostHarness> {
  final FocusNode _activatorFocus = FocusNode(debugLabel: 'modal-activator');

  @override
  void dispose() {
    _activatorFocus.dispose();
    super.dispose();
  }

  void _openSideSheet() {
    unawaited(
      AppModalHost.showSideSheet<void>(
        context,
        builder: (context) => Align(
          alignment: Alignment.centerRight,
          child: Material(
            child: SizedBox(
              width: 320,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    key: const ValueKey<String>('modal-first-action'),
                    onPressed: () {},
                    child: const Text('Pierwsza akcja'),
                  ),
                  TextButton(
                    key: const ValueKey<String>('modal-second-action'),
                    onPressed: () {},
                    child: const Text('Druga akcja'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          key: const ValueKey<String>('modal-activator'),
          focusNode: _activatorFocus,
          onPressed: _openSideSheet,
          child: const Text('Otwórz panel'),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Escape zamyka side sheet i przywraca fokus aktywatora', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: _ModalHostHarness()));
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.text('Pierwsza akcja'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    expect(
      tester
          .widget<TextButton>(
            find.byKey(const ValueKey<String>('modal-activator')),
          )
          .focusNode!
          .hasFocus,
      isFalse,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();

    expect(find.text('Pierwsza akcja'), findsNothing);
    final activator = tester.widget<TextButton>(
      find.byKey(const ValueKey<String>('modal-activator')),
    );
    expect(activator.focusNode!.hasFocus, isTrue);
  });

  testWidgets('koordynator sesji odrzuca drugi równoległy modal', (
    tester,
  ) async {
    final coordinator = AppModalCoordinator();
    addTearDown(coordinator.dispose);
    late BuildContext modalContext;
    await tester.pumpWidget(
      MaterialApp(
        home: AppModalCoordinatorScope(
          coordinator: coordinator,
          child: Builder(
            builder: (context) {
              modalContext = context;
              return const Scaffold(body: SizedBox.expand());
            },
          ),
        ),
      ),
    );

    unawaited(
      AppModalHost.showDialog<void>(
        modalContext,
        builder: (_) => const AlertDialog(content: Text('Pierwszy modal')),
      ),
    );
    await tester.pumpAndSettle();
    final rootOverlayContext = tester.element(find.text('Pierwszy modal'));
    final rejected = AppModalHost.showDialog<Object?>(
      rootOverlayContext,
      builder: (_) => const AlertDialog(content: Text('Drugi modal')),
    );
    expect(await rejected, isNull);
    expect(find.text('Drugi modal'), findsNothing);
    expect(coordinator.isPresenting, isTrue);

    Navigator.of(modalContext, rootNavigator: true).pop();
    await tester.pumpAndSettle();
    expect(coordinator.isPresenting, isFalse);

    unawaited(
      AppModalHost.showDialog<void>(
        modalContext,
        builder: (_) => const AlertDialog(content: Text('Modal po zamknięciu')),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Modal po zamknięciu'), findsOneWidget);
  });
}
