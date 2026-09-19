import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
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
    super.key,
  });

  final StorageFileResponse file;
  final StorageRepository repository;
  final DownloadTransport downloadTransport;

  static Future<bool?> show(
    BuildContext context, {
    required StorageFileResponse file,
    required StorageRepository repository,
    required DownloadTransport downloadTransport,
  }) => showDialog<bool>(
    context: context,
    builder: (_) => StorageVersionsDialog(
      file: file,
      repository: repository,
      downloadTransport: downloadTransport,
    ),
  );

  @override
  Widget build(BuildContext context) => BlocProvider(
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
    child: _StorageVersionsView(file: file),
  );
}

final class _StorageVersionsView extends StatelessWidget {
  const _StorageVersionsView({required this.file});

  final StorageFileResponse file;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(context.l10n.storageVersionsTitle),
    content: SizedBox(
      width: 560,
      height: 420,
      child: BlocBuilder<StorageVersionsCubit, StorageVersionsState>(
        builder: (context, state) => switch (state) {
          StorageVersionsInitial() || StorageVersionsLoading() => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          StorageVersionsFailure(:final message) => Center(
            child: Text(message, style: TextStyle(color: context.colors.error)),
          ),
          StorageVersionsReady(:final versions, :final busyVersion) =>
            versions.isEmpty
                ? Center(child: Text(context.l10n.storageVersionsEmpty))
                : ListView.separated(
                    itemCount: versions.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final version = versions[index];
                      final busy = busyVersion == version.version;
                      return ListTile(
                        leading: const Icon(AppIcons.documentText),
                        title: Text(
                          context.l10n.storageVersionLabel(version.version),
                        ),
                        subtitle: Text(
                          DateFormat('yyyy-MM-dd HH:mm').format(
                            version.createdAtUtc.toLocal(),
                          ),
                        ),
                        trailing: busy
                            ? const CircularProgressIndicator.adaptive()
                            : Wrap(
                                children: [
                                  IconButton(
                                    icon: const Icon(AppIcons.download),
                                    tooltip: context.l10n.storageDownloadAction,
                                    onPressed: () => unawaited(
                                      context
                                          .read<StorageVersionsCubit>()
                                          .download(version.version),
                                    ),
                                  ),
                                  if (version.version != file.version)
                                    IconButton(
                                      icon: const Icon(AppIcons.refresh),
                                      tooltip:
                                          context.l10n.storageRestoreSelected,
                                      onPressed: () => unawaited(
                                        _restore(context, version.version),
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
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: Text(context.l10n.close),
      ),
    ],
  );

  Future<void> _restore(BuildContext context, int version) async {
    final restored = await context.read<StorageVersionsCubit>().restore(
      version,
    );
    if (restored && context.mounted) Navigator.of(context).pop(true);
  }
}
