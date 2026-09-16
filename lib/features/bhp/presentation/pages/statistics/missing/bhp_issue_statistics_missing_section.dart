import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/extensions/date_extensions.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/bhp_employee_name.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/missing/cubit/bhp_issue_statistics_missing_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/missing/cubit/bhp_issue_statistics_missing_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/users/user_issues/bhp_user_issues_modal.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_tooltip.dart';

/// Sekcja segmentu `Braki` oparta o globalny endpoint braków.
class BhpIssueStatisticsMissingSection extends StatelessWidget {
  /// Tworzy sekcję statystyk braków.
  const BhpIssueStatisticsMissingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = BhpIssueStatisticsMissingCubit(
          repository: context.read<BhpDashboardRepository>(),
        );
        unawaited(cubit.load());
        return cubit;
      },
      child:
          BlocBuilder<
            BhpIssueStatisticsMissingCubit,
            BhpIssueStatisticsMissingState
          >(
            builder: (context, state) {
              final intl = context.l10n;
              final cubit = context.read<BhpIssueStatisticsMissingCubit>();
              final data = state.data;

              if (state is BhpIssueStatisticsMissingLoading && data == null) {
                return const Center(
                  child: Padding(
                    padding: .symmetric(vertical: Sizes.p48),
                    child: AppSpinner(size: Sizes.p48),
                  ),
                );
              }

              if (state case BhpIssueStatisticsMissingError(
                :final message,
              ) when data == null) {
                return AppEmptyState.error(
                  title: intl.bhpStatisticsMissingSummaryTitle,
                  message: message,
                );
              }

              if (data == null) {
                return AppEmptyState.noData(
                  title: intl.bhpStatisticsMissingNoDataTitle,
                  message: intl.bhpStatisticsMissingNoDataMessage,
                );
              }

              final rows = _buildRows(data.items);
              return LayoutBuilder(
                builder: (context, constraints) {
                  final useCompactScrollLayout = constraints.maxHeight < 760;

                  final summaryCard = AppSectionCard(
                    title: intl.bhpStatisticsMissingSummaryTitle,
                    subtitle: intl.bhpStatisticsMissingSummarySubtitle,
                    trailing: AppActionPill(
                      label: intl.bhpRefreshAction,
                      icon: Icons.refresh_rounded,
                      tone: .contrast,
                      onPressed: cubit.load,
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [_MissingSummaryGrid(data: data)],
                    ),
                  );

                  final table = AppSimpleTable<_MissingUserRow>(
                    rows: rows,
                    onRowTap: (context, row, sourceIndex) =>
                        showBhpUserIssuesModal(
                          context,
                          user: row.user,
                        ),
                    columns: [
                      AppSimpleTableColumn(
                        label: intl.bhpUsersTitle,
                        width: 220,
                        sortValue: (row) => row.userFullName.toLowerCase(),
                        cellBuilder: (context, row) => Text(row.userFullName),
                      ),
                      AppSimpleTableColumn(
                        label: intl.bhpTablePosition,
                        width: 200,
                        sortValue: (row) => row.stanowiskoNazwa.toLowerCase(),
                        cellBuilder: (context, row) =>
                            Text(row.stanowiskoNazwa),
                      ),
                      AppSimpleTableColumn(
                        label: intl.bhpStatisticsMissingItemsLabel,
                        width: 120,
                        numeric: true,
                        sortValue: (row) => row.missingCount,
                        cellAlignment: .centerRight,
                        cellBuilder: (context, row) =>
                            Text('${row.missingCount}'),
                      ),
                      AppSimpleTableColumn(
                        label: intl.bhpStatisticsMissingTableItemsLabel,
                        width: 420,
                        sortValue: (row) => row.itemsLabel.toLowerCase(),
                        cellBuilder: (context, row) => Text(
                          row.itemsLabel,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppSimpleTableColumn(
                        label: intl.bhpStatisticsMissingTableLatestIssueLabel,
                        width: 140,
                        sortValue: (row) => row.latestIssueClosedAt ?? '',
                        cellBuilder: (context, row) => Text(
                          row.latestIssueClosedAt.toAppDate(
                            placeholder: '—',
                          ),
                        ),
                      ),
                    ],
                    height: useCompactScrollLayout
                        ? _resolveCompactTableHeight(constraints.maxHeight)
                        : null,
                    stateId: 'bhp_issue_statistics_missing_table_v1',
                    persistState: true,
                    simpleExcelMode: true,
                  );

                  final tableCardBody = Column(
                    crossAxisAlignment: .start,
                    children: [
                      if (state is BhpIssueStatisticsMissingLoading) ...[
                        Row(
                          children: [
                            const SizedBox(
                              width: Sizes.p16,
                              height: Sizes.p16,
                              child: AppSpinner(size: Sizes.p16),
                            ),
                            Gaps.w8,
                            Text(
                              intl.bhpStatisticsIssuesComparisonLoading,
                              style: context.text.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                                fontWeight: .w600,
                              ),
                            ),
                          ],
                        ),
                        Gaps.h12,
                      ],
                      if (state case BhpIssueStatisticsMissingError(
                        :final message,
                      )) ...[
                        Text(
                          message,
                          style: context.text.bodySmall?.copyWith(
                            color: context.colors.error,
                            fontWeight: .w600,
                          ),
                        ),
                        Gaps.h12,
                      ],
                      if (rows.isEmpty)
                        AppEmptyState.noData(
                          title: intl.bhpStatisticsMissingNoDataTitle,
                          message: intl.bhpStatisticsMissingNoDataMessage,
                        )
                      else if (useCompactScrollLayout)
                        table
                      else
                        Expanded(child: table),
                    ],
                  );

                  final tableCard = AppSectionCard(
                    title: intl.bhpStatisticsMissingTableTitle,
                    subtitle: intl.bhpStatisticsMissingTableMessage,
                    expandChild: !useCompactScrollLayout,
                    child: tableCardBody,
                  );

                  if (useCompactScrollLayout) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          summaryCard,
                          Gaps.h12,
                          tableCard,
                        ],
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      summaryCard,
                      Gaps.h12,
                      Expanded(child: tableCard),
                    ],
                  );
                },
              );
            },
          ),
    );
  }
}

