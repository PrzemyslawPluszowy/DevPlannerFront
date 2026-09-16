import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/domain/storage/models/storage_scope.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';

/// Pasek nawigacji okruszkowej (Breadcrumbs) dla eksploratora plików.
class StorageBreadcrumbs extends StatelessWidget {
  /// Tworzy pasek okruszków.
  const StorageBreadcrumbs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageBrowserCubit, StorageBrowserState>(
      buildWhen: (prev, curr) =>
          prev.runtimeType != curr.runtimeType ||
          _extractBreadcrumbs(prev) != _extractBreadcrumbs(curr),
      builder: (context, state) {
        final breadcrumbs = _extractBreadcrumbs(state);
        final scope = _extractScope(state);
        if (breadcrumbs.isEmpty) {
          return const SizedBox.shrink();
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < breadcrumbs.length; i++) ...[
                if (i > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      AppIcons.chevronRight,
                      size: 14,
                      color: context.colors.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                _BreadcrumbChip(
                  item: breadcrumbs[i],
                  displayName: breadcrumbs[i].folderId == null && scope != null
                      ? _rootName(context, scope)
                      : breadcrumbs[i].name,
                  isLast: i == breadcrumbs.length - 1,
                  onTap: () => context
                      .read<StorageBrowserCubit>()
                      .navigateToBreadcrumb(breadcrumbs[i]),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  List<StorageBreadcrumbItem> _extractBreadcrumbs(StorageBrowserState state) =>
      switch (state) {
        StorageBrowserReady(:final breadcrumbs) => breadcrumbs,
        StorageBrowserEmpty(:final breadcrumbs) => breadcrumbs,
        StorageBrowserLoading(:final breadcrumbs) => breadcrumbs,
        _ => const [],
      };

  StorageScope? _extractScope(StorageBrowserState state) => switch (state) {
    StorageBrowserInitial(:final scope) ||
    StorageBrowserLoading(:final scope) ||
    StorageBrowserReady(:final scope) ||
    StorageBrowserEmpty(:final scope) ||
    StorageBrowserFailure(:final scope) ||
    StorageBrowserForbidden(:final scope) => scope,
  };

  String _rootName(BuildContext context, StorageScope scope) => switch (scope) {
    StoragePersonalScope() => context.l10n.storageMyFiles,
    StorageSharedScope() => context.l10n.storageSharedWithMe,
    StorageRecentScope() => context.l10n.storageRecent,
    StorageFavoritesScope() => context.l10n.storageFavorites,
    StorageTrashScope() => context.l10n.storageTrash,
    StorageWorkspaceScope() => context.l10n.storageWorkspaceFilesTitle,
    StorageProjectScope() => context.l10n.storageProjectFilesTitle,
    StorageResourceScope() => context.l10n.storageAttachmentsTitle,
  };
}

class _BreadcrumbChip extends StatelessWidget {
  const _BreadcrumbChip({
    required this.item,
    required this.displayName,
    required this.isLast,
    required this.onTap,
  });

  final StorageBreadcrumbItem item;
  final String displayName;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = isLast
        ? context.text.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colors.onSurface,
          )
        : context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          );

    return InkWell(
      onTap: isLast ? null : onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.folderId == null) ...[
              Icon(
                AppIcons.folder,
                size: 16,
                color: isLast
                    ? theme.colorScheme.primary
                    : context.colors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              displayName,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
