import 'dart:io';
import 'dart:ui' as ui;

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_assignee_columns_preference.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_board_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cards/kanban_card_tokens.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_columns_viewport.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart'
    show
        KanbanAssigneeColumn,
        KanbanAssigneeColumnsViewport,
        KanbanBoardGroupingBar,
        KanbanColumnWidget,
        KanbanTaskCard;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Baseline pakietu K0 dla widoku Kanban grupowanego po osobach.
///
/// Test zapisuje zrzuty obu grupowań w motywie jasnym i ciemnym oraz przy
/// skalowaniu tekstu 100%, 150% i 200%, mierzy wymiary kolumn i kart, a także
/// dowodzi, że o rendererze decyduje przełącznik widoku, a nie zapisane
/// w projekcie `swimlaneMode`. Skalowanie 200% jest realnym testem dostępności:
/// przekroczenie układu zgłasza wyjątek Fluttera i wywraca test.
const _outputDir = 'docs/recovery/visual-captures/k0';

const _scales = <double>[1.0, 1.5, 2.0];

/// Ustawia okno testowe na rozmiar baseline'u, żeby zrzut nie był przycięty do
/// domyślnych 800x600 i pokazywał całe poziome pasmo kolumn.
void _sizeWindow(
  WidgetTester tester, {
  double width = 1440,
  double height = 900,
}) {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _capture(WidgetTester tester, String filename) async {
  await tester.runAsync(() async {
    final finder = find.byKey(const ValueKey('k0_capture_target'));
    final boundary =
        finder.evaluate().single.renderObject! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final directory = Directory(_outputDir);
    if (!directory.existsSync()) directory.createSync(recursive: true);
    File('$_outputDir/$filename')
        .writeAsBytesSync(byteData!.buffer.asUint8List());
  });
}

KanbanTaskCardResponse _task({
  required String id,
  required String title,
  required ProjectTaskStatus status,
  String? primaryAssigneeUserId,
  List<String> assigneeUserIds = const [],
  TaskPriority priority = TaskPriority.normal,
  DateTime? dueAtUtc,
  int checklistTotal = 0,
  int checklistCompleted = 0,
  bool isBlocked = false,
}) => KanbanTaskCardResponse(
  id: id,
  number: 101,
  taskCode: 'TASK-101',
  title: title,
  status: status,
  priority: priority,
  position: 1_000,
  checklistTotal: checklistTotal,
  checklistCompleted: checklistCompleted,
  attachmentCount: 0,
  version: 3,
  dueAtUtc: dueAtUtc,
  isBlocked: isBlocked,
  primaryAssigneeUserId: primaryAssigneeUserId,
  assigneeUserIds: assigneeUserIds,
);

KanbanBoardResponse _statusBoard({
  KanbanSwimlaneMode swimlane = KanbanSwimlaneMode.none,
}) => KanbanBoardResponse(
  projectId: 'project-1',
  swimlaneMode: swimlane,
  settingsVersion: 4,
  hiddenColumns: const [],
  visibleCardFields: const [
    KanbanCardField.assignee,
    KanbanCardField.dueDate,
    KanbanCardField.checklist,
  ],
  defaultCardDensity: KanbanCardDensity.comfortable,
  columns: [
    KanbanColumnResponse(
      status: ProjectTaskStatus.todo,
      displayName: 'Do zrobienia',
      color: '#6C5CE7',
      totalTaskCount: 2,
      isWipLimitExceeded: false,
      tasks: [
        _task(
          id: 'task-1',
          title: 'Przygotować podgląd szablonu dla kreatora projektu',
          status: ProjectTaskStatus.todo,
          primaryAssigneeUserId: 'user-1',
          assigneeUserIds: const ['user-1', 'user-2'],
          dueAtUtc: DateTime.utc(2026, 9, 24),
          checklistTotal: 3,
          checklistCompleted: 1,
        ),
        _task(
          id: 'task-2',
          title: 'Krótki tytuł',
          status: ProjectTaskStatus.todo,
          priority: TaskPriority.high,
          isBlocked: true,
        ),
      ],
    ),
    KanbanColumnResponse(
      status: ProjectTaskStatus.inProgress,
      displayName: 'W toku',
      color: '#0984E3',
      totalTaskCount: 1,
      isWipLimitExceeded: false,
      tasks: [
        _task(
          id: 'task-3',
          title: 'Domknąć widok grupowany po osobach',
          status: ProjectTaskStatus.inProgress,
          primaryAssigneeUserId: 'user-2',
          assigneeUserIds: const ['user-2'],
          dueAtUtc: DateTime.utc(2026, 9, 21),
        ),
      ],
    ),
  ],
);

AssigneeKanbanBoardResponse _assigneeBoard() => AssigneeKanbanBoardResponse(
  projectId: 'project-1',
  grouping: KanbanSwimlaneMode.assignee,
  settingsVersion: 4,
  visibleCardFields: const [
    KanbanCardField.assignee,
    KanbanCardField.dueDate,
    KanbanCardField.checklist,
  ],
  defaultCardDensity: KanbanCardDensity.comfortable,
  groups: [
    AssigneeKanbanGroupResponse(
      displayName: 'Nieprzypisane',
      totalTaskCount: 1,
      tasks: [
        _task(
          id: 'task-2',
          title: 'Krótki tytuł',
          status: ProjectTaskStatus.todo,
          priority: TaskPriority.high,
          isBlocked: true,
        ),
      ],
    ),
    AssigneeKanbanGroupResponse(
      assigneeUserId: 'user-1',
      displayName: 'Przemysław Nowak',
      isCurrentUser: true,
      totalTaskCount: 1,
      tasks: [
        _task(
          id: 'task-1',
          title: 'Przygotować podgląd szablonu dla kreatora projektu',
          status: ProjectTaskStatus.todo,
          primaryAssigneeUserId: 'user-1',
          assigneeUserIds: const ['user-1', 'user-2'],
          dueAtUtc: DateTime.utc(2026, 9, 24),
          checklistTotal: 3,
          checklistCompleted: 1,
        ),
      ],
      nextCursor: 'next-page',
    ),
    AssigneeKanbanGroupResponse(
      assigneeUserId: 'user-2',
      displayName: 'Marta Zielińska',
      totalTaskCount: 1,
      tasks: [
        _task(
          id: 'task-3',
          title: 'Domknąć widok grupowany po osobach',
          status: ProjectTaskStatus.inProgress,
          primaryAssigneeUserId: 'user-2',
          assigneeUserIds: const ['user-2'],
          dueAtUtc: DateTime.utc(2026, 9, 21),
        ),
      ],
    ),
  ],
);

Widget _app({
  required TasksBoardCubit cubit,
  required TasksBoardReady state,
  required ThemeData theme,
  required double textScale,
  Widget? child,
  bool showGroupingBar = true,
}) => BlocProvider<TasksBoardCubit>.value(
  value: cubit,
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
        size: const Size(1440, 900),
        textScaler: TextScaler.linear(textScale),
      ),
      child: Scaffold(
        body: RepaintBoundary(
          key: const ValueKey('k0_capture_target'),
          child: SizedBox(
            width: 1440,
            height: 900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showGroupingBar) KanbanBoardGroupingBar(state: state),
                Expanded(
                  child:
                      child ??
                      (state.grouping == TasksBoardGrouping.assignee
                          ? KanbanAssigneeColumnsViewport(
                              workspaceId: 'workspace-1',
                              projectId: 'project-1',
                              state: state,
                              board: state.assigneeBoard!,
                            )
                          : KanbanColumnsViewport(
                              workspaceId: 'workspace-1',
                              projectId: 'project-1',
                              state: state,
                            )),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ),
);

TasksBoardCubit _cubit() {
  final cubit = TasksBoardCubit(
    _K0Repository(),
    _K0Realtime(),
    _K0TasksRepository(),
    viewPreferenceStore: _K0PreferenceStore(),
    workspaceId: 'workspace-1',
    projectId: 'project-1',
  );
  addTearDown(cubit.close);
  return cubit;
}

Future<TasksBoardReady> _readyState(
  TasksBoardGrouping grouping, {
  KanbanSwimlaneMode swimlane = KanbanSwimlaneMode.none,
}) async {
  final cubit = _cubit();
  await cubit.load();
  await cubit.setGrouping(grouping);
  final state = cubit.state as TasksBoardReady;
  return state.copyWith(board: _statusBoard(swimlane: swimlane));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Motyw produktu korzysta z Inter i Material Symbols, więc baseline musi
    // renderować te same fonty co aplikacja, inaczej zrzut nie jest dowodem.
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

  final themes = <String, ThemeData>{
    'light': MaterialTheme.crm().light(),
    'dark': MaterialTheme.crm().dark(),
  };
  final themesByGrouping = <String, TasksBoardGrouping>{
    'status': TasksBoardGrouping.status,
    'assignee': TasksBoardGrouping.assignee,
  };

  for (final grouping in themesByGrouping.entries) {
    for (final theme in themes.entries) {
      for (final scale in _scales) {
        final label = '${scale.toStringAsFixed(2)}x';
        testWidgets(
          'baseline K0: ${grouping.key} ${theme.key} $label',
          (tester) async {
            _sizeWindow(tester);
            final state = await _readyState(grouping.value);
            await tester.pumpWidget(
              _app(
                cubit: _cubit(),
                state: state,
                theme: theme.value,
                textScale: scale,
              ),
            );
            await tester.pumpAndSettle();

            expect(
              tester.takeException(),
              isNull,
              reason:
                  'skalowanie tekstu $label nie może przepełniać kolumny ani nagłówka',
            );
            await _capture(
              tester,
              'kanban-${grouping.key}-${theme.key}-$label.png',
            );
          },
        );
      }
    }
  }

  testWidgets('baseline K0: karta ze statusem w widoku osób', (tester) async {
    _sizeWindow(tester, width: 600, height: 600);
    for (final theme in themes.entries) {
      for (final scale in _scales) {
        await tester.pumpWidget(
          _app(
            cubit: _cubit(),
            state: await _readyState(TasksBoardGrouping.assignee),
            theme: theme.value,
            textScale: scale,
            showGroupingBar: false,
            child: Center(
              child: SizedBox(
                width: KanbanCardTokens.columnWidthStandard - 18,
                child: KanbanTaskCard(
                  task: _task(
                    id: 'task-1',
                    title: 'Przygotować podgląd szablonu dla kreatora projektu',
                    status: ProjectTaskStatus.todo,
                    primaryAssigneeUserId: 'user-1',
                    assigneeUserIds: const ['user-1', 'user-2'],
                    dueAtUtc: DateTime.utc(2026, 9, 24),
                    checklistTotal: 3,
                    checklistCompleted: 1,
                  ),
                  workspaceId: 'workspace-1',
                  projectId: 'project-1',
                  visibleCardFields: const [
                    KanbanCardField.assignee,
                    KanbanCardField.dueDate,
                    KanbanCardField.checklist,
                  ],
                  density: KanbanCardDensity.comfortable,
                  isSelected: false,
                  memberProfilesByUserId: const {},
                  statusBadge: const (
                    label: 'Do zrobienia',
                    color: Color(0xFF6C5CE7),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await _capture(
          tester,
          'kanban-card-badge-${theme.key}-${scale.toStringAsFixed(2)}x.png',
        );
      }
    }
  });

  testWidgets(
    'baseline K0: wąskie okno przy 200% nie przepełnia paska grupowania',
    (tester) async {
      _sizeWindow(tester, width: 600, height: 600);
      final state = await _readyState(TasksBoardGrouping.assignee);
      await tester.pumpWidget(
        _app(
          cubit: _cubit(),
          state: state,
          theme: themes['light']!,
          textScale: 2.0,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
        reason: 'plan §5.9: skalowanie 200% nie może przepełniać chrome tablicy (zmierzone 9.9 px przed poprawką)',
      );
      expect(
        find.text('Status'),
        findsOneWidget,
        reason: 'przełącznik pozostaje widoczny i dostępny w wąskim oknie',
      );
      await _capture(tester, 'kanban-grouping-bar-narrow-light-2.00x.png');
    },
  );

  testWidgets(
    'baseline K0: szerokość kolumny i wysokość karty trzymają się tokenów',
    (tester) async {
      _sizeWindow(tester);
      final statusState = await _readyState(TasksBoardGrouping.status);
      await tester.pumpWidget(
        _app(
          cubit: _cubit(),
          state: statusState,
          theme: themes['light']!,
          textScale: 1.0,
        ),
      );
      await tester.pumpAndSettle();
      final statusColumn = tester.getSize(
        find.byType(KanbanColumnWidget).first,
      );
      final cardSize = tester.getSize(find.byType(KanbanTaskCard).first);

      final assigneeState = await _readyState(TasksBoardGrouping.assignee);
      await tester.pumpWidget(
        _app(
          cubit: _cubit(),
          state: assigneeState,
          theme: themes['light']!,
          textScale: 1.0,
        ),
      );
      await tester.pumpAndSettle();
      final personColumn = tester.getSize(
        find.byType(KanbanAssigneeColumn).first,
      );

      // Wypisujemy pomiar, żeby baseline był czytelny w logu uruchomienia.
      debugPrint(
        'K0 wymiary: kolumna statusu=${statusColumn.width}x${statusColumn.height}, '
        'kolumna osoby=${personColumn.width}x${personColumn.height}, '
        'karta=${cardSize.width}x${cardSize.height}, '
        'tokeny: kolumna=${KanbanCardTokens.columnWidthStandard}, '
        'odstęp kart=${KanbanCardTokens.cardGap}, gutter=${KanbanCardTokens.boardGutter}',
      );

      expect(
        statusColumn.width,
        KanbanCardTokens.columnWidthStandard,
        reason: 'kolumna statusu korzysta z tokenu szerokości',
      );
      expect(
        personColumn.width,
        KanbanCardTokens.columnWidthStandard,
        reason: 'kolumna osoby używa tej samej szerokości co kolumna statusu',
      );
      expect(
        cardSize.width,
        lessThanOrEqualTo(KanbanCardTokens.columnWidthStandard),
        reason: 'karta nie może być szersza niż kolumna',
      );
      expect(cardSize.height, greaterThan(0));
    },
  );

  testWidgets(
    'baseline K0: o rendererze decyduje przełącznik, nie swimlaneMode projektu',
    (tester) async {
      _sizeWindow(tester);
      // Historyczny defekt: projekt miał zapisane `Assignee`, a tablica i tak
      // rysowała kolumny statusów. Dziś renderer wybiera widok stanu, więc samo
      // ustawienie projektu nie może zmienić siatki kolumn.
      final swimlaneOnly = await _readyState(
        TasksBoardGrouping.status,
        swimlane: KanbanSwimlaneMode.assignee,
      );
      await tester.pumpWidget(
        _app(
          cubit: _cubit(),
          state: swimlaneOnly,
          theme: themes['light']!,
          textScale: 1.0,
        ),
      );
      await tester.pumpAndSettle();

      expect(
        swimlaneOnly.board.swimlaneMode,
        KanbanSwimlaneMode.assignee,
        reason: 'projekt ma zapisane grupowanie po osobach',
      );
      expect(swimlaneOnly.grouping, TasksBoardGrouping.status);
      expect(find.byType(KanbanColumnWidget), findsWidgets);
      expect(
        find.byType(KanbanAssigneeColumn),
        findsNothing,
        reason: 'zapis projektu nie może sam przełączać renderera',
      );

      // Ten sam projekt po przełączeniu widoku pokazuje kolumny osób.
      final switched = await _readyState(TasksBoardGrouping.assignee);
      await tester.pumpWidget(
        _app(
          cubit: _cubit(),
          state: switched,
          theme: themes['light']!,
          textScale: 1.0,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KanbanAssigneeColumn), findsNWidgets(3));
      expect(find.byType(KanbanColumnWidget), findsNothing);
      expect(find.text('Nieprzypisane'), findsOneWidget);
      expect(find.text('Przemysław Nowak'), findsOneWidget);
      expect(
        find.text('Ty'),
        findsOneWidget,
        reason: 'bieżący użytkownik ma własny badge w nagłówku kolumny',
      );
      expect(
        find.text('Do zrobienia'),
        findsWidgets,
        reason: 'status wraca jako badge karty, gdy kolumna opisuje osobę',
      );
    },
  );
}

final class _K0Repository implements KanbanRepository {
  @override
  Future<Either<ApiError, KanbanBoardResponse>> getBoard({
    required String workspaceId,
    required String projectId,
    KanbanBoardFilter filter = KanbanBoardFilter.none,
  }) async => Right(_statusBoard());

  @override
  Future<Either<ApiError, AssigneeKanbanBoardResponse>> getAssigneeBoard({
    required String workspaceId,
    required String projectId,
    KanbanBoardFilter filter = KanbanBoardFilter.none,
  }) async => Right(_assigneeBoard());

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} nie jest używane w baseline K0',
  );
}

final class _K0PreferenceStore implements TasksBoardViewPreferenceStore {
  @override
  Future<TasksBoardGrouping?> readGrouping({
    required String workspaceId,
    required String projectId,
  }) async => null;

  @override
  Future<void> writeGrouping({
    required String workspaceId,
    required String projectId,
    required TasksBoardGrouping grouping,
  }) async {}

  @override
  Future<TasksBoardAssigneeColumnsPreference> readAssigneeColumns({
    required String workspaceId,
    required String projectId,
  }) async => const TasksBoardAssigneeColumnsPreference();

  @override
  Future<void> writeAssigneeColumns({
    required String workspaceId,
    required String projectId,
    required TasksBoardAssigneeColumnsPreference preference,
  }) async {}
}

final class _K0Realtime implements TaskProjectRealtime {
  @override
  Stream<TaskProjectRealtimeUpdate> get updates =>
      const Stream<TaskProjectRealtimeUpdate>.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

final class _K0TasksRepository implements TasksRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} nie jest używane w baseline K0',
  );
}
