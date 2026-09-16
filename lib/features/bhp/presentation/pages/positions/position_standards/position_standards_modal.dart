import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_standards/cubit/bhp_position_standards_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_standards/cubit/bhp_position_standards_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_standards/position_standard_editor_modal.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_modal_sheet.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Otwiera manager standardu wyposażenia dla stanowiska BHP.
Future<void> showBhpPositionStandardsModal(
  BuildContext context, {
  required GetBhpPositionListItem position,
  required BhpPositionsRepository positionsRepository,
  required BhpEquipmentRepository equipmentRepository,
}) async {
  final cubit = BhpPositionStandardsCubit(
    position: position,
    positionsRepository: positionsRepository,
    equipmentRepository: equipmentRepository,
  );
  unawaited(cubit.load());

  try {
    await AppModalSheet.showSideSheet<void>(
      context,
      title: context.l10n.bhpPositionStandardsTitle,
      subtitle: position.nazwa,
      size: AppModalSheetSize.large,
      width: 1280,
      headerActions: [
        BlocProvider.value(
          value: cubit,
          child: Builder(
            builder: (context) {
              return AppActionButton.filled(
                label: context.l10n.bhpPositionStandardsAddAction,
                icon: Icons.add_rounded,
                dense: true,
                onPressedAsync: () => _openCreateStandard(context, position),
              );
            },
          ),
        ),
      ],
      body: BlocProvider.value(
        value: cubit,
        child: BhpPositionStandardsContent(position: position),
      ),
    );
  } finally {
    await cubit.close();
  }
}

/// Treść managera standardu wyposażenia stanowiska BHP.
class BhpPositionStandardsContent extends StatelessWidget {
  /// Tworzy treść managera standardu stanowiska.
  const BhpPositionStandardsContent({
    required this.position,
    this.showPositionSummary = true,
    this.showInlineAddAction = false,
    super.key,
  });

  /// Stanowisko, którego dotyczy modal.
  final GetBhpPositionListItem position;

  /// Czy renderować kartę podsumowania stanowiska nad listą standardów.
  final bool showPositionSummary;

  /// Czy pokazać lokalny przycisk dodawania pozycji standardu.
  final bool showInlineAddAction;

  @override
  Widget build(BuildContext context) => _BhpPositionStandardsBody(
    position: position,
    showPositionSummary: showPositionSummary,
    showInlineAddAction: showInlineAddAction,
  );
}

/// Kompatybilna treść listy standardów stanowiska.
///
/// Klasa zachowuje historyczną nazwę używaną przed refaktorem, żeby
/// hot reload nie wpadał w błędy lookupu po przebudowie drzewa widgetów.
class _BhpPositionStandardsBody extends StatelessWidget {
  /// Tworzy treść listy standardów stanowiska.
  const _BhpPositionStandardsBody({
    required this.position,
    required this.showPositionSummary,
    required this.showInlineAddAction,
  });

  /// Stanowisko, którego dotyczy zawartość.
  final GetBhpPositionListItem position;

  /// Czy renderować kartę podsumowania stanowiska nad listą.
  final bool showPositionSummary;

