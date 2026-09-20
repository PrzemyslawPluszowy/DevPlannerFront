import 'dart:async';

import 'package:dartz/dartz.dart' hide State;
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_preview_models.dart';
import 'package:devplanner/workspaces/data/projects/setups/models/project_setup_request_models.dart';
import 'package:devplanner/workspaces/data/projects/templates/models/project_template_models.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_setup_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_status.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_visibility.dart';
import 'package:devplanner/workspaces/data/shared/enums/workspace_role.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_setup/project_setup_creation.dart';
import 'package:devplanner/workspaces/domain/repositories/project_setups_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_templates_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Workspace, w którym wszystkie testy kreatora tworzą projekt.
const String kProjectSetupWorkspaceId = 'ws-1';

/// Port kreatora sterowany z testu: każdy test decyduje, co zwróci `preview`
/// i `create`, a fixture rejestruje pełne żądania razem z kluczami idempotencji.
final class FakeProjectSetupsRepository implements ProjectSetupsRepository {
  /// Tworzy atrapę portu kreatora.
  FakeProjectSetupsRepository({this.onPreview, this.onCreate});

  /// Odpowiedź `preview`; `null` zwraca poprawny plan pustego projektu.
  Future<Either<ApiError, ProjectSetupPreviewResponse>> Function(
    CreateProjectSetupRequest request,
  )?
  onPreview;

  /// Odpowiedź `create`; `null` zwraca utworzony projekt `project-new`.
  Future<Either<ApiError, ProjectSetupCreation>> Function(
    CreateProjectSetupRequest request,
    String idempotencyKey,
  )?
  onCreate;

  /// Żądania `preview` w kolejności zgłoszeń.
  final List<CreateProjectSetupRequest> previewRequests =
      <CreateProjectSetupRequest>[];

  /// Żądania `create` w kolejności zgłoszeń.
  final List<CreateProjectSetupRequest> createRequests =
      <CreateProjectSetupRequest>[];

  /// Klucze idempotencji `create` w kolejności zgłoszeń.
  final List<String> idempotencyKeys = <String>[];

  @override
  Future<Either<ApiError, ProjectSetupPreviewResponse>> previewProjectSetup({
    required String workspaceId,
    required CreateProjectSetupRequest request,
  }) {
    previewRequests.add(request);
    final handler = onPreview;
    if (handler == null) return Future.value(Right(projectSetupPlan()));
    return handler(request);
  }

  @override
  Future<Either<ApiError, ProjectSetupCreation>> createProjectSetup({
    required String workspaceId,
    required CreateProjectSetupRequest request,
    required String idempotencyKey,
  }) {
    createRequests.add(request);
    idempotencyKeys.add(idempotencyKey);
    final handler = onCreate;
    if (handler == null) return Future.value(Right(projectSetupCreation()));
    return handler(request, idempotencyKey);
  }
}

/// Port projektów sesji w kształcie produkcyjnym.
///
/// W aplikacji `ProjectsRepositoryImpl` realizuje także kontrakt kreatora i to
/// ten obiekt przekazuje sidebar. Atrapa musi mieć ten sam kształt, żeby test
/// otwierał kreator dokładnie tak, jak robi to aplikacja.
final class FakeSessionProjectsRepository
    implements ProjectsRepository, ProjectSetupsRepository {
  /// Tworzy port sesji delegujący kontrakt kreatora do [setups].
  FakeSessionProjectsRepository(this.setups);

  /// Port kreatora, na który delegujemy oba wywołania.
  final FakeProjectSetupsRepository setups;

  @override
  Future<Either<ApiError, ProjectSetupPreviewResponse>> previewProjectSetup({
    required String workspaceId,
    required CreateProjectSetupRequest request,
  }) => setups.previewProjectSetup(workspaceId: workspaceId, request: request);

  @override
  Future<Either<ApiError, ProjectSetupCreation>> createProjectSetup({
    required String workspaceId,
    required CreateProjectSetupRequest request,
    required String idempotencyKey,
  }) => setups.createProjectSetup(
    workspaceId: workspaceId,
    request: request,
    idempotencyKey: idempotencyKey,
  );

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} nie jest stubowane');
}

