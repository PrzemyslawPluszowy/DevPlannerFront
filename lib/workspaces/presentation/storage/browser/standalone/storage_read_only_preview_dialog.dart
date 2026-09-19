import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/cubit/storage_preview_state.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_media_preview.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_pdf_preview.dart';
import 'package:devplanner/workspaces/presentation/storage/preview/widgets/storage_text_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class StorageReadOnlyPreviewDialog extends StatelessWidget {
  const StorageReadOnlyPreviewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900, maxHeight: 700),
        child: Column(
          children: [
            ListTile(
              title: Text(context.l10n.storagePreviewTitle),
              trailing: IconButton(
                tooltip: context.l10n.close,
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(AppIcons.close),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: BlocBuilder<StoragePreviewCubit, StoragePreviewState>(
                builder: (context, state) => switch (state) {
                  StoragePreviewInitial() || StoragePreviewLoading() =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                  StoragePreviewFailure(:final message) => Center(
                    child: Text(context.l10n.storagePreviewError(message)),
                  ),
                  StoragePreviewReady(
                    :final file,
                    :final kind,
                    :final previewUrl,
                    :final previewHeaders,
                  ) =>
                    StorageReadOnlyPreviewBody(
                      file: file,
                      kind: kind,
                      url: previewUrl,
                      headers: previewHeaders,
                    ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class StorageReadOnlyPreviewBody extends StatelessWidget {
  const StorageReadOnlyPreviewBody({
    required this.file,
    required this.kind,
    required this.url,
    required this.headers,
    super.key,
  });

  final StorageFileResponse file;
  final StoragePreviewKind kind;
  final String url;
  final Map<String, String> headers;

  @override
  Widget build(BuildContext context) => switch (kind) {
    StoragePreviewKind.image => InteractiveViewer(
      child: Image.network(url, headers: headers, fit: BoxFit.contain),
    ),
    StoragePreviewKind.pdf => StoragePdfPreview(url: url, headers: headers),
    StoragePreviewKind.video => StorageMediaPreview(
      url: url,
      isAudio: false,
      headers: headers,
    ),
    StoragePreviewKind.audio => StorageMediaPreview(
      url: url,
      isAudio: true,
      headers: headers,
    ),
    StoragePreviewKind.text => StorageTextPreview(url: url),
    StoragePreviewKind.office || StoragePreviewKind.unsupported => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          file.canRead
              ? context.l10n.storageUnsupportedDescription
              : context.l10n.storageForbiddenTitle,
        ),
      ),
    ),
  };
}
