import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/domain/models/workspace_summary.dart';
import 'package:devplanner/workspaces/domain/ports/workspaces_gateway.dart';
import 'package:devplanner/workspaces/presentation/cubit/devplanner_workspaces_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Produkcyjny katalog workspace rootu, oparty o lokalny kontrakt backendu.
final class DevPlannerWorkspacesPage extends StatelessWidget {
  const DevPlannerWorkspacesPage({
    required this.gateway,
    this.onOpenWorkspace,
    super.key,
  });

  final WorkspacesGateway? gateway;
  final ValueChanged<String>? onOpenWorkspace;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) {
      final cubit = DevPlannerWorkspacesCubit(gateway: gateway);
      unawaited(cubit.load());
      return cubit;
    },
    child: _DevPlannerWorkspacesView(onOpenWorkspace: onOpenWorkspace),
  );
}

final class _DevPlannerWorkspacesView extends StatelessWidget {
  const _DevPlannerWorkspacesView({this.onOpenWorkspace});

  final ValueChanged<String>? onOpenWorkspace;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocBuilder<DevPlannerWorkspacesCubit, DevPlannerWorkspacesState>(
      builder: (context, state) => switch (state) {
        DevPlannerWorkspacesInitial() || DevPlannerWorkspacesLoading() =>
          const Center(child: CircularProgressIndicator()),
        DevPlannerWorkspacesReady(:final items) =>
          items.isEmpty
              ? _EmptyWorkspaces(onRefresh: _refresh)
              : _WorkspaceGrid(
                  items: items,
                  onOpenWorkspace: onOpenWorkspace,
                ),
        DevPlannerWorkspacesFailure(:final reason, :final statusCode) =>
          _WorkspaceFailure(
            reason: reason,
            statusCode: statusCode,
            onRefresh: _refresh,
          ),
      },
    ),
  );

  void _refresh(BuildContext context) {
    unawaited(context.read<DevPlannerWorkspacesCubit>().load());
  }
}

final class _WorkspaceGrid extends StatelessWidget {
  const _WorkspaceGrid({required this.items, this.onOpenWorkspace});

  final List<WorkspaceSummary> items;
  final ValueChanged<String>? onOpenWorkspace;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 12),
          sliver: SliverToBoxAdapter(
            child: Text(
              l10n.workspacesMenuTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(28),
          sliver: SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 360,
              mainAxisExtent: 150,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  key: ValueKey<String>('workspace-card-${item.id}'),
                  onTap: onOpenWorkspace == null
                      ? null
                      : () => onOpenWorkspace!(item.id),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item.description ?? l10n.workspacesMenuSubtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

final class _EmptyWorkspaces extends StatelessWidget {
  const _EmptyWorkspaces({required this.onRefresh});

  final void Function(BuildContext) onRefresh;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.workspacesEmptyTitle,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(context.l10n.workspacesEmptyMessage),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => onRefresh(context),
          child: Text(context.l10n.workspacesRefresh),
        ),
      ],
    ),
  );
}

final class _WorkspaceFailure extends StatelessWidget {
  const _WorkspaceFailure({
    required this.reason,
    required this.statusCode,
    required this.onRefresh,
  });

  final WorkspacesFailureReason reason;
  final int? statusCode;
  final void Function(BuildContext) onRefresh;

  String _title(BuildContext context) => switch (reason) {
    WorkspacesFailureReason.unauthorized => context.l10n.workspacesSessionTitle,
    WorkspacesFailureReason.forbidden => context.l10n.workspacesForbiddenTitle,
    WorkspacesFailureReason.transportUnavailable =>
      context.l10n.workspacesTransportUnavailableTitle,
    WorkspacesFailureReason.requestFailed ||
    WorkspacesFailureReason.invalidResponse =>
      context.l10n.workspacesErrorTitle,
  };

  String _message(BuildContext context) => switch (reason) {
    WorkspacesFailureReason.unauthorized =>
      context.l10n.workspacesSessionMessage,
    WorkspacesFailureReason.forbidden =>
      context.l10n.workspacesForbiddenMessage,
    WorkspacesFailureReason.transportUnavailable =>
      context.l10n.workspacesTransportUnavailableMessage,
    WorkspacesFailureReason.requestFailed =>
      context.l10n.workspacesRequestFailedMessage,
    WorkspacesFailureReason.invalidResponse =>
      context.l10n.workspacesInvalidResponseMessage,
  };

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              _title(context),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(_message(context), textAlign: TextAlign.center),
            if (statusCode != null) ...[
              const SizedBox(height: 4),
              Text(
                context.l10n.workspacesHttpStatus(statusCode!),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => onRefresh(context),
              child: Text(context.l10n.workspacesRetry),
            ),
          ],
        ),
      ),
    ),
  );
}
