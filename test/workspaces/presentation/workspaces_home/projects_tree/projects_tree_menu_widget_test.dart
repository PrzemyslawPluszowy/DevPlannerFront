import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/shared/presentation/widgets/app_expansible_navigation_item.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_member_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_user_preference_response.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_action_capabilities.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_list_query.dart';
import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_context_menu.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/workspace_project_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Atrapa katalogu projektów używana przez drzewo.
final class _FakeProjectsGateway implements ProjectsGateway {
  _FakeProjectsGateway(this.items);

  final List<ProjectListItem> items;

  @override
  Future<List<ProjectListItem>> listProjects(
    String workspaceId, {
    ProjectListState state = ProjectListState.active,
    ProjectListVisibility? visibility,
    bool? includeHidden,
  }) async => items;

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} nie jest stubowane');
}

/// Atrapa zasobów projektu – drzewo nie ładuje w teście żadnych instancji.
final class _FakeProjectResourcesRepository
    implements ProjectResourcesRepository {
  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listTasks({
    required String workspaceId,
    required String projectId,
  }) async => const Right(<ProjectResourceListItem>[]);

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listWhiteboards({
    required String workspaceId,
    required String projectId,
  }) async => const Right(<ProjectResourceListItem>[]);

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listWikiPages({
    required String workspaceId,
    required String projectId,
  }) async => const Right(<ProjectResourceListItem>[]);

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listProjectFolders({
    required String workspaceId,
    required String projectId,
  }) async => const Right(<ProjectResourceListItem>[]);

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listAutomations({
    required String workspaceId,
    required String projectId,
  }) async => const Right(<ProjectResourceListItem>[]);

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} nie jest stubowane');
}

/// Rejestrująca atrapa mutacji projektów.
///
/// Odpowiedzi lifecycle zwracają ten sam projekt co lista, żeby test sprawdzał
/// scalanie odpowiedzi serwera, a nie podmianę nazwy.
final class _FakeProjectsRepository implements ProjectsRepository {
  _FakeProjectsRepository(this.items);

  final List<ProjectListItem> items;

  final List<String> archiveCalls = <String>[];
  final List<String> restoreCalls = <String>[];
  final List<String> deleteCalls = <String>[];
  final List<bool> pinnedCalls = <bool>[];

  /// Wywołania odczytu sekcji zarejestrowane przez atrapę.
  final List<ProjectListVisibility?> listVisibilityCalls =
      <ProjectListVisibility?>[];

  Either<ApiError, ProjectUserPreferenceResponse>? preferenceResult;
  ApiError? archiveError;

  /// Odpowiedź zapisu kolejności; `null` zwraca listę zgodną z payloadem.
  Future<Either<ApiError, List<ProjectListItem>>> Function(
    List<String> projectIds,
    int call,
  )?
  onUpdateOrder;

  @override
  Future<Either<ApiError, List<ProjectListItem>>> listProjects(
    String workspaceId, {
    ProjectListState state = ProjectListState.active,
    ProjectListVisibility? visibility,
    bool? includeHidden,
  }) async {
    listVisibilityCalls.add(visibility);
    if (state == ProjectListState.archived) {
      return Right(<ProjectListItem>[
        for (final project in items)
          if (project.isArchived) project,
      ]);
    }
    if (visibility == ProjectListVisibility.hidden) {
      return Right(<ProjectListItem>[
        for (final project in items)
          if (project.isHidden) project,
      ]);
    }
    return const Right(<ProjectListItem>[]);
  }

  @override
  Future<Either<ApiError, List<ProjectListItem>>> updateProjectOrder({
    required String workspaceId,
    required List<String> projectIds,
  }) {
    final handler = onUpdateOrder;
    if (handler != null) return handler(projectIds, 0);
    return Future<Either<ApiError, List<ProjectListItem>>>.value(
      Right(<ProjectListItem>[for (final id in projectIds) _byId(id)]),
    );
  }

