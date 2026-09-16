import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/theme/bhp_chart_colors.dart';

/// Pojedyncza pozycja danych na wykresie kołowym.
class BhpPieChartEntry {
  /// Tworzy wpis wykresu kołowego.
  const BhpPieChartEntry({
    required this.label,
    required this.value,
  });

  /// Etykieta (np. nazwa artykułu lub stanowiska).
  final String label;

  /// Wartość (np. ilość sztuk lub liczba wydań).
  final double value;
}

/// Wykres kołowy prezentujący udział procentowy Top 5 elementów.
class BhpTopItemsPieChart extends StatelessWidget {
  /// Tworzy wykres kołowy dla przekazanych danych.
  const BhpTopItemsPieChart({
    required this.title,
    required this.entries,
    required this.valueSuffix,
    super.key,
  });

  /// Tytuł wykresu.
  final String title;

  /// Dane do wyświetlenia na wykresie.
  final List<BhpPieChartEntry> entries;

  /// Sufiks wartości (np. "szt.", "operacji").
  final String valueSuffix;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sortowanie malejąco
    final sortedEntries = List<BhpPieChartEntry>.from(entries)
      ..sort((a, b) => b.value.compareTo(a.value));

    // Podział na Top 5 i Pozostałe
    final topEntries = sortedEntries.take(5).toList();
    final remainingValue = sortedEntries
        .skip(5)
        .fold(0.0, (sum, entry) => sum + entry.value);

    if (remainingValue > 0) {
      topEntries.add(
        BhpPieChartEntry(
          label: 'Pozostałe',
          value: remainingValue,
        ),
      );
    }

    final total = topEntries.fold(0.0, (sum, entry) => sum + entry.value);

    // Paleta kolorów dla wykresu
    const baseColors = BhpChartColors.palette;

    final chartSections = List<PieChartSectionData>.generate(
      topEntries.length,
      (index) {
        final entry = topEntries[index];
        final percentage = total > 0 ? (entry.value / total) * 100 : 0.0;
        final color = baseColors[index % baseColors.length];

        return PieChartSectionData(
          color: color,
          value: entry.value,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 50.0,
          titleStyle: context.text.labelSmall?.copyWith(
            fontWeight: .w800,
            color: colors.onPrimary,
          ),
        );
      },
    );

    return Card(
      color: colors.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(.circular(Sizes.p16)),
        side: BorderSide(
          color: colors.outlineVariant.withValues(alpha: .35),
        ),
      ),
      child: Padding(
        padding: const .all(Sizes.p20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              title,
              style: context.text.titleMedium?.copyWith(fontWeight: .w800),
            ),
            Gaps.h20,
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 500;

                final chartWidget = SizedBox(
                  height: 180,
                  width: 180,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: Sizes.p32,
                      sections: chartSections,
                    ),
                  ),
                );

                final legendWidget = Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: List.generate(topEntries.length, (index) {
                    final entry = topEntries[index];
                    final color = baseColors[index % baseColors.length];
                    final valStr = entry.value == entry.value.roundToDouble()
                        ? entry.value.toInt().toString()
                        : entry.value.toStringAsFixed(1);

                    return Padding(
                      padding: const .symmetric(vertical: Sizes.p4),
                      child: Row(
                        children: [
                          Container(
                            width: Sizes.p12,
                            height: Sizes.p12,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Gaps.w8,
                          Expanded(
                            child: Text(
                              entry.label,
                              style: context.text.bodySmall?.copyWith(
                                fontWeight: .w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Gaps.w8,
                          Text(
                            '$valStr $valueSuffix',
                            style: context.text.bodySmall?.copyWith(
                              fontWeight: .w700,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                );

                if (isWide) {
                  return Row(
                    children: [
                      chartWidget,
                      Gaps.w32,
                      Expanded(child: legendWidget),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Center(child: chartWidget),
                      Gaps.h20,
                      legendWidget,
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
