import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// One version row with its capability-gated actions.
final class StorageVersionListRow extends StatelessWidget {
  const StorageVersionListRow({
    required this.version,
    required this.currentVersion,
    required this.isBusy,
    required this.canPreview,
    required this.canDownload,
    required this.canRestore,
    required this.canDelete,
    required this.onPreview,
    required this.onDownload,
    required this.onRestore,
    required this.onDelete,
    super.key,
  });

  final StorageFileVersionResponse version;
  final int currentVersion;
  final bool isBusy;
  final bool canPreview;
  final bool canDownload;
  final bool canRestore;
  final bool canDelete;
  final VoidCallback onPreview;
  final VoidCallback onDownload;
  final VoidCallback onRestore;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: const Icon(AppIcons.documentText),
    title: Text(context.l10n.storageVersionLabel(version.version)),
    subtitle: Text(
      '${DateFormat.yMMMd().add_Hm().format(version.createdAtUtc.toLocal())}\n'
      '${context.l10n.storageVersionAuthor(version.changedByDisplayName ?? context.l10n.storageVersionAuthorUnknown)}'
      '${version.changeSummary == null ? '' : '\n${version.changeSummary}'}',
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    ),
    trailing: isBusy
        ? const CircularProgressIndicator.adaptive()
        : Wrap(
            children: [
              if (canPreview)
                IconButton(
                  key: ValueKey('preview-version-${version.version}'),
                  icon: const Icon(Icons.visibility_outlined),
                  tooltip: context.l10n.storageVersionPreviewAction,
                  onPressed: onPreview,
                ),
              if (canDownload)
                IconButton(
                  icon: const Icon(AppIcons.download),
                  tooltip: context.l10n.storageDownloadAction,
                  onPressed: onDownload,
                ),
              if (canRestore && version.version != currentVersion)
                IconButton(
                  key: ValueKey('restore-version-${version.version}'),
                  icon: const Icon(AppIcons.refresh),
                  tooltip: context.l10n.storageRestoreSelected,
                  onPressed: onRestore,
                ),
              if (canDelete && version.version != currentVersion)
                IconButton(
                  key: ValueKey('delete-version-${version.version}'),
                  icon: Icon(AppIcons.delete, color: context.colors.error),
                  tooltip: context.l10n.storageVersionDeleteAction,
                  onPressed: onDelete,
                ),
            ],
          ),
  );
}
