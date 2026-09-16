import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/app/shell/overlay/app_modal_host.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/shared/presentation/icons/app_icons.dart';
import 'package:ready_next/workspaces/data/shared/enums/storage_enums.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_contract_models.dart';
import 'package:ready_next/workspaces/data/storage/models/storage_models.dart';
import 'package:ready_next/workspaces/data/storage/transport/public_share_link_builder_impl.dart';
import 'package:ready_next/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:ready_next/workspaces/domain/repositories/storage_repository.dart';
import 'package:ready_next/workspaces/domain/repositories/workspaces_repository.dart';
import 'package:ready_next/workspaces/domain/storage/ports/public_share_link_builder.dart';
import 'package:ready_next/workspaces/presentation/storage/sharing/cubit/storage_sharing_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';
import 'package:ready_next/workspaces/presentation/storage/sharing/user_search/cubit/storage_user_search_cubit.dart';
import 'package:ready_next/workspaces/presentation/storage/sharing/user_search/cubit/storage_user_search_state.dart';
import 'package:ready_next/workspaces/presentation/storage/sharing/widgets/storage_public_link_form.dart';

part 'storage_share_row.part.dart';

/// Modalny dialog zarządzania udostępnieniem pliku.
class StorageSharingDialog extends StatelessWidget {
  /// Tworzy dialog udostępniania dla wskazanego pliku.
  const StorageSharingDialog({
    required this.file,
    this.repository,
    this.workspacesRepository,
    this.publicShareLinkBuilder,
    super.key,
  });

  /// Plik, którego dotyczy udostępnienie.
  final StorageFileResponse file;

  /// Opcjonalne repozytorium (domyślnie z kontekstu).
  final StorageRepository? repository;

  /// Optional Ready directory repository, injectable in tests.
  final WorkspacesRepository? workspacesRepository;

  /// Optional public URL builder, injectable in tests.
  final PublicShareLinkBuilder? publicShareLinkBuilder;

  /// Wyświetla dialog udostępniania w aplikacji.
  static Future<void> show(
    BuildContext context, {
    required StorageFileResponse file,
  }) {
    return AppModalHost.showDialog<void>(
      context,
      builder: (_) => StorageSharingDialog(file: file),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = repository ?? context.read<StorageRepository>();
    final directory =
        workspacesRepository ?? context.read<WorkspacesRepository>();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = StorageSharingCubit(
              fileId: file.id,
              repository: repo,
            );
            unawaited(cubit.loadShares());
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) => StorageUserSearchCubit(
            workspaceId: file.workspaceId,
            repository: directory,
          ),
        ),
      ],
      child: _StorageSharingDialogView(
        file: file,
        publicShareLinkBuilder:
            publicShareLinkBuilder ?? const PublicShareLinkBuilderImpl(),
      ),
    );
  }
}

class _StorageSharingDialogView extends StatefulWidget {
  const _StorageSharingDialogView({
    required this.file,
    required this.publicShareLinkBuilder,
  });

  final StorageFileResponse file;
  final PublicShareLinkBuilder publicShareLinkBuilder;

  @override
  State<_StorageSharingDialogView> createState() =>
      _StorageSharingDialogViewState();
}

class _StorageSharingDialogViewState extends State<_StorageSharingDialogView> {
  final _userInputController = TextEditingController();
  ReadyDirectoryUserResponse? _selectedUser;
  StorageShareAccessLevel _selectedLevel = StorageShareAccessLevel.reader;

