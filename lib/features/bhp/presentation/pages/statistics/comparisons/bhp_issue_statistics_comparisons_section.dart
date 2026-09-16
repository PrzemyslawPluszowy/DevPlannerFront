import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/comparisons/bhp_issue_statistics_comparisons_models.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/comparisons/cubit/bhp_issue_statistics_comparisons_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/comparisons/cubit/bhp_issue_statistics_comparisons_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/comparisons/widgets/bhp_comparisons_chart.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_tooltip.dart';

/// Sekcja porównań 3-letnich (Rok X vs Rok X - 1 vs Rok X - 2).
class BhpIssueStatisticsComparisonsSection extends StatelessWidget {
  /// Tworzy sekcję porównań.
  const BhpIssueStatisticsComparisonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final initialYear = DateTime.now().year;

    return BlocProvider(
      create: (context) {
        final cubit = BhpIssueStatisticsComparisonsCubit(
          repository: context.read<BhpDashboardRepository>(),
          initialYear: initialYear,
        );
        unawaited(cubit.load(initialYear));
        return cubit;
      },
      child:
          BlocBuilder<
            BhpIssueStatisticsComparisonsCubit,
            BhpIssueStatisticsComparisonsState
          >(
            builder: (context, state) {
              final cubit = context.read<BhpIssueStatisticsComparisonsCubit>();

              return Column(
                crossAxisAlignment: .start,
                children: [
                  _ComparisonsYearToolbar(
                    selectedYear: state.year,
                    onYearSelected: cubit.load,
                    onRefresh: () => cubit.load(state.year),
                  ),
                  Gaps.h12,
                  switch (state) {
                    BhpIssueStatisticsComparisonsInitial() ||
                    BhpIssueStatisticsComparisonsLoading() => const Center(
                      child: Padding(
                        padding: .symmetric(vertical: Sizes.p48),
                        child: AppSpinner(size: Sizes.p48),
                      ),
                    ),
                    BhpIssueStatisticsComparisonsError(:final message) =>
                      AppEmptyState.error(
                        title: context
                            .l10n
                            .bhpStatisticsComparisonsPlaceholderTitle,
                        message: message,
                      ),
                    BhpIssueStatisticsComparisonsSuccess(:final snapshot) =>
                      _ComparisonsDashboard(
                        snapshot: snapshot,
                      ),
                  },
                ],
              );
            },
          ),
    );
  }
}

/// Pasek wyboru roku bazowego dla porównań.
class _ComparisonsYearToolbar extends StatelessWidget {
  const _ComparisonsYearToolbar({
    required this.selectedYear,
    required this.onYearSelected,
    required this.onRefresh,
  });

  final int selectedYear;
  final ValueChanged<int> onYearSelected;
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

enum _ComparisonsTableTab {
  metrics,
  products,
  equivalents,
}

/// Główny widok danych porównawczych dla 3 lat.
class _ComparisonsDashboard extends StatefulWidget {
  const _ComparisonsDashboard({required this.snapshot});

  final BhpIssueStatisticsComparisonsSnapshot snapshot;

  @override
  State<_ComparisonsDashboard> createState() => _ComparisonsDashboardState();
}

class _ComparisonsDashboardState extends State<_ComparisonsDashboard> {
  _ComparisonsTableTab _selectedTab = _ComparisonsTableTab.metrics;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.l10n;
    final yearX = widget.snapshot.selectedYearStats.year;
    final yearX1 = widget.snapshot.previousYearStats.year;
    final yearX2 = widget.snapshot.twoYearsBackStats.year;

