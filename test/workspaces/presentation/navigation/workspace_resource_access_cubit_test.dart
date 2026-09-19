import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:devplanner/foundation/error/api_error.dart';
import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_resource_access_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_resource_access_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _Repository implements ProjectResourcesRepository {
  _Repository(this.result);

  final Either<ApiError, List<ProjectResourceListItem>> result;

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listTasks({
    required String workspaceId,
    required String projectId,
  }) async => result;

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listWhiteboards({
    required String workspaceId,
    required String projectId,
  }) async => result;

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listWikiPages({
    required String workspaceId,
    required String projectId,
  }) async => result;

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listProjectFolders({
    required String workspaceId,
    required String projectId,
  }) async => result;

  @override
  Future<Either<ApiError, List<ProjectResourceListItem>>> listAutomations({
    required String workspaceId,
    required String projectId,
  }) async => result;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const task = ProjectResourceListItem(
    id: 'task-1',
    title: 'Przygotować menu',
    kind: ProjectResourceKind.tasks,
    isVerified: true,
  );

  blocTest<WorkspaceResourceAccessCubit, WorkspaceResourceAccessState>(
    'potwierdza zasób z URL dopiero po znalezieniu go w katalogu projektu',
    build: () => WorkspaceResourceAccessCubit(
      repository: _Repository(const Right([task])),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      resourceKind: 'tasks',
      resourceId: 'task-1',
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<WorkspaceResourceAccessLoading>(),
      isA<WorkspaceResourceAccessGranted>(),
    ],
  );

  blocTest<WorkspaceResourceAccessCubit, WorkspaceResourceAccessState>(
    'nie pokazuje technicznego placeholdera dla zasobu spoza katalogu',
    build: () => WorkspaceResourceAccessCubit(
      repository: _Repository(const Right([task])),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
      resourceKind: 'tasks',
      resourceId: 'missing-task',
    ),
    act: (cubit) => cubit.load(),
    expect: () => [
      isA<WorkspaceResourceAccessLoading>(),
      isA<WorkspaceResourceAccessNotFound>(),
    ],
  );
}
