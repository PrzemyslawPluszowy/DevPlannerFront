import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_project_access_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_project_access_state.dart';
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
  test('udziela dostępu tylko dla projektu z tego workspace', () async {
    final cubit = WorkspaceProjectAccessCubit(
      gateway: _Gateway(
        Future.value([
          const ProjectListItem(
            id: 'project-1',
            workspaceId: 'workspace-1',
            name: 'Alpha',
          ),
        ]),
      ),
      workspaceId: 'workspace-1',
      projectId: 'project-1',
    );
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state, isA<WorkspaceProjectAccessGranted>());
  });

  test('brak projektu mapuje się na notFound bez enumeracji', () async {
    final cubit = WorkspaceProjectAccessCubit(
      gateway: _Gateway(Future.value(const [])),
      workspaceId: 'workspace-1',
      projectId: 'missing',
    );
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state, isA<WorkspaceProjectAccessDenied>());
    final denied = cubit.state as WorkspaceProjectAccessDenied;
    expect(denied.reason, ProjectsFailureReason.notFound);
    expect(denied.statusCode, 404);
  });
}
