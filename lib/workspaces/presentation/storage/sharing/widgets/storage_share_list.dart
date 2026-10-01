import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_share_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lista aktywnych grantów; błąd pobierania/mutacji pozostaje nad danymi.
final class StorageShareList extends StatelessWidget {
  const StorageShareList({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageSharingCubit, StorageSharingState>(
        builder: (context, state) => switch (state) {
          StorageSharingInitial() || StorageSharingLoading() => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          StorageSharingFailure() => const SizedBox.shrink(),
          StorageSharingReady(
            :final shares,
            :final isRefreshing,
          ) =>
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isRefreshing) const LinearProgressIndicator(minHeight: 2),
                if (shares.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: context.filesTheme.common.sectionGap,
                    ),
                    child: Text(
                      context.l10n.storageNoActiveShares,
                      style: context.filesTheme.common.dataText.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: shares.length,
                      separatorBuilder: (_, _) => Divider(
                        height: 1,
                        color: context.filesTheme.common.divider,
                      ),
                      itemBuilder: (context, index) => StorageShareRow(
                        share: shares[index],
                      ),
                    ),
                  ),
              ],
            ),
        },
      );
}

final class StorageShareRow extends StatelessWidget {
  const StorageShareRow({required this.share, super.key});

  final StorageFileShareResponse share;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageSharingCubit, StorageSharingState>(
        builder: (context, state) {
          final cubit = context.read<StorageSharingCubit>();
          final common = context.filesTheme.common;
          return ListTile(
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: common.tightGap),
            minLeadingWidth: 24,
            leading: Icon(
              share.shareType == StorageShareType.project
                  ? AppIcons.folder
                  : AppIcons.share,
              size: 18,
              color: context.colors.onSurfaceVariant,
            ),
            title: Text(
              _targetLabel(context),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: common.dataText,
            ),
            subtitle: Text(
              context.l10n.storageShareAccessLabel(share.accessLevel.name),
              style: common.metaText.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            trailing: IconButton(
              tooltip: context.l10n.storageRemoveShareTooltip,
              icon: const Icon(AppIcons.delete),
              onPressed:
                  state is StorageSharingReady &&
                      !state.isMutating &&
                      !state.isRefreshing
                  ? () => _confirmRevoke(context, cubit)
                  : null,
            ),
            hoverColor: common.rowHover,
            selectedTileColor: common.rowSelected,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(common.controlRadius),
            ),
          );
        },
      );

  String _targetLabel(BuildContext context) => switch (share.shareType) {
    StorageShareType.workspace => context.l10n.storageShareWorkspaceLabel(
      share.sharedWithWorkspaceId ?? '-',
    ),
    StorageShareType.project => context.l10n.storageShareProjectLabel(
      share.sharedWithProjectId ?? '-',
    ),
    StorageShareType.publicLink => context.l10n.storagePublicLinkTitle,
    StorageShareType.user => context.l10n.storageShareUserLabel(
      share.sharedWithUserId ?? '-',
    ),
  };

  Future<void> _confirmRevoke(
    BuildContext context,
    StorageSharingCubit source,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => StorageShareConfirmationDialog(
        title: context.l10n.storageDeleteConfirmTitle,
        message: context.l10n.storageDeleteConfirmMessage,
        action: context.l10n.delete,
      ),
    );
    if (!context.mounted ||
        source.isClosed ||
        confirmed != true ||
        !identical(context.read<StorageSharingCubit>(), source)) {
      return;
    }
    await source.revokeShare(share.id);
  }
}