    // 1. Dane do tabeli głównych wskaźników
    final metricRows = [
      _MetricComparisonRow(
        label: intl.bhpStatisticsIssuesIssuedCountLabel,
        tooltip: intl.bhpStatisticsStructureIssuedCountTooltip,
        valueX: '${widget.snapshot.selectedYearStats.totalIssuedCount}',
        valueX1: '${widget.snapshot.previousYearStats.totalIssuedCount}',
        valueX2: '${widget.snapshot.twoYearsBackStats.totalIssuedCount}',
        numericValueX: widget.snapshot.selectedYearStats.totalIssuedCount
            .toDouble(),
        numericValueX1: widget.snapshot.previousYearStats.totalIssuedCount
            .toDouble(),
        numericValueX2: widget.snapshot.twoYearsBackStats.totalIssuedCount
            .toDouble(),
      ),
      _MetricComparisonRow(
        label: intl.bhpStatisticsIssuesIssuedQuantityLabel,
        tooltip: intl.bhpStatisticsStructureIssuedQuantityTooltip,
        valueX: _formatQuantity(
          widget.snapshot.selectedYearStats.totalIssuedQuantity,
        ),
        valueX1: _formatQuantity(
          widget.snapshot.previousYearStats.totalIssuedQuantity,
        ),
        valueX2: _formatQuantity(
          widget.snapshot.twoYearsBackStats.totalIssuedQuantity,
        ),
        numericValueX: widget.snapshot.selectedYearStats.totalIssuedQuantity,
        numericValueX1: widget.snapshot.previousYearStats.totalIssuedQuantity,
        numericValueX2: widget.snapshot.twoYearsBackStats.totalIssuedQuantity,
      ),
      _MetricComparisonRow(
        label: intl.bhpStatisticsUsersCountLabel,
        tooltip: intl.bhpStatisticsStructureUsersTooltip,
        valueX: '${widget.snapshot.selectedYearStats.distinctUsersCount}',
        valueX1: '${widget.snapshot.previousYearStats.distinctUsersCount}',
        valueX2: '${widget.snapshot.twoYearsBackStats.distinctUsersCount}',
        numericValueX: widget.snapshot.selectedYearStats.distinctUsersCount
            .toDouble(),
        numericValueX1: widget.snapshot.previousYearStats.distinctUsersCount
            .toDouble(),
        numericValueX2: widget.snapshot.twoYearsBackStats.distinctUsersCount
            .toDouble(),
      ),
      _MetricComparisonRow(
        label: intl.bhpStatisticsStructureEquipmentLabel,
        tooltip: intl.bhpStatisticsStructureEquipmentTooltip,
        valueX: '${widget.snapshot.selectedYearStats.distinctEquipmentCount}',
        valueX1: '${widget.snapshot.previousYearStats.distinctEquipmentCount}',
        valueX2: '${widget.snapshot.twoYearsBackStats.distinctEquipmentCount}',
        numericValueX: widget.snapshot.selectedYearStats.distinctEquipmentCount
            .toDouble(),
        numericValueX1: widget.snapshot.previousYearStats.distinctEquipmentCount
            .toDouble(),
        numericValueX2: widget.snapshot.twoYearsBackStats.distinctEquipmentCount
            .toDouble(),
      ),
    ];

    // 2. Dane do tabeli artykułów/produktów
    final allEquipmentKeys = <String>{
      ...widget.snapshot.selectedYearStats.equipmentStats.keys,
      ...widget.snapshot.previousYearStats.equipmentStats.keys,
      ...widget.snapshot.twoYearsBackStats.equipmentStats.keys,
    }.toList()..sort();

    final productRows = allEquipmentKeys.map((key) {
      final statsX = widget.snapshot.selectedYearStats.equipmentStats[key];
      final statsX1 = widget.snapshot.previousYearStats.equipmentStats[key];
      final statsX2 = widget.snapshot.twoYearsBackStats.equipmentStats[key];

      final qtyX = statsX?.quantity ?? 0.0;
      final countX = statsX?.count ?? 0;

      final qtyX1 = statsX1?.quantity ?? 0.0;
      final countX1 = statsX1?.count ?? 0;

      final qtyX2 = statsX2?.quantity ?? 0.0;
      final countX2 = statsX2?.count ?? 0;

      return _ProductComparisonRow(
        label: statsX?.label ?? statsX1?.label ?? statsX2?.label ?? '—',
        quantityX: qtyX,
        quantityX1: qtyX1,
        quantityX2: qtyX2,
        countX: countX,
        countX1: countX1,
        countX2: countX2,
        yearXLabel: '$countX (${_formatQuantity(qtyX)})',
        yearX1Label: '$countX1 (${_formatQuantity(qtyX1)})',
        yearX2Label: '$countX2 (${_formatQuantity(qtyX2)})',
      );
    }).toList();

