import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/equipment_activation/cubit/bhp_equipment_activation_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/equipment_activation/cubit/bhp_equipment_activation_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

part 'equipment_activation_modal_widgets.part.dart';

/// Otwiera modal zmiany statusu karty wyposażenia.
Future<bool?> showBhpEquipmentActivationModal(
  BuildContext context, {
  required GetBhpEquipmentListItem item,
  required BhpEquipmentActivationMode mode,
}) async {
  final repository = context.read<BhpEquipmentRepository>();
  final cubit = BhpEquipmentActivationCubit(
    repository: repository,
    equipment: item,
    mode: mode,
  );
  unawaited(cubit.load());

  try {
    return await AppModalSheet.showSideSheet<bool>(
      context,
      title: switch (mode) {
        BhpEquipmentActivationMode.setInactive =>
          context.l10n.bhpEquipmentSetInactiveTitle,
        BhpEquipmentActivationMode.setActive =>
          context.l10n.bhpEquipmentSetActiveTitle,
      },
      subtitle: '${item.symbol} · ${item.nazwa}',
      size: AppModalSheetSize.large,
      width: 980,
      body: BlocProvider.value(
        value: cubit,
        child: const _BhpEquipmentActivationModalBody(),
      ),
    );
  } finally {
    await cubit.close();
  }
}

/// Treść modala zmiany statusu karty wyposażenia.
class _BhpEquipmentActivationModalBody extends StatelessWidget {
  /// Tworzy treść modala zmiany statusu.
  const _BhpEquipmentActivationModalBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      BhpEquipmentActivationCubit,
      BhpEquipmentActivationState
    >(
      builder: (context, state) {
        return switch (state) {
          BhpEquipmentActivationLoading() => const SizedBox(
            height: 240,
            child: Center(child: AppSpinner()),
          ),
          BhpEquipmentActivationError(:final message) => AppEmptyState.error(
            title: context.l10n.inventoryLoadingErrorTitle,
            message: message,
          ),
          BhpEquipmentActivationReady() => _ActivationReadyView(state: state),
        };
      },
    );
  }
}

/// Widok gotowego modala zmiany statusu karty wyposażenia.
class _ActivationReadyView extends StatelessWidget {
  /// Tworzy widok gotowego modala.
  const _ActivationReadyView({required this.state});

  /// Gotowy stan modala.
  final BhpEquipmentActivationReady state;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        Text(
          switch (state.mode) {
            BhpEquipmentActivationMode.setInactive =>
              intl.bhpEquipmentImpactSetInactiveDescription,
            BhpEquipmentActivationMode.setActive =>
              intl.bhpEquipmentImpactSetActiveDescription,
          },
          style: context.text.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
            height: 1.35,
          ),
        ),
        Gaps.h16,
        Wrap(
          spacing: Sizes.p8,
          runSpacing: Sizes.p8,
          children: [
            AppStatusBadge(
              label: intl.bhpEquipmentImpactActiveLinksCount(
                state.impact.activeStandardsCount,
              ),
              tone: AppStatusBadgeTone.success,
              icon: Icons.link_rounded,
            ),
            AppStatusBadge(
              label: intl.bhpEquipmentImpactInactiveLinksCount(
                state.impact.inactiveStandardsCount,
              ),
              tone: AppStatusBadgeTone.warning,
              icon: Icons.link_off_rounded,
            ),
            if (state.mode == BhpEquipmentActivationMode.setActive)
              AppStatusBadge(
                label: intl.bhpEquipmentImpactSelectedLinksCount(
                  state.selectedStandardIds.length,
                ),
                icon: Icons.checklist_rounded,
              ),
          ],
        ),
        Gaps.h20,
        _buildBody(context),
        Gaps.h24,
        Row(
          mainAxisAlignment: .end,
          children: [
            AppActionButton.text(
              label: context.l10n.cancel,
              icon: Icons.close_rounded,
              onPressed: state.isSubmitting
                  ? null
                  : () => Navigator.of(context).pop(false),
            ),
            Gaps.w8,
            AppActionButton.filled(
              label: switch (state.mode) {
                BhpEquipmentActivationMode.setInactive =>
                  intl.bhpEquipmentSetInactiveAction,
                BhpEquipmentActivationMode.setActive =>
                  intl.bhpEquipmentSetActiveAction,
              },
              icon: switch (state.mode) {
                BhpEquipmentActivationMode.setInactive =>
                  Icons.pause_circle_outline_rounded,
                BhpEquipmentActivationMode.setActive =>
                  Icons.check_circle_outline_rounded,
              },
              onPressedAsync: state.isSubmitting
                  ? null
                  : () => _submit(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return switch (state.mode) {
      BhpEquipmentActivationMode.setInactive => _InactiveImpactList(
        entries: state.affectedActiveStandards
            .map(
              (standard) => BhpEquipmentActivationEntry(standard: standard),
            )
            .toList(growable: false),
      ),
      BhpEquipmentActivationMode.setActive => _ActiveImpactList(state: state),
    };
  }

  Future<void> _submit(BuildContext context) async {
    final result = await context.read<BhpEquipmentActivationCubit>().submit();
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
          message: switch (state.mode) {
            BhpEquipmentActivationMode.setInactive =>
              context.l10n.bhpEquipmentSetInactiveSuccess(
                state.impact.equipment.symbol,
              ),
            BhpEquipmentActivationMode.setActive =>
              context.l10n.bhpEquipmentSetActiveSuccess(
                state.impact.equipment.symbol,
              ),
          },
          tone: AppToastTone.success,
        );
        Navigator.of(context).pop(true);
      },
    );
  }
}
