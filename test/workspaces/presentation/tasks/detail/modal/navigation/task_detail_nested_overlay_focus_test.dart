import 'dart:async';

import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/shared/presentation/widgets/app_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'menu and nested dialog restore focus to modal action and then opener',
    (tester) async {
      final openerFocus = FocusNode(debugLabel: 'task-opener');
      final modalActionFocus = FocusNode(debugLabel: 'task-modal-action');
      addTearDown(openerFocus.dispose);
      addTearDown(modalActionFocus.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) => TextButton(
                  focusNode: openerFocus,
                  onPressed: () {
                    openerFocus.requestFocus();
                    unawaited(
                      DevPlannerModalHost.showDialog<void>(
                        context,
                        barrierDismissible: false,
                        builder: (modalContext) => _TaskModalHarness(
                          modalActionFocus: modalActionFocus,
                          onClose: () => Navigator.of(
                            modalContext,
                            rootNavigator: true,
                          ).pop(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Open task'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open task'));
      await tester.pumpAndSettle();
      expect(find.text('Task details'), findsOneWidget);

      await tester.tap(find.text('Task actions'));
      await tester.pumpAndSettle();
      expect(find.text('Edit task'), findsOneWidget);

      await tester.tap(find.text('Edit task'));
      await tester.pumpAndSettle();
      expect(find.text('Close confirmation'), findsOneWidget);

      await tester.tap(find.text('Close confirmation'));
      await tester.pumpAndSettle();
      expect(modalActionFocus.hasFocus, isTrue);

      await tester.tap(find.text('Close task'));
      await tester.pumpAndSettle();
      expect(openerFocus.hasFocus, isTrue);
      expect(find.text('Task details'), findsNothing);
    },
  );
}

final class _TaskModalHarness extends StatelessWidget {
  const _TaskModalHarness({
    required this.modalActionFocus,
    required this.onClose,
  });

  final FocusNode modalActionFocus;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Dialog(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Task details'),
          Builder(
            builder: (buttonContext) => Focus(
              focusNode: modalActionFocus,
              child: TextButton(
                onPressed: () async {
                  modalActionFocus.requestFocus();
                  final action = await AppContextMenu.select<String>(
                    buttonContext,
                    globalPosition: AppContextMenu.positionFor(buttonContext),
                    options: const [
                      AppContextMenuOption(
                        value: 'edit',
                        label: 'Edit task',
                      ),
                    ],
                  );
                  if (action != 'edit' || !buttonContext.mounted) return;
                  await DevPlannerModalHost.showDialog<void>(
                    buttonContext,
                    barrierDismissible: false,
                    builder: (context) => Dialog(
                      child: TextButton(
                        onPressed: () => Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pop(),
                        child: const Text('Close confirmation'),
                      ),
                    ),
                  );
                },
                child: const Text('Task actions'),
              ),
            ),
          ),
          TextButton(onPressed: onClose, child: const Text('Close task')),
        ],
      ),
    ),
  );
}
