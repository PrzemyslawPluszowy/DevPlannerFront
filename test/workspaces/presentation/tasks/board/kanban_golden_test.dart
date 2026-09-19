import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

final class _DummyTasksRepository implements TasksRepository {
  @override
  Future<Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>>
  listProjectTasks({
    required String workspaceId,
    required String projectId,
    ProjectTasksQuery query = const ProjectTasksQuery(),
  }) async {
    return const Right(
      CursorPageResponse<ProjectTaskListItemResponse>(items: []),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

TasksBoardReady _createGoldenState() => const TasksBoardReady(
  board: KanbanBoardResponse(
    projectId: 'p-1',
    swimlaneMode: KanbanSwimlaneMode.none,
    settingsVersion: 1,
    hiddenColumns: [],
    visibleCardFields: [
      KanbanCardField.assignee,
      KanbanCardField.dueDate,
      KanbanCardField.subtasks,
    ],
    defaultCardDensity: KanbanCardDensity.comfortable,
    columns: [
      KanbanColumnResponse(
        status: ProjectTaskStatus.todo,
        displayName: 'Do zrobienia',
        color: '#2563EB',
        totalTaskCount: 5,
        isWipLimitExceeded: false,
        tasks: [],
      ),
      KanbanColumnResponse(
        status: ProjectTaskStatus.inProgress,
        displayName: 'W toku',
        color: '#F59E0B',
        totalTaskCount: 3,
        isWipLimitExceeded: false,
        tasks: [],
      ),
    ],
  ),
  userPreference: UserKanbanPreferenceResponse(
    workspaceId: 'w-1',
    projectId: 'p-1',
    userId: 'user-1',
    version: 1,
    collapsedColumns: [],
    collapsedCustomStatusIds: [],
    quickFilter: KanbanQuickFilter.all,
  ),
  presence: [],
  connectionState: WorkspaceSignalRConnectionState.connected,
  memberProfilesByUserId: {
    'user-1': ProjectMemberProfile(
      userId: 'user-1',
      displayName: 'Jan Kowalski',
      role: ProjectRole.admin,
    ),
    'user-2': ProjectMemberProfile(
      userId: 'user-2',
      displayName: 'Anna Nowak',
      role: ProjectRole.member,
    ),
  },
);

KanbanTaskCardResponse _createGoldenTask() => const KanbanTaskCardResponse(
  id: 'task-100',
  number: 100,
  taskCode: 'EX-100',
  title: 'Implementacja zwartego nagłówka i hierarchii kart',
  status: ProjectTaskStatus.inProgress,
  priority: TaskPriority.high,
  position: 1000,
  primaryAssigneeUserId: 'user-1',
  checklistTotal: 4,
  checklistCompleted: 2,
  attachmentCount: 1,
  subtaskTotal: 4,
  subtaskCompleted: 1,
  watcherCount: 2,
  version: 1,
);

Widget _buildGoldenHeaderApp({
  required TasksBoardReady state,
  required double width,
  required ThemeData theme,
}) => MaterialApp(
  theme: theme,
  locale: const Locale('pl'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: MediaQuery(
    data: MediaQueryData(size: Size(width, 800)),
    child: Scaffold(
      body: SizedBox(
        width: width,
        child: RepaintBoundary(
          key: const ValueKey('golden_header_boundary'),
          child: TasksBoardHeader(
            state: state,
            workspaceId: 'w-1',
            projectId: 'p-1',
            view: TasksProjectView.board,
            onViewChanged: (_) {},
          ),
        ),
      ),
    ),
  ),
);

Widget _buildGoldenCardApp({
  required KanbanTaskCardResponse task,
  required ThemeData theme,
  double cardWidth = 308.0,
}) => RepositoryProvider<TasksRepository>.value(
  value: _DummyTasksRepository(),
  child: MaterialApp(
    theme: theme,
    locale: const Locale('pl'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: MediaQuery(
      data: const MediaQueryData(size: Size(1280, 800)),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surfaceContainerLow,
        body: Center(
          child: SizedBox(
            width: cardWidth,
            child: RepaintBoundary(
              key: const ValueKey('golden_card_boundary'),
              child: KanbanTaskCard(
                task: task,
                workspaceId: 'w-1',
                projectId: 'p-1',
                visibleCardFields: const [
                  KanbanCardField.assignee,
                  KanbanCardField.dueDate,
                  KanbanCardField.subtasks,
                ],
                density: KanbanCardDensity.comfortable,
                isSelected: false,
                memberProfilesByUserId: const {},
              ),
            ),
          ),
        ),
      ),
    ),
  ),
);

void main() {
  final lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.light,
    colorSchemeSeed: const Color(0xFF6C5CE7),
  );

  final darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.dark,
    colorSchemeSeed: const Color(0xFF6C5CE7),
  );

  group('Kanban Golden Tests — regresja wizualna', () {
    testWidgets('Header desktop 1280px matches golden file', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final state = _createGoldenState();
      await tester.pumpWidget(
        _buildGoldenHeaderApp(state: state, width: 1280, theme: lightTheme),
      );
      await tester.pumpAndSettle();

      final headerBox =
          tester.renderObject(find.byType(TasksBoardHeader)) as RenderBox;
      // Weryfikacja kryterium planu: zwarty nagłówek na desktopie <= 52.0 px
      expect(headerBox.size.height, lessThanOrEqualTo(52.0));
      expect(headerBox.size.height, greaterThanOrEqualTo(40.0));

      await expectLater(
        find.byKey(const ValueKey('golden_header_boundary')),
        matchesGoldenFile('goldens/header_desktop_1280.png'),
      );
    });

    testWidgets('Card comfortable light matches golden file', (tester) async {
      final task = _createGoldenTask();
      await tester.pumpWidget(
        _buildGoldenCardApp(task: task, theme: lightTheme),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byKey(const ValueKey('golden_card_boundary')),
        matchesGoldenFile('goldens/card_comfortable_light.png'),
      );
    });

    testWidgets('Card comfortable dark matches golden file', (tester) async {
      final task = _createGoldenTask();
      await tester.pumpWidget(
        _buildGoldenCardApp(task: task, theme: darkTheme),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byKey(const ValueKey('golden_card_boundary')),
        matchesGoldenFile('goldens/card_comfortable_dark.png'),
      );
    });
  });
}
