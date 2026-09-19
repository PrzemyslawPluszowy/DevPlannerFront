import 'package:devplanner/workspaces/presentation/tasks/board/viewport/kanban_auto_scroll_coordinator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KanbanAutoScrollCoordinator', () {
    late KanbanAutoScrollCoordinator coordinator;

    setUp(() {
      coordinator = KanbanAutoScrollCoordinator();
    });

    tearDown(() {
      coordinator.endDrag();
    });

    test('rejestruje i wyrejestrowuje poziomy kontroler tablicy', () {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      coordinator.registerBoardController(controller);
      coordinator.unregisterBoardController(controller);

      coordinator.endDrag();
    });

    test(
      'inicjalizuje drag ze stoperem i przyjmuje uaktualnienia wskaźnika',
      () {
        const vsync = TestVSync();
        coordinator.startDrag(vsync, const Offset(100, 100));
        coordinator.updatePointer(const Offset(120, 150));
        coordinator.endDrag();
      },
    );

    testWidgets(
      'poprawnie integruje się z KanbanAutoScrollScope w drzewie widgetów',
      (tester) async {
        KanbanAutoScrollCoordinator? scopedCoordinator;

        await tester.pumpWidget(
          MaterialApp(
            home: KanbanAutoScrollScope(
              coordinator: coordinator,
              child: Builder(
                builder: (context) {
                  scopedCoordinator = KanbanAutoScrollScope.of(context);
                  return const SizedBox();
                },
              ),
            ),
          ),
        );

        expect(scopedCoordinator, equals(coordinator));
      },
    );
  });
}
