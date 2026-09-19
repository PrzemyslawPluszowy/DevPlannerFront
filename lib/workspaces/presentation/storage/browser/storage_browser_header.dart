import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/l10n/app_localizations.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/transport/file_picker_port_impl.dart';
import 'package:devplanner/workspaces/domain/storage/models/storage_scope.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_state.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_document_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_folder_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_scope_route_codec.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Górny nagłówek sekcji eksploratora plików: tytuł bieżącego zakresu oraz akcje nadrzędne (Nowy folder, Prześlij pliki).
class StorageBrowserHeader extends StatelessWidget {
  /// Tworzy nagłówek eksploratora.
  const StorageBrowserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<StorageBrowserCubit>();

    return BlocBuilder<StorageBrowserCubit, StorageBrowserState>(
      buildWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      builder: (context, state) {
        final scope = cubit.currentScope;
        final title = _resolveScopeTitle(scope, l10n);
        final canCreateContent = scope.canCreateContent;
        final canCreateDocument =
            scope.isPersonal ||
            scope is StorageWorkspaceScope ||
            scope is StorageProjectScope;
        // W kompaktowym shellu sidebar nadal zajmuje 56 px, dlatego próg
        // dotyczy całego okna i uwzględnia przestrzeń odebraną headerowi.
        final compactActions = MediaQuery.sizeOf(context).width < 780;
        final returnTo = StorageScopeRouteCodec.returnLocation(
          StorageScopeRouteCodec.routeUri(context),
        );

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: context.colors.surface,
            border: Border(
              bottom: BorderSide(
                color: context.colors.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Row(
            children: [
              if (returnTo != null) ...[
                IconButton(
                  icon: const Icon(AppIcons.arrowLeft),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed: () => context.go(returnTo),
                ),
                const SizedBox(width: 4),
              ],
              Text(
                title,
                style: context.text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.onSurface,
                ),
              ),
              const Spacer(),
              // Nowy folder i dokument
              if (canCreateContent) ...[
                if (compactActions) ...[
                  IconButton(
                    icon: const Icon(AppIcons.folder, size: 18),
                    tooltip: l10n.storageNewFolder,
                    onPressed: () => _showCreateFolderDialog(context, scope),
                  ),
                  IconButton.filled(
                    icon: const Icon(AppIcons.upload, size: 18),
                    tooltip: l10n.storageUploadFiles,
                    onPressed: () => _pickAndUploadFiles(context, scope),
                  ),
                  if (canCreateDocument)
                    IconButton(
                      icon: const Icon(AppIcons.document, size: 18),
                      tooltip: l10n.storageNewDocument,
                      onPressed: () =>
                          _showCreateDocumentDialog(context, scope),
                    ),
                ] else ...[
                  OutlinedButton.icon(
                    icon: const Icon(AppIcons.folder, size: 16),
                    label: Text(l10n.storageNewFolder),
                    onPressed: () => _showCreateFolderDialog(context, scope),
                  ),
                  const SizedBox(width: 8),
                  if (canCreateDocument) ...[
                    OutlinedButton.icon(
                      icon: const Icon(AppIcons.document, size: 16),
                      label: Text(l10n.storageNewDocument),
                      onPressed: () =>
                          _showCreateDocumentDialog(context, scope),
                    ),
                    const SizedBox(width: 8),
                  ],
                  FilledButton.icon(
                    icon: const Icon(AppIcons.upload, size: 16),
                    label: Text(l10n.storageUploadFiles),
                    onPressed: () => _pickAndUploadFiles(context, scope),
                  ),
                ],
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _showCreateDocumentDialog(
    BuildContext context,
    StorageScope scope,
  ) async {
    final l10n = context.l10n;
    final nameController = TextEditingController();
    final result = await showDialog<(String, StorageDocumentFormat)>(
      context: context,
      builder: (_) => _StorageCreateDocumentDialog(
        controller: nameController,
        l10n: l10n,
      ),
    );
    nameController.dispose();
    if (result != null && context.mounted) {
      await context.read<StorageDocumentMutationCubit>().createDocument(
        scope: scope,
        name: result.$1,
        format: result.$2,
      );
    }
  }

  String _resolveScopeTitle(StorageScope scope, AppLocalizations l10n) {
    if (scope.folderId != null) return l10n.storageFolderTitle;
    if (scope.isTrash) return l10n.storageTrash;
    if (scope.isFavorites) return l10n.storageFavorites;
    if (scope.isRecent) return l10n.storageRecent;
    if (scope.isSharedWithMe) return l10n.storageSharedWithMe;
    return switch (scope) {
      StorageWorkspaceScope() => l10n.storageWorkspaceFilesTitle,
      StorageProjectScope() => l10n.storageProjectFilesTitle,
      StorageResourceScope() => l10n.storageAttachmentsTitle,
      _ => l10n.storageMyFiles,
    };
  }

  Future<void> _showCreateFolderDialog(
    BuildContext context,
    StorageScope scope,
  ) async {
    final l10n = context.l10n;
    final controller = TextEditingController();

    final folderName = await showDialog<String>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: Text(l10n.storageCreateFolderDialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.storageCreateFolderDialogHint,
          ),
          onSubmitted: (val) => Navigator.of(dialogCtx).pop(val.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogCtx).pop(controller.text.trim()),
            child: Text(l10n.storageCreateFolderButton),
          ),
        ],
      ),
    );

    if (folderName != null && folderName.isNotEmpty && context.mounted) {
      await context.read<StorageFolderMutationCubit>().createFolder(
        scope: scope,
        name: folderName,
        parentFolderId: scope.folderId,
      );
      if (context.mounted) {
        unawaited(context.read<StorageBrowserCubit>().load(showLoading: false));
      }
    }
  }

  Future<void> _pickAndUploadFiles(
    BuildContext context,
    StorageScope scope,
  ) async {
    const picker = FilePickerPortImpl();
    final pickedFiles = await picker.pickFiles();
    if (pickedFiles.isEmpty || !context.mounted) return;

    context.read<StorageUploadCubit>().enqueue(pickedFiles, scope);
  }
}

/// Dialog tworzenia dokumentu z lokalnym, zwalnianym wyborem formatu.
final class _StorageCreateDocumentDialog extends StatefulWidget {
  const _StorageCreateDocumentDialog({
    required this.controller,
    required this.l10n,
  });

  final TextEditingController controller;
  final AppLocalizations l10n;

  @override
  State<_StorageCreateDocumentDialog> createState() =>
      _StorageCreateDocumentDialogState();
}

final class _StorageCreateDocumentDialogState
    extends State<_StorageCreateDocumentDialog> {
  final ValueNotifier<StorageDocumentFormat> _format = ValueNotifier(
    StorageDocumentFormat.docx,
  );

  @override
  void dispose() {
    _format.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ValueListenableBuilder<StorageDocumentFormat>(
        valueListenable: _format,
        builder: (context, format, _) => AlertDialog(
          title: Text(widget.l10n.storageCreateDocumentDialogTitle),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: widget.controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: widget.l10n.storageDocumentName,
                    hintText: widget.l10n.storageDocumentNameHint,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<StorageDocumentFormat>(
                  initialValue: format,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: widget.l10n.storageDocumentFormat,
                  ),
                  items: StorageDocumentFormat.values
                      .map(
                        (item) => DropdownMenuItem(
                          value: item,
                          child: Text(_formatLabel(item, widget.l10n)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) _format.value = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(widget.l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                final name = widget.controller.text.trim();
                if (name.isNotEmpty) Navigator.pop(context, (name, format));
              },
              child: Text(widget.l10n.storageCreateDocumentButton),
            ),
          ],
        ),
      );

  String _formatLabel(StorageDocumentFormat format, AppLocalizations l10n) =>
      switch (format) {
        StorageDocumentFormat.txt => l10n.storageFormatTxt,
        StorageDocumentFormat.odt => l10n.storageFormatOdt,
        StorageDocumentFormat.ods => l10n.storageFormatOds,
        StorageDocumentFormat.odp => l10n.storageFormatOdp,
        StorageDocumentFormat.docx => l10n.storageFormatDocx,
        StorageDocumentFormat.xlsx => l10n.storageFormatXlsx,
        StorageDocumentFormat.pptx => l10n.storageFormatPptx,
      };
}
