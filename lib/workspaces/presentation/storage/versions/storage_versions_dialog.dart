import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_action_error_banner.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_preview_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/cubit/storage_versions_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/cubit/storage_versions_state.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/storage_version_delete_confirmation.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/storage_version_list_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Dialog historii wersji pliku.
final class StorageVersionsDialog extends StatelessWidget {
  const StorageVersionsDialog({
    required this.file,
    required this.repository,
    required this.downloadTransport,
    this.canDeleteVersions,
    this.canPreview,
    this.canDownload,
    this.canRestore,
    super.key,
  });

  final StorageFileResponse file;
  final StorageRepository repository;
  final DownloadTransport downloadTransport;
  final bool? canDeleteVersions;
  final bool? canPreview;
  final bool? canDownload;
  final bool? canRestore;

  static Future<bool?> show(
    BuildContext context, {
    required StorageFileResponse file,
    required StorageRepository repository,
    required DownloadTransport downloadTransport,
    bool? canDeleteVersions,
    bool? canPreview,
    bool? canDownload,
    bool? canRestore,
  }) => DevPlannerModalHost.showDialog<bool>(
    context,
    builder: (_) => StorageVersionsDialog(
      file: file,
      repository: repository,
      downloadTransport: downloadTransport,
      canDeleteVersions: canDeleteVersions ?? file.canManageVersions,
      canPreview: canPreview ?? file.canPreview,
      canDownload: canDownload ?? file.canDownload,
      canRestore: canRestore ?? file.canRestore,
    ),
  );

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
    key: ValueKey((
      file.id,
      file.version,
      file.originalFileName,
      ObjectKey(repository),
      ObjectKey(downloadTransport),
    )),
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
      BlocProvider(
        create: (_) => StorageFileMutationCubit(
          repository: repository,
          downloadTransport: downloadTransport,
        ),
      ),
    ],
    child: _StorageVersionsView(
      file: file,
      repository: repository,
      canDeleteVersions: canDeleteVersions ?? file.canManageVersions,
      canPreview: canPreview ?? file.canPreview,
      canDownload: canDownload ?? file.canDownload,
      canRestore: canRestore ?? file.canRestore,
    ),
  );
}

final class _StorageVersionsView extends StatelessWidget {
  const _StorageVersionsView({
    required this.file,
    required this.repository,
    required this.canDeleteVersions,
    required this.canPreview,
    required this.canDownload,
    required this.canRestore,
  });

  final StorageRepository repository;

  final StorageFileResponse file;
  final bool canDeleteVersions;
  final bool canPreview;
  final bool canDownload;
  final bool canRestore;

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: context.tasksTheme.canvas,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.tasksTheme.panelRadius),
      side: BorderSide(color: context.tasksTheme.canvasBorder),
    ),
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
                  StorageVersionsFailure(
                    :final message,
                    :final apiError,
                  ) =>
                    apiError == null
                        ? Center(
                            child: Text(
                              message,
                              style: TextStyle(color: context.colors.error),
                            ),
                          )
                        : StoragePreviewActionErrorBanner(
                            error: apiError,
                            onRetry: () => unawaited(
                              context.read<StorageVersionsCubit>().load(),
                            ),
                          ),
                  StorageVersionsReady() => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state.apiError case final apiError?)
                        StoragePreviewActionErrorBanner(
                          error: apiError,
                          onRetry: () => unawaited(
                            context.read<StorageVersionsCubit>().load(),
                          ),
                        ),
                      if (state.isRefreshing)
                        const LinearProgressIndicator(minHeight: 2),
                      Expanded(
                        child: state.versions.isEmpty
                            ? Center(
                                child: Text(context.l10n.storageVersionsEmpty),
                              )
                            : ListView.separated(
                                itemCount: state.versions.length,
                                separatorBuilder: (_, _) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final version = state.versions[index];
                                  return StorageVersionListRow(
                                    version: version,
                                    currentVersion: file.version,
                                    isBusy:
                                        state.busyVersion == version.version,
                                    canPreview: canPreview,
                                    canDownload: canDownload,
                                    canRestore: canRestore,
                                    canDelete: canDeleteVersions,
                                    onPreview: () => unawaited(
                                      _preview(context, version.version),
                                    ),
                                    onDownload: () => unawaited(
                                      context
                                          .read<StorageVersionsCubit>()
                                          .download(version.version),
                                    ),
                                    onRestore: () => unawaited(
                                      _restore(context, version.version),
                                    ),
                                    onDelete: () => unawaited(
                                      _delete(context, version.version),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
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
    final mutationCubit = context.read<StorageFileMutationCubit>();
    final versionsCubit = context.read<StorageVersionsCubit>();
    await previewCubit.prepareVersionPreview(file: file, version: version);
    if (!context.mounted ||
        previewCubit.isClosed ||
        versionsCubit.isClosed ||
        !identical(previewCubit, context.read<StoragePreviewCubit>()) ||
        !identical(versionsCubit, context.read<StorageVersionsCubit>())) {
      return;
    }
    await DevPlannerModalHost.showDialog<void>(
      context,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: previewCubit),
          BlocProvider.value(value: mutationCubit),
        ],
        child: StoragePreviewDialog(
          file: file,
          repository: repository,
          version: version,
          onDownload: () => versionsCubit.downloadWithFeedback(version),
        ),
      ),
    );
  }

  Future<void> _restore(BuildContext context, int version) async {
    final cubit = context.read<StorageVersionsCubit>();
    final restored = await cubit.restore(version);
    if (!context.mounted ||
        cubit.isClosed ||
        !identical(cubit, context.read<StorageVersionsCubit>())) {
      return;
    }
    if (restored) Navigator.of(context).pop(true);
  }

  Future<void> _delete(BuildContext context, int version) async {
    final cubit = context.read<StorageVersionsCubit>();
    final confirmed = await StorageVersionDeleteConfirmation.show(
      context,
      version,
    );
    if (confirmed != true ||
        !context.mounted ||
        cubit.isClosed ||
        !identical(cubit, context.read<StorageVersionsCubit>())) {
      return;
    }
    await cubit.delete(version);
  }
}