/// Siatka skróconych KPI dla zakładki braków.
class _MissingSummaryGrid extends StatelessWidget {
  /// Tworzy siatkę podsumowania braków.
  const _MissingSummaryGrid({required this.data});

  /// Dane globalnych braków.
  final GetBhpMissingEquipmentResponseData data;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;

    return Wrap(
      spacing: Sizes.p12,
      runSpacing: Sizes.p12,
      children: [
        _MissingSummaryTile(
          label: intl.bhpStatisticsMissingPeopleLabel,
          value: '${data.usersCount}',
          tooltip: intl.bhpStatisticsMissingPeopleTooltip,
        ),
        _MissingSummaryTile(
          label: intl.bhpStatisticsMissingItemsLabel,
          value: '${data.missingItemsCount}',
          tooltip: intl.bhpStatisticsMissingItemsTooltip,
        ),
        _MissingSummaryTile(
          label: intl.bhpStatisticsMissingTopItemLabel,
          value: data.topMissingCardLabel == null
              ? '—'
              : '${data.topMissingCardLabel} (${data.topMissingCardCount})',
          tooltip: intl.bhpStatisticsMissingTopItemTooltip,
        ),
      ],
    );
  }
}

/// Pojedynczy kafelek podsumowania braków.
class _MissingSummaryTile extends StatelessWidget {
  /// Tworzy kafelek podsumowania.
  const _MissingSummaryTile({
    required this.label,
    required this.value,
    required this.tooltip,
  });

  /// Etykieta KPI.
  final String label;

  /// Wartość KPI.
  final String value;

  /// Objaśnienie dla użytkownika.
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: 220,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: const BorderRadius.all(.circular(Sizes.p12)),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: .45),
          ),
        ),
        child: Padding(
          padding: const .all(Sizes.p12),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: .w700,
                      ),
                    ),
                  ),
                  Gaps.w8,
                  AppTooltip(
                    message: tooltip,
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: Sizes.p16,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Gaps.h8,
              Text(
                value,
                style: context.text.titleLarge?.copyWith(
                  fontWeight: .w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double _resolveCompactTableHeight(double availableHeight) {
  final estimatedHeight = (availableHeight * .58).clamp(320.0, 640.0);
  return estimatedHeight;
}

/// Zagregowany wiersz tabeli braków dla jednego pracownika.
class _MissingUserRow {
  /// Tworzy wiersz tabeli braków.
  const _MissingUserRow({
    required this.user,
    required this.userFullName,
    required this.stanowiskoNazwa,
    required this.missingCount,
    required this.itemsLabel,
    required this.latestIssueClosedAt,
  });

  /// Minimalne dane pracownika potrzebne do otwarcia karty wydań.
  final GetBhpUserListItem user;

  /// Imię i nazwisko pracownika.
  final String userFullName;

  /// Nazwa stanowiska.
  final String stanowiskoNazwa;

  /// Liczba brakujących pozycji.
  final int missingCount;

  /// Lista brakujących elementów.
  final String itemsLabel;

  /// Ostatnia data zamkniętego wydania w obrębie braków.
  final String? latestIssueClosedAt;
}

List<_MissingUserRow> _buildRows(List<GetBhpMissingEquipmentItem> items) {
  final grouped = <int, List<GetBhpMissingEquipmentItem>>{};

  for (final item in items) {
    grouped.putIfAbsent(item.userId, () => []).add(item);
  }

  final rows = grouped.values
      .map((group) {
        final first = group.first;
        final labels =
            group
                .map((item) => item.equipmentLabel)
                .toSet()
                .toList(growable: false)
              ..sort();
        final latestDates =
            group
                .map((item) => item.latestIssueClosedAt)
                .whereType<String>()
                .toList(growable: false)
              ..sort();

        return _MissingUserRow(
          user: GetBhpUserListItem(
            id: first.userId,
            aktywny: true,
            isArchived: false,
            imie: extractBhpEmployeeFirstName(first.userFullName),
            nazwisko: extractBhpEmployeeLastName(first.userFullName),
            stanowiskoId: first.stanowiskoId,
            stanowiskoNazwa: first.stanowiskoNazwa,
          ),
          userFullName: first.formattedUserFullName,
          stanowiskoNazwa: first.stanowiskoNazwa?.trim().isNotEmpty == true
              ? first.stanowiskoNazwa!
              : '—',
          missingCount: group.length,
          itemsLabel: labels.join(', '),
          latestIssueClosedAt: latestDates.isEmpty ? null : latestDates.last,
        );
      })
      .toList(growable: false);

  rows.sort((a, b) => b.missingCount.compareTo(a.missingCount));
  return rows;
}
