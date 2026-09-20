import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/shared/presentation/widgets/app_shimmer.dart';
import 'package:devplanner/workspaces/domain/models/project_resource_list_item.dart';
import 'package:devplanner/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/project_templates_repository.dart';
import 'package:devplanner/workspaces/domain/repositories/projects_repository.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:devplanner/workspaces/presentation/navigation/cubit/workspace_projects_state.dart';
import 'package:devplanner/workspaces/presentation/projects/dialogs/project_resource_creation_dialogs.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/cubit/projects_tree_cubit.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/project_menu_groups.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/projects_tree_failure_banner.dart';
import 'package:devplanner/workspaces/presentation/workspaces_home/projects_tree/widgets/projects_tree_projects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Leniwie ładowane poddrzewo projektów dla danego workspace’u w menu bocznym.
///
/// Drzewo ma jedno menu kontekstowe projektu (`ProjectContextMenuButton`) i
/// jednego właściciela stanu preferencji (`ProjectsTreeCubit`, tworzonego tutaj
/// i zwalnianego razem z widgetem). Porty mutacji są opcjonalne: bez nich
/// drzewo nadal czyta projekty, ale akcje zapisu są jawnie wyłączone z powodem
/// zamiast udawać działanie.
///
/// Sekcje `Ukryte` i `Archiwum` są pobierane z serwera razem z listą aktywnych,
/// więc pokazują projekty potwierdzone przez backend, a nie tylko efekt
/// operacji wykonanych w tej sesji.
class WorkspaceProjectMenu extends StatelessWidget {
  const WorkspaceProjectMenu({
    required this.workspaceId,
    required this.onProjectTap,
    this.resourcesRepository,
    this.onAction,
    this.projectsRepository,
    this.templatesRepository,
    super.key,
  });

  /// Identyfikator workspace’u, którego projekty renderuje menu.
  final String workspaceId;

  /// Nawigacja po wybraniu projektu albo jego zasobu.
  final ValueChanged<String> onProjectTap;

  /// Opcjonalne repozytorium zasobów projektu (wstrzykiwane w testach).
  final ProjectResourcesRepository? resourcesRepository;

  /// Opcjonalna obsługa akcji tworzenia zasobów.
  final ProjectMenuActionCallback? onAction;

  /// Port mutacji projektów (pin, hide, kolejność, lifecycle).
  final ProjectsRepository? projectsRepository;

  /// Port szablonów projektów.
  final ProjectTemplatesRepository? templatesRepository;

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

  void _createProject(BuildContext context) => _handleAction(
    context,
    ProjectMenuAction.createProject,
    null,
    () => context.read<WorkspaceProjectsCubit>().load(force: true),
  );