    productRows.sort((a, b) => b.quantityX.compareTo(a.quantityX));

    // 3. Dane do tabeli ekwiwalentów
    final equivalentSummaryRows = [
      _MetricComparisonRow(
        label: intl.bhpStatisticsComparisonsEquivalentsCountRow,
        tooltip: intl.bhpStatisticsComparisonsEquivalentsCountTooltip,
        valueX: '${widget.snapshot.selectedYearStats.totalEquivalentCount}',
        valueX1: '${widget.snapshot.previousYearStats.totalEquivalentCount}',
        valueX2: '${widget.snapshot.twoYearsBackStats.totalEquivalentCount}',
        numericValueX: widget.snapshot.selectedYearStats.totalEquivalentCount
            .toDouble(),
        numericValueX1: widget.snapshot.previousYearStats.totalEquivalentCount
            .toDouble(),
        numericValueX2: widget.snapshot.twoYearsBackStats.totalEquivalentCount
            .toDouble(),
      ),
      _MetricComparisonRow(
        label: intl.bhpStatisticsComparisonsEquivalentsAmountRow,
        tooltip: intl.bhpStatisticsComparisonsEquivalentsAmountTooltip,
        valueX:
            '${_formatQuantity(widget.snapshot.selectedYearStats.totalEquivalentAmount)} ${intl.bhpCurrencyPln}',
        valueX1:
            '${_formatQuantity(widget.snapshot.previousYearStats.totalEquivalentAmount)} ${intl.bhpCurrencyPln}',
        valueX2:
            '${_formatQuantity(widget.snapshot.twoYearsBackStats.totalEquivalentAmount)} ${intl.bhpCurrencyPln}',
        numericValueX: widget.snapshot.selectedYearStats.totalEquivalentAmount,
        numericValueX1: widget.snapshot.previousYearStats.totalEquivalentAmount,
        numericValueX2: widget.snapshot.twoYearsBackStats.totalEquivalentAmount,
      ),
    ];

    final allEquivalentEquipmentKeys = <String>{
      ...widget.snapshot.selectedYearStats.equivalentStats.keys,
      ...widget.snapshot.previousYearStats.equivalentStats.keys,
      ...widget.snapshot.twoYearsBackStats.equivalentStats.keys,
    }.toList()..sort();

    final equivalentProductRows = allEquivalentEquipmentKeys.map((key) {
      final statsX = widget.snapshot.selectedYearStats.equivalentStats[key];
      final statsX1 = widget.snapshot.previousYearStats.equivalentStats[key];
      final statsX2 = widget.snapshot.twoYearsBackStats.equivalentStats[key];

      final amountX = statsX?.amount ?? 0.0;
      final countX = statsX?.count ?? 0;

      final amountX1 = statsX1?.amount ?? 0.0;
      final countX1 = statsX1?.count ?? 0;

      final amountX2 = statsX2?.amount ?? 0.0;
      final countX2 = statsX2?.count ?? 0;

      return _ProductComparisonRow(
        label: statsX?.label ?? statsX1?.label ?? statsX2?.label ?? '—',
        quantityX: amountX,
        quantityX1: amountX1,
        quantityX2: amountX2,
        countX: countX,
        countX1: countX1,
        countX2: countX2,
        yearXLabel:
            '$countX (${_formatQuantity(amountX)} ${intl.bhpCurrencyPln})',
        yearX1Label:
            '$countX1 (${_formatQuantity(amountX1)} ${intl.bhpCurrencyPln})',
        yearX2Label:
            '$countX2 (${_formatQuantity(amountX2)} ${intl.bhpCurrencyPln})',
      );
    }).toList();

