/// Semantyczne typy pozycji docelowego drzewa nawigacji Workspaces.
///
/// Typy zasobów projektu są kontraktem dla przyszłego adaptera projektów.
/// Nie oznaczają, że dane zasobu są już załadowane.
enum WorkspaceNavigationNodeKind {
  overview,
  personalTasks,
  personalFiles,
  workspace,
  projects,
  project,
  tasks,
  whiteboards,
  corkboard,
  wiki,
  files,
  automations,
}

/// Pozycja drzewa nawigacji niezależna od routingu i widgetów.
final class WorkspaceNavigationNode {
  WorkspaceNavigationNode({
    required this.id,
    required this.kind,
    this.label,
    this.workspaceId,
    this.projectId,
    List<WorkspaceNavigationNode> children = const <WorkspaceNavigationNode>[],
    this.isSelectable = true,
    this.isDataPending = false,
  }) : children = List<WorkspaceNavigationNode>.unmodifiable(children);

  final String id;
  final WorkspaceNavigationNodeKind kind;

  /// Nazwa pochodząca z backendu; pozycje statyczne tłumaczy presentation.
  final String? label;
  final String? workspaceId;
  final String? projectId;
  final List<WorkspaceNavigationNode> children;

  /// Kolekcje zasobów mogą być tylko nagłówkiem strukturalnym.
  final bool isSelectable;

  /// Prawda oznacza, że brakuje jeszcze źródła danych dla tej gałęzi.
  final bool isDataPending;

  bool get hasChildren => children.isNotEmpty || isDataPending;
}
