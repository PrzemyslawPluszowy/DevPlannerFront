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
  CreateTaskSavedViewPayload? created;

  @override
  Future<Either<ApiError, List<TaskSavedViewResponse>>> list({
    required String workspaceId,
    required String projectId,
  }) async => Right([_sampleView]);

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
