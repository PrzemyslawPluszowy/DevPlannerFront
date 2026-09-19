import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/project_resources_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/project_resources_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeProjectResourcesRepository implements ProjectResourcesRepository {
  _FakeProjectResourcesRepository({
    required this.whiteboards,
    required this.wiki,
    this.tasks = const Right([]),
  });

  final Either<ApiError, List<ProjectResourceListItem>> whiteboards;
  final Either<ApiError, List<ProjectResourceListItem>> wiki;
  final Either<ApiError, List<ProjectResourceListItem>> tasks;
  int whiteboardCalls = 0;
  int wikiCalls = 0;
  int taskCalls = 0;

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listTasks({
    required String workspaceId,
    required String projectId,
  }) async {
    taskCalls++;
    return tasks;
  }

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listWhiteboards({
    required String workspaceId,
    required String projectId,
  }) async {
    whiteboardCalls++;
    return whiteboards;
  }

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listWikiPages({
    required String workspaceId,
    required String projectId,
  }) async {
    wikiCalls++;
    return wiki;
  }

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

void main() {
  const task = ProjectResourceListItem(
    id: 'task-1',
    title: 'TASK-1 · Przygotować menu',
    kind: ProjectResourceKind.tasks,
  );

  blocTest<ProjectResourcesCubit, ProjectResourcesState>(
    'ładuje zadania projektu przez lokalny Cubit zasobów',
    build: () => ProjectResourcesCubit(
      repository: _FakeProjectResourcesRepository(
        whiteboards: const Right([]),
        wiki: const Right([]),
        tasks: const Right([task]),
      ),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      kind: ProjectResourceKind.tasks,
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<ProjectResourcesLoading>(),
      isA<ProjectResourcesReady>(),
    ],
  );

  const whiteboard = ProjectResourceListItem(
    id: 'whiteboard-1',
    title: 'Plan wdrożenia',
    kind: ProjectResourceKind.whiteboards,
  );

  blocTest<ProjectResourcesCubit, ProjectResourcesState>(
    'ładuje whiteboardy dopiero po wywołaniu load i mapuje stan ready',
    build: () {
      final repository = _FakeProjectResourcesRepository(
        whiteboards: const Right([whiteboard]),
        wiki: const Right([]),
      );
      return ProjectResourcesCubit(
        repository: repository,
        workspaceId: 'workspace-1',
        projectId: 'project-1',
        kind: ProjectResourceKind.whiteboards,
      );
    },
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<ProjectResourcesLoading>(),
      isA<ProjectResourcesReady>(),
    ],
  );

  blocTest<ProjectResourcesCubit, ProjectResourcesState>(
    'zachowuje jawny komunikat backendu i pozwala ponowić błąd',
    build: () => ProjectResourcesCubit(
      repository: _FakeProjectResourcesRepository(
        whiteboards: const Left(
          ApiError(
            type: ApiErrorType.forbidden,
            message: 'Brak dostępu do whiteboardów.',
            backendCode: 403,
          ),
        ),
        wiki: const Right([]),
      ),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      kind: ProjectResourceKind.whiteboards,
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<ProjectResourcesLoading>(),
      isA<ProjectResourcesFailure>(),
    ],
    verify: (cubit) {
      final state = cubit.state as ProjectResourcesFailure;
      expect(state.message, 'Brak dostępu do whiteboardów.');
      expect(state.backendCode, '403');
    },
  );
}
