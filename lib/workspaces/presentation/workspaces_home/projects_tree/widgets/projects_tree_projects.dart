import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/cubit/projects_tree_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_context_menu.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_menu_groups.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_tree_actions.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_tree_items.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/projects_tree_project_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Lista projektów drzewa wraz z sekcjami `Ukryte` i `Archiwum`.
///
/// DnD pracuje na pełnej liście widocznych projektów, bo takiego payloadu
/// wymaga backend; sekcja przypięta jest zawsze na górze, więc przeciągnięcie
/// między sekcjami wraca do porządku przypiętych.
class ProjectsTreeProjectsList extends StatelessWidget {
  const ProjectsTreeProjectsList({
    required this.workspaceId,
    required this.onProjectTap,
    required this.onAction,
    this.resourcesRepository,
    super.key,
  });

  /// Identyfikator workspace’u, którego projekty renderuje lista.
  final String workspaceId;

  /// Nawigacja po wybraniu projektu albo jego zasobu.
  final ValueChanged<String> onProjectTap;

  /// Obsługa akcji tworzenia zasobów projektu.
  final ProjectMenuActionCallback onAction;

  /// Opcjonalne repozytorium zasobów projektu (wstrzykiwane w testach).
  final ProjectResourcesRepository? resourcesRepository;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProjectsTreeCubit, ProjectsTreeState>(
      builder: (context, state) {
        final cubit = context.read<ProjectsTreeCubit>();
        final visible = state.visible;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (visible.isNotEmpty)
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                buildDefaultDragHandles: false,
                onReorderItem: (oldIndex, newIndex) =>
                    _reorder(context, visible, oldIndex, newIndex),
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final project = visible[index];
                  return KeyedSubtree(
                    key: ValueKey<String>(project.id),
                    child: ProjectTreeItemBranch(
                      workspaceId: workspaceId,
                      project: project,
                      index: index,
                      reorderable: cubit.canMutateProjects,
                      pending: state.pendingProjectIds.contains(project.id),
                      onProjectTap: onProjectTap,
                      resourcesRepository: resourcesRepository,
                      onAction: onAction,
                      onProjectAction: (action, target) =>
                          ProjectTreeActions.handle(
                            context,
                            action: action,
                            project: target,
                            workspaceId: workspaceId,
                            onProjectTap: onProjectTap,
                          ),
                    ),
                  );
                },
              ),
            ProjectsTreeProjectSection(
              title: l10n.projectsTreeHiddenSectionTitle,
              icon: Symbols.visibility_off_rounded,
              projects: state.hidden,
              placement: ProjectMenuPlacement.hiddenSection,
              availabilityFor: (project) =>
                  projectMenuAvailability(context, project),
              pendingProjectIds: state.pendingProjectIds,
              onOpen: (project) => _openProject(project, onProjectTap),
              onAction: (action, project) => ProjectTreeActions.handle(
                context,
                action: action,
                project: project,
                workspaceId: workspaceId,
                onProjectTap: onProjectTap,
              ),
            ),
            ProjectsTreeProjectSection(
              title: l10n.projectsTreeArchiveSectionTitle,
              icon: Symbols.archive_rounded,
              note: l10n.projectsTreeArchiveSectionNote,
              projects: state.archived,
              placement: ProjectMenuPlacement.archiveSection,
              availabilityFor: (project) =>
                  projectMenuAvailability(context, project),
              pendingProjectIds: state.pendingProjectIds,
              onOpen: (project) => _openProject(project, onProjectTap),
              onAction: (action, project) => ProjectTreeActions.handle(
                context,
                action: action,
                project: project,
                workspaceId: workspaceId,
                onProjectTap: onProjectTap,
              ),
            ),
          ],
        );
      },
    );
  }

  void _openProject(
    ProjectListItem project,
    ValueChanged<String> onProjectTap,
  ) => onProjectTap('/workspaces/$workspaceId/projects/${project.id}/tasks');

  void _reorder(
    BuildContext context,
    List<ProjectListItem> visible,
    int oldIndex,
    int newIndex,
  ) {
    if (oldIndex < 0 || oldIndex >= visible.length) return;
    if (newIndex < 0 || newIndex > visible.length) return;
    final ids = visible.map((project) => project.id).toList();
    final moved = ids.removeAt(oldIndex);
    ids.insert(newIndex.clamp(0, ids.length), moved);
    // Backend wymaga pełnej listy widocznych projektów; `ids` zawsze nią jest,
    // bo powstała z bieżącego stanu drzewa.
    context.read<ProjectsTreeCubit>().reorderVisible(ids);
  }
}
