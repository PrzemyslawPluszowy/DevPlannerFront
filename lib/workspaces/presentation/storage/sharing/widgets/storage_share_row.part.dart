part of 'storage_sharing_dialog.dart';

class _StorageShareRow extends StatelessWidget {
  const _StorageShareRow({required this.share});

  final StorageFileShareResponse share;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final typeLabel = switch (share.shareType) {
      StorageShareType.user => l10n.storageShareUserLabel(
        share.sharedWithUserId ?? '-',
      ),
      StorageShareType.workspace => l10n.storageShareWorkspaceLabel(
        share.sharedWithWorkspaceId ?? '-',
      ),
      StorageShareType.project => l10n.storageShareProjectLabel(
        share.sharedWithProjectId ?? '-',
      ),
      StorageShareType.publicLink =>
        '${l10n.storagePublicLinkTitle} (${share.shareToken != null && share.shareToken!.length >= 8 ? share.shareToken!.substring(0, 8) : ''}...)',
    };

    final levelLabel = switch (share.accessLevel) {
      StorageShareAccessLevel.read ||
      StorageShareAccessLevel.reader => l10n.storageAccessReader,
      StorageShareAccessLevel.commenter => l10n.storageAccessCommenter,
      StorageShareAccessLevel.write ||
      StorageShareAccessLevel.editor => l10n.storageAccessEditor,
      StorageShareAccessLevel.owner => l10n.storageAccessOwner,
    };

    return ListTile(
      dense: true,
      contentPadding: .zero,
      leading: Icon(
        share.shareType == StorageShareType.publicLink
            ? AppIcons.link
            : AppIcons.user,
        size: 18,
      ),
      title: Text(typeLabel, style: context.text.bodyMedium),
      subtitle: Text(
        l10n.storageShareAccessLabel(levelLabel),
        style: context.text.bodySmall,
      ),
      trailing: IconButton(
        icon: const Icon(AppIcons.delete, size: 18),
        tooltip: l10n.storageRemoveShareTooltip,
        color: context.colors.error,
        onPressed: () {
          unawaited(context.read<StorageSharingCubit>().revokeShare(share.id));
        },
      ),
    );
  }
}
