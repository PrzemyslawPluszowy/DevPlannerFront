import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/l10n/app_localizations.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:ready_next/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:ready_next/workspaces/data/shared/enums/task_contract_enums.dart';
import 'package:ready_next/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:ready_next/workspaces/presentation/tasks/list/preferences/widgets/task_list_columns_sheet.dart';

final class _MockTaskListConfigurationRepository
    implements TaskListConfigurationRepository {
  EffectiveTaskListConfigurationResponse? effectiveConfig;
  int resetCallCount = 0;

  @override
  Future<Either<ApiError, EffectiveTaskListConfigurationResponse>>
  getEffectiveConfiguration({
    required String workspaceId,
    required String projectId,
  }) async {
    if (effectiveConfig != null) return Right(effectiveConfig!);
    return const Left(
      ApiError(type: ApiErrorType.notFound, message: 'Not found'),
    );
  }

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>>
  updateUserPreference({
    required String workspaceId,
    required String projectId,
    required UpdateTaskListUserPreferencePayload payload,
  }) async {
    return Right(
      TaskListUserPreferenceResponse(
        workspaceId: workspaceId,
        projectId: projectId,
        coreUserId: 'user-1',
        visibleColumns: payload.visibleColumns,
        columnWidths: payload.columnWidths,
        version: payload.expectedVersion + 1,
      ),
    );
  }

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>> resetUserPreference({
    required String workspaceId,
    required String projectId,
  }) async {
    resetCallCount++;
    return const Right(
      TaskListUserPreferenceResponse(
        workspaceId: 'ws-1',
        projectId: 'proj-1',
        coreUserId: 'user-1',
        visibleColumns: [],
        columnWidths: {},
        version: 1,
      ),
    );
  }

  @override
  Future<Either<ApiError, ProjectTaskListPolicyResponse>> getPolicy({
    required String workspaceId,
    required String projectId,
  }) async => Right(
    ProjectTaskListPolicyResponse(
      workspaceId: workspaceId,
      projectId: projectId,
      availableColumns: const ['title', 'status', 'priority'],
      requiredColumns: const ['title'],
      defaultColumns: const ['title', 'status'],
      defaultColumnWidths: const {},
      defaultSortField: TaskSavedViewSortField.position,
      defaultSortDirection: TaskSavedViewSortDirection.ascending,
      defaultGroupBy: TaskSavedViewGroupBy.status,
      updatedAtUtc: DateTime.now(),
      version: 1,
    ),
  );

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>> getUserPreference({
    required String workspaceId,
    required String projectId,
  }) async => throw UnimplementedError();

  int updatePolicyCallCount = 0;

  @override
  Future<Either<ApiError, ProjectTaskListPolicyResponse>> updatePolicy({
    required String workspaceId,
    required String projectId,
    required UpdateProjectTaskListPolicyPayload payload,
  }) async {
    updatePolicyCallCount++;
    return Right(
      ProjectTaskListPolicyResponse(
        workspaceId: workspaceId,
        projectId: projectId,
        availableColumns: payload.availableColumns,
        requiredColumns: payload.requiredColumns,
        defaultColumns: payload.defaultColumns,
        defaultColumnWidths: payload.defaultColumnWidths,
        defaultSortField: payload.defaultSortField,
        defaultSortDirection: payload.defaultSortDirection,
        defaultGroupBy: payload.defaultGroupBy,
        updatedAtUtc: DateTime.now(),
        version: payload.expectedVersion + 1,
      ),
    );
  }
}

