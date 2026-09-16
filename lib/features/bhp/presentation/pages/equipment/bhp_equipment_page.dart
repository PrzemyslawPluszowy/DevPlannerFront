import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_equipment_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/add_equipment/add_equipment_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/cubit/bhp_equipment_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/cubit/bhp_equipment_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/edit_equipment/edit_equipment_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/equipment/equipment_activation/equipment_activation_export.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_section.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';

/// Ekran sekcji wyposażenia BHP.
class BhpEquipmentPage extends StatelessWidget {
  /// Tworzy ekran sekcji wyposażenia BHP.
  const BhpEquipmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = BhpEquipmentCubit(
          repository: context.read<BhpEquipmentRepository>(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const _BhpEquipmentContent(),
    );
  }
}

/// Zawartość sekcji wyposażenia BHP.
class _BhpEquipmentContent extends StatelessWidget {
  /// Tworzy zawartość sekcji wyposażenia BHP.
  const _BhpEquipmentContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhpEquipmentCubit, BhpEquipmentState>(
      builder: (context, state) {
        final cubit = context.read<BhpEquipmentCubit>();
        final intl = context.l10n;
        final selectedFilter = switch (state) {
          BhpEquipmentSuccess(:final filter) => filter,
          _ => cubit.filter,
        };

        return AppModuleSection(
          title: intl.bhpEquipmentTitle,
          subtitle: switch (state) {
            BhpEquipmentSuccess(:final items) => intl.bhpEquipmentSubtitle(
              items.where((row) => row.aktywny).length,
              items.length,
            ),
            _ => intl.bhpEquipmentSectionSubtitle,
          },
          chips: [
            AppActionChip(
              label: 'Aktywne',
              icon: Icons.check_circle_outline_rounded,
              tooltip: intl.bhpEquipmentFilterActiveTooltip,
              selected: selectedFilter == BhpEquipmentFilter.aktywne,
              tone: .primary,
              onPressed: () => cubit.load(BhpEquipmentFilter.aktywne),
            ),
            AppActionChip(
              label: 'Nieaktywne',
              icon: Icons.pause_circle_outline_rounded,
              tooltip: intl.bhpEquipmentFilterInactiveTooltip,
              selected: selectedFilter == BhpEquipmentFilter.nieaktywne,
              tone: .primary,
              onPressed: () => cubit.load(BhpEquipmentFilter.nieaktywne),
            ),
            AppActionChip(
              label: 'Wszystkie',
              icon: Icons.inventory_2_outlined,
              tooltip: intl.bhpEquipmentFilterAllTooltip,
              selected: selectedFilter == BhpEquipmentFilter.wszystkie,
              tone: .primary,
              onPressed: () => cubit.load(BhpEquipmentFilter.wszystkie),
            ),
          ],
          actions: [
            AppActionPill(
              label: intl.inventoryAdd,
              icon: Icons.add_box_outlined,
              tone: .primary,
              onPressed: () => _handleAddEquipment(context, cubit),
            ),
            AppActionPill(
              label: intl.bhpRefreshAction,
              icon: Icons.refresh_rounded,
              tone: .contrast,
              onPressed: cubit.load,
            ),
          ],
          child: switch (state) {
            BhpEquipmentInitial() || BhpEquipmentLoading() => const Center(
              child: AppSpinner(),
            ),
            BhpEquipmentError(:final message) => Center(
              child: AppEmptyState.error(
                title: intl.bhpEquipmentErrorTitle,
                message: message,
              ),
            ),
            BhpEquipmentSuccess(:final items) => AppSectionCard(
              expandChild: true,
              child: items.isEmpty
                  ? AppEmptyState.noData(
                      title: intl.bhpEquipmentEmptyTitle,
                      message: intl.bhpEquipmentEmptyMessage,
                    )
                  : AppSimpleTable<GetBhpEquipmentListItem>(
                      rows: items,
                      height: null,
                      stateId: 'bhp_equipment_table_v2',
                      persistState: true,
                      onRowTap: (context, row, sourceIndex) =>
                          _handleEditEquipment(context, cubit, row),
                      onRowSecondaryTap: (context, row, sourceIndex, details) =>
                          _showEquipmentActionsMenu(
                            context,
                            cubit: cubit,
                            row: row,
                            fromPointer: details.globalPosition,
                          ),
                      showSearch: true,
                      searchHintText: intl.bhpEquipmentSearchHint,
                      searchMatcher: (row, query) {
                        final phrase = query.toLowerCase();
                        return row.symbol.toLowerCase().contains(phrase) ||
                            row.nazwa.toLowerCase().contains(phrase) ||
                            (row.jm ?? '').toLowerCase().contains(phrase);
                      },
                      columns: [
                        AppSimpleTableColumn(
                          label: intl.bhpTableSymbol,
                          width: 120,
                          sortValue: (row) => row.symbol.toLowerCase(),
                          cellBuilder: (context, row) => Text(row.symbol),
                        ),
                        AppSimpleTableColumn(
                          label: intl.bhpTableEquipment,
                          width: 260,
                          sortValue: (row) => row.nazwa.toLowerCase(),
                          cellBuilder: (context, row) => Text(row.nazwa),
                        ),
                        AppSimpleTableColumn(
                          label: intl.bhpTableUnit,
                          width: 90,
                          sortValue: (row) => row.jm?.toLowerCase() ?? '',
                          cellBuilder: (context, row) => Text(row.jm ?? '—'),
                        ),
                        AppSimpleTableColumn(
                          label: intl.bhpTablePeriod,
                          width: 120,
                          sortValue: (row) => row.okresUzywalnosci ?? '',
                          cellBuilder: (context, row) =>
                              Text(row.okresUzywalnosci ?? '—'),
                        ),
                        AppSimpleTableColumn(
                          label: intl.bhpTableDefaultQuantity,
                          width: 120,
                          sortValue: (row) => row.iloscDomyslna ?? '',
                          cellBuilder: (context, row) =>
                              Text(row.iloscDomyslna ?? '—'),
                        ),
                        AppSimpleTableColumn(
                          label: 'Ekwiwalent',
                          width: 120,
                          sortValue: (row) => row.ekwiwalent ?? '',
                          cellBuilder: (context, row) =>
                              Text(row.ekwiwalent ?? '—'),
                        ),
                        AppSimpleTableColumn(
                          label: intl.bhpTablePrice,
                          width: 110,
                          sortValue: (row) => row.cena ?? '',
                          cellBuilder: (context, row) => Text(row.cena ?? '—'),
                        ),
                        AppSimpleTableColumn(
                          label: intl.bhpTableStatus,
                          width: 130,
                          sortable: false,
                          cellBuilder: (context, row) => AppStatusBadge(
                            label: row.aktywny
                                ? intl.bhpStatusActive
                                : intl.bhpStatusInactive,
                            tone: row.aktywny
                                ? AppStatusBadgeTone.success
                                : AppStatusBadgeTone.warning,
                            icon: row.aktywny
                                ? Icons.check_circle_outline_rounded
                                : Icons.pause_circle_outline_rounded,
                            tooltip: row.aktywny
                                ? intl.bhpEquipmentStatusActiveTooltip
                                : intl.bhpEquipmentStatusInactiveTooltip,
                          ),
                        ),
                        AppSimpleTableColumn(
                          label: intl.inventoryActionsLabel,
                          width: 150,
                          sortable: false,
                          cellAlignment: .center,
                          cellBuilder: (context, row) => AppContextMenuButton(
                            label: intl.inventoryActionsLabel,
                            icon: Icons.more_horiz_rounded,
                            dense: true,
                            menuHeaderTitle: row.symbol,
                            menuHeaderSubtitle: row.nazwa,
                            actions: _buildEquipmentActions(
                              context,
                              cubit,
                              row,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          },
        );
      },
    );
  }
}

List<AppContextMenuAction> _buildEquipmentActions(
  BuildContext context,
  BhpEquipmentCubit cubit,
  GetBhpEquipmentListItem row,
) {
  final colors = context.colors;

  return [
    AppContextMenuAction(
      label: context.l10n.edit,
      icon: Icons.edit_outlined,
      foregroundColor: colors.primary,
      onTap: (_) => _handleEditEquipment(context, cubit, row),
    ),
    if (!row.aktywny)
      AppContextMenuAction(
        label: context.l10n.bhpEquipmentSetActiveAction,
        icon: Icons.check_circle_outline_rounded,
        foregroundColor: colors.tertiary,
        onTap: (_) => _handleSetEquipmentActive(context, cubit, row),
      ),
    if (row.aktywny)
      AppContextMenuAction(
        label: context.l10n.bhpEquipmentSetInactiveAction,
        icon: Icons.pause_circle_outline_rounded,
        isDestructive: true,
        foregroundColor: colors.error,
        onTap: (_) => _handleSetEquipmentInactive(context, cubit, row),
      ),
  ];
}

Future<void> _showEquipmentActionsMenu(
  BuildContext context, {
  required BhpEquipmentCubit cubit,
  required GetBhpEquipmentListItem row,
  required Offset fromPointer,
}) async {
  final actions = _buildEquipmentActions(context, cubit, row);
  if (actions.isEmpty) {
    return;
  }

  final overlayBox =
      Overlay.of(context).context.findRenderObject()! as RenderBox;
  final selectedIndex = await showMenu<int>(
    context: context,
    position: RelativeRect.fromLTRB(
      fromPointer.dx,
      fromPointer.dy,
      overlayBox.size.width - fromPointer.dx,
      overlayBox.size.height - fromPointer.dy,
    ),
    items: [
      PopupMenuItem<int>(
        enabled: false,
        height: 56,
        child: Column(
          crossAxisAlignment: .start,
          mainAxisAlignment: .center,
          children: [
            Text(
              row.symbol,
              maxLines: 1,
              overflow: .ellipsis,
              style: context.text.labelLarge?.copyWith(fontWeight: .w700),
            ),
            Gaps.h2,
            Text(
              row.nazwa,
              maxLines: 1,
              overflow: .ellipsis,
              style: context.text.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      const PopupMenuDivider(),
      for (final entry in actions.indexed)
        PopupMenuItem<int>(
          value: entry.$1,
          child: Row(
            children: [
              if (entry.$2.icon case final icon?) ...[
                Icon(
                  icon,
                  size: 18,
                  color:
                      entry.$2.foregroundColor ??
                      (entry.$2.isDestructive
                          ? context.colors.error
                          : context.colors.primary),
                ),
                Gaps.w8,
              ],
              Text(
                entry.$2.label,
                style: context.text.labelLarge?.copyWith(
                  color:
                      entry.$2.foregroundColor ??
                      (entry.$2.isDestructive
                          ? context.colors.error
                          : context.colors.primary),
                  fontWeight: .w500,
                ),
              ),
            ],
          ),
        ),
    ],
  );

  if (!context.mounted || selectedIndex == null) {
    return;
  }

  await actions[selectedIndex].onTap(context);
}

Future<void> _handleAddEquipment(
  BuildContext context,
  BhpEquipmentCubit cubit,
) async {
  final created = await showAddBhpEquipmentModal(context);
  if (!context.mounted || created == null) {
    return;
  }

  AppToast.show(
    context,
    message: 'Lista wyposażenia została odświeżona po dodaniu pozycji.',
    tone: AppToastTone.success,
  );
  await cubit.load();
}

Future<void> _handleEditEquipment(
  BuildContext context,
  BhpEquipmentCubit cubit,
  GetBhpEquipmentListItem row,
) async {
  final updated = await showEditBhpEquipmentModal(context, item: row);
  if (!context.mounted || updated == null) {
    return;
  }

  await cubit.load();
}

Future<void> _handleSetEquipmentInactive(
  BuildContext context,
  BhpEquipmentCubit cubit,
  GetBhpEquipmentListItem row,
) async {
  final changed = await showBhpEquipmentActivationModal(
    context,
    item: row,
    mode: BhpEquipmentActivationMode.setInactive,
  );
  if (!context.mounted || changed != true) {
    return;
  }

  await cubit.load();
}

Future<void> _handleSetEquipmentActive(
  BuildContext context,
  BhpEquipmentCubit cubit,
  GetBhpEquipmentListItem row,
) async {
  final changed = await showBhpEquipmentActivationModal(
    context,
    item: row,
    mode: BhpEquipmentActivationMode.setActive,
  );
  if (!context.mounted || changed != true) {
    return;
  }

  await cubit.load();
}
