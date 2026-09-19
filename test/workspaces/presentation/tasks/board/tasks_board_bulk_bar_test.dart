import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/bulk/tasks_contextual_bulk_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

KanbanTaskCardResponse _card(String id, String title, int position) =>
    KanbanTaskCardResponse(
      id: id,
      number: 1,
      taskCode: 'DEV-1',
      title: title,
      status: ProjectTaskStatus.todo,
      priority: TaskPriority.normal,
      position: position,
      checklistTotal: 0,
      checklistCompleted: 0,
      attachmentCount: 0,
      version: 1,
    );

KanbanBoardResponse _board() => KanbanBoardResponse(
  projectId: 'project-1',
  swimlaneMode: KanbanSwimlaneMode.none,
  settingsVersion: 1,
  hiddenColumns: [],
  visibleCardFields: [],
  defaultCardDensity: KanbanCardDensity.comfortable,
  columns: [
    KanbanColumnResponse(
      status: ProjectTaskStatus.todo,
      displayName: 'Do zrobienia',
      color: '#2563EB',
      totalTaskCount: 2,
      isWipLimitExceeded: false,
      tasks: [
        _card('task-1', 'Pierwsze zadanie', 1),
        _card('task-2', 'Drugie zadanie', 2),
      ],
    ),
    const KanbanColumnResponse(
      status: ProjectTaskStatus.inProgress,
      displayName: 'W toku',
      color: '#F59E0B',
      totalTaskCount: 0,
      isWipLimitExceeded: false,
      tasks: [],
    ),
  ],
);

/// Repozytorium notujące akcje masowe boardu.
final class _FakeKanbanRepository implements KanbanRepository {
  BulkMoveKanbanTasksPayload? lastBulkMovePayload;
  BulkUpdateKanbanTasksPayload? lastBulkUpdatePayload;
  int bulkMoveCalls = 0;

  @override
  Future<Either<ApiError, KanbanBoardResponse>> getBoard({
    required String workspaceId,
    required String projectId,
    KanbanBoardFilter filter = KanbanBoardFilter.none,
  }) async => Right(_board());

  @override
  Future<Either<ApiError, UserKanbanPreferenceResponse>> getUserPreference({
    required String workspaceId,
    required String projectId,
  }) async => const Left(
    ApiError(type: ApiErrorType.notFound, message: 'Brak preferencji'),
  );

  @override
  Future<Either<ApiError, BulkMoveKanbanTasksResponse>> bulkMove({
    required String workspaceId,
    required String projectId,
    required BulkMoveKanbanTasksPayload payload,
  }) async {
    bulkMoveCalls++;
    lastBulkMovePayload = payload;
    return Right(
      BulkMoveKanbanTasksResponse(
        tasks: _board().columns.last.tasks,
        targetColumnTaskCount: 2,
        isWipLimitExceeded: false,
      ),
    );
  }

  @override
  Future<Either<ApiError, BulkUpdateKanbanTasksResponse>> bulkUpdate({
    required String workspaceId,
    required String projectId,
    required BulkUpdateKanbanTasksPayload payload,
  }) async {
    lastBulkUpdatePayload = payload;
    return const Right(
      BulkUpdateKanbanTasksResponse(tasks: [], updatedCount: 2),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FakeTasksRepository implements TasksRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _NoRealtime implements TaskProjectRealtime {
  @override
  Stream<TaskProjectRealtimeUpdate> get updates => const Stream.empty();

  @override
  Stream<WorkspaceSignalRConnectionState> get connectionStates =>
      const Stream.empty();

  @override
  Stream<WorkspaceScopedRealtimeError> get errors => const Stream.empty();

  @override
  Future<void> start({
    required String workspaceId,
    required String projectId,
  }) async {}

  @override
  Future<void> dispose() async {}
}

void main() {
  testWidgets('pasek Kanbanu to wspólny contextual bulk bar i wykonuje bulk move', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final repository = _FakeKanbanRepository();
    final cubit = TasksBoardCubit(
      repository,
      _NoRealtime(),
      _FakeTasksRepository(),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    addTearDown(cubit.close);
    await cubit.start();
    await tester.pump();

    await tester.pumpWidget(
      BlocProvider<TasksBoardCubit>.value(
        value: cubit,
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
            body: BlocBuilder<TasksBoardCubit, TasksBoardState>(
              builder: (context, state) => state is TasksBoardReady
                  ? TasksHeader(
                      state: state,
                      workspaceId: 'workspace-1',
                      projectId: 'project-1',
                      view: TasksProjectView.board,
                      onViewChanged: (_) {},
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Bez zaznaczenia wiersz poleceń pokazuje kontrolki widoku, nie akcje masowe.
    expect(find.byType(TasksContextualBulkBar), findsNothing);

    final ready = cubit.state as TasksBoardReady;
    ready.board.columns.first.tasks.forEach(cubit.toggleTaskSelection);
    await tester.pumpAndSettle();

    // Ten sam komponent co w Liście, z licznikiem z ARB.
    expect(find.byType(TasksContextualBulkBar), findsOneWidget);
    expect(find.text('Wybrano: 2'), findsOneWidget);
    expect(find.byKey(const ValueKey('board_bulk_move')), findsOneWidget);
    expect(find.byKey(const ValueKey('board_bulk_priority')), findsOneWidget);
    expect(find.byKey(const ValueKey('board_bulk_due_date')), findsOneWidget);

    // Przeniesienie zaznaczonych kart trafia do bulk move boardu.
    await tester.tap(find.byKey(const ValueKey('board_bulk_move')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('W toku').last);
    await tester.pumpAndSettle();

    expect(repository.bulkMoveCalls, 1);
    expect(
      repository.lastBulkMovePayload?.tasks.map((item) => item.taskId),
      containsAll(<String>['task-1', 'task-2']),
    );
    expect(
      repository.lastBulkMovePayload?.targetStatus,
      ProjectTaskStatus.inProgress,
    );
  });
}
