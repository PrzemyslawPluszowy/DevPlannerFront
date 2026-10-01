import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:devplanner/foundation/theme/files_theme.dart';
import 'package:devplanner/foundation/theme/theme.dart';
import 'package:devplanner/shared/presentation/icons/app_icons.dart';
import 'package:devplanner/workspaces/data/shared/enums/storage_enums.dart';
import 'package:devplanner/workspaces/data/workspaces/responses/workspace_responses.dart';
import 'package:devplanner/workspaces/domain/storage/ports/storage_user_directory_port.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_share_directory_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_share_directory_state.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_cubit.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/cubit/storage_sharing_state.dart';
import 'package:devplanner/workspaces/presentation/storage/sharing/widgets/storage_share_people_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Sekcja udostępniania osobie z lokalnego katalogu użytkowników.
final class StorageSharePeopleSection extends StatelessWidget {
  const StorageSharePeopleSection({
    required this.workspaceId,
    required this.userDirectory,
    super.key,
  });

  final String? workspaceId;
  final StorageUserDirectoryPort? userDirectory;

  @override
  Widget build(BuildContext context) {
    final workspace = workspaceId;
    final directory = userDirectory;
    if (workspace == null || directory == null) {
      return StorageShareDirectoryNote(
        text: context.l10n.storageUserSearchWorkspaceRequired,
      );
    }
    return BlocProvider(
      key: ValueKey((workspace, identityHashCode(directory))),
      create: (_) => StorageShareDirectoryCubit(
        workspaceId: workspace,
        directory: directory,
      ),
      child: const _StorageSharePeopleForm(),
    );
  }
}

final class _StorageSharePeopleForm extends StatefulWidget {
  const _StorageSharePeopleForm();

  @override
  State<_StorageSharePeopleForm> createState() =>
      _StorageSharePeopleFormState();
}

final class _StorageSharePeopleFormState
    extends State<_StorageSharePeopleForm> {
  final _queryController = TextEditingController();
  LocalUserDirectoryResponse? _selected;
  StorageShareAccessLevel _level = StorageShareAccessLevel.reader;

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() => _selected = null);
    context.read<StorageShareDirectoryCubit>().search(query);
  }

  void _selectUser(LocalUserDirectoryResponse user) {
    setState(() => _selected = user);
  }

  void _selectAccessLevel(Set<StorageShareAccessLevel> selection) {
    if (selection.isEmpty) return;
    setState(() => _level = selection.first);
  }

  Future<void> _shareSelected() async {
    final selected = _selected;
    if (selected == null) return;
    final source = context.read<StorageSharingCubit>();
    if (source.isMutating) return;
    final succeeded = await source.shareWithUser(
      targetUserId: selected.userId,
      accessLevel: _level,
    );
    if (!mounted || !context.mounted || source.isClosed) return;
    if (!identical(context.read<StorageSharingCubit>(), source) || !succeeded) {
      return;
    }
    _queryController.clear();
    context.read<StorageShareDirectoryCubit>().search('');
    setState(() {
      _selected = null;
      _level = StorageShareAccessLevel.reader;
    });
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<StorageShareDirectoryCubit, StorageShareDirectoryState>(
        builder: (context, directoryState) =>
            BlocBuilder<StorageSharingCubit, StorageSharingState>(
              builder: (context, sharingState) {
                final canMutate =
                    sharingState is StorageSharingReady &&
                    context.read<StorageSharingCubit>().canMutate;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      key: const ValueKey('storage_share_user_search'),
                      controller: _queryController,
                      decoration: InputDecoration(
                        labelText: context.l10n.tasksAssigneeSearchPeople,
                        prefixIcon: const Icon(AppIcons.search, size: 16),
                        isDense: true,
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: context.colors.outlineVariant,
                          ),
                          borderRadius: BorderRadius.circular(
                            context.filesTheme.common.controlRadius,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: context.colors.primary),
                          borderRadius: BorderRadius.circular(
                            context.filesTheme.common.controlRadius,
                          ),
                        ),
                      ),
                      onChanged: _onSearchChanged,
                    ),
                    const SizedBox(height: 6),
                    _DirectoryResults(
                      state: directoryState,
                      selectedUserId: _selected?.userId,
                      onSelect: _selectUser,
                    ),
                    if (_selected != null) ...[
                      const SizedBox(height: 8),
                      StorageSharePersonControls(
                        level: _level,
                        isMutating: !canMutate,
                        onLevelChanged: _selectAccessLevel,
                        onShare: _shareSelected,
                      ),
                    ],
                  ],
                );
              },
            ),
      );
}

final class _DirectoryResults extends StatelessWidget {
  const _DirectoryResults({
    required this.state,
    required this.selectedUserId,
    required this.onSelect,
  });

  final StorageShareDirectoryState state;
  final String? selectedUserId;
  final ValueChanged<LocalUserDirectoryResponse> onSelect;

  @override
  Widget build(BuildContext context) => switch (state) {
    StorageShareDirectoryIdle() => const SizedBox.shrink(),
    StorageShareDirectoryLoading() => const LinearProgressIndicator(
      minHeight: 2,
    ),
    StorageShareDirectoryFailure(:final error) => StorageShareDirectoryError(
      error: error,
    ),
    StorageShareDirectoryReady(:final users) =>
      users.isEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                context.l10n.storageUserSearchNoResults,
                style: context.filesTheme.common.dataText.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            )
          : _DirectoryUserList(
              users: users,
              selectedUserId: selectedUserId,
              onSelect: onSelect,
            ),
  };
}

final class _DirectoryUserList extends StatelessWidget {
  const _DirectoryUserList({
    required this.users,
    required this.selectedUserId,
    required this.onSelect,
  });

  final List<LocalUserDirectoryResponse> users;
  final String? selectedUserId;
  final ValueChanged<LocalUserDirectoryResponse>? onSelect;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxHeight: 160),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
      itemBuilder: (context, index) => _DirectoryUserRow(
        user: users[index],
        isSelected: users[index].userId == selectedUserId,
        onSelect: onSelect,
      ),
    ),
  );
}

final class _DirectoryUserRow extends StatelessWidget {
  const _DirectoryUserRow({
    required this.user,
    required this.isSelected,
    required this.onSelect,
  });

  final LocalUserDirectoryResponse user;
  final bool isSelected;
  final ValueChanged<LocalUserDirectoryResponse>? onSelect;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey('storage_share_user-${user.userId}'),
      dense: true,
      selected: isSelected,
      selectedTileColor: context.filesTheme.common.rowSelected,
      hoverColor: context.filesTheme.common.rowHover,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          context.filesTheme.common.controlRadius,
        ),
      ),
      title: Text(
        user.displayName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.filesTheme.common.dataText,
      ),
      subtitle: Text(
        user.login,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.filesTheme.common.metaText.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
      onTap: onSelect == null ? null : () => onSelect!(user),
    );
  }
}
