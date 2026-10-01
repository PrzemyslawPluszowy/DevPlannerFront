import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_state.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_media_preview.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_pdf_preview.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_text_preview.dart';
import 'package:devplanner/workspaces/presentation/storage/shared/storage_formatters.dart';
import 'package:flutter/material.dart';

/// Renderer przygotowanego podglądu; historia nie może otwierać edytora bieżącej wersji.
final class StoragePreviewBody extends StatelessWidget {
  const StoragePreviewBody({
    required this.file,
    required this.ready,
    required this.onOpenEditor,
    this.onDownload,
    super.key,
  });
  final StorageFileResponse file;
  final StoragePreviewReady ready;
  final VoidCallback onOpenEditor;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final kind = ready.kind;
    final previewUrl = ready.previewUrl;
    final previewHeaders = ready.previewHeaders;
    final imageBytes = ready.imageBytes;
    final version = ready.version;
    return switch (kind) {
      StoragePreviewKind.image =>
        imageBytes == null
            ? Center(child: Text(context.l10n.storageImageLoadError))
            : Center(
                child: InteractiveViewer(
                  child: Image.memory(
                    imageBytes,
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
              version == null
                  ? context.l10n.storageOfficeDescription
                  : context.l10n.storageVersionPreviewOfficeUnavailable,
              textAlign: TextAlign.center,
              style: context.text.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            if (file.canEditOnline && version == null)
              OutlinedButton.icon(
                icon: const Icon(AppIcons.documentText, size: 16),
                label: Text(context.l10n.storageOpenOfficeAction),
                onPressed: onOpenEditor,
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
        headers: previewHeaders,
        key: ValueKey((file.id, ready.version, previewUrl)),
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
            if (onDownload != null)
              FilledButton.icon(
                icon: const Icon(AppIcons.download, size: 16),
                label: Text(context.l10n.storageDownloadAction),
                onPressed: onDownload,
              ),
          ],
        ),
      ),
    };
  }
}
