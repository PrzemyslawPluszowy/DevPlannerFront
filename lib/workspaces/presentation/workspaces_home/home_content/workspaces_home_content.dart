import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:ready_next/app/router/app_route_paths.dart';
import 'package:ready_next/app/router/app_router.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/shared/presentation/widgets/app_shimmer.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/cubit/workspaces_home_cubit.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/cubit/workspaces_home_state.dart';
import 'package:ready_next/workspaces/presentation/workspaces_home/manage_workspace/create_workspace_dialog.dart';

/// Treść sekcji przeglądu workspace’ów wraz z pełną obsługą stanów API.
class WorkspacesHomeContent extends StatelessWidget {
  /// Tworzy treść sekcji głównej.
  const WorkspacesHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkspacesHomeCubit, WorkspacesHomeState>(
      builder: (context, state) => switch (state) {
        WorkspacesHomeInitial() ||
        WorkspacesHomeLoading() => const AppShimmerContent(),
        WorkspacesHomeEmpty() => _EmptyView(
          onCreate: () => showCreateWorkspaceDialog(context),
          onRetry: context.read<WorkspacesHomeCubit>().load,
        ),
        WorkspacesHomeForbidden(:final message, :final backendCode) =>
          _ErrorView(
            title: context.l10n.workspacesForbiddenTitle,
            message: message,
            backendCode: backendCode,
            onRetry: context.read<WorkspacesHomeCubit>().load,
          ),
        WorkspacesHomeUnauthorized(:final message, :final backendCode) =>
          _ErrorView(
            title: context.l10n.workspacesSessionTitle,
            message: message,
            backendCode: backendCode,
            onRetry: context.read<WorkspacesHomeCubit>().load,
          ),
        WorkspacesHomeFailure(:final message, :final backendCode) => _ErrorView(
          title: context.l10n.workspacesErrorTitle,
          message: message,
          backendCode: backendCode,
          onRetry: context.read<WorkspacesHomeCubit>().load,
        ),
        WorkspacesHomeLoaded() => const _WorkspaceOverviewHub(),
      },
    );
  }
}

/// Elegancki panel startowy po wejściu do modułu Workspaces.
class _WorkspaceOverviewHub extends StatelessWidget {
  const _WorkspaceOverviewHub();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = context.colors;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Padding(
          padding: const .symmetric(
            horizontal: Sizes.p24,
            vertical: Sizes.p32,
          ),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: isDark ? .22 : .12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.primary.withValues(alpha: .35),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  WorkspaceIcons.workspaces,
                  size: 32,
                  color: colors.primary,
                ),
              ),
              Gaps.h20,
              Text(
                'Przestrzenie robocze',
                style: context.text.headlineSmall?.copyWith(
                  fontWeight: .w700,
                  color: colors.onSurface,
                ),
              ),
              Gaps.h8,
              Text(
                'Wybierz przestrzeń roboczą z menu bocznego lub utwórz nową, aby zarządzać projektami, zadaniami i dokumentami.',
                textAlign: TextAlign.center,
                style: context.text.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              Gaps.h24,
              Wrap(
                spacing: Sizes.p12,
                runSpacing: Sizes.p12,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: () =>
                        unawaited(showCreateWorkspaceDialog(context)),
                    icon: const Icon(Symbols.add_rounded, size: 18),
                    label: const Text('Nowy workspace'),
                    style: FilledButton.styleFrom(
                      padding: const .symmetric(
                        horizontal: Sizes.p16,
                        vertical: Sizes.p12,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: .all(.circular(10)),
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.router.navigatePath(
                      AppRoutePaths.meTasks,
                    ),
                    icon: const Icon(Symbols.task_alt_rounded, size: 18),
                    label: const Text('Moje zadania'),
                    style: OutlinedButton.styleFrom(
                      padding: const .symmetric(
                        horizontal: Sizes.p16,
                        vertical: Sizes.p12,
                      ),
                      shape: const RoundedRectangleBorder(
                        borderRadius: .all(.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({
    required this.onCreate,
    required this.onRetry,
  });

  final VoidCallback onCreate;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const .all(Sizes.p24),
          child: Column(
            mainAxisSize: .min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  WorkspaceIcons.workspaces,
                  size: 28,
                  color: context.colors.primary,
                ),
              ),
              Gaps.h16,
              Text(
                context.l10n.workspacesEmptyTitle,
                textAlign: TextAlign.center,
                style: context.text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.h8,
              Text(
                context.l10n.workspacesEmptyMessage,
                textAlign: TextAlign.center,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              Gaps.h20,
              Wrap(
                spacing: Sizes.p8,
                children: [
                  FilledButton.icon(
                    onPressed: onCreate,
                    icon: const Icon(Symbols.add, size: 16),
                    label: Text(context.l10n.workspacesCreateWorkspace),
                  ),
                  OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Symbols.refresh, size: 16),
                    label: Text(context.l10n.workspacesRefresh),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.title,
    required this.message,
    required this.backendCode,
    required this.onRetry,
  });

  final String title;
  final String message;
  final String? backendCode;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const .all(Sizes.p24),
          child: Column(
            mainAxisSize: .min,
            children: [
              Icon(
                Symbols.error_outline_rounded,
                size: 48,
                color: context.colors.error,
              ),
              Gaps.h16,
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.error,
                ),
              ),
              Gaps.h8,
              Text(
                message,
                textAlign: TextAlign.center,
                style: context.text.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              if (backendCode case final code?) ...[
                Gaps.h6,
                Text(
                  'Kod błędu: $code',
                  style: context.text.labelSmall?.copyWith(
                    color: context.colors.onSurfaceVariant.withValues(
                      alpha: .7,
                    ),
                  ),
                ),
              ],
              Gaps.h20,
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Symbols.refresh, size: 16),
                label: Text(context.l10n.workspacesRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