  @override
  Future<Either<ApiError, ProjectUserPreferenceResponse>>
  updateProjectPreference({
    required String workspaceId,
    required String projectId,
    required bool isHidden,
    required bool isPinned,
    int? expectedVersion,
  }) async {
    pinnedCalls.add(isPinned);
    final result = preferenceResult;
    if (result != null) return result;
    return Right(
      ProjectUserPreferenceResponse(
        projectId: projectId,
        isHidden: isHidden,
        isPinned: isPinned,
        sortPosition: 0,
        updatedAtUtc: DateTime.utc(2026, 9, 19),
      ),
    );
  }

  @override
  Future<Either<ApiError, ProjectListItem>> archiveProject({
    required String workspaceId,
    required String projectId,
    int? expectedVersion,
  }) async {
    archiveCalls.add(projectId);
    final error = archiveError;
    if (error != null) return Left(error);
    return Right(_byId(projectId));
  }

  @override
  Future<Either<ApiError, ProjectListItem>> restoreProject({
    required String workspaceId,
    required String projectId,
    int? expectedVersion,
  }) async {
    restoreCalls.add(projectId);
    return Right(_byId(projectId));
  }

  @override
  Future<Either<ApiError, void>> deleteProject({
    required String workspaceId,
    required String projectId,
  }) async {
    deleteCalls.add(projectId);
    return const Right(null);
  }

  /// Odpowiedź opuszczenia projektu; `null` zwraca sukces.
  Future<Either<ApiError, ProjectMemberResponse>> Function(String projectId)?
  onLeave;

  @override
  Future<Either<ApiError, ProjectMemberResponse>> leaveProject({
    required String workspaceId,
    required String projectId,
  }) async {
    final handler = onLeave;
    if (handler != null) return handler(projectId);
    return Right(_memberResponse(projectId));
  }

  ProjectMemberResponse _memberResponse(String projectId) =>
      ProjectMemberResponse(
        id: 'membership-$projectId',
        workspaceMembershipId: 'workspace-membership-1',
        userId: 'user-1',
        role: ProjectRole.member,
        createdAtUtc: DateTime.utc(2026, 9, 19),
      );

  /// Odpowiedź członkostwa dla atrapy wywołań w testach.
  ProjectMemberResponse memberResponseFor(String projectId) =>
      _memberResponse(projectId);

  ProjectListItem _byId(String projectId) =>
      items.firstWhere((project) => project.id == projectId);

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} nie jest stubowane');
}

/// Data archiwizacji używana przez fixture’y; trzymana w zmiennej, bo lint
/// traktuje `DateTime.utc(...)` wprost w argumencie jako wartość domyślną.
final DateTime _archivedAt = DateTime.utc(2026, 8, 4);

/// Możliwości pełnego zarządzania projektem, używane przez większość testów.
const ProjectActionCapabilities _manageCapabilities = ProjectActionCapabilities(
  canManage: true,
  canArchive: true,
  canDelete: true,
  canManageMembers: true,
  canCreateTemplate: true,
  canLeave: true,
);

ProjectListItem _item(
  String id, {
  bool isPinned = false,
  String? name,
  ProjectActionCapabilities? capabilities = _manageCapabilities,
  bool isHidden = false,
  DateTime? archivedAtUtc,
}) => ProjectListItem(
  id: id,
  workspaceId: 'ws-1',
  name: name ?? 'Projekt $id',
  capabilities: capabilities,
  isPinned: isPinned,
  isHidden: isHidden,
  archivedAtUtc: archivedAtUtc,
);

const String _workspaceId = 'ws-1';

