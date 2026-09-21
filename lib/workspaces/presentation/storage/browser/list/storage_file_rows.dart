import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_view_preference.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_drag_and_drop.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_move_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_preview_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_file_context_menu.dart';
import 'package:devplanner/workspaces/presentation/storage/shared/storage_formatters.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_sharing_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Wiersze plików w widoku tabelarycznym / liście eksploratora.
class StorageFileRows extends StatelessWidget {
  /// Tworzy listę plików.
  const StorageFileRows({
    required this.files,
    this.capabilities = StorageShellCapabilities.readOnly,
    this.onOpenFileDetails,
    super.key,
  });

  /// Lista plików do wyrenderowania.
  final List<StorageFileResponse> files;

  /// Uprawnienia kompozycji przekazywane do akcji wiersza.
  final StorageShellCapabilities capabilities;

  /// Nawigacja do świeżych szczegółów pliku.
  final ValueChanged<String>? onOpenFileDetails;

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();

    final selectionCubit = context.watch<StorageSelectionCubit>();
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final openDetails = onOpenFileDetails;

    final dense =
        context.select<StorageBrowserCubit, StorageDensity>(
          (cubit) => cubit.currentDensity,
        ) ==
        StorageDensity.compact;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: files.length,
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: context.colors.outlineVariant.withValues(alpha: 0.3),
      ),
      itemBuilder: (context, index) {
        final file = files[index];
        final isSelected = selectionCubit.state.isFileSelected(file.id);
        final iconData = StorageFormatters.iconForFile(
          mimeType: file.mimeType,
          extension: file.extension,
        );

        return StorageFileDragSource(
          fileId: file.id,
          label: file.originalFileName,
          enabled: capabilities.canMove,
          child: GestureDetector(
            onSecondaryTapDown: (details) => StorageFileContextMenu.show(
              context,
              file,
              details.globalPosition,
              capabilities: capabilities,
              onOpenFileDetails: openDetails,
            ),
            child: ListTile(
              dense: dense,
              minVerticalPadding: dense ? 4 : 8,
              selected: isSelected,
              selectedTileColor: context.colors.primaryContainer.withValues(
                alpha: 0.3,
              ),
              leading: Icon(
                iconData,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                file.originalFileName,
                style: context.text.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                '${StorageFormatters.formatBytes(file.fileSizeBytes)} • ${dateFormat.format(file.updatedAtUtc.toLocal())}',
              ),
              trailing: Row(
                mainAxisSize: .min,
                children: [
                  if (openDetails != null)
                    IconButton(
                      key: ValueKey('file-details-${file.id}'),
                      icon: const Icon(Icons.info_outline, size: 18),
                      tooltip: context.l10n.storageDetailsTitle,
                      onPressed: () => openDetails(file.id),
                    ),
                  if (capabilities.canMove)
                    IconButton(
                      key: ValueKey('move-file-${file.id}'),
                      icon: const Icon(AppIcons.folder, size: 18),
                      tooltip: context.l10n.storageMoveAction,
                      onPressed: () => unawaited(
                        runStorageMoveToFolderAction(
                          context,
                          fileIds: [file.id],
                        ),
                      ),
                    ),
                  if (capabilities.canShare && file.canShare)
                    IconButton(
                      key: ValueKey('share-file-${file.id}'),
                      icon: const Icon(AppIcons.share, size: 18),
                      tooltip: context.l10n.storageShareAction,
                      onPressed: () {
                        unawaited(
                          StorageSharingDialog.show(
                            context,
                            file: file,
                            repository: context.read<StorageRepository>(),
                            userDirectory: context
                                .read<StorageUserDirectoryPort?>(),
                          ),
                        );
                      },
                    ),
                  if (capabilities.canFavorite && file.canRead)
                    IconButton(
                      icon: Icon(
                        file.isFavorite ? AppIcons.star : AppIcons.star,
                        size: 18,
                        color: file.isFavorite
                            ? context.colors.tertiary
                            : context.colors.onSurfaceVariant,
                      ),
                      tooltip: file.isFavorite
                          ? context.l10n.storageRemoveFavoriteAction
                          : context.l10n.storageAddFavoriteAction,
                      onPressed: () {
                        unawaited(
                          context
                              .read<StorageFileMutationCubit>()
                              .toggleFavorite(
                                file,
                              ),
                        );
                      },
                    ),
                  if (capabilities.canDownload && file.canDownload)
                    IconButton(
                      key: ValueKey('download-file-${file.id}'),
                      icon: const Icon(AppIcons.download, size: 18),
                      tooltip: context.l10n.storageDownloadAction,
                      onPressed: () {
                        unawaited(
                          context.read<StorageFileMutationCubit>().downloadFile(
                            file,
                          ),
                        );
                      },
                    ),
                ],
              ),
              onTap: () {
                if (selectionCubit.state.hasSelection) {
                  selectionCubit.toggleFile(file);
                } else {
                  _openPreview(context, file);
                }
              },
              onLongPress: () => selectionCubit.toggleFile(file),
            ),
          ),
        );
      },
    );
  }

  void _openPreview(BuildContext context, StorageFileResponse file) {
    unawaited(showStoragePreview(context, file: file));
  }
}
