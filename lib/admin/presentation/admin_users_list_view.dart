import 'package:devplanner/admin/data/admin_users_composition.dart';
import 'package:devplanner/admin/domain/models/admin_user.dart';
import 'package:devplanner/admin/domain/models/admin_user_commands.dart';
import 'package:devplanner/admin/presentation/admin_user_form_dialog.dart';
import 'package:devplanner/admin/presentation/admin_user_roles_dialog.dart';
import 'package:devplanner/admin/presentation/cubit/admin_user_lifecycle_cubit.dart';
import 'package:devplanner/admin/presentation/cubit/admin_user_lifecycle_state.dart';
import 'package:devplanner/admin/presentation/cubit/admin_users_cubit.dart';
import 'package:devplanner/admin/presentation/cubit/admin_users_state.dart';
import 'package:devplanner/core/theme/theme.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Lista kont i cienka kompozycja akcji administracyjnych.
class AdminUsersListView extends StatefulWidget {
  const AdminUsersListView({required this.composition, super.key});

  final AdminUsersComposition composition;

  @override
  State<AdminUsersListView> createState() => _AdminUsersListViewState();
}

class _AdminUsersListViewState extends State<AdminUsersListView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AdminUsersHeader(
          composition: widget.composition,
          searchController: _searchController,
          onSearch: (value) => context.read<AdminUsersCubit>().search(value),
          onRefresh: () => context.read<AdminUsersCubit>().refresh(),
          onCreate: widget.composition.canManageUsers
              ? () => _openCreateDialog(context)
              : null,
        ),
        Gaps.h16,
        Expanded(
          child: BlocBuilder<AdminUsersCubit, AdminUsersState>(
            builder: (context, state) => _AdminUsersBody(
              state: state,
              composition: widget.composition,
              onRetry: () => context.read<AdminUsersCubit>().refresh(),
              onLoadMore: () => context.read<AdminUsersCubit>().loadMore(),
              onEdit: _openEditDialog,
              onRoles: _openRolesDialog,
              onLifecycle: _confirmLifecycle,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openCreateDialog(BuildContext context) async {
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => AdminUserFormDialog(composition: widget.composition),
    );
    if (created == true && context.mounted) {
      await context.read<AdminUsersCubit>().refresh();
    }
  }

  Future<void> _openEditDialog(BuildContext context, AdminUser user) async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (_) => AdminUserFormDialog(
        composition: widget.composition,
        user: user,
      ),
    );
    if (updated == true && context.mounted) {
      await context.read<AdminUsersCubit>().refresh();
    }
  }

  Future<void> _openRolesDialog(BuildContext context, AdminUser user) async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (_) => AdminUserRolesDialog(
        composition: widget.composition,
        user: user,
      ),
    );
    if (updated == true && context.mounted) {
      await context.read<AdminUsersCubit>().refresh();
    }
  }

  Future<void> _confirmLifecycle(
    BuildContext context,
    AdminUser user,
    AdminUserLifecycleAction action,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogContext.l10n.adminUsersConfirmAction),
        content: Text(dialogContext.l10n.adminUsersConfirmActionMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(dialogContext.l10n.adminUsersCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(dialogContext.l10n.adminUsersSave),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final cubit = AdminUserLifecycleCubit(composition: widget.composition);
    await cubit.submit(
      userId: user.userId,
      action: action,
    );
    final state = cubit.state;
    await cubit.close();
    if (!context.mounted) return;
    if (state is AdminUserLifecycleSucceeded) {
      await context.read<AdminUsersCubit>().refresh();
    } else if (state is AdminUserLifecycleFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }
}

class _AdminUsersHeader extends StatelessWidget {
  const _AdminUsersHeader({
    required this.composition,
    required this.searchController,
    required this.onSearch,
    required this.onRefresh,
    this.onCreate,
  });

  final AdminUsersComposition composition;
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final VoidCallback onRefresh;
  final VoidCallback? onCreate;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: Sizes.p12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.adminUsersTitle,
              style: context.text.headlineSmall,
            ),
            Gaps.h4,
            Text(context.l10n.adminUsersSubtitle),
          ],
        ),
        Wrap(
          spacing: Sizes.p8,
          children: [
            SizedBox(
              width: 320,
              child: TextField(
                controller: searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: onSearch,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: context.l10n.adminUsersSearchHint,
                ),
              ),
            ),
            IconButton(
              tooltip: context.l10n.adminUsersRefresh,
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
            ),
            if (onCreate != null)
              FilledButton.icon(
                onPressed: onCreate,
                icon: const Icon(Icons.person_add_outlined),
                label: Text(context.l10n.adminUsersCreate),
              ),
          ],
        ),
      ],
    );
  }
}

class _AdminUsersBody extends StatelessWidget {
  const _AdminUsersBody({
    required this.state,
    required this.composition,
    required this.onRetry,
    required this.onLoadMore,
    required this.onEdit,
    required this.onRoles,
    required this.onLifecycle,
  });

  final AdminUsersState state;
  final AdminUsersComposition composition;
  final VoidCallback onRetry;
  final VoidCallback onLoadMore;
  final Future<void> Function(BuildContext context, AdminUser user) onEdit;
  final Future<void> Function(BuildContext context, AdminUser user) onRoles;
  final Future<void> Function(
    BuildContext context,
    AdminUser user,
    AdminUserLifecycleAction action,
  )
  onLifecycle;

