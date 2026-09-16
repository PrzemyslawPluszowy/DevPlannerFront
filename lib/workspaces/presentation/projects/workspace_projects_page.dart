import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/domain/models/project_list_item.dart';
import 'package:ready_next/workspaces/domain/repositories/projects_repository.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_projects_cubit.dart';
import 'package:ready_next/workspaces/presentation/navigation/cubit/workspace_projects_state.dart';

/// Lista projektów bieżącego workspace’u.
///
/// Jest ładowana dopiero po wejściu w `/workspaces/:workspaceId/projects`;
/// menu korzysta z tego samego Cubita lokalnie dla rozwiniętej gałęzi.
class WorkspaceProjectsPageView extends StatelessWidget {
  const WorkspaceProjectsPageView({required this.workspaceId, super.key});

  final String workspaceId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final cubit = WorkspaceProjectsCubit(
        repository: context.read<ProjectsRepository>(),
        workspaceId: workspaceId,
      );
      unawaited(cubit.load());
      return cubit;
    },
    child: const _ProjectsView(),
  );
}

class _ProjectsView extends StatelessWidget {
  const _ProjectsView();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Sizes.p24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Projekty', style: context.text.headlineSmall),
        Gaps.h4,
        Text(
          'Projekty dostępne w tym workspace’u.',
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        Gaps.h20,
        Expanded(
          child: BlocBuilder<WorkspaceProjectsCubit, WorkspaceProjectsState>(
            builder: (context, state) => switch (state) {
              WorkspaceProjectsInitial() || WorkspaceProjectsLoading() =>
                const Center(child: CircularProgressIndicator()),
              WorkspaceProjectsEmpty() => const _ProjectsMessage(
                icon: WorkspaceIcons.folders,
                title: 'Brak projektów',
                message: 'Utwórz pierwszy projekt, aby rozpocząć pracę.',
              ),
              WorkspaceProjectsFailure(:final message) => _ProjectsMessage(
                icon: Symbols.error_outline,
                title: 'Nie udało się pobrać projektów',
                message: message,
              ),
              WorkspaceProjectsReady(:final items) => _ProjectList(items),
            },
          ),
        ),
      ],
    ),
  );
}

class _ProjectList extends StatelessWidget {
  const _ProjectList(this.items);

  final List<ProjectListItem> items;

  @override
  Widget build(BuildContext context) => ListView.separated(
    itemCount: items.length,
    separatorBuilder: (context, index) => const SizedBox(height: Sizes.p8),
    itemBuilder: (context, index) {
      final item = items[index];
      return Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          dense: true,
          leading: Icon(
            item.visibility.name == 'private'
                ? WorkspaceIcons.privateSpace
                : WorkspaceIcons.workflow,
            color: context.colors.primary,
          ),
          title: Text(item.name),
          subtitle: Text(
            item.description?.trim().isNotEmpty == true
                ? item.description!
                : '${item.visibility.name == 'private' ? 'Prywatny' : 'Wspólny'} · ${item.status.name}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: item.isPinned
              ? Icon(
                  WorkspaceIcons.pin,
                  size: 17,
                  color: context.colors.primary,
                )
              : null,
          onTap: () => unawaited(
            context.router.navigatePath(
              '/workspaces/${item.workspaceId}/projects/${item.id}',
            ),
          ),
        ),
      );
    },
  );
}

class _ProjectsMessage extends StatelessWidget {
  const _ProjectsMessage({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 44, color: context.colors.onSurfaceVariant),
        Gaps.h12,
        Text(title, style: context.text.titleLarge),
        Gaps.h8,
        Text(message, textAlign: TextAlign.center),
      ],
    ),
  );
}
