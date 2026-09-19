import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/cubit/task_saved_views_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/models/task_list_view_snapshot.dart';
import 'package:devplanner/workspaces/presentation/tasks/views/widgets/task_saved_views_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

final class _MockTaskViewRepository implements TaskViewRepository {
  _MockTaskViewRepository({List<TaskSavedViewResponse>? views})
    : views = views ?? [_sampleView];

  final List<TaskSavedViewResponse> views;
  CreateTaskSavedViewPayload? created;

  @override
  Future<Either<ApiError, List<TaskSavedViewResponse>>> list({
    required String workspaceId,
    required String projectId,
  }) async => Right(views);

  @override
  Future<Either<ApiError, TaskSavedViewResponse>> create({
    required String workspaceId,
    required String projectId,
    required CreateTaskSavedViewPayload payload,
  }) async {
    created = payload;
    return Right(
      TaskSavedViewResponse(
        id: 'view-created',
        name: payload.name,
        createdAtUtc: DateTime.utc(2026),
        updatedAtUtc: DateTime.utc(2026),
        view: payload.view,
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final _sampleView = TaskSavedViewResponse(
  id: 'view-sample',
  name: 'Mój widok',
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  view: const TaskSavedViewDefinition(
    filter: TaskSavedViewFilter(statuses: [ProjectTaskStatus.todo]),
    sortField: TaskSavedViewSortField.position,
    sortDirection: TaskSavedViewSortDirection.ascending,
    groupBy: TaskSavedViewGroupBy.none,
    columns: [TaskSavedViewColumn.title],
  ),
);

final _teamView = TaskSavedViewResponse(
  id: 'view-team',
  name: 'Widok zespołu',
  createdAtUtc: DateTime.utc(2026),
  updatedAtUtc: DateTime.utc(2026),
  view: const TaskSavedViewDefinition(
    filter: TaskSavedViewFilter(),
    sortField: TaskSavedViewSortField.position,
    sortDirection: TaskSavedViewSortDirection.ascending,
    groupBy: TaskSavedViewGroupBy.none,
    columns: [TaskSavedViewColumn.title],
  ),
);

Widget _buildTestableWidget({
  required TaskSavedViewsCubit cubit,
  TaskListViewSnapshot? snapshot,
}) => MaterialApp(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  locale: const Locale('pl'),
  home: Scaffold(
    body: BlocProvider.value(
      value: cubit,
      child: TaskSavedViewsMenu(
        compact: false,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        currentSnapshot: snapshot,
      ),
    ),
  ),
);

void main() {
  testWidgets(
    'Menu wyświetla widok domyślny i zapisaną listę, pozwala przełączać',
    (tester) async {
      final repo = _MockTaskViewRepository();
      final cubit = TaskSavedViewsCubit(
        repository: repo,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      await cubit.load();

      final testSnapshot = TaskListViewSnapshot(
        filter: const TaskSavedViewFilter(),
        sortField: TaskSavedViewSortField.position,
        sortDirection: TaskSavedViewSortDirection.ascending,
        groupBy: TaskSavedViewGroupBy.none,
        columns: const [TaskSavedViewColumn.title],
        customFieldIds: const [],
        columnOrder: const ['sys:title'],
      );

      await tester.pumpWidget(
        _buildTestableWidget(cubit: cubit, snapshot: testSnapshot),
      );
      await tester.pumpAndSettle();

      // Domyślnie aktywny jest widok domyślny
      expect(find.text('Widok domyślny'), findsOneWidget);

      // Otwórz menu
      await tester.tap(find.byType(TaskSavedViewsMenu));
      await tester.pumpAndSettle();

      // Sprawdź pozycje w menu
      expect(find.text('Zapisz bieżący widok'), findsOneWidget);
      expect(
        find.text('Widok domyślny'),
        findsNWidgets(2),
      ); // Na przycisku i w menu
      expect(find.text('Mój widok'), findsOneWidget);

      // Kliknij "Mój widok"
      await tester.tap(find.text('Mój widok'));
      await tester.pumpAndSettle();

      // Teraz przycisk główny wyświetla "Mój widok"
      expect(find.text('Mój widok'), findsOneWidget);
      expect((cubit.state as TaskSavedViewsReady).activeViewId, 'view-sample');

      // Ponownie otwórz menu i wybierz "Widok domyślny"
      await tester.tap(find.byType(TaskSavedViewsMenu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Widok domyślny').last);
      await tester.pumpAndSettle();

      expect((cubit.state as TaskSavedViewsReady).activeViewId, isNull);

      await cubit.close();
    },
  );

  testWidgets(
    'każdy widok ma jedno „…", a jego akcje są zakotwiczone w klikniętym wierszu',
    (tester) async {
      final repo = _MockTaskViewRepository(views: [_sampleView, _teamView]);
      final cubit = TaskSavedViewsCubit(
        repository: repo,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      await cubit.load();

      await tester.pumpWidget(_buildTestableWidget(cubit: cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TaskSavedViewsMenu));
      await tester.pumpAndSettle();

      // Menu listy widoków nie duplikuje pozycji zarządzania tekstem.
      expect(find.text('Zarządzaj widokiem'), findsNothing);
      expect(
        find.byTooltip('Zarządzaj widokiem'),
        findsNWidgets(2),
        reason: 'każdy widok ma dokładnie jedną akcję w wierszu',
      );

      final listMenuOption = tester.getRect(find.text('Zapisz bieżący widok'));
      final clickedRow = tester.getRect(find.text('Widok zespołu'));

      // Akcje wiersza otwierają się z przycisku „…" drugiego widoku.
      await tester.tap(find.byTooltip('Zarządzaj widokiem').at(1));
      await tester.pumpAndSettle();

      // Menu listy widoków jest zamknięte, więc pod spodem nie zostaje lista.
      expect(find.text('Zapisz bieżący widok'), findsNothing);
      expect(find.text('Mój widok'), findsNothing);
      expect(find.text('Widok zespołu'), findsOneWidget);

      // Kliknięcie „…” nie wybiera widoku.
      expect((cubit.state as TaskSavedViewsReady).activeViewId, isNull);

      final itemMenuOption = tester.getRect(find.text('Zarządzaj widokiem'));
      expect(
        itemMenuOption.left,
        greaterThan(listMenuOption.left + 100),
        reason: 'akcje wiersza startują z prawej krawędzi wiersza, nie z triggera',
      );
      expect(
        itemMenuOption.top,
        greaterThan(listMenuOption.top + 40),
        reason: 'menu akcji nie otwiera się w miejscu menu listy widoków',
      );
      expect(
        (itemMenuOption.top - clickedRow.top).abs(),
        lessThan(120),
        reason: 'menu akcji jest zakotwiczone w klikniętym wierszu',
      );

      await cubit.close();
    },
  );

  testWidgets(
    'Zapisz bieżący widok otwiera TaskSavedViewNameDialog z bieżącym snapshotem',
    (tester) async {
      final repo = _MockTaskViewRepository();
      final cubit = TaskSavedViewsCubit(
        repository: repo,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      );
      await cubit.load();

      final currentSnapshot = TaskListViewSnapshot(
        filter: const TaskSavedViewFilter(pinnedOnly: true),
        sortField: TaskSavedViewSortField.dueAtUtc,
        sortDirection: TaskSavedViewSortDirection.descending,
        groupBy: TaskSavedViewGroupBy.priority,
        columns: const [
          TaskSavedViewColumn.title,
          TaskSavedViewColumn.dueAtUtc,
        ],
        customFieldIds: const [],
        columnOrder: const ['sys:title', 'sys:dueAtUtc'],
      );

      await tester.pumpWidget(
        _buildTestableWidget(cubit: cubit, snapshot: currentSnapshot),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(TaskSavedViewsMenu));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Zapisz bieżący widok'));
      await tester.pumpAndSettle();

      // Sprawdź obecność dialogu zapisu
      expect(find.text('Zapisz bieżący widok'), findsWidgets);
      expect(find.text('Konfiguracja do zapisania:'), findsOneWidget);

      // Wpisz nazwę i zatwierdź
      await tester.enterText(find.byType(TextField), 'Widok priorytetowy');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Zapisz'));
      await tester.pumpAndSettle();

      expect(repo.created?.name, 'Widok priorytetowy');
      expect(repo.created?.view.sortField, TaskSavedViewSortField.dueAtUtc);
      expect(repo.created?.view.filter.pinnedOnly, isTrue);

      await cubit.close();
    },
  );
}
