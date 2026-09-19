import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

final class _DelayedMockTasksRepository implements TasksRepository {
  _DelayedMockTasksRepository({this.completer});

  final Completer<
    Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>
  >?
  completer;

  @override
  Future<Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>>
  listProjectTasks({
    required String workspaceId,
    required String projectId,
    ProjectTasksQuery query = const ProjectTasksQuery(),
  }) async {
    if (completer != null) {
      return completer!.future;
    }
    return Right(
      CursorPageResponse<ProjectTaskListItemResponse>(
        items: [
          ProjectTaskListItemResponse(
            id: 'sub-1',
            number: 102,
            key: 'EX-102',
            title: 'Podzadanie 1',
            status: ProjectTaskStatus.todo,
            priority: TaskPriority.normal,
            assignees: const [],
            checklistCompletedCount: 0,
            checklistTotalCount: 0,
            updatedAtUtc: DateTime.utc(2026, 9, 6),
            version: 1,
          ),
          ProjectTaskListItemResponse(
            id: 'sub-2',
            number: 103,
            key: 'EX-103',
            title: 'Podzadanie 2',
            status: ProjectTaskStatus.done,
            priority: TaskPriority.normal,
            assignees: const [],
            checklistCompletedCount: 0,
            checklistTotalCount: 0,
            updatedAtUtc: DateTime.utc(2026, 9, 6),
            version: 1,
          ),
        ],
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

KanbanTaskCardResponse _createSampleCard({
  String id = 'task-1',
  String title = 'Zadanie główne',
  int subtaskTotal = 2,
  int subtaskCompleted = 1,
}) => KanbanTaskCardResponse(
  id: id,
  number: 101,
  taskCode: 'EX-101',
  title: title,
  status: ProjectTaskStatus.todo,
  priority: TaskPriority.high,
  position: 1000,
  checklistTotal: 0,
  checklistCompleted: 0,
  attachmentCount: 0,
  subtaskTotal: subtaskTotal,
  subtaskCompleted: subtaskCompleted,
  version: 1,
);

Widget _buildTestApp({
  required Widget child,
  TasksRepository? tasksRepository,
}) {
  return RepositoryProvider<TasksRepository>.value(
    value: tasksRepository ?? _DelayedMockTasksRepository(),
    child: MaterialApp(
      locale: const Locale('pl'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(child: child),
      ),
    ),
  );
}

void main() {
  group('Kanban Visual Reset - Tokeny i Paintery', () {
    test('DottedRRectPainter poprawnie konfiguruje parametry punktowe', () {
      const painter = DottedRRectPainter(
        color: Colors.blue,
      );

      expect(painter.radius, KanbanCardTokens.cardRadius);
      expect(painter.dotDiameter, KanbanCardTokens.cardBorderDotDiameter);
      expect(painter.step, KanbanCardTokens.cardBorderDotSpacing);
      expect(painter.radius, 8.0);
      expect(painter.dotDiameter, 1.0);
      expect(painter.step, 4.0);
    });

    test('DottedHorizontalLinePainter poprawnie konfiguruje parametry', () {
      const painter = DottedHorizontalLinePainter(
        color: Colors.grey,
      );

      expect(painter.dotDiameter, 1.0);
      expect(painter.step, 4.0);
    });
  });

  group('Kanban Visual Reset - KanbanCardFrame', () {
    testWidgets('renderuje KanbanCardFrame z obrysem i dziecko', (
      tester,
    ) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const KanbanCardFrame(
            child: Text('Karta testowa'),
          ),
        ),
      );

      expect(find.text('Karta testowa'), findsOneWidget);
      expect(find.byType(KanbanCardFrame), findsOneWidget);
    });

    testWidgets('zmienia styl przy zaznaczeniu (isSelected)', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          child: const KanbanCardFrame(
            isSelected: true,
            child: Text('Zaznaczona karta'),
          ),
        ),
      );

      expect(find.text('Zaznaczona karta'), findsOneWidget);
      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(KanbanCardFrame),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.border, isNotNull);
    });
  });

  group('Kanban Visual Reset - Drag Preview', () {
    testWidgets(
      'renderuje się z użyciem KanbanDottedCardFrame i zlokalizowanym nagłówkiem',
      (
        tester,
      ) async {
        final task = _createSampleCard();
        await tester.pumpWidget(
          _buildTestApp(
            child: SizedBox(
              width: 280,
              child: KanbanCardDragPreview(
                task: task,
                density: KanbanCardDensity.comfortable,
                visibleCardFields: const [
                  KanbanCardField.subtasks,
                ],
                memberProfilesByUserId: const {},
              ),
            ),
          ),
        );

        expect(find.text('EX-101'), findsOneWidget);
        expect(find.text('Zadanie główne'), findsOneWidget);
        expect(find.textContaining('Podzadania (1/2)'), findsOneWidget);

        final frameFinder = find.byType(KanbanDottedCardFrame);
        expect(frameFinder, findsOneWidget);
      },
    );
  });

  group('Kanban Visual Reset - Skeleton Rows podczas ładowania', () {
    testWidgets(
      'wyświetla wiersze skeletonu zamiast spinnera podczas pobierania podzadań',
      (
        tester,
      ) async {
        final completer =
            Completer<
              Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>
            >();
        final repo = _DelayedMockTasksRepository(completer: completer);
        final task = _createSampleCard();

        await tester.pumpWidget(
          _buildTestApp(
            tasksRepository: repo,
            child: SizedBox(
              width: 280,
              child: KanbanCardSubtasksSection(
                task: task,
                workspaceId: 'w-1',
                projectId: 'p-1',
                memberProfilesByUserId: const {},
              ),
            ),
          ),
        );

        // Rozwinięcie sekcji podzadań
        await tester.tap(find.byKey(const ValueKey('subtasks_toggle_button')));
        await tester.pump(); // Początek ładowania

        // Brak spinnera CircularProgressIndicator
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // Zakończenie requestu
        completer.complete(
          Right(
            CursorPageResponse<ProjectTaskListItemResponse>(
              items: [
                ProjectTaskListItemResponse(
                  id: 'sub-1',
                  number: 102,
                  key: 'EX-102',
                  title: 'Podzadanie 1',
                  status: ProjectTaskStatus.todo,
                  priority: TaskPriority.normal,
                  assignees: const [],
                  checklistCompletedCount: 0,
                  checklistTotalCount: 0,
                  updatedAtUtc: DateTime.utc(2026, 9, 6),
                  version: 1,
                ),
              ],
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Po załadowaniu pojawia się treść podzadania
        expect(find.text('Podzadanie 1'), findsOneWidget);
      },
    );
  });
}
