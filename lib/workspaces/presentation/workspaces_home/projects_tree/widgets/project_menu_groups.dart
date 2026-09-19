import 'dart:async';

import 'package:devplanner/app/router/devplanner_navigation.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_expansible_navigation_item.dart';
import 'package:devplanner/shared/presentation/widgets/app_shimmer.dart';
import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/project_resources_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/project_resources_state.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_resource_menu_branch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef ProjectMenuActionCallback = void Function(
  ProjectMenuAction action,
  String? projectId, [
  FutureOr<void> Function()? onCreated,
]);

/// Nagłówek sekcji projektów z przyciskiem szybkiego tworzenia nowego projektu.
class ProjectMenuSectionHeader extends StatelessWidget {
  const ProjectMenuSectionHeader({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => AppExpansibleNavigationItem(
    label: context.l10n.workspaceShellProjects,
    icon: WorkspaceIcons.folders,
    trailing: IconButton(
      tooltip: context.l10n.workspacesMenuCreateProject,
      onPressed: onPressed,
      icon: const Icon(WorkspaceIcons.add, size: 15),
      visualDensity: VisualDensity.compact,
    ),
  );
}

/// Rozwijana grupa tablic Whiteboard projektu z listą utworzonych tablic i akcją dodawania nowej.
class ProjectWhiteboardMenuGroup extends StatelessWidget {
  const ProjectWhiteboardMenuGroup({
    required this.workspaceId,
    required this.projectId,
    required this.repository,
    required this.onAction,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final ProjectResourcesRepository repository;
  final ProjectMenuActionCallback onAction;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) {
      final cubit = ProjectResourcesCubit(
        workspaceId: workspaceId,
        projectId: projectId,
        kind: ProjectResourceKind.whiteboards,
        repository: repository,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: BlocBuilder<ProjectResourcesCubit, ProjectResourcesState>(
      builder: (context, state) {
        final content = switch (state) {
          ProjectResourcesInitial() ||
          ProjectResourcesLoading() => const Padding(
            padding: EdgeInsets.only(left: 20, top: 2),
            child: AppShimmerMenuItem(),
          ),
          ProjectResourcesFailure(:final message) => _MenuInlineMessage(
            message: message,
            isError: true,
          ),
          ProjectResourcesEmpty() => _MenuEmptyAction(
            label: context.l10n.workspacesMenuCreateWhiteboard,
            onPressed: () => onAction(
              ProjectMenuAction.createWhiteboard,
              projectId,
              context.read<ProjectResourcesCubit>().reload,
            ),
          ),
          ProjectResourcesReady(:final items) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final item in items)
                ProjectResourceMenuBranch(
                  resource: item,
                  workspaceId: workspaceId,
                  projectId: projectId,
                ),
              _MenuAddMoreAction(
                label: context.l10n.workspacesMenuAddAnotherWhiteboard,
                onPressed: () => onAction(
                  ProjectMenuAction.createWhiteboard,
                  projectId,
                  context.read<ProjectResourcesCubit>().reload,
                ),
              ),
            ],
          ),
        };

        final path = '/workspaces/$workspaceId/projects/$projectId/whiteboards';
        final selected = context.plannerNavigation.currentPath.startsWith(path);

        return AppExpansibleNavigationItem(
          label: context.l10n.workspacesSectionWhiteboards,
          icon: WorkspaceIcons.whiteboard,
          depth: 2,
          selected: selected,
          hasChildren: true,
          initiallyExpanded: selected,
          body: content,
        );
      },
    ),
  );
}

class _MenuEmptyAction extends StatelessWidget {
  const _MenuEmptyAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(start: 36, top: 2, bottom: 4),
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(WorkspaceIcons.add, size: 13),
        label: Text(
          label,
          style: context.text.labelSmall?.copyWith(
            fontSize: 11,
            color: context.colors.primary,
          ),
        ),
        style: TextButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        ),
      ),
    ),
  );
}

class _MenuAddMoreAction extends StatelessWidget {
  const _MenuAddMoreAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(start: 36, top: 2, bottom: 4),
    child: Align(
      alignment: AlignmentDirectional.centerStart,
      child: InkWell(
        onTap: onPressed,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(WorkspaceIcons.add, size: 12, color: context.colors.primary),
              const SizedBox(width: 4),
              Text(
                label,
                style: context.text.labelSmall?.copyWith(
                  fontSize: 10.5,
                  color: context.colors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _MenuInlineMessage extends StatelessWidget {
  const _MenuInlineMessage({required this.message, required this.isError});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(start: 48, top: 4, bottom: 4),
    child: Text(
      message,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: context.text.labelSmall?.copyWith(
        color: isError ? context.colors.error : context.colors.onSurfaceVariant,
      ),
    ),
  );
}
