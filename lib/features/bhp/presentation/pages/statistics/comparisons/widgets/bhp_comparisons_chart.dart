import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/theme/bhp_chart_colors.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';

/// Model danych wejściowych dla wykresu porównania produktów.
class BhpProductComparisonEntry {
  /// Tworzy rekord porównania dla produktu.
  const BhpProductComparisonEntry({
    required this.label,
    required this.quantityX,
    required this.quantityX1,
    required this.quantityX2,
    required this.countX,
    required this.countX1,
    required this.countX2,
  });

  /// Nazwa artykułu BHP.
  final String label;

  /// Wydana ilość w roku X.
  final double quantityX;

  /// Wydana ilość w roku X-1.
  final double quantityX1;

  /// Wydana ilość w roku X-2.
  final double quantityX2;

  /// Liczba wydań w roku X.
  final int countX;

  /// Liczba wydań w roku X-1.
  final int countX1;

  /// Liczba wydań w roku X-2.
  final int countX2;
}

/// Typ metryki wybranej do wizualizacji produktów.
enum _ProductChartMetric {
  /// Wydana ilość (sztuki).
  quantity,

  /// Liczba wydań (operacje).
  count,
}

/// Wykres porównawczy Top 5 produktów na przestrzeni 3 lat.
class BhpComparisonsChart extends StatefulWidget {
  /// Tworzy wykres porównawczy trendów produktów.
  const BhpComparisonsChart({
    required this.year,
    required this.products,
    super.key,
  });

  /// Wybrany rok bazowy (Rok X).
  final int year;

  /// Lista produktów do porównania.
  final List<BhpProductComparisonEntry> products;

  @override
  State<BhpComparisonsChart> createState() => _BhpComparisonsChartState();
}

class _BhpComparisonsChartState extends State<BhpComparisonsChart> {
  _ProductChartMetric _metric = _ProductChartMetric.quantity;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final colors = context.colors;

