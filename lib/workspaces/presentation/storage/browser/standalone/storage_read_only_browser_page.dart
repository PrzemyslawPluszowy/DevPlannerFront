import 'dart:async';

import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/domain/storage/ports/download_transport.dart';
import 'package:devplanner/workspaces/domain/storage/ports/file_picker_port.dart';
import 'package:devplanner/workspaces/domain/storage/ports/upload_transport.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_delete_actions.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_folder_create_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_content.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/standalone/storage_read_only_browser_error.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/widgets/storage_upload_queue_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Minimalny pion Files: lista, foldery, preview i bezpieczne mutacje desktopowe.
///
/// Strona nie zna transportu HTTP ani tokenów. Otrzymuje gotowe repozytorium,
/// a Cubity przekazują operacje do lokalnych portów domenowych.
class StorageReadOnlyBrowserPage extends StatelessWidget {
  /// Tworzy przeglądarkę dla podanego zakresu Storage.
  const StorageReadOnlyBrowserPage({
    required this.repository,
    this.initialScope = const StorageScope.personal(),
    this.filePicker,
    this.uploadTransport,
    this.downloadTransport,
    this.allowFolderCreation = false,
    this.allowFolderRename = false,
    this.allowDeletion = false,
    this.allowDownload = false,
    this.allowSharing = false,
    this.allowVersionManagement = false,
    this.onOpenFileDetails,
    super.key,
  });

  /// Repozytorium Storage złożone przez composition root.
  final StorageRepository repository;

  /// Początkowy zakres (personal/workspace/project/shared itd.).
  final StorageScope initialScope;

  /// Platform picker supplied by the composition root.
  final FilePickerPort? filePicker;

  /// Presigned transfer supplied by the composition root.
  final UploadTransport? uploadTransport;

  /// Download adapter required by the existing file mutation Cubit.
  final DownloadTransport? downloadTransport;

  /// Enables folder creation only when the composition root explicitly allows it.
  final bool allowFolderCreation;

  /// Enables folder rename only when the composition root explicitly allows it.
  final bool allowFolderRename;

  /// Enables ACL-checked file/folder deletion only in the desktop composition.
  final bool allowDeletion;

  /// Enables single-file download only for the authenticated desktop
  /// composition. Web/BFF remains read-only.
  final bool allowDownload;

  /// Enables ACL sharing only for the authenticated desktop composition.
  /// BFF/web remains without any sharing control.
  final bool allowSharing;

  /// Enables version history only in the authenticated desktop composition.
  final bool allowVersionManagement;

  /// Nawigacja do świeżych szczegółów pliku, składana wyłącznie przez router.
  final ValueChanged<String>? onOpenFileDetails;

  @override
  Widget build(BuildContext context) {
    final upload = uploadTransport;
    final deletion = allowDeletion && downloadTransport != null;
    final download = allowDownload && downloadTransport != null;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = StorageBrowserCubit(
              repository: repository,
              initialScope: initialScope,
            );
            unawaited(cubit.load());
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) => StoragePreviewCubit(repository: repository),
        ),
        if (allowFolderCreation || allowFolderRename || deletion)
          BlocProvider<StorageFolderMutationCubit>(
            create: (_) => StorageFolderMutationCubit(repository: repository),
          ),
        if (deletion || download)
          BlocProvider<StorageFileMutationCubit>(
            create: (_) => StorageFileMutationCubit(
              repository: repository,
              downloadTransport: downloadTransport!,
            ),
          ),
      ],
      child: Builder(
        builder: (context) {
          final content = _StorageReadOnlyBrowserView(
            repository: repository,
            filePicker: filePicker,
            uploadTransport: upload,
            allowDeletion: deletion,
            allowDownload: download,
            allowSharing: allowSharing,
            allowVersionManagement: allowVersionManagement,
            versionsDownloadTransport: downloadTransport,
            allowFolderCreation: allowFolderCreation,
            allowFolderRename: allowFolderRename,
            onOpenFileDetails: onOpenFileDetails,
          );
          Widget composed = content;
          if (allowFolderCreation || allowFolderRename || deletion) {
            composed = StorageFolderMutationFeedback(
              onMutated: () => unawaited(
                context.read<StorageBrowserCubit>().load(showLoading: false),
              ),
              child: composed,
            );
          }
          if (deletion || download) {
            composed = StorageFileMutationFeedback(
              onDeleted: () => unawaited(
                context.read<StorageBrowserCubit>().load(showLoading: false),
              ),
              onRestored: () => unawaited(
                context.read<StorageBrowserCubit>().load(showLoading: false),
              ),
              child: composed,
            );
          }
          if (upload == null) return composed;
          return BlocProvider<StorageUploadCubit>(
            create: (context) => StorageUploadCubit(
              repository: repository,
              uploadTransport: upload,
              onUploadCompleted: () =>
                  context.read<StorageBrowserCubit>().load(showLoading: false),
            ),
            child: composed,
          );
        },
      ),
    );
  }
}

