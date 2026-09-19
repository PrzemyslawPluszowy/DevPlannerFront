import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/presentation/storage/browser/cubit/storage_browser_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/shared/storage_formatters.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/upload/cubit/storage_upload_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Pływający panel (Overlay) w prawym dolnym rogu ekranu prezentujący kolejkę uploadu plików.
class StorageUploadQueueOverlay extends StatelessWidget {
  /// Tworzy pływający panel kolejki uploadu.
  const StorageUploadQueueOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StorageUploadCubit, StorageUploadState>(
      builder: (context, state) {
        if (!state.hasItems) {
          return const SizedBox.shrink();
        }

        final l10n = context.l10n;
        final uploadCubit = context.read<StorageUploadCubit>();

        return Positioned(
          right: 24,
          bottom: 24,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: context.colors.surface,
            child: Container(
              width: 360,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: context.colors.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pasek nagłówka okna uploadu
                  InkWell(
                    onTap: uploadCubit.toggleExpanded,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          if (state.isUploading) ...[
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            const SizedBox(width: 10),
                          ],
                          Expanded(
                            child: Text(
                              l10n.storageUploadQueueTitle,
                              style: context.text.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${state.completedCount}/${state.items.length}',
                            style: context.text.labelSmall?.copyWith(
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            state.isExpanded
                                ? AppIcons.chevronDown
                                : AppIcons.chevronUp,
                            size: 18,
                          ),
                          IconButton(
                            icon: const Icon(AppIcons.close, size: 16),
                            tooltip: context.l10n.storageClearCompletedTooltip,
                            padding: .zero,
                            constraints: const BoxConstraints(),
                            onPressed: uploadCubit.clearCompleted,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (state.isExpanded) ...[
                    const Divider(height: 1),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 240),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: state.items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return _UploadItemTile(item: item);
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UploadItemTile extends StatelessWidget {
  const _UploadItemTile({required this.item});

  final StorageUploadQueueItem item;

  @override
  Widget build(BuildContext context) {
    final uploadCubit = context.read<StorageUploadCubit>();
    final browserCubit = context.read<StorageBrowserCubit>();

    return Padding(
      padding: const .symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.input.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.text.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildStatusIcon(context, item, uploadCubit, browserCubit),
            ],
          ),
          const SizedBox(height: 4),
          if (item.status == StorageUploadItemStatus.uploading) ...[
            LinearProgressIndicator(
              value: item.progress > 0 ? item.progress : null,
              minHeight: 3,
            ),
            const SizedBox(height: 4),
          ],
          Text(
            item.status == StorageUploadItemStatus.uploading &&
                    item.totalBytes > 0
                ? '${StorageFormatters.formatBytes(item.bytesSent)} / ${StorageFormatters.formatBytes(item.totalBytes)} (${(item.progress * 100).toStringAsFixed(0)}%)'
                : StorageFormatters.formatBytes(item.input.size),
            style: context.text.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          if (item.errorMessage != null || item.errorCode != null)
            Text(
              _errorMessage(context, item),
              style: context.text.labelSmall?.copyWith(
                color: context.colors.error,
              ),
            ),
        ],
      ),
    );
  }

  String _errorMessage(BuildContext context, StorageUploadQueueItem item) {
    final l10n = context.l10n;
    return switch (item.errorCode) {
      StorageUploadMessage.fileTooLarge => l10n.storageUploadFileTooLarge,
      StorageUploadMessage.cancelledByUser => l10n.storageUploadCancelledByUser,
      StorageUploadMessage.uploadCancelled => l10n.storageUploadCancelled,
      StorageUploadMessage.unsupportedScope =>
        l10n.storageUploadUnsupportedScope,
      StorageUploadMessage.ticketReservationFailed =>
        l10n.storageUploadTicketReservationFailed,
      StorageUploadMessage.transferFailed => l10n.storageUploadTransferFailed,
      StorageUploadMessage.completionFailed =>
        l10n.storageUploadCompletionFailed,
      StorageUploadMessage.placementFailed => l10n.storageUploadPlacementFailed,
      null => item.errorMessage!,
    };
  }

  Widget _buildStatusIcon(
    BuildContext context,
    StorageUploadQueueItem item,
    StorageUploadCubit uploadCubit,
    StorageBrowserCubit browserCubit,
  ) {
    return switch (item.status) {
      StorageUploadItemStatus.queued => const Icon(AppIcons.clock, size: 16),
      StorageUploadItemStatus.uploading => IconButton(
        icon: const Icon(AppIcons.close, size: 14),
        tooltip: context.l10n.storageCancelUploadTooltip,
        padding: .zero,
        constraints: const BoxConstraints(),
        onPressed: () => uploadCubit.cancel(item.id),
      ),
      StorageUploadItemStatus.completing => const SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      StorageUploadItemStatus.done => Icon(
        AppIcons.checkCircle,
        size: 16,
        color: context.colors.primary,
      ),
      StorageUploadItemStatus.failed => IconButton(
        icon: const Icon(AppIcons.refresh, size: 14),
        tooltip: context.l10n.storageRetryUploadTooltip,
        padding: .zero,
        constraints: const BoxConstraints(),
        onPressed: () => uploadCubit.retry(item.id, browserCubit.currentScope),
      ),
      StorageUploadItemStatus.cancelled => Icon(
        AppIcons.slash,
        size: 14,
        color: context.colors.outline,
      ),
    };
  }
}