  /// Pobiera z serwera sekcje `Ukryte` i `Archiwum`.
  ///
  /// Wywoływane razem z listą aktywnych; drzewo bez portu mutacji nie udaje
  /// danych, których nie może pobrać.
  void _loadServerSections(
    ProjectsTreeCubit cubit,
    WorkspaceProjectsState state,
  ) {
    if (state is WorkspaceProjectsFailure) return;
    if (!cubit.canMutateProjects) return;
    unawaited(cubit.refreshServerSections());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectsTreeCubit>(
      create: (context) {
        final cubit = ProjectsTreeCubit(
          workspaceId: workspaceId,
          mutations: projectsRepository ?? context.read<ProjectsRepository?>(),
          templates:
              templatesRepository ??
              context.read<ProjectTemplatesRepository?>(),
        );
        final projectsState = context.read<WorkspaceProjectsCubit>().state;
        if (projectsState is WorkspaceProjectsReady) {
          cubit.syncFromServer(projectsState.items);
        }
        _loadServerSections(cubit, projectsState);
        return cubit;
      },
      child: BlocListener<WorkspaceProjectsCubit, WorkspaceProjectsState>(
        listenWhen: (_, state) =>
            state is WorkspaceProjectsReady || state is WorkspaceProjectsEmpty,
        listener: (context, state) {
          final cubit = context.read<ProjectsTreeCubit>();
          if (state is WorkspaceProjectsReady) {
            cubit.syncFromServer(state.items);
          }
          // Sekcje `Ukryte` i `Archiwum` są niezależne od listy aktywnych:
          // workspace bez aktywnych projektów nadal może mieć archiwum.
          _loadServerSections(cubit, state);
        },
        child: BlocListener<ProjectsTreeCubit, ProjectsTreeState>(
          listenWhen: (previous, next) =>
              next.notice != null && next.notice!.id != previous.notice?.id,
          listener: (context, state) => _showNotice(context, state.notice!),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProjectMenuSectionHeader(
                onPressed: () => _createProject(context),
              ),
              const _ProjectsTreeFailureHost(),
              BlocBuilder<WorkspaceProjectsCubit, WorkspaceProjectsState>(
                builder: (context, state) => switch (state) {
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
                  WorkspaceProjectsEmpty() => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CreateProjectMenuAction(
                        onPressed: () => _createProject(context),
                      ),
                      // Pusty stan listy aktywnych nie oznacza pustego
                      // archiwum — sekcje nadal mogą mieć treść z serwera.
                      ProjectsTreeProjectsList(
                        workspaceId: workspaceId,
                        onProjectTap: onProjectTap,
                        resourcesRepository: resourcesRepository,
                        onAction: (action, projectId, [onCreated]) =>
                            _handleAction(
                              context,
                              action,
                              projectId,
                              onCreated,
                            ),
                      ),
                    ],
                  ),
                  WorkspaceProjectsReady(:final items) when items.isEmpty =>
                    _CreateProjectMenuAction(
                      onPressed: () => _createProject(context),
                    ),
                  WorkspaceProjectsReady() => ProjectsTreeProjectsList(
                    workspaceId: workspaceId,
                    onProjectTap: onProjectTap,
                    resourcesRepository: resourcesRepository,
                    onAction: (action, projectId, [onCreated]) =>
                        _handleAction(context, action, projectId, onCreated),
                  ),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotice(BuildContext context, ProjectsTreeNotice notice) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    final cubit = context.read<ProjectsTreeCubit>();
    final l10n = context.l10n;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(_noticeMessage(l10n, notice)),
          behavior: SnackBarBehavior.floating,
          action: notice.canUndo
              ? SnackBarAction(
                  label: l10n.projectsNoticeUndo,
                  onPressed: cubit.undoLastNotice,
                )
              : null,
        ),
      );
  }
}

String _noticeMessage(AppLocalizations l10n, ProjectsTreeNotice notice) =>
    switch (notice.kind) {
      ProjectsTreeNoticeKind.pinned => l10n.projectsNoticePinned(
        notice.projectName,
      ),
      ProjectsTreeNoticeKind.unpinned => l10n.projectsNoticeUnpinned(
        notice.projectName,
      ),
      ProjectsTreeNoticeKind.hidden => l10n.projectsNoticeHidden(
        notice.projectName,
      ),
      ProjectsTreeNoticeKind.unhidden => l10n.projectsNoticeUnhidden(
        notice.projectName,
      ),
      ProjectsTreeNoticeKind.archived => l10n.projectsNoticeArchived(
        notice.projectName,
      ),
      ProjectsTreeNoticeKind.restored => l10n.projectsNoticeRestored(
        notice.projectName,
      ),
      ProjectsTreeNoticeKind.deleted => l10n.projectsNoticeDeleted(
        notice.projectName,
      ),
      ProjectsTreeNoticeKind.left => l10n.projectsNoticeLeft(
        notice.projectName,
      ),
      ProjectsTreeNoticeKind.templateCreated =>
        l10n.projectsNoticeTemplateCreated(notice.projectName),
    };

/// Trwały komunikat ostatniej nieudanej operacji na projektach.
class _ProjectsTreeFailureHost extends StatelessWidget {
  const _ProjectsTreeFailureHost();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ProjectsTreeCubit, ProjectsTreeState>(
        buildWhen: (previous, next) => previous.failure != next.failure,
        builder: (context, state) {
          final failure = state.failure;
          if (failure == null) return const SizedBox.shrink();
          final cubit = context.read<ProjectsTreeCubit>();
          return ProjectsTreeFailureBanner(
            failure: failure,
            onRetry: failure.retry == null ? null : cubit.retryFailure,
            onDismiss: cubit.dismissFailure,
          );
        },
      );
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
    final displayMessage =
        message ?? context.l10n.projectsTreeLoadFailureFallback;
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
