import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/models/task_project_realtime_update.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_assignee_columns_preference.dart';
import 'package:devplanner/workspaces/domain/models/tasks_board_grouping.dart';
import 'package:devplanner/workspaces/domain/ports/tasks_board_view_preference_store.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_project_realtime.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/cubit/tasks_board_state.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_page.dart'
    show
        KanbanAssigneeColumn,
        KanbanAssigneeColumnsViewport,
        showKanbanMoveToPersonDialog;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

/// Widok osób: przełącznik grupowania, osobista preferencja, paginacja grup
/// oraz zmiana głównego wykonawcy z optimistic update i rollbackiem.
void main() {
  test('przełączenie na osoby zapisuje preferencję i wczytuje grupy', () async {
    final repository = _Repository();
    final preference = _GroupingPreferenceStore();
    final cubit = _cubit(repository, preference);
    await cubit.load();

    await cubit.setGrouping(TasksBoardGrouping.assignee);

    final state = cubit.state as TasksBoardReady;
    expect(state.grouping, TasksBoardGrouping.assignee);
    expect(state.assigneeBoard, isNotNull);
    expect(state.isAssigneeBoardLoading, isFalse);
    expect(repository.assigneeBoardCalls, 1);
    expect(preference.writes, [
      (
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        grouping: 'assignee',
      ),
    ]);
    expect(
      state.assigneeBoard!.groups.map((group) => group.displayName),
      ['Nieprzypisane', 'Marta', 'Adam'],
    );
  });

  test('zapisana preferencja wraca po ponownym wejściu na tablicę', () async {
    final repository = _Repository();
    final preference = _GroupingPreferenceStore(saved: 'assignee');
    final cubit = _cubit(repository, preference);
    await cubit.load();

    await cubit.start();

    final state = cubit.state as TasksBoardReady;
    expect(state.grouping, TasksBoardGrouping.assignee);
    expect(repository.assigneeBoardCalls, 1);
  });

  test(
    'nieudany odczyt grup wraca do statusów i zostawia trwały błąd',
    () async {
      final repository = _Repository()
        ..assigneeBoardResult = const Left(
          ApiError(type: ApiErrorType.server, message: 'Brak połączenia.'),
        );
      final cubit = _cubit(repository, _GroupingPreferenceStore());
      await cubit.load();

      await cubit.setGrouping(TasksBoardGrouping.assignee);

      final state = cubit.state as TasksBoardReady;
      expect(state.grouping, TasksBoardGrouping.status);
      expect(state.assigneeBoard, isNull);
      expect(state.error?.code, 'Brak połączenia.');
      expect(state.board.columns, isNotEmpty);
    },
  );

  test('doładowanie dotyczy jednej grupy i nie duplikuje kart', () async {
    final repository = _Repository()
      ..assigneeGroupResult = Right(
        CursorPageResponse(
          items: [
            _card(id: 'task-2', version: 4),
            _card(id: 'task-9', version: 1),
          ],
          nextCursor: 'page-3',
        ),
      );
    final cubit = _cubit(repository, _GroupingPreferenceStore());
    await cubit.load();
    await cubit.setGrouping(TasksBoardGrouping.assignee);
    final group = (cubit.state as TasksBoardReady).assigneeBoard!.groups[2];

    await cubit.loadMoreAssigneeGroup(group);

    final updated = (cubit.state as TasksBoardReady).assigneeBoard!.groups[2];
    expect(updated.tasks.map((task) => task.id), ['task-2', 'task-9']);
    expect(updated.nextCursor, 'page-3');
    expect(repository.assigneeGroupPeople, ['user-2']);
    expect(
      (cubit.state as TasksBoardReady).assigneeBoard!.groups[1].tasks,
      hasLength(1),
      reason: 'doładowanie jednej kolumny nie może zmieniać innych grup',
    );
  });

  test('błąd doładowania zostaje przy swojej grupie', () async {
    final repository = _Repository()
      ..assigneeGroupResult = const Left(
        ApiError(type: ApiErrorType.server, message: 'Nie udało się.'),
      );
    final cubit = _cubit(repository, _GroupingPreferenceStore());
    await cubit.load();
    await cubit.setGrouping(TasksBoardGrouping.assignee);
    final group = (cubit.state as TasksBoardReady).assigneeBoard!.groups[2];

    await cubit.loadMoreAssigneeGroup(group);

    final state = cubit.state as TasksBoardReady;
    expect(state.assigneeGroupLoadErrors, {'user-2': 'Nie udało się.'});
    expect(state.loadingAssigneeGroupKeys, isEmpty);
    expect(state.assigneeBoard!.groups[2].tasks, hasLength(1));
  });

  test('przeniesienie do osoby zmienia wykonawcę bez zmiany statusu', () async {
    final repository = _Repository();
    final cubit = _cubit(repository, _GroupingPreferenceStore());
    await cubit.load();
    await cubit.setGrouping(TasksBoardGrouping.assignee);
    final task =
        (cubit.state as TasksBoardReady).assigneeBoard!.groups[2].tasks.single;

    final result = await cubit.moveTaskToAssignee(
      task: task,
      targetUserId: 'user-1',
    );

    expect(result, isTrue);
    expect(repository.changePrimaryPeople.single.targetUserId, 'user-1');
    expect(repository.changePrimaryPeople.single.expectedVersion, 4);
    final groups = (cubit.state as TasksBoardReady).assigneeBoard!.groups;
    expect(
      groups[2].tasks,
      isEmpty,
      reason: 'karta opuszcza kolumnę poprzedniej osoby',
    );
    final moved = groups[1].tasks.singleWhere((item) => item.id == 'task-2');
    expect(moved.primaryAssigneeUserId, 'user-1');
    expect(
      moved.status,
      ProjectTaskStatus.inProgress,
      reason: 'zmiana osoby nie może zmieniać statusu zadania',
    );
    expect(moved.version, 5, reason: 'karta pochodzi z odpowiedzi serwera');
    expect((cubit.state as TasksBoardReady).pendingTaskIds, isEmpty);
  });

  test('konflikt wersji cofa przeniesienie i pokazuje błąd', () async {
    final repository = _Repository()
      ..changePrimaryResult = const Left(
        ApiError(
          type: ApiErrorType.conflict,
          message: 'Karta została zmieniona w innej sesji.',
          statusCode: 409,
          apiCode: 'kanban.version_conflict',
        ),
      );
    final cubit = _cubit(repository, _GroupingPreferenceStore());
    await cubit.load();
    await cubit.setGrouping(TasksBoardGrouping.assignee);
    final task =
        (cubit.state as TasksBoardReady).assigneeBoard!.groups[2].tasks.single;

    final result = await cubit.moveTaskToAssignee(
      task: task,
      targetUserId: 'user-1',
    );

    expect(result, isFalse);
    final state = cubit.state as TasksBoardReady;
    expect(
      state.assigneeBoard!.groups[1].tasks.map((item) => item.id),
      isNot(contains('task-2')),
      reason: 'konflikt nie może zostawiać karty w kolumnie docelowej',
    );
    expect(
      state.assigneeBoard!.groups[2].tasks.single.id,
      'task-2',
      reason: 'rollback musi przywrócić kartę do kolumny sprzed zmiany',
    );
    expect(state.error?.code, contains('innej sesji'));
    expect(state.pendingTaskIds, isEmpty);
  });

  testWidgets(
    'kolumna osoby pokazuje nazwę, licznik, badge „Ty” i status karty',
    (
      tester,
    ) async {
      final cubit = _cubit(_Repository(), _GroupingPreferenceStore());
      await cubit.load();
      await cubit.setGrouping(TasksBoardGrouping.assignee);
      final state = cubit.state as TasksBoardReady;
      final group = state.assigneeBoard!.groups[1];

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<TasksBoardCubit>.value(
            value: cubit,
            child: Scaffold(
              body: SizedBox(
                height: 600,
                child: KanbanAssigneeColumn(
                  workspaceId: 'workspace-1',
                  projectId: 'project-1',
                  state: state,
                  group: group,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Marta'), findsOneWidget);
      expect(
        find.text('Ty'),
        findsOneWidget,
        reason: 'bieżący użytkownik ma własny badge',
      );
      expect(find.text('1'), findsWidgets, reason: 'licznik kart grupy');
      expect(
        find.text('Do zrobienia'),
        findsOneWidget,
        reason: 'status wraca jako badge karty, gdy kolumna opisuje osobę',
      );
      expect(
        find.text('TASK-1'),
        findsOneWidget,
        reason: 'kod zadania zostaje na karcie jako tekst drugorzędny',
      );
      expect(find.text('Zadanie task-1'), findsOneWidget);
    },
  );

  testWidgets('pusta kolumna grupy jest całą strefą upuszczenia', (
    tester,
  ) async {
    final cubit = _cubit(_Repository(), _GroupingPreferenceStore());
    await cubit.load();
    await cubit.setGrouping(TasksBoardGrouping.assignee);
    final state = cubit.state as TasksBoardReady;
    final empty = state.assigneeBoard!.groups[0];

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<TasksBoardCubit>.value(
          value: cubit,
          child: Scaffold(
            body: SizedBox(
              height: 600,
              child: KanbanAssigneeColumn(
                workspaceId: 'workspace-1',
                projectId: 'project-1',
                state: state,
                group: empty,
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Nieprzypisane'), findsOneWidget);
    expect(
      find.text('0'),
      findsOneWidget,
      reason: 'pusta grupa nadal pokazuje licznik',
    );
  });

  testWidgets(
    'wiersz dodawania zadania jest tylko w kolumnie Nieprzypisane',
    (tester) async {
      final cubit = _cubit(_Repository(), _GroupingPreferenceStore());
      await cubit.load();
      await cubit.setGrouping(TasksBoardGrouping.assignee);
      final state = cubit.state as TasksBoardReady;
      final groups = state.assigneeBoard!.groups;

      Future<void> pumpGroup(AssigneeKanbanGroupResponse group) async {
        await tester.pumpWidget(
          MaterialApp(
            locale: const Locale('pl'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocProvider<TasksBoardCubit>.value(
              value: cubit,
              child: Scaffold(
                body: SizedBox(
                  height: 600,
                  child: KanbanAssigneeColumn(
                    workspaceId: 'workspace-1',
                    projectId: 'project-1',
                    state: state,
                    group: group,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
      }

      // Nowe zadanie powstaje w Backlogu bez wykonawcy, więc pojawia się
      // dokładnie w kolumnie „Nieprzypisane” — w kolumnie osoby wiersz
      // obiecywałby kartę, która tam nie trafi.
      await pumpGroup(groups[0]);
      expect(find.text('Dodaj zadanie'), findsOneWidget);

      await pumpGroup(groups[1]);
      expect(find.text('Dodaj zadanie'), findsNothing);
    },
  );

  testWidgets(
    'menu: wybór osoby z klawiatury przenosi kartę bez przeciągania',
    (tester) async {
      final cubit = _cubit(_Repository(), _GroupingPreferenceStore());
      await cubit.load();
      await cubit.setGrouping(TasksBoardGrouping.assignee);
      final state = cubit.state as TasksBoardReady;
      // Karta leży w kolumnie Adama, więc lista pomija tę kolumnę.
      final task = state.assigneeBoard!.groups[2].tasks.single;

      ({String? targetUserId})? selected;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  selected = await showKanbanMoveToPersonDialog(
                    context,
                    state: state,
                    taskId: task.id,
                  );
                },
                child: const Text('otwórz'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('otwórz'));
      await tester.pumpAndSettle();

      expect(find.text('Marta'), findsOneWidget);
      expect(find.text('Nieprzypisane'), findsWidgets);
      expect(
        find.text('Adam'),
        findsNothing,
        reason: 'kolumna bieżącej osoby nie jest celem przeniesienia',
      );

      await tester.tap(find.text('Marta'));
      await tester.pumpAndSettle();

      expect(selected?.targetUserId, 'user-1');
    },
  );

  testWidgets(
    'menu: „Nieprzypisane” wymaga potwierdzenia usunięcia wykonawców',
    (
      tester,
    ) async {
      final cubit = _cubit(_Repository(), _GroupingPreferenceStore());
      await cubit.load();
      await cubit.setGrouping(TasksBoardGrouping.assignee);
      final state = cubit.state as TasksBoardReady;
      final task = state.assigneeBoard!.groups[2].tasks.single;

      var opened = false;
      ({String? targetUserId})? selected;
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () async {
                  opened = true;
                  selected = await showKanbanMoveToPersonDialog(
                    context,
                    state: state,
                    taskId: task.id,
                  );
                },
                child: const Text('otwórz'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('otwórz'));
      await tester.pumpAndSettle();
      expect(opened, isTrue);

      final dialogRow = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Nieprzypisane'),
      );
      expect(dialogRow, findsOneWidget);
      await tester.tap(dialogRow);
      await tester.pumpAndSettle();
      expect(
        find.text('Usunąć wszystkich wykonawców?'),
        findsWidgets,
        reason: 'reguła D2: usunięcie wykonawców wymaga jawnego potwierdzenia',
      );

      await tester.tap(find.text('Usuń wykonawców'));
      await tester.pumpAndSettle();
      expect(selected?.targetUserId, isNull);
    },
  );

  test(
    'rollback przeniesienia nie nadpisuje zmian, które przyszły w trakcie',
    () async {
      final repository = _Repository()
        ..changePrimaryCompleter =
            Completer<Either<ApiError, ChangeKanbanPrimaryAssigneeResponse>>()
        ..assigneeGroupResult = Right(
          CursorPageResponse(items: [_card(id: 'task-9', version: 1)]),
        );
      final cubit = _cubit(repository, _GroupingPreferenceStore());
      await cubit.load();
      await cubit.setGrouping(TasksBoardGrouping.assignee);
      final task = (cubit.state as TasksBoardReady)
          .assigneeBoard!
          .groups[2]
          .tasks
          .single;

      final pendingMove = cubit.moveTaskToAssignee(
        task: task,
        targetUserId: 'user-1',
      );
      // W czasie oczekiwania na odpowiedź doładowuje się kolejna strona grupy.
      await cubit.loadMoreAssigneeGroup(
        (cubit.state as TasksBoardReady).assigneeBoard!.groups[2],
      );
      expect(
        (cubit.state as TasksBoardReady).assigneeBoard!.groups[2].tasks.map(
          (item) => item.id,
        ),
        contains('task-9'),
        reason: 'doładowanie strony musi dojść do stanu przed rozstrzygnięciem mutacji',
      );

      repository.changePrimaryCompleter!.complete(
        const Left(
          ApiError(type: ApiErrorType.server, message: 'Błąd zapisu.'),
        ),
      );
      await pendingMove;

      final groups = (cubit.state as TasksBoardReady).assigneeBoard!.groups;
      expect(
        groups[2].tasks.map((item) => item.id),
        containsAll(<String>['task-2', 'task-9']),
        reason: 'rollback cofa tylko własną kartę i nie może zgubić doładowanej strony',
      );
      expect(
        groups[1].tasks.map((item) => item.id),
        isNot(contains('task-2')),
        reason: 'karta wraca do kolumny źródłowej',
      );
    },
  );

  testWidgets('obserwator nie przeciąga kart i nie przyjmuje upuszczenia', (
    tester,
  ) async {
    final cubit = _cubit(_Repository(), _GroupingPreferenceStore());
    await cubit.load();
    await cubit.setGrouping(TasksBoardGrouping.assignee);
    final ready = cubit.state as TasksBoardReady;

    Future<void> pumpWithRole(ProjectRole role) async {
      final state = ready.copyWith(
        memberProfilesByUserId: {
          'user-1': ProjectMemberProfile(
            userId: 'user-1',
            role: role,
            displayName: 'Przemysław Nowak',
          ),
        },
      );
      await tester.pumpWidget(
        ListenableProvider<AuthSessionPort>.value(
          value: AuthSessionController(
            initial: const AuthSessionSnapshot(
              status: AuthSessionStatus.signedIn,
              user: AuthUser(
                userId: 'user-1',
                login: 'tester',
                displayName: 'Tester',
              ),
            ),
          ),
          child: MaterialApp(
            locale: const Locale('pl'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: BlocProvider<TasksBoardCubit>.value(
              value: cubit,
              child: Scaffold(
                body: SizedBox(
                  height: 600,
                  child: KanbanAssigneeColumn(
                    workspaceId: 'workspace-1',
                    projectId: 'project-1',
                    state: state,
                    group: state.assigneeBoard!.groups[2],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pumpWithRole(ProjectRole.observer);
    expect(
      find.byType(Draggable<KanbanTaskCardResponse>),
      findsNothing,
      reason: 'obserwator nie może zaczynać przeciągania',
    );

    await pumpWithRole(ProjectRole.member);
    expect(
      find.byType(Draggable<KanbanTaskCardResponse>),
      findsWidgets,
      reason: 'członek projektu zachowuje przeciąganie',
    );
  });

  testWidgets('przy wielu osobach tablica ma poziomy pasek przewijania', (
    tester,
  ) async {
    final cubit = _cubit(_Repository(), _GroupingPreferenceStore());
    await cubit.load();
    await cubit.setGrouping(TasksBoardGrouping.assignee);
    final ready = cubit.state as TasksBoardReady;
    final board = ready.assigneeBoard!;
    final many = board.copyWith(
      groups: [
        for (var index = 0; index < 12; index++)
          AssigneeKanbanGroupResponse(
            assigneeUserId: 'user-$index',
            displayName: 'Osoba $index',
            totalTaskCount: 0,
            tasks: const [],
          ),
      ],
    );
    final state = ready.copyWith(assigneeBoard: many);

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: BlocProvider<TasksBoardCubit>.value(
          value: cubit,
          child: Scaffold(
            body: SizedBox(
              width: 420,
              height: 600,
              child: KanbanAssigneeColumnsViewport(
                workspaceId: 'workspace-1',
                projectId: 'project-1',
                state: state,
                board: many,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final scrollbar = tester.widget<Scrollbar>(find.byType(Scrollbar));
    expect(scrollbar.thumbVisibility, isTrue);
    expect(
      scrollbar.controller?.position.maxScrollExtent ?? 0,
      greaterThan(0),
      reason:
          'pasek musi mieć co przewijać, gdy kolumny nie mieszczą się w oknie',
    );
    expect(find.byType(KanbanAssigneeColumn), findsWidgets);
  });

  test(
    'szybki filtr w widoku osób wraca po świeże grupy, a nie tylko po kolumny',
    () async {
      final repository = _Repository();
      final cubit = _cubit(repository, _GroupingPreferenceStore());
      await cubit.start();
      await pumpEventQueue();
      await cubit.setGrouping(TasksBoardGrouping.assignee);
      expect(repository.assigneeBoardCalls, 1);

      // Backend po szybkim filtrze zwraca inny zestaw grup i liczniki.
      repository.assigneeBoardResult = Right(
        _assigneeBoard(
          groups: [
            const AssigneeKanbanGroupResponse(
              displayName: 'Nieprzypisane',
              totalTaskCount: 0,
              tasks: [],
            ),
            AssigneeKanbanGroupResponse(
              assigneeUserId: 'user-1',
              displayName: 'Marta',
              isCurrentUser: true,
              totalTaskCount: 2,
              tasks: [
                _card(
                  id: 'task-1',
                  version: 1,
                  primaryAssigneeUserId: 'user-1',
                ),
                _card(
                  id: 'task-9',
                  version: 1,
                  primaryAssigneeUserId: 'user-1',
                ),
              ],
            ),
          ],
        ),
      );

      await cubit.setQuickFilter(KanbanQuickFilter.mine);

      final state = cubit.state as TasksBoardReady;
      expect(
        repository.preferenceWrites.single.quickFilter,
        KanbanQuickFilter.mine,
      );
      expect(
        repository.assigneeBoardCalls,
        2,
        reason: 'tablica osób musi wrócić po grupy po zmianie szybkiego filtra',
      );
      expect(
        state.assigneeBoard!.groups.map((group) => group.totalTaskCount),
        [0, 2],
        reason: 'ekran pokazuje grupy z odczytu po filtrze, nie sprzed filtra',
      );
      expect(
        state.isAssigneeBoardLoading,
        isFalse,
        reason: 'wskaźnik wczytywania musi zgasnąć po odświeżeniu grup',
      );
    },
  );

  test(
    'późniejsza odpowiedź starszego żądania nie nadpisuje świeżych grup',
    () async {
      final repository = _Repository()..holdAssigneeBoard = true;
      final cubit = _cubit(repository, _GroupingPreferenceStore());
      await cubit.start();
      await pumpEventQueue();

      // Pierwszy odczyt grup (np. dla filtra High) trzymamy otwarty.
      final firstLoad = cubit.setGrouping(TasksBoardGrouping.assignee);
      await pumpEventQueue();
      expect(repository.assigneeBoardCalls, 1);

      // W trakcie drugie żądanie dla nowego filtra (Critical) i ono wraca
      // pierwsze, więc jego grupy są tym, co użytkownik ma prawo zobaczyć.
      final secondLoad = cubit.setFilterPriority(TaskPriority.high);
      await pumpEventQueue();
      expect(repository.assigneeBoardCalls, 2);
      repository.assigneeBoardRequests[1].complete(
        Right(
          _assigneeBoard(
            groups: [
              AssigneeKanbanGroupResponse(
                assigneeUserId: 'user-2',
                displayName: 'Adam',
                totalTaskCount: 7,
                tasks: [
                  _card(
                    id: 'task-7',
                    version: 1,
                    primaryAssigneeUserId: 'user-2',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      await secondLoad;

      // Starsza odpowiedź wraca ostatnia i nie może już niczego podmienić.
      repository.assigneeBoardRequests[0].complete(
        Right(
          _assigneeBoard(
            groups: [
              AssigneeKanbanGroupResponse(
                assigneeUserId: 'user-1',
                displayName: 'Marta',
                totalTaskCount: 99,
                tasks: [
                  _card(
                    id: 'task-1',
                    version: 1,
                    primaryAssigneeUserId: 'user-1',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      await firstLoad;

      final state = cubit.state as TasksBoardReady;
      expect(
        state.assigneeBoard!.groups.single.displayName,
        'Adam',
        reason: 'ekran pokazuje grupy z nowszego żądania, nie z ostatniej odpowiedzi',
      );
      expect(state.assigneeBoard!.groups.single.totalTaskCount, 7);
    },
  );

  test('ukrycie kolumny osoby wraca z zapisanej preferencji', () async {
    final store = _GroupingPreferenceStore(
      saved: TasksBoardGrouping.assignee.wireValue,
      savedColumns: const TasksBoardAssigneeColumnsPreference(
        hiddenAssigneeUserIds: {'user-2'},
        hideEmpty: true,
      ),
    );
    final cubit = _cubit(_Repository(), store);
    await cubit.start();
    await pumpEventQueue();

    var state = cubit.state as TasksBoardReady;
    expect(state.hiddenAssigneeUserIds, {'user-2'});
    expect(state.hideEmptyAssigneeColumns, isTrue);
    expect(
      state.grouping,
      TasksBoardGrouping.assignee,
      reason: 'zapisana preferencja grupowania nadal obowiązuje',
    );

    await cubit.setAssigneeColumnVisible(groupKey: 'user-1', visible: false);
    await pumpEventQueue();
    state = cubit.state as TasksBoardReady;
    expect(state.hiddenAssigneeUserIds, {'user-1', 'user-2'});
    expect(
      store.columnWrites.last.hiddenAssigneeUserIds,
      {'user-1', 'user-2'},
      reason: 'widoczność kolumn jest osobistą preferencją zapisywaną lokalnie',
    );

    await cubit.showAllAssigneeColumns();
    await pumpEventQueue();
    state = cubit.state as TasksBoardReady;
    expect(state.hiddenAssigneeUserIds, isEmpty);
    expect(state.hideEmptyAssigneeColumns, isFalse);
    expect(
      store.columnWrites.last.isDefault,
      isTrue,
      reason: 'powrót do pełnej listy czyści zapis',
    );
  });

  testWidgets('ukryte kolumny osób nie są montowane na tablicy', (
    tester,
  ) async {
    final cubit = _cubit(_Repository(), _GroupingPreferenceStore());
    await cubit.load();
    await cubit.setGrouping(TasksBoardGrouping.assignee);
    final ready = cubit.state as TasksBoardReady;
    final board = ready.assigneeBoard!;

    Future<void> pumpBoard(TasksBoardReady state) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: BlocProvider<TasksBoardCubit>.value(
            value: cubit,
            child: Scaffold(
              body: SizedBox(
                // Dość szeroko, żeby wszystkie trzy kolumny zostały zbudowane:
                // lista pozioma buduje leniwie, więc wąskie okno ukryłoby kolumnę
                // z powodów układu, a nie z powodu filtra widoczności.
                width: 1200,
                height: 600,
                child: KanbanAssigneeColumnsViewport(
                  workspaceId: 'workspace-1',
                  projectId: 'project-1',
                  state: state,
                  board: board,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pumpBoard(ready);
    expect(find.text('Marta'), findsOneWidget);
    expect(find.text('Adam'), findsOneWidget);

    await pumpBoard(ready.copyWith(hiddenAssigneeUserIds: const {'user-2'}));
    expect(find.text('Marta'), findsOneWidget);
    expect(
      find.text('Adam'),
      findsNothing,
      reason: 'ukryta kolumna nie jest montowana',
    );

    await pumpBoard(ready.copyWith(hideEmptyAssigneeColumns: true));
    expect(
      find.text('Nieprzypisane'),
      findsNothing,
      reason: 'pusta kolumna znika, gdy włączone jest ukrywanie pustych',
    );
    expect(find.text('Marta'), findsOneWidget);
  });

  test(
    'wejście w widok osób zdejmuje filtr wykonawcy, reszta wymiarów zostaje',
    () async {
      final repository = _Repository();
      final cubit = _cubit(repository, _GroupingPreferenceStore());
      await cubit.load();
      await cubit.setFilterAssignee('user-2');
      await cubit.setFilterPriority(TaskPriority.high);
      expect(
        (cubit.state as TasksBoardReady).filter.assigneeUserId,
        'user-2',
      );

      await cubit.setGrouping(TasksBoardGrouping.assignee);

      final state = cubit.state as TasksBoardReady;
      expect(
        state.filter.assigneeUserId,
        isNull,
        reason:
            'kontrolka filtra wykonawcy znika w widoku osób, więc filtr nie może '
            'dalej zawężać kolumn',
      );
      expect(
        state.filter.priority,
        TaskPriority.high,
        reason: 'pozostałe wymiary filtra zostają',
      );
      expect(
        repository.assigneeBoardFilters.last.assigneeUserId,
        isNull,
        reason: 'odczyt tablicy osób nie może nieść ukrytego filtra wykonawcy',
      );

      await cubit.setGrouping(TasksBoardGrouping.status);
      expect(
        (cubit.state as TasksBoardReady).filter.assigneeUserId,
        isNull,
        reason: 'powrót do statusów nie przywraca usuniętego filtra osoby',
      );
    },
  );

  test(
    'szybkie zmiany widoczności kolumn zapisują się szeregowo i wygrywa najnowsza',
    () async {
      final store = _GroupingPreferenceStore()..holdColumnWrites = true;
      final cubit = _cubit(_Repository(), store);
      await cubit.load();
      await cubit.setGrouping(TasksBoardGrouping.assignee);

      await cubit.setAssigneeColumnVisible(groupKey: 'user-1', visible: false);
      await cubit.setAssigneeColumnVisible(groupKey: 'user-2', visible: false);
      await pumpEventQueue();

      expect(
        store.columnWrites,
        hasLength(1),
        reason:
            'drugi zapis czeka na pierwszy — równoległe zapisy mogłyby dobiec '
            'w odwrotnej kolejności i nadpisać świeższy wybór',
      );
      expect(store.maxConcurrentColumnWrites, 1);

      store.columnWriteCompleters.single.complete();
      await pumpEventQueue();

      expect(
        store.columnWrites.last.hiddenAssigneeUserIds,
        {'user-1', 'user-2'},
        reason: 'po zakończeniu zapisu storage dostaje najnowszy stan',
      );
      expect(store.maxConcurrentColumnWrites, 1);
    },
  );

  test('filtr statusu w widoku osób jedzie do odczytu grup i wraca po świeże', () async {
    final repository = _Repository();
    final cubit = _cubit(repository, _GroupingPreferenceStore());
    await cubit.load();
    await cubit.setGrouping(TasksBoardGrouping.assignee);
    expect(repository.assigneeBoardCalls, 1);

    repository.assigneeBoardResult = Right(
      _assigneeBoard(
        groups: [
          AssigneeKanbanGroupResponse(
            assigneeUserId: 'user-1',
            displayName: 'Marta',
            isCurrentUser: true,
            totalTaskCount: 1,
            tasks: [
              _card(
                id: 'task-1',
                version: 1,
                primaryAssigneeUserId: 'user-1',
                status: ProjectTaskStatus.inProgress,
              ),
            ],
          ),
        ],
      ),
    );

    await cubit.setFilterStatusColumn(status: ProjectTaskStatus.inProgress);

    // Osoba opisuje kolumnę, więc status jest filtrem kart: Backend dostaje go
    // razem z odczytem grup, a liczniki i karty opisują ten sam zbiór.
    expect(repository.assigneeBoardCalls, 2);
    expect(
      repository.assigneeBoardFilters.last.status,
      ProjectTaskStatus.inProgress,
    );
    final state = cubit.state as TasksBoardReady;
    expect(state.filter.status, ProjectTaskStatus.inProgress);
    expect(state.assigneeBoard!.groups.single.totalTaskCount, 1);

    await cubit.setFilterStatusColumn();
    expect(repository.assigneeBoardFilters.last.status, isNull);
  });

  test('status to jeden wymiar: własny zdejmuje systemowy jedną operacją', () async {
    final repository = _Repository();
    final cubit = _cubit(repository, _GroupingPreferenceStore());
    await cubit.load();
    await cubit.setGrouping(TasksBoardGrouping.assignee);

    await cubit.setFilterStatusColumn(status: ProjectTaskStatus.inProgress);
    var state = cubit.state as TasksBoardReady;
    expect(state.filter.status, ProjectTaskStatus.inProgress);
    expect(state.filter.customStatusId, isNull);

    // Wybór własnego statusu nie może zostawić obu filtrów: karta ma albo
    // własny status, albo systemowy, więc razem dają pustą tablicę.
    await cubit.setFilterStatusColumn(customStatusId: 'custom-1');
    state = cubit.state as TasksBoardReady;
    expect(state.filter.customStatusId, 'custom-1');
    expect(state.filter.status, isNull);
    expect(repository.assigneeBoardFilters.last.status, isNull);
    expect(repository.assigneeBoardFilters.last.customStatusId, 'custom-1');

    // „Pokaż wszystkie” to jedna operacja, nie dwie niezależne: inaczej między
    // wywołaniami powstaje stan z jednym filtrem i wyścig odświeżeń.
    final callsBefore = repository.assigneeBoardCalls;
    await cubit.setFilterStatusColumn();
    state = cubit.state as TasksBoardReady;
    expect(state.filter.status, isNull);
    expect(state.filter.customStatusId, isNull);
    expect(
      repository.assigneeBoardCalls,
      callsBefore + 1,
      reason: 'wyczyszczenie wymiaru odświeża tablicę dokładnie raz',
    );
  });

  test('powrót do widoku statusów zdejmuje filtr statusu', () async {
    final repository = _Repository();
    final cubit = _cubit(repository, _GroupingPreferenceStore());
    await cubit.load();
    await cubit.setGrouping(TasksBoardGrouping.assignee);
    await cubit.setFilterStatusColumn(status: ProjectTaskStatus.inProgress);

    // W widoku statusów kolumna sama jest statusem, więc filtr, którego
    // kontrolka tam nie istnieje, nie może dalej zawężać kolumn.
    await cubit.setGrouping(TasksBoardGrouping.status);

    final state = cubit.state as TasksBoardReady;
    expect(state.filter.status, isNull);
    expect(state.filter.customStatusId, isNull);
    expect(
      repository.boardFilters.last.status,
      isNull,
      reason: 'odczyt kolumn statusów nie może nieść ukrytego filtra statusu',
    );
  });

  test('przeniesienie do Nieprzypisane czyści wykonawców karty', () async {
    final repository = _Repository()
      ..changePrimaryResult = Right(
        ChangeKanbanPrimaryAssigneeResponse(
          task: _card(id: 'task-2', version: 5),
          previousAssigneeUserId: 'user-2',
          previousGroupTaskCount: 0,
          targetGroupTaskCount: 1,
        ),
      );
    final cubit = _cubit(repository, _GroupingPreferenceStore());
    await cubit.load();
    await cubit.setGrouping(TasksBoardGrouping.assignee);
    final task =
        (cubit.state as TasksBoardReady).assigneeBoard!.groups[2].tasks.single;

    await cubit.moveTaskToAssignee(task: task, targetUserId: null);

    final groups = (cubit.state as TasksBoardReady).assigneeBoard!.groups;
    final moved = groups[0].tasks.single;
    expect(moved.primaryAssigneeUserId, isNull);
    expect(moved.assigneeUserIds, isEmpty);
    expect(groups[2].totalTaskCount, 0);
    expect(
      groups[0].totalTaskCount,
      1,
      reason: 'licznik grupy docelowej pochodzi z odpowiedzi serwera',
    );
  });

  test('karta usunięta w innej sesji znika z lokalnych grup', () async {
    final repository = _Repository()
      ..changePrimaryResult = const Left(
        ApiError(
          type: ApiErrorType.notFound,
          message: 'Zadanie nie istnieje.',
          statusCode: 404,
          apiCode: 'task.not_found',
        ),
      );
    final cubit = _cubit(repository, _GroupingPreferenceStore());
    await cubit.load();
    await cubit.setGrouping(TasksBoardGrouping.assignee);
    final task =
        (cubit.state as TasksBoardReady).assigneeBoard!.groups[2].tasks.single;

    await cubit.moveTaskToAssignee(task: task, targetUserId: null);

    final state = cubit.state as TasksBoardReady;
    expect(
      state.assigneeBoard!.groups
          .expand((group) => group.tasks)
          .map((item) => item.id),
      isNot(contains('task-2')),
      reason: 'zadanie bez pary (404) nie może zostać na tablicy',
    );
    expect(state.pendingTaskIds, isEmpty);
  });
}

TasksBoardCubit _cubit(
  _Repository repository,
  _GroupingPreferenceStore preference,
) {
  final cubit = TasksBoardCubit(
    repository,
    _Realtime(),
    _TasksRepository(),
    viewPreferenceStore: preference,
    workspaceId: 'workspace-1',
    projectId: 'project-1',
  );
  addTearDown(cubit.close);
  return cubit;
}

KanbanTaskCardResponse _card({
  required String id,
  required int version,
  String? primaryAssigneeUserId,
  List<String>? assigneeUserIds,
  ProjectTaskStatus status = ProjectTaskStatus.todo,
}) => KanbanTaskCardResponse(
  id: id,
  number: 1,
  taskCode: 'TASK-1',
  title: 'Zadanie $id',
  status: status,
  priority: TaskPriority.normal,
  position: 100,
  checklistTotal: 0,
  checklistCompleted: 0,
  attachmentCount: 0,
  version: version,
  primaryAssigneeUserId: primaryAssigneeUserId,
  assigneeUserIds:
      assigneeUserIds ??
      (primaryAssigneeUserId == null ? const [] : [primaryAssigneeUserId]),
);

KanbanBoardResponse _statusBoard() => KanbanBoardResponse(
  projectId: 'project-1',
  swimlaneMode: KanbanSwimlaneMode.none,
  settingsVersion: 0,
  hiddenColumns: const [],
  visibleCardFields: const [],
  defaultCardDensity: KanbanCardDensity.comfortable,
  columns: [
    KanbanColumnResponse(
      status: ProjectTaskStatus.todo,
      displayName: 'Do zrobienia',
      color: '#6C5CE7',
      totalTaskCount: 1,
      isWipLimitExceeded: false,
      tasks: [_card(id: 'task-1', version: 1)],
    ),
    const KanbanColumnResponse(
      status: ProjectTaskStatus.inProgress,
      displayName: 'W toku',
      color: '#0984E3',
      totalTaskCount: 0,
      isWipLimitExceeded: false,
      tasks: [],
    ),
  ],
);

AssigneeKanbanBoardResponse _assigneeBoard({
  List<AssigneeKanbanGroupResponse>? groups,
}) => AssigneeKanbanBoardResponse(
  projectId: 'project-1',
  grouping: KanbanSwimlaneMode.assignee,
  settingsVersion: 0,
  visibleCardFields: const [],
  defaultCardDensity: KanbanCardDensity.comfortable,
  groups:
      groups ??
      [
        const AssigneeKanbanGroupResponse(
          displayName: 'Nieprzypisane',
          totalTaskCount: 0,
          tasks: [],
        ),
        AssigneeKanbanGroupResponse(
          assigneeUserId: 'user-1',
          displayName: 'Marta',
          isCurrentUser: true,
          totalTaskCount: 1,
          tasks: [
            _card(id: 'task-1', version: 1, primaryAssigneeUserId: 'user-1'),
          ],
        ),
        AssigneeKanbanGroupResponse(
          assigneeUserId: 'user-2',
          displayName: 'Adam',
          totalTaskCount: 1,
          tasks: [
            _card(
              id: 'task-2',
              version: 4,
              primaryAssigneeUserId: 'user-2',
              status: ProjectTaskStatus.inProgress,
            ),
          ],
          nextCursor: 'page-2',
        ),
      ],
);

/// Repozytorium zwracające wyłącznie to, czego wymaga ten scenariusz.
final class _Repository implements KanbanRepository {
  final List<String?> assigneeGroupPeople = [];
  final List<({String? targetUserId, int expectedVersion})>
  changePrimaryPeople = [];
  Either<ApiError, AssigneeKanbanBoardResponse>? assigneeBoardResult;
  Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>?
  assigneeGroupResult;
  Either<ApiError, ChangeKanbanPrimaryAssigneeResponse>? changePrimaryResult;

  /// Zapisane payloady preferencji widoku; brak wpisu = brak zapisu.
  final List<UpdateUserKanbanPreferencePayload> preferenceWrites = [];

  /// Gdy ustawione, mutacja czeka na decyzję testu (do sprawdzenia rollbacku).
  Completer<Either<ApiError, ChangeKanbanPrimaryAssigneeResponse>>?
  changePrimaryCompleter;
  int assigneeBoardCalls = 0;

  @override
  Future<Either<ApiError, UserKanbanPreferenceResponse>> getUserPreference({
    required String workspaceId,
    required String projectId,
  }) async => Right(
    UserKanbanPreferenceResponse(
      workspaceId: workspaceId,
      projectId: projectId,
      userId: 'user-1',
      collapsedColumns: const [],
      collapsedCustomStatusIds: const [],
      quickFilter: KanbanQuickFilter.all,
      version: 1,
    ),
  );

  @override
  Future<Either<ApiError, KanbanBoardResponse>> getBoard({
    required String workspaceId,
    required String projectId,
    KanbanBoardFilter filter = KanbanBoardFilter.none,
  }) async {
    boardFilters.add(filter);
    return Right(_statusBoard());
  }

  @override
  Future<Either<ApiError, UserKanbanPreferenceResponse>> updateUserPreference({
    required String workspaceId,
    required String projectId,
    required UpdateUserKanbanPreferencePayload payload,
  }) async {
    preferenceWrites.add(payload);
    return Right(
      UserKanbanPreferenceResponse(
        workspaceId: workspaceId,
        projectId: projectId,
        userId: 'user-1',
        collapsedColumns: payload.collapsedColumns,
        collapsedCustomStatusIds:
            payload.collapsedCustomStatusIds ?? const <String>[],
        quickFilter: payload.quickFilter,
        version: payload.expectedVersion + 1,
      ),
    );
  }

  /// Gdy ustawione, każdy odczyt grup czeka na decyzję testu — potrzebne do
  /// sprawdzenia wyścigu dwóch żądań.
  bool holdAssigneeBoard = false;
  final List<Completer<Either<ApiError, AssigneeKanbanBoardResponse>>>
  assigneeBoardRequests = [];

  /// Filtry, z którymi poproszono o tablicę osób — kolejność wywołań.
  final List<KanbanBoardFilter> assigneeBoardFilters = [];

  /// Filtry, z którymi poproszono o kolumny statusów — kolejność wywołań.
  final List<KanbanBoardFilter> boardFilters = [];

  @override
  Future<Either<ApiError, AssigneeKanbanBoardResponse>> getAssigneeBoard({
    required String workspaceId,
    required String projectId,
    KanbanBoardFilter filter = KanbanBoardFilter.none,
  }) {
    assigneeBoardCalls++;
    assigneeBoardFilters.add(filter);
    if (holdAssigneeBoard) {
      final completer =
          Completer<Either<ApiError, AssigneeKanbanBoardResponse>>();
      assigneeBoardRequests.add(completer);
      return completer.future;
    }
    return Future.value(assigneeBoardResult ?? Right(_assigneeBoard()));
  }

  @override
  Future<Either<ApiError, CursorPageResponse<KanbanTaskCardResponse>>>
  getAssigneeGroup({
    required String workspaceId,
    required String projectId,
    String? assigneeUserId,
    KanbanColumnQuery query = const KanbanColumnQuery(),
  }) async {
    assigneeGroupPeople.add(assigneeUserId);
    return assigneeGroupResult ??
        Right(
          CursorPageResponse(items: [_card(id: 'task-1', version: 2)]),
        );
  }

  @override
  Future<Either<ApiError, ChangeKanbanPrimaryAssigneeResponse>>
  changePrimaryAssignee({
    required String workspaceId,
    required String projectId,
    required String taskId,
    required String? targetUserId,
    required int expectedVersion,
  }) async {
    changePrimaryPeople.add((
      targetUserId: targetUserId,
      expectedVersion: expectedVersion,
    ));
    if (changePrimaryCompleter != null) return changePrimaryCompleter!.future;
    return changePrimaryResult ??
        Right(
          ChangeKanbanPrimaryAssigneeResponse(
            task: _card(
              id: taskId,
              version: expectedVersion + 1,
              primaryAssigneeUserId: targetUserId,
              assigneeUserIds: targetUserId == null
                  ? const <String>[]
                  : [targetUserId],
              status: ProjectTaskStatus.inProgress,
            ),
            previousAssigneeUserId: 'user-1',
            previousGroupTaskCount: 0,
            targetGroupTaskCount: 1,
          ),
        );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} nie jest używane w teście',
  );
}

final class _GroupingPreferenceStore implements TasksBoardViewPreferenceStore {
  _GroupingPreferenceStore({
    this.saved,
    this.savedColumns = const TasksBoardAssigneeColumnsPreference(),
  });

  final String? saved;
  final TasksBoardAssigneeColumnsPreference savedColumns;
  final List<({String workspaceId, String projectId, String grouping})> writes =
      [];
  final List<TasksBoardAssigneeColumnsPreference> columnWrites = [];

  /// Gdy ustawione, zapis kolumn czeka na decyzję testu.
  bool holdColumnWrites = false;
  final List<Completer<void>> columnWriteCompleters = [];

  /// Ile zapisów kolumn trwało jednocześnie — serializacja musi trzymać 1.
  int activeColumnWrites = 0;
  int maxConcurrentColumnWrites = 0;

  @override
  Future<TasksBoardGrouping?> readGrouping({
    required String workspaceId,
    required String projectId,
  }) async => TasksBoardGrouping.fromWire(saved);

  @override
  Future<void> writeGrouping({
    required String workspaceId,
    required String projectId,
    required TasksBoardGrouping grouping,
  }) async {
    writes.add((
      workspaceId: workspaceId,
      projectId: projectId,
      grouping: grouping.wireValue,
    ));
  }

  @override
  Future<TasksBoardAssigneeColumnsPreference> readAssigneeColumns({
    required String workspaceId,
    required String projectId,
  }) async => savedColumns;

  @override
  Future<void> writeAssigneeColumns({
    required String workspaceId,
    required String projectId,
    required TasksBoardAssigneeColumnsPreference preference,
  }) async {
    columnWrites.add(preference);
    activeColumnWrites++;
    maxConcurrentColumnWrites = activeColumnWrites > maxConcurrentColumnWrites
        ? activeColumnWrites
        : maxConcurrentColumnWrites;
    try {
      if (holdColumnWrites) {
        final completer = Completer<void>();
        columnWriteCompleters.add(completer);
        await completer.future;
      }
    } finally {
      activeColumnWrites--;
    }
  }
}

final class _Realtime implements TaskProjectRealtime {
  @override
  Stream<TaskProjectRealtimeUpdate> get updates =>
      const Stream<TaskProjectRealtimeUpdate>.empty();

  @override
  Stream<WorkspaceSignalRConnectionState> get connectionStates =>
      const Stream<WorkspaceSignalRConnectionState>.empty();

  @override
  Stream<WorkspaceScopedRealtimeError> get errors =>
      const Stream<WorkspaceScopedRealtimeError>.empty();

  @override
  dynamic noSuchMethod(Invocation invocation) => Future<void>.value();
}

final class _TasksRepository implements TasksRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnimplementedError(
    '${invocation.memberName} nie jest używane w teście',
  );
}