  /// Czy pokazać lokalny przycisk dodawania pozycji standardu.
  final bool showInlineAddAction;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhpPositionStandardsCubit, BhpPositionStandardsState>(
      builder: (context, state) {
        final text = context.text;
        final intl = context.l10n;

        return switch (state) {
          BhpPositionStandardsLoading() => const SizedBox(
            height: 320,
            child: Center(child: AppSpinner()),
          ),
          BhpPositionStandardsError(:final message) => AppEmptyState.error(
            title: intl.bhpPositionStandardsLoadErrorTitle,
            message: message,
          ),
          BhpPositionStandardsReady() => Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              if (showInlineAddAction) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        intl.bhpPositionStandardsTitle,
                        style: text.titleMedium?.copyWith(fontWeight: .w700),
                      ),
                    ),
                    AppActionButton.filled(
                      label: intl.bhpPositionStandardsAddAction,
                      icon: Icons.add_rounded,
                      dense: true,
                      onPressedAsync: () => _openCreateStandard(
                        context,
                        position,
                      ),
                    ),
                  ],
                ),
                Gaps.h16,
              ],
              Wrap(
                spacing: Sizes.p8,
                runSpacing: Sizes.p8,
                children: [
                  AppActionChip(
                    label: intl.bhpStatusActive,
                    icon: Icons.check_circle_outline_rounded,
                    selected:
                        state.filter == BhpPositionStandardsFilter.aktywne,
                    tone: .primary,
                    onPressed: () => context
                        .read<BhpPositionStandardsCubit>()
                        .setFilter(BhpPositionStandardsFilter.aktywne),
                  ),
                  AppActionChip(
                    label: intl.bhpPositionsFilterInactive,
                    icon: Icons.pause_circle_outline_rounded,
                    selected:
                        state.filter == BhpPositionStandardsFilter.nieaktywne,
                    tone: .primary,
                    onPressed: () => context
                        .read<BhpPositionStandardsCubit>()
                        .setFilter(BhpPositionStandardsFilter.nieaktywne),
                  ),
                  AppActionChip(
                    label: intl.bhpPositionsFilterAll,
                    icon: Icons.inventory_2_outlined,
                    selected:
                        state.filter == BhpPositionStandardsFilter.wszystkie,
                    tone: .primary,
                    onPressed: () => context
                        .read<BhpPositionStandardsCubit>()
                        .setFilter(BhpPositionStandardsFilter.wszystkie),
                  ),
                ],
              ),
              Gaps.h16,
              if (showPositionSummary) ...[
                AppSectionCard(
                  padding: const .all(Sizes.p12),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AppText(
                              intl.bhpPositionStandardsPositionLabel,
                              style: text.titleMedium?.copyWith(
                                fontWeight: .w700,
                              ),
                            ),
                          ),
                          AppStatusBadge(
                            label: position.aktywny
                                ? intl.bhpStatusActive
                                : intl.bhpPositionsFilterInactive,
                            tone: position.aktywny
                                ? AppStatusBadgeTone.success
                                : AppStatusBadgeTone.warning,
                            icon: position.aktywny
                                ? Icons.check_circle_outline_rounded
                                : Icons.pause_circle_outline_rounded,
                          ),
                        ],
                      ),
                      Gaps.h8,
                      AppText(
                        position.nazwa,
                        style: text.titleLarge?.copyWith(fontWeight: .w700),
                      ),
                      if (position.uwagi case final notes?
                          when notes.trim().isNotEmpty) ...[
                        Gaps.h8,
                        AppText(
                          notes.trim(),
                          style: text.bodyMedium?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                      Gaps.h12,
                      Wrap(
                        spacing: Sizes.p8,
                        runSpacing: Sizes.p8,
                        children: [
                          AppStatusBadge(
                            label: intl.bhpPositionStandardsItemsCount(
                              state.standards.length,
                            ),
                            icon: Icons.inventory_2_outlined,
                          ),
                          AppStatusBadge(
                            label: intl.bhpPositionStandardsActiveCount(
                              state.standards
                                  .where((item) => item.aktywny)
                                  .length,
                            ),
                            tone: AppStatusBadgeTone.success,
                            icon: Icons.done_all_rounded,
                          ),
                          AppStatusBadge(
                            label: intl.bhpPositionStandardsEquipmentPoolCount(
                              state.equipment.length,
                            ),
                            icon: Icons.category_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Gaps.h16,
              ],
              AppSectionCard(
                child: SizedBox(
                  height: 520,
                  child: state.filteredStandards.isEmpty
                      ? AppEmptyState.noData(
                          title: intl.bhpPositionStandardsEmptyTitle,
                          message: intl.bhpPositionStandardsEmptyMessage,
                        )
                      : AppSimpleTable<GetBhpUserStandardItem>(
                          rows: state.filteredStandards,
                          height: null,
                          stateId:
                              'bhp_position_standards_table_${position.id}',
                          persistState: true,
                          onRowTap: (context, row, sourceIndex) =>
                              _openEditStandard(context, position, row),
                          columns: [
                            AppSimpleTableColumn(
                              label: 'Symbol',
                              width: 120,
                              cellBuilder: (context, row) => Text(
                                row.kartaWyposazeniaSymbol ?? '—',
                              ),
                            ),
                            AppSimpleTableColumn(
                              label: intl.bhpTableEquipment,
                              width: 280,
                              cellBuilder: (context, row) =>
                                  Text(row.kartaWyposazeniaNazwa ?? '—'),
                            ),
                            AppSimpleTableColumn(
                              label: 'Jm',
                              width: 80,
                              cellBuilder: (context, row) =>
                                  Text(row.kartaWyposazeniaJm ?? '—'),
                            ),
                            AppSimpleTableColumn(
                              label: intl.bhpTableQuantity,
                              width: 90,
                              numeric: true,
                              cellAlignment: .centerRight,
                              cellBuilder: (context, row) =>
                                  Text(row.ilosc ?? '—'),
                            ),
                            AppSimpleTableColumn(
                              label: 'Okres',
                              width: 100,
                              numeric: true,
                              cellAlignment: .centerRight,
                              cellBuilder: (context, row) =>
                                  Text(row.okres?.toString() ?? '—'),
                            ),
                            AppSimpleTableColumn(
                              label: 'Uwagi',
                              width: 260,
                              cellBuilder: (context, row) => Text(
                                row.uwagi?.trim().isNotEmpty == true
                                    ? row.uwagi!.trim()
                                    : '—',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            AppSimpleTableColumn(
                              label: intl.bhpTableStatus,
                              width: 120,
                              sortable: false,
                              cellAlignment: .center,
                              cellBuilder: (context, row) => AppStatusBadge(
                                label: row.aktywny
                                    ? intl.bhpStatusActive
                                    : intl.bhpPositionsFilterInactive,
                                tone: row.aktywny
                                    ? AppStatusBadgeTone.success
                                    : AppStatusBadgeTone.neutral,
                                icon: row.aktywny
                                    ? Icons.check_circle_outline_rounded
                                    : Icons.remove_circle_outline_rounded,
                              ),
                            ),
                            AppSimpleTableColumn(
                              label: intl.inventoryActionsLabel,
                              width: 150,
                              sortable: false,
                              cellAlignment: .center,
                              cellBuilder: (context, row) =>
                                  AppContextMenuButton(
                                    label: intl.inventoryActionsLabel,
                                    icon: Icons.more_horiz_rounded,
                                    dense: true,
                                    menuHeaderTitle:
                                        row.kartaWyposazeniaSymbol ?? 'Pozycja',
                                    menuHeaderSubtitle:
                                        row.kartaWyposazeniaNazwa,
                                    actions: _buildStandardActions(
                                      context,
                                      position,
                                      row,
                                    ),
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

List<AppContextMenuAction> _buildStandardActions(
  BuildContext context,
  GetBhpPositionListItem position,
  GetBhpUserStandardItem standard,
) {
  final colors = context.colors;

  return [
    AppContextMenuAction(
      label: context.l10n.edit,
      icon: Icons.edit_outlined,
      foregroundColor: colors.primary,
      onTap: (_) => _openEditStandard(context, position, standard),
    ),
    if (!standard.aktywny)
      AppContextMenuAction(
        label: context.l10n.delete,
        icon: Icons.delete_outline_rounded,
        isDestructive: true,
        foregroundColor: colors.error,
        onTap: (_) => _deleteStandard(context, standard),
      ),
    if (!standard.aktywny)
      AppContextMenuAction(
        label: context.l10n.bhpPositionStandardsRestoreAction,
        icon: Icons.settings_backup_restore_rounded,
        foregroundColor: colors.tertiary,
        onTap: (_) => _restoreStandard(context, standard),
      ),
    if (standard.aktywny)
      AppContextMenuAction(
        label: context.l10n.bhpPositionStandardsArchiveAction,
        icon: Icons.archive_outlined,
        isDestructive: true,
        foregroundColor: colors.error,
        onTap: (_) => _archiveStandard(context, standard),
      ),
  ];
}

Future<void> _openCreateStandard(
  BuildContext context,
  GetBhpPositionListItem position,
) async {
  await showBhpPositionStandardEditorModal(context, position: position);
}

Future<void> _openEditStandard(
  BuildContext context,
  GetBhpPositionListItem position,
  GetBhpUserStandardItem standard,
) async {
  await showBhpPositionStandardEditorModal(
    context,
    position: position,
    standard: standard,
  );
}

Future<void> _archiveStandard(
  BuildContext context,
  GetBhpUserStandardItem standard,
) async {
  final confirmed = await AppConfirmDialog.show(
    context,
    title: context.l10n.bhpPositionStandardsArchiveTitle,
    message: context.l10n.bhpPositionStandardsArchiveMessage(
      standard.kartaWyposazeniaSymbol ?? '—',
    ),
    confirmLabel: context.l10n.bhpPositionStandardsArchiveAction,
    tone: AppConfirmDialogTone.danger,
  );
  if (!context.mounted || !confirmed) {
    return;
  }

  final result = await context
      .read<BhpPositionStandardsCubit>()
      .archiveStandard(
        standard.id,
      );
  if (!context.mounted) {
    return;
  }

  result.fold(
    (error) => AppToast.show(
      context,
      message: error.message,
      tone: AppToastTone.error,
    ),
    (_) => AppToast.show(
      context,
      message: context.l10n.bhpPositionStandardsArchiveSuccess,
      tone: AppToastTone.success,
    ),
  );
}

Future<void> _restoreStandard(
  BuildContext context,
  GetBhpUserStandardItem standard,
) async {
  final confirmed = await AppConfirmDialog.show(
    context,
    title: context.l10n.bhpPositionStandardsRestoreTitle,
    message: context.l10n.bhpPositionStandardsRestoreMessage(
      standard.kartaWyposazeniaSymbol ?? '—',
    ),
    confirmLabel: context.l10n.bhpPositionStandardsRestoreAction,
    tone: AppConfirmDialogTone.warning,
  );
  if (!context.mounted || !confirmed) {
    return;
  }

  final result = await context
      .read<BhpPositionStandardsCubit>()
      .unarchiveStandard(
        standard.id,
      );
  if (!context.mounted) {
    return;
  }

  result.fold(
    (error) => AppToast.show(
      context,
      message: error.message,
      tone: AppToastTone.error,
    ),
    (_) => AppToast.show(
      context,
      message: context.l10n.bhpPositionStandardsRestoreSuccess,
      tone: AppToastTone.success,
    ),
  );
}

Future<void> _deleteStandard(
  BuildContext context,
  GetBhpUserStandardItem standard,
) async {
  final confirmed = await AppConfirmDialog.show(
    context,
    title: context.l10n.bhpPositionStandardsDeleteTitle,
    message: context.l10n.bhpPositionStandardsDeleteMessage(
      standard.kartaWyposazeniaSymbol ?? '—',
    ),
    confirmLabel: context.l10n.delete,
    tone: AppConfirmDialogTone.danger,
  );
  if (!context.mounted || !confirmed) {
    return;
  }

  final result = await context.read<BhpPositionStandardsCubit>().deleteStandard(
    standard.id,
  );
  if (!context.mounted) {
    return;
  }

  result.fold(
    (error) => AppToast.show(
      context,
      message: error.message,
      tone: AppToastTone.error,
    ),
    (_) => AppToast.show(
      context,
      message: context.l10n.bhpPositionStandardsDeleteSuccess,
      tone: AppToastTone.success,
    ),
  );
}
