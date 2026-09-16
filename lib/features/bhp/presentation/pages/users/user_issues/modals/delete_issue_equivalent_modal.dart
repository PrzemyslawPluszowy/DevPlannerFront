import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/cubit/bhp_user_issue_equivalent_command_cubit.dart';
import 'package:ready_next/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera potwierdzenie usunięcia ekwiwalentu z wydania wyposażenia BHP.
Future<bool> showDeleteIssueEquivalentModal(
  BuildContext context, {
  required int userId,
  required GetBhpUserIssue issue,
}) async {
  final usersRepository = context.read<BhpUsersRepository>();
  final commandCubit = BhpUserIssueEquivalentCommandCubit(
    repository: usersRepository,
    userId: userId,
    inProgressMessage: context.l10n.bhpUserIssueCommandInProgress,
  );

  final equipmentLabel = _resolveIssueEquivalentLabel(context, issue);

  try {
    return await AppConfirmDialog.show(
      context,
      title: context.l10n.bhpIssueEquivalentDeleteTitle,
      message: context.l10n.bhpIssueEquivalentDeleteMessage(equipmentLabel),
      confirmLabel: context.l10n.bhpIssueEquivalentDeleteAction,
      cancelLabel: context.l10n.cancel,
      tone: AppConfirmDialogTone.danger,
      onConfirm: () async {
        final result = await commandCubit.deleteEquivalent(issue.id);
        if (!context.mounted) {
          return false;
        }

        return result.fold(
          (error) {
            AppToast.show(
              context,
              message: error.message,
              tone: AppToastTone.error,
            );
            return false;
          },
          (_) {
            AppToast.show(
              context,
              message: context.l10n.bhpIssueEquivalentDeleteSuccess,
              tone: AppToastTone.success,
            );
            return true;
          },
        );
      },
    );
  } finally {
    await commandCubit.close();
  }
}

String _resolveIssueEquivalentLabel(
  BuildContext context,
  GetBhpUserIssue issue,
) {
  final symbol = issue.kartaWyposazeniaSymbol?.trim();
  final name = issue.kartaWyposazeniaNazwa?.trim();

  if (symbol case final symbolValue? when symbolValue.isNotEmpty) {
    if (name case final nameValue? when nameValue.isNotEmpty) {
      return '$symbolValue - $nameValue';
    }

    return symbolValue;
  }

  if (name case final nameValue? when nameValue.isNotEmpty) {
    return nameValue;
  }

  return context.l10n.bhpUserIssuesActionsForIssue;
}
