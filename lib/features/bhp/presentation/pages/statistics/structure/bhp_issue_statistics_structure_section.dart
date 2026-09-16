import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/data/repositories/bhp_dashboard_repository.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/structure/bhp_issue_statistics_structure_models.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/structure/cubit/bhp_issue_statistics_structure_cubit.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/structure/cubit/bhp_issue_statistics_structure_state.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/structure/widgets/bhp_top_items_pie_chart.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_chip.dart';
import 'package:ready_next/shared/presentation/widgets/app_action_pill.dart';
import 'package:ready_next/shared/presentation/widgets/app_empty_state.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';
import 'package:ready_next/shared/presentation/widgets/app_simple_table.dart';
import 'package:ready_next/shared/presentation/widgets/app_spinner.dart';
import 'package:ready_next/shared/presentation/widgets/app_tooltip.dart';

/// Sekcja segmentu `Struktura` z lokalnym filtrem roku.
class BhpIssueStatisticsStructureSection extends StatelessWidget {
  /// Tworzy sekcję statystyk struktury.
  const BhpIssueStatisticsStructureSection({super.key});

  @override
  Widget build(BuildContext context) {
    final initialYear = DateTime.now().year;

    return BlocProvider(
      create: (context) {
        final cubit = BhpIssueStatisticsStructureCubit(
          repository: context.read<BhpDashboardRepository>(),
          initialYear: initialYear,
        );
        unawaited(cubit.load(initialYear));
        return cubit;
      },
      child:
          BlocBuilder<
            BhpIssueStatisticsStructureCubit,
            BhpIssueStatisticsStructureState
          >(
            builder: (context, state) {
              final cubit = context.read<BhpIssueStatisticsStructureCubit>();

              return Column(
                crossAxisAlignment: .start,
                children: [
                  _StructureYearToolbar(
                    selectedYear: state.year,
                    onYearSelected: cubit.load,
                    onRefresh: () => cubit.load(state.year),
                  ),
                  Gaps.h12,
                  switch (state) {
                    BhpIssueStatisticsStructureInitial() ||
                    BhpIssueStatisticsStructureLoading() => const Center(
                      child: Padding(
                        padding: .symmetric(vertical: Sizes.p48),
                        child: AppSpinner(size: Sizes.p48),
                      ),
                    ),
                    BhpIssueStatisticsStructureError(:final message) =>
                      AppEmptyState.error(
                        title: context.l10n.bhpStatisticsStructureSummaryTitle,
                        message: message,
                      ),
                    BhpIssueStatisticsStructureSuccess(:final data) =>
                      _StructureStatisticsSheet(
                        snapshot: buildStructureSnapshot(data!.items),
                      ),
                  },
                ],
              );
            },
          ),
    );
  }
}

/// Pasek lokalnych filtrów roku dla sekcji struktury.
class _StructureYearToolbar extends StatelessWidget {
  /// Tworzy pasek roku sekcji struktury.
  const _StructureYearToolbar({
    required this.selectedYear,
    required this.onYearSelected,
    required this.onRefresh,
  });

  /// Wybrany rok.
  final int selectedYear;

  /// Zmiana roku.
  final ValueChanged<int> onYearSelected;

  /// Odświeżenie danych.
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

enum _StructureTableTab {
  positions,
  equipment,
}

/// Arkusz z tabelaryczną strukturą danych operacji.
class _StructureStatisticsSheet extends StatefulWidget {
  /// Tworzy arkusz sekcji struktury.
  const _StructureStatisticsSheet({required this.snapshot});

  /// Snapshot zagregowanych danych.
  final BhpIssueStatisticsStructureSnapshot snapshot;

  @override
  State<_StructureStatisticsSheet> createState() =>
      _StructureStatisticsSheetState();
}

class _StructureStatisticsSheetState extends State<_StructureStatisticsSheet> {
  _StructureTableTab _selectedTab = _StructureTableTab.positions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.l10n;

