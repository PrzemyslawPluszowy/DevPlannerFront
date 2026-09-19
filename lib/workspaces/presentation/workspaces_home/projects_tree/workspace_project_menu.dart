import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_expansible_navigation_item.dart';
import 'package:devplanner/shared/presentation/widgets/app_shimmer.dart';
import 'package:devplanner/workspaces/domain/models/project_list_item.dart';
import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_menu_groups.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Leniwie ładowane poddrzewo projektów dla danego workspace’u w menu bocznym.
class WorkspaceProjectMenu extends StatelessWidget {
  const WorkspaceProjectMenu({
    required this.workspaceId,
    required this.onProjectTap,
    this.resourcesRepository,
    this.onAction,
    super.key,
  });

  final String workspaceId;
  final ValueChanged<String> onProjectTap;
  final ProjectResourcesRepository? resourcesRepository;
  final ProjectMenuActionCallback? onAction;

  void _handleAction(
    BuildContext context,
    ProjectMenuAction action,
    String? projectId, [
    FutureOr<void> Function()? onCreated,
  ]) {
    if (onAction case final callback?) {
      callback(action, projectId, onCreated);
      return;
    }
    switch (action) {
      case ProjectMenuAction.createWhiteboard:
        if (projectId != null) {
          unawaited(
            ProjectResourceCreationDialogs.showCreateWhiteboard(
              context,
              workspaceId: workspaceId,
              projectId: projectId,
              onCreated: onCreated,
            ),
          );
        }
      case ProjectMenuAction.createTask:
        if (projectId != null) {
          unawaited(
            ProjectResourceCreationDialogs.showCreateTask(
              context,
              workspaceId: workspaceId,
              projectId: projectId,
            ),
          );
        }
      case ProjectMenuAction.createProject:
        unawaited(
          ProjectResourceCreationDialogs.showCreateProject(
            context,
            workspaceId: workspaceId,
            onCreated: onCreated,
          ),
        );
      case ProjectMenuAction.createWikiPage:
        if (projectId != null) {
          unawaited(
            ProjectResourceCreationDialogs.showCreateWikiPage(
              context,
              workspaceId: workspaceId,
              projectId: projectId,
            ),
          );
        }
      case ProjectMenuAction.addCorkboardCard:
        if (projectId != null) {
          unawaited(
            ProjectResourceCreationDialogs.showCreateCorkboardCard(
              context,
              workspaceId: workspaceId,
              projectId: projectId,
            ),
          );
        }
      case ProjectMenuAction.createFolder || ProjectMenuAction.createFile:
        if (projectId != null) {
          unawaited(
            ProjectResourceCreationDialogs.showCreateFolder(
              context,
              workspaceId: workspaceId,
              projectId: projectId,
            ),
          );
        }
      case ProjectMenuAction.createAutomation:
        final path = '/workspaces/$workspaceId/projects/$projectId/automations';
        onProjectTap(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspaceProjectsCubit, WorkspaceProjectsState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProjectMenuSectionHeader(
              onPressed: () => _handleAction(
                context,
                ProjectMenuAction.createProject,
                null,
                () => context.read<WorkspaceProjectsCubit>().load(force: true),
              ),
            ),
            switch (state) {
              WorkspaceProjectsInitial() ||
              WorkspaceProjectsLoading() => const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    AppShimmerMenuItem(),
                    Gaps.h4,
                    AppShimmerMenuItem(),
                  ],
                ),
              ),
              WorkspaceProjectsFailure(
                :final message,
                :final backendCode,
                :final statusCode,
              ) =>
                _WorkspaceProjectsFailureRow(
                  message: message,
                  backendCode: backendCode,
                  statusCode: statusCode,
                ),
              WorkspaceProjectsEmpty() => _CreateProjectMenuAction(
                onPressed: () => _handleAction(
                  context,
                  ProjectMenuAction.createProject,
                  null,
                  () =>
                      context.read<WorkspaceProjectsCubit>().load(force: true),
                ),
              ),
              WorkspaceProjectsReady(:final items) when items.isEmpty =>
                _CreateProjectMenuAction(
                  onPressed: () => _handleAction(
                    context,
                    ProjectMenuAction.createProject,
                    null,
                    () => context.read<WorkspaceProjectsCubit>().load(
                      force: true,
                    ),
                  ),
                ),
              WorkspaceProjectsReady(:final items) => Column(
                mainAxisSize: MainAxisSize.min,
                children: items
                    .map(
                      (project) => _ProjectItemBranch(
                        workspaceId: workspaceId,
                        project: project,
                        onProjectTap: onProjectTap,
                        resourcesRepository: resourcesRepository,
                        onAction: (action, pId, [onCreated]) =>
                            _handleAction(context, action, pId, onCreated),
                      ),
                    )
                    .toList(),
              ),
            },
          ],
        );
      },
    );
  }
}

class _CreateProjectMenuAction extends StatelessWidget {
  const _CreateProjectMenuAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Align(
    alignment: AlignmentDirectional.centerStart,
    child: TextButton.icon(
      onPressed: onPressed,
      icon: const Icon(WorkspaceIcons.add, size: 14),
      label: Text(context.l10n.workspacesMenuCreateProject),
      style: TextButton.styleFrom(
        visualDensity: VisualDensity.compact,
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    ),
  );
}

class _WorkspaceProjectsFailureRow extends StatelessWidget {
  const _WorkspaceProjectsFailureRow({
    required this.message,
    required this.backendCode,
    required this.statusCode,
  });

  final String? message;
  final String? backendCode;
  final int? statusCode;

  @override
  Widget build(BuildContext context) {
    final displayCode = backendCode ?? statusCode?.toString();
    final displayMessage = message ?? 'Nie udało się pobrać projektów.';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(
            Symbols.error_outline_rounded,
            size: 13,
            color: context.colors.error,
          ),
          Gaps.w4,
          Expanded(
            child: Text(
              displayCode == null
                  ? displayMessage
                  : '$displayMessage (kod: $displayCode)',
              style: context.text.labelSmall?.copyWith(
                color: context.colors.error,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            tooltip: context.l10n.workspacesRetry,
            onPressed: () => unawaited(
              context.read<WorkspaceProjectsCubit>().load(),
            ),
            icon: const Icon(Symbols.refresh_rounded, size: 15),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _ProjectItemBranch extends StatelessWidget {
  const _ProjectItemBranch({
    required this.workspaceId,
    required this.project,
    required this.onProjectTap,
    required this.onAction,
    this.resourcesRepository,
  });

  final String workspaceId;
  final ProjectListItem project;
  final ValueChanged<String> onProjectTap;
  final ProjectResourcesRepository? resourcesRepository;
  final ProjectMenuActionCallback onAction;

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
          body: Padding(
            padding: const EdgeInsetsDirectional.only(start: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Zadania & Kanban
                _ProjectDirectNavLink(
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
                _ProjectDirectNavLink(
                  label: context.l10n.workspacesProjectCorkboard,
                  icon: WorkspaceIcons.corkboard,
                  path: '$projectPath/corkboard',
                ),

                // 4. Baza wiedzy (Wiki)
                _ProjectDirectNavLink(
                  label: context.l10n.workspacesSectionWiki,
                  icon: WorkspaceIcons.wiki,
                  path: '$projectPath/wiki',
                ),

                // 5. Pliki projektu
                _ProjectDirectNavLink(
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

class _ProjectDirectNavLink extends StatelessWidget {
  const _ProjectDirectNavLink({
    required this.label,
    required this.icon,
    required this.path,
  });

  final String label;
  final IconData icon;
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
