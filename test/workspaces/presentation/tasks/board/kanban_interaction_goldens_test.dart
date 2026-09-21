import 'dart:io';

import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart'
    show KanbanAssigneeColumn, KanbanColumnWidget, KanbanTaskCard;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Goldeny karty Kanban, stanów interakcji i kolumn.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final fontLoader = FontLoader('Inter');
    for (final file in const [
      'assets/fonts/Inter-Regular.ttf',
      'assets/fonts/Inter-SemiBold.ttf',
      'assets/fonts/Inter-Bold.ttf',
    ]) {
      if (File(file).existsSync()) {
        fontLoader.addFont(File(file).readAsBytes().then(ByteData.sublistView));
      }
    }
    await fontLoader.load();
  });

  final themes = <String, ThemeData>{
    'light': MaterialTheme.crm().light(),
    'dark': MaterialTheme.crm().dark(),
  };
  final densities = <String, KanbanCardDensity>{
    'compact': KanbanCardDensity.compact,
    'comfortable': KanbanCardDensity.comfortable,
    'detailed': KanbanCardDensity.detailed,
  };

  KanbanTaskCardResponse task({bool withAssignee = true}) =>
      KanbanTaskCardResponse(
        id: 'task-1',
        number: 101,
        taskCode: 'TASK-101',
        title: 'Przygotować podgląd szablonu dla kreatora projektu',
        status: ProjectTaskStatus.inProgress,
        priority: TaskPriority.high,
        position: 1000,
        checklistTotal: 3,
        checklistCompleted: 1,
        attachmentCount: 1,
        version: 7,
        dueAtUtc: DateTime.utc(2026, 9, 24),
        primaryAssigneeUserId: withAssignee ? 'user-1' : null,
        assigneeUserIds: withAssignee ? const ['user-1', 'user-2'] : const [],
        labels: const [
          KanbanCardLabelResponse(id: 'label-1', name: 'UX', color: '#6C5CE7'),
        ],
        isPinned: true,
        watcherCount: 2,
        isWatchedByMe: true,
      );

  KanbanTaskCardResponse plainTask() => const KanbanTaskCardResponse(
    id: 'task-status-1',
    number: 7,
    taskCode: 'TASK-7',
    title: 'Karta w kolumnie statusu',
    status: ProjectTaskStatus.todo,
    priority: TaskPriority.normal,
    position: 1000,
    checklistTotal: 0,
    checklistCompleted: 0,
    attachmentCount: 0,
    version: 2,
  );

  KanbanBoardResponse statusBoard() => KanbanBoardResponse(
    projectId: 'project-1',
    swimlaneMode: KanbanSwimlaneMode.none,
    settingsVersion: 1,
    hiddenColumns: const [],
    visibleCardFields: const [KanbanCardField.assignee],
    defaultCardDensity: KanbanCardDensity.comfortable,
    columns: [
      KanbanColumnResponse(
        status: ProjectTaskStatus.todo,
        displayName: 'Do zrobienia',
        color: '#6C5CE7',
        totalTaskCount: 1,
        isWipLimitExceeded: false,
        tasks: [plainTask()],
      ),
    ],
  );

  AssigneeKanbanGroupResponse group({
    required String? assigneeUserId,
    required String displayName,
    required List<KanbanTaskCardResponse> tasks,
    bool isCurrentUser = false,
  }) => AssigneeKanbanGroupResponse(
    assigneeUserId: assigneeUserId,
    displayName: displayName,
    isCurrentUser: isCurrentUser,
    totalTaskCount: tasks.length,
    tasks: tasks,
  );

  TasksBoardReady ready({
    required TasksBoardGrouping grouping,
    required List<AssigneeKanbanGroupResponse> groups,
  }) => TasksBoardReady(
    board: statusBoard(),
    connectionState: WorkspaceSignalRConnectionState.disconnected,
    presence: const [],
    grouping: grouping,
    assigneeBoard: AssigneeKanbanBoardResponse(
      projectId: 'project-1',
      grouping: KanbanSwimlaneMode.assignee,
      settingsVersion: 1,
      visibleCardFields: const [KanbanCardField.assignee],
      defaultCardDensity: KanbanCardDensity.comfortable,
      groups: groups,
    ),
  );

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    required ThemeData theme,
    double width = 290,
    double textScale = 1.0,
    bool disableAnimations = false,
    bool highContrast = false,
  }) async {
    tester.view.physicalSize = Size(width + 40, 700);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: MediaQueryData(
            size: Size(width + 40, 700),
            textScaler: TextScaler.linear(textScale),
            disableAnimations: disableAnimations,
            highContrast: highContrast,
          ),
          child: Scaffold(
            backgroundColor: theme.colorScheme.surfaceContainerLow,
            body: Center(
              child: SizedBox(width: width, child: child),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final theme in themes.entries) {
    for (final density in densities.entries) {
      testWidgets('golden karty: ${density.key} ${theme.key}', (tester) async {
        await pump(
          tester,
          KanbanTaskCard(
            task: task(),
            workspaceId: 'w',
            projectId: 'p',
            visibleCardFields: const [
              KanbanCardField.assignee,
              KanbanCardField.dueDate,
              KanbanCardField.labels,
              KanbanCardField.checklist,
              KanbanCardField.timeTracking,
              KanbanCardField.blockers,
              KanbanCardField.customFields,
            ],
            density: density.value,
            isSelected: false,
            memberProfilesByUserId: const {},
          ),
          theme: theme.value,
        );

        await expectLater(
          find.byType(KanbanTaskCard),
          matchesGoldenFile(
            'goldens/k1/density-${density.key}-${theme.key}.png',
          ),
        );
      });
    }
  }

  final states = <String, ({bool isSelected, bool isPending, bool hasError})>{
    'rest': (isSelected: false, isPending: false, hasError: false),
    'selected': (isSelected: true, isPending: false, hasError: false),
    'pending': (isSelected: false, isPending: true, hasError: false),
    'error': (isSelected: false, isPending: false, hasError: true),
  };

  for (final theme in themes.entries) {
    for (final state in states.entries) {
      testWidgets('golden stanu karty: ${state.key} ${theme.key}', (
        tester,
      ) async {
        await pump(
          tester,
          KanbanTaskCard(
            task: task(),
            workspaceId: 'w',
            projectId: 'p',
            visibleCardFields: const [
              KanbanCardField.assignee,
              KanbanCardField.dueDate,
            ],
            density: KanbanCardDensity.comfortable,
            isSelected: state.value.isSelected,
            isPending: state.value.isPending,
            hasError: state.value.hasError,
            memberProfilesByUserId: const {},
            statusBadge: const (label: 'W toku', color: Color(0xFF0984E3)),
          ),
          theme: theme.value,
        );

        await expectLater(
          find.byType(KanbanTaskCard),
          matchesGoldenFile('goldens/k1/state-${state.key}-${theme.key}.png'),
        );
      });
    }

    testWidgets('golden focusa karty ${theme.key}', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await pump(
        tester,
        KanbanTaskCard(
          task: task(),
          workspaceId: 'w',
          projectId: 'p',
          visibleCardFields: const [KanbanCardField.assignee],
          density: KanbanCardDensity.comfortable,
          isSelected: false,
          memberProfilesByUserId: const {},
          focusNode: focusNode,
        ),
        theme: theme.value,
      );
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(KanbanTaskCard),
        matchesGoldenFile('goldens/k1/state-focused-${theme.key}.png'),
      );
    });
  }

  testWidgets('reduced motion wyłącza animację karty', (tester) async {
    Future<Duration> durationFor({required bool reduceMotion}) async {
      await pump(
        tester,
        KanbanTaskCard(
          task: task(),
          workspaceId: 'w',
          projectId: 'p',
          visibleCardFields: const [KanbanCardField.assignee],
          density: KanbanCardDensity.comfortable,
          isSelected: false,
          memberProfilesByUserId: const {},
        ),
        theme: themes['light']!,
        disableAnimations: reduceMotion,
      );
      return tester
          .widget<AnimatedContainer>(
            find
                .descendant(
                  of: find.byType(KanbanTaskCard),
                  matching: find.byType(AnimatedContainer),
                )
                .first,
          )
          .duration;
    }

    expect(
      await durationFor(reduceMotion: false),
      const Duration(milliseconds: 140),
    );
    expect(
      await durationFor(reduceMotion: true),
      Duration.zero,
      reason: 'systemowe „ogranicz animacje” nie może zostawiać mrugania',
    );
  });

  testWidgets('wysoki kontrast wzmacnia przerywaną ramkę kafelka', (
    tester,
  ) async {
    expect(
      KanbanCardTokens.cardDashedBorderRest(
        themes['light']!.colorScheme,
        isDark: false,
        highContrast: true,
      ),
      KanbanCardTokens.cardBorderHighContrast(themes['light']!.colorScheme),
      reason: 'wysoki kontrast nie może zostawić subtelnej alfy obrysu',
    );

    await pump(
      tester,
      KanbanTaskCard(
        task: task(),
        workspaceId: 'w',
        projectId: 'p',
        visibleCardFields: const [
          KanbanCardField.assignee,
          KanbanCardField.dueDate,
        ],
        density: KanbanCardDensity.comfortable,
        isSelected: false,
        memberProfilesByUserId: const {},
      ),
      theme: themes['light']!,
      highContrast: true,
    );

    await expectLater(
      find.byType(KanbanTaskCard),
      matchesGoldenFile('goldens/k1/high-contrast-light.png'),
    );
  });

  final columnStates = <String, ({TasksBoardReady state, int groupIndex})>{
    'status': (
      state: ready(
        grouping: TasksBoardGrouping.status,
        groups: [
          group(
            assigneeUserId: null,
            displayName: 'Nieprzypisane',
            tasks: const [],
          ),
        ],
      ),
      groupIndex: 0,
    ),
    'assignee': (
      state: ready(
        grouping: TasksBoardGrouping.assignee,
        groups: [
          group(
            assigneeUserId: null,
            displayName: 'Nieprzypisane',
            tasks: [task(withAssignee: false)],
          ),
          group(
            assigneeUserId: 'user-1',
            displayName: 'Przemysław Nowak',
            isCurrentUser: true,
            tasks: [task()],
          ),
        ],
      ),
      groupIndex: 1,
    ),
    'unassigned': (
      state: ready(
        grouping: TasksBoardGrouping.assignee,
        groups: [
          group(
            assigneeUserId: null,
            displayName: 'Nieprzypisane',
            tasks: [task(withAssignee: false)],
          ),
        ],
      ),
      groupIndex: 0,
    ),
    'empty': (
      state: ready(
        grouping: TasksBoardGrouping.assignee,
        groups: [
          group(
            assigneeUserId: 'user-2',
            displayName: 'Marta Zielińska',
            tasks: const [],
          ),
        ],
      ),
      groupIndex: 0,
    ),
  };

  for (final theme in themes.entries) {
    for (final column in columnStates.entries) {
      testWidgets('golden kolumny: ${column.key} ${theme.key}', (tester) async {
        final state = column.value.state;
        final isStatus = column.key == 'status';
        await pump(
          tester,
          BlocProvider<TasksBoardCubit>.value(
            value: _cubit(),
            child: SizedBox(
              width: 308,
              height: 600,
              child: isStatus
                  ? KanbanColumnWidget(
                      workspaceId: 'w',
                      projectId: 'p',
                      column: state.board.columns.first,
                      visibleCardFields: const [KanbanCardField.assignee],
                      density: KanbanCardDensity.comfortable,
                      selectedTaskIds: const {},
                      pendingTaskIds: const {},
                      memberProfilesByUserId: const {},
                      isCollapsed: false,
                      onToggleCollapsed: () {},
                      isLoadingMore: false,
                    )
                  : KanbanAssigneeColumn(
                      workspaceId: 'w',
                      projectId: 'p',
                      state: state,
                      group:
                          state.assigneeBoard!.groups[column.value.groupIndex],
                    ),
            ),
          ),
          theme: theme.value,
          width: 308,
        );

        await expectLater(
          find.byType(isStatus ? KanbanColumnWidget : KanbanAssigneeColumn),
          matchesGoldenFile('goldens/k1/column-${column.key}-${theme.key}.png'),
        );
      });
    }
  }
}

TasksBoardCubit _cubit() => TasksBoardCubit(
  _UnusedRepository(),
  _UnusedRealtime(),
  _UnusedTasksRepository(),
  workspaceId: 'w',
  projectId: 'p',
);

final class _UnusedRepository implements KanbanRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('golden nie używa repozytorium');
}

final class _UnusedTasksRepository implements TasksRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('golden nie używa repozytorium');
}

final class _UnusedRealtime implements TaskProjectRealtime {
  @override
  Stream<TaskProjectRealtimeUpdate> get updates =>
      const Stream<TaskProjectRealtimeUpdate>.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('golden nie używa realtime');
}