void main() {
  late _MockTaskListConfigurationRepository repo;
  late TaskListPreferencesCubit cubit;

  setUp(() {
    repo = _MockTaskListConfigurationRepository();
    repo.effectiveConfig = const EffectiveTaskListConfigurationResponse(
      workspaceId: 'ws-1',
      projectId: 'proj-1',
      availableColumns: [
        'sys:title',
        'sys:status',
        'sys:priority',
        'cf:cf-1',
      ],
      requiredColumns: [
        'sys:title',
      ],
      effectiveVisibleColumns: [
        'sys:title',
        'sys:status',
        'sys:priority',
      ],
      effectiveColumnWidths: {
        'sys:title': 200.0,
        'sys:status': 120.0,
      },
      sortField: TaskSavedViewSortField.position,
      sortDirection: TaskSavedViewSortDirection.ascending,
      groupBy: TaskSavedViewGroupBy.status,
      userPreferenceVersion: 1,
      policyVersion: 1,
    );
    cubit = TaskListPreferencesCubit(
      repository: repo,
      workspaceId: 'ws-1',
      projectId: 'proj-1',
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  final customFields = [
    const TaskCustomFieldResponse(
      id: 'cf-1',
      name: 'Klient VIP',
      type: TaskCustomFieldType.boolean,
      position: 1,
      isRequired: false,
    ),
  ];

  Widget buildTestWidget({bool canManage = false}) => MaterialApp(
    locale: const Locale('pl'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: Center(
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => TaskListColumnsSheet.show(
              context,
              cubit: cubit,
              customFields: customFields,
              canManage: canManage,
            ),
            child: const Text('Otwórz konfigurację'),
          ),
        ),
      ),
    ),
  );

  testWidgets('arkusz konfiguracji renderuje dostępne kolumny i oznaczenia', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await cubit.load();
    await tester.pumpWidget(buildTestWidget());

    // Otwórz arkusz
    await tester.tap(find.text('Otwórz konfigurację'));
    await tester.pumpAndSettle();

    // Sprawdź nagłówek arkusza
    expect(find.text('Dostosuj kolumny'), findsOneWidget);

    // Sprawdź obecność kolumny wymaganej 'Zadanie' (sys:title) i ikony kłódki
    expect(find.text('Zadanie'), findsOneWidget);
    expect(find.byIcon(Symbols.lock_rounded), findsWidgets);

    // Sprawdź obecność innych kolumn
    expect(find.text('Status'), findsOneWidget);
    expect(find.text('Priorytet'), findsOneWidget);
    expect(find.text('Klient VIP'), findsOneWidget);

    // Sprawdź przycisk przywracania domyślnych
    expect(find.text('Przywróć domyślne'), findsOneWidget);
  });

  testWidgets('wyszukiwarka filtruje widoczne kolumny', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await cubit.load();
    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.text('Otwórz konfigurację'));
    await tester.pumpAndSettle();

    // Wpisz zapytanie w wyszukiwarkę
    await tester.enterText(find.byType(TextField), 'Klient');
    await tester.pumpAndSettle();

    // Powinno pokazywać tylko 'Klient VIP' w sekcji puli
    expect(find.text('Klient VIP'), findsOneWidget);
    expect(find.text('Kolumny standardowe'), findsNothing);
  });

  testWidgets('przełączenie widoczności dozwolonej kolumny aktualizuje stan', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await cubit.load();
    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.text('Otwórz konfigurację'));
    await tester.pumpAndSettle();

    // Kafelek dla 'Klient VIP' (początkowo w sekcji puli dostępnych pól)
    final vipFinder = find.text('Klient VIP');
    expect(vipFinder, findsOneWidget);

    await tester.ensureVisible(vipFinder);
    await tester.pumpAndSettle();

    await tester.tap(vipFinder);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 600));

    // Sprawdź czy pole 'cf-1' zostało włączone w cubit
    final readyState = cubit.state as TaskListPreferencesReady;
    expect(
      readyState.effectiveVisibleColumns.any((c) => c.id == 'cf:cf-1'),
      isTrue,
    );
  });

  testWidgets('przycisk przywrócenia domyślnych projektu wywołuje reset', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await cubit.load();
    await tester.pumpWidget(buildTestWidget());

    await tester.tap(find.text('Otwórz konfigurację'));
    await tester.pumpAndSettle();

    final resetButton = find.text('Przywróć domyślne');
    expect(resetButton, findsOneWidget);

    await tester.tap(resetButton);
    await tester.pumpAndSettle();

    expect(repo.resetCallCount, equals(1));
  });

  testWidgets(
    'administrator widzi przełącznik zakładek i może zapisać domyślne projektu',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await cubit.load();
      await tester.pumpWidget(buildTestWidget(canManage: true));

      await tester.tap(find.text('Otwórz konfigurację'));
      await tester.pumpAndSettle();

      // Sprawdź obecność obu zakładek
      expect(find.text('Moje ustawienia'), findsOneWidget);
      expect(find.text('Domyślne projektu (Admin)'), findsOneWidget);

      // Przełącz na zakładkę domyślnych projektu
      await tester.tap(find.text('Domyślne projektu (Admin)'));
      await tester.pumpAndSettle();

      // Sprawdź obecność przycisku zapisu dla projektu
      final saveProjectButton = find.text('Zapisz jako domyślne projektu');
      expect(saveProjectButton, findsOneWidget);

      await tester.tap(saveProjectButton);
      await tester.pumpAndSettle();

      // Zweryfikuj wywołanie updatePolicy w repozytorium
      expect(repo.updatePolicyCallCount, equals(1));
    },
  );
}
