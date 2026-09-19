import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:devplanner/auth/domain/models/auth_models.dart';
import 'package:devplanner/auth/domain/ports/auth_session_port.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/workspaces/data/kanban/models/kanban_models.dart';
import 'package:devplanner/workspaces/data/projects/milestones/models/milestone_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_list_configuration_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_templates_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/models/task_views_models.dart';
import 'package:devplanner/workspaces/data/projects/tasks/tasks_board_composition.dart';
import 'package:devplanner/workspaces/data/realtime/scoped/workspace_scoped_realtime_service.dart';
import 'package:devplanner/workspaces/data/realtime/signalr/workspace_signalr_client.dart';
import 'package:devplanner/workspaces/data/shared/enums/kanban_enums.dart';
import 'package:devplanner/workspaces/data/shared/enums/project_task_status.dart';
import 'package:devplanner/workspaces/domain/models/project_member_profile.dart';
import 'package:devplanner/workspaces/domain/repositories/kanban_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/milestone_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_member_profiles_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_capacity_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_collaboration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_list_configuration_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_metadata_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_recurrence_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_template_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_view_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/task_workflow_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/tasks_repository.dart';
import 'package:devplanner/workspaces/presentation/tasks/board/tasks_board_route_page.dart';
import 'package:devplanner/workspaces/presentation/tasks/list/project_tasks_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:signalr_netcore/signalr_client.dart';

final class _MockKanbanRepository extends Mock implements KanbanRepository {}

final class _MockTasksRepository extends Mock implements TasksRepository {}

final class _MockTaskWorkflowRepository extends Mock
    implements TaskWorkflowRepository {}

final class _MockTaskCollaborationRepository extends Mock
    implements TaskCollaborationRepository {}

final class _MockTaskTemplateRepository extends Mock
    implements TaskTemplateRepository {}

final class _MockProjectMemberProfilesRepository extends Mock
    implements ProjectMemberProfilesRepository {}

final class _MockTaskMetadataRepository extends Mock
    implements TaskMetadataRepository {}

final class _MockTaskViewRepository extends Mock
    implements TaskViewRepository {}

final class _MockTaskListConfigurationRepository extends Mock
    implements TaskListConfigurationRepository {}

final class _MockTaskCapacityRepository extends Mock
    implements TaskCapacityRepository {}

final class _MockTaskRecurrenceRepository extends Mock
    implements TaskRecurrenceRepository {}

final class _MockMilestoneRepository extends Mock
    implements MilestoneRepository {}

final class _FakeSignalRTransport implements WorkspaceSignalRTransport {
  @override
  Stream<WorkspaceSignalRConnectionState> get states =>
      Stream<WorkspaceSignalRConnectionState>.value(
        WorkspaceSignalRConnectionState.disconnected,
      );

  @override
  Future<void> connect() async {}

  @override
  Future<void> disconnect() async {}

  @override
  Future<Object?> invoke(String methodName, {List<Object>? args}) async => null;

  @override
  void on(String methodName, MethodInvocationFunc handler) {}

  @override
  void dispose() {}
}

final class _FakeRealtimeFactory extends WorkspaceScopedRealtimeFactory {
  _FakeRealtimeFactory()
    : super(baseUrl: 'https://test.invalid', accessTokenProvider: _token);

  static Future<String?> _token() async => 'test-token';

  @override
  WorkspaceScopedRealtimeService create(WorkspaceScopedRealtimeKind kind) =>
      WorkspaceScopedRealtimeService(client: _FakeSignalRTransport());
}

class _RouteFixture {
  _RouteFixture({required this.boardResult, this.pendingBoard}) {
    _stubRepositories();
  }

  final Either<ApiError, KanbanBoardResponse> boardResult;
  final Future<Either<ApiError, KanbanBoardResponse>>? pendingBoard;
  final _MockKanbanRepository kanban = _MockKanbanRepository();
  final _MockTasksRepository tasks = _MockTasksRepository();
  final _MockTaskWorkflowRepository workflow = _MockTaskWorkflowRepository();
  final _MockTaskCollaborationRepository collaboration =
      _MockTaskCollaborationRepository();
  final _MockTaskTemplateRepository templates = _MockTaskTemplateRepository();
  final _MockProjectMemberProfilesRepository profiles =
      _MockProjectMemberProfilesRepository();
  final _MockTaskMetadataRepository metadata = _MockTaskMetadataRepository();
  final _MockTaskViewRepository views = _MockTaskViewRepository();
  final _MockTaskListConfigurationRepository listConfiguration =
      _MockTaskListConfigurationRepository();
  final _MockTaskCapacityRepository capacity = _MockTaskCapacityRepository();
  final _MockTaskRecurrenceRepository recurrence =
      _MockTaskRecurrenceRepository();
  final _MockMilestoneRepository milestones = _MockMilestoneRepository();

  TasksBoardComposition get composition => TasksBoardComposition(
    kanbanRepository: kanban,
    tasksRepository: tasks,
    workflowRepository: workflow,
    collaborationRepository: collaboration,
    taskTemplateRepository: templates,
    memberProfilesRepository: profiles,
    metadataRepository: metadata,
    viewRepository: views,
    listConfigurationRepository: listConfiguration,
    capacityRepository: capacity,
    recurrenceRepository: recurrence,
    milestoneRepository: milestones,
    realtimeFactory: _FakeRealtimeFactory(),
  );

