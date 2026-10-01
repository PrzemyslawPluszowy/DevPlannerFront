import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/chrome/task_list_chrome_host.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/widgets/task_list_columns_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

final class _TasksRepository implements TasksRepository {
  @override
  Future<Either<ApiError, ProjectTaskGroupedListResponse>>
  listProjectTaskGroups({
    required String workspaceId,
    required String projectId,
    ProjectTasksGroupedQuery query = const ProjectTasksGroupedQuery(),
  }) async => const Right(
    ProjectTaskGroupedListResponse(
      totalCount: 0,
      groupBy: TaskSavedViewGroupBy.status,
      groups: [],
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _ConfigurationRepository
    implements TaskListConfigurationRepository {
  @override
  Future<Either<ApiError, EffectiveTaskListConfigurationResponse>>
  getEffectiveConfiguration({
    required String workspaceId,
    required String projectId,
  }) async => const Right(
    EffectiveTaskListConfigurationResponse(
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      effectiveVisibleColumns: ['sys:key', 'sys:title'],
      effectiveColumnWidths: {'sys:key': 90.0, 'sys:title': 280.0},
      availableColumns: ['sys:key', 'sys:title'],
      requiredColumns: ['sys:title'],
      sortField: TaskSavedViewSortField.position,
      sortDirection: TaskSavedViewSortDirection.ascending,
      groupBy: TaskSavedViewGroupBy.status,
      userPreferenceVersion: 1,
      policyVersion: 1,
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _MetadataRepository implements TaskMetadataRepository {
  @override
  Future<Either<ApiError, List<TaskCustomFieldResponse>>> listCustomFields({
    required String workspaceId,
    required String projectId,
  }) async => const Right(<TaskCustomFieldResponse>[]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _DeferredMetadataRepository extends _MetadataRepository {
  final Completer<Either<ApiError, List<TaskCustomFieldResponse>>> response =
      Completer();

  @override
  Future<Either<ApiError, List<TaskCustomFieldResponse>>> listCustomFields({
    required String workspaceId,
    required String projectId,
  }) => response.future;
}

final class _CollaborationRepository implements TaskCollaborationRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _RecurrenceRepository implements TaskRecurrenceRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _harness({
  required TaskMetadataRepository metadata,
  required Locale locale,
  required Widget child,
}) => MultiRepositoryProvider(
  providers: [
    RepositoryProvider<TasksRepository>.value(value: _TasksRepository()),
    RepositoryProvider<TaskListConfigurationRepository>.value(
      value: _ConfigurationRepository(),
    ),
    RepositoryProvider<TaskMetadataRepository>.value(value: metadata),
    RepositoryProvider<TaskCollaborationRepository>.value(
      value: _CollaborationRepository(),
    ),
    RepositoryProvider<TaskRecurrenceRepository>.value(
      value: _RecurrenceRepository(),
    ),
  ],
  child: MaterialApp(
    locale: locale,
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  ),
);

Widget _host({Key? key}) => TaskListChromeHost(
  key: key,
  workspaceId: 'workspace-1',
  projectId: 'project-1',
  savedViewId: null,
  groupBy: TaskSavedViewGroupBy.status,
  memberProfilesByUserId: const {},
  builder: (context, chrome) => chrome.commandBar,
);

Future<void> _pump(
  WidgetTester tester, {
  required TaskMetadataRepository metadata,
  Locale locale = const Locale('pl'),
  Key? hostKey,
}) async {
  tester.view.physicalSize = const Size(1920, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(
    _harness(
      metadata: metadata,
      locale: locale,
      child: _host(key: hostKey),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('etykiety listy i menu są dostępne po polsku i angielsku', (
    tester,
  ) async {
    for (final testCase in [
      (
        locale: const Locale('pl'),
        all: 'Wszystkie osoby',
        unassigned: 'Nieprzypisane',
        pinned: 'Przypięte przeze mnie',
        direction: 'Kierunek sortowania',
        ascending: 'Rosnąco',
        descending: 'Malejąco',
      ),
      (
        locale: const Locale('en'),
        all: 'All people',
        unassigned: 'Unassigned',
        pinned: 'Pinned by me',
        direction: 'Sort direction',
        ascending: 'Ascending',
        descending: 'Descending',
      ),
    ]) {
      await _pump(
        tester,
        metadata: _MetadataRepository(),
        locale: testCase.locale,
      );
      expect(find.text(testCase.pinned), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('command_filter_assignee')));
      await tester.pumpAndSettle();
      expect(find.text(testCase.all), findsOneWidget);
      expect(find.text(testCase.unassigned), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('command_sort_direction')));
      await tester.pumpAndSettle();
      expect(find.text(testCase.direction), findsOneWidget);
      expect(find.text(testCase.ascending), findsWidgets);
      expect(find.text(testCase.descending), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
    }
  });

  testWidgets('stary odczyt nie otwiera arkusza po podmianie repozytorium', (
    tester,
  ) async {
    final oldRepository = _DeferredMetadataRepository();
    await _pump(tester, metadata: oldRepository);
    await tester.tap(find.byKey(const ValueKey('command_columns')));
    await tester.pump();

    await _pump(tester, metadata: _MetadataRepository());
    oldRepository.response.complete(
      const Right(<TaskCustomFieldResponse>[]),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TaskListColumnsSheet), findsNothing);

    await tester.tap(find.byKey(const ValueKey('command_columns')));
    await tester.pumpAndSettle();
    expect(find.byType(TaskListColumnsSheet), findsOneWidget);
  });

  testWidgets('odczyt kolumn kończący się po dispose jest ignorowany', (
    tester,
  ) async {
    final repository = _DeferredMetadataRepository();
    await _pump(tester, metadata: repository);
    await tester.tap(find.byKey(const ValueKey('command_columns')));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    repository.response.complete(const Right(<TaskCustomFieldResponse>[]));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
