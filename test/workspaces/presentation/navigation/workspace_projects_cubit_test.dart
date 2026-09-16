import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/data/shared/enums/project_role.dart';
import 'package:ready_next/workspaces/domain/models/project_list_item.dart';
import 'package:ready_next/workspaces/domain/repositories/projects_repository.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_projects_state.dart';

class _FakeProjectsRepository implements ProjectsRepository {
  const _FakeProjectsRepository(this.result);

  final Either<ApiError, List<ProjectListItem>> result;

  @override
  Future<Either<ApiError, List<ProjectListItem>>> listProjects(
    String workspaceId, {
    bool includeHidden = false,
  }) async => result;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  const project = ProjectListItem(
    id: 'project-1',
    workspaceId: 'workspace-1',
    name: 'Alpha',
    myRole: ProjectRole.member,
    isPinned: true,
    sortPosition: 0,
  );

  test('ładuje projekty dopiero na żądanie i emituje gotowy stan', () async {
    final cubit = WorkspaceProjectsCubit(
      repository: const _FakeProjectsRepository(Right([project])),
      workspaceId: 'workspace-1',
    );

    expect(cubit.state, isA<WorkspaceProjectsInitial>());
    await cubit.load();

    expect(cubit.state, isA<WorkspaceProjectsReady>());
    expect((cubit.state as WorkspaceProjectsReady).items.single.name, 'Alpha');
    await cubit.close();
  });

  test('nie ukrywa błędu backendu w gałęzi menu', () async {
    final cubit = WorkspaceProjectsCubit(
      repository: const _FakeProjectsRepository(
        Left(ApiError(type: ApiErrorType.forbidden, message: 'Brak dostępu.')),
      ),
      workspaceId: 'workspace-1',
    );

    await cubit.load();

    expect(cubit.state, isA<WorkspaceProjectsFailure>());
    expect((cubit.state as WorkspaceProjectsFailure).message, 'Brak dostępu.');
    await cubit.close();
  });
}
