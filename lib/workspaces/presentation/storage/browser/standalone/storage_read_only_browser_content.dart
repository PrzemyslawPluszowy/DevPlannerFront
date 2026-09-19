import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_delete_actions.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_folder_create_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_read_only_file_tile.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_read_only_preview_dialog.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Zawartość standalone browsera wydzielona z composition page.
///
/// Rozdzielenie utrzymuje page poniżej limitu 400 linii i zostawia w niej
/// wyłącznie składanie Cubitów oraz capability gate'y.
final class StorageReadOnlyBrowserContent extends StatelessWidget {
  /// Tworzy listę folderów, plików i akcji Files.
  const StorageReadOnlyBrowserContent({
    required this.breadcrumbs,
    required this.folders,
    required this.files,
    required this.filePicker,
    required this.canUpload,
    required this.canCreateFolder,
    required this.canRenameFolder,
    required this.canDelete,
    required this.canRestore,
    required this.canDownload,
    required this.canShare,
    required this.repository,
    required this.onShareMutationConfirmed,
    required this.canManageVersions,
    required this.versionsRepository,
    required this.versionsDownloadTransport,
    required this.onVersionsRestored,
    required this.onOpenFileDetails,
    super.key,
  });

  final List<StorageBreadcrumbItem> breadcrumbs;
  final List<StorageFolderResponse> folders;
  final List<StorageFileResponse> files;
  final FilePickerPort? filePicker;
  final bool canUpload;
  final bool canCreateFolder;
  final bool canRenameFolder;
  final bool canDelete;
  final bool canRestore;
  final bool canDownload;
  final bool canShare;
  final StorageRepository repository;
  final Future<void> Function()? onShareMutationConfirmed;
  final bool canManageVersions;
  final StorageRepository versionsRepository;
  final DownloadTransport? versionsDownloadTransport;
  final VoidCallback onVersionsRestored;
  final ValueChanged<String>? onOpenFileDetails;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StorageBrowserCubit>();
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        if (canUpload || canCreateFolder)
          Align(
            alignment: Alignment.centerRight,
            child: Wrap(
              spacing: 12,
              children: [
                if (canCreateFolder)
                  StorageFolderCreateAction(scope: cubit.currentScope),
                if (canUpload)
                  FilledButton.icon(
                    icon: const Icon(AppIcons.upload, size: 18),
                    label: Text(context.l10n.storageUploadFiles),
                    onPressed: () => _pickAndUploadFiles(context),
                  ),
              ],
            ),
          ),
        StorageReadOnlyBrowserBreadcrumbs(items: breadcrumbs),
        if (folders.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            context.l10n.storageFoldersTitle,
            style: context.text.titleSmall,
          ),
          const SizedBox(height: 8),
          for (final folder in folders)
            ListTile(
              leading: Icon(AppIcons.folder, color: context.colors.primary),
              title: Text(folder.name),
              subtitle: Text('${folder.itemCount}'),
              enabled: folder.canRead,
              onTap: folder.canRead ? () => cubit.openFolder(folder) : null,
              trailing: Wrap(
                spacing: 4,
                children: [
                  if (canRenameFolder && folder.canEdit)
                    StorageFolderRenameAction(
                      key: ValueKey('rename-folder-${folder.id}'),
                      folderId: folder.id,
                      currentName: folder.name,
                    ),
                  if (canDelete && folder.canDelete)
                    StorageFolderDeleteAction(
                      buttonKey: ValueKey('delete-folder-${folder.id}'),
                      folderId: folder.id,
                    ),
                ],
              ),
            ),
        ],
        if (files.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            context.l10n.storageFilesCount(files.length),
            style: context.text.titleSmall,
          ),
          const SizedBox(height: 8),
          for (final file in files)
            StorageReadOnlyFileTile(
              file: file,
              canDelete: canDelete,
              canRestore: canRestore,
              canDownload: canDownload,
              canShare: canShare,
              repository: repository,
              onShareMutationConfirmed: onShareMutationConfirmed,
              canManageVersions: canManageVersions,
              versionsRepository: versionsRepository,
              versionsDownloadTransport: versionsDownloadTransport,
              onVersionsRestored: onVersionsRestored,
              onOpenDetails: onOpenFileDetails == null
                  ? null
                  : () => onOpenFileDetails!(file.id),
              onOpen: () => _openPreview(context, file),
            ),
        ],
      ],
    );
  }

  Future<void> _pickAndUploadFiles(BuildContext context) async {
    final picker = filePicker;
    if (picker == null) return;
    final pickedFiles = await picker.pickFiles();
    if (!context.mounted || pickedFiles.isEmpty) return;
    context.read<StorageUploadCubit>().enqueue(
      pickedFiles,
      context.read<StorageBrowserCubit>().currentScope,
    );
  }

  void _openPreview(BuildContext context, StorageFileResponse file) {
    if (!file.canRead || !file.canPreview) return;
    final previewCubit = context.read<StoragePreviewCubit>();
    unawaited(previewCubit.preparePreview(file));
    unawaited(
      showDialog<void>(
        context: context,
        builder: (_) => BlocProvider.value(
          value: previewCubit,
          child: const StorageReadOnlyPreviewDialog(),
        ),
      ),
    );
  }
}

/// Breadcrumbs for standalone Files navigation.
final class StorageReadOnlyBrowserBreadcrumbs extends StatelessWidget {
  /// Tworzy nawigację ścieżki folderów.
  const StorageReadOnlyBrowserBreadcrumbs({required this.items, super.key});

  final List<StorageBreadcrumbItem> items;

  @override
  Widget build(BuildContext context) {
    final browser = context.read<StorageBrowserCubit>();
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: Icon(Icons.chevron_right, size: 16),
            ),
          TextButton(
            onPressed: () => browser.navigateToBreadcrumb(items[index]),
            child: Text(
              items[index].name.isEmpty
                  ? _rootLabel(context, browser.currentScope)
                  : items[index].name,
            ),
          ),
        ],
      ],
    );
  }

  static String _rootLabel(BuildContext context, StorageScope scope) =>
      switch (scope) {
        StorageSharedScope() => context.l10n.storageSharedWithMe,
        StorageRecentScope() => context.l10n.storageRecent,
        StorageFavoritesScope() => context.l10n.storageFavorites,
        StorageTrashScope() => context.l10n.storageTrash,
        _ => context.l10n.storageMyFiles,
      };
}
