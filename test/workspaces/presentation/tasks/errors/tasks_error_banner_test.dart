import 'package:dartz/dartz.dart';
import 'package:devplanner/core/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/chrome/tasks_error_banner_host.dart';
import 'package:devplanner/workspaces/presentation/tasks/errors/tasks_error_banner.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/preferences/cubit/task_list_preferences_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class _StubTaskListConfigurationRepository
    implements TaskListConfigurationRepository {
  int? statusCodeOnUpdate;
  int updateCallCount = 0;
  bool failRead = false;

  static const config = EffectiveTaskListConfigurationResponse(
    workspaceId: 'ws-1',
    projectId: 'proj-1',
    availableColumns: ['sys:title', 'sys:status'],
    requiredColumns: ['sys:title'],
    effectiveVisibleColumns: ['sys:title', 'sys:status'],
    effectiveColumnWidths: {'sys:title': 200.0},
    sortField: TaskSavedViewSortField.position,
    sortDirection: TaskSavedViewSortDirection.ascending,
    groupBy: TaskSavedViewGroupBy.status,
    userPreferenceVersion: 1,
    policyVersion: 1,
  );

  @override
  Future<Either<ApiError, EffectiveTaskListConfigurationResponse>>
  getEffectiveConfiguration({
    required String workspaceId,
    required String projectId,
  }) async {
    if (failRead) {
      return const Left(
        ApiError(
          type: ApiErrorType.server,
          message: 'Nie można wczytać konfiguracji',
        ),
      );
    }
    return const Right(config);
  }

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>>
  updateUserPreference({
    required String workspaceId,
    required String projectId,
    required UpdateTaskListUserPreferencePayload payload,
  }) async {
    updateCallCount++;
    if (statusCodeOnUpdate case final statusCode?) {
      return Left(
        ApiError(
          type: ApiErrorType.conflict,
          message: 'Konflikt',
          statusCode: statusCode,
        ),
      );
    }
    return Right(
      TaskListUserPreferenceResponse(
        workspaceId: workspaceId,
        projectId: projectId,
        userId: 'user-1',
        visibleColumns: payload.visibleColumns,
        columnWidths: payload.columnWidths,
        version: payload.expectedVersion + 1,
      ),
    );
  }

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>> getUserPreference({
    required String workspaceId,
    required String projectId,
  }) async => const Right(
    TaskListUserPreferenceResponse(
      workspaceId: 'ws-1',
      projectId: 'proj-1',
      userId: 'user-1',
      visibleColumns: ['sys:title'],
      columnWidths: {},
      version: 1,
    ),
  );

  @override
  Future<Either<ApiError, TaskListUserPreferenceResponse>> resetUserPreference({
    required String workspaceId,
    required String projectId,
  }) async => const Right(
    TaskListUserPreferenceResponse(
      workspaceId: 'ws-1',
      projectId: 'proj-1',
      userId: 'user-1',
      visibleColumns: [],
      columnWidths: {},
      version: 1,
    ),
  );

  @override
  Future<Either<ApiError, ProjectTaskListPolicyResponse>> getPolicy({
    required String workspaceId,
    required String projectId,
  }) async => const Left(ApiError(type: ApiErrorType.notFound, message: 'brak'));

  @override
  Future<Either<ApiError, ProjectTaskListPolicyResponse>> updatePolicy({
    required String workspaceId,
    required String projectId,
    required UpdateProjectTaskListPolicyPayload payload,
  }) async => const Left(ApiError(type: ApiErrorType.notFound, message: 'brak'));
}

void main() {
  late _StubTaskListConfigurationRepository repository;
  late TaskListPreferencesCubit cubit;

  setUp(() {
    repository = _StubTaskListConfigurationRepository();
    cubit = TaskListPreferencesCubit(
      repository: repository,
      workspaceId: 'ws-1',
      projectId: 'proj-1',
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  Widget buildHost() => MaterialApp(
    locale: const Locale('pl'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: BlocProvider<TaskListPreferencesCubit>.value(
        value: cubit,
        child: const TasksErrorBannerHost(boardActive: false),
      ),
    ),
  );

  testWidgets(
    'błąd zapisu ustawień Listy jest widoczny bez otwierania arkusza kolumn',
    (tester) async {
      await cubit.load();
      repository.statusCodeOnUpdate = 409;
      // Konflikt zapisu kończy się zaparkowaniem intencji i trwałym błędem.
      cubit.resizeColumn('sys:title', 320.0);
      await cubit.saveNow();

      await tester.pumpWidget(buildHost());
      await tester.pump();

      expect(
        find.text(
          (await AppLocalizations.delegate.load(const Locale('pl')))
              .tasksListPreferencesConflict,
        ),
        findsOneWidget,
        reason:
            'komunikat o konflikcie ustawień musi być widoczny poza arkuszem kolumn',
      );
      expect(find.text('Ponów'), findsOneWidget);
      expect(find.text('Odśwież'), findsOneWidget);
    },
  );

  testWidgets('„Ponów” w bannerze ponawia zapis draftu użytkownika', (
    tester,
  ) async {
    await cubit.load();
    repository.statusCodeOnUpdate = 409;
    cubit.resizeColumn('sys:title', 320.0);
    await cubit.saveNow();

    await tester.pumpWidget(buildHost());
    await tester.pump();

    // Konflikt ustępuje: przycisk musi ponowić intencję użytkownika.
    repository.statusCodeOnUpdate = null;
    await tester.tap(find.text('Ponów'));
    await tester.pumpAndSettle();

    expect(find.text('Ponów'), findsNothing, reason: 'udany zapis czyści błąd');
    expect(cubit.state, isA<TaskListPreferencesReady>());
    expect(
      (cubit.state as TaskListPreferencesReady).columnWidths['sys:title'],
      320.0,
    );
  });

  testWidgets('błąd odczytu ustawień pokazuje się bez akcji ponowienia', (
    tester,
  ) async {
    // Stan błędu odczytu powstaje, gdy konfiguracja nie wróci z Backendu.
    repository.failRead = true;
    final failing = TaskListPreferencesCubit(
      repository: repository,
      workspaceId: 'ws-1',
      projectId: 'proj-1',
    );
    addTearDown(failing.close);
    await failing.load();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: BlocProvider<TaskListPreferencesCubit>.value(
            value: failing,
            child: const TasksErrorBannerHost(boardActive: false),
          ),
        ),
      ),
    );
    await tester.pump();

    final l10n = await AppLocalizations.delegate.load(const Locale('pl'));
    expect(find.text('Nie można wczytać konfiguracji'), findsOneWidget);
    expect(
      find.text(l10n.tasksViewErrorRefresh),
      findsOneWidget,
      reason: 'nieudany odczyt ponawia się odświeżeniem, nie „Ponów”',
    );
    expect(find.text(l10n.tasksViewErrorRetry), findsNothing);
  });

  testWidgets('banner pokazuje identyfikator korelacji z Backendu', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('pl'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: TasksErrorBanner(
            message: 'Konflikt',
            traceId: 'trace-42',
            onRetry: () {},
            onRefresh: () {},
            onDismiss: () {},
          ),
        ),
      ),
    );

    final l10n = await AppLocalizations.delegate.load(const Locale('pl'));
    expect(find.text(l10n.tasksViewErrorTraceId('trace-42')), findsOneWidget);
    expect(find.text(l10n.tasksViewErrorRetry), findsOneWidget);
    expect(find.text(l10n.tasksViewErrorRefresh), findsOneWidget);
  });
}
