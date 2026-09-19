import 'dart:io';
import 'dart:ui' as ui;

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
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

const _outputDir =
    '/Users/przemyslawnowak/.gemini/antigravity/brain/dd4c279c-efb6-4d69-a405-69e0d641e673/screenshots';

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

TasksBoardReady _createBaselineState() => const TasksBoardReady(
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
    'user-3': ProjectMemberProfile(
      userId: 'user-3',
      displayName: 'Piotr Wiśniewski',
      role: ProjectRole.member,
    ),
  },
);

KanbanTaskCardResponse _createSampleCardTask() => const KanbanTaskCardResponse(
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

Widget _buildBaselineHeaderApp({
  required TasksBoardReady state,
  required double width,
  required ThemeData theme,
  double textScale = 1.0,
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
    data: MediaQueryData(
      size: Size(width, 800),
      textScaler: TextScaler.linear(textScale),
    ),
    child: Scaffold(
      body: SizedBox(
        width: width,
        child: RepaintBoundary(
          key: const ValueKey('baseline_capture_header'),
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

Widget _buildBaselineCardApp({
  required KanbanTaskCardResponse task,
  required ThemeData theme,
  double cardWidth = 308.0,
  double textScale = 1.0,
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
      data: MediaQueryData(
        size: const Size(1280, 800),
        textScaler: TextScaler.linear(textScale),
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surfaceContainerLow,
        body: Center(
          child: SizedBox(
            width: cardWidth,
            child: RepaintBoundary(
              key: const ValueKey('baseline_capture_card'),
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

Future<void> _captureBaseline(
  WidgetTester tester,
  Key targetKey,
  String filename,
) async {
  await tester.runAsync(() async {
    final finder = find.byKey(targetKey);
    final element = finder.evaluate().single;
    final boundary = element.renderObject! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final bytes = byteData.buffer.asUint8List();
      final file = File('$_outputDir/$filename');
      file.writeAsBytesSync(bytes);
    }
  });
}

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

  group('Etap A — Baseline audit i ochrona regresji', () {
    const widths = [1440.0, 1280.0, 1024.0, 768.0];
    const textScales = [1.0, 1.25];

    for (final width in widths) {
      for (final textScale in textScales) {
        testWidgets(
          'Screenshot nagłówka: width=${width.toInt()}px, textScale=$textScale, Light & Dark',
          (tester) async {
            tester.view.physicalSize = Size(width, 800);
            tester.view.devicePixelRatio = 1.0;
            addTearDown(tester.view.resetPhysicalSize);
            addTearDown(tester.view.resetDevicePixelRatio);

            final state = _createBaselineState();

            // Light
            await tester.pumpWidget(
              _buildBaselineHeaderApp(
                state: state,
                width: width,
                theme: lightTheme,
                textScale: textScale,
              ),
            );
            await tester.pumpAndSettle();

            final headerBox =
                tester.renderObject(find.byType(TasksBoardHeader)) as RenderBox;
            final baselineHeight = headerBox.size.height;
            expect(baselineHeight, greaterThan(0));

            await _captureBaseline(
              tester,
              const ValueKey('baseline_capture_header'),
              'baseline_header_${width.toInt()}px_scale${textScale}_light.png',
            );

            // Dark
            await tester.pumpWidget(
              _buildBaselineHeaderApp(
                state: state,
                width: width,
                theme: darkTheme,
                textScale: textScale,
              ),
            );
            await tester.pumpAndSettle();

            await _captureBaseline(
              tester,
              const ValueKey('baseline_capture_header'),
              'baseline_header_${width.toInt()}px_scale${textScale}_dark.png',
            );
          },
        );
      }
    }

    testWidgets(
      'Pomiar i spis elementów bazowych nagłówka na desktopie 1280px',
      (
        tester,
      ) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final state = _createBaselineState();
        await tester.pumpWidget(
          _buildBaselineHeaderApp(
            state: state,
            width: 1280,
            theme: lightTheme,
          ),
        );
        await tester.pumpAndSettle();

        final headerBox =
            tester.renderObject(find.byType(TasksBoardHeader)) as RenderBox;
        // Weryfikacja kryterium planu: zwarty jednoliniowy nagłówek na desktopie <= 52 px (docelowo 44-48 px)
        expect(headerBox.size.height, greaterThanOrEqualTo(40.0));
        expect(headerBox.size.height, lessThanOrEqualTo(52.0));

        // Spis widocznych elementów w bazowym nagłówku
        expect(find.text('8'), findsOneWidget); // licznik zadań
        expect(find.text('Tablica'), findsOneWidget);
        expect(find.text('Lista'), findsOneWidget);
        expect(find.text('Timeline'), findsOneWidget);
      },
    );

    testWidgets('Screenshot bazowej karty: Light i Dark, skala 1.0 i 1.25', (
      tester,
    ) async {
      final sampleTask = _createSampleCardTask();

      // Light 1.0
      await tester.pumpWidget(
        _buildBaselineCardApp(
          task: sampleTask,
          theme: lightTheme,
        ),
      );
      await tester.pumpAndSettle();
      await _captureBaseline(
        tester,
        const ValueKey('baseline_capture_card'),
        'baseline_card_comfortable_light_scale1.0.png',
      );

      // Dark 1.0
      await tester.pumpWidget(
        _buildBaselineCardApp(
          task: sampleTask,
          theme: darkTheme,
        ),
      );
      await tester.pumpAndSettle();
      await _captureBaseline(
        tester,
        const ValueKey('baseline_capture_card'),
        'baseline_card_comfortable_dark_scale1.0.png',
      );

      // Light 1.25
      await tester.pumpWidget(
        _buildBaselineCardApp(
          task: sampleTask,
          theme: lightTheme,
          textScale: 1.25,
        ),
      );
      await tester.pumpAndSettle();
      await _captureBaseline(
        tester,
        const ValueKey('baseline_capture_card'),
        'baseline_card_comfortable_light_scale1.25.png',
      );
    });
  });
}
