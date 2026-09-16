import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ready_next/core/error/api_error.dart';
import 'package:ready_next/workspaces/domain/models/project_list_item.dart';
import 'package:ready_next/workspaces/domain/repositories/projects_repository.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_project_access_cubit.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_project_access_state.dart';

final class _ProjectsRepository implements ProjectsRepository {
  _ProjectsRepository(this.result);
  Either<ApiError, List<ProjectListItem>> result;

  @override
  Future<Either<ApiError, List<ProjectListItem>>> listProjects(
    String workspaceId, {
    bool includeHidden = false,
  }) async => result;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('odrzuca projekt spoza workspace’u z deep linku', () async {
    final repository = _ProjectsRepository(const Right([]));
    final cubit = WorkspaceProjectAccessCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state, isA<WorkspaceProjectAccessDenied>());
  });

  test('zachowuje jawny błąd backendu 403', () async {
    final repository = _ProjectsRepository(
      const Left(
        ApiError(
          type: ApiErrorType.forbidden,
          message: 'Brak dostępu do projektu.',
          backendCode: 40301,
        ),
      ),
    );
    final cubit = WorkspaceProjectAccessCubit(
      repository: repository,
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    addTearDown(cubit.close);

    await cubit.load();

    final state = cubit.state as WorkspaceProjectAccessDenied;
    expect(state.message, 'Brak dostępu do projektu.');
    expect(state.backendCode, '40301');
  });
}
