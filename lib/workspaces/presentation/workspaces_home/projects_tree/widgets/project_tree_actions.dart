import 'dart:async';

import 'package:devplanner/workspaces/data/projects/settings/project_settings_composition.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:devplanner/workspaces/presentation/projects/settings/project_settings_modal.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/cubit/projects_tree_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_context_dialogs.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_context_menu.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dostępność akcji menu wynikająca z kompozycji i capabilities serwera.
ProjectMenuAvailability projectMenuAvailability(
  BuildContext context,
  ProjectListItem project,
) {
  final tree = context.read<ProjectsTreeCubit>();
  return ProjectMenuAvailability(
    // Uprawnienia pochodzą z serwera; brak odpowiedzi wyłącza akcje zarządcze
    // zamiast zgadywać je z roli użytkownika.
    capabilities: project.capabilities,
    canMutatePreferences: tree.canMutateProjects,
    canCreateTemplate: tree.canCreateTemplate,
    canOpenSettings: context.read<ProjectSettingsComposition?>() != null,
    canManageLifecycle: tree.canMutateProjects,
  );
}

/// Wykonuje akcję z jednego menu kontekstowego projektu.
///
/// Jedno miejsce obsługuje drzewo, sekcję `Ukryte` i sekcję `Archiwum`, więc
/// żadna akcja nie ma drugiej, rozbieżnej implementacji.
abstract final class ProjectTreeActions {
  /// Obsługuje wybraną akcję menu dla projektu.
  static Future<void> handle(
    BuildContext context, {
    required ProjectContextAction action,
    required ProjectListItem project,
    required String workspaceId,
    required ValueChanged<String> onProjectTap,
  }) async {
    final cubit = context.read<ProjectsTreeCubit>();
    switch (action) {
      case ProjectContextAction.open:
        onProjectTap(_projectTasksPath(workspaceId, project));
      case ProjectContextAction.togglePin:
        cubit.setPinned(project, isPinned: !project.isPinned);
      case ProjectContextAction.hide:
        cubit.setHidden(project, isHidden: true);
      case ProjectContextAction.unhide:
        cubit.setHidden(project, isHidden: false);
      case ProjectContextAction.renameAppearance:
        await openSettings(context, project);
      case ProjectContextAction.settings:
        await openSettings(context, project);
      case ProjectContextAction.createTemplate:
        final name = await ProjectContextDialogs.askTemplateName(
          context: context,
          project: project,
        );
        if (name == null || !context.mounted) return;
        await cubit.createTemplateFromProject(project: project, name: name);
      case ProjectContextAction.archive:
        final confirmed = await ProjectContextDialogs.confirmArchive(
          context: context,
          project: project,
        );
        if (!confirmed || !context.mounted) return;
        cubit.archive(project);
      case ProjectContextAction.restore:
        cubit.restore(project);
      case ProjectContextAction.deletePermanently:
        final confirmed = await ProjectContextDialogs.confirmDeletePermanently(
          context: context,
          project: project,
        );
        if (!confirmed || !context.mounted) return;
        cubit.deletePermanently(project);
      case ProjectContextAction.leaveProject:
        final confirmed = await ProjectContextDialogs.confirmLeave(
          context: context,
          project: project,
        );
        if (!confirmed || !context.mounted) return;
        final left = await cubit.leaveProject(project);
        if (!left || !context.mounted) return;
        // Widoczność projektu Shared dziedziczy się z workspace, więc
        // o jego miejscu w drzewie rozstrzyga świeża lista serwera.
        unawaited(context.read<WorkspaceProjectsCubit>().load(force: true));
      case ProjectContextAction.moveToWorkspace:
        // Pozycja jest wyłączona w menu, bo kontrakt transferu między
        // workspace’ami jeszcze nie istnieje.
        return;
    }
  }

  /// Otwiera centrum ustawień projektu (także dla zmiany nazwy i wyglądu).
  static Future<void> openSettings(
    BuildContext context,
    ProjectListItem project,
  ) async {
    final result = await ProjectSettingsDialogs.show(
      context: context,
      project: project,
    );
    if (!context.mounted) return;
    if (result != null && result.hasChanges) {
      // Reconcile dotyczy wyłącznie katalogu projektów tego workspace’u.
      unawaited(context.read<WorkspaceProjectsCubit>().load(force: true));
    }
  }

  /// Kanoniczna trasa modułu Zadania dla projektu.
  static String _projectTasksPath(
    String workspaceId,
    ProjectListItem project,
  ) => '/workspaces/$workspaceId/projects/${project.id}/tasks';
}
