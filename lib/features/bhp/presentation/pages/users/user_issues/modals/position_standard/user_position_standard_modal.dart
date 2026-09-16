import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_users_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/position_standard/cubit/bhp_user_position_standard_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/modals/position_standard/cubit/bhp_user_position_standard_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_dropdown.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera modal stanowiska i standardu przypisań dla pracownika BHP.
Future<GetBhpUserListItem?> showBhpUserPositionStandardModal(
  BuildContext context, {
  required GetBhpUserListItem user,
}) async {
  final usersRepository = context.read<BhpUsersRepository>();
  final positionsRepository = context.read<BhpPositionsRepository>();
  final cubit = BhpUserPositionStandardCubit(
    user: user,
    usersRepository: usersRepository,
    positionsRepository: positionsRepository,
  );
  unawaited(cubit.load());

  try {
    return await AppModalSheet.showSideSheet<GetBhpUserListItem?>(
      context,
      title: context.l10n.bhpPositionStandardTitle,
      subtitle: user.fullName,
      size: AppModalSheetSize.large,
      width: 1280,
      footer: BlocProvider.value(
        value: cubit,
        child: const _BhpUserPositionStandardFooter(),
      ),
      body: BlocProvider.value(
        value: cubit,
        child: _BhpUserPositionStandardModalBody(user: user),
      ),
    );
  } finally {
    await cubit.close();
  }
}

