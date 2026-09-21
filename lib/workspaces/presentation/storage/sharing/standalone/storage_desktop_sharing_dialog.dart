import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_models.dart';
import 'package:devplanner/workspaces/data/storage/transport/public_share_link_builder_impl.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/public_share_link_builder.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/standalone/storage_public_share_form.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_share_people_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Desktopowy dialog udostępniania oparty wyłącznie na kontrakcie Storage.
///
/// Jeden dialog obsługuje cztery tryby: osobę z lokalnego katalogu, workspace
/// pliku, projekt pliku oraz link publiczny. Katalog osób jest portem z
/// composition rootu — dialog jest montowany na rootowym overlayu, więc nie może
/// czytać portów z drzewa modułu.
final class StorageDesktopSharingDialog extends StatelessWidget {
  /// Tworzy dialog udostępniania pliku.
  const StorageDesktopSharingDialog({
    required this.file,
    required this.repository,
    this.userDirectory,
    this.onMutationConfirmed,
    this.publicShareLinkBuilder,
    super.key,
  });

  /// Plik podlegający ACL.
  final StorageFileResponse file;

  /// Repozytorium Storage z desktop composition root.
  final StorageRepository repository;

  /// Lokalny katalog użytkowników; brak portu wyłącza tryb udostępniania osobie.
  final StorageUserDirectoryPort? userDirectory;

  /// Callback odświeżający browser po udanej mutacji.
  final Future<void> Function()? onMutationConfirmed;

  /// Buduje link bez ujawniania ticketu downloadu.
  final PublicShareLinkBuilder? publicShareLinkBuilder;

  /// Otwiera dialog dla pliku z `canShare == true`.
  static Future<void> show(
    BuildContext context, {
    required StorageFileResponse file,
    required StorageRepository repository,
    StorageUserDirectoryPort? userDirectory,
    Future<void> Function()? onMutationConfirmed,
    PublicShareLinkBuilder? publicShareLinkBuilder,
  }) => showDialog<void>(
    context: context,
    builder: (_) => StorageDesktopSharingDialog(
      file: file,
      repository: repository,
      userDirectory: userDirectory,
      onMutationConfirmed: onMutationConfirmed,
      publicShareLinkBuilder: publicShareLinkBuilder,
    ),
  );

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) {
      final cubit = StorageSharingCubit(
        fileId: file.id,
        repository: repository,
        onMutationConfirmed: onMutationConfirmed,
      );
      unawaited(cubit.loadShares());
      return cubit;
    },
    child: _StorageDesktopSharingView(
      file: file,
      userDirectory: userDirectory,
      publicShareLinkBuilder:
          publicShareLinkBuilder ?? const PublicShareLinkBuilderImpl(),
    ),
  );
}

final class _StorageDesktopSharingView extends StatelessWidget {
  const _StorageDesktopSharingView({
    required this.file,
    required this.userDirectory,
    required this.publicShareLinkBuilder,
  });

  final StorageFileResponse file;
  final StorageUserDirectoryPort? userDirectory;
  final PublicShareLinkBuilder publicShareLinkBuilder;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Row(
      children: [
        Icon(AppIcons.share, color: context.colors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            context.l10n.storageShareTitle(file.originalFileName),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
    content: ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 600),
      child: SingleChildScrollView(
        child: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(context.l10n.storageSharePeopleSection),
              const SizedBox(height: 8),
              StorageSharePeopleSection(
                workspaceId: file.workspaceId,
                userDirectory: userDirectory,
              ),
              const SizedBox(height: 20),
              _SectionTitle(context.l10n.storageShareWorkspaceSection),
              const SizedBox(height: 8),
              _ShareTargets(file: file),
              const SizedBox(height: 20),
              _SectionTitle(context.l10n.storageShareLinkSection),
              const SizedBox(height: 8),
              StoragePublicShareForm(
                onCreate: (password, expiresAtUtc) async {
                  final token = await context
                      .read<StorageSharingCubit>()
                      .createPublicLink(
                        accessLevel: StorageShareAccessLevel.reader,
                        password: password,
                        expiresAtUtc: expiresAtUtc,
                      );
                  if (token == null || !context.mounted) return null;
                  return publicShareLinkBuilder.build(token).fold(
                    (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.message)),
                      );
                      return null;
                    },
                    (url) => url,
                  );
                },
              ),
              const SizedBox(height: 20),
              _SectionTitle(context.l10n.storageActiveShares),
              const SizedBox(height: 8),
              const SizedBox(height: 280, child: _ShareList()),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(context.l10n.close),
      ),
    ],
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.text.titleSmall?.copyWith(fontWeight: FontWeight.w600),
  );
}

final class _ShareTargets extends StatelessWidget {
  const _ShareTargets({required this.file});

  final StorageFileResponse file;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      if (file.workspaceId case final workspaceId?)
        _ShareTargetButton(
          key: const ValueKey('share-workspace'),
          label: context.l10n.storageShareWorkspaceLabel(workspaceId),
          onPressed: () =>
              context.read<StorageSharingCubit>().shareWithWorkspace(
                workspaceId: workspaceId,
                accessLevel: StorageShareAccessLevel.reader,
              ),
        ),
      if (file.projectId case final projectId?)
        _ShareTargetButton(
          key: const ValueKey('share-project'),
          label: context.l10n.storageShareProjectLabel(projectId),
          onPressed: () => context.read<StorageSharingCubit>().shareWithProject(
            projectId: projectId,
            accessLevel: StorageShareAccessLevel.reader,
          ),
        ),
    ],
  );
}

final class _ShareTargetButton extends StatelessWidget {
  const _ShareTargetButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Future<bool> Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    icon: const Icon(AppIcons.share, size: 16),
    label: Text(label),
    onPressed: () async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(context.l10n.storageShareAction),
          content: Text(label),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(context.l10n.storageShareAction),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;
      final success = await onPressed();
      if (!context.mounted || success) return;
      _showMutationError(context);
    },
  );

  void _showMutationError(BuildContext context) {
    final state = context.read<StorageSharingCubit>().state;
    if (state case StorageSharingFailure(:final message)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }
}

final class _ShareList extends StatelessWidget {
  const _ShareList();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageSharingCubit, StorageSharingState>(
        builder: (context, state) => switch (state) {
          StorageSharingInitial() || StorageSharingLoading() => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          StorageSharingFailure(:final message) => Center(child: Text(message)),
          StorageSharingReady(:final shares) =>
            shares.isEmpty
                ? Center(child: Text(context.l10n.storageNoActiveShares))
                : ListView.separated(
                    itemCount: shares.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) =>
                        _ShareRow(share: shares[index]),
                  ),
        },
      );
}

final class _ShareRow extends StatelessWidget {
  const _ShareRow({required this.share});

  final StorageFileShareResponse share;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    contentPadding: EdgeInsets.zero,
    leading: Icon(
      share.shareType == StorageShareType.project
          ? AppIcons.folder
          : AppIcons.share,
    ),
    title: Text(_targetLabel(context)),
    subtitle: Text(
      context.l10n.storageShareAccessLabel(share.accessLevel.name),
    ),
    trailing: IconButton(
      tooltip: context.l10n.storageRemoveShareTooltip,
      icon: const Icon(AppIcons.delete),
      onPressed: () => _revoke(context),
    ),
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

  Future<void> _revoke(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.storageDeleteConfirmTitle),
        content: Text(context.l10n.storageDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final success = await context.read<StorageSharingCubit>().revokeShare(
      share.id,
    );
    if (!context.mounted || success) return;
    final state = context.read<StorageSharingCubit>().state;
    if (state case StorageSharingFailure(:final message)) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }
}
