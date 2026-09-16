import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/presentation/pages/statistics/comparisons/bhp_issue_statistics_comparisons_models.dart';

/// Stan sekcji porównań statystyk BHP.
sealed class BhpIssueStatisticsComparisonsState extends Equatable {
  const BhpIssueStatisticsComparisonsState({required this.year});

  /// Rok bazowy (Rok X).
  final int year;

  @override
  List<Object?> get props => [year];
}

/// Stan początkowy.
class BhpIssueStatisticsComparisonsInitial extends BhpIssueStatisticsComparisonsState {
  const BhpIssueStatisticsComparisonsInitial({required super.year});
}

/// Trwa ładowanie danych dla 3 lat.
class BhpIssueStatisticsComparisonsLoading extends BhpIssueStatisticsComparisonsState {
  const BhpIssueStatisticsComparisonsLoading({required super.year});
}

/// Dane zostały pomyślnie załadowane.
class BhpIssueStatisticsComparisonsSuccess extends BhpIssueStatisticsComparisonsState {
  const BhpIssueStatisticsComparisonsSuccess({
    required super.year,
    required this.snapshot,
  });

  /// Snapshot z danymi porównawczymi z 3 lat.
  final BhpIssueStatisticsComparisonsSnapshot snapshot;

  @override
  List<Object?> get props => [year, snapshot];
}

/// Wystąpił błąd podczas ładowania danych.
class BhpIssueStatisticsComparisonsError extends BhpIssueStatisticsComparisonsState {
  const BhpIssueStatisticsComparisonsError({
    required super.year,
    required this.message,
  });

  /// Treść błędu.
  final String message;

  @override
  List<Object?> get props => [year, message];
}
