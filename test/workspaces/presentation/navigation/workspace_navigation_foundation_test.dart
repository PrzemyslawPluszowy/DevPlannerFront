import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';
import 'package:devplanner/workspaces/domain/navigation/workspace_navigation_node.dart';
import 'package:devplanner/workspaces/domain/navigation/workspace_navigation_tree.dart';
import 'package:devplanner/workspaces/domain/ports/workspace_navigation_gateway.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_navigation_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_navigation_state.dart';
import 'package:flutter_test/flutter_test.dart';

final class _Gateway implements WorkspaceNavigationGateway {
  _Gateway(this.result);

  final Future<List<WorkspaceSummary>> result;

  @override
  Future<List<WorkspaceSummary>> listWorkspaces() => result;
}

void main() {
  test('tree sorts pinned workspaces and keeps project source pending', () {
    final tree = WorkspaceNavigationTree.fromWorkspaces([
      const WorkspaceSummary(
        id: 'team',
        name: 'Zespół',
        isPinned: false,
        isHidden: false,
        isOwner: false,
      ),
      const WorkspaceSummary(
        id: 'personal',
        name: 'Osobiste',
        isPinned: true,
        isHidden: false,
        isOwner: true,
      ),
    ]);

    expect(tree.nodes[0].kind, WorkspaceNavigationNodeKind.personalTasks);
    expect(
      tree.nodes.map((node) => node.kind),
      isNot(contains(WorkspaceNavigationNodeKind.overview)),
    );
    expect(
      tree.workspaceNodes.map((node) => node.workspaceId),
      ['personal', 'team'],
    );
    expect(tree.hasPendingProjectData, isTrue);
    expect(
      tree.workspaceNodes.first.children
          .firstWhere(
            (node) => node.kind == WorkspaceNavigationNodeKind.projects,
          )
          .isDataPending,
      isTrue,
    );
    // Jeden moduł Zadania: drzewo deklaruje jedną pozycję projektu, a nie
    // osobną Listę i Kanban, które sugerowałyby dwa źródła danych.
    expect(
      WorkspaceNavigationTree.projectResourceKinds,
      [
        WorkspaceNavigationNodeKind.tasks,
        WorkspaceNavigationNodeKind.files,
      ],
    );
    // Pozycje bez aktywnych tras nie są renderowane jako funkcje.
    expect(
      tree.workspaceNodes
          .expand((workspace) => workspace.children)
          .expand((node) => node.children)
          .expand((node) => node.children)
          .map((node) => node.kind),
      isNot(contains(WorkspaceNavigationNodeKind.automations)),
    );
    expect(
      WorkspaceNavigationTree.projectResourceKinds,
      contains(WorkspaceNavigationNodeKind.files),
    );
  });

  test('cubit builds a ready tree from the local workspace port', () async {
    final cubit = WorkspaceNavigationCubit(
      gateway: _Gateway(
        Future.value([
          const WorkspaceSummary(
            id: 'workspace-1',
            name: 'DevPlanner',
            isPinned: false,
            isHidden: false,
            isOwner: true,
          ),
        ]),
      ),
    );
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state, isA<WorkspaceNavigationReady>());
    final ready = cubit.state as WorkspaceNavigationReady;
    expect(ready.tree.workspaceNodes.single.label, 'DevPlanner');
  });

  test('cubit preserves typed workspace gateway failures', () async {
    final cubit = WorkspaceNavigationCubit(
      gateway: _Gateway(
        Future<List<WorkspaceSummary>>.error(
          const WorkspacesGatewayException(
            reason: WorkspacesFailureReason.unauthorized,
            statusCode: 401,
            backendCode: 'auth.required',
          ),
        ),
      ),
    );
    addTearDown(cubit.close);

    await cubit.load();

    expect(cubit.state, isA<WorkspaceNavigationFailure>());
    final failure = cubit.state as WorkspaceNavigationFailure;
    expect(failure.reason, WorkspacesFailureReason.unauthorized);
    expect(failure.statusCode, 401);
    expect(failure.backendCode, 'auth.required');
  });
}
