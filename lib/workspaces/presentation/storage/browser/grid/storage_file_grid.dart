import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_drag_and_drop.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_open_document_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_preview_action.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/mutations/cubit/storage_file_mutation_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/selection/cubit/storage_selection_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_file_artwork.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/shared/storage_file_context_menu.dart';
import 'package:devplanner/workspaces/presentation/storage/shared/storage_formatters.dart';
import 'package:devplanner/workspaces/presentation/storage/shell/storage_shell_capabilities.dart';
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

    return StorageFileDragSource(
      fileId: file.id,
      label: file.originalFileName,
      enabled: capabilities.canMove && file.canEdit && !file.isDeleted,
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
                    child: StorageFileArtwork(
                      file: file,
                      size: 72,
                      onTap: () => _openFile(context, file),
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
                          Expanded(
                            child: Text(
                              StorageFormatters.formatBytes(file.fileSizeBytes),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.text.labelSmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                          if (capabilities.canFavorite && file.canRead)
                            IconButton(
                              icon: Icon(
                                file.isFavorite
                                    ? AppIcons.star
                                    : Icons.star_border_rounded,
                                size: 16,
                                color: file.isFavorite
                                    ? context.colors.tertiary
                                    : context.colors.onSurfaceVariant,
                              ),
                              tooltip: file.isFavorite
                                  ? context.l10n.storageRemoveFavoriteAction
                                  : context.l10n.storageAddFavoriteAction,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(
                                width: 28,
                                height: 28,
                              ),
                              onPressed: () => unawaited(
                                context
                                    .read<StorageFileMutationCubit>()
                                    .toggleFavorite(file),
                              ),
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

  void _openFile(BuildContext context, StorageFileResponse file) {
    if (file.canEditOnline) {
      unawaited(runStorageOpenOfficeDocument(context, file: file));
    } else {
      _openPreview(context, file);
    }
  }

  void _showFileMenu(BuildContext context, StorageFileResponse file) {
    final box = context.findRenderObject()! as RenderBox;
    StorageFileContextMenu.show(
      context,
      file,
      box.localToGlobal(Offset(0, box.size.height)),
      capabilities: capabilities,
      onOpenFileDetails: onOpenFileDetails,
    );
  }
}
