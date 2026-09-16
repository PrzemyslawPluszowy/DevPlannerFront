import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan sekcji statystyk wydań BHP.
sealed class BhpIssueStatisticsIssuesState extends Equatable {
  /// Tworzy bazowy stan sekcji wydań.
  const BhpIssueStatisticsIssuesState({
    required this.year,
    this.currentData,
    this.previousYearData,
  });

  /// Aktualnie wybrany rok.
  final int year;

  /// Dane bieżącego roku, jeśli zostały pobrane.
  final GetBhpIssueOperationsResponseData? currentData;

  /// Dane poprzedniego roku, jeśli zostały pobrane.
  final GetBhpIssueOperationsResponseData? previousYearData;

  @override
  List<Object?> get props => [year, currentData, previousYearData];
}

/// Stan początkowy sekcji statystyk wydań.
final class BhpIssueStatisticsIssuesInitial
    extends BhpIssueStatisticsIssuesState {
  /// Tworzy stan początkowy sekcji wydań.
  const BhpIssueStatisticsIssuesInitial({required super.year});
}

/// Stan ładowania porównania roku poprzedniego.
final class BhpIssueStatisticsIssuesLoading
    extends BhpIssueStatisticsIssuesState {
  /// Tworzy stan ładowania sekcji wydań.
  const BhpIssueStatisticsIssuesLoading({
    required super.year,
    super.currentData,
    super.previousYearData,
  });
}

/// Stan gotowości sekcji statystyk wydań.
final class BhpIssueStatisticsIssuesSuccess
    extends BhpIssueStatisticsIssuesState {
  /// Tworzy stan sukcesu sekcji wydań.
  const BhpIssueStatisticsIssuesSuccess({
    required super.year,
    required super.currentData,
    super.previousYearData,
  });
}

/// Stan błędu ładowania porównania roku.
final class BhpIssueStatisticsIssuesError
    extends BhpIssueStatisticsIssuesState {
  /// Tworzy stan błędu sekcji wydań.
  const BhpIssueStatisticsIssuesError({
    required super.year,
    required this.message,
    super.currentData,
    super.previousYearData,
  });

  /// Komunikat błędu.
  final String message;

  @override
  List<Object?> get props => [year, currentData, previousYearData, message];
}