    equivalentProductRows.sort((a, b) => b.quantityX.compareTo(a.quantityX));

    return Column(
      crossAxisAlignment: .start,
      children: [
        AppSectionCard(
          padding: const .all(Sizes.p12),
          child: CupertinoSlidingSegmentedControl<_ComparisonsTableTab>(
            groupValue: _selectedTab,
            thumbColor: colors.primary,
            backgroundColor: colors.surfaceContainerHighest,
            children: {
              _ComparisonsTableTab.metrics: _TabLabel(
                label: intl.bhpStatisticsComparisonsTabMetrics,
                selected: _selectedTab == _ComparisonsTableTab.metrics,
              ),
              _ComparisonsTableTab.products: _TabLabel(
                label: intl.bhpStatisticsComparisonsTabProducts,
                selected: _selectedTab == _ComparisonsTableTab.products,
              ),
              _ComparisonsTableTab.equivalents: _TabLabel(
                label: intl.bhpStatisticsComparisonsTabEquivalents,
                selected: _selectedTab == _ComparisonsTableTab.equivalents,
              ),
            },
            onValueChanged: (value) {
              if (value case final tab?) {
                setState(() => _selectedTab = tab);
              }
            },
          ),
        ),
        Gaps.h12,
        switch (_selectedTab) {
          _ComparisonsTableTab.metrics => AppSectionCard(
            title: intl.bhpStatisticsComparisonsMetricsTitle,
            subtitle: intl.bhpStatisticsComparisonsMetricsSubtitle,
            child: AppSimpleTable<_MetricComparisonRow>(
              rows: metricRows,

              columns: [
                AppSimpleTableColumn(
                  label: intl.bhpStatisticsComparisonsTableColumnMetric,
                  width: 280,
                  sortValue: (row) => row.label.toLowerCase(),
                  cellBuilder: (context, row) => Row(
                    children: [
                      Flexible(
                        child: Text(
                          row.label,
                          style: context.text.bodyMedium?.copyWith(
                            fontWeight: .w600,
                          ),
                        ),
                      ),
                      Gaps.w8,
                      AppTooltip(
                        message: row.tooltip,
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: Sizes.p16,
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                AppSimpleTableColumn(
                  label: intl.bhpStatisticsComparisonsYearLabel(yearX),
                  width: 140,
                  numeric: true,
                  sortValue: (row) => row.numericValueX,
                  cellAlignment: .centerRight,
                  cellBuilder: (context, row) => Text(
                    row.valueX,
                    style: context.text.bodyMedium?.copyWith(
                      fontWeight: .w800,
                    ),
                  ),
                ),
                AppSimpleTableColumn(
                  label: intl.bhpStatisticsComparisonsYearLabel(yearX1),
                  width: 140,
                  numeric: true,
                  sortValue: (row) => row.numericValueX1,
                  cellAlignment: .centerRight,
                  cellBuilder: (context, row) => Text(row.valueX1),
                ),
                AppSimpleTableColumn(
                  label: intl.bhpStatisticsComparisonsYearLabel(yearX2),
                  width: 140,
                  numeric: true,
                  sortValue: (row) => row.numericValueX2,
                  cellAlignment: .centerRight,
                  cellBuilder: (context, row) => Text(row.valueX2),
                ),
              ],
              height: 240,
              stateId: 'bhp_statistics_comparisons_metrics_v1',
              persistState: true,
            ),
          ),
          _ComparisonsTableTab.products => Column(
            crossAxisAlignment: .start,
            children: [
              if (productRows.isNotEmpty) ...[
                BhpComparisonsChart(
                  year: yearX,
                  products: productRows
                      .map(
                        (row) => BhpProductComparisonEntry(
                          label: row.label,
                          quantityX: row.quantityX,
                          quantityX1: row.quantityX1,
                          quantityX2: row.quantityX2,
                          countX: row.countX,
                          countX1: row.countX1,
                          countX2: row.countX2,
                        ),
                      )
                      .toList(),
                ),
                Gaps.h12,
              ],
              AppSectionCard(
                title: intl.bhpStatisticsComparisonsProductsTitle,
                subtitle: intl.bhpStatisticsComparisonsProductsSubtitle,
                child: AppSimpleTable<_ProductComparisonRow>(
                  rows: productRows,
                  columns: [
                    AppSimpleTableColumn(
                      label: intl.bhpStatisticsComparisonsTableColumnProduct,
                      width: 320,
                      sortValue: (row) => row.label.toLowerCase(),
                      cellBuilder: (context, row) => Text(row.label),
                    ),
                    AppSimpleTableColumn(
                      label: intl.bhpStatisticsComparisonsYearLabel(yearX),
                      width: 180,
                      numeric: true,
                      sortValue: (row) => row.quantityX,
                      cellAlignment: .centerRight,
                      cellBuilder: (context, row) => Text(
                        row.yearXLabel,
                        style: context.text.bodyMedium?.copyWith(
                          fontWeight: .w800,
                        ),
                      ),
                    ),
                    AppSimpleTableColumn(
                      label: intl.bhpStatisticsComparisonsYearLabel(yearX1),
                      width: 180,
                      numeric: true,
                      sortValue: (row) => row.quantityX1,
                      cellAlignment: .centerRight,
                      cellBuilder: (context, row) => Text(row.yearX1Label),
                    ),
                    AppSimpleTableColumn(
                      label: intl.bhpStatisticsComparisonsYearLabel(yearX2),
                      width: 180,
                      numeric: true,
                      sortValue: (row) => row.quantityX2,
                      cellAlignment: .centerRight,
                      cellBuilder: (context, row) => Text(row.yearX2Label),
                    ),
                  ],
                  height: 480,
                  stateId: 'bhp_statistics_comparisons_products_v1',
                  persistState: true,
                ),
              ),
            ],
          ),
          _ComparisonsTableTab.equivalents => Column(
            crossAxisAlignment: .start,
            children: [
              AppSectionCard(
                title: intl.bhpStatisticsComparisonsEquivalentsTitle,
                subtitle: intl.bhpStatisticsComparisonsEquivalentsSubtitle,
                child: AppSimpleTable<_MetricComparisonRow>(
                  rows: equivalentSummaryRows,
                  columns: [
                    AppSimpleTableColumn(
                      label: intl.bhpStatisticsComparisonsTableColumnMetric,
                      width: 280,
                      sortValue: (row) => row.label.toLowerCase(),
                      cellBuilder: (context, row) => Row(
                        children: [
                          Flexible(
                            child: Text(
                              row.label,
                              style: context.text.bodyMedium?.copyWith(
                                fontWeight: .w600,
                              ),
                            ),
                          ),
                          Gaps.w8,
                          AppTooltip(
                            message: row.tooltip,
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: Sizes.p16,
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppSimpleTableColumn(
                      label: intl.bhpStatisticsComparisonsYearLabel(yearX),
                      width: 140,
                      numeric: true,
                      sortValue: (row) => row.numericValueX,
                      cellAlignment: .centerRight,
                      cellBuilder: (context, row) => Text(
                        row.valueX,
                        style: context.text.bodyMedium?.copyWith(
                          fontWeight: .w800,
                        ),
                      ),
                    ),
                    AppSimpleTableColumn(
                      label: intl.bhpStatisticsComparisonsYearLabel(yearX1),
                      width: 140,
                      numeric: true,
                      sortValue: (row) => row.numericValueX1,
                      cellAlignment: .centerRight,
                      cellBuilder: (context, row) => Text(row.valueX1),
                    ),
                    AppSimpleTableColumn(
                      label: intl.bhpStatisticsComparisonsYearLabel(yearX2),
                      width: 140,
                      numeric: true,
                      sortValue: (row) => row.numericValueX2,
                      cellAlignment: .centerRight,
                      cellBuilder: (context, row) => Text(row.valueX2),
                    ),
                  ],
                  height: 160,
                  stateId: 'bhp_statistics_comparisons_equivalents_summary_v1',
                  persistState: true,
                ),
              ),
              Gaps.h12,
              AppSectionCard(
                title: intl.bhpStatisticsComparisonsEquivalentsProductsTitle,
                subtitle:
                    intl.bhpStatisticsComparisonsEquivalentsProductsSubtitle,
                child: AppSimpleTable<_ProductComparisonRow>(
                  rows: equivalentProductRows,
                  columns: [
                    AppSimpleTableColumn(
                      label: intl.bhpStatisticsComparisonsTableColumnProduct,
                      width: 320,
                      sortValue: (row) => row.label.toLowerCase(),
                      cellBuilder: (context, row) => Text(row.label),
                    ),
                    AppSimpleTableColumn(
                      label: intl.bhpStatisticsComparisonsYearLabel(yearX),
                      width: 180,
                      numeric: true,
                      sortValue: (row) => row.quantityX,
                      cellAlignment: .centerRight,
                      cellBuilder: (context, row) => Text(
                        row.yearXLabel,
                        style: context.text.bodyMedium?.copyWith(
                          fontWeight: .w800,
                        ),
                      ),
                    ),
                    AppSimpleTableColumn(
                      label: intl.bhpStatisticsComparisonsYearLabel(yearX1),
                      width: 180,
                      numeric: true,
                      sortValue: (row) => row.quantityX1,
                      cellAlignment: .centerRight,
                      cellBuilder: (context, row) => Text(row.yearX1Label),
                    ),
                    AppSimpleTableColumn(
                      label: intl.bhpStatisticsComparisonsYearLabel(yearX2),
                      width: 180,
                      numeric: true,
                      sortValue: (row) => row.quantityX2,
                      cellAlignment: .centerRight,
                      cellBuilder: (context, row) => Text(row.yearX2Label),
                    ),
                  ],
                  height: 400,
                  stateId: 'bhp_statistics_comparisons_equivalents_products_v1',
                  persistState: true,
                ),
              ),
            ],
          ),
        },
      ],
    );
  }
}

/// Etykieta pojedynczego segmentu tabeli porównań.
class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.label,
    required this.selected,
  });

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .symmetric(
        horizontal: Sizes.p16,
        vertical: Sizes.p10,
      ),
      child: Text(
        label,
        style: context.text.labelLarge?.copyWith(
          fontWeight: .w700,
          color: selected ? context.colors.onPrimary : context.colors.onSurface,
        ),
      ),
    );
  }
}

/// Model wiersza tabeli głównych wskaźników.
class _MetricComparisonRow {
  const _MetricComparisonRow({
    required this.label,
    required this.tooltip,
    required this.valueX,
    required this.valueX1,
    required this.valueX2,
    required this.numericValueX,
    required this.numericValueX1,
    required this.numericValueX2,
  });

  final String label;
  final String tooltip;
  final String valueX;
  final String valueX1;
  final String valueX2;
  final double numericValueX;
  final double numericValueX1;
  final double numericValueX2;
}

/// Model wiersza tabeli produktów.
class _ProductComparisonRow {
  const _ProductComparisonRow({
    required this.label,
    required this.quantityX,
    required this.quantityX1,
    required this.quantityX2,
    required this.countX,
    required this.countX1,
    required this.countX2,
    required this.yearXLabel,
    required this.yearX1Label,
    required this.yearX2Label,
  });

  final String label;
  final double quantityX;
  final double quantityX1;
  final double quantityX2;
  final int countX;
  final int countX1;
  final int countX2;
  final String yearXLabel;
  final String yearX1Label;
  final String yearX2Label;
}

String _formatQuantity(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }
  return value.toStringAsFixed(2);
}
