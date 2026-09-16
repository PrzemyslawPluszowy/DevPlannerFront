import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/data/storage/transport/text_preview_loader_impl.dart';
import 'package:ready_next/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/office/widgets/storage_office_editor_dialog.dart';
import 'package:ready_next/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/preview/cubit/storage_preview_state.dart';
import 'package:ready_next/workspaces/presentation/storage/preview/widgets/storage_media_preview.dart';
import 'package:ready_next/workspaces/presentation/storage/preview/widgets/storage_pdf_preview.dart';
import 'package:ready_next/workspaces/presentation/storage/preview/widgets/storage_text_preview.dart';
import 'package:ready_next/workspaces/presentation/storage/shared/storage_formatters.dart';

/// Modalne okno podglądu pliku (obraz, PDF, tekst, OnlyOffice lub fallback).
class StoragePreviewDialog extends StatelessWidget {
  /// Tworzy okno dialogowe podglądu.
  const StoragePreviewDialog({
    required this.file,
    super.key,
  });

  /// Plik, dla którego wyświetlany jest podgląd.
  final StorageFileResponse file;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 900,
          maxHeight: 700,
        ),
        child: Column(
          children: [
            // Pasek nagłówka podglądu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    StorageFormatters.iconForFile(
                      mimeType: file.mimeType,
                      extension: file.extension,
                    ),
                    size: 20,
                    color: context.colors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.originalFileName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.text.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${StorageFormatters.formatBytes(file.fileSizeBytes)} • Wersja ${file.version}',
                          style: context.text.labelSmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (file.canEditOnline)
                    TextButton.icon(
                      icon: const Icon(AppIcons.documentText, size: 16),
                      label: Text(context.l10n.storageOpenOfficeAction),
                      onPressed: () {
                        Navigator.of(context).pop();
                        unawaited(
                          StorageOfficeEditorDialog.show(context, file: file),
                        );
                      },
                    ),
                  if (file.canDownload)
                    IconButton(
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
                  IconButton(
                    icon: const Icon(AppIcons.close, size: 18),
                    tooltip: context.l10n.close,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Ciało podglądu
            Expanded(
              child: BlocBuilder<StoragePreviewCubit, StoragePreviewState>(
                builder: (context, state) => switch (state) {
                  StoragePreviewInitial() ||
                  StoragePreviewLoading() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  StoragePreviewFailure(:final message) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        context.l10n.storagePreviewError(message),
                        style: TextStyle(color: context.colors.error),
                      ),
                    ),
                  ),
                  StoragePreviewReady(
                    :final kind,
                    :final previewUrl,
                    :final previewHeaders,
                  ) =>
                    _buildPreviewBody(
                      context,
                      kind,
                      previewUrl,
                      previewHeaders,
                    ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewBody(
    BuildContext context,
    StoragePreviewKind kind,
    String previewUrl,
    Map<String, String> previewHeaders,
  ) {
    return switch (kind) {
      StoragePreviewKind.image => Center(
        child: InteractiveViewer(
          child: Image.network(
            previewUrl,
            headers: previewHeaders,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    AppIcons.alertCircle,
                    size: 40,
                    color: context.colors.error,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.storageImageLoadError,
                    style: context.text.bodyMedium?.copyWith(
                      color: context.colors.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      StoragePreviewKind.office => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.documentText,
              size: 64,
              color: context.colors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              file.originalFileName,
              style: context.text.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.storageOfficeDescription,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(AppIcons.documentText, size: 16),
              label: Text(context.l10n.storageOpenOfficeAction),
              onPressed: () {
                Navigator.of(context).pop();
                unawaited(StorageOfficeEditorDialog.show(context, file: file));
              },
            ),
          ],
        ),
      ),
      StoragePreviewKind.pdf => StoragePdfPreview(
        url: previewUrl,
        headers: previewHeaders,
      ),
      StoragePreviewKind.video => StorageMediaPreview(
        url: previewUrl,
        isAudio: false,
        headers: previewHeaders,
      ),
      StoragePreviewKind.audio => StorageMediaPreview(
        url: previewUrl,
        isAudio: true,
        headers: previewHeaders,
      ),
      StoragePreviewKind.text => StorageTextPreview(
        url: previewUrl,
        loader: TextPreviewLoaderImpl(headers: previewHeaders),
      ),
      StoragePreviewKind.unsupported => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              StorageFormatters.iconForFile(
                mimeType: file.mimeType,
                extension: file.extension,
              ),
              size: 64,
              color: context.colors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              file.originalFileName,
              style: context.text.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.storageUnsupportedDescription,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            if (file.canDownload)
              FilledButton.icon(
                icon: const Icon(AppIcons.download, size: 16),
                label: Text(context.l10n.storageDownloadAction),
                onPressed: () {
                  unawaited(
                    context.read<StorageFileMutationCubit>().downloadFile(file),
                  );
                },
              ),
          ],
        ),
      ),
    };
  }
}
