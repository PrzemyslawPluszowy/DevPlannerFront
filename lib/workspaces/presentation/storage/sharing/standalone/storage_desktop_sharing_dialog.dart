import 'dart:async';

import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/presentation/devplanner_modal_host.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:devplanner/workspaces/data/storage/transport/public_share_link_builder_impl.dart';
import 'package:devplanner/workspaces/domain/repositories/storage_repository.dart';
import 'package:devplanner/workspaces/domain/storage/ports/public_share_link_builder.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/standalone/storage_public_share_form.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_share_list.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_share_people_section.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_share_targets.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_sharing_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Desktopowy dialog udostępniania oparty na portach kompozycji Storage.
final class StorageDesktopSharingDialog extends StatelessWidget {
  const StorageDesktopSharingDialog({
    required this.file,
    required this.repository,
    this.userDirectory,
    this.onMutationConfirmed,
    this.publicShareLinkBuilder,
    super.key,
  });

  final StorageFileResponse file;
  final StorageRepository repository;
  final StorageUserDirectoryPort? userDirectory;
  final Future<void> Function()? onMutationConfirmed;
  final PublicShareLinkBuilder? publicShareLinkBuilder;

  static Future<void> show(
    BuildContext context, {
    required StorageFileResponse file,
    required StorageRepository repository,
    StorageUserDirectoryPort? userDirectory,
    Future<void> Function()? onMutationConfirmed,
    PublicShareLinkBuilder? publicShareLinkBuilder,
  }) => DevPlannerModalHost.showDialog<void>(
    context,
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
    key: ValueKey((
      file.id,
      file.version,
      file.workspaceId,
      file.projectId,
      ObjectKey(repository),
      ObjectKey(userDirectory),
      ObjectKey(publicShareLinkBuilder),
      ObjectKey(onMutationConfirmed),
    )),
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

final class _StorageDesktopSharingView extends StatefulWidget {
  const _StorageDesktopSharingView({
    required this.file,
    required this.userDirectory,
    required this.publicShareLinkBuilder,
  });

  final StorageFileResponse file;
  final StorageUserDirectoryPort? userDirectory;
  final PublicShareLinkBuilder publicShareLinkBuilder;

  @override
  State<_StorageDesktopSharingView> createState() =>
      _StorageDesktopSharingViewState();
}

final class _StorageDesktopSharingViewState
    extends State<_StorageDesktopSharingView> {
  Future<StoragePublicShareCreation> _createPublicLink(
    String? password,
    DateTime? expiresAtUtc,
  ) async {
    final source = context.read<StorageSharingCubit>();
    final token = await source.createPublicLink(
      accessLevel: StorageShareAccessLevel.reader,
      password: password,
      expiresAtUtc: expiresAtUtc,
    );
    if (!mounted ||
        !context.mounted ||
        source.isClosed ||
        !identical(context.read<StorageSharingCubit>(), source)) {
      return (url: null, error: null, apiError: null);
    }
    if (token == null) {
      return (
        url: null,
        error: null,
        apiError: null,
      );
    }
    return widget.publicShareLinkBuilder.build(token).fold(
      (error) {
        unawaited(source.revokeShareToken(token));
        return (url: null, error: null, apiError: error);
      },
      (url) => (url: url, error: null, apiError: null),
    );
  }

  void _refreshShares() {
    unawaited(context.read<StorageSharingCubit>().loadShares());
  }

  void _close() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    final maxHeight = (MediaQuery.sizeOf(context).height - 32).clamp(
      320.0,
      760.0,
    );
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: common.canvas,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(common.panelRadius),
        side: BorderSide(color: common.canvasBorder),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 680, maxHeight: maxHeight),
        child: Padding(
          padding: EdgeInsets.all(common.sectionGap),
          child: Column(
            children: [
              _SharingDialogHeader(
                title: context.l10n.storageShareTitle(
                  widget.file.originalFileName,
                ),
                onClose: _close,
              ),
              SizedBox(height: common.controlGap),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: (maxHeight * .32).clamp(112.0, 220.0),
                ),
                child: const SingleChildScrollView(
                  child: StorageSharingFeedback(),
                ),
              ),
              SizedBox(height: common.controlGap),
              Expanded(
                child: SingleChildScrollView(
                  child: _StorageSharingContent(
                    file: widget.file,
                    userDirectory: widget.userDirectory,
                    onCreatePublicLink: _createPublicLink,
                    onRefresh: _refreshShares,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _SharingDialogHeader extends StatelessWidget {
  const _SharingDialogHeader({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    return Row(
      children: [
        Icon(AppIcons.share, color: context.colors.primary),
        SizedBox(width: common.controlGap),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: common.projectTitleText,
          ),
        ),
        IconButton(
          tooltip: context.l10n.close,
          onPressed: onClose,
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}

final class _StorageSharingContent extends StatelessWidget {
  const _StorageSharingContent({
    required this.file,
    required this.userDirectory,
    required this.onCreatePublicLink,
    required this.onRefresh,
  });

  final StorageFileResponse file;
  final StorageUserDirectoryPort? userDirectory;
  final Future<StoragePublicShareCreation> Function(
    String?,
    DateTime?,
  )
  onCreatePublicLink;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final common = context.filesTheme.common;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SharingSectionTitle(context.l10n.storageSharePeopleSection),
        SizedBox(height: common.tightGap * 2),
        StorageSharePeopleSection(
          workspaceId: file.workspaceId,
          userDirectory: userDirectory,
        ),
        SizedBox(height: common.sectionGap),
        _SharingSectionTitle(context.l10n.storageShareWorkspaceSection),
        SizedBox(height: common.tightGap * 2),
        StorageShareTargets(file: file),
        SizedBox(height: common.sectionGap),
        _SharingSectionTitle(context.l10n.storageShareLinkSection),
        SizedBox(height: common.tightGap * 2),
        BlocBuilder<StorageSharingCubit, StorageSharingState>(
          builder: (context, state) => StoragePublicShareForm.detailed(
            enabled:
                state is StorageSharingReady &&
                context.read<StorageSharingCubit>().canMutate,
            onCreateDetailed: onCreatePublicLink,
            onRefresh: onRefresh,
          ),
        ),
        SizedBox(height: common.sectionGap),
        _SharingSectionTitle(context.l10n.storageActiveShares),
        SizedBox(height: common.tightGap * 2),
        const StorageShareList(),
      ],
    );
  }
}

final class _SharingSectionTitle extends StatelessWidget {
  const _SharingSectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.filesTheme.common.controlText.copyWith(
      color: context.colors.onSurfaceVariant,
    ),
  );
}
