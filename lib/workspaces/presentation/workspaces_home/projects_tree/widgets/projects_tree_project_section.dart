import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/widgets/app_expansible_navigation_item.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_context_menu.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Sekcja drzewa z projektami poza główną listą (`Ukryte`, `Archiwum`).
///
/// Sekcja nie ładuje danych: dostaje projekty znane z operacji użytkownika i
/// wystawia dokładnie to samo menu kontekstowe co drzewo, z pozycjami
/// właściwymi dla swojego miejsca.
class ProjectsTreeProjectSection extends StatelessWidget {
  const ProjectsTreeProjectSection({
    required this.title,
    required this.icon,
    required this.projects,
    required this.placement,
    required this.availabilityFor,
    required this.onOpen,
    required this.onAction,
    this.note,
    this.pendingProjectIds = const <String>{},
    super.key,
  });

  /// Nagłówek sekcji z ARB.
  final String title;

  /// Ikona nagłówka sekcji.
  final IconData icon;

  /// Projekty w sekcji.
  final List<ProjectListItem> projects;

  /// Miejsce menu kontekstowego dla wierszy sekcji.
  final ProjectMenuPlacement placement;

  /// Dostępność akcji liczona per projekt (rola w projekcie bywa różna).
  final ProjectMenuAvailability Function(ProjectListItem project)
  availabilityFor;

  /// Otwarcie projektu w drzewie.
  final ValueChanged<ProjectListItem> onOpen;

  /// Wybór akcji z menu wiersza.
  final void Function(ProjectContextAction action, ProjectListItem project)
  onAction;

  /// Opcjonalna nota pod nagłówkiem (np. zakres danych sekcji).
  final String? note;

  /// Identyfikatory projektów z mutacją w locie.
  final Set<String> pendingProjectIds;

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) return const SizedBox.shrink();

    return AppExpansibleNavigationItem(
      label: title,
      icon: icon,
      depth: 1,
      hasChildren: true,
      // Sekcja istnieje tylko wtedy, gdy ma treść (np. po ukryciu projektu),
      // więc otwiera się od razu i pokazuje skutek operacji użytkownika.
      initiallyExpanded: true,
      badgeCount: projects.length,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note case final note?)
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 28,
                end: 12,
                bottom: 4,
              ),
              child: Text(
                note,
                style: context.text.labelSmall?.copyWith(
                  fontSize: 10.5,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          for (final project in projects)
            AppExpansibleNavigationItem(
              label: project.name,
              icon: Symbols.folder_rounded,
              depth: 2,
              onTap: () => onOpen(project),
              trailing: ProjectContextMenuButton(
                project: project,
                placement: placement,
                availability: availabilityFor(project),
                busy: pendingProjectIds.contains(project.id),
                onSelected: (action) => onAction(action, project),
              ),
            ),
        ],
      ),
    );
  }
}
