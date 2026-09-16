import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/delete_user/cubit/delete_bhp_user_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/delete_user/cubit/delete_bhp_user_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera modal usuwania pracownika BHP (archiwizacja).
Future<bool?> showDeleteBhpUserModal(
  BuildContext context, {
  required GetBhpUserListItem user,
}) {
  final repository = context.read<BhpUsersRepository>();

  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.bhpArchiveUserTitle,
    subtitle: context.l10n.bhpArchiveUserSubtitle,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => DeleteBhpUserCubit(repository: repository),
      child: _DeleteBhpUserModalBody(user: user),
    ),
  );
}

/// Treść modalu usuwania pracownika BHP.
class _DeleteBhpUserModalBody extends StatelessWidget {
  /// Tworzy treść modalu usuwania pracownika.
  const _DeleteBhpUserModalBody({required this.user});

  /// Pracownik do archiwizacji.
  final GetBhpUserListItem user;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.l10n;

    return BlocConsumer<DeleteBhpUserCubit, DeleteBhpUserState>(
      listener: (context, state) {
        switch (state) {
          case DeleteBhpUserSuccess():
            Navigator.of(context).pop(true);
          case DeleteBhpUserError(:final message):
            AppToast.show(
              context,
              message: message,
              tone: AppToastTone.error,
            );
          case DeleteBhpUserInitial():
          case DeleteBhpUserSubmitting():
            break;
        }
      },
      builder: (context, state) {
        final isSubmitting = state is DeleteBhpUserSubmitting;
        final errorMessage = switch (state) {
          DeleteBhpUserError(:final message) => message,
          _ => null,
        };

        return Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            Container(
              width: double.infinity,
              padding: const .all(Sizes.p16),
              decoration: BoxDecoration(
                color: context.feedback.warningBackground.withValues(
                  alpha: .72,
                ),
                borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
                border: Border.all(
                  color: context.feedback.warningForeground.withValues(
                    alpha: .24,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  Icon(
                    Icons.archive_outlined,
                    color: context.feedback.warningForeground,
                    size: Sizes.p20,
                  ),
                  Gaps.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        AppText(
                          intl.bhpArchiveUserConfirmMessage(user.fullName),
                          style: context.text.titleSmall?.copyWith(
                            color: context.feedback.warningForeground,
                            fontWeight: .w700,
                          ),
                        ),
                        Gaps.h8,
                        AppText(
                          intl.bhpArchiveUserMessage,
                          style: context.text.bodyMedium?.copyWith(
                            color: context.feedback.warningForeground,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (errorMessage case final message?) ...[
              Gaps.h12,
              AppText(
                message,
                style: context.text.bodySmall?.copyWith(
                  color: colors.error,
                  fontWeight: .w600,
                ),
              ),
            ],
            Gaps.h16,
            Row(
              mainAxisAlignment: .end,
              children: [
                AppActionButton.text(
                  label: intl.cancel,
                  icon: Icons.close_rounded,
                  tone: .neutral,
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: intl.bhpArchiveUserAction,
                  icon: Icons.archive_outlined,
                  tone: .neutral,
                  onPressedAsync: isSubmitting
                      ? null
                      : () => context.read<DeleteBhpUserCubit>().submit(
                          userId: user.id,
                        ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Otwiera modal trwałego usuwania pracownika BHP z bazy danych.
Future<bool?> showForceDeleteBhpUserModal(
  BuildContext context, {
  required GetBhpUserListItem user,
}) {
  final repository = context.read<BhpUsersRepository>();

  return AppModalSheet.show<bool>(
    context,
    title: context.l10n.bhpForceDeleteUserConfirmTitle,
    subtitle: context.l10n.bhpDeleteUserArchiveMessage,
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => DeleteBhpUserCubit(repository: repository),
      child: _ForceDeleteBhpUserModalBody(user: user),
    ),
  );
}

/// Treść modalu trwałego usuwania pracownika BHP.
class _ForceDeleteBhpUserModalBody extends StatefulWidget {
  /// Tworzy treść modalu trwałego usuwania pracownika.
  const _ForceDeleteBhpUserModalBody({required this.user});

  /// Pracownik do trwałego usunięcia.
  final GetBhpUserListItem user;

  @override
  State<_ForceDeleteBhpUserModalBody> createState() =>
      _ForceDeleteBhpUserModalBodyState();
}

class _ForceDeleteBhpUserModalBodyState
    extends State<_ForceDeleteBhpUserModalBody> {
  static const _deleteUnlockPhrase = 'Excellent2026';
  final TextEditingController _confirmationController = TextEditingController();

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.l10n;
    final isUnlocked =
        _confirmationController.text.trim() == _deleteUnlockPhrase;

    return BlocConsumer<DeleteBhpUserCubit, DeleteBhpUserState>(
      listener: (context, state) {
        switch (state) {
          case DeleteBhpUserSuccess():
            Navigator.of(context).pop(true);
          case DeleteBhpUserError(:final message):
            AppToast.show(
              context,
              message: message,
              tone: AppToastTone.error,
            );
          case DeleteBhpUserInitial():
          case DeleteBhpUserSubmitting():
            break;
        }
      },
      builder: (context, state) {
        final isSubmitting = state is DeleteBhpUserSubmitting;
        final errorMessage = switch (state) {
          DeleteBhpUserError(:final message) => message,
          _ => null,
        };

        return Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            Container(
              width: double.infinity,
              padding: const .all(Sizes.p16),
              decoration: BoxDecoration(
                color: colors.errorContainer.withValues(alpha: .68),
                borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
                border: Border.all(
                  color: colors.error.withValues(alpha: .24),
                ),
              ),
              child: Row(
                crossAxisAlignment: .start,
                children: [
                  Icon(
                    Icons.delete_forever_rounded,
                    color: colors.error,
                    size: Sizes.p20,
                  ),
                  Gaps.w12,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        AppText(
                          intl.bhpForceDeleteUserConfirmTitle,
                          style: context.text.titleSmall?.copyWith(
                            color: colors.onErrorContainer,
                            fontWeight: .w700,
                          ),
                        ),
                        Gaps.h8,
                        AppText(
                          intl.bhpForceDeleteUserConfirmBody(
                            widget.user.fullName,
                            widget.user.id.toString(),
                          ),
                          style: context.text.bodyMedium?.copyWith(
                            color: colors.onErrorContainer,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (errorMessage case final message?) ...[
              Gaps.h12,
              AppText(
                message,
                style: context.text.bodySmall?.copyWith(
                  color: colors.error,
                  fontWeight: .w600,
                ),
              ),
            ],
            Gaps.h12,
            AppTextField(
              controller: _confirmationController,
              enabled: !isSubmitting,
              labelText: intl.bhpForceDeleteUnlockLabel,
              hintText: intl.bhpForceDeleteUnlockHint,
              onChanged: (_) => setState(() {}),
            ),
            Gaps.h16,
            Row(
              mainAxisAlignment: .end,
              children: [
                AppActionButton.text(
                  label: intl.cancel,
                  icon: Icons.close_rounded,
                  tone: .neutral,
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: intl.delete,
                  icon: Icons.delete_forever_rounded,
                  tone: .danger,
                  onPressedAsync: isSubmitting || !isUnlocked
                      ? null
                      : () => context
                            .read<DeleteBhpUserCubit>()
                            .submitForceDelete(
                              userId: widget.user.id,
                            ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
