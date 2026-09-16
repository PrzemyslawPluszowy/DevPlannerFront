import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/issues/cubit/bhp_issue_statistics_issues_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/issues/cubit/bhp_issue_statistics_issues_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/issues/widgets/bhp_top_issued_items_chart.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_tooltip.dart';

/// Sekcja segmentu `Wydania` z własnym filtrem roku i cubitem.
class BhpIssueStatisticsIssuesSection extends StatelessWidget {
  /// Tworzy sekcję statystyk wydań.
  const BhpIssueStatisticsIssuesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final initialYear = DateTime.now().year;

    return BlocProvider(
      create: (context) {
        final cubit = BhpIssueStatisticsIssuesCubit(
          repository: context.read<BhpDashboardRepository>(),
          initialYear: initialYear,
        );
        unawaited(cubit.load(initialYear));
        return cubit;
      },
      child:
          BlocBuilder<
            BhpIssueStatisticsIssuesCubit,
            BhpIssueStatisticsIssuesState
          >(
            builder: (context, state) {
              final cubit = context.read<BhpIssueStatisticsIssuesCubit>();

              return Column(
                crossAxisAlignment: .start,
                children: [
                  _IssuesYearToolbar(
                    selectedYear: state.year,
                    onYearSelected: cubit.load,
                    onRefresh: () => cubit.load(state.year),
                  ),
                  Gaps.h12,
                  switch (state) {
                    BhpIssueStatisticsIssuesInitial() ||
                    BhpIssueStatisticsIssuesLoading() => const Center(
                      child: Padding(
                        padding: .symmetric(vertical: Sizes.p48),
                        child: AppSpinner(size: Sizes.p48),
                      ),
                    ),
                    BhpIssueStatisticsIssuesError(:final message) =>
                      AppEmptyState.error(
                        title: context.l10n.bhpStatisticsIssuesSummaryTitle,
                        message: message,
                      ),
                    BhpIssueStatisticsIssuesSuccess(
                      :final currentData,
                      :final previousYearData,
                    ) =>
                      _IssuesStatisticsSheet(
                        currentData: currentData!,
                        previousYearData: previousYearData,
                        isComparisonLoading: false,
                      ),
                  },
                ],
              );
            },
          ),
    );
  }
}

/// Pasek lokalnych filtrów roku dla sekcji wydań.
class _IssuesYearToolbar extends StatelessWidget {
  /// Tworzy pasek filtrów roku.
  const _IssuesYearToolbar({
    required this.selectedYear,
    required this.onYearSelected,
    required this.onRefresh,
  });

  /// Aktualnie wybrany rok.
  final int selectedYear;

  /// Obsługa zmiany roku.
  final ValueChanged<int> onYearSelected;

  /// Odświeżenie aktywnego roku.
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final years = List<int>.generate(5, (index) => DateTime.now().year - index);

