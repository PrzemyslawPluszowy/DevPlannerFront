import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/archive_equipment/cubit/archive_bhp_equipment_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/archive_equipment/cubit/archive_bhp_equipment_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera modal archiwizacji karty wyposażenia BHP.
Future<bool?> showArchiveBhpEquipmentModal(
  BuildContext context, {
  required GetBhpEquipmentListItem item,
}) {
  final repository = context.read<BhpEquipmentRepository>();

  return AppModalSheet.show<bool>(
    context,
    title: 'Archiwizuj wyposażenie',
    subtitle:
        'Pozycja zniknie z aktywnego katalogu, ale zachowa historię użycia.',
    size: AppModalSheetSize.small,
    body: BlocProvider(
      create: (_) => ArchiveBhpEquipmentCubit(repository: repository),
      child: _ArchiveBhpEquipmentModalBody(item: item),
    ),
  );
}

/// Treść modalu archiwizacji karty wyposażenia BHP.
class _ArchiveBhpEquipmentModalBody extends StatelessWidget {
  /// Tworzy treść modalu archiwizacji wyposażenia.
  const _ArchiveBhpEquipmentModalBody({required this.item});

  /// Karta wyposażenia do archiwizacji.
  final GetBhpEquipmentListItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocConsumer<ArchiveBhpEquipmentCubit, ArchiveBhpEquipmentState>(
      listener: (context, state) {
        switch (state) {
          case ArchiveBhpEquipmentSuccess():
            Navigator.of(context).pop(true);
          case ArchiveBhpEquipmentError(:final message):
            AppToast.show(
              context,
              message: message,
              tone: AppToastTone.error,
            );
          case ArchiveBhpEquipmentInitial():
          case ArchiveBhpEquipmentSubmitting():
            break;
        }
      },
      builder: (context, state) {
        final isSubmitting = state is ArchiveBhpEquipmentSubmitting;
        final errorMessage = switch (state) {
          ArchiveBhpEquipmentError(:final message) => message,
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
                'Czy na pewno chcesz zarchiwizować kartę ${item.symbol} (${item.nazwa})?',
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
                      : () => context.read<ArchiveBhpEquipmentCubit>().submit(
                          equipmentId: item.id,
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