  @override
  void dispose() {
    _userInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 680),
        child: Padding(
          padding: const .all(24),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Icon(AppIcons.share, size: 22, color: context.colors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.storageShareTitle(widget.file.originalFileName),
                      style: context.text.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(AppIcons.close, size: 20),
                    tooltip: l10n.close,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(height: 24),
              _buildAddUserSection(context),
              const SizedBox(height: 16),
              _buildPublicLinkSection(context),
              const SizedBox(height: 16),
              Text(
                l10n.storageActiveShares,
                style: context.text.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: BlocBuilder<StorageSharingCubit, StorageSharingState>(
                  builder: (context, state) {
                    return switch (state) {
                      StorageSharingInitial() ||
                      StorageSharingLoading() => const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                      StorageSharingFailure(:final message) => Center(
                        child: Text(
                          message,
                          style: TextStyle(color: context.colors.error),
                        ),
                      ),
                      StorageSharingReady(:final shares) =>
                        shares.isEmpty
                            ? Center(
                                child: Text(
                                  l10n.storageNoActiveShares,
                                  style: context.text.bodyMedium?.copyWith(
                                    color: context.colors.onSurfaceVariant,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: shares.length,
                                separatorBuilder: (_, _) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final share = shares[index];
                                  return _StorageShareRow(share: share);
                                },
                              ),
                    };
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddUserSection(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _userInputController,
                onChanged: (value) {
                  setState(() => _selectedUser = null);
                  context.read<StorageUserSearchCubit>().search(value);
                },
                decoration: InputDecoration(
                  hintText: l10n.storageUserInputHint,
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: .circular(8)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            DropdownButton<StorageShareAccessLevel>(
              value: _selectedLevel,
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(
                  value: StorageShareAccessLevel.reader,
                  child: Text(l10n.storageAccessReader),
                ),
                DropdownMenuItem(
                  value: StorageShareAccessLevel.commenter,
                  child: Text(l10n.storageAccessCommenter),
                ),
                DropdownMenuItem(
                  value: StorageShareAccessLevel.editor,
                  child: Text(l10n.storageAccessEditor),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _selectedLevel = val);
              },
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              icon: const Icon(AppIcons.add, size: 16),
              label: Text(l10n.storageAddShareButton),
              onPressed: () {
                final userId = _selectedUser?.coreUserId;
                if (userId == null) return;
                unawaited(
                  context.read<StorageSharingCubit>().shareWithUser(
                    targetUserId: userId,
                    accessLevel: _selectedLevel,
                  ),
                );
                _userInputController.clear();
                setState(() => _selectedUser = null);
                context.read<StorageUserSearchCubit>().search('');
              },
            ),
          ],
        ),
        BlocBuilder<StorageUserSearchCubit, StorageUserSearchState>(
          builder: (context, state) => switch (state) {
            StorageUserSearchInitial() => const SizedBox.shrink(),
            StorageUserSearchUnavailable() => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                l10n.storageUserSearchWorkspaceRequired,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
            StorageUserSearchLoading() => const Padding(
              padding: EdgeInsets.only(top: 8),
              child: LinearProgressIndicator(),
            ),
            StorageUserSearchFailure(:final message) => Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                message,
                style: context.text.bodySmall?.copyWith(
                  color: context.colors.error,
                ),
              ),
            ),
            StorageUserSearchReady(:final users) => ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 180),
              child: users.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(l10n.storageUserSearchNoResults),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          dense: true,
                          leading: CircleAvatar(
                            child: Text(
                              user.displayName.isEmpty
                                  ? '?'
                                  : user.displayName[0].toUpperCase(),
                            ),
                          ),
                          title: Text(user.displayName),
                          subtitle: Text(user.email ?? user.login),
                          selected: _selectedUser == user,
                          onTap: () {
                            setState(() => _selectedUser = user);
                            _userInputController.text = user.displayName;
                          },
                        );
                      },
                    ),
            ),
          },
        ),
      ],
    );
  }

  Widget _buildPublicLinkSection(BuildContext context) {
    return StoragePublicLinkForm(
      onCreate: (password, expiresAtUtc) async {
        final token = await context
            .read<StorageSharingCubit>()
            .createPublicLink(
              accessLevel: StorageShareAccessLevel.reader,
              password: password,
              expiresAtUtc: expiresAtUtc,
            );
        if (token == null || !context.mounted) return null;
        return widget.publicShareLinkBuilder.build(token).fold((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message)),
          );
          return null;
        }, (url) => url);
      },
    );
  }
}
