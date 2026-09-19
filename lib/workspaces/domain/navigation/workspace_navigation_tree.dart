import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';
import 'package:devplanner/workspaces/domain/navigation/workspace_navigation_node.dart';

/// Snapshot drzewa, który może być renderowany przez przyszły shell.
final class WorkspaceNavigationTree {
  WorkspaceNavigationTree._(Iterable<WorkspaceNavigationNode> nodes)
    : nodes = List<WorkspaceNavigationNode>.unmodifiable(nodes);

  /// Buduje tylko pozycje, dla których istnieje lokalny kontrakt danych.
  ///
  /// Workspace’y pochodzą z `GET /api/v1/workspaces/`. Gałąź projektów jest
  /// jawnie oznaczona jako oczekująca na lokalny `ProjectsGateway`; nie
  /// tworzymy zmyślonych projektów ani zasobów.
  factory WorkspaceNavigationTree.fromWorkspaces(
    Iterable<WorkspaceSummary> workspaces,
  ) => _WorkspaceNavigationTreeBuilder(
    workspaces: workspaces,
    projectsByWorkspace: const <String, List<ProjectListItem>>{},
    projectsLoaded: false,
  ).build();

  /// Builds the tree after the projects source has been loaded for each
  /// workspace. The map is keyed by the backend workspace UUID; unknown keys
  /// are ignored so projects can never appear under another workspace node.
  factory WorkspaceNavigationTree.fromWorkspacesWithProjects({
    required Iterable<WorkspaceSummary> workspaces,
    required Map<String, List<ProjectListItem>> projectsByWorkspace,
  }) => _WorkspaceNavigationTreeBuilder(
    workspaces: workspaces,
    projectsByWorkspace: projectsByWorkspace,
    projectsLoaded: true,
  ).build();

  /// Pełna lista zasobów, która musi pozostać osiągalna pod projektem.
  static const projectResourceKinds = <WorkspaceNavigationNodeKind>[
    WorkspaceNavigationNodeKind.tasks,
    WorkspaceNavigationNodeKind.taskList,
    WorkspaceNavigationNodeKind.kanban,
    WorkspaceNavigationNodeKind.whiteboards,
    WorkspaceNavigationNodeKind.corkboard,
    WorkspaceNavigationNodeKind.wiki,
    WorkspaceNavigationNodeKind.files,
    WorkspaceNavigationNodeKind.automations,
  ];

  final List<WorkspaceNavigationNode> nodes;

  Iterable<WorkspaceNavigationNode> get workspaceNodes => nodes.where(
    (node) => node.kind == WorkspaceNavigationNodeKind.workspace,
  );

  bool get hasPendingProjectData => workspaceNodes.any(
    (workspace) => workspace.children.any(
      (node) =>
          node.kind == WorkspaceNavigationNodeKind.projects &&
          node.isDataPending,
    ),
  );

  static int _compareWorkspaces(WorkspaceSummary left, WorkspaceSummary right) {
    if (left.isPinned != right.isPinned) return left.isPinned ? -1 : 1;
    return left.name.toLowerCase().compareTo(right.name.toLowerCase());
  }

  static WorkspaceNavigationNode _workspaceNode(
    WorkspaceSummary workspace, {
    List<ProjectListItem>? projects,
    required bool projectsLoaded,
  }) {
    final hasProjectSource = projectsLoaded && projects != null;
    final projectNodes = projects == null
        ? const <WorkspaceNavigationNode>[]
        : projects.map(_projectNode).toList(growable: false);

    return WorkspaceNavigationNode(
      id: 'workspace:${workspace.id}',
      kind: WorkspaceNavigationNodeKind.workspace,
      label: workspace.name,
      workspaceId: workspace.id,
      children: [
        WorkspaceNavigationNode(
          id: 'workspace:${workspace.id}:files',
          kind: WorkspaceNavigationNodeKind.files,
          workspaceId: workspace.id,
        ),
        WorkspaceNavigationNode(
          id: 'workspace:${workspace.id}:projects',
          kind: WorkspaceNavigationNodeKind.projects,
          workspaceId: workspace.id,
          children: projectNodes,
          isSelectable: false,
          isDataPending: !hasProjectSource,
        ),
      ],
    );
  }

