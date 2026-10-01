import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_error_banner.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/chrome/storage_folder_picker_cubit.dart';
import 'package:flutter/material.dart';

/// Lista i diagnostyka folderów, przewijane niezależnie od akcji dialogu.
final class StorageFolderPickerContent extends StatelessWidget {
  const StorageFolderPickerContent({
    required this.state,
    required this.disabledFolderIds,
    required this.onOpen,
    required this.onRetry,
    super.key,
  });

  final StorageFolderPickerState state;
  final Set<String> disabledFolderIds;
  final ValueChanged<StorageFolderResponse> onOpen;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    if (state.loading) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    final error = state.error;
    if (error != null) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StorageErrorBanner(
              message: error.message,
              code: error.contractCode ?? error.apiCode,
              traceId: error.traceId,
              retryAfterUtc: error.retryAfterUtc,
              onRetry: onRetry,
              onRefresh: onRetry,
            ),
            if (error.statusCode != null)
              Text('HTTP ${error.statusCode}', style: common.metaText),
            for (final field in error.fields.entries)
              Padding(
                padding: EdgeInsets.only(top: common.tightGap),
                child: Text(
                  '${field.key}: ${field.value.join('; ')}',
                  style: common.dataText.copyWith(color: colors.onSurface),
                ),
              ),
          ],
        ),
      );
    }
    if (state.folders.isEmpty) {
      return Center(
        child: Text(
          context.l10n.storageMoveDialogNoSubfolders,
          textAlign: TextAlign.center,
          style: common.dataText.copyWith(color: colors.onSurfaceVariant),
        ),
      );
    }
    return ListView.builder(
      itemCount: state.folders.length,
      itemBuilder: (context, index) => _FolderRow(
        folder: state.folders[index],
        disabled: disabledFolderIds.contains(state.folders[index].id),
        onOpen: onOpen,
      ),
    );
  }
}

final class _FolderRow extends StatelessWidget {
  const _FolderRow({
    required this.folder,
    required this.disabled,
    required this.onOpen,
  });

  final StorageFolderResponse folder;
  final bool disabled;
  final ValueChanged<StorageFolderResponse> onOpen;

  void _open() => onOpen(folder);

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final colors = context.colors;
    return ListTile(
      key: ValueKey('storage_picker_folder-${folder.id}'),
      dense: true,
      enabled: !disabled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(common.controlRadius),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: common.controlGap),
      leading: const Icon(AppIcons.folder, size: 18),
      title: Text(
        folder.name,
        style: common.dataText.copyWith(color: colors.onSurface),
      ),
      subtitle: folder.itemCount > 0
          ? Text(
              context.l10n.storageItemsCount(folder.itemCount),
              style: common.metaText.copyWith(color: colors.onSurfaceVariant),
            )
          : null,
      trailing: disabled ? null : const Icon(AppIcons.chevronRight, size: 16),
      onTap: disabled ? null : _open,
    );
  }
}