    return Column(
      crossAxisAlignment: .start,
      children: [
        AppSectionCard(
          title: intl.bhpStatisticsStructureSummaryTitle,
          subtitle: intl.bhpStatisticsStructureSummarySubtitle,
          child: Wrap(
            spacing: Sizes.p12,
            runSpacing: Sizes.p12,
            children: [
              _CompactMetricTile(
                label: intl.bhpStatisticsIssuesIssuedCountLabel,
                value: '${widget.snapshot.totalIssuedCount}',
                tooltip: intl.bhpStatisticsStructureIssuedCountTooltip,
              ),
              _CompactMetricTile(
                label: intl.bhpStatisticsIssuesIssuedQuantityLabel,
                value: _formatQuantity(widget.snapshot.totalIssuedQuantity),
                tooltip: intl.bhpStatisticsStructureIssuedQuantityTooltip,
              ),
              _CompactMetricTile(
                label: intl.bhpStatisticsStructureEquipmentLabel,
                value: '${widget.snapshot.distinctEquipmentCount}',
                tooltip: intl.bhpStatisticsStructureEquipmentTooltip,
              ),
              _CompactMetricTile(
                label: intl.bhpStatisticsUsersCountLabel,
                value: '${widget.snapshot.distinctUsersCount}',
                tooltip: intl.bhpStatisticsStructureUsersTooltip,
              ),
            ],
          ),
        ),
        Gaps.h12,
        AppSectionCard(
          padding: const .all(Sizes.p12),
          child: CupertinoSlidingSegmentedControl<_StructureTableTab>(
            groupValue: _selectedTab,
            thumbColor: colors.primary,
            backgroundColor: colors.surfaceContainerHighest,
            children: {
              _StructureTableTab.positions: _TabLabel(
                label: intl.bhpStatisticsStructurePositionsTitle,
                selected: _selectedTab == _StructureTableTab.positions,
              ),
              _StructureTableTab.equipment: _TabLabel(
                label: intl.bhpStatisticsTopEquipmentTitle,
                selected: _selectedTab == _StructureTableTab.equipment,
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
          _StructureTableTab.positions => Column(
              crossAxisAlignment: .start,
              children: [
                if (widget.snapshot.positionRows.isNotEmpty) ...[
                  BhpTopItemsPieChart(
                    title: intl.bhpStatisticsChartStructurePositionsTitle,
                    entries: widget.snapshot.positionRows
                        .map((row) => BhpPieChartEntry(
                              label: row.label,
                              value: row.issuedQuantity,
                            ))
                        .toList(),
                    valueSuffix: 'szt.',
                  ),
                  Gaps.h12,
                ],
                _TableCard<BhpIssueStatisticsPositionRow>(
                  title: intl.bhpStatisticsStructurePositionsTitle,
                  subtitle: intl.bhpStatisticsStructurePositionsSubtitle,
                  rows: widget.snapshot.positionRows,
                  height: _tableHeight(
                    widget.snapshot.positionRows.length,
                    min: 360,
                    max: 720,
                  ),
                  stateId: 'bhp_issue_statistics_structure_positions_v1',
                  columns: _countAndQuantityColumns<BhpIssueStatisticsPositionRow>(
                    context,
                    nameLabel: intl.bhpTablePosition,
                    nameWidth: 320,
                    nameValue: (row) => row.label,
                    issuedCount: (row) => row.issuedCount,
                    issuedQuantity: (row) => row.issuedQuantity,
                  ),
                ),
              ],
            ),
          _StructureTableTab.equipment => Column(
              crossAxisAlignment: .start,
              children: [
                if (widget.snapshot.equipmentRows.isNotEmpty) ...[
                  BhpTopItemsPieChart(
                    title: intl.bhpStatisticsChartStructureEquipmentTitle,
                    entries: widget.snapshot.equipmentRows
                        .map((row) => BhpPieChartEntry(
                              label: row.label,
                              value: row.issuedQuantity,
                            ))
                        .toList(),
                    valueSuffix: 'szt.',
                  ),
                  Gaps.h12,
                ],
                _TableCard<BhpIssueStatisticsEquipmentRow>(
                  title: intl.bhpStatisticsTopEquipmentTitle,
                  subtitle: intl.bhpStatisticsStructureEquipmentSubtitle,
                  rows: widget.snapshot.equipmentRows,
                  height: _tableHeight(widget.snapshot.equipmentRows.length),
                  stateId: 'bhp_issue_statistics_structure_equipment_v1',
                  columns: _countAndQuantityColumns<BhpIssueStatisticsEquipmentRow>(
                    context,
                    nameLabel: intl.bhpTableEquipmentName,
                    nameWidth: 420,
                    nameValue: (row) => row.label,
                    issuedCount: (row) => row.issuedCount,
                    issuedQuantity: (row) => row.issuedQuantity,
                  ),
                ),
              ],
            ),
        },
      ],
    );
  }
}

/// Etykieta pojedynczego segmentu tabeli struktury.
class _TabLabel extends StatelessWidget {
  /// Tworzy etykietę segmentu.
  const _TabLabel({
    required this.label,
    required this.selected,
  });

  /// Tekst etykiety.
  final String label;

  /// Czy segment jest aktywny.
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

/// Karta tabelaryczna sekcji struktury.
class _TableCard<T> extends StatelessWidget {
  /// Tworzy kartę z tabelą.
  const _TableCard({
    required this.title,
    required this.subtitle,
    required this.rows,
    required this.columns,
    required this.height,
    required this.stateId,
    this.onRowTap,
  });

  /// Tytuł sekcji.
  final String title;

  /// Opis sekcji.
  final String subtitle;

  /// Wiersze tabeli.
  final List<T> rows;

  /// Kolumny tabeli.
  final List<AppSimpleTableColumn<T>> columns;

  /// Wysokość tabeli.
  final double height;

  /// Id stanu tabeli.
  final String stateId;

  /// Obsługa kliknięcia w wiersz.
  final AppSimpleTableRowTap<T>? onRowTap;

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      title: title,
      subtitle: subtitle,
      child: rows.isEmpty
          ? AppEmptyState.noData(
              title: context.l10n.bhpStatisticsIssuesNoDataTitle,
              message: context.l10n.bhpStatisticsIssuesNoDataMessage,
            )
          : AppSimpleTable<T>(
              rows: rows,
              columns: columns,
              height: height,
              onRowTap: onRowTap,
              stateId: stateId,
              persistState: true,
              simpleExcelMode: true,
            ),
    );
  }
}

/// Kompaktowy kafelek metryki sekcji struktury.
class _CompactMetricTile extends StatelessWidget {
  /// Tworzy kafelek metryki.
  const _CompactMetricTile({
    required this.label,
    required this.value,
    this.tooltip,
  });