  static WorkspaceNavigationNode _projectNode(
    ProjectListItem project,
  ) => WorkspaceNavigationNode(
    id: 'workspace:${project.workspaceId}:project:${project.id}',
    kind: WorkspaceNavigationNodeKind.project,
    label: project.name,
    workspaceId: project.workspaceId,
    projectId: project.id,
    children: [
      WorkspaceNavigationNode(
        id: 'workspace:${project.workspaceId}:project:${project.id}:tasks',
        kind: WorkspaceNavigationNodeKind.tasks,
        workspaceId: project.workspaceId,
        projectId: project.id,
        isSelectable: false,
        children: [
          WorkspaceNavigationNode(
            id: 'workspace:${project.workspaceId}:project:${project.id}:tasks:list',
            kind: WorkspaceNavigationNodeKind.taskList,
            workspaceId: project.workspaceId,
            projectId: project.id,
          ),
          WorkspaceNavigationNode(
            id: 'workspace:${project.workspaceId}:project:${project.id}:tasks:kanban',
            kind: WorkspaceNavigationNodeKind.kanban,
            workspaceId: project.workspaceId,
            projectId: project.id,
          ),
          WorkspaceNavigationNode(
            id: 'workspace:${project.workspaceId}:project:${project.id}:tasks:automations',
            kind: WorkspaceNavigationNodeKind.automations,
            workspaceId: project.workspaceId,
            projectId: project.id,
            isSelectable: false,
          ),
        ],
      ),
      WorkspaceNavigationNode(
        id: 'workspace:${project.workspaceId}:project:${project.id}:whiteboards',
        kind: WorkspaceNavigationNodeKind.whiteboards,
        workspaceId: project.workspaceId,
        projectId: project.id,
        isSelectable: false,
      ),
      WorkspaceNavigationNode(
        id: 'workspace:${project.workspaceId}:project:${project.id}:corkboard',
        kind: WorkspaceNavigationNodeKind.corkboard,
        workspaceId: project.workspaceId,
        projectId: project.id,
        isSelectable: false,
      ),
      WorkspaceNavigationNode(
        id: 'workspace:${project.workspaceId}:project:${project.id}:wiki',
        kind: WorkspaceNavigationNodeKind.wiki,
        workspaceId: project.workspaceId,
        projectId: project.id,
        isSelectable: false,
      ),
      WorkspaceNavigationNode(
        id: 'workspace:${project.workspaceId}:project:${project.id}:files',
        kind: WorkspaceNavigationNodeKind.files,
        workspaceId: project.workspaceId,
        projectId: project.id,
      ),
    ],
  );
}

final class _WorkspaceNavigationTreeBuilder {
  const _WorkspaceNavigationTreeBuilder({
    required this.workspaces,
    required this.projectsByWorkspace,
    required this.projectsLoaded,
  });

  final Iterable<WorkspaceSummary> workspaces;
  final Map<String, List<ProjectListItem>> projectsByWorkspace;
  final bool projectsLoaded;

  WorkspaceNavigationTree build() {
    final sorted = workspaces.toList(growable: false)
      ..sort(WorkspaceNavigationTree._compareWorkspaces);
    final workspaceNodes = sorted.map(
      (workspace) => WorkspaceNavigationTree._workspaceNode(
        workspace,
        projects: projectsByWorkspace[workspace.id],
        projectsLoaded: projectsLoaded,
      ),
    );
    return WorkspaceNavigationTree._([
      WorkspaceNavigationNode(
        id: 'overview',
        kind: WorkspaceNavigationNodeKind.overview,
      ),
      WorkspaceNavigationNode(
        id: 'personal-tasks',
        kind: WorkspaceNavigationNodeKind.personalTasks,
      ),
      WorkspaceNavigationNode(
        id: 'personal-files',
        kind: WorkspaceNavigationNodeKind.personalFiles,
      ),
      ...workspaceNodes,
    ]);
  }
}
