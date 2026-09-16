import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/operations/cubit/bhp_issue_operations_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/operations/cubit/bhp_issue_operations_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_module_section.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_status_badge.dart';

/// Globalna historia operacji BHP.
class BhpIssueOperationsPage extends StatelessWidget {
  /// Tworzy globalną historię operacji BHP.
  const BhpIssueOperationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = BhpIssueOperationsCubit(
          repository: context.read<BhpDashboardRepository>(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child: const _BhpIssueOperationsContent(),
    );
  }
}

/// Zawartość globalnej historii operacji BHP.
class _BhpIssueOperationsContent extends StatelessWidget {
  /// Tworzy zawartość historii operacji BHP.
  const _BhpIssueOperationsContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BhpIssueOperationsCubit, BhpIssueOperationsState>(
      builder: (context, state) {
        final cubit = context.read<BhpIssueOperationsCubit>();
        final intl = context.l10n;
        final selectedYear = state.year;
        final years = List<int>.generate(
          5,
          (index) => DateTime.now().year - index,
        );

        return AppModuleSection(
          title: intl.bhpOperationsTitle,
          subtitle: switch (state) {
            BhpIssueOperationsSuccess(:final data) =>
              '${intl.bhpOperationsSubtitle} ${data.year} (${data.count})',
            _ => intl.bhpOperationsSubtitle,
          },
          chips: [
            for (final year in years)
              AppActionChip(
                label: year.toString(),
                icon: Icons.calendar_month_rounded,
                selected: selectedYear == year,
                tone: .primary,
                onPressed: () => cubit.load(year),
              ),
          ],
          actions: [
            AppActionPill(
              label: context.l10n.bhpRefreshAction,
              icon: Icons.refresh_rounded,
              tone: .contrast,
              onPressed: cubit.load,
            ),
          ],
          child: switch (state) {
            BhpIssueOperationsInitial() ||
            BhpIssueOperationsLoading() => const Center(
              child: AppSpinner(),
            ),
            BhpIssueOperationsError(:final message) => Center(
              child: AppEmptyState.error(
                title: intl.bhpOperationsTitle,
                message: message,
              ),
            ),
            BhpIssueOperationsSuccess(:final data) => AppSectionCard(
              expandChild: true,
              child: data.items.isEmpty
                  ? AppEmptyState.noData(
                      title: intl.bhpOperationsEmptyTitle,
                      message: intl.bhpOperationsEmptyMessage,
                    )
                  : AppSimpleTable<GetBhpIssueOperationItem>(
                      rows: data.items,
                      height: null,
                      stateId: 'bhp_issue_operations_table_v3',
                      persistState: true,
                      showSearch: true,
                      searchHintText: intl.bhpOperationsSearchHint,
                      searchMatcher: _matchOperationSearch,
                      rowHeight: 52,
                      columns: [
                        AppSimpleTableColumn(
                          label: 'Data',
                          width: 130,
                          sortValue: (row) => row.occurredAt,
                          cellBuilder: (context, row) =>
                              Text(row.occurredAt.toAppDate(placeholder: '—')),
                        ),
                        AppSimpleTableColumn(
                          label: 'Operacja',
                          width: 150,
                          sortValue: (row) => row.typeLabel.toLowerCase(),
                          cellAlignment: .center,
                          cellBuilder: (context, row) => AppStatusBadge(
                            label: row.typeLabel,
                            tone: switch (row.type) {
                              'issued' => AppStatusBadgeTone.success,
                              'closed' => AppStatusBadgeTone.warning,
                              'equivalent_registered' =>
                                AppStatusBadgeTone.info,
                              _ => AppStatusBadgeTone.neutral,
                            },
                            icon: switch (row.type) {
                              'issued' => Icons.call_received_rounded,
                              'closed' => Icons.call_made_rounded,
                              'equivalent_registered' =>
                                Icons.payments_outlined,
                              _ => Icons.change_circle_outlined,
                            },
                          ),
                        ),
                        AppSimpleTableColumn(
                          label: intl.bhpUsersTitle,
                          width: 240,
                          sortValue: (row) =>
                              row.formattedUserFullName.toLowerCase(),
                          cellBuilder: (context, row) =>
                              Text(row.formattedUserFullName),
                        ),
                        AppSimpleTableColumn(
                          label: intl.bhpTableEquipmentName,
                          width: 320,
                          sortValue: (row) => row.equipmentLabel.toLowerCase(),
                          cellBuilder: (context, row) => Text(
                            row.equipmentLabel,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        AppSimpleTableColumn(
                          label: intl.bhpTableQuantity,
                          width: 90,
                          sortValue: (row) =>
                              double.tryParse(row.quantity ?? '') ?? 0,
                          cellAlignment: .center,
                          cellBuilder: (context, row) =>
                              Text(row.quantity ?? '—'),
                        ),
                        AppSimpleTableColumn(
                          label: 'Szczegóły',
                          width: 420,
                          sortValue: (row) => row.details.toLowerCase(),
                          cellBuilder: (context, row) => Text(
                            row.details,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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

bool _matchOperationSearch(GetBhpIssueOperationItem row, String query) {
  final phrase = query.toLowerCase();
  return row.formattedUserFullName.toLowerCase().contains(phrase) ||
      row.equipmentLabel.toLowerCase().contains(phrase) ||
      row.details.toLowerCase().contains(phrase) ||
      row.typeLabel.toLowerCase().contains(phrase) ||
      row.occurredAt.toLowerCase().contains(phrase) ||
      (row.stanowiskoNazwa?.toLowerCase().contains(phrase) ?? false);
}
