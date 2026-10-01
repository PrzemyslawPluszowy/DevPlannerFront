import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/shared/cursor_page_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/task_priority.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_cubit.dart';
import 'package:devplanner/workspaces/presentation/tasks/search/tasks_global_search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Repository implements TaskViewRepository {
  int requests = 0;

  @override
  Future<Either<ApiError, CursorPageResponse<GlobalTaskSearchItemResponse>>>
  searchTasks({
    required String query,
    String? workspaceId,
    String? projectId,
    String? status,
    int limit = 50,
    String? cursor,
  }) async {
    requests++;
    if ((query == 'diagnostics' || query == 'many-diagnostics') &&
        cursor != null) {
      return Left(
        ApiError(
          type: ApiErrorType.server,
          message: 'Search is temporarily unavailable. Your query is retained.',
          statusCode: 503,
          apiCode: 'tasks.search_unavailable',
          contractCode: 'tasks.search_unavailable',
          backendCode: 721,
          fields: {
            for (var index = 0; index < 18; index++)
              'filter-$index': [
                'Long validation detail for filter $index that should remain readable in a scrollable diagnostics area.',
              ],
          },
          traceId: 'trace-search-result-503-with-a-long-diagnostic-identifier',
          retryAfterUtc: DateTime.now().toUtc().add(const Duration(seconds: 8)),
        ),
      );
    }
    if (query == 'diagnostics') {
      return Right(
        CursorPageResponse(
          items: [_item('diagnostic-task', 'First result remains available')],
          nextCursor: 'cursor-next',
        ),
      );
    }
    if (query == 'many-diagnostics') {
      return Right(
        CursorPageResponse(
          items: [
            for (var index = 0; index < 20; index++)
              _item(
                'many-diagnostic-$index',
                'Long search result number $index with context',
              ),
          ],
          nextCursor: 'cursor-diagnostics',
        ),
      );
    }
    if (query == 'fail') {
      return const Left(
        ApiError(type: ApiErrorType.unknown, message: 'offline'),
      );
    }
    if (query == 'none') {
      return const Right(CursorPageResponse(items: []));
    }
    return Right(
      CursorPageResponse(
        items: [
          if (query == 'many')
            for (var index = 0; index < 30; index++)
              _item(
                'many-$index',
                'Long search result number $index with context',
              ),
          if (query != 'many') _item('task-1', 'First result'),
          if (query != 'many') _item('task-2', 'Second result'),
        ],
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

GlobalTaskSearchItemResponse _item(String id, String title) =>
    GlobalTaskSearchItemResponse(
      id: id,
      number: 1,
      key: 'DP-1',
      workspaceId: 'workspace-1',
      workspaceName: 'Workspace',
      projectId: 'project-1',
      projectName: 'Project',
      title: title,
      matchedLabels: const [],
      score: 1,
      status: ProjectTaskStatus.todo,
      priority: TaskPriority.normal,
      updatedAtUtc: DateTime.utc(2026),
      version: 1,
    );

Widget _host({
  required TasksGlobalSearchCubit cubit,
  required Brightness brightness,
  required Locale locale,
  required ValueChanged<GlobalTaskSearchItemResponse> onOpen,
  double textScale = 1,
}) {
  final materialTheme = MaterialTheme.crm();
  return MaterialApp(
    theme: brightness == Brightness.light
        ? materialTheme.light()
        : materialTheme.dark(),
    locale: locale,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(textScale),
      ),
      child: child!,
    ),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Center(
        child: Builder(
          builder: (context) => FilledButton(
            onPressed: () => DevPlannerModalHost.showDialog<void>(
              context,
              builder: (_) => BlocProvider.value(
                value: cubit,
                child: TasksGlobalSearchDialog(onOpenTask: onOpen),
              ),
            ),
            child: const Text('Open search'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('keyboard moves selection and opens the selected task', (
    tester,
  ) async {
    final repository = _Repository();
    final cubit = TasksGlobalSearchCubit(repository: repository);
    addTearDown(() async {
      if (!cubit.isClosed) await cubit.close();
    });
    GlobalTaskSearchItemResponse? opened;

    await tester.pumpWidget(
      _host(
        cubit: cubit,
        brightness: Brightness.light,
        locale: const Locale('en'),
        onOpen: (task) => opened = task,
      ),
    );
    await tester.tap(find.text('Open search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'tasks');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(find.text('First result'), findsOneWidget);
    expect(repository.requests, 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(opened?.id, 'task-2');
  });

  testWidgets('search remains usable at 200 percent in narrow viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final cubit = TasksGlobalSearchCubit(repository: _Repository());
    addTearDown(() async {
      if (!cubit.isClosed) await cubit.close();
    });
    GlobalTaskSearchItemResponse? opened;
    await tester.pumpWidget(
      _host(
        cubit: cubit,
        brightness: Brightness.dark,
        locale: const Locale('pl'),
        textScale: 2,
        onOpen: (task) => opened = task,
      ),
    );
    await tester.tap(find.text('Open search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'tasks');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(find.text('Second result').hitTestable(), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(opened?.id, 'task-2');
  });

  testWidgets('scaled keyboard scrolling keeps selected result visible', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(600, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final cubit = TasksGlobalSearchCubit(repository: _Repository());
    addTearDown(() async {
      if (!cubit.isClosed) await cubit.close();
    });
    GlobalTaskSearchItemResponse? opened;
    await tester.pumpWidget(
      _host(
        cubit: cubit,
        brightness: Brightness.light,
        locale: const Locale('en'),
        textScale: 2,
        onOpen: (task) => opened = task,
      ),
    );
    await tester.tap(find.text('Open search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'many');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    for (var index = 0; index < 20; index++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
    }
    expect(tester.takeException(), isNull);
    expect(
      find.text('Long search result number 20 with context').hitTestable(),
      findsOneWidget,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(opened?.id, 'many-20');
  });

  testWidgets('Escape closes the root-hosted search dialog', (tester) async {
    final cubit = TasksGlobalSearchCubit(repository: _Repository());
    addTearDown(() async {
      if (!cubit.isClosed) await cubit.close();
    });
    await tester.pumpWidget(
      _host(
        cubit: cubit,
        brightness: Brightness.dark,
        locale: const Locale('en'),
        onOpen: (_) {},
      ),
    );
    await tester.tap(find.text('Open search'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('empty and error states are localized in light and dark', (
    tester,
  ) async {
    for (final brightness in Brightness.values) {
      final repository = _Repository();
      final cubit = TasksGlobalSearchCubit(repository: repository);
      addTearDown(() async {
        if (!cubit.isClosed) await cubit.close();
      });
      await tester.pumpWidget(
        _host(
          cubit: cubit,
          brightness: brightness,
          locale: const Locale('pl'),
          onOpen: (_) {},
        ),
      );
      await tester.tap(find.text('Open search'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'none');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      expect(find.text('Nie znaleziono zadań'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'fail');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      expect(find.text('Nie udało się wyszukać zadań'), findsOneWidget);
      expect(find.text('Spróbuj ponownie'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await cubit.close();
    }
  });

  testWidgets('long typed failure stays bounded with results at 200 percent', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final configuration in [
      (Brightness.light, const Locale('en')),
      (Brightness.dark, const Locale('pl')),
    ]) {
      final repository = _Repository();
      final cubit = TasksGlobalSearchCubit(repository: repository);
      addTearDown(() async {
        if (!cubit.isClosed) await cubit.close();
      });
      await tester.pumpWidget(
        _host(
          cubit: cubit,
          brightness: configuration.$1,
          locale: configuration.$2,
          textScale: 2,
          onOpen: (_) {},
        ),
      );
      await tester.tap(find.text('Open search'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'diagnostics');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump();
      expect(find.text('First result remains available'), findsOneWidget);
      final loadMore = find.text(
        configuration.$2.languageCode == 'pl'
            ? 'Pokaż kolejne wyniki'
            : 'Load more results',
      );
      await tester.drag(find.byType(ListView), const Offset(0, -2200));
      await tester.pump();
      await tester.ensureVisible(loadMore);
      await tester.tap(loadMore);
      await tester.pump();
      await tester.pump();

      expect(
        find.text(
          configuration.$2.languageCode == 'pl'
              ? 'Wyszukiwanie jest tymczasowo wstrzymane'
              : 'Search is temporarily paused',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Search is temporarily unavailable. Your query is retained.'),
        findsOneWidget,
      );
      expect(
        find.text('First result remains available').hitTestable(),
        findsOneWidget,
      );
      final detailsLabel = configuration.$2.languageCode == 'pl'
          ? 'Pokaż szczegóły błędu'
          : 'Show error details';
      expect(find.text(detailsLabel), findsOneWidget);
      final retryLabel = configuration.$2.languageCode == 'pl'
          ? 'Spróbuj ponownie'
          : 'Try again';
      expect(
        tester
            .widget<TextButton>(
              find.widgetWithText(TextButton, retryLabel),
            )
            .onPressed,
        isNull,
      );
      await tester.ensureVisible(find.text(detailsLabel));
      expect(find.text(detailsLabel).hitTestable(), findsOneWidget);
      await tester.tap(find.text(detailsLabel));
      await tester.pump();
      expect(
        find.byKey(const ValueKey('tasks-global-search-diagnostics')),
        findsOneWidget,
      );
      expect(
        find.textContaining(
          'trace-search-result-503-with-a-long-diagnostic-identifier',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox.shrink());
      await cubit.close();
    }
  });

  testWidgets('expanded cooldown details keep keyboard selection visible', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(420, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final cubit = TasksGlobalSearchCubit(repository: _Repository());
    addTearDown(() async {
      if (!cubit.isClosed) await cubit.close();
    });

    await tester.pumpWidget(
      _host(
        cubit: cubit,
        brightness: Brightness.dark,
        locale: const Locale('pl'),
        textScale: 2,
        onOpen: (_) {},
      ),
    );
    await tester.tap(find.text('Open search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'many-diagnostics');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    final loadMore = find.text('Pokaż kolejne wyniki');
    await tester.drag(find.byType(ListView), const Offset(0, -2200));
    await tester.pump();
    await tester.ensureVisible(loadMore);
    await tester.tap(loadMore);
    await tester.pump();
    await tester.pump();
    await tester.ensureVisible(find.text('Pokaż szczegóły błędu'));
    expect(find.text('Pokaż szczegóły błędu').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Pokaż szczegóły błędu'));
    await tester.pump();

    Focus.of(tester.element(find.byType(TextField))).requestFocus();
    await tester.pump();
    for (var index = 0; index < 19; index++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
    }
    expect(
      find.text('Long search result number 19 with context').hitTestable(),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await cubit.close();
  });
  testWidgets('Enter on diagnostics does not open the selected task', (
    tester,
  ) async {
    final cubit = TasksGlobalSearchCubit(repository: _Repository());
    addTearDown(() async {
      if (!cubit.isClosed) await cubit.close();
    });
    GlobalTaskSearchItemResponse? opened;
    await tester.pumpWidget(
      _host(
        cubit: cubit,
        brightness: Brightness.light,
        locale: const Locale('en'),
        onOpen: (item) => opened = item,
      ),
    );
    await tester.tap(find.text('Open search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'diagnostics');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    await tester.tap(find.text('Load more results'));
    await tester.pump();
    await tester.pump();
    final details = find.text('Show error details');
    await tester.ensureVisible(details);
    Focus.of(tester.element(details)).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(opened, isNull);
    expect(
      find.byKey(const ValueKey('tasks-global-search-diagnostics')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await cubit.close();
  });
}
