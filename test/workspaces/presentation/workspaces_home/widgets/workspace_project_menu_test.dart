import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/shared/presentation/widgets/app_shimmer.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_list_query.dart';
import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_menu_groups.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/workspace_project_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProjectsGateway implements ProjectsGateway {
  _FakeProjectsGateway(this.result);

  List<ProjectListItem> result;
  ProjectsGatewayException? error;
  int calls = 0;
  String? requestedWorkspaceId;

  @override
  Future<List<ProjectListItem>> listProjects(
    String workspaceId, {
    ProjectListState state = ProjectListState.active,
    ProjectListVisibility? visibility,
    bool? includeHidden,
  }) async {
    calls++;
    requestedWorkspaceId = workspaceId;
    final failure = error;
    if (failure != null) throw failure;
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeProjectResourcesRepository implements ProjectResourcesRepository {
  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listTasks({
    required String workspaceId,
    required String projectId,
  }) async => const Right([]);

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listWhiteboards({
    required String workspaceId,
    required String projectId,
  }) async => const Right([]);

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listWikiPages({
    required String workspaceId,
    required String projectId,
  }) async => const Right([]);

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listProjectFolders({
    required String workspaceId,
    required String projectId,
  }) async => const Right([]);

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listAutomations({
    required String workspaceId,
    required String projectId,
  }) async => const Right([]);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _harness({
  required WorkspaceProjectsCubit cubit,
  ProjectMenuActionCallback? onAction,
}) => MaterialApp(
  locale: const Locale('pl'),
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: AppLocalizations.supportedLocales,
  home: BlocProvider.value(
    value: cubit,
    child: SizedBox(
      width: 280,
      child: WorkspaceProjectMenu(
        workspaceId: 'workspace-1',
        onProjectTap: _ignoreProjectTap,
        onAction: onAction,
        resourcesRepository: _FakeProjectResourcesRepository(),
      ),
    ),
  ),
);

void _ignoreProjectTap(String path) {}

void main() {
  testWidgets('menu pokazuje ładowanie, a potem pusty katalog projektów', (
    tester,
  ) async {
    final repository = _FakeProjectsGateway(const []);
    final cubit = WorkspaceProjectsCubit(
      gateway: repository,
      workspaceId: 'workspace-1',
    );
    addTearDown(cubit.close);

    await tester.pumpWidget(_harness(cubit: cubit));
    expect(find.byType(AppShimmerMenuItem), findsNWidgets(2));

    await cubit.load();
    await tester.pump();

    expect(find.text('Utwórz pierwszy projekt'), findsOneWidget);
    expect(repository.calls, 1);
    expect(repository.requestedWorkspaceId, 'workspace-1');
  });

  testWidgets('menu pokazuje komunikat backendu przy błędzie lazy-loadingu', (
    tester,
  ) async {
    final repository = _FakeProjectsGateway(const [])
      ..error = const ProjectsGatewayException(
        reason: ProjectsFailureReason.requestFailed,
        statusCode: 503,
        message: 'Nie udało się pobrać projektów.',
      );
    final cubit = WorkspaceProjectsCubit(
      gateway: repository,
      workspaceId: 'workspace-1',
    );
    addTearDown(cubit.close);

    await tester.pumpWidget(_harness(cubit: cubit));
    await cubit.load();
    await tester.pump();

    expect(
      find.textContaining('Nie udało się pobrać projektów.'),
      findsOneWidget,
    );
    expect(find.textContaining('(kod: 503)'), findsOneWidget);
    expect(repository.calls, 1);

    repository.error = null;
    repository.result = const [];
    await tester.tap(find.byTooltip('Spróbuj ponownie'));
    await tester.pump();
    expect(find.text('Utwórz pierwszy projekt'), findsOneWidget);
    expect(repository.calls, 2);
  });

  testWidgets('pusty stan projektu emituje intencję utworzenia projektu', (
    tester,
  ) async {
    final repository = _FakeProjectsGateway(const []);
    ProjectMenuAction? action;
    String? projectId;
    final cubit = WorkspaceProjectsCubit(
      gateway: repository,
      workspaceId: 'workspace-1',
    );
    addTearDown(cubit.close);

    await tester.pumpWidget(
      _harness(
        cubit: cubit,
        onAction: (value, selectedProjectId, [onCreated]) {
          action = value;
          projectId = selectedProjectId;
        },
      ),
    );
    await cubit.load();
    await tester.pump();
    await tester.tap(find.text('Utwórz pierwszy projekt'));

    expect(action, ProjectMenuAction.createProject);
    expect(projectId, isNull);
  });
}
