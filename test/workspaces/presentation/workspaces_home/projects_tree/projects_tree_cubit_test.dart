import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_member_response.dart';
import 'package:devplanner/workspaces/data/projects/responses/project_user_preference_response.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_role.dart';
import 'package:devplanner/workspaces/domain/models/project_action_capabilities.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_list_query.dart';
import 'package:devplanner/workspaces/domain/repositories/project_templates_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/cubit/projects_tree_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wywołanie `updateProjectPreference` zarejestrowane przez atrapę.
final class _PreferenceCall {
  const _PreferenceCall({
    required this.isPinned,
    required this.isHidden,
    this.expectedVersion,
  });

  final bool isPinned;
  final bool isHidden;
  final int? expectedVersion;
}

/// Wywołanie `listProjects` zarejestrowane przez atrapę.
final class _ListCall {
  const _ListCall({required this.state, required this.visibility});

  final ProjectListState state;
  final ProjectListVisibility? visibility;
}

/// Rejestrująca atrapa repozytorium projektów.
///
/// Testy sterują kolejnością odpowiedzi, więc każde wywołanie mutacji trafia do
/// listy, a wynik jest wyliczany przez wstrzykniętą funkcję.
final class _FakeProjectsRepository implements ProjectsRepository {
  final List<_PreferenceCall> preferenceCalls = <_PreferenceCall>[];
  final List<_ListCall> listCalls = <_ListCall>[];
  final List<List<String>> orderCalls = <List<String>>[];
  final List<String> archiveCalls = <String>[];
  final List<int?> archiveVersions = <int?>[];
  final List<String> restoreCalls = <String>[];
  final List<int?> restoreVersions = <int?>[];
  final List<String> deleteCalls = <String>[];
  final List<String> leaveCalls = <String>[];

  /// Projekty zwracane dla sekcji `Ukryte` (filtr `visibility: hidden`).
  List<ProjectListItem> hiddenFromServer = const <ProjectListItem>[];

  /// Projekty zwracane dla sekcji `Archiwum` (filtr `state: archived`).
  List<ProjectListItem> archivedFromServer = const <ProjectListItem>[];

  /// Nadpisuje odpowiedź listy; `null` używa list sekcji.
  Either<ApiError, List<ProjectListItem>>? listResult;

  /// Kolejka odpowiedzi preferencji; ostatnia obowiązuje dla kolejnych wywołań.
  final List<Future<Either<ApiError, ProjectUserPreferenceResponse>>>
  preferenceResponses =
      <Future<Either<ApiError, ProjectUserPreferenceResponse>>>[];

  Future<Either<ApiError, List<ProjectListItem>>> Function(
    List<String> projectIds,
    int call,
  )?
  onUpdateOrder;

  Future<Either<ApiError, ProjectListItem>> Function(
    String projectId,
    int call,
  )?
  onArchive;

  Future<Either<ApiError, ProjectListItem>> Function(
    String projectId,
    int call,
  )?
  onRestore;

  Future<Either<ApiError, void>> Function(String projectId, int call)? onDelete;

  Future<Either<ApiError, ProjectMemberResponse>> Function(String projectId)?
  onLeave;

  int _preferenceIndex = 0;
  int _orderIndex = 0;
  int _archiveIndex = 0;
  int _restoreIndex = 0;
  int _deleteIndex = 0;

  /// Wersje preferencji zwracane w odpowiedziach (kolejne zapisy).
  final List<int?> preferenceVersions = <int?>[];

  @override
  Future<Either<ApiError, List<ProjectListItem>>> listProjects(
    String workspaceId, {
    ProjectListState state = ProjectListState.active,
    ProjectListVisibility? visibility,
    bool? includeHidden,
  }) async {
    listCalls.add(_ListCall(state: state, visibility: visibility));
    if (listResult case final result?) return result;
    if (state == ProjectListState.archived) return Right(archivedFromServer);
    if (visibility == ProjectListVisibility.hidden) {
      return Right(hiddenFromServer);
    }
    return const Right(<ProjectListItem>[]);
  }

  /// Dodaje odpowiedź preferencji dla kolejnego wywołania.
  void enqueuePreference(
    Either<ApiError, ProjectUserPreferenceResponse> value,
  ) {
    preferenceResponses.add(
      Future<Either<ApiError, ProjectUserPreferenceResponse>>.value(value),
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
  }) {
    preferenceCalls.add(
      _PreferenceCall(
        isPinned: isPinned,
        isHidden: isHidden,
        expectedVersion: expectedVersion,
      ),
    );
    final index = _preferenceIndex;
    _preferenceIndex++;
    if (preferenceResponses.isEmpty) {
      return Future<Either<ApiError, ProjectUserPreferenceResponse>>.value(
        Right(
          _preferenceResponse(
            projectId,
            isPinned: isPinned,
            isHidden: isHidden,
            version: index < preferenceVersions.length
                ? preferenceVersions[index]
                : null,
          ),
        ),
      );
    }
    final response =
        preferenceResponses[index < preferenceResponses.length
            ? index
            : preferenceResponses.length - 1];
    return response;
  }