Widget _harness({
  required WorkspaceProjectsCubit projectsCubit,
  ProjectsRepository? repository,
  required ValueChanged<String> onProjectTap,
}) {
  final router = GoRouter(
    initialLocation: '/workspaces/$_workspaceId/projects/p-1/tasks',
    routes: [
      GoRoute(
        path: '/workspaces/:workspaceId/projects/:projectId/tasks',
        builder: (context, state) => BlocProvider.value(
          value: projectsCubit,
          child: Scaffold(
            body: SizedBox(
              width: 320,
              child: WorkspaceProjectMenu(
                workspaceId: _workspaceId,
                onProjectTap: onProjectTap,
                resourcesRepository: _FakeProjectResourcesRepository(),
                projectsRepository: repository,
              ),
            ),
          ),
        ),
      ),
    ],
  );
  return MaterialApp.router(
    locale: const Locale('pl'),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: router,
  );
}

/// Pomocnik: otwiera menu kontekstowe wiersza projektu o podanej nazwie.
Future<void> _openMenu(WidgetTester tester, String projectName) async {
  final row = find
      .ancestor(
        of: find.text(projectName),
        matching: find.byType(AppExpansibleNavigationItem),
      )
      .first;
  final button = find.descendant(
    of: row,
    matching: find.byTooltip('Menu projektu'),
  );
  await tester.tap(button.first);
  await tester.pumpAndSettle();
}

