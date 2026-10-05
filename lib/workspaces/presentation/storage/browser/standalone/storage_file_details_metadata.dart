import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_extended_models.dart';
import 'package:devplanner/workspaces/presentation/storage/shared/storage_formatters.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Czytelny snapshot pliku; prawa pochodzą ze świeżej odpowiedzi serwera.
final class StorageFileDetailsMetadata extends StatelessWidget {
  const StorageFileDetailsMetadata({required this.details, super.key});

  final StorageFileDetailsResponse details;

  @override
  Widget build(BuildContext context) {
    final file = details.file;
    final l10n = context.l10n;
    final date = DateFormat.yMMMd(l10n.localeName).add_Hm();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          file.originalFileName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          file.manualDescription?.trim().isNotEmpty ?? false
              ? file.manualDescription!
              : l10n.storageFileNoDescription,
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 24,
          runSpacing: 16,
          children: [
            _FileProperty(
              label: l10n.storageFileFormat,
              value: file.extension.isEmpty
                  ? l10n.storageFileFormatUnknown
                  : file.extension.replaceAll('.', '').toUpperCase(),
            ),
            _FileProperty(
              label: l10n.storageFileSize,
              value: StorageFormatters.formatBytes(file.fileSizeBytes),
            ),
            _FileProperty(
              label: l10n.storageFileVersion,
              value: '${file.version}',
            ),
            _FileProperty(
              label: l10n.storageFileCreatedAt,
              value: date.format(file.createdAtUtc.toLocal()),
            ),
            _FileProperty(
              label: l10n.storageFileUpdatedAt,
              value: date.format(file.updatedAtUtc.toLocal()),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          l10n.storageFilePermissions,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 24,
          runSpacing: 16,
          children: [
            _FilePermission(
              label: l10n.storageFileReadPermission,
              allowed: details.permissions.canRead,
            ),
            _FilePermission(
              label: l10n.storageFileEditPermission,
              allowed: details.canEdit,
            ),
            _FilePermission(
              label: l10n.storageFileSharePermission,
              allowed: details.permissions.canShare,
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

final class _FileProperty extends StatelessWidget {
  const _FileProperty({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 220,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 4),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ),
  );
}

final class _FilePermission extends StatelessWidget {
  const _FilePermission({required this.label, required this.allowed});
  final String label;
  final bool allowed;

  @override
  Widget build(BuildContext context) => _FileProperty(
    label: label,
    value: allowed
        ? context.l10n.storagePermissionAllowed
        : context.l10n.storagePermissionUnavailable,
  );
}

/// Historia nie ujawnia UUID autorów, gdy backend nie dostarczył ich nazw.
final class StorageFileDetailsHistory extends StatelessWidget {
  const StorageFileDetailsHistory({required this.details, super.key});
  final StorageFileDetailsResponse details;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        context.l10n.storageVersionsTitle,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 12),
      if (details.versions.isEmpty) Text(context.l10n.storageVersionsEmpty),
      for (final version in details.versions)
        _FileVersionRow(version: version, currentVersion: details.file.version),
    ],
  );
}

final class _FileVersionRow extends StatelessWidget {
  const _FileVersionRow({required this.version, required this.currentVersion});
  final StorageFileVersionResponse version;
  final int currentVersion;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = DateFormat.yMMMd(l10n.localeName)
        .add_Hm()
        .format(version.createdAtUtc.toLocal());
    final name = version.changedByDisplayName;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 4,
            children: [
              Text(
                l10n.storageVersionLabel(version.version),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (version.version == currentVersion)
                Text(
                  l10n.storageVersionCurrent,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$date · ${l10n.storageVersionAuthor(name?.trim().isNotEmpty ?? false ? name! : l10n.storageVersionAuthorUnknown)}',
          ),
          const SizedBox(height: 4),
          Text(
            version.changeSummary?.trim().isNotEmpty ?? false
                ? version.changeSummary!
                : l10n.storageVersionNoSummary,
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
        ],
      ),
    );
  }
}