  @override
  Future<Either<ApiError, List<ProjectListItem>>> updateProjectOrder({
    required String workspaceId,
    required List<String> projectIds,
  }) {
    orderCalls.add(List<String>.unmodifiable(projectIds));
    final handler = onUpdateOrder;
    if (handler == null) {
      // Backend zwraca pełną listę widocznych projektów w nowej kolejności.
      return Future<Either<ApiError, List<ProjectListItem>>>.value(
        Right(<ProjectListItem>[
          for (final id in projectIds) _projectItem(id, isPinned: false),
        ]),
      );
    }
    final index = _orderIndex;
    _orderIndex++;
    return handler(projectIds, index);
  }

  @override
  Future<Either<ApiError, ProjectListItem>> archiveProject({
    required String workspaceId,
    required String projectId,
    int? expectedVersion,
  }) {
    archiveCalls.add(projectId);
    archiveVersions.add(expectedVersion);
    final handler = onArchive;
    if (handler == null) {
      return Future<Either<ApiError, ProjectListItem>>.value(
        Right(_projectItem(projectId, isPinned: false)),
      );
    }
    final index = _archiveIndex;
    _archiveIndex++;
    return handler(projectId, index);
  }

  @override
  Future<Either<ApiError, ProjectListItem>> restoreProject({
    required String workspaceId,
    required String projectId,
    int? expectedVersion,
  }) {
    restoreCalls.add(projectId);
    restoreVersions.add(expectedVersion);
    final handler = onRestore;
    if (handler == null) {
      return Future<Either<ApiError, ProjectListItem>>.value(
        Right(_projectItem(projectId, isPinned: false)),
      );
    }
    final index = _restoreIndex;
    _restoreIndex++;
    return handler(projectId, index);
  }

  @override
  Future<Either<ApiError, void>> deleteProject({
    required String workspaceId,
    required String projectId,
  }) {
    deleteCalls.add(projectId);
    final handler = onDelete;
    if (handler == null) {
      return Future<Either<ApiError, void>>.value(const Right(null));
    }
    final index = _deleteIndex;
    _deleteIndex++;
    return handler(projectId, index);
  }