final class _StorageReadOnlyBrowserView extends StatelessWidget {
  const _StorageReadOnlyBrowserView({
    required this.repository,
    required this.filePicker,
    required this.uploadTransport,
    required this.allowDeletion,
    required this.allowDownload,
    required this.allowSharing,
    required this.allowVersionManagement,
    required this.versionsDownloadTransport,
    required this.allowFolderCreation,
    required this.allowFolderRename,
    required this.onOpenFileDetails,
  });

  final StorageRepository repository;
  final FilePickerPort? filePicker;
  final UploadTransport? uploadTransport;
  final bool allowDeletion;
  final bool allowDownload;
  final bool allowSharing;
  final bool allowVersionManagement;
  final DownloadTransport? versionsDownloadTransport;
  final bool allowFolderCreation;
  final bool allowFolderRename;
  final ValueChanged<String>? onOpenFileDetails;

  @override
  Widget build(BuildContext context) {
    final canUpload = filePicker != null && uploadTransport != null;
    final content = Stack(
      children: [
        BlocBuilder<StorageBrowserCubit, StorageBrowserState>(
          builder: (context, state) => switch (state) {
            StorageBrowserInitial() || StorageBrowserLoading() => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            StorageBrowserFailure(:final message) =>
              StorageReadOnlyBrowserError(
                message: message,
                forbidden: false,
              ),
            StorageBrowserForbidden(:final message) =>
              StorageReadOnlyBrowserError(
                message: message,
                forbidden: true,
              ),
            StorageBrowserEmpty(:final breadcrumbs) =>
              StorageReadOnlyBrowserContent(
                breadcrumbs: breadcrumbs,
                folders: const [],
                files: const [],
                filePicker: filePicker,
                canUpload: canUpload,
                canCreateFolder: allowFolderCreation,
                canRenameFolder: allowFolderRename,
                canDelete: allowDeletion,
                canRestore: allowDeletion,
                canDownload: allowDownload,
                canShare: allowSharing,
                repository: repository,
                onShareMutationConfirmed: () => context
                    .read<StorageBrowserCubit>()
                    .load(showLoading: false),
                canManageVersions: allowVersionManagement,
                versionsRepository: repository,
                versionsDownloadTransport: versionsDownloadTransport,
                onVersionsRestored: () => unawaited(
                  context.read<StorageBrowserCubit>().load(showLoading: false),
                ),
                onOpenFileDetails: onOpenFileDetails,
              ),
            StorageBrowserReady(
              :final breadcrumbs,
              :final folders,
              :final files,
            ) =>
              StorageReadOnlyBrowserContent(
                breadcrumbs: breadcrumbs,
                folders: folders,
                files: files,
                filePicker: filePicker,
                canUpload: canUpload,
                canCreateFolder: allowFolderCreation,
                canRenameFolder: allowFolderRename,
                canDelete: allowDeletion,
                canRestore: allowDeletion,
                canDownload: allowDownload,
                canShare: allowSharing,
                repository: repository,
                onShareMutationConfirmed: () => context
                    .read<StorageBrowserCubit>()
                    .load(showLoading: false),
                canManageVersions: allowVersionManagement,
                versionsRepository: repository,
                versionsDownloadTransport: versionsDownloadTransport,
                onVersionsRestored: () => unawaited(
                  context.read<StorageBrowserCubit>().load(showLoading: false),
                ),
                onOpenFileDetails: onOpenFileDetails,
              ),
          },
        ),
        if (canUpload) const StorageUploadQueueOverlay(),
      ],
    );
    return Scaffold(body: content);
  }
}