    return AppSectionCard(
      padding: const .all(Sizes.p12),
      child: Wrap(
        spacing: Sizes.p8,
        runSpacing: Sizes.p8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final year in years)
            AppActionChip(
              label: year.toString(),
              icon: Icons.calendar_month_rounded,
              selected: selectedYear == year,
              tone: .primary,
              onPressed: () => onYearSelected(year),
            ),
          AppActionPill(
            label: intl.bhpRefreshAction,
            icon: Icons.refresh_rounded,
            tone: .contrast,
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}

/// Tabelaryczne zestawienie statystyk wydań.
class _IssuesStatisticsSheet extends StatelessWidget {
  /// Tworzy zestawienie statystyk wydań.
  const _IssuesStatisticsSheet({
    required this.currentData,
    required this.previousYearData,
    required this.isComparisonLoading,
  });

  /// Dane bieżącego roku.
  final GetBhpIssueOperationsResponseData currentData;

  /// Dane poprzedniego roku.
  final GetBhpIssueOperationsResponseData? previousYearData;

  /// Czy trwa ładowanie porównania.
  final bool isComparisonLoading;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.l10n;
    final currentSummary = _buildSummary(currentData.items);
    final previousSummary = previousYearData == null
        ? null
        : _buildSummary(previousYearData!.items);
    final equipmentRows = _buildEquipmentRows(currentData.items);

    return Column(
      crossAxisAlignment: .start,
      children: [
        if (equipmentRows.isNotEmpty) ...[
          BhpTopIssuedItemsChart(
            entries: equipmentRows
                .map((row) => BhpTopIssuedItemEntry(
                      label: row.label,
                      quantity: row.totalQuantity,
                      operationsCount: row.operationsCount,
                    ))
                .toList(),
          ),
          Gaps.h12,
        ],
        AppSectionCard(
          padding: const .all(Sizes.p20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                intl.bhpStatisticsIssuesSummaryTitle,
                style: context.text.titleMedium?.copyWith(fontWeight: .w800),
              ),
              Gaps.h8,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      intl.bhpStatisticsIssuesSummarySubtitle,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (isComparisonLoading) ...[
                    Gaps.w8,
                    Text(
                      intl.bhpStatisticsIssuesComparisonLoading,
                      style: context.text.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontWeight: .w600,
                      ),
                    ),
                  ],
                ],
              ),
              Gaps.h16,
              _StatisticsRow(
                label: intl.bhpStatisticsOperationsCountLabel,
                tooltip: intl.bhpStatisticsIssuesOperationsTooltip,
                currentValue: '${currentSummary.operationsCount}',
                previousValue: previousSummary?.operationsCount.toString(),
                isComparisonLoading: isComparisonLoading,
              ),
              _StatisticsRow(
                label: intl.bhpStatisticsIssuesIssuedQuantityLabel,
                tooltip: intl.bhpStatisticsIssuesIssuedQuantityTooltip,
                currentValue: _formatQuantity(
                  currentSummary.totalIssuedQuantity,
                ),
                previousValue: previousSummary == null
                    ? null
                    : _formatQuantity(previousSummary.totalIssuedQuantity),
                isComparisonLoading: isComparisonLoading,
              ),
              _StatisticsRow(
                label: intl.bhpStatisticsIssuesIssuedCountLabel,
                tooltip: intl.bhpStatisticsIssuesIssuedCountTooltip,
                currentValue: '${currentSummary.issuedCount}',
                previousValue: previousSummary?.issuedCount.toString(),
                isComparisonLoading: isComparisonLoading,
              ),
              _StatisticsRow(
                label: intl.bhpStatisticsIssuesClosedCountLabel,
                tooltip: intl.bhpStatisticsIssuesClosedCountTooltip,
                currentValue: '${currentSummary.closedCount}',
                previousValue: previousSummary?.closedCount.toString(),
                isComparisonLoading: isComparisonLoading,
              ),
              _StatisticsRow(
                label: intl.bhpStatisticsIssuesEquivalentCountLabel,
                tooltip: intl.bhpStatisticsIssuesEquivalentCountTooltip,
                currentValue: '${currentSummary.equivalentCount}',
                previousValue: previousSummary?.equivalentCount.toString(),
                isComparisonLoading: isComparisonLoading,
                showDivider: false,
              ),
            ],
          ),
        ),
        Gaps.h12,
        AppSectionCard(
          padding: const .all(Sizes.p20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                intl.bhpStatisticsIssuesTableTitle,
                style: context.text.titleMedium?.copyWith(fontWeight: .w800),
              ),
              Gaps.h8,
              Text(
                intl.bhpStatisticsIssuesTableSubtitle,
                style: context.text.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              Gaps.h16,
              if (equipmentRows.isEmpty)
                AppEmptyState.noData(
                  title: intl.bhpStatisticsIssuesNoDataTitle,
                  message: intl.bhpStatisticsIssuesNoDataMessage,
                )
              else
                AppSimpleTable<_EquipmentStatisticsRowData>(
                  rows: equipmentRows,
                  columns: [
                    AppSimpleTableColumn(
                      label: intl.bhpTableEquipmentName,
                      width: 420,
                      sortValue: (row) => row.label.toLowerCase(),
                      cellBuilder: (context, row) => Text(row.label),
                    ),
                    AppSimpleTableColumn(
                      label: intl.bhpTableQuantity,
                      width: 120,
                      numeric: true,
                      sortValue: (row) => row.totalQuantity,
                      cellAlignment: .centerRight,
                      cellBuilder: (context, row) =>
                          Text(_formatQuantity(row.totalQuantity)),
                    ),
                    AppSimpleTableColumn(
                      label: intl.bhpStatisticsOperationsCountLabel,
                      width: 120,
                      numeric: true,
                      sortValue: (row) => row.operationsCount,
                      cellAlignment: .centerRight,
                      cellBuilder: (context, row) =>
                          Text('${row.operationsCount}'),
                    ),
                  ],
                  height: 420,
                  stateId: 'bhp_issue_statistics_issues_table_v1',
                  persistState: true,
                  simpleExcelMode: true,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Wiersz tabelarycznej statystyki.
class _StatisticsRow extends StatelessWidget {
  /// Tworzy wiersz statystyki.
  const _StatisticsRow({
    required this.label,
    required this.tooltip,
    required this.currentValue,
    required this.previousValue,
    required this.isComparisonLoading,
    this.showDivider = true,
  });

  /// Etykieta.
  final String label;

  /// Tooltip.
  final String tooltip;

  /// Wartość bieżącego roku.
  final String currentValue;

  /// Wartość poprzedniego roku.
  final String? previousValue;

  /// Czy trwa ładowanie porównania.
  final bool isComparisonLoading;

  /// Czy pokazać separator.
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final comparisonText = switch ((isComparisonLoading, previousValue)) {
      (true, _) => '(...)',
      (_, final value?) => '($value)',
      _ => '(-)',
    };

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatisticsLabel(
                label: label,
                tooltip: tooltip,
              ),
            ),
            Gaps.w12,
            Text(
              '$currentValue $comparisonText',
              style: context.text.titleSmall?.copyWith(fontWeight: .w800),
            ),
          ],
        ),
        if (showDivider) ...[
          Gaps.h12,
          Divider(
            color: colors.outlineVariant.withValues(alpha: .45),
            height: 1,
          ),
          Gaps.h12,
        ],
      ],
    );
  }
}