/// Stopka modala stanowiska i standardu przypisań.
class _BhpUserPositionStandardFooter extends StatelessWidget {
  /// Tworzy stopkę modala.
  const _BhpUserPositionStandardFooter();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      BhpUserPositionStandardCubit,
      BhpUserPositionStandardState
    >(
      builder: (context, state) {
        final readyState = state is BhpUserPositionStandardReady ? state : null;
        final isSaving = readyState?.isSaving ?? false;
        final canSave = readyState?.canSave ?? false;

        return Padding(
          padding: const .all(Sizes.p16),
          child: Row(
            mainAxisAlignment: .end,
            children: [
              AppActionButton.text(
                label: context.l10n.cancel,
                icon: Icons.close_rounded,
                onPressed: isSaving ? null : () => Navigator.of(context).pop(),
              ),
              Gaps.w12,
              AppActionButton.filled(
                label: context.l10n.bhpPositionStandardSaveAction,
                icon: Icons.save_outlined,
                onPressedAsync: !canSave || isSaving
                    ? null
                    : () => _save(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _save(BuildContext context) async {
    final result = await context.read<BhpUserPositionStandardCubit>().save();
    if (!context.mounted) {
      return;
    }

    result.fold(
      (error) => AppToast.show(
        context,
        message: error.message,
        tone: AppToastTone.error,
      ),
      (updatedUser) {
        AppToast.show(
          context,
          message: context.l10n.bhpPositionStandardSaveSuccess,
          tone: AppToastTone.success,
        );
        Navigator.of(context).pop(updatedUser);
      },
    );
  }
}

/// Treść modala stanowiska i standardu przypisań.
class _BhpUserPositionStandardModalBody extends StatelessWidget {
  /// Tworzy treść modala stanowiska.
  const _BhpUserPositionStandardModalBody({required this.user});

  final GetBhpUserListItem user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      BhpUserPositionStandardCubit,
      BhpUserPositionStandardState
    >(
      builder: (context, state) {
        final colors = context.colors;
        final text = context.text;

        return switch (state) {
          BhpUserPositionStandardLoading() => const SizedBox(
            height: 280,
            child: Center(child: AppSpinner()),
          ),
          BhpUserPositionStandardError(:final message) => AppEmptyState.error(
            title: context.l10n.bhpPositionStandardLoadErrorTitle,
            message: message,
          ),
          BhpUserPositionStandardReady() => Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              AppSectionCard(
                padding: const .all(Sizes.p12),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppText(
                            context.l10n.bhpPositionStandardCurrentTitle,
                            style: text.titleMedium?.copyWith(
                              fontWeight: .w700,
                            ),
                          ),
                        ),
                        if (state.detail.stanowisko case final position?) ...[
                          AppStatusBadge(
                            label: position.aktywny
                                ? context.l10n.bhpStatusActive
                                : context.l10n.bhpStatusInactive,
                            tone: position.aktywny
                                ? AppStatusBadgeTone.success
                                : AppStatusBadgeTone.warning,
                            icon: position.aktywny
                                ? Icons.check_circle_outline_rounded
                                : Icons.pause_circle_outline_rounded,
                          ),
                        ],
                      ],
                    ),
                    Gaps.h8,
                    Text(
                      user.stanowiskoNazwa ??
                          context.l10n.bhpPositionStandardNoPosition,
                      style: text.titleMedium?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                    if (state.detail.stanowiskoLegacyLabel case final legacy?
                        when legacy.trim().isNotEmpty) ...[
                      Gaps.h4,
                      Text(
                        legacy.trim(),
                        style: text.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (state.selectedPosition.uwagi case final notes?
                        when notes.trim().isNotEmpty) ...[
                      Gaps.h12,
                      Text(
                        context.l10n.bhpPositionStandardDescriptionTitle,
                        style: text.labelMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                          fontWeight: .w700,
                        ),
                      ),
                      Gaps.h4,
                      Text(
                        notes.trim(),
                        style: text.bodyMedium?.copyWith(
                          color: colors.onSurface,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Gaps.h16,
              AppSectionCard(
                padding: const .all(Sizes.p12),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    AppText(
                      context.l10n.bhpPositionStandardChangeTitle,
                      style: text.titleMedium?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                    Gaps.h12,
                    AppDropdown<int>(
                      options: [
                        for (final position in state.positions)
                          AppDropdownOption(
                            value: position.id,
                            label: position.nazwa,
                          ),
                      ],
                      value: state.selectedPositionId,
                      variant: .filled,
                      labelText: context.l10n.bhpTablePosition,
                      hintText: context.l10n.bhpPositionStandardSelectHint,
                      onChanged: state.isSaving
                          ? null
                          : (value) => context
                                .read<BhpUserPositionStandardCubit>()
                                .changePosition(value),
                    ),
                    Gaps.h12,
                    Wrap(
                      spacing: Sizes.p8,
                      runSpacing: Sizes.p8,
                      children: [
                        AppStatusBadge(
                          label: state.selectedPositionId != null
                              ? context.l10n.bhpPositionStandardSelectedStatus
                              : context
                                    .l10n
                                    .bhpPositionStandardUnselectedStatus,
                          tone: state.selectedPositionId != null
                              ? AppStatusBadgeTone.success
                              : AppStatusBadgeTone.warning,
                          icon: state.selectedPositionId != null
                              ? Icons.done_rounded
                              : Icons.warning_amber_rounded,
                        ),
                        AppStatusBadge(
                          label: state.isLoadingStandards
                              ? context.l10n.bhpPositionStandardLoadingStandard
                              : context.l10n.bhpPositionStandardStandardCount(
                                  state.standards.length,
                                ),
                          icon: state.isLoadingStandards
                              ? Icons.sync_rounded
                              : Icons.inventory_2_outlined,
                        ),
                      ],
                    ),
                    Gaps.h8,
                    Text(
                      context.l10n.bhpPositionStandardPreviewLabel(
                        state.selectedPosition.nazwa,
                      ),
                      style: text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    if (state.standardsError case final message?) ...[
                      Gaps.h8,
                      Text(
                        message,
                        style: text.bodySmall?.copyWith(
                          color: colors.error,
                          fontWeight: .w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Gaps.h16,
              AppSectionCard(
                child: SizedBox(
                  height: 420,
                  child: state.isLoadingStandards
                      ? const Center(child: AppSpinner())
                      : state.standards.isEmpty
                      ? AppEmptyState.noData(
                          title: context
                              .l10n
                              .bhpPositionStandardEmptyStandardTitle,
                          message: context
                              .l10n
                              .bhpPositionStandardEmptyStandardMessage,
                        )
                      : AppSimpleTable<GetBhpUserStandardItem>(
                          rows: state.standards,
                          rowHeight: 56,
                          scrollbarAlwaysVisible: true,
                          columns: [
                            AppSimpleTableColumn(
                              label: context.l10n.bhpTableSymbol,
                              width: 120,
                              sortable: false,
                              cellBuilder: (context, row) => Text(
                                row.kartaWyposazeniaSymbol ?? '—',
                              ),
                            ),
                            AppSimpleTableColumn(
                              label: context.l10n.bhpTableEquipmentName,
                              width: 280,
                              cellBuilder: (context, row) => Text(
                                row.kartaWyposazeniaNazwa ?? '—',
                              ),
                            ),
                            AppSimpleTableColumn(
                              label: context.l10n.bhpTableQuantity,
                              width: 90,
                              sortable: false,
                              numeric: true,
                              cellAlignment: .centerRight,
                              cellBuilder: (context, row) =>
                                  Text(row.ilosc ?? '—'),
                            ),
                            AppSimpleTableColumn(
                              label: context.l10n.bhpTablePeriod,
                              width: 100,
                              sortable: false,
                              numeric: true,
                              cellAlignment: .centerRight,
                              cellBuilder: (context, row) =>
                                  Text(row.okres?.toString() ?? '—'),
                            ),
                            AppSimpleTableColumn(
                              label: context.l10n.bhpTableNotes,
                              width: 260,
                              sortable: false,
                              cellBuilder: (context, row) => Text(
                                row.uwagi?.trim().isNotEmpty == true
                                    ? row.uwagi!.trim()
                                    : '—',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            AppSimpleTableColumn(
                              label: context.l10n.bhpTableStatus,
                              width: 120,
                              sortable: false,
                              cellAlignment: .center,
                              cellBuilder: (context, row) => AppStatusBadge(
                                label: row.aktywny
                                    ? context.l10n.bhpStatusActive
                                    : context.l10n.bhpStatusInactive,
                                tone: row.aktywny
                                    ? AppStatusBadgeTone.success
                                    : AppStatusBadgeTone.neutral,
                                icon: row.aktywny
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.remove_circle_outline_rounded,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        };
      },
    );
  }
}
