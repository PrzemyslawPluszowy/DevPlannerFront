import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/domain/models/project_resource_list_item.dart';
import 'package:ready_next/workspaces/domain/repositories/project_resources_repository.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/project_resources_cubit.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/project_resources_state.dart';
import 'package:ready_next/workspaces/shared/presentation/widgets/workspace_feature_wrapper.dart';

/// Backendowy katalog zasobu projektu używany przez sekcje menu.
///
/// Katalog pobiera wyłącznie metadane potrzebne do nawigacji. Szczegółowy
/// ekran elementu jest osobną trasą, więc wejście do menu nie pobiera
/// snapshotów whiteboardu, treści Wiki ani plików binarnych.
class WorkspaceProjectResourceCatalogPage extends StatelessWidget {
  const WorkspaceProjectResourceCatalogPage({
    required this.workspaceId,
    required this.projectId,
    required this.kind,
    super.key,
  });

  final String workspaceId;
  final String projectId;
  final ProjectResourceKind kind;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = ProjectResourcesCubit(
        repository: context.read<ProjectResourcesRepository>(),
        workspaceId: workspaceId,
        projectId: projectId,
        kind: kind,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: _CatalogView(
      workspaceId: workspaceId,
      projectId: projectId,
      kind: kind,
    ),
  );
}

class _CatalogView extends StatelessWidget {
  const _CatalogView({
    required this.workspaceId,
    required this.projectId,
    required this.kind,
  });

  final String workspaceId;
  final String projectId;
  final ProjectResourceKind kind;

  String get _title => switch (kind) {
    ProjectResourceKind.tasks => 'Zadania',
    ProjectResourceKind.whiteboards => 'Whiteboardy',
    ProjectResourceKind.wiki => 'Wiki',
    ProjectResourceKind.files => 'Pliki',
    ProjectResourceKind.automations => 'Automatyzacje',
  };

  IconData get _icon => switch (kind) {
    ProjectResourceKind.tasks => WorkspaceIcons.tasks,
    ProjectResourceKind.whiteboards => WorkspaceIcons.whiteboard,
    ProjectResourceKind.wiki => WorkspaceIcons.wiki,
    ProjectResourceKind.files => WorkspaceIcons.file,
    ProjectResourceKind.automations => WorkspaceIcons.automations,
  };

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ProjectResourcesCubit, ProjectResourcesState>(
        builder: (context, state) => WorkspaceFeatureWrapper(
          title: _title,
          icon: _icon,
          subtitle: 'Katalog zasobów projektu',
          isLoading:
              state is ProjectResourcesInitial ||
              state is ProjectResourcesLoading,
          isEmpty: state is ProjectResourcesEmpty,
          emptyTitle: 'Brak elementów',
          emptyMessage: 'Backend nie zwrócił jeszcze elementów w tym katalogu.',
          errorMessage: switch (state) {
            ProjectResourcesFailure(:final message, :final backendCode) =>
              backendCode == null ? message : '$message (kod: $backendCode)',
            _ => null,
          },
          onRetry: () =>
              unawaited(context.read<ProjectResourcesCubit>().load()),
          scrollable: false,
          padding: EdgeInsets.zero,
          child: switch (state) {
            ProjectResourcesReady(:final items) => ListView.separated(
              padding: const EdgeInsets.all(Sizes.p16),
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) => _ResourceRow(
                item: items[index],
                collectionTitle: _title,
                workspaceId: workspaceId,
                projectId: projectId,
              ),
            ),
            _ => const SizedBox.shrink(),
          },
        ),
      );
}

class _ResourceRow extends StatelessWidget {
  const _ResourceRow({
    required this.item,
    required this.collectionTitle,
    required this.workspaceId,
    required this.projectId,
  });

  final ProjectResourceListItem item;
  final String collectionTitle;
  final String workspaceId;
  final String projectId;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(
      item.kind == ProjectResourceKind.tasks
          ? WorkspaceIcons.tasks
          : item.kind == ProjectResourceKind.wiki
          ? WorkspaceIcons.wiki
          : item.kind == ProjectResourceKind.files
          ? WorkspaceIcons.file
          : item.kind == ProjectResourceKind.automations
          ? WorkspaceIcons.automations
          : WorkspaceIcons.whiteboard,
    ),
    title: Text(item.title),
    subtitle: Text(
      item.isVerified ? '$collectionTitle · zweryfikowano' : collectionTitle,
    ),
    trailing: const Icon(Symbols.chevron_right),
    onTap: () => context.router.navigatePath(
      '/workspaces/$workspaceId/projects/$projectId/${item.kind.name}/${item.id}',
    ),
  );
}