/// Atrapa katalogu i podglądów szablonów projektu.
final class FakeProjectTemplatesRepository
    implements ProjectTemplatesRepository {
  /// Tworzy atrapę katalogu.
  FakeProjectTemplatesRepository({
    this.templates = const <ProjectTemplateResponse>[],
    this.details,
    this.listError,
    this.detailsError,
    this.onDetails,
  });

  /// Katalog zwracany przez `listTemplates`.
  List<ProjectTemplateResponse> templates;

  /// Podgląd zwracany przez `getTemplateDetails`.
  ProjectTemplateDetailsResponse? details;

  /// Błąd katalogu; wygrywa z [templates].
  ApiError? listError;

  /// Błąd podglądu; wygrywa z [details].
  ApiError? detailsError;

  /// Odpowiedź podglądu sterowana z testu; `null` zwraca [details].
  ///
  /// Potrzebne tam, gdzie ten sam szablon ma zwrócić różne wersje w kolejnych
  /// odczytach, np. po konflikcie wersji przy tworzeniu projektu.
  Future<Either<ApiError, ProjectTemplateDetailsResponse>> Function(
    String templateId,
  )?
  onDetails;

  /// Identyfikatory, których podgląd pobrał kreator.
  final List<String> detailsRequests = <String>[];

  @override
  Future<Either<ApiError, List<ProjectTemplateResponse>>> listTemplates(
    String workspaceId,
  ) async {
    final error = listError;
    if (error != null) return Left(error);
    return Right(List<ProjectTemplateResponse>.of(templates));
  }

  @override
  Future<Either<ApiError, ProjectTemplateDetailsResponse>> getTemplateDetails({
    required String workspaceId,
    required String templateId,
  }) async {
    detailsRequests.add(templateId);
    final handler = onDetails;
    if (handler != null) return handler(templateId);
    final error = detailsError;
    if (error != null) return Left(error);
    final value = details;
    if (value == null) {
      return Left(
        ApiError(
          type: ApiErrorType.notFound,
          message: 'Brak podglądu szablonu $templateId.',
        ),
      );
    }
    return Right(value);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} nie jest stubowane');
}

/// Atrapa listy członków workspace.
final class FakeWorkspaceMembersRepository implements WorkspacesRepository {
  /// Tworzy atrapę listy członków.
  FakeWorkspaceMembersRepository({
    this.members = const <WorkspaceMemberResponse>[],
    this.membersError,
  });

  /// Członkowie zwracani przez `listMembers`.
  List<WorkspaceMemberResponse> members;

  /// Błąd listy członków; wygrywa z [members].
  ApiError? membersError;

