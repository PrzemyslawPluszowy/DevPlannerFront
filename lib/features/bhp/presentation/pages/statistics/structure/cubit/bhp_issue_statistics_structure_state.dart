import 'package:equatable/equatable.dart';
import 'package:ready_next/features/bhp/data/models/endpoints/endpoints.dart';

/// Bazowy stan sekcji statystyk struktury BHP.
sealed class BhpIssueStatisticsStructureState extends Equatable {
  /// Tworzy bazowy stan sekcji struktury.
  const BhpIssueStatisticsStructureState({
    required this.year,
    this.data,
  });

  /// Aktualnie wybrany rok.
  final int year;

  /// Dane operacji dla wybranego roku.
  final GetBhpIssueOperationsResponseData? data;

  @override
  List<Object?> get props => [year, data];
}

/// Stan początkowy sekcji struktury.
final class BhpIssueStatisticsStructureInitial
    extends BhpIssueStatisticsStructureState {
  /// Tworzy stan początkowy sekcji struktury.
  const BhpIssueStatisticsStructureInitial({required super.year});
}

/// Stan ładowania sekcji struktury.
final class BhpIssueStatisticsStructureLoading
    extends BhpIssueStatisticsStructureState {
  /// Tworzy stan ładowania sekcji struktury.
  const BhpIssueStatisticsStructureLoading({
    required super.year,
    super.data,
  });
}

/// Stan sukcesu sekcji struktury.
final class BhpIssueStatisticsStructureSuccess
    extends BhpIssueStatisticsStructureState {
  /// Tworzy stan sukcesu sekcji struktury.
  const BhpIssueStatisticsStructureSuccess({
    required super.year,
    required super.data,
  });
}

/// Stan błędu sekcji struktury.
final class BhpIssueStatisticsStructureError
    extends BhpIssueStatisticsStructureState {
  /// Tworzy stan błędu sekcji struktury.
  const BhpIssueStatisticsStructureError({
    required super.year,
    required this.message,
    super.data,
  });

  /// Komunikat błędu.
  final String message;

  @override
  List<Object?> get props => [year, data, message];
}