  @override
  Future<Either<ApiError, ProjectMemberResponse>> leaveProject({
    required String workspaceId,
    required String projectId,
  }) {
    leaveCalls.add(projectId);
    final handler = onLeave;
    if (handler != null) return handler(projectId);
    return Future<Either<ApiError, ProjectMemberResponse>>.value(
      Right(
        ProjectMemberResponse(
          id: 'membership-$projectId',
          workspaceMembershipId: 'workspace-membership-1',
          userId: 'user-1',
          role: ProjectRole.member,
          createdAtUtc: DateTime.utc(2026, 9, 19),
        ),
      ),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} nie jest stubowane');

  ProjectUserPreferenceResponse _preferenceResponse(
    String projectId, {
    required bool isPinned,
    required bool isHidden,
    int? version,
  }) => ProjectUserPreferenceResponse(
    projectId: projectId,
    isHidden: isHidden,
    isPinned: isPinned,
    sortPosition: 0,
    updatedAtUtc: DateTime.utc(2026, 9, 19),
    version: version,
  );

  ProjectListItem _projectItem(String projectId, {required bool isPinned}) =>
      ProjectListItem(
        id: projectId,
        workspaceId: 'workspace-1',
        name: projectId,
        isPinned: isPinned,
      );
}

/// Rejestrująca atrapa repozytorium szablonów projektów.
final class _FakeProjectTemplatesRepository
    implements ProjectTemplatesRepository {
  _FakeProjectTemplatesRepository({
    Either<ApiError, ProjectTemplateResponse>? result,
  }) : result = result ?? Right(_template);

  static final ProjectTemplateResponse _template = ProjectTemplateResponse(
    id: 'template-1',
    name: 'Szablon',
    updatedAtUtc: DateTime.utc(2026, 9, 19),
    version: 1,
  );

  final Either<ApiError, ProjectTemplateResponse> result;
  final List<String> calls = <String>[];

  @override
  Future<Either<ApiError, ProjectTemplateResponse>> createTemplateFromProject({
    required String workspaceId,
    required String projectId,
    required String name,
  }) async {
    calls.add('$workspaceId/$projectId/$name');
    return result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} nie jest stubowane');
}

/// Data archiwizacji używana przez fixture’y; trzymana w zmiennej, bo lint
/// traktuje `DateTime.utc(...)` wprost w argumencie jako wartość domyślną.
final DateTime _archivedAt = DateTime.utc(2026, 8, 4);

/// Projekt zarchiwizowany: znacznik archiwum i wersja tworzą spójny fixture.
ProjectListItem _archivedProject(String id, {int? version}) =>
    _project(id, archivedAtUtc: _archivedAt, version: version);

ProjectListItem _project(
  String id, {
  bool isPinned = false,
  String? name,
  bool isHidden = false,
  DateTime? archivedAtUtc,
  int? version,
  ProjectActionCapabilities? capabilities,
}) => ProjectListItem(
  id: id,
  workspaceId: 'workspace-1',
  name: name ?? 'Projekt $id',
  isPinned: isPinned,
  isHidden: isHidden,
  archivedAtUtc: archivedAtUtc,
  version: version,
  capabilities: capabilities,
);

ApiError _apiError({
  required int statusCode,
  String? apiCode,
  String? traceId,
  String message = 'Operacja odrzucona przez serwer.',
}) => ApiError(
  type: ApiErrorType.badResponse,
  message: message,
  statusCode: statusCode,
  apiCode: apiCode,
  traceId: traceId,
);

void main() {
  late _FakeProjectsRepository repository;
  late ProjectsTreeCubit cubit;

  setUp(() {
    repository = _FakeProjectsRepository();
    cubit = ProjectsTreeCubit(
      workspaceId: 'workspace-1',
      mutations: repository,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  List<String> visibleIds(ProjectsTreeCubit target) =>
      target.state.visible.map((project) => project.id).toList(growable: false);

  group('synchronizacja listy', () {
    test(
      'układa przypięte projekty na górze i zachowuje kolejność serwera',
      () {
        cubit.syncFromServer(<ProjectListItem>[
          _project('a'),
          _project('b', isPinned: true),
          _project('c'),
        ]);

        expect(visibleIds(cubit), <String>['b', 'a', 'c']);
      },
    );

    test('świeża lista serwera zdejmuje lokalne znaczniki ukrycia', () async {
      cubit.syncFromServer(<ProjectListItem>[_project('a'), _project('b')]);
      cubit.setHidden(_project('a'), isHidden: true);
      expect(cubit.state.hidden.map((project) => project.id), <String>['a']);
      await pumpEventQueue();

      // Backend nie zwraca ukrytych projektów; ich ponowne pojawienie się jest
      // dowodem, że nie są już ukryte.
      cubit.syncFromServer(<ProjectListItem>[_project('a'), _project('b')]);

      expect(cubit.state.hidden, isEmpty);
      expect(visibleIds(cubit), <String>['a', 'b']);
    });

    test('świeża lista nie zdejmuje ukrycia z żądaniem w locie', () async {
      final completer =
          Completer<Either<ApiError, ProjectUserPreferenceResponse>>();
      repository.preferenceResponses.add(completer.future);
      cubit.syncFromServer(<ProjectListItem>[_project('a'), _project('b')]);
      cubit.setHidden(_project('a'), isHidden: true);
      expect(cubit.state.hidden.map((project) => project.id), <String>['a']);

      // Serwer nie potwierdził jeszcze ukrycia, więc lista widocznych nadal
      // zawiera projekt A — intencja w locie ma pierwszeństwo nad listą.
      cubit.syncFromServer(<ProjectListItem>[_project('a'), _project('b')]);

      expect(cubit.state.hidden.map((project) => project.id), <String>['a']);
      expect(visibleIds(cubit), <String>['b']);

      completer.complete(
        Right(
          ProjectUserPreferenceResponse(
            projectId: 'a',
            isHidden: true,
            isPinned: false,
            updatedAtUtc: DateTime.utc(2026, 9, 19),
          ),
        ),
      );
      await pumpEventQueue();

      expect(cubit.state.hidden.map((project) => project.id), <String>['a']);
      expect(cubit.state.failure, isNull);
    });

    test(
      'lista aktywnych nie zdejmuje znacznika archiwum z projektu spoza niej',
      () async {
        // Projekt zarchiwizowany pochodzi z serwera i nie należy do listy
        // aktywnych, więc jej odświeżenie nie może go „przywrócić”.
        repository.archivedFromServer = <ProjectListItem>[
          _archivedProject('archived'),
        ];
        await cubit.refreshServerSections();

        expect(cubit.state.archived.map((project) => project.id), <String>[
          'archived',
        ]);

        cubit.syncFromServer(<ProjectListItem>[_project('active')]);

        expect(cubit.state.archived.map((project) => project.id), <String>[
          'archived',
        ]);
        expect(visibleIds(cubit), <String>['active']);
      },
    );
  });

  group('sekcje Ukryte i Archiwum z serwera', () {
    test('odtwarza archiwum po restarcie klienta', () async {
      // Pierwsza „sesja” archiwizuje projekt tylko po stronie serwera.
      repository.archivedFromServer = <ProjectListItem>[
        _archivedProject('archived'),
      ];

      // Restart klienta: nowy cubit i świeży odczyt z serwera.
      final restarted = ProjectsTreeCubit(
        workspaceId: 'workspace-1',
        mutations: repository,
      );
      restarted.syncFromServer(<ProjectListItem>[_project('active')]);
      expect(restarted.state.archived, isEmpty);

      await restarted.refreshServerSections();

      expect(restarted.state.archived.map((project) => project.id), <String>[
        'archived',
      ]);
      expect(visibleIds(restarted), <String>['active']);
      await restarted.close();
    });

    test('pobiera ukryte i archiwalne dokładnie tymi filtrami', () async {
      await cubit.refreshServerSections();

      expect(
        repository.listCalls.map((call) => (call.state, call.visibility)),
        <(ProjectListState, ProjectListVisibility?)>[
          (ProjectListState.active, ProjectListVisibility.hidden),
          (ProjectListState.archived, ProjectListVisibility.all),
        ],
      );
    });

    test(
      'projekt archiwalny znika z drzewa, gdy serwer go przywrócił',
      () async {
        repository.archivedFromServer = <ProjectListItem>[
          _archivedProject('x'),
        ];
        await cubit.refreshServerSections();
        expect(cubit.state.archived.map((project) => project.id), <String>[
          'x',
        ]);

        repository.archivedFromServer = const <ProjectListItem>[];
        cubit.syncFromServer(<ProjectListItem>[_project('x')]);
        await cubit.refreshServerSections();

        expect(cubit.state.archived, isEmpty);
        expect(visibleIds(cubit), <String>['x']);
      },
    );

    test('projekt ukryty w serwerze trafia do sekcji Ukryte', () async {
      repository.hiddenFromServer = <ProjectListItem>[
        _project('hidden', isHidden: true),
      ];

      await cubit.refreshServerSections();

      expect(cubit.state.hidden.map((project) => project.id), <String>[
        'hidden',
      ]);
      expect(visibleIds(cubit), isEmpty);
    });

    test('odczyt sekcji nie nadpisuje intencji ukrycia w locie', () async {
      final completer =
          Completer<Either<ApiError, ProjectUserPreferenceResponse>>();
      repository.preferenceResponses.add(completer.future);
      repository.hiddenFromServer = <ProjectListItem>[
        // Serwer jeszcze nie potwierdził ukrycia, ale jego lista już je widzi.
        _project('a', isHidden: true),
      ];
      cubit.syncFromServer(<ProjectListItem>[_project('a')]);
      cubit.setPinned(_project('a'), isPinned: true);
      expect(cubit.state.pendingProjectIds, contains('a'));

      await cubit.refreshServerSections();

      // Znacznik ukrycia z serwera nie może wyprzedzić intencji przypięcia,
      // która jest jeszcze w locie.
      final project = cubit.state.visible.single;
      expect(project.id, 'a');
      expect(project.isPinned, isTrue);

      completer.complete(
        Right(
          ProjectUserPreferenceResponse(
            projectId: 'a',
            isHidden: false,
            isPinned: true,
            updatedAtUtc: DateTime.utc(2026, 9, 19),
          ),
        ),
      );
      await pumpEventQueue();

      expect(cubit.state.visible.single.isPinned, isTrue);
      expect(cubit.state.failure, isNull);
    });

    test(
      'porażka odczytu sekcji zostaje trwałym błędem z ponowieniem',
      () async {
        repository.listResult = Left(
          _apiError(statusCode: 403, apiCode: 'workspace.forbidden'),
        );

        await cubit.refreshServerSections();

        expect(
          cubit.state.failure?.operation,
          ProjectsTreeOperation.loadSections,
        );
        expect(cubit.state.failure?.kind, ProjectsTreeFailureKind.forbidden);
        expect(cubit.state.failure?.code, 'workspace.forbidden');

        repository.listResult = null;
        repository.archivedFromServer = <ProjectListItem>[
          _archivedProject('archived'),
        ];
        cubit.retryFailure();
        await pumpEventQueue();

        expect(cubit.state.failure, isNull);
        expect(cubit.state.archived.map((project) => project.id), <String>[
          'archived',
        ]);
      },
    );

    test('licznik odczytu sekcji jest pomijany po zamknięciu cubitu', () async {
      final local = ProjectsTreeCubit(
        workspaceId: 'workspace-1',
        mutations: repository,
      );
      final future = local.refreshServerSections();
      await local.close();

      await future;

      expect(local.isClosed, isTrue);
    });
  });

  group('przypięcie i ukrycie', () {
    test('stan lokalny zmienia się przed odpowiedzią serwera', () async {
      final completer =
          Completer<Either<ApiError, ProjectUserPreferenceResponse>>();
      repository.preferenceResponses.add(completer.future);
      cubit.syncFromServer(<ProjectListItem>[_project('a'), _project('b')]);

      cubit.setPinned(_project('a'), isPinned: true);

      expect(visibleIds(cubit), <String>['a', 'b']);
      expect(cubit.state.pendingProjectIds, contains('a'));
      expect(repository.preferenceCalls.single.isPinned, isTrue);

      completer.complete(
        Right(
          ProjectUserPreferenceResponse(
            projectId: 'a',
            isHidden: false,
            isPinned: true,
            sortPosition: 0,
            updatedAtUtc: DateTime.utc(2026, 9, 19),
          ),
        ),
      );
      await pumpEventQueue();

      expect(cubit.state.pendingProjectIds, isEmpty);
      expect(cubit.state.failure, isNull);
      expect(cubit.state.notice?.kind, ProjectsTreeNoticeKind.pinned);
    });

    test('porażka 403 cofa wyłącznie pole operacji i raportuje błąd', () async {
      cubit.syncFromServer(<ProjectListItem>[
        _project('a'),
        _project('b', isPinned: true),
      ]);
      repository.enqueuePreference(
        Left(
          _apiError(
            statusCode: 403,
            apiCode: 'project_forbidden',
            traceId: 'trace-403',
          ),
        ),
      );

      cubit.setPinned(_project('a'), isPinned: true);
      await pumpEventQueue();

      expect(visibleIds(cubit), <String>['b', 'a']);
      expect(cubit.state.visible.first.isPinned, isTrue);
      final failure = cubit.state.failure;
      expect(failure, isNotNull);
      expect(failure!.operation, ProjectsTreeOperation.pin);
      expect(failure.kind, ProjectsTreeFailureKind.forbidden);
      expect(failure.statusCode, 403);
      expect(failure.code, 'project_forbidden');
      expect(failure.traceId, 'trace-403');
      expect(failure.rolledBack, isTrue);
    });

    test('porażka 409 i 500 kończy się rollbackiem i trwałym błędem', () async {
      for (final statusCode in <int>[409, 500]) {
        final localCubit = ProjectsTreeCubit(
          workspaceId: 'workspace-1',
          mutations: repository,
        );
        repository.preferenceResponses.clear();
        localCubit.syncFromServer(<ProjectListItem>[
          _project('a'),
          _project('b'),
        ]);
        repository.enqueuePreference(
          Left(_apiError(statusCode: statusCode, traceId: 'trace-$statusCode')),
        );

        localCubit.setHidden(_project('a'), isHidden: true);
        await pumpEventQueue();

        expect(localCubit.state.hidden, isEmpty, reason: 'status $statusCode');
        expect(
          visibleIds(localCubit),
          <String>['a', 'b'],
          reason: 'status $statusCode',
        );
        expect(
          localCubit.state.failure?.kind,
          statusCode == 409
              ? ProjectsTreeFailureKind.conflict
              : ProjectsTreeFailureKind.server,
          reason: 'status $statusCode',
        );
        expect(localCubit.state.failure?.rolledBack, isTrue);
        expect(localCubit.state.failure?.traceId, 'trace-$statusCode');
        await localCubit.close();
      }
    });

    test(
      'późniejsza zmiana użytkownika nie jest cofana przez porażkę',
      () async {
        cubit.syncFromServer(<ProjectListItem>[_project('a')]);
        final first =
            Completer<Either<ApiError, ProjectUserPreferenceResponse>>();
        repository.preferenceResponses.add(first.future);
        repository.enqueuePreference(
          Right(
            ProjectUserPreferenceResponse(
              projectId: 'a',
              isHidden: false,
              isPinned: false,
              updatedAtUtc: DateTime.utc(2026, 9, 19),
            ),
          ),
        );

        cubit.setPinned(_project('a'), isPinned: true);
        cubit.setPinned(_project('a'), isPinned: false);
        first.complete(Left(_apiError(statusCode: 403)));
        await pumpEventQueue();

        expect(repository.preferenceCalls.length, 2);
        expect(repository.preferenceCalls[0].isPinned, isTrue);
        expect(repository.preferenceCalls[1].isPinned, isFalse);
        expect(cubit.state.visible.single.isPinned, isFalse);
        expect(cubit.state.failure?.rolledBack, isFalse);
      },
    );

    test(
      'kolejne intencje tego samego pola są scalane do ostatniej wartości',
      () async {
        cubit.syncFromServer(<ProjectListItem>[_project('a')]);
        final first =
            Completer<Either<ApiError, ProjectUserPreferenceResponse>>();
        repository.preferenceResponses.add(first.future);
        repository.enqueuePreference(
          Right(
            ProjectUserPreferenceResponse(
              projectId: 'a',
              isHidden: false,
              isPinned: false,
              updatedAtUtc: DateTime.utc(2026, 9, 19),
            ),
          ),
        );

        cubit.setPinned(_project('a'), isPinned: true);
        cubit.setPinned(_project('a'), isPinned: false);
        cubit.setPinned(_project('a'), isPinned: true);
        cubit.setPinned(_project('a'), isPinned: false);
        first.complete(
          Right(
            ProjectUserPreferenceResponse(
              projectId: 'a',
              isHidden: false,
              isPinned: true,
              updatedAtUtc: DateTime.utc(2026, 9, 19),
            ),
          ),
        );
        await pumpEventQueue();

        expect(repository.preferenceCalls.length, 2);
        expect(repository.preferenceCalls[1].isPinned, isFalse);
        expect(cubit.state.visible.single.isPinned, isFalse);
      },
    );

    test('rollback przypięcia wraca na dokładną pozycję w drzewie', () async {
      cubit.syncFromServer(<ProjectListItem>[
        _project('a', isPinned: true),
        _project('b'),
        _project('c'),
      ]);
      repository.enqueuePreference(Left(_apiError(statusCode: 403)));

      cubit.setPinned(_project('c'), isPinned: true);
      expect(visibleIds(cubit), <String>['a', 'c', 'b']);

      await pumpEventQueue();

      expect(visibleIds(cubit), <String>['a', 'b', 'c']);
      expect(cubit.state.visible.last.isPinned, isFalse);
      expect(cubit.state.failure?.rolledBack, isTrue);
    });

    test(
      'udane przypięcie przenosi projekt na górę sekcji przypiętej',
      () async {
        cubit.syncFromServer(<ProjectListItem>[
          _project('a'),
          _project('b'),
          _project('c'),
        ]);

        cubit.setPinned(_project('c'), isPinned: true);
        await pumpEventQueue();

        expect(visibleIds(cubit), <String>['c', 'a', 'b']);
        expect(cubit.state.visible.first.isPinned, isTrue);
      },
    );

    test(
      'ukrycie chowa projekt natychmiast i potwierdza z możliwością cofnięcia',
      () async {
        cubit.syncFromServer(<ProjectListItem>[_project('a'), _project('b')]);

        cubit.setHidden(_project('a'), isHidden: true);

        expect(visibleIds(cubit), <String>['b']);
        expect(cubit.state.hidden.map((project) => project.id), <String>['a']);
        await pumpEventQueue();
        expect(cubit.state.notice?.kind, ProjectsTreeNoticeKind.hidden);
        expect(cubit.state.notice?.canUndo, isTrue);
        expect(cubit.state.notice?.projectId, 'a');

        cubit.undoLastNotice();
        await pumpEventQueue();

        expect(cubit.state.hidden, isEmpty);
        expect(visibleIds(cubit), <String>['a', 'b']);
        expect(repository.preferenceCalls.last.isHidden, isFalse);
      },
    );

    test(
      'brak portu mutacji zgłasza jawną niedostępność bez wyjątku',
      () async {
        final degraded = ProjectsTreeCubit(workspaceId: 'workspace-1');
        degraded.syncFromServer(<ProjectListItem>[_project('a')]);

        degraded.setHidden(_project('a'), isHidden: true);
        await pumpEventQueue();

        expect(degraded.state.visible.map((project) => project.id), <String>[
          'a',
        ]);
        expect(
          degraded.state.failure?.kind,
          ProjectsTreeFailureKind.unavailable,
        );
        expect(degraded.state.failure?.rolledBack, isFalse);
        await degraded.close();
      },
    );
  });

  group('kolejność', () {
    test('wysyła pełną listę widocznych projektów', () async {
      cubit.syncFromServer(<ProjectListItem>[
        _project('a'),
        _project('b'),
        _project('c'),
      ]);

      cubit.reorderVisible(<String>['c', 'a', 'b']);
      await pumpEventQueue();

      expect(repository.orderCalls.single, <String>['c', 'a', 'b']);
      expect(visibleIds(cubit), <String>['c', 'a', 'b']);
    });

    test('niepełna lista nie opuszcza aplikacji', () async {
      cubit.syncFromServer(<ProjectListItem>[_project('a'), _project('b')]);

      cubit.reorderVisible(<String>['a']);

      expect(repository.orderCalls, isEmpty);
      expect(
        cubit.state.failure?.kind,
        ProjectsTreeFailureKind.invalidIntent,
      );
    });

    test('porażka przywraca dokładne poprzednie pozycje', () async {
      cubit.syncFromServer(<ProjectListItem>[
        _project('a'),
        _project('b'),
        _project('c'),
      ]);
      repository.onUpdateOrder = (ids, call) async =>
          Left(_apiError(statusCode: 409, traceId: 'trace-order'));

      cubit.reorderVisible(<String>['c', 'b', 'a']);
      await pumpEventQueue();

      expect(visibleIds(cubit), <String>['a', 'b', 'c']);
      expect(cubit.state.failure?.operation, ProjectsTreeOperation.reorder);
      expect(cubit.state.failure?.rolledBack, isTrue);
      expect(cubit.state.failure?.traceId, 'trace-order');
      expect(cubit.state.isReordering, isFalse);
    });

    test(
      'ponowienie po porażce wysyła ostatnią intencję użytkownika',
      () async {
        cubit.syncFromServer(<ProjectListItem>[_project('a'), _project('b')]);
        var call = 0;
        repository.onUpdateOrder = (ids, _) async {
          call++;
          if (call == 1) return Left(_apiError(statusCode: 500));
          return Right(<ProjectListItem>[
            _project('b'),
            _project('a'),
          ]);
        };

        cubit.reorderVisible(<String>['b', 'a']);
        await pumpEventQueue();
        expect(repository.orderCalls.length, 1);

        cubit.retryFailure();
        await pumpEventQueue();

        expect(repository.orderCalls.length, 2);
        expect(repository.orderCalls.last, <String>['b', 'a']);
        expect(visibleIds(cubit), <String>['b', 'a']);
        expect(cubit.state.failure, isNull);
      },
    );
  });

  group('lifecycle', () {
    test(
      'archiwizacja przenosi projekt do sekcji Archiwum i pozwala cofnąć',
      () async {
        cubit.syncFromServer(<ProjectListItem>[
          _project('a'),
          _project('b'),
          _project('c'),
        ]);
        repository.onArchive = (projectId, _) async =>
            Right(_project(projectId));

        cubit.archive(_project('b'));
        await pumpEventQueue();

        expect(visibleIds(cubit), <String>['a', 'c']);
        expect(cubit.state.archived.map((project) => project.id), <String>[
          'b',
        ]);
        expect(cubit.state.notice?.kind, ProjectsTreeNoticeKind.archived);
        expect(cubit.state.notice?.canUndo, isTrue);

        cubit.undoLastNotice();
        await pumpEventQueue();

        expect(visibleIds(cubit), <String>['a', 'c', 'b']);
        expect(cubit.state.archived, isEmpty);
      },
    );

    test('nieudana archiwizacja wraca na dokładną pozycję', () async {
      cubit.syncFromServer(<ProjectListItem>[
        _project('a'),
        _project('b'),
        _project('c'),
      ]);
      repository.onArchive = (projectId, _) async =>
          Left(_apiError(statusCode: 403, apiCode: 'project_manage_required'));

      cubit.archive(_project('b'));
      expect(cubit.state.archived.map((project) => project.id), <String>['b']);
      await pumpEventQueue();

      expect(visibleIds(cubit), <String>['a', 'b', 'c']);
      expect(cubit.state.archived, isEmpty);
      expect(cubit.state.failure?.operation, ProjectsTreeOperation.archive);
      expect(cubit.state.failure?.code, 'project_manage_required');
      expect(cubit.state.failure?.rolledBack, isTrue);
    });

    test('archiwizacja wysyła wersję projektu jako expectedVersion', () async {
      cubit.syncFromServer(<ProjectListItem>[
        _project('a', version: 7),
        _project('b'),
      ]);

      cubit.archive(_project('a'));
      await pumpEventQueue();

      expect(repository.archiveCalls, <String>['a']);
      expect(repository.archiveVersions, <int?>[7]);
    });

    test('przywrócenie wysyła wersję projektu jako expectedVersion', () async {
      repository.archivedFromServer = <ProjectListItem>[
        _archivedProject('a', version: 11),
      ];
      await cubit.refreshServerSections();

      cubit.restore(cubit.state.archived.single);
      await pumpEventQueue();

      expect(repository.restoreCalls, <String>['a']);
      expect(repository.restoreVersions, <int?>[11]);
    });

    test(
      'konflikt 409 przy expectedVersion zostaje trwałym błędem z kodem',
      () async {
        cubit.syncFromServer(<ProjectListItem>[_project('a', version: 3)]);
        repository.onArchive = (projectId, _) async => Left(
          _apiError(
            statusCode: 409,
            apiCode: 'project.version_conflict',
            traceId: 'trace-version',
          ),
        );

        cubit.archive(_project('a', version: 3));
        await pumpEventQueue();

        final failure = cubit.state.failure;
        expect(failure?.operation, ProjectsTreeOperation.archive);
        expect(failure?.kind, ProjectsTreeFailureKind.conflict);
        expect(failure?.statusCode, 409);
        expect(failure?.code, 'project.version_conflict');
        expect(failure?.traceId, 'trace-version');
        expect(failure?.rolledBack, isTrue);
        expect(cubit.state.archived, isEmpty);
        expect(visibleIds(cubit), <String>['a']);
      },
    );

    test('odpowiedź serwera podnosi wersję dla kolejnej operacji', () async {
      cubit.syncFromServer(<ProjectListItem>[_project('a', version: 4)]);
      repository.onArchive = (projectId, _) async =>
          Right(_project(projectId, version: 21));
      repository.onRestore = (projectId, _) async =>
          Right(_project(projectId, version: 22));

      cubit.archive(_project('a', version: 4));
      await pumpEventQueue();
      expect(cubit.state.archived.single.version, 21);

      cubit.restore(cubit.state.archived.single);
      await pumpEventQueue();

      expect(repository.archiveVersions, <int?>[4]);
      expect(repository.restoreVersions, <int?>[21]);
    });

    test(
      'preferencje wysyłają wersję z poprzedniej odpowiedzi serwera',
      () async {
        repository.preferenceVersions.addAll(<int?>[5, 6]);
        cubit.syncFromServer(<ProjectListItem>[_project('a')]);

        // Pierwszy zapis w sesji nie zna jeszcze wersji preferencji.
        cubit.setPinned(_project('a'), isPinned: true);
        await pumpEventQueue();
        // Drugi zapis używa wersji zwróconej przez pierwszy.
        cubit.setHidden(_project('a'), isHidden: true);
        await pumpEventQueue();

        expect(
          repository.preferenceCalls.map((call) => call.expectedVersion),
          <int?>[null, 5],
        );
      },
    );

    test(
      'konflikt preferencji jest trwały, a ponowienie nie tonie w 409',
      () async {
        repository.enqueuePreference(
          Left(
            _apiError(
              statusCode: 409,
              apiCode: 'project.preference_version_conflict',
            ),
          ),
        );
        repository.preferenceVersions.add(null);
        cubit.syncFromServer(<ProjectListItem>[_project('a')]);

        cubit.setPinned(_project('a', version: 9), isPinned: true);
        await pumpEventQueue();

        expect(
          cubit.state.failure?.code,
          'project.preference_version_conflict',
        );
        expect(cubit.state.failure?.kind, ProjectsTreeFailureKind.conflict);
        expect(cubit.state.visible.single.isPinned, isFalse);

        repository.preferenceResponses.clear();
        cubit.retryFailure();
        await pumpEventQueue();

        expect(cubit.state.visible.single.isPinned, isTrue);
        expect(
          repository.preferenceCalls.last.expectedVersion,
          isNull,
          reason: 'odrzucona wersja nie może blokować jawnego ponowienia',
        );
      },
    );

    test('trwałe usunięcie czyści projekt tylko po sukcesie', () async {
      cubit.syncFromServer(<ProjectListItem>[_project('a'), _project('b')]);
      repository.onArchive = (projectId, _) async => Right(_project(projectId));
      cubit.archive(_project('a'));
      await pumpEventQueue();

      repository.onDelete = (projectId, _) async =>
          Left(_apiError(statusCode: 404));
      cubit.deletePermanently(_project('a'));
      await pumpEventQueue();

      expect(cubit.state.archived.map((project) => project.id), <String>['a']);
      expect(
        cubit.state.failure?.operation,
        ProjectsTreeOperation.deletePermanently,
      );

      repository.onDelete = (projectId, _) async => const Right(null);
      cubit.deletePermanently(_project('a'));
      await pumpEventQueue();

      expect(cubit.state.archived, isEmpty);
      expect(cubit.state.visible.map((project) => project.id), <String>['b']);
      expect(repository.deleteCalls, <String>['a', 'a']);
    });

    test('przywrócenie wraca do drzewa nawet po porażce usunięcia', () async {
      cubit.syncFromServer(<ProjectListItem>[_project('a'), _project('b')]);
      repository.onArchive = (projectId, _) async => Right(_project(projectId));
      cubit.archive(_project('a'));
      await pumpEventQueue();
      repository.onRestore = (projectId, _) async => Right(_project(projectId));

      cubit.restore(_project('a'));
      await pumpEventQueue();

      expect(visibleIds(cubit), <String>['b', 'a']);
      expect(cubit.state.archived, isEmpty);
      expect(repository.restoreCalls, <String>['a']);
    });
  });

  group('opuszczenie projektu', () {
    test('potwierdzenie serwera daje wynik i komunikat bez cofania', () async {
      cubit.syncFromServer(<ProjectListItem>[_project('a')]);

      final left = await cubit.leaveProject(_project('a'));

      expect(left, isTrue);
      expect(repository.leaveCalls, <String>['a']);
      expect(cubit.state.notice?.kind, ProjectsTreeNoticeKind.left);
      expect(
        cubit.state.notice?.canUndo,
        isFalse,
        reason: 'członkostwa nie da się przywrócić z drzewa',
      );
      // Projekt pozostaje w drzewie do czasu świeżej listy serwera: dostęp do
      // projektu Shared dziedziczy się z workspace.
      expect(visibleIds(cubit), <String>['a']);
    });

    test('porażka jest trwałym błędem z kodem i ponowieniem', () async {
      cubit.syncFromServer(<ProjectListItem>[_project('a')]);
      repository.onLeave = (projectId) async => Left(
        _apiError(statusCode: 409, apiCode: 'project.last_owner'),
      );

      final left = await cubit.leaveProject(_project('a'));

      expect(left, isFalse);
      expect(cubit.state.notice, isNull);
      expect(
        cubit.state.failure?.operation,
        ProjectsTreeOperation.leaveMembership,
      );
      expect(cubit.state.failure?.code, 'project.last_owner');
      expect(cubit.state.failure?.kind, ProjectsTreeFailureKind.conflict);
      expect(
        cubit.state.failure?.rolledBack,
        isFalse,
        reason:
            'drzewo nie zmieniło się optymistycznie, więc nie ma czego cofać',
      );

      repository.onLeave = null;
      cubit.retryFailure();
      await pumpEventQueue();

      expect(cubit.state.notice?.kind, ProjectsTreeNoticeKind.left);
      expect(repository.leaveCalls, <String>['a', 'a']);
    });

    test('brak portu mutacji zgłasza niedostępność zamiast sukcesu', () async {
      final degraded = ProjectsTreeCubit(workspaceId: 'workspace-1');
      degraded.syncFromServer(<ProjectListItem>[_project('a')]);

      final left = await degraded.leaveProject(_project('a'));

      expect(left, isFalse);
      expect(
        degraded.state.failure?.kind,
        ProjectsTreeFailureKind.unavailable,
      );
      await degraded.close();
    });
  });

  group('szablon projektu', () {
    test('tworzy szablon i potwierdza sukces', () async {
      final templates = _FakeProjectTemplatesRepository();
      final localCubit = ProjectsTreeCubit(
        workspaceId: 'workspace-1',
        mutations: repository,
        templates: templates,
      );

      final created = await localCubit.createTemplateFromProject(
        project: _project('a'),
        name: 'Szablon A',
      );

      expect(created, isTrue);
      expect(templates.calls.single, 'workspace-1/a/Szablon A');
      expect(
        localCubit.state.notice?.kind,
        ProjectsTreeNoticeKind.templateCreated,
      );
      await localCubit.close();
    });

    test('porażka tworzenia szablonu nie udaje sukcesu', () async {
      final templates = _FakeProjectTemplatesRepository(
        result: Left(_apiError(statusCode: 409, traceId: 'trace-template')),
      );
      final localCubit = ProjectsTreeCubit(
        workspaceId: 'workspace-1',
        mutations: repository,
        templates: templates,
      );

      final created = await localCubit.createTemplateFromProject(
        project: _project('a'),
        name: 'Szablon A',
      );

      expect(created, isFalse);
      expect(localCubit.state.notice, isNull);
      expect(
        localCubit.state.failure?.operation,
        ProjectsTreeOperation.createTemplate,
      );
      expect(localCubit.state.failure?.traceId, 'trace-template');
      await localCubit.close();
    });
  });

  test('dismissFailure czyści trwały komunikat bez zmiany projektów', () async {
    cubit.syncFromServer(<ProjectListItem>[_project('a')]);
    repository.enqueuePreference(Left(_apiError(statusCode: 403)));
    cubit.setPinned(_project('a'), isPinned: true);
    await pumpEventQueue();
    expect(cubit.state.failure, isNotNull);

    cubit.dismissFailure();

    expect(cubit.state.failure, isNull);
    expect(cubit.state.visible.map((project) => project.id), <String>['a']);
  });
}
