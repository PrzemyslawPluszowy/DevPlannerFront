import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/app/shell/overlay/app_modal_coordinator.dart';
import 'package:ready_next/app/shell/overlay/app_modal_host.dart';
import 'package:ready_next/shared/presentation/widgets/app_bubble_toast.dart';

void main() {
  testWidgets('toast oczekuje pod aktywną barierą modalną', (tester) async {
    final coordinator = AppModalCoordinator();
    final toastController = AppBubbleToastController(coordinator);
    addTearDown(toastController.dispose);
    addTearDown(coordinator.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: AppModalCoordinatorScope(
          coordinator: coordinator,
          child: AppBubbleToastScope(
            controller: toastController,
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Column(
                    children: [
                      FilledButton(
                        onPressed: () {
                          AppBubbleToast.show(
                            context,
                            message: 'Bieżący toast',
                            duration: const Duration(minutes: 1),
                          );
                        },
                        child: const Text('Pokaż toast'),
                      ),
                      FilledButton(
                        onPressed: () {
                          AppModalHost.showDialog<void>(
                            context,
                            builder: (dialogContext) {
                              return AlertDialog(
                                content: const Text('Modal aktywny'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      AppBubbleToast.show(
                                        dialogContext,
                                        message: 'Pierwszy toast po modalu',
                                        duration: const Duration(minutes: 1),
                                      );
                                    },
                                    child: const Text(
                                      'Kolejkuj pierwszy toast',
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      AppBubbleToast.show(
                                        dialogContext,
                                        message: 'Drugi toast po modalu',
                                        duration: const Duration(minutes: 1),
                                      );
                                    },
                                    child: const Text('Kolejkuj drugi toast'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(dialogContext).pop(),
                                    child: const Text('Zamknij modal'),
                                  ),
                                ],
                              );
                            },
                          ).ignore();
                        },
                        child: const Text('Otwórz modal'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Pokaż toast'));
    await tester.pumpAndSettle();
    expect(find.text('Bieżący toast'), findsOneWidget);

    await tester.tap(find.text('Otwórz modal'));
    await tester.pumpAndSettle();
    expect(find.byType(ModalBarrier), findsAtLeastNWidgets(1));
    expect(find.text('Bieżący toast'), findsNothing);

    await tester.tap(find.text('Kolejkuj pierwszy toast'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kolejkuj drugi toast'));
    await tester.pumpAndSettle();
    expect(find.text('Pierwszy toast po modalu'), findsNothing);
    expect(find.text('Drugi toast po modalu'), findsNothing);

    await tester.tap(find.text('Zamknij modal'));
    await tester.pumpAndSettle();
    expect(find.text('Pierwszy toast po modalu'), findsOneWidget);
    expect(find.text('Drugi toast po modalu'), findsNothing);

    await tester.tap(find.text('Pierwszy toast po modalu'));
    await tester.pumpAndSettle();
    expect(find.text('Pierwszy toast po modalu'), findsNothing);
    expect(find.text('Drugi toast po modalu'), findsOneWidget);

    toastController.dismiss();
    await tester.pump();
  });
}
