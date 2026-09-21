import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_drag_and_drop.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_move_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_open_document_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_preview_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_file_context_menu.dart';
import 'package:devplanner/workspaces/presentation/storage/shared/storage_formatters.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_sharing_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
import 'package:devplanner/workspaces/presentation/storage/versions/storage_versions_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Siatka plików w widoku kafelkowym eksploratora.
class StorageFileGrid extends StatelessWidget {
  /// Tworzy siatkę plików.
  const StorageFileGrid({
    required this.files,
    this.capabilities = StorageShellCapabilities.readOnly,
    this.onOpenFileDetails,
    super.key,
  });

  /// Lista plików do wyrenderowania.
  final List<StorageFileResponse> files;

  /// Uprawnienia kompozycji przekazywane do akcji kafelka.
  final StorageShellCapabilities capabilities;

  /// Nawigacja do świeżych szczegółów pliku.
  final ValueChanged<String>? onOpenFileDetails;

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            context.l10n.storageFilesCount(files.length),
            style: context.text.labelMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisExtent: 160,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];
            return _FileGridCard(
              file: file,
              capabilities: capabilities,
              onOpenFileDetails: onOpenFileDetails,
            );
          },
        ),
      ],
    );
  }
}

class _FileGridCard extends StatelessWidget {
  const _FileGridCard({
    required this.file,
    required this.capabilities,
    required this.onOpenFileDetails,
  });

  final StorageFileResponse file;
  final StorageShellCapabilities capabilities;
  final ValueChanged<String>? onOpenFileDetails;

  @override
  Widget build(BuildContext context) {
    final selectionCubit = context.watch<StorageSelectionCubit>();
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
          onOpenFileDetails: onOpenFileDetails,
        ),
        child: InkWell(
          onTap: () {
            if (selectionCubit.state.hasSelection) {
              selectionCubit.toggleFile(file);
            } else {
              _openPreview(context, file);
            }
          },
          onLongPress: () => selectionCubit.toggleFile(file),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? context.colors.primaryContainer.withValues(alpha: 0.4)
                  : context.colors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : context.colors.outlineVariant.withValues(alpha: 0.4),
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Obszar ikony / miniatury
                Expanded(
                  child: Center(
                    child: Icon(
                      iconData,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                // Pasek metadanych pliku
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        file.originalFileName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            StorageFormatters.formatBytes(file.fileSizeBytes),
                            style: context.text.labelSmall?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                          const Spacer(),
                          if (file.isFavorite)
                            Icon(
                              AppIcons.star,
                              size: 14,
                              color: context.colors.tertiary,
                            ),
                          IconButton(
                            icon: const Icon(AppIcons.moreVertical, size: 14),
                            tooltip: context.l10n.storageMoreOptionsTooltip,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => _showFileMenu(context, file),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPreview(BuildContext context, StorageFileResponse file) {
    unawaited(showStoragePreview(context, file: file));
  }

  void _showFileMenu(BuildContext context, StorageFileResponse file) {
    final mutationCubit = context.read<StorageFileMutationCubit>();
    final l10n = context.l10n;
    final isTrash = context.read<StorageBrowserCubit>().currentScope.isTrash;
    final openDetails = onOpenFileDetails;
    unawaited(
      DevPlannerModalHost.showBottomSheet<void>(
        context,
        builder: (sheetCtx) => SafeArea(
          child: Column(
            mainAxisSize: .min,
            children: [
              if (openDetails != null)
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.storageDetailsTitle),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    openDetails(file.id);
                  },
                ),
              if (file.canEditOnline && !isTrash)
                ListTile(
                  key: ValueKey('open-office-${file.id}'),
                  leading: const Icon(AppIcons.documentText),
                  title: Text(l10n.storageOpenOfficeAction),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    unawaited(
                      runStorageOpenOfficeDocument(context, file: file),
                    );
                  },
                ),
              if (capabilities.canMove && !isTrash)
                ListTile(
                  key: ValueKey('move-file-${file.id}'),
                  leading: const Icon(AppIcons.folder),
                  title: Text(l10n.storageMoveAction),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    unawaited(
                      runStorageMoveToFolderAction(context, fileIds: [file.id]),
                    );
                  },
                ),
              if (capabilities.canShare && file.canShare && !isTrash)
                ListTile(
                  leading: const Icon(AppIcons.share),
                  title: Text(l10n.storageShareAction),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
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
              if (capabilities.canFavorite && file.canRead && !isTrash)
                ListTile(
                  leading: Icon(
                    AppIcons.star,
                    color: file.isFavorite ? context.colors.tertiary : null,
                  ),
                  title: Text(
                    file.isFavorite
                        ? l10n.storageRemoveFavoriteAction
                        : l10n.storageAddFavoriteAction,
                  ),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    unawaited(mutationCubit.toggleFavorite(file));
                  },
                ),
              if (capabilities.canDownload && file.canDownload)
                ListTile(
                  leading: const Icon(AppIcons.download),
                  title: Text(l10n.storageDownloadAction),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    unawaited(mutationCubit.downloadFile(file));
                  },
                ),
              if (capabilities.canManageVersions && file.canManageVersions)
                ListTile(
                  leading: const Icon(AppIcons.documentText),
                  title: Text(l10n.storageVersionsTitle),
                  onTap: () async {
                    Navigator.of(sheetCtx).pop();
                    final restored = await StorageVersionsDialog.show(
                      context,
                      file: file,
                      repository: context.read<StorageRepository>(),
                      downloadTransport: context.read<DownloadTransport>(),
                    );
                    if (restored == true && context.mounted) {
                      unawaited(
                        context.read<StorageBrowserCubit>().load(
                          showLoading: false,
                        ),
                      );
                    }
                  },
                ),
              if (capabilities.canDelete && isTrash && file.canRestore)
                ListTile(
                  leading: const Icon(AppIcons.refresh),
                  title: Text(l10n.storageRestoreSelected),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    unawaited(mutationCubit.restoreFile(file.id));
                  },
                )
              else if (capabilities.canDelete && file.canDelete)
                ListTile(
                  leading: Icon(AppIcons.delete, color: context.colors.error),
                  title: Text(
                    l10n.storageDeleteAction,
                    style: TextStyle(color: context.colors.error),
                  ),
                  onTap: () {
                    Navigator.of(sheetCtx).pop();
                    unawaited(mutationCubit.deleteFile(file.id));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