  /// Etykieta metryki.
  final String label;

  /// Wartość metryki.
  final String value;

  /// Opcjonalny opis pomocniczy (tooltip).
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: 240,
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
                  if (tooltip != null) ...[
                    Gaps.w8,
                    AppTooltip(
                      message: tooltip!,
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: Sizes.p16,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
              Gaps.h8,
              Text(
                value,
                style: context.text.titleLarge?.copyWith(fontWeight: .w800),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<AppSimpleTableColumn<T>> _countAndQuantityColumns<T>(
  BuildContext context, {
  required String nameLabel,
  required double nameWidth,
  required String Function(T row) nameValue,
  required int Function(T row) issuedCount,
  required double Function(T row) issuedQuantity,
}) {
  final intl = context.l10n;

  return [
    AppSimpleTableColumn(
      label: nameLabel,
      width: nameWidth,
      sortValue: (row) => nameValue(row).toLowerCase(),
      cellBuilder: (context, row) => Text(nameValue(row)),
    ),
    AppSimpleTableColumn(
      label: intl.bhpStatisticsIssuesIssuedCountLabel,
      width: 140,
      numeric: true,
      sortValue: issuedCount,
      cellAlignment: .centerRight,
      tooltip: intl.bhpStatisticsStructureIssuedCountTooltip,
      cellBuilder: (context, row) => Text('${issuedCount(row)}'),
    ),
    AppSimpleTableColumn(
      label: intl.bhpStatisticsIssuesIssuedQuantityLabel,
      width: 160,
      numeric: true,
      sortValue: issuedQuantity,
      cellAlignment: .centerRight,
      tooltip: intl.bhpStatisticsStructureIssuedQuantityTooltip,
      cellBuilder: (context, row) => Text(_formatQuantity(issuedQuantity(row))),
    ),
  ];
}

double _tableHeight(
  int rowCount, {
  double min = 320,
  double max = 620,
}) {
  const headerHeight = 44.0;
  const rowHeight = 44.0;
  const verticalPadding = 24.0;
  final estimatedHeight =
      headerHeight + (rowCount * rowHeight) + verticalPadding;

  return estimatedHeight.clamp(min, max);
}

String _formatQuantity(double value) {
  if (value == value.roundToDouble()) {
    return value.toInt().toString();
  }

  return value.toStringAsFixed(2);
}
