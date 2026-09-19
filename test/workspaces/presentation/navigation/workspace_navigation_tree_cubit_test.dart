import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';
import 'package:devplanner/workspaces/domain/navigation/workspace_navigation_node.dart';
import 'package:devplanner/workspaces/domain/navigation/workspace_navigation_tree.dart';
import 'package:devplanner/workspaces/domain/ports/projects_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_navigation_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_navigation_tree_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_navigation_tree_state.dart';
import 'package:flutter_test/flutter_test.dart';

final class _WorkspaceGateway implements WorkspaceNavigationGateway {
  _WorkspaceGateway(this.result);

  final Future<List<WorkspaceSummary>> result;

  @override
  Future<List<WorkspaceSummary>> listWorkspaces() => result;
}

final class _ProjectsGateway implements ProjectsGateway {
  _ProjectsGateway(this.results);

  final Map<String, Future<List<ProjectListItem>>> results;
  final requestedWorkspaceIds = <String>[];

  @override
  Future<List<ProjectListItem>> listProjects(
    String workspaceId, {
    bool includeHidden = false,
  }) {
    requestedWorkspaceIds.add(workspaceId);
    return results[workspaceId] ?? Future.value(const <ProjectListItem>[]);
  }
}

void main() {
  const workspaces = [
    WorkspaceSummary(
      id: 'workspace-a',
      name: 'Alpha',
      isPinned: true,
      isHidden: false,
      isOwner: true,
    ),
    WorkspaceSummary(
      id: 'workspace-b',
      name: 'Beta',
      isPinned: false,
      isHidden: false,
      isOwner: false,
    ),
  ];

  test('materializes projects below the matching workspace only', () {
    final tree = WorkspaceNavigationTree.fromWorkspacesWithProjects(
      workspaces: workspaces,
      projectsByWorkspace: const {
        'workspace-a': [
          ProjectListItem(
            id: 'project-a',
            workspaceId: 'workspace-a',
            name: 'Project Alpha',
          ),
        ],
        'workspace-b': <ProjectListItem>[],
      },
    );

    final alpha = tree.workspaceNodes.firstWhere(
      (node) => node.workspaceId == 'workspace-a',
    );
    final beta = tree.workspaceNodes.firstWhere(
      (node) => node.workspaceId == 'workspace-b',
    );
    final alphaProjects = alpha.children.firstWhere(
      (node) => node.kind == WorkspaceNavigationNodeKind.projects,
    );
    final betaProjects = beta.children.firstWhere(
      (node) => node.kind == WorkspaceNavigationNodeKind.projects,
    );

    expect(alphaProjects.kind, WorkspaceNavigationNodeKind.projects);
    expect(alphaProjects.isDataPending, isFalse);
    expect(alphaProjects.children, hasLength(1));
    expect(
      alphaProjects.children.single.kind,
      WorkspaceNavigationNodeKind.project,
    );
    expect(alphaProjects.children.single.projectId, 'project-a');
    expect(alphaProjects.children.single.workspaceId, 'workspace-a');
    expect(alphaProjects.children.single.hasChildren, isTrue);
    final projectChildren = alphaProjects.children.single.children;
    final tasks = projectChildren.firstWhere(
      (node) => node.kind == WorkspaceNavigationNodeKind.tasks,
    );
    expect(
      tasks.children.map((node) => node.kind),
      containsAll([
        WorkspaceNavigationNodeKind.taskList,
        WorkspaceNavigationNodeKind.kanban,
        WorkspaceNavigationNodeKind.automations,
      ]),
    );
    expect(
      projectChildren.map((node) => node.kind),
      containsAll([
        WorkspaceNavigationNodeKind.whiteboards,
        WorkspaceNavigationNodeKind.corkboard,
        WorkspaceNavigationNodeKind.wiki,
        WorkspaceNavigationNodeKind.files,
      ]),
    );
    expect(betaProjects.children, isEmpty);
    expect(tree.hasPendingProjectData, isFalse);
  });

  test(
    'loads every workspace and produces a complete ready snapshot',
    () async {
      final projectsGateway = _ProjectsGateway({
        'workspace-a': Future.value(const [
          ProjectListItem(
            id: 'project-a',
            workspaceId: 'workspace-a',
            name: 'Project Alpha',
          ),
        ]),
        'workspace-b': Future.value(const <ProjectListItem>[]),
      });
      final cubit = WorkspaceNavigationTreeCubit(
        workspaceGateway: _WorkspaceGateway(Future.value(workspaces)),
        projectsGateway: projectsGateway,
      );
      addTearDown(cubit.close);

      await cubit.load();

      expect(projectsGateway.requestedWorkspaceIds, [
        'workspace-a',
        'workspace-b',
      ]);
      expect(cubit.state, isA<WorkspaceNavigationTreeReady>());
      final ready = cubit.state as WorkspaceNavigationTreeReady;
      expect(ready.tree.hasPendingProjectData, isFalse);
      expect(
        ready.tree.workspaceNodes.first.children
            .firstWhere(
              (node) => node.kind == WorkspaceNavigationNodeKind.projects,
            )
            .children
            .single
            .projectId,
        'project-a',
      );
    },
  );

  test(
    'keeps typed project failure and does not emit fallback projects',
    () async {
      final cubit = WorkspaceNavigationTreeCubit(
        workspaceGateway: _WorkspaceGateway(Future.value(workspaces)),
        projectsGateway: _ProjectsGateway({
          'workspace-a': Future<List<ProjectListItem>>.error(
            const ProjectsGatewayException(
              reason: ProjectsFailureReason.forbidden,
              statusCode: 403,
              backendCode: 'workspace.project.forbidden',
            ),
          ),
        }),
      );
      addTearDown(cubit.close);

      await cubit.load();

      expect(cubit.state, isA<WorkspaceNavigationTreeFailure>());
      final failure = cubit.state as WorkspaceNavigationTreeFailure;
      expect(failure.source, WorkspaceNavigationTreeFailureSource.projects);
      expect(failure.workspaceId, 'workspace-a');
      expect(failure.projectsReason, ProjectsFailureReason.forbidden);
      expect(failure.statusCode, 403);
    },
  );

  test('rejects a project returned for a different workspace', () async {
    final cubit = WorkspaceNavigationTreeCubit(
      workspaceGateway: _WorkspaceGateway(Future.value(workspaces)),
      projectsGateway: _ProjectsGateway({
        'workspace-a': Future.value(const [
          ProjectListItem(
            id: 'project-b',
            workspaceId: 'workspace-b',
            name: 'Wrong scope',
          ),
        ]),
      }),
    );
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state, isA<WorkspaceNavigationTreeFailure>());
    final failure = cubit.state as WorkspaceNavigationTreeFailure;
    expect(failure.source, WorkspaceNavigationTreeFailureSource.composition);
    expect(failure.workspaceId, 'workspace-a');
    expect(failure.projectsReason, ProjectsFailureReason.invalidResponse);
  });

  test('keeps typed workspace failure at the catalog boundary', () async {
    final cubit = WorkspaceNavigationTreeCubit(
      workspaceGateway: _WorkspaceGateway(
        Future<List<WorkspaceSummary>>.error(
          const WorkspacesGatewayException(
            reason: WorkspacesFailureReason.unauthorized,
            statusCode: 401,
            backendCode: 'auth.required',
          ),
        ),
      ),
      projectsGateway: _ProjectsGateway(const {}),
    );
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state, isA<WorkspaceNavigationTreeFailure>());
    final failure = cubit.state as WorkspaceNavigationTreeFailure;
    expect(failure.source, WorkspaceNavigationTreeFailureSource.workspaces);
    expect(failure.workspacesReason, WorkspacesFailureReason.unauthorized);
    expect(failure.statusCode, 401);
  });
}