    if (widget.products.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sortowanie według wybranej metryki w roku bazowym (Rok X) i wybór Top 5
    final sortedProducts = List<BhpProductComparisonEntry>.from(widget.products);
    if (_metric == _ProductChartMetric.quantity) {
      sortedProducts.sort((a, b) => b.quantityX.compareTo(a.quantityX));
    } else {
      sortedProducts.sort((a, b) => b.countX.compareTo(a.countX));
    }

    final topProducts = sortedProducts.take(5).toList();

    // Szukanie maksymalnej wartości do wyskalowania osi Y
    var maxVal = 0.0;
    for (final prod in topProducts) {
      if (_metric == _ProductChartMetric.quantity) {
        if (prod.quantityX > maxVal) maxVal = prod.quantityX;
        if (prod.quantityX1 > maxVal) maxVal = prod.quantityX1;
        if (prod.quantityX2 > maxVal) maxVal = prod.quantityX2;
      } else {
        if (prod.countX > maxVal) maxVal = prod.countX.toDouble();
        if (prod.countX1 > maxVal) maxVal = prod.countX1.toDouble();
        if (prod.countX2 > maxVal) maxVal = prod.countX2.toDouble();
      }
    }

    if (maxVal == 0) {
      maxVal = 10;
    } else {
      maxVal = (maxVal * 1.15).ceilToDouble();
    }

    // Grupy słupków dla Top 5 produktów
    final barGroups = List<BarChartGroupData>.generate(topProducts.length, (index) {
      final prod = topProducts[index];
      final double valX2;
      final double valX1;
      final double valX;

      if (_metric == _ProductChartMetric.quantity) {
        valX2 = prod.quantityX2;
        valX1 = prod.quantityX1;
        valX = prod.quantityX;
      } else {
        valX2 = prod.countX2.toDouble();
        valX1 = prod.countX1.toDouble();
        valX = prod.countX.toDouble();
      }

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: valX2,
            color: BhpChartColors.comparisonYears[0],
            width: Sizes.p8,
            borderRadius: const BorderRadius.only(
              topLeft: .circular(Sizes.p2),
              topRight: .circular(Sizes.p2),
            ),
          ),
          BarChartRodData(
            toY: valX1,
            color: BhpChartColors.comparisonYears[1],
            width: Sizes.p8,
            borderRadius: const BorderRadius.only(
              topLeft: .circular(Sizes.p2),
              topRight: .circular(Sizes.p2),
            ),
          ),
          BarChartRodData(
            toY: valX,
            color: BhpChartColors.comparisonYears[2],
            width: Sizes.p8,
            borderRadius: const BorderRadius.only(
              topLeft: .circular(Sizes.p2),
              topRight: .circular(Sizes.p2),
            ),
          ),
        ],
      );
    });

    final yearX = widget.year;
    final yearX1 = widget.year - 1;
    final yearX2 = widget.year - 2;

    return AppSectionCard(
      padding: const .all(Sizes.p20),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                intl.bhpStatisticsChartComparisonsTitle,
                style: context.text.titleMedium?.copyWith(fontWeight: .w800),
              ),
              CupertinoSlidingSegmentedControl<_ProductChartMetric>(
                groupValue: _metric,
                thumbColor: colors.primary,
                backgroundColor: colors.surfaceContainerHighest,
                children: {
                  _ProductChartMetric.quantity: Padding(
                    padding: const .symmetric(horizontal: Sizes.p12, vertical: Sizes.p8),
                    child: Text(
                      intl.bhpStatisticsChartToggleQuantity,
                      style: context.text.bodySmall?.copyWith(
                        fontWeight: .w700,
                        color: _metric == _ProductChartMetric.quantity
                            ? colors.onPrimary
                            : colors.onSurface,
                      ),
                    ),
                  ),
                  _ProductChartMetric.count: Padding(
                    padding: const .symmetric(horizontal: Sizes.p12, vertical: Sizes.p8),
                    child: Text(
                      intl.bhpStatisticsChartToggleCount,
                      style: context.text.bodySmall?.copyWith(
                        fontWeight: .w700,
                        color: _metric == _ProductChartMetric.count
                            ? colors.onPrimary
                            : colors.onSurface,
                      ),
                    ),
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() => _metric = value);
                  }
                },
              ),
            ],
          ),
          Gaps.h24,
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxVal,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => colors.surfaceContainerHigh,
                    tooltipBorder: BorderSide(
                      color: colors.outlineVariant.withValues(alpha: .3),
                    ),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final prod = topProducts[group.x];
                      final yr = rodIndex == 0 ? yearX2 : (rodIndex == 1 ? yearX1 : yearX);
                      final val = rod.toY == rod.toY.roundToDouble()
                          ? rod.toY.toInt().toString()
                          : rod.toY.toStringAsFixed(1);
                      return BarTooltipItem(
                        '${prod.label}\n$yr: $val',
                        context.text.bodySmall!.copyWith(
                          fontWeight: .w700,
                          color: colors.onSurface,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: Sizes.p40,
                      getTitlesWidget: (value, meta) {
                        if (value == maxVal) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          value.toInt().toString(),
                          style: context.text.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                          textAlign: .right,
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < topProducts.length) {
                          final label = topProducts[idx].label;
                          final shortLabel = label.length > 12 ? '${label.substring(0, 10)}...' : label;
                          return Padding(
                            padding: const .only(top: Sizes.p8),
                            child: Text(
                              shortLabel,
                              style: context.text.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                                fontWeight: .w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                ),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: colors.outlineVariant.withValues(alpha: .2),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: barGroups,
              ),
            ),
          ),
          Gaps.h16,
          // Legenda dla lat
          Row(
            mainAxisAlignment: .center,
            children: [
              _LegendItem(color: BhpChartColors.comparisonYears[0], label: yearX2.toString()),
              Gaps.w16,
              _LegendItem(color: BhpChartColors.comparisonYears[1], label: yearX1.toString()),
              Gaps.w16,
              _LegendItem(color: BhpChartColors.comparisonYears[2], label: yearX.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: Sizes.p12,
          height: Sizes.p12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(.circular(Sizes.p2)),
          ),
        ),
        Gaps.w8,
        Text(
          label,
          style: context.text.bodySmall?.copyWith(
            fontWeight: .w700,
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
