import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_state.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Gateway implements ProjectsGateway {
  _Gateway(this.result);

  final Future<List<ProjectListItem>> result;

  @override
  Future<List<ProjectListItem>> listProjects(
    String workspaceId, {
    bool includeHidden = false,
  }) => result;
}

void main() {
  const project = ProjectListItem(
    id: 'project-1',
    workspaceId: 'workspace-1',
    name: 'Alpha',
    isPinned: true,
    sortPosition: 0,
  );

  test('ładuje projekty dopiero na żądanie i emituje gotowy stan', () async {
    final cubit = WorkspaceProjectsCubit(
      gateway: _Gateway(Future.value([project])),
      workspaceId: 'workspace-1',
    );
    addTearDown(cubit.close);

    expect(cubit.state, isA<WorkspaceProjectsInitial>());
    await cubit.load();

    expect(cubit.state, isA<WorkspaceProjectsReady>());
    expect((cubit.state as WorkspaceProjectsReady).items.single.name, 'Alpha');
  });

  test('zachowuje typed forbidden i nie zamienia go na pustą listę', () async {
    final cubit = WorkspaceProjectsCubit(
      gateway: _Gateway(
        Future<List<ProjectListItem>>.error(
          const ProjectsGatewayException(
            reason: ProjectsFailureReason.forbidden,
            statusCode: 403,
            backendCode: 'workspace.forbidden',
          ),
        ),
      ),
      workspaceId: 'workspace-1',
    );
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state, isA<WorkspaceProjectsFailure>());
    final failure = cubit.state as WorkspaceProjectsFailure;
    expect(failure.reason, ProjectsFailureReason.forbidden);
    expect(failure.statusCode, 403);
    expect(failure.backendCode, 'workspace.forbidden');
  });
}