void main() {
  late _FakeProjectsRepository repository;
  late WorkspaceProjectsCubit projectsCubit;
  late List<String> navigated;

  setUp(() {
    final items = <ProjectListItem>[
      _item('p-1', name: 'Alfa', isPinned: true),
      _item('p-2', name: 'Beta'),
      _item('p-3', name: 'Gamma'),
    ];
    repository = _FakeProjectsRepository(items);
    navigated = <String>[];
    projectsCubit = WorkspaceProjectsCubit(
      gateway: _FakeProjectsGateway(items),
      workspaceId: _workspaceId,
    );
  });

  tearDown(() async {
    await projectsCubit.close();
  });

  Future<void> pumpMenu(WidgetTester tester) async {
    await tester.pumpWidget(
      _harness(
        projectsCubit: projectsCubit,
        repository: repository,
        onProjectTap: navigated.add,
      ),
    );
    await projectsCubit.load();
    await tester.pumpAndSettle();
  }

  testWidgets(
    'menu projektu pokazuje pozycje z planu i jawnie wyłączone akcje',
    (
      tester,
    ) async {
      await pumpMenu(tester);

      await _openMenu(tester, 'Beta');

      expect(find.text('Otwórz'), findsOneWidget);
      expect(find.text('Przypnij'), findsOneWidget);
      expect(find.text('Ukryj dla mnie'), findsOneWidget);
      expect(find.text('Zmień nazwę i wygląd'), findsOneWidget);
      expect(find.text('Ustawienia'), findsOneWidget);
      expect(find.text('Utwórz szablon z projektu'), findsOneWidget);
      expect(find.text('Archiwizuj'), findsOneWidget);
      // Kontrakty, których nie ma, są obecne wyłącznie jako jawnie wyłączone.
      expect(find.text('Przenieś do workspace'), findsOneWidget);
      expect(
        find.textContaining('Kontrakt przenoszenia projektu'),
        findsOneWidget,
      );
      expect(find.text('Opuść projekt'), findsOneWidget);
      // Capabilities z serwera pozwalają opuścić projekt, więc pozycja jest
      // aktywna i nie ma powodu wyłączenia.
      final leave = tester.widget<PopupMenuItem<ProjectContextAction>>(
        find.ancestor(
          of: find.text('Opuść projekt'),
          matching: find.byType(PopupMenuItem<ProjectContextAction>),
        ),
      );
      expect(leave.enabled, isTrue);
      // Usuwanie trwałe jest dostępne wyłącznie z widoku archiwum.
      expect(find.text('Usuń trwale'), findsNothing);
    },
  );

  testWidgets(
    'projekt bez capabilities wyłącza akcje zarządcze z jawnym powodem',
    (
      tester,
    ) async {
      await projectsCubit.close();
      projectsCubit = WorkspaceProjectsCubit(
        gateway: _FakeProjectsGateway(<ProjectListItem>[
          // Ten sam projekt bez odpowiedzi backendu o uprawnieniach.
          _item('p-1', name: 'Alfa', capabilities: null),
        ]),
        workspaceId: _workspaceId,
      );
      await pumpMenu(tester);

      await _openMenu(tester, 'Alfa');

      // Brak capabilities nie jest zgadywany z roli: akcje zarządcze są
      // wyłączone, a powód mówi o brakującej odpowiedzi backendu.
      expect(
        find.textContaining('Backend nie zwrócił uprawnień'),
        findsNWidgets(3),
      );
      expect(
        find.textContaining('Wymaga roli właściciela'),
        findsNothing,
      );
      // Trwałe usunięcie jest dostępne wyłącznie z sekcji Archiwum.
      expect(find.text('Usuń trwale'), findsNothing);
    },
  );

  testWidgets('menu liczy dostępność z capabilities serwera, nie z roli', (
    tester,
  ) async {
    await projectsCubit.close();
    projectsCubit = WorkspaceProjectsCubit(
      gateway: _FakeProjectsGateway(<ProjectListItem>[
        // Backend odmawia zarządzania, choć rola wyglądałaby na zarządczą.
        _item(
          'p-1',
          name: 'Alfa',
          capabilities: const ProjectActionCapabilities(canLeave: true),
        ),
      ]),
      workspaceId: _workspaceId,
    );
    await pumpMenu(tester);

    await _openMenu(tester, 'Alfa');

    // Trzy pozycje zarządcze: zmiana nazwy, szablon i archiwizacja. Szablon
    // zgłasza brak portu szablonów, bo drzewo w tym teście go nie dostaje.
    expect(
      find.textContaining('Wymaga roli właściciela lub administratora'),
      findsNWidgets(2),
    );
    expect(
      find.textContaining('Repozytorium szablonów projektów'),
      findsOneWidget,
    );
    // `canLeave` z serwera odblokowuje opuszczenie projektu, mimo że pozostałe
    // możliwości są wyłączone.
    final leave = tester.widget<PopupMenuItem<ProjectContextAction>>(
      find.ancestor(
        of: find.text('Opuść projekt'),
        matching: find.byType(PopupMenuItem<ProjectContextAction>),
      ),
    );
    expect(leave.enabled, isTrue);
  });

  testWidgets('opuszczenie projektu wymaga potwierdzenia i odświeża listę', (
    tester,
  ) async {
    final leaveCalls = <String>[];
    repository.onLeave = (projectId) async {
      leaveCalls.add(projectId);
      return Right(repository.memberResponseFor(projectId));
    };
    await pumpMenu(tester);

    await _openMenu(tester, 'Beta');
    await tester.tap(find.text('Opuść projekt'));
    await tester.pumpAndSettle();

    expect(find.text('Opuścić projekt?'), findsOneWidget);
    await tester.tap(find.text('Opuść projekt').last);
    await tester.pumpAndSettle();

    expect(leaveCalls, <String>['p-2']);
    expect(find.textContaining('Opuściłeś projekt Beta'), findsOneWidget);
  });

  testWidgets('nieudane opuszczenie projektu zostaje trwałym błędem', (
    tester,
  ) async {
    repository.onLeave = (projectId) async =>
        const Left<ApiError, ProjectMemberResponse>(
          ApiError(
            type: ApiErrorType.badResponse,
            message: 'Nie można opuścić projektu.',
            statusCode: 409,
            apiCode: 'project.last_owner',
            traceId: 'trace-leave',
          ),
        );
    await pumpMenu(tester);

    await _openMenu(tester, 'Beta');
    await tester.tap(find.text('Opuść projekt'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Opuść projekt').last);
    await tester.pumpAndSettle();

    expect(find.text('Operacja na projekcie nie powiodła się'), findsOneWidget);
    expect(find.textContaining('Opuszczenie projektu'), findsOneWidget);
    expect(find.textContaining('project.last_owner'), findsOneWidget);
    // Projekt pozostaje w drzewie: porażka nie udaje sukcesu.
    expect(find.text('Beta'), findsOneWidget);
  });

  testWidgets(
    'archiwizacja wymaga potwierdzenia i przenosi projekt do sekcji Archiwum',
    (
      tester,
    ) async {
      await pumpMenu(tester);

      await _openMenu(tester, 'Beta');
      await tester.tap(find.text('Archiwizuj'));
      await tester.pumpAndSettle();

      expect(find.text('Zarchiwizować projekt?'), findsOneWidget);
      expect(
        find.textContaining('zniknie z drzewa projektów'),
        findsOneWidget,
      );

      await tester.tap(find.text('Archiwizuj projekt'));
      await tester.pumpAndSettle();

      expect(repository.archiveCalls, <String>['p-2']);
      // Wiersz zniknął z listy drzewa i pojawił się w sekcji Archiwum.
      expect(find.byKey(const ValueKey<String>('p-2')), findsNothing);
      expect(find.text('Archiwum'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);

      // Przywrócenie jest dostępne z sekcji Archiwum (sekcja otwiera się sama).
      await _openMenu(tester, 'Beta');
      expect(find.text('Przywróć do drzewa'), findsOneWidget);
      expect(find.text('Usuń trwale'), findsOneWidget);
    },
  );

  testWidgets('sekcja Archiwum po restarcie pokazuje projekt z serwera', (
    tester,
  ) async {
    final items = <ProjectListItem>[
      _item('p-1', name: 'Alfa'),
      _item('p-9', name: 'Zarchiwizowany', archivedAtUtc: _archivedAt),
    ];
    await projectsCubit.close();
    projectsCubit = WorkspaceProjectsCubit(
      gateway: _FakeProjectsGateway(items),
      workspaceId: _workspaceId,
    );
    repository = _FakeProjectsRepository(items);

    await pumpMenu(tester);

    // Klient dopiero co wystartował: archiwum pochodzi z serwera, a nie
    // z operacji archiwizacji wykonanej w tej sesji.
    expect(find.text('Archiwum'), findsOneWidget);
    expect(find.text('Zarchiwizowany'), findsOneWidget);
    expect(find.text('Alfa'), findsOneWidget);
    expect(
      repository.listVisibilityCalls,
      contains(ProjectListVisibility.hidden),
    );
  });

  testWidgets('trwałe usunięcie wymaga wpisania nazwy projektu', (
    tester,
  ) async {
    await pumpMenu(tester);
    await _openMenu(tester, 'Beta');
    await tester.tap(find.text('Archiwizuj'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archiwizuj projekt'));
    await tester.pumpAndSettle();

    await _openMenu(tester, 'Beta');
    await tester.tap(find.text('Usuń trwale'));
    await tester.pumpAndSettle();

    expect(find.text('Trwale usunąć projekt?'), findsOneWidget);
    final confirmButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Usuń trwale'),
    );
    expect(confirmButton.onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'Beta');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Usuń trwale').last);
    await tester.pumpAndSettle();

    expect(repository.deleteCalls, <String>['p-2']);
    expect(find.text('Beta'), findsNothing);
  });

  testWidgets('ukrycie chowa wiersz i pokazuje potwierdzenie z cofnięciem', (
    tester,
  ) async {
    await pumpMenu(tester);

    await _openMenu(tester, 'Beta');
    await tester.tap(find.text('Ukryj dla mnie'));
    await tester.pumpAndSettle();

    // Wiersz zniknął z listy drzewa i pojawił się w sekcji Ukryte.
    expect(find.byKey(const ValueKey<String>('p-2')), findsNothing);
    expect(find.text('Ukryte'), findsOneWidget);
    expect(find.textContaining('ukryty w drzewie'), findsOneWidget);

    await tester.tap(find.text('Cofnij'));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey<String>('p-2')), findsOneWidget);
    expect(find.text('Ukryte'), findsNothing);
  });

  testWidgets('nieudane przypięcie cofa stan i zostawia trwały błąd', (
    tester,
  ) async {
    repository.preferenceResult = const Left(
      ApiError(
        type: ApiErrorType.badResponse,
        message: 'Brak uprawnień do projektu.',
        statusCode: 403,
        apiCode: 'project_forbidden',
        traceId: 'trace-widget',
      ),
    );
    await pumpMenu(tester);

    await _openMenu(tester, 'Gamma');
    await tester.tap(find.text('Przypnij'));
    await tester.pumpAndSettle();

    // Błąd jest trwały i widoczny, a wiersz wrócił na poprzednią pozycję.
    expect(find.text('Operacja na projekcie nie powiodła się'), findsOneWidget);
    expect(
      find.textContaining('Operacja została cofnięta'),
      findsOneWidget,
    );
    expect(find.textContaining('Brak uprawnień do wykonania'), findsOneWidget);
    expect(find.textContaining('project_forbidden'), findsOneWidget);
    expect(find.textContaining('trace-widget'), findsOneWidget);
    expect(find.text('Ponów'), findsOneWidget);

    final order = tester
        .widgetList<ReorderableDragStartListener>(
          find.byType(ReorderableDragStartListener),
        )
        .map((handle) => handle.index)
        .toList();
    expect(order, <int>[0, 1, 2]);
    final labels = tester
        .widgetList<AppExpansibleNavigationItem>(
          find.byType(AppExpansibleNavigationItem),
        )
        .map((item) => item.label)
        .toList();
    expect(
      labels.indexOf('Alfa') < labels.indexOf('Beta'),
      isTrue,
      reason: 'kolejność po rollbacku: Alfa (przypięta) przed Beta',
    );
    expect(labels.indexOf('Beta') < labels.indexOf('Gamma'), isTrue);
  });

  testWidgets('archiwizacja z błędem wraca na tę samą pozycję', (tester) async {
    repository.archiveError = const ApiError(
      type: ApiErrorType.badResponse,
      message: 'Konflikt wersji projektu.',
      statusCode: 409,
      traceId: 'trace-409',
    );
    await pumpMenu(tester);

    await _openMenu(tester, 'Beta');
    await tester.tap(find.text('Archiwizuj'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Archiwizuj projekt'));
    await tester.pumpAndSettle();

    expect(find.text('Beta'), findsOneWidget);
    expect(find.text('Archiwum'), findsNothing);
    expect(find.textContaining('trace-409'), findsOneWidget);
    expect(find.textContaining('Stan projektu zmienił się'), findsOneWidget);
  });

  testWidgets('DnD wysyła pełną kolejność widocznych projektów', (
    tester,
  ) async {
    final orderCalls = <List<String>>[];
    repository.onUpdateOrder = (ids, _) async {
      orderCalls.add(ids);
      return Right(<ProjectListItem>[
        for (final id in ids) _item(id, name: id),
      ]);
    };
    await pumpMenu(tester);

    // Przeciągamy drugi wiersz (Beta) poniżej Gamma.
    final handle = find.byTooltip('Zmień kolejność projektu').at(1);
    await tester.drag(handle, const Offset(0, 80));
    await tester.pumpAndSettle();

    expect(orderCalls, hasLength(1));
    expect(orderCalls.single, <String>['p-1', 'p-3', 'p-2']);
  });

  testWidgets('bez portu mutacji akcje zapisu są jawnie wyłączone z powodem', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        projectsCubit: projectsCubit,
        onProjectTap: navigated.add,
      ),
    );
    await projectsCubit.load();
    await tester.pumpAndSettle();

    await _openMenu(tester, 'Beta');

    expect(
      find.textContaining('Brak portu projektów w tej kompozycji'),
      findsWidgets,
    );
  });
}
