import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_positions_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/add_position/add_position_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/archive_position/archive_position_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/cubit/bhp_positions_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/cubit/bhp_positions_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/edit_position/edit_position_export.dart';
import 'package:ready_next/features/bhp/presentation/pages/positions/position_users/bhp_position_users_modal.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_confirm_dialog.dart';
import 'package:ready_next/shared/presentation/widgets/app_context_menu_button.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_section.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';
import 'package:ready_next/shared/presentation/widgets/app_text.dart';
import 'package:ready_next/shared/presentation/widgets/app_text_field.dart';
import 'package:ready_next/shared/presentation/widgets/app_toast.dart';
import 'package:ready_next/shared/utils/validators/app_validators.dart';

/// Ekran sekcji stanowisk BHP.
class BhpPositionsPage extends StatelessWidget {
  /// Tworzy ekran sekcji stanowisk BHP.
  const BhpPositionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = BhpPositionsCubit(
          repository: context.read<BhpPositionsRepository>(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const _BhpPositionsContent(),
    );
  }
}

/// Zawartość sekcji stanowisk BHP.
class _BhpPositionsContent extends StatelessWidget {
  /// Tworzy zawartość sekcji stanowisk BHP.
  const _BhpPositionsContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhpPositionsCubit, BhpPositionsState>(
      builder: (context, state) {
        final cubit = context.read<BhpPositionsCubit>();
        final intl = context.l10n;
        final selectedFilter = switch (state) {
          BhpPositionsSuccess(:final filter) => filter,
          _ => cubit.filter,
        };

        return AppModuleSection(
          title: intl.bhpPositionsTitle,
          subtitle: switch (state) {
            BhpPositionsSuccess(:final items) => intl.bhpPositionsSubtitle(
              items.where((row) => row.aktywny).length,
              items.length,
            ),
            _ => intl.bhpPositionsSectionSubtitle,
          },
          chips: [
            AppActionChip(
              label: 'Aktywne',
              icon: Icons.check_circle_outline_rounded,
              selected: selectedFilter == BhpPositionsFilter.aktywne,
              tone: .primary,
              onPressed: () => cubit.load(BhpPositionsFilter.aktywne),
            ),
            AppActionChip(
              label: intl.bhpPositionsFilterInactive,
              icon: Icons.pause_circle_outline_rounded,
              selected: selectedFilter == BhpPositionsFilter.nieaktywne,
              tone: .primary,
              onPressed: () => cubit.load(BhpPositionsFilter.nieaktywne),
            ),
            AppActionChip(
              label: intl.bhpPositionsFilterAll,
              icon: Icons.work_outline_rounded,
              selected: selectedFilter == BhpPositionsFilter.wszystkie,
              tone: .primary,
              onPressed: () => cubit.load(BhpPositionsFilter.wszystkie),
            ),
          ],
          actions: [
            AppActionPill(
              label: intl.inventoryAdd,
              icon: Icons.add_box_outlined,
              tone: .primary,
              onPressed: () => _handleAddPosition(context, cubit),
            ),
            AppActionPill(
              label: intl.bhpRefreshAction,
              icon: Icons.refresh_rounded,
              tone: .contrast,
              onPressed: cubit.load,
            ),
          ],
          child: switch (state) {
            BhpPositionsInitial() || BhpPositionsLoading() => const Center(
              child: AppSpinner(),
            ),
            BhpPositionsError(:final message) => Center(
              child: AppEmptyState.error(
                title: intl.bhpPositionsErrorTitle,
                message: message,
              ),
            ),
            BhpPositionsSuccess(:final items) => AppSectionCard(
              expandChild: true,
              child: items.isEmpty
                  ? AppEmptyState.noData(
                      title: intl.bhpPositionsEmptyTitle,
                      message: intl.bhpPositionsEmptyMessage,
                    )
                  : AppSimpleTable<GetBhpPositionListItem>(
                      rows: items,
                      height: null,
                      stateId: 'bhp_positions_table_v2',
                      persistState: true,
                      onRowTap: (context, row, sourceIndex) =>
                          _handleEditPosition(context, cubit, row),
                      onRowSecondaryTap: (context, row, sourceIndex, details) =>
                          _showPositionActionsMenu(
                            context,
                            cubit: cubit,
                            row: row,
                            fromPointer: details.globalPosition,
                          ),
                      showSearch: true,
                      searchHintText: intl.bhpPositionsSearchHint,
                      searchMatcher: (row, query) {
                        final phrase = query.toLowerCase();
                        return row.nazwa.toLowerCase().contains(phrase) ||
                            (row.uwagi ?? '').toLowerCase().contains(phrase);
                      },
                      columns: [
                        AppSimpleTableColumn(
                          label: 'ID',
                          width: 80,
                          sortValue: (row) => row.id,
                          cellBuilder: (context, row) => Text('${row.id}'),
                        ),
                        AppSimpleTableColumn(
                          label: intl.bhpTablePosition,
                          width: 280,
                          sortValue: (row) => row.nazwa.toLowerCase(),
                          cellBuilder: (context, row) => Text(row.nazwa),
                        ),
                        AppSimpleTableColumn(
                          label: intl.bhpTableNotes,
                          width: 420,
                          sortValue: (row) => row.uwagi?.toLowerCase() ?? '',
                          cellBuilder: (context, row) => Text(row.uwagi ?? '—'),
                        ),
                        AppSimpleTableColumn(
                          label: intl.bhpSectionUsers,
                          width: 110,
                          numeric: true,
                          sortValue: (row) => row.pracownicyCount ?? 0,
                          cellBuilder: (context, row) {
                            final employeesCount = row.pracownicyCount ?? 0;

                            if (employeesCount <= 0) {
                              return Text('$employeesCount');
                            }

                            return InkWell(
                              onTap: () => showBhpPositionUsersModal(
                                context,
                                position: row,
                              ),
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Sizes.p4,
                                  vertical: Sizes.p2,
                                ),
                                child: Text(
                                  '$employeesCount',
                                  style: context.text.bodyMedium?.copyWith(
                                    color: context.colors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            );
                          },
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
                            menuHeaderTitle: row.nazwa,
                            menuHeaderSubtitle: row.aktywny
                                ? intl.bhpStatusActive
                                : intl.bhpStatusInactive,
                            actions: _buildPositionActions(context, cubit, row),
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

List<AppContextMenuAction> _buildPositionActions(
  BuildContext context,
  BhpPositionsCubit cubit,
  GetBhpPositionListItem row,
) {
  final colors = context.colors;

  return [
    AppContextMenuAction(
      label: context.l10n.edit,
      icon: Icons.edit_outlined,
      foregroundColor: colors.primary,
      onTap: (_) => _handleEditPosition(context, cubit, row),
    ),
    AppContextMenuAction(
      label: 'Duplikuj',
      icon: Icons.copy_rounded,
      foregroundColor: colors.primary,
      onTap: (_) => _handleDuplicatePosition(context, cubit, row),
    ),
    if (!row.aktywny) ...[
      AppContextMenuAction(
        label: context.l10n.bhpPositionsRestoreAction,
        icon: Icons.settings_backup_restore_rounded,
        foregroundColor: colors.tertiary,
        onTap: (_) => _handleRestorePosition(context, cubit, row),
      ),
      AppContextMenuAction(
        label: context.l10n.delete,
        icon: Icons.delete_forever_rounded,
        isDestructive: true,
        foregroundColor: colors.error,
        onTap: (_) => _handleDeletePosition(context, cubit, row),
      ),
    ],
    if (row.aktywny)
      AppContextMenuAction(
        label: 'Archiwizuj',
        icon: Icons.archive_outlined,
        isDestructive: true,
        foregroundColor: colors.error,
        onTap: (_) => _handleArchivePosition(context, cubit, row),
      ),
  ];
}

Future<void> _showPositionActionsMenu(
  BuildContext context, {
  required BhpPositionsCubit cubit,
  required GetBhpPositionListItem row,
  required Offset fromPointer,
}) async {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
  if (overlay == null || !context.mounted) {
    return;
  }

  final selected = await showMenu<AppContextMenuAction>(
    context: context,
    position: RelativeRect.fromLTRB(
      fromPointer.dx,
      fromPointer.dy,
      overlay.size.width - fromPointer.dx,
      overlay.size.height - fromPointer.dy,
    ),
    items: [
      for (final action in _buildPositionActions(context, cubit, row))
        PopupMenuItem<AppContextMenuAction>(
          value: action,
          child: Row(
            children: [
              Icon(action.icon, size: 18, color: action.foregroundColor),
              Gaps.w8,
              Expanded(child: Text(action.label)),
            ],
          ),
        ),
    ],
  );

  if (!context.mounted) {
    return;
  }

  selected?.onTap(context);
}

Future<void> _handleAddPosition(
  BuildContext context,
  BhpPositionsCubit cubit,
) async {
  final created = await showAddBhpPositionModal(context);
  if (!context.mounted || created == null) {
    return;
  }

  await cubit.load();
}

Future<void> _handleEditPosition(
  BuildContext context,
  BhpPositionsCubit cubit,
  GetBhpPositionListItem item,
) async {
  await showEditBhpPositionModal(context, item: item);
  if (!context.mounted) {
    return;
  }

  await cubit.load();
}

Future<void> _handleArchivePosition(
  BuildContext context,
  BhpPositionsCubit cubit,
  GetBhpPositionListItem item,
) async {
  final archived = await showArchiveBhpPositionModal(context, item: item);
  if (!context.mounted || archived != true) {
    return;
  }

  AppToast.show(
    context,
    message: 'Zarchiwizowano stanowisko ${item.nazwa}.',
    tone: AppToastTone.success,
  );
  await cubit.load();
}

Future<void> _handleRestorePosition(
  BuildContext context,
  BhpPositionsCubit cubit,
  GetBhpPositionListItem item,
) async {
  final confirmed = await AppConfirmDialog.show(
    context,
    title: context.l10n.bhpPositionsRestoreTitle,
    message: context.l10n.bhpPositionsRestoreMessage(item.nazwa),
    confirmLabel: context.l10n.bhpPositionsRestoreAction,
    tone: AppConfirmDialogTone.warning,
  );
  if (!context.mounted || !confirmed) {
    return;
  }

  final result = await cubit.unarchivePosition(item.id);
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
      message: context.l10n.bhpPositionsRestoreSuccess(item.nazwa),
      tone: AppToastTone.success,
    ),
  );
}

/// Pokazuje dialog duplikowania stanowiska BHP, umożliwiając podanie nowej nazwy.
Future<void> _handleDuplicatePosition(
  BuildContext context,
  BhpPositionsCubit cubit,
  GetBhpPositionListItem item,
) async {
  final controller = TextEditingController(text: '${item.nazwa} - Kopia');
  final formKey = GlobalKey<FormState>();

  final duplicated = await AppConfirmDialog.show(
    context,
    title: 'Duplikuj stanowisko',
    message: '',
    confirmLabel: 'Duplikuj',
    cancelLabel: context.l10n.cancel,
    content: Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          AppText(
            'Podaj nazwę dla zduplikowanego stanowiska:',
            style: context.text.bodyMedium,
          ),
          Gaps.h12,
          AppTextField(
            controller: controller,
            labelText: 'Nazwa stanowiska',
            validator: AppValidators.required(
              message: 'Nazwa nie może być pusta',
            ),
          ),
        ],
      ),
    ),
    onConfirm: () async {
      if (!formKey.currentState!.validate()) {
        return false;
      }
      final result = await cubit.duplicatePosition(
        item.id,
        controller.text.trim(),
      );
      return result.fold(
        (error) {
          if (context.mounted) {
            AppToast.show(
              context,
              message: error.message,
              tone: AppToastTone.error,
            );
          }
          return false;
        },
        (_) => true,
      );
    },
  );

  if (duplicated && context.mounted) {
    AppToast.show(
      context,
      message: 'Zduplikowano stanowisko pod nazwą "${controller.text.trim()}".',
      tone: AppToastTone.success,
    );
  }

  controller.dispose();
}

/// Pokazuje dialog potwierdzenia usunięcia stanowiska BHP z bazy.
Future<void> _handleDeletePosition(
  BuildContext context,
  BhpPositionsCubit cubit,
  GetBhpPositionListItem item,
) async {
  final confirmed = await AppConfirmDialog.show(
    context,
    title: 'Usuń stanowisko',
    message:
        'Czy na pewno chcesz trwale usunąć stanowisko „${item.nazwa}”?\nTej operacji nie można cofnąć.',
    confirmLabel: 'Usuń',
    cancelLabel: context.l10n.cancel,
    tone: AppConfirmDialogTone.danger,
  );
  if (!context.mounted || !confirmed) {
    return;
  }

  final result = await cubit.deletePosition(item.id);
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
      message: 'Pomyślnie usunięto stanowisko „${item.nazwa}”.',
      tone: AppToastTone.success,
    ),
  );
}
