import 'package:flutter/cupertino.dart';
import 'package:ready_next/core/l10n/l10n_extensions.dart';
import 'package:ready_next/core/theme/theme.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/theme/bhp_chart_colors.dart';
import 'package:ready_next/shared/presentation/widgets/app_section_card.dart';

/// Typy danych do sortowania i prezentacji na wykresie.
enum _ChartSortType {
  /// Wydana ilość.
  quantity,

  /// Liczba operacji.
  operations,
}

/// Pomocnicza struktura danych dla pojedynczego wiersza wykresu.
class BhpTopIssuedItemEntry {
  /// Tworzy wpis dla wykresu wydanych artykułów.
  const BhpTopIssuedItemEntry({
    required this.label,
    required this.quantity,
    required this.operationsCount,
  });

  /// Nazwa wyposażenia.
  final String label;

  /// Wydana ilość.
  final double quantity;

  /// Liczba operacji.
  final int operationsCount;
}

/// Wykres horyzontalny prezentujący najczęściej wydawane artykuły BHP (Top 5).
class BhpTopIssuedItemsChart extends StatefulWidget {
  /// Tworzy wykres Top 5 wydanych artykułów.
  const BhpTopIssuedItemsChart({
    required this.entries,
    super.key,
  });

  /// Lista wszystkich zagregowanych wierszy wyposażenia.
  final List<BhpTopIssuedItemEntry> entries;

  @override
  State<BhpTopIssuedItemsChart> createState() => _BhpTopIssuedItemsChartState();
}

class _BhpTopIssuedItemsChartState extends State<BhpTopIssuedItemsChart> {
  _ChartSortType _sortType = _ChartSortType.quantity;

  @override
  Widget build(BuildContext context) {
    final intl = context.l10n;
    final colors = context.colors;

    if (widget.entries.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sortowanie i wybór top 5 w zależności od typu metryki
    final sortedList = List<BhpTopIssuedItemEntry>.from(widget.entries);
    if (_sortType == _ChartSortType.quantity) {
      sortedList.sort((a, b) => b.quantity.compareTo(a.quantity));
    } else {
      sortedList.sort((a, b) => b.operationsCount.compareTo(a.operationsCount));
    }

    final topEntries = sortedList.take(5).toList();

    // Wyznaczenie maksymalnej wartości w celu ustalenia proporcji barów
    var maxVal = 0.0;
    if (_sortType == _ChartSortType.quantity) {
      maxVal = topEntries.first.quantity;
    } else {
      maxVal = topEntries.first.operationsCount.toDouble();
    }

    if (maxVal == 0) {
      maxVal = 1.0;
    }

    return AppSectionCard(
      padding: const .all(Sizes.p20),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                intl.bhpStatisticsChartStructureEquipmentTitle,
                style: context.text.titleMedium?.copyWith(fontWeight: .w800),
              ),
              CupertinoSlidingSegmentedControl<_ChartSortType>(
                groupValue: _sortType,
                thumbColor: colors.primary,
                backgroundColor: colors.surfaceContainerHighest,
                children: {
                  _ChartSortType.quantity: Padding(
                    padding: const .symmetric(
                      horizontal: Sizes.p12,
                      vertical: Sizes.p8,
                    ),
                    child: Text(
                      intl.bhpStatisticsChartToggleQuantity,
                      style: context.text.bodySmall?.copyWith(
                        fontWeight: .w700,
                        color: _sortType == _ChartSortType.quantity
                            ? colors.onPrimary
                            : colors.onSurface,
                      ),
                    ),
                  ),
                  _ChartSortType.operations: Padding(
                    padding: const .symmetric(
                      horizontal: Sizes.p12,
                      vertical: Sizes.p8,
                    ),
                    child: Text(
                      intl.bhpStatisticsChartToggleCount,
                      style: context.text.bodySmall?.copyWith(
                        fontWeight: .w700,
                        color: _sortType == _ChartSortType.operations
                            ? colors.onPrimary
                            : colors.onSurface,
                      ),
                    ),
                  ),
                },
                onValueChanged: (value) {
                  if (value != null) {
                    setState(() => _sortType = value);
                  }
                },
              ),
            ],
          ),
          Gaps.h24,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: topEntries.length,
            separatorBuilder: (context, index) => Gaps.h16,
            itemBuilder: (context, index) {
              final entry = topEntries[index];
              final value = _sortType == _ChartSortType.quantity
                  ? entry.quantity
                  : entry.operationsCount.toDouble();

              final ratio = (value / maxVal).clamp(0.0, 1.0);

              final valueStr = _sortType == _ChartSortType.quantity
                  ? (entry.quantity == entry.quantity.roundToDouble()
                        ? entry.quantity.toInt().toString()
                        : entry.quantity.toStringAsFixed(1))
                  : entry.operationsCount.toString();

              final suffix = _sortType == _ChartSortType.quantity
                  ? ' szt.'
                  : ' op.';

              final barColor =
                  BhpChartColors.palette[index % BhpChartColors.palette.length];

              return Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    entry.label,
                    style: context.text.bodyMedium?.copyWith(
                      fontWeight: .w700,
                    ),
                  ),
                  Gaps.h8,
                  Row(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: [
                                Container(
                                  height: Sizes.p10,
                                  decoration: BoxDecoration(
                                    color: colors.surfaceContainerHighest,
                                    borderRadius: const BorderRadius.all(
                                      .circular(5.0),
                                    ),
                                  ),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 400),
                                  height: Sizes.p10,
                                  width: constraints.maxWidth * ratio,
                                  decoration: BoxDecoration(
                                    color: barColor,
                                    borderRadius: const BorderRadius.all(
                                      .circular(5.0),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Gaps.w12,
                      SizedBox(
                        width: 70,
                        child: Text(
                          '$valueStr$suffix',
                          style: context.text.bodyMedium?.copyWith(
                            fontWeight: .w800,
                            color: colors.onSurfaceVariant,
                          ),
                          textAlign: .right,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
