import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/assign_from_standard/cubit/bhp_assign_user_issues_from_standard_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/assign_from_standard/cubit/bhp_assign_user_issues_from_standard_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

part 'assign_user_issues_from_standard_modal_widgets.part.dart';

/// Otwiera modal wyboru pozycji do dopisania ze standardu stanowiska.
Future<bool?> showAssignUserIssuesFromStandardModal(
  BuildContext context, {
  required GetBhpUserListItem user,
}) async {
  final repository = context.read<BhpUsersRepository>();
  final cubit = BhpAssignUserIssuesFromStandardCubit(
    repository: repository,
    userId: user.id,
  );
  unawaited(cubit.load());

  try {
    return await AppModalSheet.showSideSheet<bool>(
      context,
      title: context.l10n.bhpAssignFromStandardTitle,
      subtitle: user.stanowiskoNazwa == null || user.stanowiskoNazwa!.isEmpty
          ? user.fullName
          : '${user.fullName} · ${user.stanowiskoNazwa}',
      size: AppModalSheetSize.large,
      width: 980,
      body: BlocProvider.value(
        value: cubit,
        child: const _AssignUserIssuesFromStandardModalBody(),
      ),
    );
  } finally {
    await cubit.close();
  }
}

/// Treść modala wyboru pozycji standardu do dopisania.
class _AssignUserIssuesFromStandardModalBody extends StatelessWidget {
  /// Tworzy treść modala wyboru pozycji.
  const _AssignUserIssuesFromStandardModalBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      BhpAssignUserIssuesFromStandardCubit,
      BhpAssignUserIssuesFromStandardState
    >(
      builder: (context, state) {
        final colors = context.colors;
        final text = context.text;

        return switch (state) {
          BhpAssignUserIssuesFromStandardLoading() => const SizedBox(
            height: 240,
            child: Center(child: AppSpinner()),
          ),
          BhpAssignUserIssuesFromStandardError(:final message) =>
            AppEmptyState.error(
              title: context.l10n.bhpAssignFromStandardLoadErrorTitle,
              message: message,
            ),
          BhpAssignUserIssuesFromStandardReady() =>
            state.canReceiveIssues
                ? Column(
                    mainAxisSize: .min,
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        context.l10n.bhpAssignFromStandardDescription,
                        style: text.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          height: 1.35,
                        ),
                      ),
                      Gaps.h16,
                      Wrap(
                        spacing: Sizes.p8,
                        runSpacing: Sizes.p8,
                        children: [
                          AppStatusBadge(
                            label: context.l10n
                                .bhpAssignFromStandardSelectedCount(
                                  state.selectedStandardIds.length,
                                ),
                            tone: AppStatusBadgeTone.success,
                            icon: Icons.add_circle_outline_rounded,
                          ),
                          AppStatusBadge(
                            label: context.l10n
                                .bhpAssignFromStandardLockedCount(
                                  state.lockedEntries.length,
                                ),
                            tone: AppStatusBadgeTone.warning,
                            icon: Icons.lock_outline_rounded,
                          ),
                          if (state.inactiveEntries.isNotEmpty)
                            AppStatusBadge(
                              label: context.l10n
                                  .bhpAssignFromStandardInactiveCount(
                                    state.inactiveEntries.length,
                                  ),
                              icon: Icons.remove_circle_outline_rounded,
                            ),
                        ],
                      ),
                      Gaps.h20,
                      if (state.selectableEntries.isNotEmpty) ...[
                        _SectionTitle(
                          title:
                              context.l10n.bhpAssignFromStandardSectionAddable,
                        ),
                        Gaps.h8,
                        ...state.selectableEntries.map(
                          (entry) => _SelectionTile(
                            label: entry.label,
                            subtitle: entry.subtitle,
                            value: state.selectedStandardIds.contains(
                              entry.standard.id,
                            ),
                            onChanged: state.isSaving
                                ? null
                                : (_) => context
                                      .read<
                                        BhpAssignUserIssuesFromStandardCubit
                                      >()
                                      .toggleSelection(entry.standard.id),
                            enabled: true,
                            accentTone: AppStatusBadgeTone.success,
                          ),
                        ),
                        Gaps.h16,
                      ],
                      if (state.lockedEntries.isNotEmpty) ...[
                        _SectionTitle(
                          title:
                              context.l10n.bhpAssignFromStandardSectionLocked,
                        ),
                        Gaps.h8,
                        ...state.lockedEntries.map(
                          (entry) => _SelectionTile(
                            label: entry.label,
                            subtitle: entry.subtitle,
                            value: true,
                            onChanged: null,
                            enabled: false,
                            accentTone: AppStatusBadgeTone.warning,
                          ),
                        ),
                        Gaps.h16,
                      ],
                      if (state.inactiveEntries.isNotEmpty) ...[
                        _SectionTitle(
                          title:
                              context.l10n.bhpAssignFromStandardSectionInactive,
                        ),
                        Gaps.h8,
                        ...state.inactiveEntries.map(
                          (entry) => _SelectionTile(
                            label: entry.label,
                            subtitle: entry.subtitle,
                            value: false,
                            onChanged: null,
                            enabled: false,
                            accentTone: AppStatusBadgeTone.neutral,
                          ),
                        ),
                      ],
                      Gaps.h24,
                      Row(
                        mainAxisAlignment: .end,
                        children: [
                          AppActionButton.text(
                            label: context.l10n.cancel,
                            icon: Icons.close_rounded,
                            onPressed: state.isSaving
                                ? null
                                : () => Navigator.of(context).pop(false),
                          ),
                          Gaps.w8,
                          AppActionButton.filled(
                            label:
                                context.l10n.bhpAssignFromStandardSubmitAction,
                            icon: Icons.check_rounded,
                            onPressedAsync:
                                state.isSaving ||
                                    state.selectedStandardIds.isEmpty
                                ? null
                                : () => _submit(context),
                          ),
                        ],
                      ),
                    ],
                  )
                : AppEmptyState.noData(
                    title: context.l10n.bhpAssignFromStandardBlockedTitle,
                    message: context.l10n.bhpAssignFromStandardBlockedMessage,
                  ),
        };
      },
    );
  }

  Future<void> _submit(BuildContext context) async {
    final result = await context
        .read<BhpAssignUserIssuesFromStandardCubit>()
        .submit();
    if (!context.mounted) {
      return;
    }

    result.fold(
      (error) => AppToast.show(
        context,
        message: error.message,
        tone: AppToastTone.error,
      ),
      (_) {
        AppToast.show(
          context,
          message: context.l10n.bhpIssueFormSuccessStandard,
          tone: AppToastTone.success,
        );
        Navigator.of(context).pop(true);
      },
    );
  }
}
