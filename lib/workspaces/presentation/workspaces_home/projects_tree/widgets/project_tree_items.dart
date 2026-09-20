import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_expansible_navigation_item.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_context_menu.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_menu_groups.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_tree_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Wiersz jednego projektu w drzewie wraz z jego podmenu zasobów.
///
/// Wiersz nie zna stanu preferencji: dostaje je gotowe i woła jedno menu
/// kontekstowe, więc drzewo, sekcja `Ukryte` i sekcja `Archiwum` mają spójne
/// akcje.
class ProjectTreeItemBranch extends StatelessWidget {
  const ProjectTreeItemBranch({
    required this.workspaceId,
    required this.project,
    required this.index,
    required this.reorderable,
    required this.pending,
    required this.onProjectTap,
    required this.onAction,
    required this.onProjectAction,
    this.resourcesRepository,
    super.key,
  });

  /// Identyfikator workspace’u, w którym leży projekt.
  final String workspaceId;

  /// Projekt prezentowany w wierszu.
  final ProjectListItem project;

  /// Pozycja wiersza w liście drzewa (uchwyt DnD).
  final int index;

  /// Czy drzewo może zmieniać kolejność (jest port mutacji).
  final bool reorderable;

  /// Czy trwa zapisywanie zmiany tego projektu.
  final bool pending;

  /// Nawigacja po wejściu w projekt.
  final ValueChanged<String> onProjectTap;

  /// Obsługa tworzenia zasobów projektu (zachowanie istniejącego menu).
  final ProjectMenuActionCallback onAction;

  /// Wybór akcji z menu kontekstowego projektu.
  final void Function(ProjectContextAction action, ProjectListItem project)
  onProjectAction;

  /// Opcjonalne repozytorium zasobów projektu (wstrzykiwane w testach).
  final ProjectResourcesRepository? resourcesRepository;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: GoRouter.of(context).routerDelegate,
      builder: (context, _) {
        final projectPath = '/workspaces/$workspaceId/projects/${project.id}';
        final selected = context.plannerNavigation.currentPath.startsWith(
          projectPath,
        );
        final repo =
            resourcesRepository ?? context.read<ProjectResourcesRepository>();

        return AppExpansibleNavigationItem(
          label: project.name,
          icon: WorkspaceIcons.workflow,
          depth: 1,
          selected: selected,
          hasChildren: true,
          initiallyExpanded: selected,
          onTap: () => onProjectTap('$projectPath/tasks'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (reorderable)
                ReorderableDragStartListener(
                  index: index,
                  child: Tooltip(
                    message: context.l10n.projectsTreeDragHandle,
                    child: Icon(
                      Symbols.drag_indicator_rounded,
                      size: 15,
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ProjectContextMenuButton(
                project: project,
                placement: ProjectMenuPlacement.tree,
                availability: projectMenuAvailability(context, project),
                busy: pending,
                onSelected: (action) => onProjectAction(action, project),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Zadania & Kanban
                ProjectTreeDirectNavLink(
                  label: context.l10n.workspacesSectionTasks,
                  icon: WorkspaceIcons.tasks,
                  path: '$projectPath/tasks',
                ),

                // 2. Whiteboardy (jedyne rozwijane instancje)
                ProjectWhiteboardMenuGroup(
                  workspaceId: workspaceId,
                  projectId: project.id,
                  repository: repo,
                  onAction: onAction,
                ),

                // 3. Tablica korkowa (Corkboard)
                ProjectTreeDirectNavLink(
                  label: context.l10n.workspacesProjectCorkboard,
                  icon: WorkspaceIcons.corkboard,
                  path: '$projectPath/corkboard',
                ),

                // 4. Baza wiedzy (Wiki)
                ProjectTreeDirectNavLink(
                  label: context.l10n.workspacesSectionWiki,
                  icon: WorkspaceIcons.wiki,
                  path: '$projectPath/wiki',
                ),

                // 5. Pliki projektu
                ProjectTreeDirectNavLink(
                  label: context.l10n.workspacesSectionFiles,
                  icon: WorkspaceIcons.file,
                  path: '$projectPath/files',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Bezpośredni link nawigacyjny wewnątrz projektu (bez własnego stanu).
class ProjectTreeDirectNavLink extends StatelessWidget {
  const ProjectTreeDirectNavLink({
    required this.label,
    required this.icon,
    required this.path,
    super.key,
  });

  /// Etykieta z ARB.
  final String label;

  /// Ikona pozycji.
  final IconData icon;

  /// Docelowa trasa projektu.
  final String path;

  @override
  Widget build(BuildContext context) {
    final currentPath = context.plannerNavigation.currentPath;
    final selected = currentPath == path || currentPath.startsWith('$path/');

    return AppExpansibleNavigationItem(
      label: label,
      icon: icon,
      depth: 2,
      selected: selected,
      onTap: () => context.plannerNavigation.go(path),
    );
  }
}
