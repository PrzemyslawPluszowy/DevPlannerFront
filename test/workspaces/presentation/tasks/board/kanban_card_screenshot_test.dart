import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/kanban/models/kanban_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/shared/cursor_page_response.dart';
import 'package:ready_next/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_task_status.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_priority.dart';
import 'package:ready_next/workspaces/domain/models/project_member_profile.dart';
import 'package:ready_next/workspaces/domain/repositories/tasks_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/board/tasks_board_page.dart';

final class _MockTasksRepository implements TasksRepository {
  _MockTasksRepository({this.completer});

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
            number: 125,
            key: 'EX-125',
            title: 'Weryfikacja danych technicznych',
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
            number: 126,
            key: 'EX-126',
            title: 'Wycena i przygotowanie kosztorysu',
            status: ProjectTaskStatus.done,
            priority: TaskPriority.high,
            assignees: const [],
            checklistCompletedCount: 0,
            checklistTotalCount: 0,
            updatedAtUtc: DateTime.utc(2026, 9, 6),
            version: 1,
          ),
          ProjectTaskListItemResponse(
            id: 'sub-3',
            number: 127,
            key: 'EX-127',
            title: 'Załączniki i dokumentacja końcowa',
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
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

const _outputDir =
    '/Users/przemyslawnowak/.gemini/antigravity/brain/62bce781-3ebe-452c-8a14-06ebf3725e9f/screenshots';

KanbanTaskCardResponse _createSampleTask({
  String id = 'task-124',
  String title = 'Przygotować ofertę dla klienta',
  int subtaskTotal = 7,
  int subtaskCompleted = 3,
  TaskPriority priority = TaskPriority.high,
}) => KanbanTaskCardResponse(
  id: id,
  number: 124,
  taskCode: 'EX-124',
  title: title,
  status: ProjectTaskStatus.todo,
  priority: priority,
  position: 1000,
  dueAtUtc: DateTime.utc(2026, 9, 10, 14),
  primaryAssigneeCoreUserId: 'u-1',
  checklistTotal: 0,
  checklistCompleted: 0,
  attachmentCount: 2,
  subtaskTotal: subtaskTotal,
  subtaskCompleted: subtaskCompleted,
  isWatchedByMe: true,
  watcherCount: 3,
  version: 1,
);

final Map<String, ProjectMemberProfile> _sampleMembers = {
  'u-1': const ProjectMemberProfile(
    coreUserId: 'u-1',
    displayName: 'Anna Kowalska',
    role: ProjectRole.member,
  ),
};

Widget _buildWrapper({
  required Widget child,
  required ThemeData theme,
  double textScale = 1.0,
  TasksRepository? tasksRepository,
}) => RepositoryProvider<TasksRepository>.value(
  value: tasksRepository ?? _MockTasksRepository(),
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
        textScaler: TextScaler.linear(textScale),
        size: const Size(1280, 800),
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.surfaceContainerLow,
        body: Center(
          child: RepaintBoundary(
            key: const ValueKey('capture_target'),
            child: child,
          ),
        ),
      ),
    ),
  ),
);

Future<void> _capture(WidgetTester tester, String filename) async {
  await tester.runAsync(() async {
    final finder = find.byKey(const ValueKey('capture_target'));
    final element = finder.evaluate().single;
    final boundary = element.renderObject! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final bytes = byteData!.buffer.asUint8List();
    final file = File('$_outputDir/$filename');
    file.writeAsBytesSync(bytes);
  });
}

