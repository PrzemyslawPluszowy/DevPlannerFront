import 'dart:async';

import 'package:devplanner/admin/data/admin_users_composition.dart';
import 'package:devplanner/admin/domain/models/admin_user.dart';
import 'package:devplanner/admin/presentation/cubit/admin_user_form_cubit.dart';
import 'package:devplanner/admin/presentation/cubit/admin_user_form_state.dart';
import 'package:devplanner/foundation/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Formularz konta jest lokalnym właścicielem controllerów i Cubita.
class AdminUserFormDialog extends StatefulWidget {
  const AdminUserFormDialog({required this.composition, this.user, super.key});

  final AdminUsersComposition composition;
  final AdminUser? user;

  bool get isEditing => user != null;

  @override
  State<AdminUserFormDialog> createState() => _AdminUserFormDialogState();
}

class _AdminUserFormDialogState extends State<AdminUserFormDialog> {
  late final TextEditingController _login;
  late final TextEditingController _email;
  late final TextEditingController _displayName;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _login = TextEditingController(text: user?.login);
    _email = TextEditingController(text: user?.email);
    _displayName = TextEditingController(text: user?.displayName);
  }

  @override
  void dispose() {
    _login.dispose();
    _email.dispose();
    _displayName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminUserFormCubit(composition: widget.composition),
      child: BlocConsumer<AdminUserFormCubit, AdminUserFormState>(
        listener: (context, state) {
          if (state is AdminUserFormSucceeded) {
            Navigator.of(context).pop(true);
          }
        },
        builder: (context, state) {
          final submitting = state is AdminUserFormSubmitting;
          final failure = state is AdminUserFormFailure ? state : null;
          return AlertDialog(
            title: Text(
              widget.isEditing
                  ? context.l10n.adminUsersEditTitle
                  : context.l10n.adminUsersCreateTitle,
            ),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!widget.isEditing)
                      TextField(
                        controller: _login,
                        enabled: !submitting,
                        decoration: InputDecoration(
                          labelText: context.l10n.adminUsersLogin,
                        ),
                      ),
                    TextField(
                      controller: _email,
                      enabled: !submitting,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: context.l10n.adminUsersEmail,
                      ),
                    ),
                    TextField(
                      controller: _displayName,
                      enabled: !submitting,
                      decoration: InputDecoration(
                        labelText: context.l10n.adminUsersDisplayName,
                      ),
                    ),
                    if (failure != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          failure.isValidation
                              ? context.l10n.adminUsersRequired
                              : failure.message ??
                                    context.l10n.adminUsersLoadFailureTitle,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: submitting
                    ? null
                    : () => Navigator.of(context).pop(),
                child: Text(context.l10n.adminUsersCancel),
              ),
              FilledButton(
                onPressed: submitting ? null : () => _submit(context),
                child: submitting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(context.l10n.adminUsersSave),
              ),
            ],
          );
        },
      ),
    );
  }

  void _submit(BuildContext context) {
    final cubit = context.read<AdminUserFormCubit>();
    final user = widget.user;
    if (user == null) {
      unawaited(
        cubit.create(
          login: _login.text,
          email: _email.text,
          displayName: _displayName.text,
        ),
      );
      return;
    }
    unawaited(
      cubit.update(
        userId: user.userId,
        login: user.login,
        email: _email.text,
        displayName: _displayName.text,
      ),
    );
  }
}
