import 'package:devplanner/admin/data/admin_users_composition.dart';
import 'package:devplanner/admin/domain/models/admin_user.dart';
import 'package:devplanner/admin/presentation/cubit/admin_user_roles_cubit.dart';
import 'package:devplanner/admin/presentation/cubit/admin_user_roles_state.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUserRolesDialog extends StatefulWidget {
  const AdminUserRolesDialog({
    required this.composition,
    required this.user,
    super.key,
  });

  final AdminUsersComposition composition;
  final AdminUser user;

  @override
  State<AdminUserRolesDialog> createState() => _AdminUserRolesDialogState();
}

class _AdminUserRolesDialogState extends State<AdminUserRolesDialog> {
  late Set<String> _roles;

  @override
  void initState() {
    super.initState();
    _roles = widget.user.roles.toSet();
  }

  @override
  Widget build(BuildContext context) {
    final isSelf = widget.user.userId == widget.composition.currentUserId;
    return BlocProvider(
      create: (_) => AdminUserRolesCubit(composition: widget.composition),
      child: BlocConsumer<AdminUserRolesCubit, AdminUserRolesState>(
        listener: (context, state) {
          if (state is AdminUserRolesSucceeded) Navigator.of(context).pop(true);
        },
        builder: (context, state) {
          final submitting = state is AdminUserRolesSubmitting;
          final failure = state is AdminUserRolesFailure ? state : null;
          return AlertDialog(
            title: Text(context.l10n.adminUsersRoles),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  value: _roles.contains(AdminRoleCodes.systemAdmin),
                  onChanged: submitting || isSelf
                      ? null
                      : (value) => _toggle(AdminRoleCodes.systemAdmin, value),
                  title: Text(context.l10n.adminUsersRoleSystemAdmin),
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  value: _roles.contains(AdminRoleCodes.user),
                  onChanged: submitting
                      ? null
                      : (value) => _toggle(AdminRoleCodes.user, value),
                  title: Text(context.l10n.adminUsersRoleUser),
                  contentPadding: EdgeInsets.zero,
                ),
                if (failure != null)
                  Text(
                    failure.isSelfEscalation
                        ? context.l10n.adminUsersSelfRoleBlocked
                        : failure.message ??
                              context.l10n.adminUsersLoadFailureTitle,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: submitting
                    ? null
                    : () => Navigator.of(context).pop(),
                child: Text(context.l10n.adminUsersCancel),
              ),
              FilledButton(
                onPressed: submitting
                    ? null
                    : () => context.read<AdminUserRolesCubit>().save(
                        userId: widget.user.userId,
                        roles: _roles,
                        existingRoles: widget.user.roles,
                      ),
                child: submitting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(context.l10n.adminUsersRoleSave),
              ),
            ],
          );
        },
      ),
    );
  }

  void _toggle(String role, bool? selected) {
    setState(() {
      if (selected ?? false) {
        _roles.add(role);
      } else {
        _roles.remove(role);
      }
    });
  }
}