/// Etykieta statystyki z tooltipem.
class _StatisticsLabel extends StatelessWidget {
  /// Tworzy etykietę z tooltipem.
  const _StatisticsLabel({
    required this.label,
    required this.tooltip,
  });

  /// Tekst etykiety.
  final String label;

  /// Treść tooltipa.
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Flexible(
          child: Text(
            label,
            style: context.text.bodyMedium?.copyWith(fontWeight: .w600),
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
    );
  }
}

/// Dane jednego wiersza tabeli wydań.
class _EquipmentStatisticsRowData {
  /// Tworzy wiersz tabeli wydań.
  const _EquipmentStatisticsRowData({
    required this.label,
    required this.totalQuantity,
    required this.operationsCount,
  });

  /// Nazwa rzeczy.
  final String label;

  /// Łączna wydana ilość.
  final double totalQuantity;

  /// Liczba operacji.
  final int operationsCount;
}

/// Zagregowane podsumowanie roku.
class _IssueYearSummary {
  /// Tworzy podsumowanie roku.
  const _IssueYearSummary({
    required this.operationsCount,
    required this.totalIssuedQuantity,
    required this.issuedCount,
    required this.closedCount,
    required this.equivalentCount,
  });

  /// Liczba wszystkich operacji.
  final int operationsCount;

  /// Łączna ilość tylko z wydań.
  final double totalIssuedQuantity;

  /// Liczba wydań.
  final int issuedCount;

  /// Liczba zamknięć.
  final int closedCount;

  /// Liczba ekwiwalentów.
  final int equivalentCount;
}

_IssueYearSummary _buildSummary(List<GetBhpIssueOperationItem> items) {
  var issuedQuantity = 0.0;
  var issuedCount = 0;
  var closedCount = 0;
  var equivalentCount = 0;

  for (final item in items) {
    switch (item.type) {
      case 'issued':
        issuedCount++;
        issuedQuantity += double.tryParse(item.quantity ?? '') ?? 0;
      case 'closed':
        closedCount++;
      case 'equivalent_registered':
        equivalentCount++;
      default:
        break;
    }
  }

  return _IssueYearSummary(
    operationsCount: items.length,
    totalIssuedQuantity: issuedQuantity,
    issuedCount: issuedCount,
    closedCount: closedCount,
    equivalentCount: equivalentCount,
  );
}

List<_EquipmentStatisticsRowData> _buildEquipmentRows(
  List<GetBhpIssueOperationItem> items,
) {
  final grouped = <String, ({double quantity, int operations})>{};

  for (final item in items) {
    if (item.type != 'issued') {
      continue;
    }

    final label = item.equipmentLabel;
    final current = grouped[label] ?? (quantity: 0, operations: 0);
    grouped[label] = (
      quantity: current.quantity + (double.tryParse(item.quantity ?? '') ?? 0),
      operations: current.operations + 1,
    );
  }

  final sorted = grouped.entries.toList()
    ..sort((left, right) {
      final quantityOrder = right.value.quantity.compareTo(left.value.quantity);
      if (quantityOrder != 0) {
        return quantityOrder;
      }
      return right.value.operations.compareTo(left.value.operations);
    });

  return [
    for (final entry in sorted)
      _EquipmentStatisticsRowData(
        label: entry.key,
        totalQuantity: entry.value.quantity,
        operationsCount: entry.value.operations,
      ),
  ];
}

String _formatQuantity(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toStringAsFixed(2).replaceAll('.', ',');
}
