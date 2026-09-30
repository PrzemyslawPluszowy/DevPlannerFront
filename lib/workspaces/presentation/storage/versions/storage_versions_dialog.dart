import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/cubit/storage_versions_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/cubit/storage_versions_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Dialog historii wersji pliku.
final class StorageVersionsDialog extends StatelessWidget {
  const StorageVersionsDialog({
    required this.file,
    required this.repository,
    required this.downloadTransport,
    this.canDeleteVersions = false,
    super.key,
  });

  final StorageFileResponse file;
  final StorageRepository repository;
  final DownloadTransport downloadTransport;
  final bool canDeleteVersions;

  static Future<bool?> show(
    BuildContext context, {
    required StorageFileResponse file,
    required StorageRepository repository,
    required DownloadTransport downloadTransport,
    bool canDeleteVersions = false,
  }) => showDialog<bool>(
    context: context,
    builder: (_) => StorageVersionsDialog(
      file: file,
      repository: repository,
      downloadTransport: downloadTransport,
      canDeleteVersions: canDeleteVersions,
    ),
  );

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) {
          final cubit = StorageVersionsCubit(
            fileId: file.id,
            fileName: file.originalFileName,
            expectedVersion: file.version,
            repository: repository,
            downloadTransport: downloadTransport,
          );
          unawaited(cubit.load());
          return cubit;
        },
      ),
      // Podgląd wersji korzysta z tych samych rendererów co podgląd pliku,
      // więc nie powstaje drugi zestaw powierzchni podglądu.
      BlocProvider(create: (_) => StoragePreviewCubit(repository: repository)),
    ],
    child: _StorageVersionsView(
      file: file,
      repository: repository,
      canDeleteVersions: canDeleteVersions,
    ),
  );
}

final class _StorageVersionsView extends StatelessWidget {
  const _StorageVersionsView({
    required this.file,
    required this.repository,
    required this.canDeleteVersions,
  });

  final StorageRepository repository;

  final StorageFileResponse file;
  final bool canDeleteVersions;

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: context.colors.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680, maxHeight: 620),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 16, 14, 14),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.history_rounded, color: context.colors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.storageVersionsTitle,
                    style: context.text.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: context.l10n.close,
                  onPressed: () => Navigator.of(context).pop(false),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<StorageVersionsCubit, StorageVersionsState>(
                builder: (context, state) => switch (state) {
                  StorageVersionsInitial() ||
                  StorageVersionsLoading() => const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                  StorageVersionsFailure(:final message) => Center(
                    child: Text(
                      message,
                      style: TextStyle(color: context.colors.error),
                    ),
                  ),
                  StorageVersionsReady(:final versions, :final busyVersion) =>
                    versions.isEmpty
                        ? Center(child: Text(context.l10n.storageVersionsEmpty))
                        : ListView.separated(
                            itemCount: versions.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final version = versions[index];
                              final busy = busyVersion == version.version;
                              return ListTile(
                                leading: const Icon(AppIcons.documentText),
                                title: Text(
                                  context.l10n.storageVersionLabel(
                                    version.version,
                                  ),
                                ),
                                subtitle: Text(
                                  '${DateFormat.yMMMd().add_Hm().format(version.createdAtUtc.toLocal())}\n'
                                  '${context.l10n.storageVersionAuthor(version.changedByDisplayName ?? context.l10n.storageVersionAuthorUnknown)}'
                                  '${version.changeSummary == null ? '' : '\n${version.changeSummary}'}',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: busy
                                    ? const CircularProgressIndicator.adaptive()
                                    : Wrap(
                                        children: [
                                          IconButton(
                                            key: ValueKey(
                                              'preview-version-${version.version}',
                                            ),
                                            icon: const Icon(
                                              Icons.visibility_outlined,
                                            ),
                                            tooltip: context
                                                .l10n
                                                .storageVersionPreviewAction,
                                            onPressed: () => unawaited(
                                              _preview(
                                                context,
                                                version.version,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(AppIcons.download),
                                            tooltip: context
                                                .l10n
                                                .storageDownloadAction,
                                            onPressed: () => unawaited(
                                              context
                                                  .read<StorageVersionsCubit>()
                                                  .download(version.version),
                                            ),
                                          ),
                                          if (version.version != file.version)
                                            IconButton(
                                              icon: const Icon(
                                                AppIcons.refresh,
                                              ),
                                              tooltip: context
                                                  .l10n
                                                  .storageRestoreSelected,
                                              onPressed: () => unawaited(
                                                _restore(
                                                  context,
                                                  version.version,
                                                ),
                                              ),
                                            ),
                                          if (canDeleteVersions &&
                                              version.version != file.version)
                                            IconButton(
                                              key: ValueKey(
                                                'delete-version-${version.version}',
                                              ),
                                              icon: Icon(
                                                AppIcons.delete,
                                                color: context.colors.error,
                                              ),
                                              tooltip: context
                                                  .l10n
                                                  .storageVersionDeleteAction,
                                              onPressed: () => unawaited(
                                                _delete(
                                                  context,
                                                  version.version,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                              );
                            },
                          ),
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );

  /// Pokazuje wersję historyczną w podglądzie tylko do odczytu.
  ///
  /// Przywrócenie nie jest tu wywoływane: oglądanie starej treści nie może
  /// zmienić bieżącego pliku.
  Future<void> _preview(BuildContext context, int version) async {
    final previewCubit = context.read<StoragePreviewCubit>();
    await previewCubit.prepareVersionPreview(file: file, version: version);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: previewCubit,
        child: StoragePreviewDialog(
          file: file,
          repository: repository,
          version: version,
        ),
      ),
    );
  }

  Future<void> _restore(BuildContext context, int version) async {
    final restored = await context.read<StorageVersionsCubit>().restore(
      version,
    );
    if (restored && context.mounted) Navigator.of(context).pop(true);
  }

  Future<void> _delete(BuildContext context, int version) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.storageVersionDeleteAction),
        content: Text(
          dialogContext.l10n.storageVersionDeleteConfirm(version),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.close),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(dialogContext.l10n.storageVersionDeleteAction),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<StorageVersionsCubit>().delete(version);
  }
}
