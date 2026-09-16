import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Statystyki roczne wydań dla celów porównawczych.
class BhpIssueYearlyComparisonStats {
  const BhpIssueYearlyComparisonStats({
    required this.year,
    required this.totalIssuedCount,
    required this.totalIssuedQuantity,
    required this.distinctUsersCount,
    required this.distinctEquipmentCount,
    required this.monthlyCounts,
    required this.monthlyQuantities,
    required this.equipmentStats,
    required this.totalEquivalentCount,
    required this.totalEquivalentAmount,
    required this.equivalentStats,
  });

  /// Buduje statystyki roczne na podstawie danych API.
  factory BhpIssueYearlyComparisonStats.fromOperations(
    int year,
    List<GetBhpIssueOperationItem> items,
  ) {
    var totalIssuedCount = 0;
    var totalIssuedQuantity = 0.0;
    final userIds = <int>{};
    final equipmentIds = <int>{};
    final monthlyCounts = List<int>.filled(12, 0);
    final monthlyQuantities = List<double>.filled(12, 0.0);
    final equipmentStats =
        <String, ({String label, int count, double quantity})>{};

    var totalEquivalentCount = 0;
    var totalEquivalentAmount = 0.0;
    final equivalentStats =
        <String, ({String label, int count, double amount})>{};

    for (final item in items) {
      if (item.type == 'equivalent_registered') {
        totalEquivalentCount++;
        final amount = double.tryParse(item.equivalentAmount ?? '') ?? 0.0;
        totalEquivalentAmount += amount;

        final key = _statsKey(item.kartaWyposazeniaId, item.equipmentLabel);
        final current =
            equivalentStats[key] ??
            (label: item.equipmentLabel, count: 0, amount: 0.0);
        equivalentStats[key] = (
          label: current.label,
          count: current.count + 1,
          amount: current.amount + amount,
        );
      }

      if (item.type != 'issued') {
        continue;
      }

      totalIssuedCount++;
      final qty = double.tryParse(item.quantity ?? '') ?? 0.0;
      totalIssuedQuantity += qty;

      userIds.add(item.userId);
      if (item.kartaWyposazeniaId case final id?) {
        equipmentIds.add(id);
      }

      final key = _statsKey(item.kartaWyposazeniaId, item.equipmentLabel);
      final current =
          equipmentStats[key] ??
          (label: item.equipmentLabel, count: 0, quantity: 0.0);
      equipmentStats[key] = (
        label: current.label,
        count: current.count + 1,
        quantity: current.quantity + qty,
      );

      if (item.occurredAtDate case final date?) {
        final monthIdx = date.month - 1;
        if (monthIdx >= 0 && monthIdx < 12) {
          monthlyCounts[monthIdx]++;
          monthlyQuantities[monthIdx] += qty;
        }
      }
    }

    return BhpIssueYearlyComparisonStats(
      year: year,
      totalIssuedCount: totalIssuedCount,
      totalIssuedQuantity: totalIssuedQuantity,
      distinctUsersCount: userIds.length,
      distinctEquipmentCount: equipmentIds.length,
      monthlyCounts: monthlyCounts,
      monthlyQuantities: monthlyQuantities,
      equipmentStats: equipmentStats,
      totalEquivalentCount: totalEquivalentCount,
      totalEquivalentAmount: totalEquivalentAmount,
      equivalentStats: equivalentStats,
    );
  }

  /// Rok.
  final int year;

  /// Łączna liczba wydań.
  final int totalIssuedCount;

  /// Łączna wydana ilość.
  final double totalIssuedQuantity;

  /// Liczba unikalnych pracowników.
  final int distinctUsersCount;

  /// Liczba unikalnych rodzajów wyposażenia.
  final int distinctEquipmentCount;

  /// Liczba wydań w poszczególnych miesiącach (indeks 0 = Styczeń, 11 = Grudzień).
  final List<int> monthlyCounts;

  /// Łączna ilość wydana w poszczególnych miesiącach.
  final List<double> monthlyQuantities;

  /// Statystyki per artykuł BHP (klucz to stabilny identyfikator agregacji).
  final Map<String, ({String label, int count, double quantity})>
  equipmentStats;

  /// Łączna liczba ekwiwalentów.
  final int totalEquivalentCount;

  /// Łączna wypłacona kwota ekwiwalentów (zł).
  final double totalEquivalentAmount;

  /// Statystyki ekwiwalentów per artykuł (klucz to stabilny identyfikator agregacji).
  final Map<String, ({String label, int count, double amount})> equivalentStats;
}

/// Zagregowany snapshot 3 lat do porównania.
class BhpIssueStatisticsComparisonsSnapshot {
  const BhpIssueStatisticsComparisonsSnapshot({
    required this.selectedYearStats,
    required this.previousYearStats,
    required this.twoYearsBackStats,
  });

  /// Dane dla wybranego roku (Rok X).
  final BhpIssueYearlyComparisonStats selectedYearStats;

  /// Dane dla poprzedniego roku (Rok X - 1).
  final BhpIssueYearlyComparisonStats previousYearStats;

  /// Dane sprzed dwóch lat (Rok X - 2).
  final BhpIssueYearlyComparisonStats twoYearsBackStats;
}

String _statsKey(int? id, String label) {
  if (id case final equipmentId?) {
    return 'equipment:$equipmentId';
  }

  return 'equipment:${label.toLowerCase()}';
}