  @override
  Widget build(BuildContext context) => switch (state) {
    AdminUsersInitial() || AdminUsersLoading() => const Center(
      child: CircularProgressIndicator(),
    ),
    AdminUsersFailure(:final message, :final previousUsers) =>
      previousUsers.isEmpty
          ? _FailureView(message: message, onRetry: onRetry)
          : _UsersList(
              users: previousUsers,
              composition: composition,
              onLoadMore: onLoadMore,
              onEdit: onEdit,
              onRoles: onRoles,
              onLifecycle: onLifecycle,
            ),
    AdminUsersReady(:final users, :final nextCursor, :final isLoadingMore) =>
      users.isEmpty
          ? const _EmptyUsersView()
          : _UsersList(
              users: users,
              hasMore: nextCursor != null,
              isLoadingMore: isLoadingMore,
              composition: composition,
              onLoadMore: onLoadMore,
              onEdit: onEdit,
              onRoles: onRoles,
              onLifecycle: onLifecycle,
            ),
  };
}

class _UsersList extends StatelessWidget {
  const _UsersList({
    required this.users,
    required this.composition,
    required this.onLoadMore,
    required this.onEdit,
    required this.onRoles,
    required this.onLifecycle,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final List<AdminUser> users;
  final AdminUsersComposition composition;
  final VoidCallback onLoadMore;
  final Future<void> Function(BuildContext context, AdminUser user) onEdit;
  final Future<void> Function(BuildContext context, AdminUser user) onRoles;
  final Future<void> Function(
    BuildContext context,
    AdminUser user,
    AdminUserLifecycleAction action,
  )
  onLifecycle;
  final bool hasMore;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: users.length + (hasMore ? 1 : 0),
      separatorBuilder: (_, _) => Gaps.h8,
      itemBuilder: (context, index) {
        if (index == users.length) {
          return Center(
            child: isLoadingMore
                ? const CircularProgressIndicator()
                : OutlinedButton(
                    onPressed: onLoadMore,
                    child: Text(context.l10n.adminUsersRetry),
                  ),
          );
        }
        final user = users[index];
        return _AdminUserTile(
          user: user,
          composition: composition,
          onEdit: onEdit,
          onRoles: onRoles,
          onLifecycle: onLifecycle,
        );
      },
    );
  }
}

class _AdminUserTile extends StatelessWidget {
  const _AdminUserTile({
    required this.user,
    required this.composition,
    required this.onEdit,
    required this.onRoles,
    required this.onLifecycle,
  });

  final AdminUser user;
  final AdminUsersComposition composition;
  final Future<void> Function(BuildContext context, AdminUser user) onEdit;
  final Future<void> Function(BuildContext context, AdminUser user) onRoles;
  final Future<void> Function(
    BuildContext context,
    AdminUser user,
    AdminUserLifecycleAction action,
  )
  onLifecycle;

  @override
  Widget build(BuildContext context) {
    final canManage = composition.canManageUsers;
    final isSelf = user.userId == composition.currentUserId;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.p16),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: Sizes.p12,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 260, maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.displayName, style: context.text.titleMedium),
                  Gaps.h4,
                  Text('${user.login} · ${user.email}'),
                  Gaps.h8,
                  Wrap(
                    spacing: Sizes.p8,
                    runSpacing: Sizes.p4,
                    children: [
                      Chip(label: Text(_statusLabel(context, user.status))),
                      ...user.roles.map((role) => Chip(label: Text(role))),
                    ],
                  ),
                ],
              ),
            ),
            if (canManage)
              Wrap(
                spacing: Sizes.p4,
                children: [
                  IconButton(
                    tooltip: context.l10n.adminUsersEditTitle,
                    onPressed: () => onEdit(context, user),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  IconButton(
                    tooltip: context.l10n.adminUsersRoleSave,
                    onPressed: () => onRoles(context, user),
                    icon: const Icon(Icons.admin_panel_settings_outlined),
                  ),
                  if (!isSelf && user.status != AdminUserStatus.deactivated)
                    IconButton(
                      tooltip: context.l10n.adminUsersDeactivate,
                      onPressed: () => onLifecycle(
                        context,
                        user,
                        AdminUserLifecycleAction.deactivate,
                      ),
                      icon: const Icon(Icons.person_off_outlined),
                    ),
                  if (!isSelf && user.status == AdminUserStatus.deactivated)
                    IconButton(
                      tooltip: context.l10n.adminUsersReactivate,
                      onPressed: () => onLifecycle(
                        context,
                        user,
                        AdminUserLifecycleAction.reactivate,
                      ),
                      icon: const Icon(Icons.person_add_alt_1_outlined),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(BuildContext context, AdminUserStatus status) =>
      switch (status) {
        AdminUserStatus.pendingActivation =>
          context.l10n.adminUsersStatusPendingActivation,
        AdminUserStatus.active => context.l10n.adminUsersStatusActive,
        AdminUserStatus.deactivated => context.l10n.adminUsersStatusDeactivated,
        AdminUserStatus.locked => context.l10n.adminUsersStatusLocked,
      };
}

class _EmptyUsersView extends StatelessWidget {
  const _EmptyUsersView();

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.people_outline, size: 42),
        Gaps.h12,
        Text(context.l10n.adminUsersEmptyTitle, style: context.text.titleLarge),
        Gaps.h4,
        Text(context.l10n.adminUsersEmptyMessage),
      ],
    ),
  );
}

class _FailureView extends StatelessWidget {
  const _FailureView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, size: 42),
        Gaps.h12,
        Text(
          context.l10n.adminUsersLoadFailureTitle,
          style: context.text.titleLarge,
        ),
        Gaps.h4,
        Text(message, textAlign: TextAlign.center),
        Gaps.h12,
        FilledButton(
          onPressed: onRetry,
          child: Text(context.l10n.adminUsersRetry),
        ),
      ],
    ),
  );
}
