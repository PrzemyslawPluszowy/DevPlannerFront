import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/data/storage/transport/download_transport_impl.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/presentation/storage/versions/cubit/storage_versions_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/versions/cubit/storage_versions_state.dart';

/// Dialog historii wersji pliku.
final class StorageVersionsDialog extends StatelessWidget {
  const StorageVersionsDialog({required this.file, super.key});

  final StorageFileResponse file;

  static Future<bool?> show(
    BuildContext context, {
    required StorageFileResponse file,
  }) => showDialog<bool>(
    context: context,
    builder: (_) => StorageVersionsDialog(file: file),
  );

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) {
      final cubit = StorageVersionsCubit(
        fileId: file.id,
        fileName: file.originalFileName,
        expectedVersion: file.version,
        repository: context.read<StorageRepository>(),
        downloadTransport: const DownloadTransportImpl(),
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
