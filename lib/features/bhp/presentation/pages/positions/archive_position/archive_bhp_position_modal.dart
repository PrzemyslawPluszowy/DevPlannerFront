import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/archive_position/cubit/archive_bhp_position_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/archive_position/cubit/archive_bhp_position_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera modal archiwizacji stanowiska BHP.
Future<bool?> showArchiveBhpPositionModal(
  BuildContext context, {
  required GetBhpPositionListItem item,
}) {
  final repository = context.read<BhpPositionsRepository>();

  return AppModalSheet.show<bool>(
    context,
    title: 'Archiwizuj stanowisko',
    subtitle:
        'Stanowisko zniknie z aktywnego słownika, ale zachowa powiązania historyczne.',
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => ArchiveBhpPositionCubit(repository: repository),
      child: _ArchiveBhpPositionModalBody(item: item),
    ),
  );
}

/// Treść modalu archiwizacji stanowiska BHP.
class _ArchiveBhpPositionModalBody extends StatelessWidget {
  /// Tworzy treść modalu archiwizacji stanowiska.
  const _ArchiveBhpPositionModalBody({required this.item});

  /// Stanowisko do archiwizacji.
  final GetBhpPositionListItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocConsumer<ArchiveBhpPositionCubit, ArchiveBhpPositionState>(
      listener: (context, state) {
        switch (state) {
          case ArchiveBhpPositionSuccess():
            Navigator.of(context).pop(true);
          case ArchiveBhpPositionError(:final message):
            AppToast.show(
              context,
              message: message,
              tone: AppToastTone.error,
            );
          case ArchiveBhpPositionInitial():
          case ArchiveBhpPositionSubmitting():
            break;
        }
      },
      builder: (context, state) {
        final isSubmitting = state is ArchiveBhpPositionSubmitting;
        final errorMessage = switch (state) {
          ArchiveBhpPositionError(:final message) => message,
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
              child: AppText(
                'Czy na pewno chcesz zarchiwizować stanowisko ${item.nazwa}?',
                style: context.text.bodyMedium?.copyWith(
                  color: colors.onErrorContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (errorMessage case final message?) ...[
              Gaps.h12,
              AppText(
                message,
                style: context.text.bodySmall?.copyWith(
                  color: colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            Gaps.h16,
            Row(
              mainAxisAlignment: .end,
              children: [
                AppActionButton.text(
                  label: 'Anuluj',
                  icon: Icons.close_rounded,
                  tone: .neutral,
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(false),
                ),
                Gaps.w8,
                AppActionButton.filled(
                  label: 'Archiwizuj',
                  icon: Icons.archive_outlined,
                  tone: .danger,
                  onPressedAsync: isSubmitting
                      ? null
                      : () => context.read<ArchiveBhpPositionCubit>().submit(
                          positionId: item.id,
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