  @override
  Future<Either<ApiError, List<WorkspaceMemberResponse>>> listMembers(
    String workspaceId,
  ) async {
    final error = membersError;
    if (error != null) return Left(error);
    return Right(List<WorkspaceMemberResponse>.of(members));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw UnimplementedError('${invocation.memberName} nie jest stubowane');
}

/// Buduje plan kreatora dla testów podsumowania.
ProjectSetupPreviewResponse projectSetupPlan({
  String name = 'Plan testowy',
  String? templateName,
  bool inheritsWorkspaceMembers = true,
  int memberCount = 1,
  String scheduleMode = 'Manual',
  List<ProjectSetupWarningResponse> warnings =
      const <ProjectSetupWarningResponse>[],
  List<ProjectSetupRecipePreviewResponse> recipes =
      const <ProjectSetupRecipePreviewResponse>[],
}) => ProjectSetupPreviewResponse(
  source: templateName == null
      ? ProjectSetupSourceKind.blank
      : ProjectSetupSourceKind.projectTemplate,
  template: templateName == null
      ? null
      : const ProjectSetupTemplatePreviewResponse(
          templateId: 'template-1',
          name: 'Szablon startowy',
          version: 3,
          taskCount: 4,
          labelCount: 2,
          customFieldCount: 1,
          customStatusCount: 5,
        ),
  project: ProjectSetupProjectPreviewResponse(
    name: name,
    visibility: ProjectVisibility.private,
    status: ProjectStatus.active,
    inheritsWorkspaceMembers: inheritsWorkspaceMembers,
    memberCount: memberCount,
    members: const <ProjectSetupMemberPreviewResponse>[],
  ),
  workflow: const ProjectSetupWorkflowPreviewResponse(
    kind: ProjectSetupWorkflowKind.systemDefault,
    systemStatusCount: 4,
    customStatuses: <ProjectSetupWorkflowStatusPreviewResponse>[],
  ),
  taskView: const ProjectSetupTaskViewPreviewResponse(
    defaultView: ProjectSetupTaskViewKind.list,
    listDefaultColumns: <String>['title'],
    listSortField: 'Position',
    listSortDirection: 'Ascending',
    listGroupBy: 'Status',
    boardSwimlaneMode: KanbanSwimlaneMode.none,
    boardCardDensity: KanbanCardDensity.comfortable,
    boardVisibleCardFields: <KanbanCardField>[KanbanCardField.assignee],
    boardWipLimitCount: 0,
    boardHiddenColumnCount: 0,
  ),
  scheduleMode: scheduleMode,
  automationRecipes: recipes,
  warnings: warnings,
);

/// Buduje wynik utworzenia projektu z identyfikatorem przydzielonym przez serwer.
ProjectSetupCreation projectSetupCreation({
  String projectId = 'project-new',
  String name = 'Plan testowy',
  bool replayed = false,
}) => ProjectSetupCreation(
  project: ProjectListItem(
    id: projectId,
    workspaceId: kProjectSetupWorkspaceId,
    name: name,
  ),
  replayed: replayed,
  memberCount: 1,
  installedRecipeKeys: const <String>[],
  defaultView: ProjectSetupTaskViewKind.list,
);

/// Buduje wpis katalogu szablonów.
ProjectTemplateResponse projectTemplate({
  String id = 'template-1',
  String name = 'Szablon startowy',
  int version = 3,
}) => ProjectTemplateResponse(
  id: id,
  name: name,
  updatedAtUtc: DateTime.utc(2026, 9),
  version: version,
);

/// Buduje podgląd szablonu z policzalnymi zadaniami, etykietami i polami.
ProjectTemplateDetailsResponse projectTemplateDetails({
  String id = 'template-1',
  String name = 'Szablon startowy',
  String? description = 'Opis z katalogu',
  int version = 3,
  int taskCount = 4,
  int labelCount = 2,
  int customFieldCount = 1,
  int customStatusCount = 5,
}) => ProjectTemplateDetailsResponse(
  id: id,
  name: name,
  description: description,
  visibility: 'Private',
  status: 'Active',
  workflow: const <ProjectTemplateWorkflowResponse>[],
  transitions: const <ProjectTemplateTransitionResponse>[],
  customStatuses: <ProjectTemplateCustomStatusResponse>[
    for (var index = 0; index < customStatusCount; index++)
      ProjectTemplateCustomStatusResponse(
        sourceId: 'status-$index',
        name: 'Status $index',
        color: '#64748B',
        category: 'Todo',
        position: index,
        isDefault: index == 0,
      ),
  ],
  labels: <ProjectTemplateDefinitionResponse>[
    for (var index = 0; index < labelCount; index++)
      ProjectTemplateDefinitionResponse(
        sourceId: 'label-$index',
        name: 'Etykieta $index',
        type: 'Label',
      ),
  ],
  customFields: <ProjectTemplateDefinitionResponse>[
    for (var index = 0; index < customFieldCount; index++)
      ProjectTemplateDefinitionResponse(
        sourceId: 'field-$index',
        name: 'Pole $index',
        type: 'Text',
      ),
  ],
  tasks: <ProjectTemplateTaskResponse>[
    for (var index = 0; index < taskCount; index++)
      ProjectTemplateTaskResponse(
        sourceId: 'task-$index',
        title: 'Zadanie $index',
        status: 'Todo',
        priority: 'Medium',
        position: index,
        checklist: const <String>[],
        acceptanceCriteria: const <String>[],
        labelSourceIds: const <String>[],
        customFieldValues: const <ProjectTemplateTaskCustomValueResponse>[],
      ),
  ],
  updatedAtUtc: DateTime.utc(2026, 9),
  version: version,
);

/// Buduje aktywnego członka workspace.
WorkspaceMemberResponse workspaceMember({
  required String userId,
  WorkspaceRole role = WorkspaceRole.member,
  String? id,
}) => WorkspaceMemberResponse(
  id: id ?? 'membership-$userId',
  userId: userId,
  role: role,
  createdAtUtc: DateTime.utc(2026, 9),
  updatedAtUtc: DateTime.utc(2026, 9),
);

/// Błąd portu w kształcie zwracanym przez repozytoria.
ApiError projectSetupApiError({
  ApiErrorType type = ApiErrorType.badResponse,
  String message = 'Operacja nie powiodła się.',
  int? statusCode,
  String? apiCode,
  String? traceId,
}) => ApiError(
  type: type,
  message: message,
  statusCode: statusCode,
  apiCode: apiCode,
  traceId: traceId,
);

/// Klucz trasy projektu używany przez testy sukcesu.
const String kProjectRouteKey = 'project-route';

/// Uruchamia aplikację testową z prawdziwym routerem i otwiera [open] po
/// pierwszej klatce.
///
/// Kreator w aplikacji żyje w dialogu na routerze, więc sukces kończy się
/// `Navigator.pop` i przejściem do projektu. Ramka odwzorowuje to zachowanie:
/// trasa projektu renderuje [kProjectRouteKey], żeby test mógł sprawdzić
/// dokąd zaprowadziło utworzenie projektu.
Future<void> pumpProjectSetupApp(
  WidgetTester tester, {
  required Future<void> Function(BuildContext context) open,
}) async {
  // Kreator jest modalem desktopowym: test dowodzi kontraktu portów, a nie
  // responsywności w wąskim oknie, więc dostaje docelowy rozmiar okna.
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1440, 900);
  addTearDown(tester.view.reset);
  final router = GoRouter(
    initialLocation: '/start',
    routes: <RouteBase>[
      GoRoute(
        path: '/start',
        builder: (context, state) => _DialogLauncher(open: open),
      ),
      GoRoute(
        path: '/workspaces/:workspaceId',
        builder: (context, state) => Scaffold(
          body: Text('workspace:${state.pathParameters['workspaceId']}'),
        ),
      ),
      // Kreator po sukcesie otwiera projekt trasą bez sufiksu modułu.
      GoRoute(
        path: '/workspaces/:workspaceId/projects/:projectId',
        builder: (context, state) => Scaffold(
          body: Text('$kProjectRouteKey:${state.pathParameters['projectId']}'),
        ),
      ),
      GoRoute(
        path: '/workspaces/:workspaceId/projects/:projectId/tasks',
        builder: (context, state) => Scaffold(
          body: Text(
            '$kProjectRouteKey:${state.pathParameters['projectId']}',
          ),
        ),
      ),
    ],
  );
  await tester.pumpWidget(
    MaterialApp.router(
      locale: const Locale('pl'),
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
  await tester.pump();
  await tester.pump();
}

/// Otwiera dialog po pierwszej klatce, żeby test nie musiał klikać wejścia.
class _DialogLauncher extends StatefulWidget {
  const _DialogLauncher({required this.open});

  final Future<void> Function(BuildContext context) open;

  @override
  State<_DialogLauncher> createState() => _DialogLauncherState();
}

class _DialogLauncherState extends State<_DialogLauncher> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(widget.open(context));
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: SizedBox.shrink());
}