  void _stubRepositories() {
    when(
      () => tasks.listProjectTaskGroups(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        query: any(named: 'query'),
      ),
    ).thenAnswer(
      (_) async => const Right<ApiError, ProjectTaskGroupedListResponse>(
        ProjectTaskGroupedListResponse(
          totalCount: 0,
          groupBy: TaskSavedViewGroupBy.status,
          groups: [],
        ),
      ),
    );
    when(
      () => kanban.getBoard(workspaceId: 'workspace-1', projectId: 'project-1'),
    ).thenAnswer((_) => pendingBoard ?? Future.value(boardResult));
    when(
      () => kanban.getUserPreference(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer(
      (_) async => const Left<ApiError, UserKanbanPreferenceResponse>(
        ApiError(type: ApiErrorType.notFound, message: 'No preference'),
      ),
    );
    when(
      () => workflow.getWorkflow(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer(
      (_) async => const Left<ApiError, ProjectTaskWorkflowResponse>(
        ApiError(type: ApiErrorType.notFound, message: 'No workflow'),
      ),
    );
    when(
      () => profiles.listProfiles(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        forceRefresh: true,
      ),
    ).thenAnswer(
      (_) async => const Right<ApiError, List<ProjectMemberProfile>>(
        <ProjectMemberProfile>[],
      ),
    );
    when(
      () => metadata.listLabels(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer(
      (_) async => const Right<ApiError, List<TaskLabelResponse>>(
        <TaskLabelResponse>[],
      ),
    );
    when(
      () => metadata.listCustomFields(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer(
      (_) async => const Right<ApiError, List<TaskCustomFieldResponse>>(
        <TaskCustomFieldResponse>[],
      ),
    );
    when(
      () => milestones.listMilestones(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer(
      (_) async =>
          const Right<ApiError, List<MilestoneResponse>>(<MilestoneResponse>[]),
    );
    when(
      () => views.list(workspaceId: 'workspace-1', projectId: 'project-1'),
    ).thenAnswer(
      (_) async => const Right<ApiError, List<TaskSavedViewResponse>>(
        <TaskSavedViewResponse>[],
      ),
    );
    when(
      () => listConfiguration.getEffectiveConfiguration(
        workspaceId: 'workspace-1',
        projectId: 'project-1',
      ),
    ).thenAnswer(
      (_) async => const Left<ApiError, EffectiveTaskListConfigurationResponse>(
        ApiError(type: ApiErrorType.notFound, message: 'No list config'),
      ),
    );
    when(() => templates.list('workspace-1')).thenAnswer(
      (_) async => const Right<ApiError, List<TaskTemplateResponse>>(
        <TaskTemplateResponse>[],
      ),
    );
  }
}

final class _RouteHarness extends StatelessWidget {
  const _RouteHarness({required this.fixture, this.initialView = 'kanban'});

  final _RouteFixture fixture;
  final String? initialView;

  @override
  Widget build(BuildContext context) => MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('pl'),
    home: Scaffold(
      body: TasksBoardRoutePage(
        composition: fixture.composition,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        authSession: AuthSessionController(
          initial: const AuthSessionSnapshot(
            status: AuthSessionStatus.signedIn,
            user: AuthUser(
              userId: 'user-1',
              login: 'tester',
              displayName: 'Tester',
            ),
          ),
        ),
        initialView: initialView,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  registerFallbackValue(const ProjectTasksGroupedQuery());

  group('TasksBoardRoutePage', () {
    testWidgets('uses the rich standalone list for the default route', (
      tester,
    ) async {
      final fixture = _RouteFixture(boardResult: _emptyBoardResult);
      await tester.pumpWidget(
        _RouteHarness(fixture: fixture, initialView: null),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ProjectTasksList), findsOneWidget);
      verify(
        () => fixture.tasks.listProjectTaskGroups(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          query: any(named: 'query'),
        ),
      ).called(1);
    });

    testWidgets('renders loading boundary before the board response', (
      tester,
    ) async {
      final completer = Completer<Either<ApiError, KanbanBoardResponse>>();
      final fixture = _RouteFixture(
        boardResult: _emptyBoardResult,
        pendingBoard: completer.future,
      );
      await tester.pumpWidget(_RouteHarness(fixture: fixture));

      expect(find.byType(TasksBoardRoutePage), findsOneWidget);
      expect(find.byType(Container), findsWidgets);

      completer.complete(_emptyBoardResult);
      await tester.pumpAndSettle();
    });

    testWidgets('passes workspace and project ids and renders empty board', (
      tester,
    ) async {
      final fixture = _RouteFixture(boardResult: _emptyBoardResult);
      await tester.pumpWidget(_RouteHarness(fixture: fixture));
      await tester.pumpAndSettle();

      expect(
        find.text('Projekt nie ma skonfigurowanych kolumn'),
        findsOneWidget,
      );
      verify(
        () => fixture.kanban.getBoard(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
        ),
      ).called(1);
    });

    testWidgets('renders a forbidden boundary without a network request', (
      tester,
    ) async {
      final fixture = _RouteFixture(
        boardResult: const Left<ApiError, KanbanBoardResponse>(
          ApiError(
            type: ApiErrorType.forbidden,
            statusCode: 403,
            message: 'Board access denied',
          ),
        ),
      );
      await tester.pumpWidget(_RouteHarness(fixture: fixture));
      await tester.pumpAndSettle();

      expect(find.text('Nie masz dostępu do tej tablicy'), findsOneWidget);
      expect(find.text('Board access denied'), findsOneWidget);
      verifyNever(
        () => fixture.kanban.getSystemColumn(
          workspaceId: 'workspace-1',
          projectId: 'project-1',
          status: ProjectTaskStatus.todo,
        ),
      );
    });
  });
}

const _emptyBoardResult = Right<ApiError, KanbanBoardResponse>(
  KanbanBoardResponse(
    projectId: 'project-1',
    swimlaneMode: KanbanSwimlaneMode.none,
    settingsVersion: 1,
    hiddenColumns: [],
    visibleCardFields: [],
    defaultCardDensity: KanbanCardDensity.comfortable,
    columns: [],
  ),
);
