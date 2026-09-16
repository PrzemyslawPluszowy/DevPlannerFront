import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';

/// Pusty stan bieżącego katalogu.
final class StorageEmptyView extends StatelessWidget {
  const StorageEmptyView({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          AppIcons.folder,
          size: 48,
          color: context.colors.onSurfaceVariant.withValues(alpha: 0.5),
        ),
        const SizedBox(height: 12),
        Text(
          context.l10n.storageEmptyTitle,
          style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          context.l10n.storageEmptySubtitle,
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    ),
  );
}

/// Stan błędu listowania z możliwością ponowienia.
final class StorageErrorView extends StatelessWidget {
  const StorageErrorView({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AppIcons.alertCircle, size: 48, color: context.colors.error),
        const SizedBox(height: 12),
        Text(context.l10n.storageErrorTitle, style: context.text.titleSmall),
        const SizedBox(height: 4),
        Text(message, style: TextStyle(color: context.colors.error)),
        const SizedBox(height: 12),
        FilledButton.icon(
          icon: const Icon(AppIcons.refresh, size: 16),
          label: Text(context.l10n.retry),
          onPressed: () => context.read<StorageBrowserCubit>().load(),
        ),
        if (context.read<StorageBrowserCubit>().currentScope.folderId != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton.icon(
              icon: const Icon(Icons.arrow_back, size: 16),
              label: Text(MaterialLocalizations.of(context).backButtonTooltip),
              onPressed: () =>
                  unawaited(context.read<StorageBrowserCubit>().navigateUp()),
            ),
          ),
      ],
    ),
  );
}

/// Jawny stan braku dostępu do zakresu Storage.
final class StorageForbiddenView extends StatelessWidget {
  const StorageForbiddenView({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AppIcons.lock, size: 48, color: context.colors.error),
        const SizedBox(height: 12),
        Text(
          context.l10n.storageForbiddenTitle,
          style: context.text.titleSmall,
        ),
        const SizedBox(height: 4),
        Text(message, style: TextStyle(color: context.colors.error)),
      ],
    ),
  );
}