void main() {
  setUpAll(() async {
    final fontLoader = FontLoader('Inter');
    fontLoader.addFont(
      File('assets/fonts/Inter-Regular.ttf')
          .readAsBytes()
          .then(ByteData.sublistView),
    );
    fontLoader.addFont(
      File('assets/fonts/Inter-SemiBold.ttf')
          .readAsBytes()
          .then(ByteData.sublistView),
    );
    fontLoader.addFont(
      File('assets/fonts/Inter-Bold.ttf')
          .readAsBytes()
          .then(ByteData.sublistView),
    );
    await fontLoader.load();

    const symbolsPath =
        '/Users/przemyslawnowak/.pub-cache/hosted/pub.dev/material_symbols_icons-4.2960.0/lib/fonts/MaterialSymbolsRounded.ttf';
    if (File(symbolsPath).existsSync()) {
      final symbolLoader = FontLoader(
        'packages/material_symbols_icons/MaterialSymbolsRounded',
      );
      symbolLoader.addFont(
        File(symbolsPath).readAsBytes().then(ByteData.sublistView),
      );
      await symbolLoader.load();
    }

    const materialIconsPath =
        '/Users/Shared/flutter_sdk/flutter/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf';
    if (File(materialIconsPath).existsSync()) {
      final iconsLoader = FontLoader('MaterialIcons');
      iconsLoader.addFont(
        File(materialIconsPath).readAsBytes().then(ByteData.sublistView),
      );
      await iconsLoader.load();
    }
  });

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

  const defaultFields = [
    KanbanCardField.assignee,
    KanbanCardField.dueDate,
    KanbanCardField.subtasks,
  ];

  group('Visual Reset - Screenshoty i Weryfikacja Wizualna', () {
    testWidgets('Karta spoczynek (Resting) - Light 280px i 320px', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final task = _createSampleTask();

      // 280 px
      await tester.pumpWidget(
        _buildWrapper(
          theme: lightTheme,
          child: SizedBox(
            width: 280,
            child: KanbanTaskCard(
              task: task,
              workspaceId: 'w-1',
              projectId: 'p-1',
              visibleCardFields: defaultFields,
              density: KanbanCardDensity.comfortable,
              isSelected: false,
              memberProfilesByCoreUserId: _sampleMembers,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _capture(tester, 'card_resting_light_280.png');

      // 320 px
      await tester.pumpWidget(
        _buildWrapper(
          theme: lightTheme,
          child: SizedBox(
            width: 320,
            child: KanbanTaskCard(
              task: task,
              workspaceId: 'w-1',
              projectId: 'p-1',
              visibleCardFields: defaultFields,
              density: KanbanCardDensity.comfortable,
              isSelected: false,
              memberProfilesByCoreUserId: _sampleMembers,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _capture(tester, 'card_resting_light_320.png');
    });

    testWidgets('Karta spoczynek (Resting) - Dark 320px', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final task = _createSampleTask();

      await tester.pumpWidget(
        _buildWrapper(
          theme: darkTheme,
          child: SizedBox(
            width: 320,
            child: KanbanTaskCard(
              task: task,
              workspaceId: 'w-1',
              projectId: 'p-1',
              visibleCardFields: defaultFields,
              density: KanbanCardDensity.comfortable,
              isSelected: false,
              memberProfilesByCoreUserId: _sampleMembers,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _capture(tester, 'card_resting_dark_320.png');
    });

    testWidgets('Karta stany Hover, Selected - Light 320px', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final task = _createSampleTask();

      // Selected
      await tester.pumpWidget(
        _buildWrapper(
          theme: lightTheme,
          child: SizedBox(
            width: 320,
            child: KanbanTaskCard(
              task: task,
              workspaceId: 'w-1',
              projectId: 'p-1',
              visibleCardFields: defaultFields,
              density: KanbanCardDensity.comfortable,
              isSelected: true,
              memberProfilesByCoreUserId: _sampleMembers,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _capture(tester, 'card_selected_light_320.png');

      // Hover
      await tester.pumpWidget(
        _buildWrapper(
          theme: lightTheme,
          child: SizedBox(
            width: 320,
            child: KanbanDottedCardFrame(
              child: KanbanTaskCard(
                task: task,
                workspaceId: 'w-1',
                projectId: 'p-1',
                visibleCardFields: defaultFields,
                density: KanbanCardDensity.comfortable,
                isSelected: false,
                memberProfilesByCoreUserId: _sampleMembers,
              ),
            ),
          ),
        ),
      );
      final gesture = await tester.createGesture(
        kind: ui.PointerDeviceKind.mouse,
      );
      await gesture.addPointer(location: Offset.zero);
      await gesture.moveTo(
        tester.getCenter(find.byType(KanbanDottedCardFrame).first),
      );
      await tester.pump();
      await _capture(tester, 'card_hover_light_320.png');
    });

    testWidgets('Karta z rozwiniętymi podzadaniami - Light 320px', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final task = _createSampleTask();

      await tester.pumpWidget(
        _buildWrapper(
          theme: lightTheme,
          child: SizedBox(
            width: 320,
            child: KanbanTaskCard(
              task: task,
              workspaceId: 'w-1',
              projectId: 'p-1',
              visibleCardFields: defaultFields,
              density: KanbanCardDensity.comfortable,
              isSelected: false,
              memberProfilesByCoreUserId: _sampleMembers,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Rozwiń sekcję podzadań
      await tester.tap(find.byKey(const ValueKey('subtasks_toggle_button')));
      await tester.pumpAndSettle();
      await _capture(tester, 'card_expanded_subtasks_light_320.png');
    });

    testWidgets('Karta z rozwiniętymi podzadaniami - Dark 320px', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final task = _createSampleTask();

      await tester.pumpWidget(
        _buildWrapper(
          theme: darkTheme,
          child: SizedBox(
            width: 320,
            child: KanbanTaskCard(
              task: task,
              workspaceId: 'w-1',
              projectId: 'p-1',
              visibleCardFields: defaultFields,
              density: KanbanCardDensity.comfortable,
              isSelected: false,
              memberProfilesByCoreUserId: _sampleMembers,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('subtasks_toggle_button')));
      await tester.pumpAndSettle();
      await _capture(tester, 'card_expanded_subtasks_dark_320.png');
    });

    testWidgets('Karta Skeleton Rows (loading) i Drag Preview', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final completer =
          Completer<
            Either<ApiError, CursorPageResponse<ProjectTaskListItemResponse>>
          >();
      final repo = _MockTasksRepository(completer: completer);
      final task = _createSampleTask();

      // Skeleton rows
      await tester.pumpWidget(
        _buildWrapper(
          theme: lightTheme,
          tasksRepository: repo,
          child: SizedBox(
            width: 320,
            child: KanbanTaskCard(
              task: task,
              workspaceId: 'w-1',
              projectId: 'p-1',
              visibleCardFields: defaultFields,
              density: KanbanCardDensity.comfortable,
              isSelected: false,
              memberProfilesByCoreUserId: _sampleMembers,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('subtasks_toggle_button')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      await _capture(tester, 'card_loading_skeleton_320.png');

      // Drag preview
      await tester.pumpWidget(
        _buildWrapper(
          theme: lightTheme,
          child: SizedBox(
            width: 320,
            child: KanbanCardDragPreview(
              task: task,
              density: KanbanCardDensity.comfortable,
              visibleCardFields: defaultFields,
              memberProfilesByCoreUserId: _sampleMembers,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await _capture(tester, 'card_drag_preview_320.png');
    });

    testWidgets('Karta z powiększoną czcionką textScale=1.25 bez overflow', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final task = _createSampleTask(
        title: 'Bardzo długi tytuł zadania sprawdzający zachowanie przy skali 125% bez błędów overflow',
      );

      await tester.pumpWidget(
        _buildWrapper(
          theme: lightTheme,
          textScale: 1.25,
          child: SizedBox(
            width: 320,
            child: KanbanTaskCard(
              task: task,
              workspaceId: 'w-1',
              projectId: 'p-1',
              visibleCardFields: defaultFields,
              density: KanbanCardDensity.comfortable,
              isSelected: false,
              memberProfilesByCoreUserId: _sampleMembers,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Podzadania'));
      await tester.pumpAndSettle();
      await _capture(tester, 'card_text_scale_125_320.png');
    });

    testWidgets('Karta stan Focus - Light 320px', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final task = _createSampleTask();
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await tester.pumpWidget(
        _buildWrapper(
          theme: lightTheme,
          child: SizedBox(
            width: 320,
            child: KanbanTaskCard(
              task: task,
              workspaceId: 'w-1',
              projectId: 'p-1',
              visibleCardFields: defaultFields,
              density: KanbanCardDensity.comfortable,
              isSelected: false,
              memberProfilesByCoreUserId: _sampleMembers,
              focusNode: focusNode,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      await _capture(tester, 'card_focus_light_320.png');
    });

    testWidgets('Kolumna referencyjna - Light i Dark', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      Widget buildCol(ThemeData theme) {
        final colors = theme.colorScheme;
        return Container(
          width: 312,
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.outlineVariant.withValues(alpha: .5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: colors.outlineVariant.withValues(alpha: .4),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF00B894),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'W trakcie (In Progress)',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest.withValues(
                          alpha: .6,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '2',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Symbols.keyboard_arrow_left_rounded,
                      size: 18,
                      color: colors.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KanbanTaskCard(
                      task: _createSampleTask(
                        id: 'task-1',
                      ),
                      workspaceId: 'w-1',
                      projectId: 'p-1',
                      visibleCardFields: defaultFields,
                      density: KanbanCardDensity.comfortable,
                      isSelected: false,
                      memberProfilesByCoreUserId: _sampleMembers,
                    ),
                    const SizedBox(height: 8),
                    KanbanTaskCard(
                      task: _createSampleTask(
                        id: 'task-2',
                        title: 'Weryfikacja projektu technicznego',
                        priority: TaskPriority.normal,
                        subtaskTotal: 0,
                      ),
                      workspaceId: 'w-1',
                      projectId: 'p-1',
                      visibleCardFields: defaultFields,
                      density: KanbanCardDensity.comfortable,
                      isSelected: false,
                      memberProfilesByCoreUserId: _sampleMembers,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      // Light
      await tester.pumpWidget(
        _buildWrapper(
          theme: lightTheme,
          child: buildCol(lightTheme),
        ),
      );
      await tester.pumpAndSettle();
      await _capture(tester, 'column_reference_light.png');

      // Dark
      await tester.pumpWidget(
        _buildWrapper(
          theme: darkTheme,
          child: buildCol(darkTheme),
        ),
      );
      await tester.pumpAndSettle();
      await _capture(tester, 'column_reference_dark.png');
    });
  });
}
